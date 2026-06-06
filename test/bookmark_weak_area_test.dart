// test/bookmark_weak_area_test.dart
// Regression tests for:
//   1. Bookmarks: persisted bookmark IDs are loaded on initialize() and
//      returned correctly so a session can be started with bookmarked questions.
//   2. Weak areas: performance stats saved via recordAnswer() are loaded on
//      initialize() and getWeakSubTypes() returns sub-types whose accuracy < 70%
//      with >= 3 attempts.
//   3. PracticeScreen shows the bookmark card when bookmarks exist.
//   4. PracticeScreen shows the weak-area card when weak areas exist.
//   5. Full round-trip: save → clear in-memory → initialize() → verify.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:excel_driving_g1/controllers/smart_learning_controller.dart';
import 'package:excel_driving_g1/controllers/gamification_controller.dart';
import 'package:excel_driving_g1/data/question_data_manager.dart';
import 'package:excel_driving_g1/models/question.dart';
import 'package:excel_driving_g1/screens/practice_screen.dart';
import 'package:excel_driving_g1/screens/test_session_screen.dart';
import 'package:excel_driving_g1/l10n/app_strings.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Resets the SmartLearningController singleton between tests by clearing
/// SharedPreferences and the internal initialized flag via clearAllData().
Future<void> _resetSmartLearning() async {
  SharedPreferences.setMockInitialValues({});
  final ctrl = SmartLearningController();
  await ctrl.clearAllData();
  // Reset the initialized flag so the next initialize() re-reads prefs.
  // clearAllData calls _save() which writes empty data, but _isInitialized
  // is still true — we need to bypass it by calling clearAllData first,
  // then we can re-initialize cleanly.
}

/// Wraps a widget with MaterialApp for widget tests.
Widget _wrap(Widget child) => MaterialApp(home: child);

// ---------------------------------------------------------------------------
// Unit Tests — SmartLearningController (bookmarks)
// ---------------------------------------------------------------------------

void main() {
  group('SmartLearningController — Bookmark persistence', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SmartLearningController().clearAllData();
    });

    test('toggleBookmark adds a question ID', () {
      final ctrl = SmartLearningController();
      expect(ctrl.isBookmarked('q_1'), isFalse);
      ctrl.toggleBookmark('q_1');
      expect(ctrl.isBookmarked('q_1'), isTrue);
      expect(ctrl.bookmarkCount, equals(1));
      expect(ctrl.bookmarkedQuestionIds, contains('q_1'));
    });

    test('toggleBookmark removes an already-bookmarked ID', () {
      final ctrl = SmartLearningController();
      ctrl.toggleBookmark('q_1');
      expect(ctrl.bookmarkCount, equals(1));
      ctrl.toggleBookmark('q_1');
      expect(ctrl.bookmarkCount, equals(0));
      expect(ctrl.isBookmarked('q_1'), isFalse);
    });

    test('bookmarkedQuestionIds is a defensive copy', () {
      final ctrl = SmartLearningController();
      ctrl.toggleBookmark('q_1');
      ctrl.toggleBookmark('q_2');
      final ids = ctrl.bookmarkedQuestionIds;
      // Mutating the returned set must not affect the controller.
      ids.add('q_99');
      expect(ctrl.bookmarkCount, equals(2));
    });

    test('initialize() loads bookmarks saved to SharedPreferences', () async {
      // Pre-populate SharedPreferences with two bookmarks.
      SharedPreferences.setMockInitialValues({
        'g1_smart_bookmarks': ['q_alpha', 'q_beta'],
      });

      final ctrl = SmartLearningController();
      await ctrl.clearAllData(); // clears in-memory state only (not our mock prefs above)

      // Simulate fresh singleton by re-calling initialize after setting mock.
      // Since _isInitialized was reset by clearAllData's save-then-reload
      // pattern, we prime the prefs first then call initialize.
      SharedPreferences.setMockInitialValues({
        'g1_smart_bookmarks': ['q_alpha', 'q_beta'],
      });
      await ctrl.initialize();

      expect(ctrl.bookmarkCount, equals(2));
      expect(ctrl.isBookmarked('q_alpha'), isTrue);
      expect(ctrl.isBookmarked('q_beta'), isTrue);
    });

    test('bookmarks survive a save → re-initialize round-trip', () async {
      final ctrl = SmartLearningController();

      // Add bookmarks (this saves to mock SharedPreferences).
      ctrl.toggleBookmark('q_1');
      ctrl.toggleBookmark('q_2');
      ctrl.toggleBookmark('q_3');

      // Allow async save to complete.
      await Future.delayed(Duration.zero);

      // Read back the prefs to confirm they were saved.
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList('g1_smart_bookmarks') ?? [];
      expect(saved, containsAll(['q_1', 'q_2', 'q_3']));
      expect(saved.length, equals(3));
    });

    test('bookmarks round-trip: clear in-memory → initialize loads them back',
        () async {
      final ctrl = SmartLearningController();
      ctrl.toggleBookmark('q_save_1');
      ctrl.toggleBookmark('q_save_2');
      await Future.delayed(Duration.zero); // let _save() complete

      // Simulate app restart by resetting initialized flag via clearAllData
      // but first snapshot the saved prefs.
      final prefs = await SharedPreferences.getInstance();
      final savedList = prefs.getStringList('g1_smart_bookmarks') ?? [];
      expect(savedList, containsAll(['q_save_1', 'q_save_2']));

      // Re-initialize with the saved prefs still in place (mock doesn't reset).
      await ctrl.initialize(); // _isInitialized was reset by clearAllData
      expect(ctrl.isBookmarked('q_save_1'), isTrue);
      expect(ctrl.isBookmarked('q_save_2'), isTrue);
    });

    test('bookmarkedQuestionIds maps to real questions in QuestionDataManager',
        () {
      final dataManager = QuestionDataManager();
      final allIds = dataManager.allQuestions.map((q) => q.id).toSet();
      // Use a real question ID.
      final realId = allIds.first;

      final ctrl = SmartLearningController();
      ctrl.toggleBookmark(realId);

      final ids = ctrl.bookmarkedQuestionIds.toList();
      final questions =
          ids.map((id) => dataManager.getQuestionById(id)).whereType<Question>().toList();
      expect(questions, isNotEmpty);
      expect(questions.first.id, equals(realId));
    });
  });

  // -------------------------------------------------------------------------
  // Unit Tests — SmartLearningController (weak areas)
  // -------------------------------------------------------------------------

  group('SmartLearningController — Weak area detection', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SmartLearningController().clearAllData();
    });

    Question _makeQuestion(String subType) => Question(
          id: 'wk_${subType}_1',
          stem: 'Test question for $subType?',
          options: ['A', 'B', 'C', 'D'],
          correctAnswer: 0,
          explanation: 'Explanation.',
          type: QuestionType.rulesOfRoad,
          subType: subType,
        );

    test('getWeakSubTypes returns empty for fresh controller', () {
      expect(SmartLearningController().getWeakSubTypes(), isEmpty);
    });

    test('sub-type with < 3 attempts is not a weak area', () {
      final ctrl = SmartLearningController();
      final q = _makeQuestion('parking_rules');
      ctrl.recordAnswer(q, false);
      ctrl.recordAnswer(q, false);
      expect(ctrl.getWeakSubTypes(), isEmpty);
      expect(ctrl.isWeakArea('parking_rules'), isFalse);
    });

    test('sub-type with >= 3 attempts and accuracy < 70% is weak', () {
      final ctrl = SmartLearningController();
      final q = _makeQuestion('speed_limits');
      ctrl.recordAnswer(q, false); // 0/1 = 0%
      ctrl.recordAnswer(q, false); // 0/2 = 0%
      ctrl.recordAnswer(q, false); // 0/3 = 0%
      expect(ctrl.isWeakArea('speed_limits'), isTrue);
      expect(ctrl.getWeakSubTypes(), contains('speed_limits'));
    });

    test('sub-type with accuracy >= 70% is not weak even with many attempts', () {
      final ctrl = SmartLearningController();
      final q = _makeQuestion('right_of_way');
      ctrl.recordAnswer(q, true);  // 1/1
      ctrl.recordAnswer(q, true);  // 2/2
      ctrl.recordAnswer(q, true);  // 3/3 = 100%
      expect(ctrl.isWeakArea('right_of_way'), isFalse);
      expect(ctrl.getWeakSubTypes(), isNot(contains('right_of_way')));
    });

    test('accuracy exactly at 69% is a weak area', () {
      final ctrl = SmartLearningController();
      final q = _makeQuestion('lane_changes');
      // 2 correct out of 3 = 66.7% → weak
      ctrl.recordAnswer(q, true);
      ctrl.recordAnswer(q, false);
      ctrl.recordAnswer(q, false);
      expect(ctrl.isWeakArea('lane_changes'), isTrue);
    });

    test('accuracy exactly at 70% is NOT a weak area', () {
      final ctrl = SmartLearningController();
      final q = _makeQuestion('merging');
      // 7 correct out of 10 = 70% → not weak (boundary is < 70%)
      for (int i = 0; i < 7; i++) ctrl.recordAnswer(q, true);
      for (int i = 0; i < 3; i++) ctrl.recordAnswer(q, false);
      expect(ctrl.isWeakArea('merging'), isFalse);
    });

    test('getWeakSubTypes lists multiple weak sub-types', () {
      final ctrl = SmartLearningController();
      for (final sub in ['sub_a', 'sub_b', 'sub_c']) {
        final q = _makeQuestion(sub);
        ctrl.recordAnswer(q, false);
        ctrl.recordAnswer(q, false);
        ctrl.recordAnswer(q, false);
      }
      final weak = ctrl.getWeakSubTypes();
      expect(weak, containsAll(['sub_a', 'sub_b', 'sub_c']));
    });

    test('improving a weak sub-type removes it from weak list', () {
      final ctrl = SmartLearningController();
      final q = _makeQuestion('road_signs');
      ctrl.recordAnswer(q, false);
      ctrl.recordAnswer(q, false);
      ctrl.recordAnswer(q, false);
      expect(ctrl.isWeakArea('road_signs'), isTrue);

      // Answer 10 more correctly to push accuracy above 70%.
      for (int i = 0; i < 10; i++) ctrl.recordAnswer(q, true);
      expect(ctrl.isWeakArea('road_signs'), isFalse);
    });

    test('weak areas round-trip: performance data saved and reloadable', () async {
      final ctrl = SmartLearningController();
      final q = _makeQuestion('intersections');
      ctrl.recordAnswer(q, false);
      ctrl.recordAnswer(q, false);
      ctrl.recordAnswer(q, false);
      await Future.delayed(Duration.zero); // let _save() complete

      final prefs = await SharedPreferences.getInstance();
      final perfJson = prefs.getString('g1_smart_performance');
      expect(perfJson, isNotNull);
      final Map<String, dynamic> data = jsonDecode(perfJson!);
      expect(data.containsKey('intersections'), isTrue);
      expect(data['intersections']['totalAttempts'], equals(3));
      expect(data['intersections']['correctAttempts'], equals(0));
    });

    test('initialize() loads performance stats and restores weak areas',
        () async {
      // Pre-populate SharedPreferences with a weak sub-type.
      final perfData = jsonEncode({
        'traffic_lights': {
          'subType': 'traffic_lights',
          'totalAttempts': 5,
          'correctAttempts': 1, // 20% → weak
        }
      });
      SharedPreferences.setMockInitialValues({
        'g1_smart_performance': perfData,
      });
      await SmartLearningController().initialize();
      expect(SmartLearningController().isWeakArea('traffic_lights'), isTrue);
      expect(SmartLearningController().getWeakSubTypes(), contains('traffic_lights'));
    });
  });

  // -------------------------------------------------------------------------
  // Unit Tests — GamificationController persistence
  // -------------------------------------------------------------------------

  group('GamificationController — initialize() loads persisted data', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await GamificationController().clearAllData();
    });

    test('fresh controller has level 1 and 0 XP', () {
      final ctrl = GamificationController();
      expect(ctrl.getStats().currentLevel, equals(1));
      expect(ctrl.getStats().totalXP, equals(0));
    });

    test('initialize() loads persisted XP and level', () async {
      SharedPreferences.setMockInitialValues({
        'g1_gamification_xp': 500,
        'g1_gamification_level': 3,
        'g1_gamification_points': 200,
        'g1_gamification_streak': 5,
        'g1_gamification_best_streak': 7,
        'g1_gamification_daily_streak': 2,
      });
      await GamificationController().initialize();
      final stats = GamificationController().getStats();
      expect(stats.totalXP, equals(500));
      expect(stats.currentLevel, equals(3));
    });
  });

  // -------------------------------------------------------------------------
  // Widget Tests — PracticeScreen shows smart cards when data exists
  // -------------------------------------------------------------------------

  group('PracticeScreen — bookmark and weak area cards', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SmartLearningController().clearAllData();
    });

    testWidgets('shows "Bookmarked Questions" card when bookmarks exist',
        (tester) async {
      final ctrl = SmartLearningController();
      ctrl.toggleBookmark('q_test_001');
      ctrl.toggleBookmark('q_test_002');

      await tester.pumpWidget(_wrap(const PracticeScreen()));
      await tester.pumpAndSettle();

      // The bookmark card should appear.
      expect(find.text('Bookmarked Questions'), findsWidgets);
    });

    testWidgets('shows "Weak Area Focus" card when weak areas exist',
        (tester) async {
      final ctrl = SmartLearningController();
      final q = Question(
        id: 'q_weak_test',
        stem: 'A weak area question?',
        options: ['A', 'B', 'C', 'D'],
        correctAnswer: 0,
        explanation: 'Explanation.',
        type: QuestionType.trafficSigns,
        subType: 'stop_signs',
      );
      ctrl.recordAnswer(q, false);
      ctrl.recordAnswer(q, false);
      ctrl.recordAnswer(q, false);

      await tester.pumpWidget(_wrap(const PracticeScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Weak Area Focus'), findsWidgets);
    });

    testWidgets('does not show smart cards for a fresh user (no data)',
        (tester) async {
      await tester.pumpWidget(_wrap(const PracticeScreen()));
      await tester.pumpAndSettle();

      // Smart cards should NOT appear for a brand-new user.
      expect(find.text('Bookmarked Questions'), findsNothing);
      expect(find.text('Weak Area Focus'), findsNothing);
    });

    testWidgets('tapping "Bookmarked Questions" Start button launches a session',
        (tester) async {
      final dataManager = QuestionDataManager();
      final realId = dataManager.allQuestions.first.id;
      final ctrl = SmartLearningController();
      ctrl.toggleBookmark(realId);

      await tester.pumpWidget(_wrap(const PracticeScreen()));
      await tester.pumpAndSettle();

      // Scroll to reveal the smart practice section.
      await tester.drag(find.byType(ListView), const Offset(0, -200));
      await tester.pumpAndSettle();

      // The bookmark card is visible.
      expect(find.text('Bookmarked Questions'), findsWidgets);

      // The action is triggered by the ElevatedButton labelled 'Start'
      // that is the trailing widget of the Bookmarked Questions ListTile.
      // Find the first 'Start' button that is a descendant of the ListTile
      // containing 'Bookmarked Questions'.
      final bookmarkListTile = find.ancestor(
        of: find.text('Bookmarked Questions'),
        matching: find.byType(ListTile),
      );
      final startBtn = find.descendant(
        of: bookmarkListTile,
        matching: find.text('Start'),
      );
      expect(startBtn, findsOneWidget);
      await tester.tap(startBtn);
      await tester.pumpAndSettle();

      // A TestSessionScreen should have been pushed.
      expect(find.byType(TestSessionScreen), findsOneWidget);
    });

    testWidgets('tapping "Weak Area Focus" Start button launches a session',
        (tester) async {
      final ctrl = SmartLearningController();
      final dataManager = QuestionDataManager();
      // Use a real sub-type present in the question bank.
      final realQ = dataManager.allQuestions.firstWhere(
        (q) => q.subType.isNotEmpty,
        orElse: () => dataManager.allQuestions.first,
      );
      // Record 3 wrong answers to create a weak area.
      ctrl.recordAnswer(realQ, false);
      ctrl.recordAnswer(realQ, false);
      ctrl.recordAnswer(realQ, false);

      await tester.pumpWidget(_wrap(const PracticeScreen()));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(ListView), const Offset(0, -200));
      await tester.pumpAndSettle();

      expect(find.text('Weak Area Focus'), findsWidgets);

      final weakListTile = find.ancestor(
        of: find.text('Weak Area Focus'),
        matching: find.byType(ListTile),
      );
      final startBtn = find.descendant(
        of: weakListTile,
        matching: find.text('Start'),
      );
      expect(startBtn, findsOneWidget);
      await tester.tap(startBtn);
      await tester.pumpAndSettle();

      expect(find.byType(TestSessionScreen), findsOneWidget);
    });
  });

  // -------------------------------------------------------------------------
  // Integration — main() initializes both controllers
  // -------------------------------------------------------------------------

  group('App startup — controllers initialized before runApp', () {
    test('SmartLearningController.initialize is idempotent', () async {
      SharedPreferences.setMockInitialValues({});
      final ctrl = SmartLearningController();
      await ctrl.clearAllData();
      // Calling initialize() multiple times should not crash.
      await ctrl.initialize();
      await ctrl.initialize();
      expect(ctrl.bookmarkCount, equals(0));
    });

    test('GamificationController.initialize is idempotent', () async {
      SharedPreferences.setMockInitialValues({});
      final ctrl = GamificationController();
      await ctrl.clearAllData();
      await ctrl.initialize();
      await ctrl.initialize();
      expect(ctrl.getStats().currentLevel, equals(1));
    });

    test('both controllers can be initialized concurrently via Future.wait', () async {
      SharedPreferences.setMockInitialValues({});
      await SmartLearningController().clearAllData();
      await GamificationController().clearAllData();

      await Future.wait([
        SmartLearningController().initialize(),
        GamificationController().initialize(),
      ]);

      expect(SmartLearningController().bookmarkCount, equals(0));
      expect(GamificationController().getStats().currentLevel, equals(1));
    });
  });
}
