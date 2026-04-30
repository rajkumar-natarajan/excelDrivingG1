import 'package:flutter_test/flutter_test.dart';
import 'package:excel_driving_g1/models/question.dart';
import 'dart:math';

void main() {
  // ─────────────────────────────────────────────────────────────────────────
  // QuestionType enum
  // ─────────────────────────────────────────────────────────────────────────
  group('QuestionType', () {
    test('has 6 values', () {
      expect(QuestionType.values.length, equals(6));
    });

    test('all types have a non-empty displayName', () {
      for (final type in QuestionType.values) {
        expect(type.displayName, isNotEmpty);
      }
    });

    test('displayNames are unique', () {
      final names = QuestionType.values.map((t) => t.displayName).toSet();
      expect(names.length, equals(QuestionType.values.length));
    });

    test('graduated licensing has correct displayName', () {
      expect(QuestionType.graduatedLicensing.displayName, contains('Graduated'));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Difficulty enum
  // ─────────────────────────────────────────────────────────────────────────
  group('Difficulty', () {
    test('has 3 values', () {
      expect(Difficulty.values.length, equals(3));
    });

    test('all difficulties have displayName', () {
      for (final d in Difficulty.values) {
        expect(d.displayName, isNotEmpty);
      }
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Question model
  // ─────────────────────────────────────────────────────────────────────────
  group('Question', () {
    const q = Question(
      id: 'test_001',
      stem: 'What is the default city speed limit in Ontario?',
      options: ['30 km/h', '50 km/h', '60 km/h', '80 km/h'],
      correctAnswer: 1,
      explanation: 'The default city speed limit is 50 km/h.',
      type: QuestionType.rulesOfRoad,
      subType: 'speed',
      difficulty: Difficulty.easy,
    );

    test('has 4 options', () => expect(q.options.length, equals(4)));

    test('correctAnswer is a valid index 0-3',
        () => expect(q.correctAnswer, inInclusiveRange(0, 3)));

    test('options[correctAnswer] returns the right answer',
        () => expect(q.options[q.correctAnswer], equals('50 km/h')));

    test('withShuffledOptions preserves all 4 options', () {
      final s = q.withShuffledOptions(Random(42));
      expect(s.options.toSet(), equals(q.options.toSet()));
    });

    test('withShuffledOptions correctAnswer still points to 50 km/h', () {
      final s = q.withShuffledOptions(Random(42));
      expect(s.options[s.correctAnswer], equals('50 km/h'));
    });

    test('id, type, subType, difficulty preserved after shuffle', () {
      final s = q.withShuffledOptions(Random(1));
      expect(s.id, equals(q.id));
      expect(s.type, equals(q.type));
      expect(s.subType, equals(q.subType));
      expect(s.difficulty, equals(q.difficulty));
    });

    test('stem and explanation are non-empty', () {
      expect(q.stem, isNotEmpty);
      expect(q.explanation, isNotEmpty);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // UserAnswer model
  // ─────────────────────────────────────────────────────────────────────────
  group('UserAnswer', () {
    test('isCorrect is true when provided as true', () {
      const answer = UserAnswer(
        questionId: 'ua_001',
        selectedOption: 2,
        isCorrect: true,
        timeTaken: Duration(seconds: 10),
      );
      expect(answer.isCorrect, isTrue);
    });

    test('isCorrect is false when provided as false', () {
      const answer = UserAnswer(
        questionId: 'ua_001',
        selectedOption: 0,
        isCorrect: false,
        timeTaken: Duration(seconds: 5),
      );
      expect(answer.isCorrect, isFalse);
    });
  });

  group('TestConfiguration', () {
    test('has required fields', () {
      const config = TestConfiguration(
        testType: TestType.quickAssessment,
        questionCount: 10,
        timeInMinutes: 10,
        difficulty: Difficulty.medium,
      );
      expect(config.questionCount, equals(10));
      expect(config.testType, equals(TestType.quickAssessment));
    });

    test('quickAssessment has 10 questions', () {
      expect(TestType.quickAssessment.questionCount, equals(10));
    });

    test('standardPractice has 20 questions', () {
      expect(TestType.standardPractice.questionCount, equals(20));
    });

    test('fullMock has 40 questions', () {
      expect(TestType.fullMock.questionCount, equals(40));
    });

    test('shuffleQuestions defaults to true', () {
      const config = TestConfiguration(
        testType: TestType.standardPractice,
        questionCount: 20,
        timeInMinutes: 20,
        difficulty: Difficulty.medium,
      );
      expect(config.shuffleQuestions, isTrue);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // PerformanceStats model
  // ─────────────────────────────────────────────────────────────────────────
  group('PerformanceStats', () {
    test('accuracy is 0 when no attempts', () {
      final stats = PerformanceStats(subType: 'test');
      expect(stats.accuracy, equals(0.0));
    });

    test('recordAttempt increments totalAttempts', () {
      final stats = PerformanceStats(subType: 'test');
      stats.recordAttempt(true);
      expect(stats.totalAttempts, equals(1));
    });

    test('accuracy is 1.0 when all correct', () {
      final stats = PerformanceStats(subType: 'test');
      stats.recordAttempt(true);
      stats.recordAttempt(true);
      expect(stats.accuracy, equals(1.0));
    });

    test('accuracy is 0.5 when half correct', () {
      final stats = PerformanceStats(subType: 'test');
      stats.recordAttempt(true);
      stats.recordAttempt(false);
      expect(stats.accuracy, equals(0.5));
    });

    test('toJson / fromJson round-trips', () {
      final stats = PerformanceStats(subType: 'speed', totalAttempts: 10, correctAttempts: 7);
      final json = stats.toJson();
      final restored = PerformanceStats.fromJson(json);
      expect(restored.subType, equals('speed'));
      expect(restored.totalAttempts, equals(10));
      expect(restored.correctAttempts, equals(7));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // TestSessionRecord model
  // ─────────────────────────────────────────────────────────────────────────
  group('TestSessionRecord', () {
    test('accuracy is calculated correctly', () {
      final record = TestSessionRecord(
        date: DateTime.now(),
        totalQuestions: 20,
        correctAnswers: 16,
        totalTimeSeconds: 300,
        testType: 'Standard Test',
      );
      expect(record.accuracy, closeTo(0.8, 0.001));
    });

    test('passed getter uses 80% threshold', () {
      final passing = TestSessionRecord(
        date: DateTime.now(),
        totalQuestions: 20,
        correctAnswers: 16,
        totalTimeSeconds: 300,
        testType: 'Standard Test',
      );
      // 16/20 = 80% — should pass
      expect(passing.accuracy, greaterThanOrEqualTo(0.8));
    });

    test('toJson / fromJson round-trips', () {
      final now = DateTime.now();
      final record = TestSessionRecord(
        date: now,
        totalQuestions: 40,
        correctAnswers: 35,
        totalTimeSeconds: 1200,
        testType: 'Full Mock',
      );
      final json = record.toJson();
      final restored = TestSessionRecord.fromJson(json);
      expect(restored.totalQuestions, equals(40));
      expect(restored.correctAnswers, equals(35));
      expect(restored.testType, equals('Full Mock'));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // TimeStats model
  // ─────────────────────────────────────────────────────────────────────────
  group('TimeStats', () {
    test('averageTime is 0 with no records', () {
      final stats = TimeStats(subType: 'speed');
      expect(stats.averageTime, equals(0.0));
    });

    test('averageTime computed correctly', () {
      final stats = TimeStats(subType: 'speed');
      stats.recordTime(10);
      stats.recordTime(20);
      expect(stats.averageTime, equals(15.0));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // TrendPoint model
  // ─────────────────────────────────────────────────────────────────────────
  group('TrendPoint', () {
    test('stores label and value', () {
      final point = TrendPoint(label: 'Week 1', value: 85.0);
      expect(point.label, equals('Week 1'));
      expect(point.value, equals(85.0));
    });
  });
}
