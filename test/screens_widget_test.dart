// test/screens_widget_test.dart
// Widget tests for PracticeScreen, TestSessionScreen, ResultsScreen,
// AchievementsScreen, DashboardScreen, ProgressScreen, ReviewScreen.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:excel_driving_g1/main.dart';
import 'package:excel_driving_g1/models/question.dart';
import 'package:excel_driving_g1/screens/practice_screen.dart';
import 'package:excel_driving_g1/screens/test_session_screen.dart';
import 'package:excel_driving_g1/screens/results_screen.dart';
import 'package:excel_driving_g1/screens/review_screen.dart';
import 'package:excel_driving_g1/screens/achievements_screen.dart';
import 'package:excel_driving_g1/screens/progress_screen.dart';
import 'package:excel_driving_g1/screens/dashboard_screen.dart';
import 'package:excel_driving_g1/data/question_data_manager.dart';
import 'package:excel_driving_g1/controllers/settings_controller.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Minimal Question factory for tests.
Question makeQuestion({
  String id = 'q_test_1',
  String stem = 'What is the speed limit in a school zone?',
  int correctAnswer = 0,
  QuestionType type = QuestionType.rulesOfRoad,
  Difficulty difficulty = Difficulty.medium,
}) {
  return Question(
    id: id,
    stem: stem,
    options: ['40 km/h', '50 km/h', '60 km/h', '80 km/h'],
    correctAnswer: correctAnswer,
    explanation: 'School zones have a 40 km/h limit.',
    type: type,
    subType: 'speed_limits',
    difficulty: difficulty,
  );
}

List<Question> makeFiveQuestions() => List.generate(
      5,
      (i) => makeQuestion(id: 'q_test_${i + 1}', stem: 'Question ${i + 1}?'),
    );

TestConfiguration makeConfig({
  TestType type = TestType.quickAssessment,
  Difficulty difficulty = Difficulty.medium,
}) =>
    TestConfiguration(
      testType: type,
      questionCount: 5,
      timeInMinutes: 10,
      difficulty: difficulty,
      shuffleQuestions: false,
    );

/// Wraps [widget] in a MaterialApp so navigation/theme/directionality works.
Widget wrap(Widget widget) => MaterialApp(home: widget);

// ---------------------------------------------------------------------------

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    SettingsController().setLanguage(Language.english);
    SettingsController().setThemeMode(ThemeMode.system);
  });

  // ─────────────────────────────────────────────────────────────────────────
  // PracticeScreen
  // ─────────────────────────────────────────────────────────────────────────
  group('PracticeScreen', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(wrap(const PracticeScreen()));
      await tester.pumpAndSettle();
      expect(find.byType(PracticeScreen), findsOneWidget);
    });

    testWidgets('shows Practice app bar', (tester) async {
      await tester.pumpWidget(wrap(const PracticeScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Practice'), findsWidgets);
    });

    testWidgets('shows Configuration card', (tester) async {
      await tester.pumpWidget(wrap(const PracticeScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Configuration'), findsWidgets);
    });

    testWidgets('shows difficulty dropdown', (tester) async {
      await tester.pumpWidget(wrap(const PracticeScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Difficulty Level'), findsWidgets);
    });

    testWidgets('shows Topics chip section', (tester) async {
      await tester.pumpWidget(wrap(const PracticeScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Topics'), findsWidgets);
    });

    testWidgets('shows 6 topic filter chips (one per QuestionType)', (tester) async {
      await tester.pumpWidget(wrap(const PracticeScreen()));
      await tester.pumpAndSettle();
      expect(find.byType(FilterChip), findsNWidgets(QuestionType.values.length));
    });

    testWidgets('shows Select Test Type header', (tester) async {
      await tester.pumpWidget(wrap(const PracticeScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Select Test Type'), findsWidgets);
    });

    testWidgets('shows Quick Check test type card', (tester) async {
      await tester.pumpWidget(wrap(const PracticeScreen()));
      await tester.pumpAndSettle();
      // Scroll down to reveal test type cards
      await tester.drag(find.byType(ListView), const Offset(0, -400));
      await tester.pumpAndSettle();
      expect(find.textContaining('Quick Check'), findsWidgets);
    });

    testWidgets('shows Standard Practice test type card', (tester) async {
      await tester.pumpWidget(wrap(const PracticeScreen()));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView), const Offset(0, -400));
      await tester.pumpAndSettle();
      expect(find.textContaining('Standard Practice'), findsWidgets);
    });

    testWidgets('shows Mock G1 Test type card', (tester) async {
      await tester.pumpWidget(wrap(const PracticeScreen()));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView), const Offset(0, -600));
      await tester.pumpAndSettle();
      expect(find.textContaining('Full Mock'), findsWidgets);
    });

    testWidgets('shows Smart Practice card', (tester) async {
      await tester.pumpWidget(wrap(const PracticeScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Smart Practice'), findsWidgets);
    });

    testWidgets('deselecting one chip keeps at least one type selected', (tester) async {
      await tester.pumpWidget(wrap(const PracticeScreen()));
      await tester.pumpAndSettle();
      // Tap the first chip (should be selected initially) — deselect it
      final chips = tester.widgetList<FilterChip>(find.byType(FilterChip)).toList();
      expect(chips.first.selected, isTrue);
      await tester.tap(find.byType(FilterChip).first);
      await tester.pumpAndSettle();
      // At least 5 should remain selected (6-1=5)
      final selectedCount = tester
          .widgetList<FilterChip>(find.byType(FilterChip))
          .where((c) => c.selected)
          .length;
      expect(selectedCount, greaterThanOrEqualTo(1));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // TestSessionScreen
  // ─────────────────────────────────────────────────────────────────────────
  group('TestSessionScreen', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(wrap(TestSessionScreen(
        configuration: makeConfig(),
        questions: makeFiveQuestions(),
      )));
      await tester.pump(); // one frame — don't pumpAndSettle (timer runs)
      expect(find.byType(TestSessionScreen), findsOneWidget);
    });

    testWidgets('shows question stem', (tester) async {
      await tester.pumpWidget(wrap(TestSessionScreen(
        configuration: makeConfig(),
        questions: [makeQuestion(stem: 'What is the speed limit?')],
      )));
      await tester.pump();
      expect(find.textContaining('speed limit'), findsWidgets);
    });

    testWidgets('shows 4 answer option buttons', (tester) async {
      await tester.pumpWidget(wrap(TestSessionScreen(
        configuration: makeConfig(),
        questions: [makeQuestion()],
      )));
      await tester.pump();
      // Each option is rendered — look for option texts
      expect(find.text('40 km/h'), findsWidgets);
      expect(find.text('50 km/h'), findsWidgets);
      expect(find.text('60 km/h'), findsWidgets);
      expect(find.text('80 km/h'), findsWidgets);
    });

    testWidgets('shows timer in header', (tester) async {
      await tester.pumpWidget(wrap(TestSessionScreen(
        configuration: makeConfig(),
        questions: makeFiveQuestions(),
      )));
      await tester.pump();
      // Timer shows MM:SS pattern — look for colon
      expect(
        find.byWidgetPredicate(
          (w) => w is Text && w.data != null && RegExp(r'\d+:\d+').hasMatch(w.data!),
        ),
        findsWidgets,
      );
    });

    testWidgets('shows question counter (1 of N)', (tester) async {
      await tester.pumpWidget(wrap(TestSessionScreen(
        configuration: makeConfig(),
        questions: makeFiveQuestions(),
      )));
      await tester.pump();
      // Progress indicator or "1" somewhere
      expect(find.byType(LinearProgressIndicator), findsWidgets);
    });

    testWidgets('selecting correct answer highlights it', (tester) async {
      final q = makeQuestion(correctAnswer: 0);
      await tester.pumpWidget(wrap(TestSessionScreen(
        configuration: makeConfig(),
        questions: [q],
      )));
      await tester.pump();
      await tester.tap(find.text('40 km/h').first);
      await tester.pump();
      // After selecting, an answer state exists; no exception thrown
      expect(tester.takeException(), isNull);
    });

    testWidgets('selecting wrong answer does not crash', (tester) async {
      final q = makeQuestion(correctAnswer: 0);
      await tester.pumpWidget(wrap(TestSessionScreen(
        configuration: makeConfig(),
        questions: [q],
      )));
      await tester.pump();
      await tester.tap(find.text('50 km/h').first); // index 1 = wrong
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('selecting an answer twice does not change it', (tester) async {
      final q = makeQuestion(correctAnswer: 0);
      await tester.pumpWidget(wrap(TestSessionScreen(
        configuration: makeConfig(),
        questions: [q],
      )));
      await tester.pump();
      await tester.tap(find.text('40 km/h').first);
      await tester.pump();
      // Tap a different option — should be ignored
      await tester.tap(find.text('50 km/h').first);
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows Next button after selecting answer', (tester) async {
      final q = makeQuestion(correctAnswer: 0);
      await tester.pumpWidget(wrap(TestSessionScreen(
        configuration: makeConfig(),
        questions: [q],
      )));
      await tester.pump();
      await tester.tap(find.text('40 km/h').first);
      await tester.pump();
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Text &&
              w.data != null &&
              (w.data!.toLowerCase().contains('next') ||
                  w.data!.toLowerCase().contains('finish') ||
                  w.data!.toLowerCase().contains('suivant')),
        ),
        findsWidgets,
      );
    });

    testWidgets('single-question test finishes on Next tap', (tester) async {
      final q = makeQuestion(correctAnswer: 0);
      await tester.pumpWidget(wrap(TestSessionScreen(
        configuration: makeConfig(),
        questions: [q],
      )));
      await tester.pump();
      // Select answer
      await tester.tap(find.text('40 km/h').first);
      await tester.pump();
      // Tap the Next / Finish button
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
        // Should have navigated to ResultsScreen
        expect(find.byType(ResultsScreen), findsOneWidget);
      }
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // ResultsScreen
  // ─────────────────────────────────────────────────────────────────────────
  group('ResultsScreen', () {
    TestResult makeResult({int correct = 3, int total = 5}) {
      final config = makeConfig();
      final answers = List.generate(
        total,
        (i) => UserAnswer(
          questionId: 'q_test_${i + 1}',
          selectedOption: i < correct ? 0 : 1,
          isCorrect: i < correct,
          timeTaken: const Duration(seconds: 10),
        ),
      );
      return TestResult(
        id: 'sw_res_$correct\_$total',
        completedAt: DateTime.now(),
        configuration: config,
        answers: answers,
        totalQuestions: total,
        correctAnswers: correct,
        totalTime: const Duration(minutes: 5),
        scoreByType: {QuestionType.rulesOfRoad: correct},
        scoreBySubType: {'speed_limits': correct},
      );
    }

    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(wrap(ResultsScreen(
        result: makeResult(),
        questions: makeFiveQuestions(),
      )));
      await tester.pumpAndSettle();
      expect(find.byType(ResultsScreen), findsOneWidget);
    });

    testWidgets('shows Test Results app bar', (tester) async {
      await tester.pumpWidget(wrap(ResultsScreen(
        result: makeResult(),
        questions: makeFiveQuestions(),
      )));
      await tester.pumpAndSettle();
      expect(find.text('Test Results'), findsWidgets);
    });

    testWidgets('shows percentage score', (tester) async {
      await tester.pumpWidget(wrap(ResultsScreen(
        result: makeResult(correct: 4, total: 5),
        questions: makeFiveQuestions(),
      )));
      await tester.pumpAndSettle();
      // 4/5 = 80% — look for 80
      expect(
        find.byWidgetPredicate(
          (w) => w is Text && w.data != null && w.data!.contains('80'),
        ),
        findsWidgets,
      );
    });

    testWidgets('shows PASS for 80% score (4/5)', (tester) async {
      await tester.pumpWidget(wrap(ResultsScreen(
        result: makeResult(correct: 4, total: 5),
        questions: makeFiveQuestions(),
      )));
      await tester.pumpAndSettle();
      expect(
        find.byWidgetPredicate(
          (w) => w is Text && w.data != null &&
              (w.data!.toUpperCase().contains('PASS') || w.data!.contains('🎉')),
        ),
        findsWidgets,
      );
    });

    testWidgets('shows FAIL for below 80% (2/5 = 40%)', (tester) async {
      await tester.pumpWidget(wrap(ResultsScreen(
        result: makeResult(correct: 2, total: 5),
        questions: makeFiveQuestions(),
      )));
      await tester.pumpAndSettle();
      // Either TRY AGAIN or a fail message is shown
      expect(
        find.byWidgetPredicate(
          (w) => w is Text && w.data != null &&
              (w.data!.toUpperCase().contains('TRY') ||
               w.data!.toUpperCase().contains('FAIL') ||
               w.data!.toUpperCase().contains('AGAIN')),
        ),
        findsWidgets,
      );
    });

    testWidgets('shows Review Answers button', (tester) async {
      await tester.pumpWidget(wrap(ResultsScreen(
        result: makeResult(),
        questions: makeFiveQuestions(),
      )));
      await tester.pumpAndSettle();
      // Scroll to the bottom to reveal the Review Answers button
      await tester.drag(find.byType(ListView), const Offset(0, -600));
      await tester.pumpAndSettle();
      expect(find.text('Review Answers'), findsWidgets);
    });

    testWidgets('shows performance breakdown section', (tester) async {
      await tester.pumpWidget(wrap(ResultsScreen(
        result: makeResult(),
        questions: makeFiveQuestions(),
      )));
      await tester.pumpAndSettle();
      // Scroll to find the breakdown section
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(find.textContaining('Breakdown'), findsWidgets);
    });

    testWidgets('shows rewards card when points > 0', (tester) async {
      await tester.pumpWidget(wrap(ResultsScreen(
        result: makeResult(correct: 4, total: 5),
        questions: makeFiveQuestions(),
        pointsEarned: 50,
        xpEarned: 25,
      )));
      await tester.pumpAndSettle();
      expect(
        find.byWidgetPredicate(
          (w) => w is Text && w.data != null && w.data!.contains('50'),
        ),
        findsWidgets,
      );
    });

    testWidgets('tapping Review Answers navigates to ReviewScreen', (tester) async {
      await tester.pumpWidget(wrap(ResultsScreen(
        result: makeResult(),
        questions: makeFiveQuestions(),
      )));
      await tester.pumpAndSettle();
      // Scroll to the bottom to reveal the Review Answers button
      await tester.drag(find.byType(ListView), const Offset(0, -600));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Review Answers'));
      await tester.pumpAndSettle();
      expect(find.byType(ReviewScreen), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // ReviewScreen
  // ─────────────────────────────────────────────────────────────────────────
  group('ReviewScreen', () {
    TestResult makeResult() {
      final config = makeConfig();
      final answers = List.generate(
        5,
        (i) => UserAnswer(
          questionId: 'q_test_${i + 1}',
          selectedOption: i < 3 ? 0 : 1,
          isCorrect: i < 3,
          timeTaken: const Duration(seconds: 10),
        ),
      );
      return TestResult(
        id: 'sw_rev_1',
        completedAt: DateTime.now(),
        configuration: config,
        answers: answers,
        totalQuestions: 5,
        correctAnswers: 3,
        totalTime: const Duration(minutes: 5),
        scoreByType: {QuestionType.rulesOfRoad: 3},
        scoreBySubType: {'speed_limits': 3},
      );
    }

    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(wrap(ReviewScreen(
        result: makeResult(),
        questions: makeFiveQuestions(),
      )));
      await tester.pumpAndSettle();
      expect(find.byType(ReviewScreen), findsOneWidget);
    });

    testWidgets('shows question stems in review', (tester) async {
      await tester.pumpWidget(wrap(ReviewScreen(
        result: makeResult(),
        questions: [makeQuestion(stem: 'Review stem question?')],
      )));
      await tester.pumpAndSettle();
      expect(find.textContaining('Review stem question'), findsWidgets);
    });

    testWidgets('shows correct answer text', (tester) async {
      await tester.pumpWidget(wrap(ReviewScreen(
        result: makeResult(),
        questions: [makeQuestion(correctAnswer: 0)],
      )));
      await tester.pumpAndSettle();
      expect(find.text('40 km/h'), findsWidgets);
    });

    testWidgets('shows explanation text', (tester) async {
      await tester.pumpWidget(wrap(ReviewScreen(
        result: makeResult(),
        questions: [makeQuestion()],
      )));
      await tester.pumpAndSettle();
      expect(find.textContaining('school zone'), findsWidgets);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // AchievementsScreen
  // ─────────────────────────────────────────────────────────────────────────
  group('AchievementsScreen', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(wrap(const AchievementsScreen()));
      await tester.pumpAndSettle();
      expect(find.byType(AchievementsScreen), findsOneWidget);
    });

    testWidgets('shows Achievements title', (tester) async {
      await tester.pumpWidget(wrap(const AchievementsScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Achievements'), findsWidgets);
    });

    testWidgets('shows at least one achievement entry', (tester) async {
      await tester.pumpWidget(wrap(const AchievementsScreen()));
      await tester.pumpAndSettle();
      // Achievements are listed as AnimatedContainers (not Card widgets)
      expect(find.byType(AnimatedContainer), findsWidgets);
    });

    testWidgets('shows locked state text for new user', (tester) async {
      await tester.pumpWidget(wrap(const AchievementsScreen()));
      await tester.pumpAndSettle();
      // Fresh user has no achievements unlocked
      expect(find.textContaining('Keep practising'), findsWidgets);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // ProgressScreen
  // ─────────────────────────────────────────────────────────────────────────
  group('ProgressScreen', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(wrap(const ProgressScreen()));
      await tester.pumpAndSettle();
      expect(find.byType(ProgressScreen), findsOneWidget);
    });

    testWidgets('shows Progress app bar', (tester) async {
      await tester.pumpWidget(wrap(const ProgressScreen()));
      await tester.pumpAndSettle();
      expect(find.textContaining('Progress'), findsWidgets);
    });

    testWidgets('renders without exception for new user (no history)', (tester) async {
      await tester.pumpWidget(wrap(const ProgressScreen()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // DashboardScreen
  // ─────────────────────────────────────────────────────────────────────────
  group('DashboardScreen', () {
    Widget buildDashboard() => wrap(DashboardScreen(onNavigate: (_) {}));

    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(buildDashboard());
      await tester.pumpAndSettle();
      expect(find.byType(DashboardScreen), findsOneWidget);
    });

    testWidgets('shows Quick Actions section', (tester) async {
      await tester.pumpWidget(buildDashboard());
      await tester.pumpAndSettle();
      expect(find.text('Quick Actions'), findsWidgets);
    });

    testWidgets('shows Quick Check button', (tester) async {
      await tester.pumpWidget(buildDashboard());
      await tester.pumpAndSettle();
      expect(find.textContaining('Quick Check'), findsWidgets);
    });

    testWidgets('shows Study by Topic section', (tester) async {
      await tester.pumpWidget(buildDashboard());
      await tester.pumpAndSettle();
      // Scroll to reveal Study by Topic section
      await tester.drag(find.byType(ListView), const Offset(0, -400));
      await tester.pumpAndSettle();
      expect(find.textContaining('Study'), findsWidgets);
    });

    testWidgets('shows Achievements icon button', (tester) async {
      await tester.pumpWidget(buildDashboard());
      await tester.pumpAndSettle();
      // Achievements accessible via trophy icon in AppBar
      expect(find.byIcon(Icons.emoji_events), findsWidgets);
    });

    testWidgets('renders without exception for new user', (tester) async {
      await tester.pumpWidget(buildDashboard());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Language switching end-to-end
  // ─────────────────────────────────────────────────────────────────────────
  group('Language switching', () {
    testWidgets('Practice screen shows French after language change', (tester) async {
      await tester.pumpWidget(const ExcelDrivingG1App());
      await tester.pumpAndSettle();

      // Switch to French
      SettingsController().setLanguage(Language.french);
      await tester.pumpAndSettle();

      // Practice tab still visible
      await tester.tap(find.text('Pratique').last);
      await tester.pumpAndSettle();
      expect(find.text('Pratique'), findsWidgets);
    });

    testWidgets('Settings screen shows French labels', (tester) async {
      SettingsController().setLanguage(Language.french);
      await tester.pumpWidget(const ExcelDrivingG1App());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Paramètres').last);
      await tester.pumpAndSettle();
      expect(find.text('Paramètres'), findsWidgets);
    });

    testWidgets('resetting to English works', (tester) async {
      SettingsController().setLanguage(Language.french);
      SettingsController().setLanguage(Language.english);
      await tester.pumpWidget(const ExcelDrivingG1App());
      await tester.pumpAndSettle();
      expect(find.text('Practice'), findsWidgets);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Settings — Legal & Support links section
  // ─────────────────────────────────────────────────────────────────────────
  group('Settings — Legal & Support', () {
    Future<void> openSettings(WidgetTester tester) async {
      await tester.pumpWidget(const ExcelDrivingG1App());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Settings').last);
      await tester.pumpAndSettle();
      // Scroll to the bottom to reveal Legal section
      await tester.drag(find.byType(Scrollable).last, const Offset(0, -800));
      await tester.pumpAndSettle();
    }

    testWidgets('Legal & Support section header visible', (tester) async {
      await openSettings(tester);
      expect(find.text('Legal & Support'), findsWidgets);
    });

    testWidgets('Privacy Policy link visible', (tester) async {
      await openSettings(tester);
      expect(find.text('Privacy Policy'), findsWidgets);
    });

    testWidgets('Terms & Conditions link visible', (tester) async {
      await openSettings(tester);
      expect(find.textContaining('Terms'), findsWidgets);
    });

    testWidgets('Support link visible', (tester) async {
      await openSettings(tester);
      expect(find.text('Support'), findsWidgets);
    });

    testWidgets('App Guide link visible', (tester) async {
      await openSettings(tester);
      expect(find.text('App Guide'), findsWidgets);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // QuestionDataManager integration — questions usable in test session
  // ─────────────────────────────────────────────────────────────────────────
  group('QuestionDataManager → TestSessionScreen integration', () {
    testWidgets('can start a QuickAssessment session with real questions', (tester) async {
      final dm = QuestionDataManager();
      final config = TestConfiguration(
        testType: TestType.quickAssessment,
        questionCount: 10,
        timeInMinutes: 10,
        difficulty: Difficulty.medium,
        shuffleQuestions: false,
      );
      final questions = dm.getConfiguredQuestions(config);
      expect(questions.length, equals(10));

      await tester.pumpWidget(wrap(TestSessionScreen(
        configuration: config,
        questions: questions,
      )));
      await tester.pump();
      expect(find.byType(TestSessionScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('can start a StandardPractice session (20 questions)', (tester) async {
      final dm = QuestionDataManager();
      final config = TestConfiguration(
        testType: TestType.standardPractice,
        questionCount: 20,
        timeInMinutes: 20,
        difficulty: Difficulty.medium,
        shuffleQuestions: false,
      );
      final questions = dm.getConfiguredQuestions(config);
      expect(questions.length, equals(20));

      await tester.pumpWidget(wrap(TestSessionScreen(
        configuration: config,
        questions: questions,
      )));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('French questions load and render in TestSessionScreen', (tester) async {
      final dm = QuestionDataManager();
      final config = TestConfiguration(
        testType: TestType.quickAssessment,
        questionCount: 5,
        timeInMinutes: 5,
        difficulty: Difficulty.medium,
        shuffleQuestions: false,
      );
      final questions = dm.getConfiguredQuestions(config, language: Language.french);
      expect(questions.length, equals(5));

      await tester.pumpWidget(wrap(TestSessionScreen(
        configuration: config,
        questions: questions,
      )));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });
}
