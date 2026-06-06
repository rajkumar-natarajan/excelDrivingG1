import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question.dart';

/// Manages smart learning: weak areas, spaced repetition, bookmarks, time analytics
class SmartLearningController extends ChangeNotifier {
  static final SmartLearningController _instance = SmartLearningController._internal();
  factory SmartLearningController() => _instance;
  SmartLearningController._internal();

  Map<String, PerformanceStats> _performanceBySubType = {};
  Set<String> _bookmarkedQuestions = {};
  Map<String, DateTime> _incorrectQuestions = {};
  Set<String> _masteredQuestions = {};
  Map<String, TimeStats> _timeBySubType = {};
  List<TestSessionRecord> _testHistory = [];
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    final prefs = await SharedPreferences.getInstance();
    final perfJson = prefs.getString('g1_smart_performance');
    if (perfJson != null) {
      final Map<String, dynamic> data = jsonDecode(perfJson);
      _performanceBySubType = data.map((key, value) => MapEntry(key, PerformanceStats.fromJson(value)));
    }
    final bookmarks = prefs.getStringList('g1_smart_bookmarks');
    if (bookmarks != null) _bookmarkedQuestions = bookmarks.toSet();
    final incorrectJson = prefs.getString('g1_smart_incorrect');
    if (incorrectJson != null) {
      final Map<String, dynamic> data = jsonDecode(incorrectJson);
      _incorrectQuestions = data.map((key, value) => MapEntry(key, DateTime.parse(value)));
    }
    final mastered = prefs.getStringList('g1_smart_mastered');
    if (mastered != null) _masteredQuestions = mastered.toSet();
    final timeJson = prefs.getString('g1_smart_time_stats');
    if (timeJson != null) {
      final Map<String, dynamic> data = jsonDecode(timeJson);
      _timeBySubType = data.map((key, value) => MapEntry(key, TimeStats.fromJson(value)));
    }
    final historyJson = prefs.getString('g1_smart_test_history');
    if (historyJson != null) {
      final List<dynamic> data = jsonDecode(historyJson);
      _testHistory = data.map((e) => TestSessionRecord.fromJson(e)).toList();
    }
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final perfData = _performanceBySubType.map((key, value) => MapEntry(key, value.toJson()));
    await prefs.setString('g1_smart_performance', jsonEncode(perfData));
    await prefs.setStringList('g1_smart_bookmarks', _bookmarkedQuestions.toList());
    final incorrectData = _incorrectQuestions.map((key, value) => MapEntry(key, value.toIso8601String()));
    await prefs.setString('g1_smart_incorrect', jsonEncode(incorrectData));
    await prefs.setStringList('g1_smart_mastered', _masteredQuestions.toList());
    final timeData = _timeBySubType.map((key, value) => MapEntry(key, value.toJson()));
    await prefs.setString('g1_smart_time_stats', jsonEncode(timeData));
    final historyData = _testHistory.take(50).map((e) => e.toJson()).toList();
    await prefs.setString('g1_smart_test_history', jsonEncode(historyData));
  }

  bool isBookmarked(String questionId) => _bookmarkedQuestions.contains(questionId);

  void toggleBookmark(String questionId) {
    if (_bookmarkedQuestions.contains(questionId)) {
      _bookmarkedQuestions.remove(questionId);
    } else {
      _bookmarkedQuestions.add(questionId);
    }
    _save();
    notifyListeners();
  }

  Set<String> get bookmarkedQuestionIds => Set.from(_bookmarkedQuestions);
  int get bookmarkCount => _bookmarkedQuestions.length;
  int get masteredCount => _masteredQuestions.length;

  void recordAnswer(Question question, bool isCorrect, {int? timeSpentSeconds}) {
    final subType = question.subType;
    if (!_performanceBySubType.containsKey(subType)) {
      _performanceBySubType[subType] = PerformanceStats(subType: subType);
    }
    _performanceBySubType[subType]!.recordAttempt(isCorrect);
    if (timeSpentSeconds != null && timeSpentSeconds > 0) {
      if (!_timeBySubType.containsKey(subType)) {
        _timeBySubType[subType] = TimeStats(subType: subType);
      }
      _timeBySubType[subType]!.recordTime(timeSpentSeconds);
    }
    if (isCorrect) {
      if (_incorrectQuestions.containsKey(question.id)) {
        _incorrectQuestions.remove(question.id);
        _masteredQuestions.add(question.id);
      }
    } else {
      _incorrectQuestions[question.id] = DateTime.now();
      _masteredQuestions.remove(question.id);
    }
    _save();
    notifyListeners();
  }

  void recordTestSessionWithTime(List<Question> questions, List<UserAnswer> answers, int totalTimeSeconds) {
    int correct = 0;
    for (int i = 0; i < questions.length && i < answers.length; i++) {
      int estimatedTime = totalTimeSeconds ~/ questions.length;
      recordAnswer(questions[i], answers[i].isCorrect, timeSpentSeconds: estimatedTime);
      if (answers[i].isCorrect) correct++;
    }
    _testHistory.insert(0, TestSessionRecord(
      date: DateTime.now(),
      totalQuestions: questions.length,
      correctAnswers: correct,
      totalTimeSeconds: totalTimeSeconds,
      testType: questions.isNotEmpty ? questions.first.type.displayName : 'unknown',
    ));
    _save();
    notifyListeners();
  }

  PerformanceStats? getStats(String subType) => _performanceBySubType[subType];
  Map<String, PerformanceStats> get allStats => Map.from(_performanceBySubType);
  TimeStats? getTimeStats(String subType) => _timeBySubType[subType];
  Map<String, TimeStats> get allTimeStats => Map.from(_timeBySubType);

  List<String> getWeakAreas() {
    final sorted = _performanceBySubType.entries.toList()
      ..sort((a, b) => a.value.accuracy.compareTo(b.value.accuracy));
    return sorted.map((e) => e.key).toList();
  }

  List<String> getWeakSubTypes() {
    return _performanceBySubType.entries
        .where((e) => e.value.accuracy < 70 && e.value.totalAttempts >= 3)
        .map((e) => e.key)
        .toList();
  }

  bool isWeakArea(String subType) {
    final stats = _performanceBySubType[subType];
    if (stats == null || stats.totalAttempts < 3) return false;
    return stats.accuracy < 70;
  }

  List<String> getQuestionsForReview() {
    final now = DateTime.now();
    return _incorrectQuestions.entries
        .where((e) => now.difference(e.value).inDays >= 1)
        .map((e) => e.key)
        .toList();
  }

  bool needsReview(String questionId) {
    if (!_incorrectQuestions.containsKey(questionId)) return false;
    return DateTime.now().difference(_incorrectQuestions[questionId]!).inDays >= 1;
  }

  int get reviewCount => getQuestionsForReview().length;

  List<TestSessionRecord> get testHistory => List.from(_testHistory);
  List<TestSessionRecord> getRecentSessions(int count) => _testHistory.take(count).toList();

  List<TestSessionRecord> getSessionsForDays(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return _testHistory.where((s) => s.date.isAfter(cutoff)).toList();
  }

  List<TrendPoint> getAccuracyTrend() {
    final last30Days = getSessionsForDays(30);
    if (last30Days.isEmpty) return [];
    Map<String, List<TestSessionRecord>> byWeek = {};
    for (final session in last30Days) {
      final weekKey = '${session.date.year}-W${_getWeekNumber(session.date)}';
      byWeek.putIfAbsent(weekKey, () => []).add(session);
    }
    List<TrendPoint> trend = [];
    final sortedWeeks = byWeek.keys.toList()..sort();
    for (final week in sortedWeeks) {
      final sessions = byWeek[week]!;
      int totalQ = 0, totalCorrect = 0;
      for (final s in sessions) {
        totalQ += s.totalQuestions;
        totalCorrect += s.correctAnswers;
      }
      trend.add(TrendPoint(
        label: week,
        value: totalQ > 0 ? (totalCorrect / totalQ) * 100 : 0,
      ));
    }
    return trend;
  }

  int _getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirst = date.difference(firstDayOfYear).inDays;
    return ((daysSinceFirst + firstDayOfYear.weekday) / 7).ceil();
  }

  Future<void> clearAllData() async {
    _performanceBySubType.clear();
    _bookmarkedQuestions.clear();
    _incorrectQuestions.clear();
    _masteredQuestions.clear();
    _timeBySubType.clear();
    _testHistory.clear();
    _isInitialized = false; // allow re-initialization after a full clear
    await _save();
    notifyListeners();
  }
}

class PerformanceStats {
  final String subType;
  int totalAttempts;
  int correctAttempts;

  PerformanceStats({required this.subType, this.totalAttempts = 0, this.correctAttempts = 0});

  double get accuracy => totalAttempts > 0 ? (correctAttempts / totalAttempts) * 100 : 0;

  void recordAttempt(bool isCorrect) {
    totalAttempts++;
    if (isCorrect) correctAttempts++;
  }

  Map<String, dynamic> toJson() => {
    'subType': subType, 'totalAttempts': totalAttempts, 'correctAttempts': correctAttempts,
  };

  factory PerformanceStats.fromJson(Map<String, dynamic> json) => PerformanceStats(
    subType: json['subType'] ?? '',
    totalAttempts: json['totalAttempts'] ?? 0,
    correctAttempts: json['correctAttempts'] ?? 0,
  );
}

class TimeStats {
  final String subType;
  int totalTime;
  int questionCount;

  TimeStats({required this.subType, this.totalTime = 0, this.questionCount = 0});

  double get averageTime => questionCount > 0 ? totalTime / questionCount : 0;

  void recordTime(int seconds) { totalTime += seconds; questionCount++; }

  Map<String, dynamic> toJson() => {
    'subType': subType, 'totalTime': totalTime, 'questionCount': questionCount,
  };

  factory TimeStats.fromJson(Map<String, dynamic> json) => TimeStats(
    subType: json['subType'] ?? '',
    totalTime: json['totalTime'] ?? 0,
    questionCount: json['questionCount'] ?? 0,
  );
}

class TestSessionRecord {
  final DateTime date;
  final int totalQuestions;
  final int correctAnswers;
  final int totalTimeSeconds;
  final String testType;

  TestSessionRecord({
    required this.date, required this.totalQuestions,
    required this.correctAnswers, required this.totalTimeSeconds, required this.testType,
  });

  double get accuracy => totalQuestions > 0 ? correctAnswers / totalQuestions : 0;

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(), 'totalQuestions': totalQuestions,
    'correctAnswers': correctAnswers, 'totalTimeSeconds': totalTimeSeconds, 'testType': testType,
  };

  factory TestSessionRecord.fromJson(Map<String, dynamic> json) => TestSessionRecord(
    date: DateTime.parse(json['date']),
    totalQuestions: json['totalQuestions'] ?? 0,
    correctAnswers: json['correctAnswers'] ?? 0,
    totalTimeSeconds: json['totalTimeSeconds'] ?? 0,
    testType: json['testType'] ?? '',
  );
}

class TrendPoint {
  final String label;
  final double value;
  TrendPoint({required this.label, required this.value});
}
