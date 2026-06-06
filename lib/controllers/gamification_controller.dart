import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages gamification features: XP, levels, streaks, achievements
class GamificationController extends ChangeNotifier {
  static final GamificationController _instance = GamificationController._internal();
  factory GamificationController() => _instance;
  GamificationController._internal();

  int _totalXP = 0;
  int _currentLevel = 1;
  int _totalPoints = 0;
  int _currentStreak = 0;
  int _bestStreak = 0;
  int _dailyStreak = 0;
  DateTime? _lastPracticeDate;
  Set<String> _unlockedAchievements = {};
  Map<String, int> _achievementProgress = {};
  int _todayQuestions = 0;
  int _todayCorrect = 0;
  bool _isInitialized = false;

  int get totalXP => _totalXP;
  int get currentLevel => _currentLevel;
  int get totalPoints => _totalPoints;
  int get currentStreak => _currentStreak;
  int get bestStreak => _bestStreak;
  int get dailyStreak => _dailyStreak;
  int get todayQuestions => _todayQuestions;
  int get todayCorrect => _todayCorrect;
  Set<String> get unlockedAchievements => Set.from(_unlockedAchievements);

  int get xpForNextLevel => _currentLevel * 100 + (_currentLevel - 1) * 50;

  int get xpInCurrentLevel {
    int xpForPreviousLevels = 0;
    for (int i = 1; i < _currentLevel; i++) {
      xpForPreviousLevels += i * 100 + (i - 1) * 50;
    }
    return _totalXP - xpForPreviousLevels;
  }

  double get levelProgress => xpInCurrentLevel / xpForNextLevel;

  Future<void> initialize() async {
    if (_isInitialized) return;
    final prefs = await SharedPreferences.getInstance();
    _totalXP = prefs.getInt('g1_gamification_xp') ?? 0;
    _currentLevel = prefs.getInt('g1_gamification_level') ?? 1;
    _totalPoints = prefs.getInt('g1_gamification_points') ?? 0;
    _currentStreak = prefs.getInt('g1_gamification_streak') ?? 0;
    _bestStreak = prefs.getInt('g1_gamification_best_streak') ?? 0;
    _dailyStreak = prefs.getInt('g1_gamification_daily_streak') ?? 0;
    final lastPractice = prefs.getString('g1_gamification_last_practice');
    if (lastPractice != null) _lastPracticeDate = DateTime.parse(lastPractice);
    final achievements = prefs.getStringList('g1_gamification_achievements');
    if (achievements != null) _unlockedAchievements = achievements.toSet();
    final progressJson = prefs.getString('g1_gamification_progress');
    if (progressJson != null) {
      final Map<String, dynamic> data = jsonDecode(progressJson);
      _achievementProgress = data.map((k, v) => MapEntry(k, v as int));
    }
    _checkDailyStreak();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('g1_gamification_xp', _totalXP);
    await prefs.setInt('g1_gamification_level', _currentLevel);
    await prefs.setInt('g1_gamification_points', _totalPoints);
    await prefs.setInt('g1_gamification_streak', _currentStreak);
    await prefs.setInt('g1_gamification_best_streak', _bestStreak);
    await prefs.setInt('g1_gamification_daily_streak', _dailyStreak);
    if (_lastPracticeDate != null) {
      await prefs.setString('g1_gamification_last_practice', _lastPracticeDate!.toIso8601String());
    }
    await prefs.setStringList('g1_gamification_achievements', _unlockedAchievements.toList());
    await prefs.setString('g1_gamification_progress', jsonEncode(_achievementProgress));
  }

  void _checkDailyStreak() {
    if (_lastPracticeDate == null) return;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastPractice = DateTime(_lastPracticeDate!.year, _lastPracticeDate!.month, _lastPracticeDate!.day);
    if (today.difference(lastPractice).inDays > 1) _dailyStreak = 0;
  }

  void _updateDailyStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (_lastPracticeDate == null) {
      _dailyStreak = 1;
      _lastPracticeDate = now;
      return;
    }
    final lastPractice = DateTime(_lastPracticeDate!.year, _lastPracticeDate!.month, _lastPracticeDate!.day);
    final daysDiff = today.difference(lastPractice).inDays;
    if (daysDiff == 0) return;
    if (daysDiff == 1) {
      _dailyStreak++;
      _checkAchievement(AchievementType.dailyStreak, _dailyStreak);
    } else {
      _dailyStreak = 1;
    }
    _lastPracticeDate = now;
  }

  GamificationReward recordAnswer({
    required bool isCorrect,
    required String questionType,
  }) {
    _todayQuestions++;
    GamificationReward reward = GamificationReward();
    if (isCorrect) {
      _todayCorrect++;
      int points = 10;
      int xp = 5;
      _currentStreak++;
      if (_currentStreak > _bestStreak) _bestStreak = _currentStreak;
      if (_currentStreak >= 10) {
        points += 20;
        xp += 10;
        reward.streakBonus = 20;
      } else if (_currentStreak >= 5) {
        points += 10;
        xp += 5;
        reward.streakBonus = 10;
      } else if (_currentStreak >= 3) {
        points += 5;
        xp += 2;
        reward.streakBonus = 5;
      }
      _totalPoints += points;
      _totalXP += xp;
      reward.pointsEarned = points;
      reward.xpEarned = xp;
      reward.currentStreak = _currentStreak;
      _checkLevelUp(reward);
      _checkAchievement(AchievementType.totalCorrect, _todayCorrect);
      _checkAchievement(AchievementType.answerStreak, _currentStreak);
      _checkAchievement(AchievementType.totalXP, _totalXP);
    } else {
      _currentStreak = 0;
      reward.currentStreak = 0;
    }
    _updateDailyStreak();
    _save();
    notifyListeners();
    return reward;
  }

  GamificationReward recordTestCompletion({
    required int totalQuestions,
    required int correctAnswers,
    required int totalTimeSeconds,
  }) {
    GamificationReward reward = GamificationReward();
    int points = 50;
    int xp = 25;
    if (correctAnswers == totalQuestions) {
      points += 100;
      xp += 50;
      reward.perfectBonus = true;
      _checkAchievement(AchievementType.perfectTest, 1);
    }
    double accuracy = totalQuestions > 0 ? correctAnswers / totalQuestions : 0;
    if (accuracy >= 0.9) { points += 30; xp += 15; }
    else if (accuracy >= 0.8) { points += 20; xp += 10; }
    double avgTime = totalQuestions > 0 ? totalTimeSeconds / totalQuestions : 0;
    if (avgTime < 20 && accuracy >= 0.7) {
      points += 25;
      xp += 12;
      reward.speedBonus = true;
    }
    _totalPoints += points;
    _totalXP += xp;
    reward.pointsEarned = points;
    reward.xpEarned = xp;
    _incrementProgress(AchievementType.testsCompleted);
    _checkAchievement(AchievementType.testsCompleted, _getProgress(AchievementType.testsCompleted));
    _checkLevelUp(reward);
    _save();
    notifyListeners();
    return reward;
  }

  void _checkLevelUp(GamificationReward reward) {
    int xpForPreviousLevels = 0;
    for (int i = 1; i <= _currentLevel; i++) {
      xpForPreviousLevels += i * 100 + (i - 1) * 50;
    }
    if (_totalXP >= xpForPreviousLevels) {
      _currentLevel++;
      reward.leveledUp = true;
      reward.newLevel = _currentLevel;
      _checkAchievement(AchievementType.level, _currentLevel);
    }
  }

  void _incrementProgress(AchievementType type) {
    final key = type.name;
    _achievementProgress[key] = (_achievementProgress[key] ?? 0) + 1;
  }

  int _getProgress(AchievementType type) => _achievementProgress[type.name] ?? 0;

  void _checkAchievement(AchievementType type, int value) {
    for (final achievement in allAchievements) {
      if (achievement.type == type &&
          value >= achievement.requirement &&
          !_unlockedAchievements.contains(achievement.id)) {
        _unlockAchievement(achievement);
      }
    }
  }

  void _unlockAchievement(Achievement achievement) {
    _unlockedAchievements.add(achievement.id);
    _totalXP += achievement.xpReward;
    _totalPoints += achievement.pointsReward;
    notifyListeners();
  }

  bool isAchievementUnlocked(String id) => _unlockedAchievements.contains(id);

  GamificationStats getStats() {
    return GamificationStats(
      totalXP: _totalXP,
      currentLevel: _currentLevel,
      totalPoints: _totalPoints,
      currentStreak: _currentStreak,
      bestStreak: _bestStreak,
      dailyStreak: _dailyStreak,
      achievementsUnlocked: _unlockedAchievements.length,
      totalAchievements: allAchievements.length,
      levelProgress: levelProgress,
      xpToNextLevel: xpForNextLevel - xpInCurrentLevel,
    );
  }

  Future<void> clearAllData() async {
    _totalXP = 0; _currentLevel = 1; _totalPoints = 0;
    _currentStreak = 0; _bestStreak = 0; _dailyStreak = 0;
    _lastPracticeDate = null; _unlockedAchievements.clear();
    _achievementProgress.clear(); _todayQuestions = 0; _todayCorrect = 0;
    _isInitialized = false; // allow re-initialization after a full clear
    await _save();
    notifyListeners();
  }
}

class GamificationReward {
  int pointsEarned = 0;
  int xpEarned = 0;
  int streakBonus = 0;
  int timeBonus = 0;
  int currentStreak = 0;
  bool leveledUp = false;
  int? newLevel;
  bool perfectBonus = false;
  bool speedBonus = false;
  List<Achievement> newAchievements = [];
  bool get hasReward => pointsEarned > 0 || xpEarned > 0 || leveledUp;
}

class GamificationStats {
  final int totalXP;
  final int currentLevel;
  final int totalPoints;
  final int currentStreak;
  final int bestStreak;
  final int dailyStreak;
  final int achievementsUnlocked;
  final int totalAchievements;
  final double levelProgress;
  final int xpToNextLevel;

  GamificationStats({
    required this.totalXP,
    required this.currentLevel,
    required this.totalPoints,
    required this.currentStreak,
    required this.bestStreak,
    required this.dailyStreak,
    required this.achievementsUnlocked,
    required this.totalAchievements,
    required this.levelProgress,
    required this.xpToNextLevel,
  });
}

enum AchievementType {
  totalCorrect, answerStreak, dailyStreak, testsCompleted, perfectTest, totalXP, level,
}

class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final AchievementType type;
  final int requirement;
  final int xpReward;
  final int pointsReward;
  final AchievementRarity rarity;

  const Achievement({
    required this.id, required this.name, required this.description,
    required this.icon, required this.type, required this.requirement,
    this.xpReward = 50, this.pointsReward = 100,
    this.rarity = AchievementRarity.common,
  });
}

enum AchievementRarity { common, uncommon, rare, epic, legendary }

const List<Achievement> allAchievements = [
  Achievement(id: 'first_correct', name: 'First Steps', description: 'Answer your first question correctly', icon: '🎯', type: AchievementType.totalCorrect, requirement: 1, xpReward: 10, pointsReward: 25),
  Achievement(id: 'correct_10', name: 'Getting Started', description: 'Answer 10 questions correctly', icon: '⭐', type: AchievementType.totalCorrect, requirement: 10, xpReward: 25, pointsReward: 50),
  Achievement(id: 'correct_50', name: 'Road Student', description: 'Answer 50 questions correctly', icon: '📖', type: AchievementType.totalCorrect, requirement: 50, xpReward: 50, pointsReward: 100, rarity: AchievementRarity.uncommon),
  Achievement(id: 'correct_100', name: 'Highway Scholar', description: 'Answer 100 questions correctly', icon: '🎓', type: AchievementType.totalCorrect, requirement: 100, xpReward: 100, pointsReward: 200, rarity: AchievementRarity.rare),
  Achievement(id: 'correct_500', name: 'Road Master', description: 'Answer 500 questions correctly', icon: '🏆', type: AchievementType.totalCorrect, requirement: 500, xpReward: 250, pointsReward: 500, rarity: AchievementRarity.epic),
  Achievement(id: 'streak_3', name: 'On a Roll', description: 'Get 3 correct answers in a row', icon: '🔥', type: AchievementType.answerStreak, requirement: 3, xpReward: 15, pointsReward: 30),
  Achievement(id: 'streak_5', name: 'Hot Streak', description: 'Get 5 correct answers in a row', icon: '💥', type: AchievementType.answerStreak, requirement: 5, xpReward: 25, pointsReward: 50, rarity: AchievementRarity.uncommon),
  Achievement(id: 'streak_10', name: 'Unstoppable', description: 'Get 10 correct answers in a row', icon: '⚡', type: AchievementType.answerStreak, requirement: 10, xpReward: 50, pointsReward: 100, rarity: AchievementRarity.rare),
  Achievement(id: 'streak_20', name: 'Legend', description: 'Get 20 correct answers in a row', icon: '👑', type: AchievementType.answerStreak, requirement: 20, xpReward: 100, pointsReward: 200, rarity: AchievementRarity.epic),
  Achievement(id: 'daily_3', name: 'Consistent', description: 'Practice for 3 days in a row', icon: '📅', type: AchievementType.dailyStreak, requirement: 3, xpReward: 30, pointsReward: 60),
  Achievement(id: 'daily_7', name: 'Week Warrior', description: 'Practice for 7 days in a row', icon: '🗓️', type: AchievementType.dailyStreak, requirement: 7, xpReward: 75, pointsReward: 150, rarity: AchievementRarity.uncommon),
  Achievement(id: 'daily_30', name: 'Month Master', description: 'Practice for 30 days in a row', icon: '📆', type: AchievementType.dailyStreak, requirement: 30, xpReward: 300, pointsReward: 600, rarity: AchievementRarity.legendary),
  Achievement(id: 'tests_1', name: 'Test Taker', description: 'Complete your first test', icon: '📝', type: AchievementType.testsCompleted, requirement: 1, xpReward: 20, pointsReward: 40),
  Achievement(id: 'tests_5', name: 'Persistent', description: 'Complete 5 tests', icon: '🎯', type: AchievementType.testsCompleted, requirement: 5, xpReward: 50, pointsReward: 100, rarity: AchievementRarity.uncommon),
  Achievement(id: 'tests_20', name: 'Test Champion', description: 'Complete 20 tests', icon: '🏅', type: AchievementType.testsCompleted, requirement: 20, xpReward: 150, pointsReward: 300, rarity: AchievementRarity.rare),
  Achievement(id: 'perfect_test', name: 'Perfect Score', description: 'Get 100% on a test', icon: '💯', type: AchievementType.perfectTest, requirement: 1, xpReward: 100, pointsReward: 200, rarity: AchievementRarity.rare),
  Achievement(id: 'level_5', name: 'Rising Driver', description: 'Reach level 5', icon: '🚗', type: AchievementType.level, requirement: 5, xpReward: 100, pointsReward: 200, rarity: AchievementRarity.uncommon),
  Achievement(id: 'level_10', name: 'Road Ready', description: 'Reach level 10', icon: '🛣️', type: AchievementType.level, requirement: 10, xpReward: 200, pointsReward: 400, rarity: AchievementRarity.rare),
  Achievement(id: 'level_20', name: 'G1 Champion', description: 'Reach level 20', icon: '🏆', type: AchievementType.level, requirement: 20, xpReward: 500, pointsReward: 1000, rarity: AchievementRarity.epic),
];
