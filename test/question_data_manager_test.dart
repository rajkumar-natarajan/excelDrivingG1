import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:excel_driving_g1/data/question_data_manager.dart';
import 'package:excel_driving_g1/models/question.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late QuestionDataManager manager;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    manager = QuestionDataManager();
    await manager.initialize();
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────
  group('QuestionDataManager - Initialization', () {
    test('has at least 90 questions after initialize', () {
      expect(manager.allQuestions.length, greaterThanOrEqualTo(90));
    });

    test('re-initializing is idempotent', () async {
      final count1 = manager.allQuestions.length;
      await manager.initialize();
      expect(manager.allQuestions.length, equals(count1));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Questions by Type
  // ─────────────────────────────────────────────────────────────────────────
  group('QuestionDataManager - by QuestionType', () {
    for (final type in QuestionType.values) {
      test('has questions for ${type.displayName}', () {
        final questions = manager.getQuestionsByType(type);
        expect(questions, isNotEmpty, reason: 'No questions for $type');
      });
    }

    test('all 6 categories are populated', () {
      for (final type in QuestionType.values) {
        expect(manager.getQuestionsByType(type), isNotEmpty);
      }
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Question Data Integrity
  // ─────────────────────────────────────────────────────────────────────────
  group('QuestionDataManager - Data Integrity', () {
    test('every question has a non-empty id', () {
      for (final q in manager.allQuestions) {
        expect(q.id, isNotEmpty, reason: 'Empty id: ${q.stem}');
      }
    });

    test('all question IDs are unique', () {
      final ids = manager.allQuestions.map((q) => q.id).toList();
      expect(ids.toSet().length, equals(ids.length));
    });

    test('every question has exactly 4 options', () {
      for (final q in manager.allQuestions) {
        expect(q.options.length, equals(4), reason: '${q.id} does not have 4 options');
      }
    });

    test('every question has a valid correctAnswer index (0–3)', () {
      for (final q in manager.allQuestions) {
        expect(q.correctAnswer, inInclusiveRange(0, 3));
      }
    });

    test('every question has a non-empty explanation', () {
      for (final q in manager.allQuestions) {
        expect(q.explanation, isNotEmpty, reason: 'No explanation for ${q.id}');
      }
    });

    test('every question has non-empty stem', () {
      for (final q in manager.allQuestions) {
        expect(q.stem, isNotEmpty);
      }
    });

    test('every option in every question is non-empty', () {
      for (final q in manager.allQuestions) {
        for (final option in q.options) {
          expect(option, isNotEmpty, reason: 'Empty option in ${q.id}');
        }
      }
    });

    test('every question has a non-empty subType', () {
      for (final q in manager.allQuestions) {
        expect(q.subType, isNotEmpty);
      }
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // getConfiguredQuestions
  // ─────────────────────────────────────────────────────────────────────────
  group('QuestionDataManager - getConfiguredQuestions', () {
    test('quickAssessment returns 10 questions', () {
      const config = TestConfiguration(
        testType: TestType.quickAssessment,
        questionCount: 10,
        timeInMinutes: 10,
        difficulty: Difficulty.medium,
      );
      final questions = manager.getConfiguredQuestions(config);
      expect(questions.length, equals(10));
    });

    test('standardPractice returns 20 questions', () {
      const config = TestConfiguration(
        testType: TestType.standardPractice,
        questionCount: 20,
        timeInMinutes: 20,
        difficulty: Difficulty.medium,
      );
      final questions = manager.getConfiguredQuestions(config);
      expect(questions.length, equals(20));
    });

    test('fullMock returns 40 questions', () {
      const config = TestConfiguration(
        testType: TestType.fullMock,
        questionCount: 40,
        timeInMinutes: 40,
        difficulty: Difficulty.medium,
      );
      final questions = manager.getConfiguredQuestions(config);
      expect(questions.length, equals(40));
    });

    test('filtering by type returns only that type', () {
      const config = TestConfiguration(
        testType: TestType.standardPractice,
        questionCount: 20,
        timeInMinutes: 20,
        difficulty: Difficulty.medium,
        selectedTypes: [QuestionType.trafficSigns],
      );
      final questions = manager.getConfiguredQuestions(config);
      for (final q in questions) {
        expect(q.type, equals(QuestionType.trafficSigns));
      }
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Category distribution
  // ─────────────────────────────────────────────────────────────────────────
  group('QuestionDataManager - Category Distribution', () {
    test('graduated licensing has at least 10 questions', () {
      expect(manager.getQuestionsByType(QuestionType.graduatedLicensing).length, greaterThanOrEqualTo(10));
    });

    test('traffic signs has at least 15 questions', () {
      expect(manager.getQuestionsByType(QuestionType.trafficSigns).length, greaterThanOrEqualTo(15));
    });

    test('rules of road has at least 15 questions', () {
      expect(manager.getQuestionsByType(QuestionType.rulesOfRoad).length, greaterThanOrEqualTo(15));
    });

    test('safe driving has at least 10 questions', () {
      expect(manager.getQuestionsByType(QuestionType.safeDriving).length, greaterThanOrEqualTo(10));
    });

    test('sharing road has at least 8 questions', () {
      expect(manager.getQuestionsByType(QuestionType.sharingRoad).length, greaterThanOrEqualTo(8));
    });

    test('special situations has at least 8 questions', () {
      expect(manager.getQuestionsByType(QuestionType.specialSituations).length, greaterThanOrEqualTo(8));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // getRandomQuestions
  // ─────────────────────────────────────────────────────────────────────────
  group('QuestionDataManager - getRandomQuestions', () {
    test('returns requested count', () {
      final questions = manager.getRandomQuestions(5);
      expect(questions.length, equals(5));
    });

    test('filters by type when provided', () {
      final questions = manager.getRandomQuestions(5, types: [QuestionType.trafficSigns]);
      for (final q in questions) {
        expect(q.type, equals(QuestionType.trafficSigns));
      }
    });
  });
}
