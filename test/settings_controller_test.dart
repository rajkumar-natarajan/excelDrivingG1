import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:excel_driving_g1/controllers/settings_controller.dart';
import 'package:excel_driving_g1/models/question.dart';

void main() {
  late SettingsController controller;

  setUp(() {
    // SettingsController is a singleton — reset to known state before each test
    controller = SettingsController();
    controller.setThemeMode(ThemeMode.system);
    controller.setDifficulty(Difficulty.medium);
    controller.toggleNotifications(true);
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Default values
  // ─────────────────────────────────────────────────────────────────────────
  group('SettingsController - Default state', () {
    test('default difficulty is medium', () {
      expect(controller.defaultDifficulty, equals(Difficulty.medium));
    });

    test('difficulty getter matches defaultDifficulty', () {
      expect(controller.difficulty, equals(controller.defaultDifficulty));
    });

    test('default themeMode is system', () {
      expect(controller.themeMode, equals(ThemeMode.system));
    });

    test('notifications enabled by default', () {
      expect(controller.notificationsEnabled, isTrue);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Theme mode
  // ─────────────────────────────────────────────────────────────────────────
  group('SettingsController - Theme Mode', () {
    test('setThemeMode to dark stores dark', () {
      controller.setThemeMode(ThemeMode.dark);
      expect(controller.themeMode, equals(ThemeMode.dark));
    });

    test('setThemeMode to light stores light', () {
      controller.setThemeMode(ThemeMode.light);
      expect(controller.themeMode, equals(ThemeMode.light));
    });

    test('toggleTheme(true) sets dark mode', () {
      controller.toggleTheme(true);
      expect(controller.themeMode, equals(ThemeMode.dark));
    });

    test('toggleTheme(false) sets light mode', () {
      controller.toggleTheme(false);
      expect(controller.themeMode, equals(ThemeMode.light));
    });

    test('setThemeMode notifies listeners', () {
      bool notified = false;
      controller.addListener(() => notified = true);
      controller.setThemeMode(ThemeMode.dark);
      expect(notified, isTrue);
      controller.removeListener(() {});
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Difficulty
  // ─────────────────────────────────────────────────────────────────────────
  group('SettingsController - Difficulty', () {
    test('setDifficulty to easy stores easy', () {
      controller.setDifficulty(Difficulty.easy);
      expect(controller.defaultDifficulty, equals(Difficulty.easy));
    });

    test('setDifficulty to hard stores hard', () {
      controller.setDifficulty(Difficulty.hard);
      expect(controller.defaultDifficulty, equals(Difficulty.hard));
    });

    test('setDifficulty to medium keeps medium', () {
      controller.setDifficulty(Difficulty.hard);
      controller.setDifficulty(Difficulty.medium);
      expect(controller.defaultDifficulty, equals(Difficulty.medium));
    });

    test('setDifficulty notifies listeners', () {
      bool notified = false;
      controller.addListener(() => notified = true);
      controller.setDifficulty(Difficulty.easy);
      expect(notified, isTrue);
    });

    test('difficulty getter always matches defaultDifficulty after change', () {
      controller.setDifficulty(Difficulty.hard);
      expect(controller.difficulty, equals(Difficulty.hard));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Notifications
  // ─────────────────────────────────────────────────────────────────────────
  group('SettingsController - Notifications', () {
    test('toggleNotifications(false) disables notifications', () {
      controller.toggleNotifications(false);
      expect(controller.notificationsEnabled, isFalse);
    });

    test('toggleNotifications(true) re-enables notifications', () {
      controller.toggleNotifications(false);
      controller.toggleNotifications(true);
      expect(controller.notificationsEnabled, isTrue);
    });

    test('toggleNotifications notifies listeners', () {
      bool notified = false;
      controller.addListener(() => notified = true);
      controller.toggleNotifications(false);
      expect(notified, isTrue);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // ChangeNotifier behaviour
  // ─────────────────────────────────────────────────────────────────────────
  group('SettingsController - ChangeNotifier', () {
    test('is a ChangeNotifier', () {
      expect(controller, isA<ChangeNotifier>());
    });

    test('singleton — same instance returned every time', () {
      final c1 = SettingsController();
      final c2 = SettingsController();
      expect(identical(c1, c2), isTrue);
    });

    test('multiple listeners all notified on change', () {
      int count = 0;
      void listener() => count++;
      controller.addListener(listener);
      controller.setThemeMode(ThemeMode.dark);
      controller.setDifficulty(Difficulty.easy);
      expect(count, greaterThanOrEqualTo(2));
      controller.removeListener(listener);
    });
  });
}
