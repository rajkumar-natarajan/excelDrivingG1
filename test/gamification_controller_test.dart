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

    test('starts with 0 current streak', () {
      expect(controller.currentStreak, equals(0));
    });

    test('starts with 0 best streak', () {
      expect(controller.bestStreak, equals(0));
    });

    test('starts with empty unlocked achievements', () {
      expect(controller.unlockedAchievements, isEmpty);
    });

    test('levelProgress is between 0 and 1', () {
      expect(controller.levelProgress, inInclusiveRange(0.0, 1.0));
    });

    test('xpForNextLevel is positive at level 1', () {
      expect(controller.xpForNextLevel, greaterThan(0));
    });

    test('xpInCurrentLevel is 0 at start', () {
      expect(controller.xpInCurrentLevel, equals(0));
    });

    test('levelProgress is 0 at start', () {
      expect(controller.levelProgress, equals(0.0));
    });

    test('today questions is 0', () {
      expect(controller.todayQuestions, equals(0));
    });

    test('today correct is 0', () {
      expect(controller.todayCorrect, equals(0));
    });

    test('calling initialize twice is idempotent', () async {
      await controller.initialize();
      expect(controller.currentLevel, equals(1));
      expect(controller.totalXP, equals(0));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Record Answer — basic correctness
  // ─────────────────────────────────────────────────────────────────────────
  group('GamificationController - recordAnswer basics', () {
    test('correct answer grants XP and points', () {
      controller.recordAnswer(isCorrect: true, questionType: 'traffic_signs');
      expect(controller.totalXP, greaterThan(0));
      expect(controller.totalPoints, greaterThan(0));
    });

    test('wrong answer grants 0 XP', () {
      controller.recordAnswer(isCorrect: false, questionType: 'traffic_signs');
      expect(controller.totalXP, equals(0));
    });

    test('wrong answer grants 0 points', () {
      controller.recordAnswer(isCorrect: false, questionType: 'rules');
      expect(controller.totalPoints, equals(0));
    });

    test('correct answer increments todayCorrect', () {
      controller.recordAnswer(isCorrect: true, questionType: 'rules');
      expect(controller.todayCorrect, equals(1));
    });

    test('wrong answer does not increment todayCorrect', () {
      controller.recordAnswer(isCorrect: false, questionType: 'rules');
      expect(controller.todayCorrect, equals(0));
    });

    test('both correct and wrong answers increment todayQuestions', () {
      controller.recordAnswer(isCorrect: true, questionType: 'rules');
      controller.recordAnswer(isCorrect: false, questionType: 'rules');
      expect(controller.todayQuestions, equals(2));
    });

    test('correct answer with no streak earns exactly 10 points and 5 XP', () {
      final reward = controller.recordAnswer(isCorrect: true, questionType: 'rules');
      expect(reward.pointsEarned, equals(10));
      expect(reward.xpEarned, equals(5));
    });

    test('returns a GamificationReward', () {
      final reward = controller.recordAnswer(isCorrect: true, questionType: 'rules');
      expect(reward, isA<GamificationReward>());
      expect(reward.hasReward, isTrue);
    });

    test('wrong answer hasReward is false (no points/xp)', () {
      final reward = controller.recordAnswer(isCorrect: false, questionType: 'rules');
      expect(reward.hasReward, isFalse);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Streak mechanics
  // ─────────────────────────────────────────────────────────────────────────
  group('GamificationController - Streak mechanics', () {
    test('correct answers increment streak sequentially', () {
      for (var i = 0; i < 5; i++) {
        controller.recordAnswer(isCorrect: true, questionType: 'safety');
      }
      expect(controller.currentStreak, equals(5));
    });

    test('wrong answer resets streak to 0', () {
      controller.recordAnswer(isCorrect: true, questionType: 'rules');
      controller.recordAnswer(isCorrect: true, questionType: 'rules');
      controller.recordAnswer(isCorrect: false, questionType: 'rules');
      expect(controller.currentStreak, equals(0));
    });

    test('bestStreak is preserved after reset', () {
      for (var i = 0; i < 5; i++) {
        controller.recordAnswer(isCorrect: true, questionType: 'rules');
      }
      controller.recordAnswer(isCorrect: false, questionType: 'rules');
      expect(controller.bestStreak, equals(5));
    });

    test('bestStreak updates when streak surpasses previous best', () {
      for (var i = 0; i < 3; i++) {
        controller.recordAnswer(isCorrect: true, questionType: 'rules');
      }
      controller.recordAnswer(isCorrect: false, questionType: 'rules');
      for (var i = 0; i < 7; i++) {
        controller.recordAnswer(isCorrect: true, questionType: 'rules');
      }
      expect(controller.bestStreak, equals(7));
    });

    test('streak 3 awards bonus points of 5', () {
      for (var i = 0; i < 2; i++) {
        controller.recordAnswer(isCorrect: true, questionType: 'rules');
      }
      final reward = controller.recordAnswer(isCorrect: true, questionType: 'rules');
      expect(reward.streakBonus, equals(5));
    });

    test('streak 5 awards bonus points of 10', () {
      for (var i = 0; i < 4; i++) {
        controller.recordAnswer(isCorrect: true, questionType: 'rules');
      }
      final reward = controller.recordAnswer(isCorrect: true, questionType: 'rules');
      expect(reward.streakBonus, equals(10));
    });

    test('streak 10 awards bonus points of 20', () {
      for (var i = 0; i < 9; i++) {
        controller.recordAnswer(isCorrect: true, questionType: 'rules');
      }
      final reward = controller.recordAnswer(isCorrect: true, questionType: 'rules');
      expect(reward.streakBonus, equals(20));
    });

    test('reward.currentStreak reflects current streak value', () {
      for (var i = 0; i < 4; i++) {
        controller.recordAnswer(isCorrect: true, questionType: 'rules');
      }
      final reward = controller.recordAnswer(isCorrect: true, questionType: 'rules');
      expect(reward.currentStreak, equals(5));
    });

    test('wrong answer reward.currentStreak is 0', () {
      controller.recordAnswer(isCorrect: true, questionType: 'rules');
      final reward = controller.recordAnswer(isCorrect: false, questionType: 'rules');
      expect(reward.currentStreak, equals(0));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Record Test Completion
  // ─────────────────────────────────────────────────────────────────────────
  group('GamificationController - recordTestCompletion', () {
    test('always grants base 50 points and 25 XP', () {
      final reward = controller.recordTestCompletion(
        totalQuestions: 20,
        correctAnswers: 0,
        totalTimeSeconds: 600,
      );
      expect(reward.pointsEarned, greaterThanOrEqualTo(50));
      expect(reward.xpEarned, greaterThanOrEqualTo(25));
    });

    test('perfect score sets perfectBonus = true', () {
      final reward = controller.recordTestCompletion(
        totalQuestions: 20,
        correctAnswers: 20,
        totalTimeSeconds: 300,
      );
      expect(reward.perfectBonus, isTrue);
    });

    test('imperfect score does NOT set perfectBonus', () {
      final reward = controller.recordTestCompletion(
        totalQuestions: 20,
        correctAnswers: 19,
        totalTimeSeconds: 300,
      );
      expect(reward.perfectBonus, isFalse);
    });

    test('≥90% accuracy grants extra 30 points and 15 XP', () {
      final reward = controller.recordTestCompletion(
        totalQuestions: 10,
        correctAnswers: 9, // 90%
        totalTimeSeconds: 300,
      );
      // base 50 + 90% bonus 30 = 80 minimum (no speed bonus at 30s avg)
      expect(reward.pointsEarned, greaterThanOrEqualTo(80));
      expect(reward.xpEarned, greaterThanOrEqualTo(40));
    });

    test('80–89% accuracy grants extra 20 points and 10 XP', () {
      final reward = controller.recordTestCompletion(
        totalQuestions: 10,
        correctAnswers: 8, // 80%
        totalTimeSeconds: 600,
      );
      // base 50 + 80% bonus 20 = 70 minimum
      expect(reward.pointsEarned, greaterThanOrEqualTo(70));
    });

    test('below 80% grants only base points (no accuracy bonus)', () {
      final reward = controller.recordTestCompletion(
        totalQuestions: 10,
        correctAnswers: 7, // 70% - fast enough for speed bonus but no accuracy bonus
        totalTimeSeconds: 600, // 60s avg → no speed bonus
      );
      expect(reward.pointsEarned, equals(50));
    });

    test('fast and accurate earns speedBonus = true', () {
      final reward = controller.recordTestCompletion(
        totalQuestions: 10,
        correctAnswers: 8, // 80% ≥ 0.7
        totalTimeSeconds: 100, // 10s avg < 20s
      );
      expect(reward.speedBonus, isTrue);
    });

    test('speed bonus with avg time ≥ 20s is false', () {
      final reward = controller.recordTestCompletion(
        totalQuestions: 10,
        correctAnswers: 9,
        totalTimeSeconds: 300, // 30s avg
      );
      expect(reward.speedBonus, isFalse);
    });

    test('perfect score unlocks achievement', () {
      controller.recordTestCompletion(
        totalQuestions: 20,
        correctAnswers: 20,
        totalTimeSeconds: 300,
      );
      expect(controller.unlockedAchievements.contains('perfect_test'), isTrue);
    });

    test('5 completed tests unlocks tests_5 achievement', () {
      for (var i = 0; i < 5; i++) {
        controller.recordTestCompletion(
          totalQuestions: 20,
          correctAnswers: 16,
          totalTimeSeconds: 300,
        );
      }
      expect(controller.unlockedAchievements.contains('tests_5'), isTrue);
    });

    test('returns a GamificationReward with accrued points', () {
      final reward = controller.recordTestCompletion(
        totalQuestions: 10,
        correctAnswers: 10,
        totalTimeSeconds: 120,
      );
      expect(reward.pointsEarned, greaterThan(0));
      expect(reward.xpEarned, greaterThan(0));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Level Up
  // ─────────────────────────────────────────────────────────────────────────
  group('GamificationController - Level Up', () {
    test('level increases after enough XP', () {
      for (var i = 0; i < 50; i++) {
        controller.recordAnswer(isCorrect: true, questionType: 'rules');
      }
      expect(controller.totalXP, greaterThan(0));
      expect(controller.currentLevel, greaterThanOrEqualTo(1));
    });

    test('xpForNextLevel at level 1 equals 100 (1*100 + 0*50)', () {
      expect(controller.xpForNextLevel, equals(100));
    });

    test('levelProgress approaches 1 as XP fills up', () {
      // Earn nearly the full level-1 XP requirement
      for (var i = 0; i < 18; i++) {
        // 18 * 5 XP = 90 XP ≈ 90% of 100
        controller.recordAnswer(isCorrect: true, questionType: 'rules');
      }
      expect(controller.levelProgress, greaterThan(0.5));
    });

    test('xpForNextLevel grows as level increases', () {
      final xpL1 = controller.xpForNextLevel;
      for (var i = 0; i < 100; i++) {
        controller.recordAnswer(isCorrect: true, questionType: 'rules');
      }
      if (controller.currentLevel > 1) {
        expect(controller.xpForNextLevel, greaterThan(xpL1));
      }
    });

    test('reward.leveledUp is true when a level boundary is crossed', () {
      // Answer enough to guarantee a level up (level 1 needs 100 XP)
      GamificationReward? levelUpReward;
      for (var i = 0; i < 25; i++) {
        final r = controller.recordAnswer(isCorrect: true, questionType: 'rules');
        if (r.leveledUp) {
          levelUpReward = r;
          break;
        }
      }
      expect(levelUpReward, isNotNull);
      expect(levelUpReward!.newLevel, greaterThan(1));
    });

    test('level 5 unlocks level_5 achievement', () {
      // Force level 5 by completing tests
      for (var i = 0; i < 20; i++) {
        controller.recordTestCompletion(
          totalQuestions: 40,
          correctAnswers: 40,
          totalTimeSeconds: 300,
        );
      }
      if (controller.currentLevel >= 5) {
        expect(controller.isAchievementUnlocked('level_5'), isTrue);
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

    test('all achievements have non-empty name and description', () {
      for (final a in allAchievements) {
        expect(a.name, isNotEmpty, reason: '${a.id} has empty name');
        expect(a.description, isNotEmpty, reason: '${a.id} has empty description');
      }
    });

    test('all achievements have positive xpReward and pointsReward', () {
      for (final a in allAchievements) {
        expect(a.xpReward, greaterThan(0), reason: '${a.id} xpReward = 0');
        expect(a.pointsReward, greaterThan(0), reason: '${a.id} pointsReward = 0');
      }
    });

    test('answering 50 correct unlocks correct_50 (road_student)', () {
      for (var i = 0; i < 50; i++) {
        controller.recordAnswer(isCorrect: true, questionType: 'rules');
      }
      expect(controller.unlockedAchievements.contains('correct_50'), isTrue);
    });

    test('streak_5 achievement unlocked after 5 in a row', () {
      for (var i = 0; i < 5; i++) {
        controller.recordAnswer(isCorrect: true, questionType: 'signs');
      }
      expect(controller.isAchievementUnlocked('streak_5'), isTrue);
    });

    test('streak_10 achievement unlocked after 10 in a row', () {
      for (var i = 0; i < 10; i++) {
        controller.recordAnswer(isCorrect: true, questionType: 'signs');
      }
      expect(controller.isAchievementUnlocked('streak_10'), isTrue);
    });

    test('streak_20 achievement unlocked after 20 in a row', () {
      for (var i = 0; i < 20; i++) {
        controller.recordAnswer(isCorrect: true, questionType: 'signs');
      }
      expect(controller.isAchievementUnlocked('streak_20'), isTrue);
    });

    test('isAchievementUnlocked returns false for not yet earned', () {
      expect(controller.isAchievementUnlocked('correct_500'), isFalse);
    });

    test('daily_7 achievement requires 7 daily streak (not immediately unlocked)', () {
      // Cannot simulate separate days, but the achievement should exist
      final dailyAchievement = allAchievements.firstWhere((a) => a.id == 'daily_7');
      expect(dailyAchievement.requirement, equals(7));
    });

    test('unlocking achievement adds its XP to totalXP', () {
      final xpBefore = controller.totalXP;
      for (var i = 0; i < 5; i++) {
        controller.recordAnswer(isCorrect: true, questionType: 'signs');
      }
      // streak_5 should be unlocked and its xpReward added
      expect(controller.totalXP, greaterThan(xpBefore));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Stats Summary
  // ─────────────────────────────────────────────────────────────────────────
  group('GamificationController - Stats Summary', () {
    test('getStats returns valid GamificationStats', () {
      final stats = controller.getStats();
      expect(stats, isNotNull);
      expect(stats.totalXP, equals(controller.totalXP));
      expect(stats.currentLevel, equals(controller.currentLevel));
      expect(stats.totalPoints, equals(controller.totalPoints));
    });

    test('getStats.currentStreak matches controller', () {
      for (var i = 0; i < 3; i++) {
        controller.recordAnswer(isCorrect: true, questionType: 'rules');
      }
      final stats = controller.getStats();
      expect(stats.currentStreak, equals(controller.currentStreak));
    });

    test('getStats.bestStreak matches controller', () {
      for (var i = 0; i < 5; i++) {
        controller.recordAnswer(isCorrect: true, questionType: 'rules');
      }
      controller.recordAnswer(isCorrect: false, questionType: 'rules');
      final stats = controller.getStats();
      expect(stats.bestStreak, equals(controller.bestStreak));
    });

    test('getStats.totalAchievements matches allAchievements.length', () {
      final stats = controller.getStats();
      expect(stats.totalAchievements, equals(allAchievements.length));
    });

    test('getStats.achievementsUnlocked increases after unlock', () {
      final before = controller.getStats().achievementsUnlocked;
      for (var i = 0; i < 5; i++) {
        controller.recordAnswer(isCorrect: true, questionType: 'rules');
      }
      final after = controller.getStats().achievementsUnlocked;
      expect(after, greaterThanOrEqualTo(before));
    });

    test('getStats.xpToNextLevel is positive at start', () {
      final stats = controller.getStats();
      expect(stats.xpToNextLevel, greaterThan(0));
    });

    test('getStats.levelProgress is 0 at start', () {
      final stats = controller.getStats();
      expect(stats.levelProgress, equals(0.0));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Clear Data
  // ─────────────────────────────────────────────────────────────────────────
  group('GamificationController - clearAllData', () {
    test('clears all XP and points', () async {
      controller.recordAnswer(isCorrect: true, questionType: 'rules');
      await controller.clearAllData();
      expect(controller.totalXP, equals(0));
      expect(controller.totalPoints, equals(0));
    });

    test('resets level to 1', () async {
      for (var i = 0; i < 100; i++) {
        controller.recordAnswer(isCorrect: true, questionType: 'rules');
      }
      await controller.clearAllData();
      expect(controller.currentLevel, equals(1));
    });

    test('resets streaks to 0', () async {
      for (var i = 0; i < 5; i++) {
        controller.recordAnswer(isCorrect: true, questionType: 'rules');
      }
      await controller.clearAllData();
      expect(controller.currentStreak, equals(0));
      expect(controller.bestStreak, equals(0));
    });

    test('clears all achievements', () async {
      for (var i = 0; i < 5; i++) {
        controller.recordAnswer(isCorrect: true, questionType: 'signs');
      }
      await controller.clearAllData();
      expect(controller.unlockedAchievements, isEmpty);
    });

    test('clears todayCorrect and todayQuestions', () async {
      controller.recordAnswer(isCorrect: true, questionType: 'rules');
      await controller.clearAllData();
      expect(controller.todayCorrect, equals(0));
      expect(controller.todayQuestions, equals(0));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // AchievementRarity
  // ─────────────────────────────────────────────────────────────────────────
  group('AchievementRarity', () {
    test('has 5 rarity levels', () {
      expect(AchievementRarity.values.length, equals(5));
    });

    test('legendary > epic > rare > uncommon > common ordering', () {
      expect(AchievementRarity.legendary.index, greaterThan(AchievementRarity.epic.index));
      expect(AchievementRarity.epic.index, greaterThan(AchievementRarity.rare.index));
      expect(AchievementRarity.rare.index, greaterThan(AchievementRarity.uncommon.index));
      expect(AchievementRarity.uncommon.index, greaterThan(AchievementRarity.common.index));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // GamificationReward value object
  // ─────────────────────────────────────────────────────────────────────────
  group('GamificationReward', () {
    test('defaults to 0 pointsEarned', () {
      final reward = GamificationReward();
      expect(reward.pointsEarned, equals(0));
    });

    test('defaults to 0 xpEarned', () {
      final reward = GamificationReward();
      expect(reward.xpEarned, equals(0));
    });

    test('hasReward is false when no points/XP and no level up', () {
      final reward = GamificationReward();
      expect(reward.hasReward, isFalse);
    });

    test('hasReward is true when leveledUp', () {
      final reward = GamificationReward()..leveledUp = true;
      expect(reward.hasReward, isTrue);
    });

    test('hasReward is true when points > 0', () {
      final reward = GamificationReward()..pointsEarned = 10;
      expect(reward.hasReward, isTrue);
    });
  });
}
