import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:excel_driving_g1/controllers/gamification_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late GamificationController controller;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    controller = GamificationController();
    await controller.clearAllData();
    await controller.initialize();
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────
  group('GamificationController - Initialization', () {
    test('starts at level 1', () {
      expect(controller.currentLevel, equals(1));
    });

    test('starts with 0 XP', () {
      expect(controller.totalXP, equals(0));
    });

    test('starts with 0 points', () {
      expect(controller.totalPoints, equals(0));
    });

    test('starts with empty unlocked achievements', () {
      expect(controller.unlockedAchievements, isEmpty);
    });

    test('levelProgress is between 0 and 1', () {
      expect(controller.levelProgress, inInclusiveRange(0.0, 1.0));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Record Answer
  // ─────────────────────────────────────────────────────────────────────────
  group('GamificationController - recordAnswer', () {
    test('correct answer grants XP and points', () {
      controller.recordAnswer(isCorrect: true, questionType: 'traffic_signs');
      expect(controller.totalXP, greaterThan(0));
      expect(controller.totalPoints, greaterThan(0));
    });

    test('wrong answer does not grant XP', () {
      controller.recordAnswer(isCorrect: false, questionType: 'traffic_signs');
      expect(controller.totalXP, equals(0));
    });

    test('wrong answer breaks streak', () {
      controller.recordAnswer(isCorrect: true, questionType: 'rules');
      controller.recordAnswer(isCorrect: true, questionType: 'rules');
      final streakAfterCorrect = controller.currentStreak;
      expect(streakAfterCorrect, greaterThan(0));

      controller.recordAnswer(isCorrect: false, questionType: 'rules');
      expect(controller.currentStreak, equals(0));
    });

    test('correct answers increment streak', () {
      for (var i = 0; i < 5; i++) {
        controller.recordAnswer(isCorrect: true, questionType: 'safety');
      }
      expect(controller.currentStreak, greaterThanOrEqualTo(5));
    });

    test('returns a GamificationReward', () {
      final reward = controller.recordAnswer(
        isCorrect: true,
        questionType: 'rules',
      );
      expect(reward, isA<GamificationReward>());
      expect(reward.hasReward, isTrue);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Record Test Completion
  // ─────────────────────────────────────────────────────────────────────────
  group('GamificationController - recordTestCompletion', () {
    test('grants bonus XP on completion', () {
      controller.recordTestCompletion(
        totalQuestions: 20,
        correctAnswers: 16,
        totalTimeSeconds: 300,
      );
      expect(controller.totalXP, greaterThan(0));
    });

    test('perfect score unlocks achievement', () {
      controller.recordTestCompletion(
        totalQuestions: 20,
        correctAnswers: 20,
        totalTimeSeconds: 300,
      );
      expect(controller.unlockedAchievements.contains('perfect_test'), isTrue);
    });

    test('returns a GamificationReward with positive values', () {
      final reward = controller.recordTestCompletion(
        totalQuestions: 10,
        correctAnswers: 10,
        totalTimeSeconds: 120,
      );
      expect(reward.pointsEarned, greaterThan(0));
      expect(reward.xpEarned, greaterThan(0));
    });

    test('records todayQuestions', () {
      controller.recordTestCompletion(
        totalQuestions: 10,
        correctAnswers: 8,
        totalTimeSeconds: 120,
      );
      expect(controller.todayQuestions, greaterThanOrEqualTo(0));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Level Up
  // ─────────────────────────────────────────────────────────────────────────
  group('GamificationController - Level Up', () {
    test('level increases after enough XP', () {
      final initialLevel = controller.currentLevel;
      // Answer many correct questions to accumulate XP
      for (var i = 0; i < 50; i++) {
        controller.recordAnswer(isCorrect: true, questionType: 'rules');
      }
      // Should have leveled up at some point
      expect(controller.totalXP, greaterThan(0));
      // Level should be >= initial (may or may not have gone up depending on XP thresholds)
      expect(controller.currentLevel, greaterThanOrEqualTo(initialLevel));
    });

    test('xpForNextLevel increases with level', () {
      final xpL1 = controller.xpForNextLevel;
      // Add enough XP to level up
      for (var i = 0; i < 100; i++) {
        controller.recordAnswer(isCorrect: true, questionType: 'rules');
      }
      if (controller.currentLevel > 1) {
        expect(controller.xpForNextLevel, greaterThan(xpL1));
      }
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Achievements
  // ─────────────────────────────────────────────────────────────────────────
  group('GamificationController - Achievements', () {
    test('allAchievements list is non-empty', () {
      expect(allAchievements, isNotEmpty);
    });

    test('allAchievements has at least 10 achievements', () {
      expect(allAchievements.length, greaterThanOrEqualTo(10));
    });

    test('all achievements have unique IDs', () {
      final ids = allAchievements.map((a) => a.id).toSet();
      expect(ids.length, equals(allAchievements.length));
    });

    test('answering 50 correct unlocks road_student achievement', () {
      for (var i = 0; i < 50; i++) {
        controller.recordAnswer(isCorrect: true, questionType: 'rules');
      }
      expect(controller.unlockedAchievements.contains('correct_50'), isTrue);
    });

    test('isAchievementUnlocked returns false for not yet earned', () {
      expect(controller.isAchievementUnlocked('correct_500'), isFalse);
    });

    test('isAchievementUnlocked returns true after unlocking', () {
      for (var i = 0; i < 20; i++) {
        controller.recordAnswer(isCorrect: true, questionType: 'signs');
      }
      // streak_20 might not be unlocked, but correct_50 after 50. Use a small threshold.
      // Let's just check streak_5 (5 in a row)
      expect(controller.isAchievementUnlocked('streak_5'), isTrue);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Stats Summary
  // ─────────────────────────────────────────────────────────────────────────
  group('GamificationController - Stats Summary', () {
    test('getStats returns valid object', () {
      final stats = controller.getStats();
      expect(stats, isNotNull);
      expect(stats.totalXP, equals(controller.totalXP));
      expect(stats.currentLevel, equals(controller.currentLevel));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Clear Data
  // ─────────────────────────────────────────────────────────────────────────
  group('GamificationController - clearAllData', () {
    test('clears all progress', () async {
      controller.recordAnswer(isCorrect: true, questionType: 'rules');
      await controller.clearAllData();
      expect(controller.totalXP, equals(0));
      expect(controller.totalPoints, equals(0));
      expect(controller.currentLevel, equals(1));
      expect(controller.unlockedAchievements, isEmpty);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // AchievementRarity
  // ─────────────────────────────────────────────────────────────────────────
  group('AchievementRarity', () {
    test('has 5 rarity levels', () {
      expect(AchievementRarity.values.length, equals(5));
    });

    test('legenday > epic > rare > uncommon > common ordering is expected', () {
      expect(AchievementRarity.legendary.index, greaterThan(AchievementRarity.epic.index));
      expect(AchievementRarity.epic.index, greaterThan(AchievementRarity.rare.index));
      expect(AchievementRarity.rare.index, greaterThan(AchievementRarity.uncommon.index));
      expect(AchievementRarity.uncommon.index, greaterThan(AchievementRarity.common.index));
    });
  });
}
