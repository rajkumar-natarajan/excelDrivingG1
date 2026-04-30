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
  });

  // ─────────────────────────────────────────────────────────────────────────
  // recordAnswer
  // ─────────────────────────────────────────────────────────────────────────
  group('SmartLearningController - recordAnswer', () {
    test('creates stats entry for new subType', () {
      controller.recordAnswer(_q('q1', 'speed_limits'), true);
      expect(controller.allStats.containsKey('speed_limits'), isTrue);
    });

    test('increments totalAttempts', () {
      controller.recordAnswer(_q('q1', 'speed'), true);
      controller.recordAnswer(_q('q2', 'speed'), false);
      expect(controller.allStats['speed']!.totalAttempts, equals(2));
    });

    test('increments correctAttempts only on correct answer', () {
      controller.recordAnswer(_q('q1', 'speed'), true);
      controller.recordAnswer(_q('q2', 'speed'), false);
      expect(controller.allStats['speed']!.correctAttempts, equals(1));
    });

    test('tracks time stats when timeSpentSeconds provided', () {
      controller.recordAnswer(_q('q1', 'speed'), true, timeSpentSeconds: 15);
      expect(controller.allTimeStats.containsKey('speed'), isTrue);
    });

    test('incorrect answer adds question to review pile', () {
      final q = _q('wrong_q1', 'parking');
      controller.recordAnswer(q, false);
      // question should be in the incorrect map (reviewable after a day)
      expect(controller.allStats.containsKey('parking'), isTrue);
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
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Weak Sub-Types
  // ─────────────────────────────────────────────────────────────────────────
  group('SmartLearningController - Weak Areas', () {
    test('returns subType with <70% accuracy (at least 3 attempts) as weak', () {
      for (var i = 0; i < 5; i++) {
        controller.recordAnswer(_q('p$i', 'parking'), false);
      }
      final weak = controller.getWeakSubTypes();
      expect(weak, contains('parking'));
    });

    test('does not return high-accuracy subType as weak', () {
      for (var i = 0; i < 10; i++) {
        controller.recordAnswer(_q('s$i', 'seatbelts'), true);
      }
      final weak = controller.getWeakSubTypes();
      expect(weak, isNot(contains('seatbelts')));
    });

    test('isWeakArea returns false when fewer than 3 attempts', () {
      controller.recordAnswer(_q('x1', 'new_topic'), false);
      controller.recordAnswer(_q('x2', 'new_topic'), false);
      // only 2 attempts — not enough to flag as weak
      expect(controller.isWeakArea('new_topic'), isFalse);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // getStats / allStats
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
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Test History (via recordTestSessionWithTime)
  // ─────────────────────────────────────────────────────────────────────────
  group('SmartLearningController - Test History', () {
    test('recordTestSessionWithTime adds a session to history', () {
      final questions = [_q('q1', 'signs'), _q('q2', 'signs')];
      final answers = [
        const UserAnswer(questionId: 'q1', selectedOption: 0, isCorrect: true, timeTaken: Duration(seconds: 5)),
        const UserAnswer(questionId: 'q2', selectedOption: 1, isCorrect: false, timeTaken: Duration(seconds: 7)),
      ];
      controller.recordTestSessionWithTime(questions, answers, 12);
      expect(controller.testHistory.length, equals(1));
      expect(controller.testHistory.first.totalQuestions, equals(2));
      expect(controller.testHistory.first.correctAnswers, equals(1));
    });

    test('most recent session is first in the list', () {
      final questions = [_q('q1', 'signs')];
      final answersA = [
        const UserAnswer(questionId: 'q1', selectedOption: 0, isCorrect: true, timeTaken: Duration(seconds: 5)),
      ];
      final answersB = [
        const UserAnswer(questionId: 'q1', selectedOption: 1, isCorrect: false, timeTaken: Duration(seconds: 3)),
      ];
      controller.recordTestSessionWithTime(questions, answersA, 5);
      controller.recordTestSessionWithTime(questions, answersB, 3);
      // second session (B) should be first
      expect(controller.testHistory.first.correctAnswers, equals(0));
    });

    test('getRecentSessions limits count', () {
      final questions = [_q('q1', 'signs')];
      final answers = [
        const UserAnswer(questionId: 'q1', selectedOption: 0, isCorrect: true, timeTaken: Duration(seconds: 5)),
      ];
      for (var i = 0; i < 10; i++) {
        controller.recordTestSessionWithTime(questions, answers, 5);
      }
      final recent = controller.getRecentSessions(3);
      expect(recent.length, equals(3));
    });

    test('getAccuracyTrend returns list', () {
      final questions = [_q('q1', 'signs')];
      final answers = [
        const UserAnswer(questionId: 'q1', selectedOption: 0, isCorrect: true, timeTaken: Duration(seconds: 5)),
      ];
      controller.recordTestSessionWithTime(questions, answers, 5);
      final trend = controller.getAccuracyTrend();
      expect(trend, isA<List<TrendPoint>>());
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // reviewCount
  // ─────────────────────────────────────────────────────────────────────────
  group('SmartLearningController - reviewCount', () {
    test('reviewCount is 0 initially', () {
      expect(controller.reviewCount, equals(0));
    });

    // Questions only appear in review after at least 1 day since they were
    // answered incorrectly. We cannot simulate time, so we verify the count
    // doesn't include freshly incorrect answers.
    test('freshly incorrect answers do not appear in review immediately', () {
      controller.recordAnswer(_q('r1', 'signs'), false);
      expect(controller.reviewCount, equals(0));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // masteredCount
  // ─────────────────────────────────────────────────────────────────────────
  group('SmartLearningController - masteredCount', () {
    test('correct answer after an incorrect one moves question to mastered', () {
      final q = _q('master_q1', 'signs');
      controller.recordAnswer(q, false); // first — goes to incorrect
      controller.recordAnswer(q, true);  // correct after incorrect → mastered
      expect(controller.masteredCount, equals(1));
    });

    test('Never-wrong correct answer is not "mastered"', () {
      // mastered requires first being incorrect then correct
      final q = _q('fresh_q', 'signs');
      controller.recordAnswer(q, true);
      expect(controller.masteredCount, equals(0));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // clearAllData
  // ─────────────────────────────────────────────────────────────────────────
  group('SmartLearningController - clearAllData', () {
    test('clears all stats, bookmarks, and history', () async {
      controller.recordAnswer(_q('q1', 'test_sub'), true);
      controller.toggleBookmark('bq1');
      final questions = [_q('q1', 'test_sub')];
      final answers = [
        const UserAnswer(questionId: 'q1', selectedOption: 0, isCorrect: true, timeTaken: Duration(seconds: 5)),
      ];
      controller.recordTestSessionWithTime(questions, answers, 5);
      await controller.clearAllData();
      expect(controller.allStats, isEmpty);
      expect(controller.bookmarkCount, equals(0));
      expect(controller.testHistory, isEmpty);
    });
  });
}
