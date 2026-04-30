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

    test('graduated licensing has correct value', () {
      expect(QuestionType.graduatedLicensing.value, equals('graduated'));
    });

    test('traffic signs has correct displayName', () {
      expect(QuestionType.trafficSigns.displayName, contains('Signs'));
    });

    test('rules of road has correct value', () {
      expect(QuestionType.rulesOfRoad.value, equals('rules'));
    });

    test('safe driving has correct value', () {
      expect(QuestionType.safeDriving.value, equals('safety'));
    });

    test('sharing road has correct value', () {
      expect(QuestionType.sharingRoad.value, equals('sharing'));
    });

    test('special situations has correct value', () {
      expect(QuestionType.specialSituations.value, equals('special'));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Graduated sub-types
  // ─────────────────────────────────────────────────────────────────────────
  group('GraduatedSubType', () {
    test('has 5 values', () {
      expect(GraduatedSubType.values.length, equals(5));
    });

    test('all have non-empty displayName', () {
      for (final s in GraduatedSubType.values) {
        expect(s.displayName, isNotEmpty);
      }
    });

    test('g1Requirements value is g1_req', () {
      expect(GraduatedSubType.g1Requirements.value, equals('g1_req'));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Traffic Signs sub-types
  // ─────────────────────────────────────────────────────────────────────────
  group('SignsSubType', () {
    test('has 5 values', () {
      expect(SignsSubType.values.length, equals(5));
    });

    test('regulatorySigns value is regulatory', () {
      expect(SignsSubType.regulatorySigns.value, equals('regulatory'));
    });

    test('roadMarkings has expected displayName', () {
      expect(SignsSubType.roadMarkings.displayName, contains('Markings'));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Rules sub-types
  // ─────────────────────────────────────────────────────────────────────────
  group('RulesSubType', () {
    test('has 5 values', () {
      expect(RulesSubType.values.length, equals(5));
    });

    test('speedLimits value is speed', () {
      expect(RulesSubType.speedLimits.value, equals('speed'));
    });

    test('intersections value is intersections', () {
      expect(RulesSubType.intersections.value, equals('intersections'));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Safety sub-types
  // ─────────────────────────────────────────────────────────────────────────
  group('SafetySubType', () {
    test('has 5 values', () {
      expect(SafetySubType.values.length, equals(5));
    });

    test('alcoholDrugs value is alcohol', () {
      expect(SafetySubType.alcoholDrugs.value, equals('alcohol'));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Sharing sub-types
  // ─────────────────────────────────────────────────────────────────────────
  group('SharingSubType', () {
    test('has 5 values', () {
      expect(SharingSubType.values.length, equals(5));
    });

    test('emergencyVehicles value is emergency', () {
      expect(SharingSubType.emergencyVehicles.value, equals('emergency'));
    });

    test('schoolBuses value is school_bus', () {
      expect(SharingSubType.schoolBuses.value, equals('school_bus'));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Special sub-types
  // ─────────────────────────────────────────────────────────────────────────
  group('SpecialSubType', () {
    test('has 4 values', () {
      expect(SpecialSubType.values.length, equals(4));
    });

    test('nightDriving value is night', () {
      expect(SpecialSubType.nightDriving.value, equals('night'));
    });

    test('collisions value is collisions', () {
      expect(SpecialSubType.collisions.value, equals('collisions'));
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

    test('easy value is easy', () {
      expect(Difficulty.easy.value, equals('easy'));
    });

    test('medium value is medium', () {
      expect(Difficulty.medium.value, equals('medium'));
    });

    test('hard value is hard', () {
      expect(Difficulty.hard.value, equals('hard'));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Language enum
  // ─────────────────────────────────────────────────────────────────────────
  group('Language', () {
    test('has at least 1 value', () {
      expect(Language.values, isNotEmpty);
    });

    test('fromCode("en") returns english', () {
      expect(Language.fromCode('en'), equals(Language.english));
    });

    test('fromCode unknown returns english default', () {
      expect(Language.fromCode('zz'), equals(Language.english));
    });

    test('english has Canadian flag emoji', () {
      expect(Language.english.flag, equals('🇨🇦'));
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

    test('correctAnswer is a valid index 0–3', () {
      expect(q.correctAnswer, inInclusiveRange(0, 3));
    });

    test('options[correctAnswer] returns the right answer', () {
      expect(q.options[q.correctAnswer], equals('50 km/h'));
    });

    test('withShuffledOptions preserves all 4 option texts', () {
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

    test('toString contains id and stem', () {
      expect(q.toString(), contains('test_001'));
    });

    test('withShuffledOptions with different seeds may produce different orders', () {
      // Run 20 shuffles and check at least one differs from original
      bool foundDifferent = false;
      for (int seed = 0; seed < 20; seed++) {
        final s = q.withShuffledOptions(Random(seed));
        if (s.options[0] != q.options[0]) {
          foundDifferent = true;
          break;
        }
      }
      expect(foundDifferent, isTrue);
    });

    test('default difficulty is medium when not specified', () {
      const noD = Question(
        id: 'none',
        stem: 'test',
        options: ['A', 'B', 'C', 'D'],
        correctAnswer: 0,
        explanation: 'e',
        type: QuestionType.safeDriving,
        subType: 'alcohol',
      );
      expect(noD.difficulty, equals(Difficulty.medium));
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

    test('questionId is stored correctly', () {
      const answer = UserAnswer(
        questionId: 'my_question',
        selectedOption: 1,
        isCorrect: true,
        timeTaken: Duration(seconds: 3),
      );
      expect(answer.questionId, equals('my_question'));
    });

    test('selectedOption is stored correctly', () {
      const answer = UserAnswer(
        questionId: 'q1',
        selectedOption: 3,
        isCorrect: false,
        timeTaken: Duration(seconds: 7),
      );
      expect(answer.selectedOption, equals(3));
    });

    test('timeTaken is stored correctly', () {
      const dur = Duration(seconds: 42);
      const answer = UserAnswer(
        questionId: 'q1',
        selectedOption: 0,
        isCorrect: true,
        timeTaken: dur,
      );
      expect(answer.timeTaken, equals(dur));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // TestType enum
  // ─────────────────────────────────────────────────────────────────────────
  group('TestType', () {
    test('quickAssessment has 10 questions', () {
      expect(TestType.quickAssessment.questionCount, equals(10));
    });

    test('standardPractice has 20 questions', () {
      expect(TestType.standardPractice.questionCount, equals(20));
    });

    test('fullMock has 40 questions', () {
      expect(TestType.fullMock.questionCount, equals(40));
    });

    test('quickAssessment has 10 minutes', () {
      expect(TestType.quickAssessment.timeInMinutes, equals(10));
    });

    test('fullMock has 40 minutes', () {
      expect(TestType.fullMock.timeInMinutes, equals(40));
    });

    test('all types have non-empty displayName', () {
      for (final t in TestType.values) {
        expect(t.displayName, isNotEmpty);
      }
    });

    test('all types have non-empty description', () {
      for (final t in TestType.values) {
        expect(t.description, isNotEmpty);
      }
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // TestConfiguration model
  // ─────────────────────────────────────────────────────────────────────────
  group('TestConfiguration', () {
    test('fields stored correctly', () {
      const config = TestConfiguration(
        testType: TestType.quickAssessment,
        questionCount: 10,
        timeInMinutes: 10,
        difficulty: Difficulty.medium,
      );
      expect(config.questionCount, equals(10));
      expect(config.testType, equals(TestType.quickAssessment));
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

    test('shuffleQuestions can be set to false', () {
      const config = TestConfiguration(
        testType: TestType.fullMock,
        questionCount: 40,
        timeInMinutes: 40,
        difficulty: Difficulty.hard,
        shuffleQuestions: false,
      );
      expect(config.shuffleQuestions, isFalse);
    });

    test('selectedTypes can be provided', () {
      const config = TestConfiguration(
        testType: TestType.quickAssessment,
        questionCount: 10,
        timeInMinutes: 10,
        difficulty: Difficulty.easy,
        selectedTypes: [QuestionType.trafficSigns],
      );
      expect(config.selectedTypes, contains(QuestionType.trafficSigns));
    });

    test('selectedTypes is null when not provided', () {
      const config = TestConfiguration(
        testType: TestType.quickAssessment,
        questionCount: 10,
        timeInMinutes: 10,
        difficulty: Difficulty.easy,
      );
      expect(config.selectedTypes, isNull);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // TestResult model - percentage and passed
  // ─────────────────────────────────────────────────────────────────────────
  group('TestResult - percentage and passed', () {
    TestResult _makeResult(int total, int correct) => TestResult(
      id: 'result_$total',
      completedAt: DateTime.now(),
      configuration: const TestConfiguration(
        testType: TestType.fullMock,
        questionCount: 40,
        timeInMinutes: 40,
        difficulty: Difficulty.medium,
      ),
      answers: [],
      totalQuestions: total,
      correctAnswers: correct,
      totalTime: const Duration(minutes: 20),
      scoreByType: {},
      scoreBySubType: {},
    );

    test('percentage of 32/40 is 80.0', () {
      final r = _makeResult(40, 32);
      expect(r.percentage, closeTo(80.0, 0.001));
    });

    test('passed is true at exactly 80%', () {
      final r = _makeResult(40, 32);
      expect(r.passed, isTrue);
    });

    test('passed is false below 80%', () {
      final r = _makeResult(40, 31); // 77.5%
      expect(r.passed, isFalse);
    });

    test('passed is true above 80%', () {
      final r = _makeResult(10, 9); // 90%
      expect(r.passed, isTrue);
    });

    test('percentage is 0 when totalQuestions is 0', () {
      final r = _makeResult(0, 0);
      expect(r.percentage, equals(0.0));
    });

    test('percentage is 100 on perfect score', () {
      final r = _makeResult(20, 20);
      expect(r.percentage, closeTo(100.0, 0.001));
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

    test('fromJson with explicit zero values', () {
      final restored = PerformanceStats.fromJson({'subType': 'x', 'totalAttempts': 0, 'correctAttempts': 0});
      expect(restored.totalAttempts, equals(0));
      expect(restored.correctAttempts, equals(0));
    });

    test('recordAttempt false does not increment correctAttempts', () {
      final stats = PerformanceStats(subType: 'test');
      stats.recordAttempt(false);
      expect(stats.correctAttempts, equals(0));
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

    test('accuracy is 0 when totalQuestions is 0', () {
      final record = TestSessionRecord(
        date: DateTime.now(),
        totalQuestions: 0,
        correctAnswers: 0,
        totalTimeSeconds: 0,
        testType: 'x',
      );
      expect(record.accuracy, equals(0.0));
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
      expect(restored.totalTimeSeconds, equals(1200));
    });

    test('fromJson with explicit zero values', () {
      final restored = TestSessionRecord.fromJson({
        'date': DateTime.now().toIso8601String(),
        'totalQuestions': 0,
        'correctAnswers': 0,
        'totalTimeSeconds': 0,
        'testType': '',
      });
      expect(restored.totalQuestions, equals(0));
      expect(restored.correctAnswers, equals(0));
      expect(restored.testType, equals(''));
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

    test('recordTime increments questionCount', () {
      final stats = TimeStats(subType: 'speed');
      stats.recordTime(10);
      stats.recordTime(20);
      expect(stats.questionCount, equals(2));
    });

    test('recordTime accumulates totalTime', () {
      final stats = TimeStats(subType: 'speed');
      stats.recordTime(5);
      stats.recordTime(5);
      stats.recordTime(10);
      expect(stats.totalTime, equals(20));
    });

    test('toJson / fromJson round-trips', () {
      final stats = TimeStats(subType: 'signs', totalTime: 100, questionCount: 5);
      final json = stats.toJson();
      final restored = TimeStats.fromJson(json);
      expect(restored.subType, equals('signs'));
      expect(restored.totalTime, equals(100));
      expect(restored.questionCount, equals(5));
    });

    test('fromJson with explicit zero values', () {
      final restored = TimeStats.fromJson({'subType': 'x', 'totalTime': 0, 'questionCount': 0});
      expect(restored.totalTime, equals(0));
      expect(restored.questionCount, equals(0));
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

    test('value can be 0', () {
      final point = TrendPoint(label: 'W0', value: 0.0);
      expect(point.value, equals(0.0));
    });

    test('value can be 100', () {
      final point = TrendPoint(label: 'W100', value: 100.0);
      expect(point.value, equals(100.0));
    });
  });
}
