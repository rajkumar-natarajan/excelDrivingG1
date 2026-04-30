import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:excel_driving_g1/main.dart';
import 'package:excel_driving_g1/screens/settings_screen.dart';
import 'package:excel_driving_g1/screens/practice_screen.dart';
import 'package:excel_driving_g1/screens/progress_screen.dart';
import 'package:excel_driving_g1/screens/study_guide_screen.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  // ─────────────────────────────────────────────────────────────────────────
  // App initialisation
  // ─────────────────────────────────────────────────────────────────────────
  group('App bootstrap', () {
    testWidgets('App builds without errors', (tester) async {
      await tester.pumpWidget(const ExcelDrivingG1App());
      await tester.pumpAndSettle();
      expect(find.byType(ExcelDrivingG1App), findsOneWidget);
    });

    testWidgets('title is ExcelDriving G1', (tester) async {
      await tester.pumpWidget(const ExcelDrivingG1App());
      await tester.pumpAndSettle();
      // MaterialApp with title 'ExcelDriving G1'
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.title, equals('ExcelDriving G1'));
    });

    testWidgets('debug banner is hidden', (tester) async {
      await tester.pumpWidget(const ExcelDrivingG1App());
      await tester.pumpAndSettle();
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.debugShowCheckedModeBanner, isFalse);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Bottom navigation bar structure
  // ─────────────────────────────────────────────────────────────────────────
  group('Navigation bar structure', () {
    testWidgets('navigation bar has 5 destinations', (tester) async {
      await tester.pumpWidget(const ExcelDrivingG1App());
      await tester.pumpAndSettle();
      expect(find.byType(NavigationDestination), findsNWidgets(5));
    });

    testWidgets('navigation bar shows Home label', (tester) async {
      await tester.pumpWidget(const ExcelDrivingG1App());
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsWidgets);
    });

    testWidgets('navigation bar shows Practice label', (tester) async {
      await tester.pumpWidget(const ExcelDrivingG1App());
      await tester.pumpAndSettle();
      expect(find.text('Practice'), findsWidgets);
    });

    testWidgets('navigation bar shows Progress label', (tester) async {
      await tester.pumpWidget(const ExcelDrivingG1App());
      await tester.pumpAndSettle();
      expect(find.text('Progress'), findsWidgets);
    });

    testWidgets('navigation bar shows Study label', (tester) async {
      await tester.pumpWidget(const ExcelDrivingG1App());
      await tester.pumpAndSettle();
      expect(find.text('Study'), findsWidgets);
    });

    testWidgets('navigation bar shows Settings label', (tester) async {
      await tester.pumpWidget(const ExcelDrivingG1App());
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsWidgets);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Tab navigation
  // ─────────────────────────────────────────────────────────────────────────
  group('Tab navigation', () {
    testWidgets('tapping Practice tab shows PracticeScreen', (tester) async {
      await tester.pumpWidget(const ExcelDrivingG1App());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Practice').last);
      await tester.pumpAndSettle();
      expect(find.byType(PracticeScreen), findsOneWidget);
    });

    testWidgets('tapping Progress tab shows ProgressScreen', (tester) async {
      await tester.pumpWidget(const ExcelDrivingG1App());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Progress').last);
      await tester.pumpAndSettle();
      expect(find.byType(ProgressScreen), findsOneWidget);
    });

    testWidgets('tapping Study tab shows StudyGuideScreen', (tester) async {
      await tester.pumpWidget(const ExcelDrivingG1App());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Study').last);
      await tester.pumpAndSettle();
      expect(find.byType(StudyGuideScreen), findsOneWidget);
    });

    testWidgets('tapping Settings tab shows SettingsScreen', (tester) async {
      await tester.pumpWidget(const ExcelDrivingG1App());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Settings').last);
      await tester.pumpAndSettle();
      expect(find.byType(SettingsScreen), findsOneWidget);
    });

    testWidgets('tapping Home tab after another tab returns to Home', (tester) async {
      await tester.pumpWidget(const ExcelDrivingG1App());
      await tester.pumpAndSettle();
      // Go to Settings
      await tester.tap(find.text('Settings').last);
      await tester.pumpAndSettle();
      // Come back to Home
      await tester.tap(find.text('Home').last);
      await tester.pumpAndSettle();
      // MainNavigation is always present; Home tab label is visible
      expect(find.byType(MainNavigation), findsOneWidget);
      expect(find.text('Home'), findsWidgets);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Settings screen widgets
  // ─────────────────────────────────────────────────────────────────────────
  group('Settings screen content', () {
    Future<void> openSettings(WidgetTester tester) async {
      await tester.pumpWidget(const ExcelDrivingG1App());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Settings').last);
      await tester.pumpAndSettle();
    }

    testWidgets('Shows Settings app bar title', (tester) async {
      await openSettings(tester);
      expect(find.text('Settings'), findsWidgets);
    });

    testWidgets('Shows Theme setting', (tester) async {
      await openSettings(tester);
      expect(find.text('Theme'), findsWidgets);
    });

    testWidgets('Shows Default Difficulty setting', (tester) async {
      await openSettings(tester);
      expect(find.text('Default Difficulty'), findsWidgets);
    });

    testWidgets('Shows Clear All Progress button', (tester) async {
      await openSettings(tester);
      expect(find.text('Clear All Data'), findsWidgets);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Dark mode rendering
  // ─────────────────────────────────────────────────────────────────────────
  group('Theme rendering', () {
    testWidgets('App renders without errors in light theme', (tester) async {
      await tester.pumpWidget(const ExcelDrivingG1App());
      await tester.pumpAndSettle();
      // No exception thrown = light theme renders fine
      expect(tester.takeException(), isNull);
    });

    testWidgets('App has both light and dark themes defined', (tester) async {
      await tester.pumpWidget(const ExcelDrivingG1App());
      await tester.pumpAndSettle();
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.theme, isNotNull);
      expect(app.darkTheme, isNotNull);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Study Guide screen
  // ─────────────────────────────────────────────────────────────────────────
  group('Study Guide screen', () {
    testWidgets('Study Guide screen builds', (tester) async {
      await tester.pumpWidget(const ExcelDrivingG1App());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Study').last);
      await tester.pumpAndSettle();
      expect(find.byType(StudyGuideScreen), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Clear progress dialog
  // ─────────────────────────────────────────────────────────────────────────
  group('Clear progress dialog', () {
    testWidgets('tapping Clear All Progress shows confirmation dialog', (tester) async {
      await tester.pumpWidget(const ExcelDrivingG1App());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Settings').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Clear All Data'));
      await tester.pumpAndSettle();
      expect(find.text('Confirm Delete'), findsOneWidget);
    });

    testWidgets('Cancel dismisses the dialog', (tester) async {
      await tester.pumpWidget(const ExcelDrivingG1App());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Settings').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Clear All Data'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Confirm Delete'), findsNothing);
    });
  });
}

