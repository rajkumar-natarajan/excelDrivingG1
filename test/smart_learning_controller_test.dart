import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:excel_driving_g1/controllers/smart_learning_controller.dart';
import 'package:excel_driving_g1/models/question.dart' hide PerformanceStats, TestSessionRecord, TrendPoint, TimeStats;

// Helper to build a minimal Question
Question _q(String id, String subType) => Question(
  id: id,
  stem: 'Q $id',
  options: ['A', 'B', 'C', 'D'],
  correctAnswer: 0,
  explanation: 'Answer is A.',
  type: QuestionType.rulesOfRoad,
  subType: subType,
);

UserAnswer _ans(String qId, {bool correct = true}) => UserAnswer(
  questionId: qId,
  selectedOption: correct ? 0 : 1,
  isCorrect: correct,
  timeTaken: const Duration(seconds: 5),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SmartLearningController controller;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    controller = SmartLearningController();
    await controller.clearAllData();
    controller = SmartLearningController();
    await controller.initialize();
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────
  group('SmartLearningController - Initialization', () {
    test('starts with empty stats', () {
      expect(controller.allStats, isEmpty);
    });

    test('starts with 0 bookmarks', () {
      expect(controller.bookmarkCount, equals(0));
    });

    test('starts with 0 mastered questions', () {
      expect(controller.masteredCount, equals(0));
    });

    test('starts with empty test history', () {
      expect(controller.testHistory, isEmpty);
    });

    test('starts with empty time stats', () {
      expect(controller.allTimeStats, isEmpty);
    });

    test('starts with reviewCount = 0', () {
      expect(controller.reviewCount, equals(0));
    });

    test('calling initialize twice is idempotent', () async {
      await controller.initialize();
      expect(controller.allStats, isEmpty);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // recordAnswer — performance stats
  // ─────────────────────────────────────────────────────────────────────────
  group('SmartLearningController - recordAnswer', () {
    test('creates stats entry for new subType', () {
      controller.recordAnswer(_q('q1', 'speed'), true);
      expect(controller.allStats.containsKey('speed'), isTrue);
    });

    test('increments totalAttempts on each call', () {
      controller.recordAnswer(_q('q1', 'speed'), true);
      controller.recordAnswer(_q('q2', 'speed'), false);
      expect(controller.allStats['speed']!.totalAttempts, equals(2));
    });

    test('increments correctAttempts only for correct answers', () {
      controller.recordAnswer(_q('q1', 'speed'), true);
      controller.recordAnswer(_q('q2', 'speed'), false);
      controller.recordAnswer(_q('q3', 'speed'), true);
      expect(controller.allStats['speed']!.correctAttempts, equals(2));
    });

    test('tracks time stats when timeSpentSeconds provided', () {
      controller.recordAnswer(_q('q1', 'speed'), true, timeSpentSeconds: 15);
      expect(controller.allTimeStats.containsKey('speed'), isTrue);
    });

    test('omitting timeSpentSeconds does not create time stats entry', () {
      controller.recordAnswer(_q('q1', 'speed'), true);
      expect(controller.allTimeStats.containsKey('speed'), isFalse);
    });

    test('time stats averageTime computed correctly', () {
      controller.recordAnswer(_q('q1', 'speed'), true, timeSpentSeconds: 10);
      controller.recordAnswer(_q('q2', 'speed'), false, timeSpentSeconds: 30);
      expect(controller.allTimeStats['speed']!.averageTime, equals(20.0));
    });

    test('separate subTypes get independent stats', () {
      controller.recordAnswer(_q('a1', 'alpha'), true);
      controller.recordAnswer(_q('b1', 'beta'), false);
      expect(controller.allStats['alpha']!.correctAttempts, equals(1));
      expect(controller.allStats['beta']!.correctAttempts, equals(0));
    });

    test('accuracy is 100% when all answers correct', () {
      for (var i = 0; i < 5; i++) {
        controller.recordAnswer(_q('q$i', 'signs'), true);
      }
      expect(controller.allStats['signs']!.accuracy, equals(100.0));
    });

    test('accuracy is 50% when half correct', () {
      controller.recordAnswer(_q('q1', 'rules'), true);
      controller.recordAnswer(_q('q2', 'rules'), false);
      expect(controller.allStats['rules']!.accuracy, equals(50.0));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Incorrect → mastered flow
  // ─────────────────────────────────────────────────────────────────────────
  group('SmartLearningController - Mastered questions', () {
    test('correct-then-correct does NOT add to mastered', () {
      final q = _q('fresh_q', 'signs');
      controller.recordAnswer(q, true);
      expect(controller.masteredCount, equals(0));
    });

    test('incorrect then correct moves question to mastered', () {
      final q = _q('master_q1', 'signs');
      controller.recordAnswer(q, false);
      controller.recordAnswer(q, true);
      expect(controller.masteredCount, equals(1));
    });

    test('only the once-incorrect question is mastered (not others)', () {
      controller.recordAnswer(_q('qA', 'sp'), true);
      controller.recordAnswer(_q('qB', 'sp'), false);
      controller.recordAnswer(_q('qB', 'sp'), true);
      expect(controller.masteredCount, equals(1));
    });

    test('answering incorrectly again removes from mastered', () {
      final q = _q('qX', 'sp');
      controller.recordAnswer(q, false);
      controller.recordAnswer(q, true);  // mastered
      controller.recordAnswer(q, false); // back to incorrect
      expect(controller.masteredCount, equals(0));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Bookmarks
  // ─────────────────────────────────────────────────────────────────────────
  group('SmartLearningController - Bookmarks', () {
    test('toggleBookmark adds a bookmark', () {
      controller.toggleBookmark('bq1');
      expect(controller.isBookmarked('bq1'), isTrue);
      expect(controller.bookmarkCount, equals(1));
    });

    test('toggleBookmark removes existing bookmark', () {
      controller.toggleBookmark('bq1');
      controller.toggleBookmark('bq1');
      expect(controller.isBookmarked('bq1'), isFalse);
      expect(controller.bookmarkCount, equals(0));
    });

    test('bookmarkedQuestionIds returns all bookmarked ids', () {
      controller.toggleBookmark('bq1');
      controller.toggleBookmark('bq2');
      final ids = controller.bookmarkedQuestionIds;
      expect(ids, containsAll(['bq1', 'bq2']));
    });

    test('isBookmarked returns false for non-bookmarked question', () {
      expect(controller.isBookmarked('not_bookmarked'), isFalse);
    });

    test('multiple bookmarks tracked independently', () {
      controller.toggleBookmark('bq1');
      controller.toggleBookmark('bq2');
      controller.toggleBookmark('bq3');
      expect(controller.bookmarkCount, equals(3));
    });

    test('removing one bookmark does not affect others', () {
      controller.toggleBookmark('bq1');
      controller.toggleBookmark('bq2');
      controller.toggleBookmark('bq1'); // remove bq1
      expect(controller.isBookmarked('bq2'), isTrue);
      expect(controller.bookmarkCount, equals(1));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Weak Areas
  // ─────────────────────────────────────────────────────────────────────────
  group('SmartLearningController - Weak Areas', () {
    test('subType with <70% accuracy and ≥3 attempts flagged as weak', () {
      for (var i = 0; i < 5; i++) {
        controller.recordAnswer(_q('p$i', 'parking'), false);
      }
      expect(controller.getWeakSubTypes(), contains('parking'));
    });

    test('does not return high-accuracy subType as weak', () {
      for (var i = 0; i < 10; i++) {
        controller.recordAnswer(_q('s$i', 'seatbelts'), true);
      }
      expect(controller.getWeakSubTypes(), isNot(contains('seatbelts')));
    });

    test('isWeakArea returns false when fewer than 3 attempts', () {
      controller.recordAnswer(_q('x1', 'new_topic'), false);
      controller.recordAnswer(_q('x2', 'new_topic'), false);
      expect(controller.isWeakArea('new_topic'), isFalse);
    });

    test('isWeakArea returns false for unknown subType', () {
      expect(controller.isWeakArea('completely_unknown'), isFalse);
    });

    test('isWeakArea returns true when accuracy drops below 70% (≥3 attempts)', () {
      for (var i = 0; i < 4; i++) {
        controller.recordAnswer(_q('w$i', 'weather'), false);
      }
      expect(controller.isWeakArea('weather'), isTrue);
    });

    test('getWeakAreas returns all subTypes sorted by accuracy lowest first', () {
      for (var i = 0; i < 5; i++) {
        controller.recordAnswer(_q('p$i', 'poor_topic'), false);
        controller.recordAnswer(_q('g$i', 'good_topic'), true);
      }
      final areas = controller.getWeakAreas();
      final poorIdx = areas.indexOf('poor_topic');
      final goodIdx = areas.indexOf('good_topic');
      expect(poorIdx, lessThan(goodIdx));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // getStats
  // ─────────────────────────────────────────────────────────────────────────
  group('SmartLearningController - getStats', () {
    test('returns null for subType with no data', () {
      expect(controller.getStats('no_such_subtype'), isNull);
    });

    test('returns correct PerformanceStats after answering', () {
      controller.recordAnswer(_q('i1', 'intersections'), true);
      final stats = controller.getStats('intersections');
      expect(stats, isNotNull);
      expect(stats!.totalAttempts, equals(1));
      expect(stats.correctAttempts, equals(1));
    });

    test('allStats returns copy — mutating it does not affect internal state', () {
      controller.recordAnswer(_q('q1', 'test'), true);
      final copy = controller.allStats;
      copy.clear();
      expect(controller.allStats, isNotEmpty);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Review Queue
  // ─────────────────────────────────────────────────────────────────────────
  group('SmartLearningController - reviewCount / needsReview', () {
    test('reviewCount is 0 initially', () {
      expect(controller.reviewCount, equals(0));
    });

    test('freshly incorrect answers do not appear in review immediately', () {
      controller.recordAnswer(_q('r1', 'signs'), false);
      expect(controller.reviewCount, equals(0));
    });

    test('needsReview returns false for question never answered', () {
      expect(controller.needsReview('never_seen'), isFalse);
    });

    test('needsReview returns false for freshly incorrect question', () {
      controller.recordAnswer(_q('fresh', 'signs'), false);
      expect(controller.needsReview('fresh'), isFalse);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Test History
  // ─────────────────────────────────────────────────────────────────────────
  group('SmartLearningController - Test History', () {
    test('recordTestSessionWithTime adds a session to history', () {
      final questions = [_q('q1', 'signs'), _q('q2', 'signs')];
      final answers = [_ans('q1'), _ans('q2', correct: false)];
      controller.recordTestSessionWithTime(questions, answers, 12);
      expect(controller.testHistory.length, equals(1));
      expect(controller.testHistory.first.totalQuestions, equals(2));
      expect(controller.testHistory.first.correctAnswers, equals(1));
    });

    test('most recent session is first in the list', () {
      final questions = [_q('q1', 'signs')];
      controller.recordTestSessionWithTime(questions, [_ans('q1')], 5);
      controller.recordTestSessionWithTime(questions, [_ans('q1', correct: false)], 3);
      expect(controller.testHistory.first.correctAnswers, equals(0));
    });

    test('getRecentSessions limits count', () {
      final questions = [_q('q1', 'signs')];
      for (var i = 0; i < 10; i++) {
        controller.recordTestSessionWithTime(questions, [_ans('q1')], 5);
      }
      expect(controller.getRecentSessions(3).length, equals(3));
    });

    test('getRecentSessions returns all when fewer than requested', () {
      final questions = [_q('q1', 'signs')];
      controller.recordTestSessionWithTime(questions, [_ans('q1')], 5);
      expect(controller.getRecentSessions(10).length, equals(1));
    });

    test('getSessionsForDays returns sessions within the window', () {
      final questions = [_q('q1', 'signs')];
      controller.recordTestSessionWithTime(questions, [_ans('q1')], 5);
      final recent = controller.getSessionsForDays(1);
      expect(recent.length, equals(1));
    });

    test('getAccuracyTrend returns a list', () {
      final questions = [_q('q1', 'signs')];
      controller.recordTestSessionWithTime(questions, [_ans('q1')], 5);
      expect(controller.getAccuracyTrend(), isA<List<TrendPoint>>());
    });

    test('testHistory is a copy — mutating it does not affect internal state', () {
      final questions = [_q('q1', 'signs')];
      controller.recordTestSessionWithTime(questions, [_ans('q1')], 5);
      final copy = controller.testHistory;
      copy.clear();
      expect(controller.testHistory.length, equals(1));
    });

    test('session totalTimeSeconds stored correctly', () {
      final questions = [_q('q1', 'signs')];
      controller.recordTestSessionWithTime(questions, [_ans('q1')], 42);
      expect(controller.testHistory.first.totalTimeSeconds, equals(42));
    });

    test('session testType is set from first question type displayName', () {
      final questions = [
        Question(
          id: 'qt1',
          stem: 'test',
          options: ['A', 'B', 'C', 'D'],
          correctAnswer: 0,
          explanation: 'e',
          type: QuestionType.trafficSigns,
          subType: 'signals',
        )
      ];
      controller.recordTestSessionWithTime(questions, [_ans('qt1')], 10);
      expect(controller.testHistory.first.testType, equals(QuestionType.trafficSigns.displayName));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // clearAllData
  // ─────────────────────────────────────────────────────────────────────────
  group('SmartLearningController - clearAllData', () {
    test('clears all stats, bookmarks, and history', () async {
      controller.recordAnswer(_q('q1', 'test_sub'), true);
      controller.toggleBookmark('bq1');
      controller.recordTestSessionWithTime([_q('q1', 'test_sub')], [_ans('q1')], 5);
      await controller.clearAllData();
      expect(controller.allStats, isEmpty);
      expect(controller.bookmarkCount, equals(0));
      expect(controller.testHistory, isEmpty);
    });

    test('clears mastered questions', () async {
      final q = _q('clear_q', 'signs');
      controller.recordAnswer(q, false);
      controller.recordAnswer(q, true);
      expect(controller.masteredCount, equals(1));
      await controller.clearAllData();
      expect(controller.masteredCount, equals(0));
    });

    test('clears time stats', () async {
      controller.recordAnswer(_q('q1', 'speed'), true, timeSpentSeconds: 15);
      await controller.clearAllData();
      expect(controller.allTimeStats, isEmpty);
    });
  });
}
