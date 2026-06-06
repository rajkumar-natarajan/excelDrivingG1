// test/workflow_test.dart
// End-to-end workflow tests — full user journeys through the app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import 'package:excel_driving_g1/main.dart';
import 'package:excel_driving_g1/models/question.dart';
import 'package:excel_driving_g1/controllers/settings_controller.dart';
import 'package:excel_driving_g1/controllers/gamification_controller.dart';
import 'package:excel_driving_g1/controllers/smart_learning_controller.dart';
import 'package:excel_driving_g1/data/question_data_manager.dart';
import 'package:excel_driving_g1/screens/test_session_screen.dart';
import 'package:excel_driving_g1/screens/results_screen.dart';
import 'package:excel_driving_g1/screens/review_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

Question _makeQ(int index) => Question(
      id: 'wf_q_$index',
      stem: 'Workflow question $index?',
      options: ['Option A', 'Option B', 'Option C', 'Option D'],
      correctAnswer: 0,
      explanation: 'Explanation for $index.',
      type: QuestionType.rulesOfRoad,
      subType: 'speed_limits',
      difficulty: Difficulty.medium,
    );

TestConfiguration _makeConfig(int count) => TestConfiguration(
      testType: TestType.quickAssessment,
      questionCount: count,
      timeInMinutes: 10,
      difficulty: Difficulty.medium,
      shuffleQuestions: false,
    );

// ─────────────────────────────────────────────────────────────────────────────

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    SettingsController().setLanguage(Language.english);
    SettingsController().setThemeMode(ThemeMode.system);
    // Reset singletons for isolation
    await GamificationController().clearAllData();
    await SmartLearningController().clearAllData();
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Full app tab navigation workflow
  // ─────────────────────────────────────────────────────────────────────────
  group('Tab navigation workflow', () {
    testWidgets('user can visit all 5 tabs and return to Home', (tester) async {
      await tester.pumpWidget(const ExcelDrivingG1App());
      await tester.pumpAndSettle();

      final tabs = ['Practice', 'Progress', 'Study', 'Settings', 'Home'];
      for (final tab in tabs) {
        final finder = find.text(tab);
        if (finder.evaluate().isNotEmpty) {
          await tester.tap(finder.last);
          await tester.pumpAndSettle();
        }
      }

      // Should be back on Home
      expect(find.text('Home'), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Settings → clear data dialog → cancel → still on Settings', (tester) async {
      await tester.pumpWidget(const ExcelDrivingG1App());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Settings').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Clear All Data'));
      await tester.pumpAndSettle();

      expect(find.text('Confirm Delete'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Dialog is gone, still on Settings
      expect(find.text('Confirm Delete'), findsNothing);
      expect(find.text('Settings'), findsWidgets);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Complete a test and see results
  // ─────────────────────────────────────────────────────────────────────────
  group('Complete test → results workflow', () {
    testWidgets('answering all questions reaches ResultsScreen', (tester) async {
      final questions = List.generate(3, _makeQ);
      final config = _makeConfig(3);

      await tester.pumpWidget(MaterialApp(
        home: TestSessionScreen(configuration: config, questions: questions),
      ));
      await tester.pump();

      for (int i = 0; i < questions.length; i++) {
        // Select option A (correct)
        await tester.tap(find.text('Option A').first);
        await tester.pump();

        // Tap Next/Finish
        final nextFinder = find.byWidgetPredicate(
          (w) =>
              w is Text &&
              w.data != null &&
              (w.data!.toLowerCase().contains('next') ||
                  w.data!.toLowerCase().contains('finish') ||
                  w.data!.toLowerCase().contains('suivant') ||
                  w.data!.toLowerCase().contains('terminer')),
        );
        if (nextFinder.evaluate().isNotEmpty) {
          await tester.tap(nextFinder.first);
          await tester.pumpAndSettle();
        }
      }

      expect(find.byType(ResultsScreen), findsOneWidget);
    });

    testWidgets('ResultsScreen → Review Answers → ReviewScreen', (tester) async {
      final questions = List.generate(3, _makeQ);
      final config = _makeConfig(3);
      final answers = questions.asMap().entries
          .map((e) => UserAnswer(
                questionId: e.value.id,
                selectedOption: 0,
                isCorrect: true,
                timeTaken: const Duration(seconds: 5),
              ))
          .toList();
      final result = TestResult(
        id: 'wf_res_1',
        completedAt: DateTime.now(),
        configuration: config,
        answers: answers,
        totalQuestions: 3,
        correctAnswers: 3,
        totalTime: const Duration(minutes: 3),
        scoreByType: {QuestionType.rulesOfRoad: 3},
        scoreBySubType: {'speed_limits': 3},
      );

      await tester.pumpWidget(MaterialApp(
        home: ResultsScreen(result: result, questions: questions),
      ));
      await tester.pumpAndSettle();

      // Scroll to find Review Answers button
      final reviewBtn = find.text('Review Answers');
      if (reviewBtn.evaluate().isEmpty) {
        await tester.scrollUntilVisible(reviewBtn, 200,
            scrollable: find.byType(Scrollable).last);
      }
      await tester.tap(reviewBtn);
      await tester.pumpAndSettle();

      expect(find.byType(ReviewScreen), findsOneWidget);
    });

    testWidgets('ReviewScreen shows all answered questions', (tester) async {
      final questions = List.generate(3, _makeQ);
      final config = _makeConfig(3);
      final answers = questions.asMap().entries
          .map((e) => UserAnswer(
                questionId: e.value.id,
                selectedOption: 0,
                isCorrect: true,
                timeTaken: const Duration(seconds: 5),
              ))
          .toList();
      final result = TestResult(
        id: 'wf_res_2',
        completedAt: DateTime.now(),
        configuration: config,
        answers: answers,
        totalQuestions: 3,
        correctAnswers: 3,
        totalTime: const Duration(minutes: 3),
        scoreByType: {QuestionType.rulesOfRoad: 3},
        scoreBySubType: {'speed_limits': 3},
      );

      await tester.pumpWidget(MaterialApp(
        home: ReviewScreen(result: result, questions: questions),
      ));
      await tester.pumpAndSettle();

      // At least the first question stem should be visible
      expect(find.textContaining('Workflow question 0'), findsWidgets);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Gamification workflow
  // ─────────────────────────────────────────────────────────────────────────
  group('Gamification workflow', () {
    test('answering 10 correct questions increases XP from 0', () async {
      final g = GamificationController();
      await g.initialize();
      expect(g.totalXP, 0);

      for (int i = 0; i < 10; i++) {
        g.recordAnswer(isCorrect: true, questionType: 'rules_of_road');
      }
      expect(g.totalXP, greaterThan(0));
    });

    test('10 consecutive correct answers builds streak ≥ 10', () async {
      final g = GamificationController();
      await g.initialize();
      for (int i = 0; i < 10; i++) {
        g.recordAnswer(isCorrect: true, questionType: 'rules_of_road');
      }
      expect(g.currentStreak, greaterThanOrEqualTo(10));
    });

    test('a wrong answer resets the streak to 0', () async {
      final g = GamificationController();
      await g.initialize();
      for (int i = 0; i < 5; i++) {
        g.recordAnswer(isCorrect: true, questionType: 'rules_of_road');
      }
      g.recordAnswer(isCorrect: false, questionType: 'rules_of_road');
      expect(g.currentStreak, 0);
    });

    test('perfect 10/10 test grants perfectBonus', () async {
      final g = GamificationController();
      await g.initialize();
      final reward = g.recordTestCompletion(
        correctAnswers: 10,
        totalQuestions: 10,
        totalTimeSeconds: 80,
      );
      expect(reward.perfectBonus, isTrue);
    });

    test('clearAllData resets XP, level, streaks', () async {
      final g = GamificationController();
      await g.initialize();
      for (int i = 0; i < 20; i++) {
        g.recordAnswer(isCorrect: true, questionType: 'rules_of_road');
      }
      await g.clearAllData();
      expect(g.totalXP, 0);
      expect(g.currentLevel, 1);
      expect(g.currentStreak, 0);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Smart Learning workflow
  // ─────────────────────────────────────────────────────────────────────────
  group('Smart Learning workflow', () {
    test('bookmarking a question adds it to bookmarks', () async {
      final sl = SmartLearningController();
      await sl.initialize();
      sl.toggleBookmark('wf_q_1');
      expect(sl.isBookmarked('wf_q_1'), isTrue);
      expect(sl.bookmarkCount, 1);
    });

    test('toggling bookmark twice removes it', () async {
      final sl = SmartLearningController();
      await sl.initialize();
      sl.toggleBookmark('wf_q_1');
      sl.toggleBookmark('wf_q_1');
      expect(sl.isBookmarked('wf_q_1'), isFalse);
      expect(sl.bookmarkCount, 0);
    });

    test('recording 3+ wrong answers flags subType as weak', () async {
      final sl = SmartLearningController();
      await sl.initialize();
      for (int i = 0; i < 5; i++) {
        final q = _makeQ(i);
        sl.recordAnswer(q, false);
      }
      expect(sl.isWeakArea('speed_limits'), isTrue);
      expect(sl.getWeakSubTypes(), contains('speed_limits'));
    });

    test('high-accuracy subType is NOT flagged as weak', () async {
      final sl = SmartLearningController();
      await sl.initialize();
      for (int i = 0; i < 10; i++) {
        final q = Question(
          id: 'signs_q_$i',
          stem: 'Signs q $i?',
          options: ['A', 'B', 'C', 'D'],
          correctAnswer: 0,
          explanation: 'E',
          type: QuestionType.trafficSigns,
          subType: 'road_signs',
          difficulty: Difficulty.medium,
        );
        sl.recordAnswer(q, true);
      }
      expect(sl.isWeakArea('signs'), isFalse);
    });

    test('clearAllData removes bookmarks and weak areas', () async {
      final sl = SmartLearningController();
      await sl.initialize();
      sl.toggleBookmark('wf_q_1');
      for (int i = 0; i < 5; i++) {
        sl.recordAnswer(_makeQ(i), false);
      }
      await sl.clearAllData();
      expect(sl.bookmarkCount, 0);
      expect(sl.isWeakArea('speed_limits'), isFalse);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Settings workflow
  // ─────────────────────────────────────────────────────────────────────────
  group('Settings workflow', () {
    test('switching to dark theme updates themeMode', () {
      final s = SettingsController();
      s.setThemeMode(ThemeMode.dark);
      expect(s.themeMode, ThemeMode.dark);
    });

    test('switching to light theme updates themeMode', () {
      final s = SettingsController();
      s.setThemeMode(ThemeMode.light);
      expect(s.themeMode, ThemeMode.light);
    });

    test('setting difficulty to hard updates defaultDifficulty', () {
      final s = SettingsController();
      s.setDifficulty(Difficulty.hard);
      expect(s.defaultDifficulty, Difficulty.hard);
    });

    test('setting difficulty to easy updates defaultDifficulty', () {
      final s = SettingsController();
      s.setDifficulty(Difficulty.easy);
      expect(s.defaultDifficulty, Difficulty.easy);
    });

    test('language can be toggled back and forth', () {
      final s = SettingsController();
      s.setLanguage(Language.french);
      expect(s.language, Language.french);
      s.setLanguage(Language.english);
      expect(s.language, Language.english);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // QuestionDataManager — full 352-question corpus validation
  // ─────────────────────────────────────────────────────────────────────────
  group('QuestionDataManager corpus', () {
    late QuestionDataManager dm;
    setUp(() => dm = QuestionDataManager());

    test('has exactly 352 or more questions', () {
      expect(dm.allQuestions.length, greaterThanOrEqualTo(352));
    });

    test('all 6 QuestionTypes are populated', () {
      for (final type in QuestionType.values) {
        expect(
          dm.getQuestionsByType(type).length,
          greaterThan(0),
          reason: '$type should have questions',
        );
      }
    });

    test('no duplicate IDs in the full bank', () {
      final ids = dm.allQuestions.map((q) => q.id).toList();
      expect(ids.toSet().length, ids.length, reason: 'All IDs must be unique');
    });

    test('every question has a non-empty explanation', () {
      for (final q in dm.allQuestions) {
        expect(q.explanation.trim(), isNotEmpty, reason: '${q.id} has empty explanation');
      }
    });

    test('every question has exactly 4 options', () {
      for (final q in dm.allQuestions) {
        expect(q.options.length, 4, reason: '${q.id} has wrong option count');
      }
    });

    test('correctAnswer is always 0–3', () {
      for (final q in dm.allQuestions) {
        expect(q.correctAnswer, inInclusiveRange(0, 3),
            reason: '${q.id} has out-of-range correctAnswer');
      }
    });

    test('getConfiguredQuestions quickAssessment returns 10 questions', () {
      final config = TestConfiguration(
        testType: TestType.quickAssessment,
        questionCount: 10,
        timeInMinutes: 10,
        difficulty: Difficulty.medium,
        shuffleQuestions: false,
      );
      expect(dm.getConfiguredQuestions(config).length, 10);
    });

    test('getConfiguredQuestions standardPractice returns 20 questions', () {
      final config = TestConfiguration(
        testType: TestType.standardPractice,
        questionCount: 20,
        timeInMinutes: 20,
        difficulty: Difficulty.medium,
        shuffleQuestions: false,
      );
      expect(dm.getConfiguredQuestions(config).length, 20);
    });

    test('getConfiguredQuestions fullMock returns 40 questions', () {
      final config = TestConfiguration(
        testType: TestType.fullMock,
        questionCount: 40,
        timeInMinutes: 40,
        difficulty: Difficulty.medium,
        shuffleQuestions: false,
      );
      expect(dm.getConfiguredQuestions(config).length, 40);
    });

    test('French-localised questions have non-empty stems', () {
      final config = TestConfiguration(
        testType: TestType.quickAssessment,
        questionCount: 10,
        timeInMinutes: 10,
        difficulty: Difficulty.medium,
        shuffleQuestions: false,
      );
      final questions = dm.getConfiguredQuestions(config, language: Language.french);
      for (final q in questions) {
        expect(q.stem.trim(), isNotEmpty, reason: '${q.id} has empty French stem');
      }
    });

    test('shuffled questions preserve all options', () {
      final q = dm.allQuestions.first;
      final shuffled = q.withShuffledOptions(Random(42));
      expect(shuffled.options.length, 4);
      expect(shuffled.options.toSet(), equals(q.options.toSet()));
    });

    test('shuffled question correctAnswer still points to same text', () {
      final q = dm.allQuestions.first;
      final correctText = q.options[q.correctAnswer];
      final shuffled = q.withShuffledOptions(Random(42));
      expect(shuffled.options[shuffled.correctAnswer], equals(correctText));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // TestResult model — pass/fail logic
  // ─────────────────────────────────────────────────────────────────────────
  group('TestResult pass/fail logic', () {
    TestResult makeResult(int correct, int total) {
      final answers = List.generate(
        total,
        (i) => UserAnswer(
          questionId: 'q$i',
          selectedOption: i < correct ? 0 : 1,
          isCorrect: i < correct,
          timeTaken: const Duration(seconds: 10),
        ),
      );
      return TestResult(
        id: 'pf_$correct\_$total',
        completedAt: DateTime.now(),
        configuration: _makeConfig(total),
        answers: answers,
        totalQuestions: total,
        correctAnswers: correct,
        totalTime: const Duration(minutes: 5),
        scoreByType: {QuestionType.rulesOfRoad: correct},
        scoreBySubType: {'speed_limits': correct},
      );
    }

    test('32/40 = 80% passes', () {
      final r = makeResult(32, 40);
      expect(r.percentage, closeTo(80.0, 0.1));
      expect(r.passed, isTrue);
    });

    test('31/40 = 77.5% fails', () {
      final r = makeResult(31, 40);
      expect(r.passed, isFalse);
    });

    test('40/40 = 100% passes', () {
      final r = makeResult(40, 40);
      expect(r.percentage, closeTo(100.0, 0.1));
      expect(r.passed, isTrue);
    });

    test('0/40 = 0% fails', () {
      final r = makeResult(0, 40);
      expect(r.percentage, closeTo(0.0, 0.1));
      expect(r.passed, isFalse);
    });

    test('16/20 = 80% passes (short test)', () {
      final r = makeResult(16, 20);
      expect(r.percentage, closeTo(80.0, 0.1));
      expect(r.passed, isTrue);
    });
  });
}
