// Question models for ExcelDriving G1 Flutter App
// Based on Ontario G1 Driver's Licence Test (MTO Driver's Handbook)
import 'dart:math';

/// Question categories matching G1 test topics
enum QuestionType {
  graduatedLicensing('graduated', 'Graduated Licensing'),
  trafficSigns('signs', 'Traffic Signs & Signals'),
  rulesOfRoad('rules', 'Rules of the Road'),
  safeDriving('safety', 'Safe Driving'),
  sharingRoad('sharing', 'Sharing the Road'),
  specialSituations('special', 'Special Situations');

  final String value;
  final String displayName;
  const QuestionType(this.value, this.displayName);
}

/// Graduated Licensing subtypes
enum GraduatedSubType {
  g1Requirements('g1_req', 'G1 Requirements'),
  g1Restrictions('g1_restrict', 'G1 Restrictions'),
  g2Requirements('g2_req', 'G2 Requirements'),
  g2Restrictions('g2_restrict', 'G2 Restrictions'),
  gLicence('g_licence', 'Full G Licence');

  final String value;
  final String displayName;
  const GraduatedSubType(this.value, this.displayName);
}

/// Traffic Signs subtypes
enum SignsSubType {
  regulatorySigns('regulatory', 'Regulatory Signs'),
  warningSigns('warning', 'Warning Signs'),
  informationSigns('information', 'Information Signs'),
  trafficSignals('signals', 'Traffic Signals'),
  roadMarkings('markings', 'Road Markings');

  final String value;
  final String displayName;
  const SignsSubType(this.value, this.displayName);
}

/// Rules of Road subtypes
enum RulesSubType {
  speedLimits('speed', 'Speed Limits'),
  rightOfWay('right_of_way', 'Right of Way'),
  turnsLanes('turns', 'Turns & Lanes'),
  parkingStopping('parking', 'Parking & Stopping'),
  intersections('intersections', 'Intersections');

  final String value;
  final String displayName;
  const RulesSubType(this.value, this.displayName);
}

/// Safe Driving subtypes
enum SafetySubType {
  alcoholDrugs('alcohol', 'Alcohol & Drugs'),
  distractedDriving('distracted', 'Distracted Driving'),
  defensiveDriving('defensive', 'Defensive Driving'),
  seatbelts('seatbelts', 'Seatbelts & Safety'),
  vehicleInspection('inspection', 'Vehicle Checks');

  final String value;
  final String displayName;
  const SafetySubType(this.value, this.displayName);
}

/// Sharing Road subtypes
enum SharingSubType {
  pedestrians('pedestrians', 'Pedestrians'),
  cyclists('cyclists', 'Cyclists'),
  trucks('trucks', 'Large Vehicles'),
  emergencyVehicles('emergency', 'Emergency Vehicles'),
  schoolBuses('school_bus', 'School Buses');

  final String value;
  final String displayName;
  const SharingSubType(this.value, this.displayName);
}

/// Special Situations subtypes
enum SpecialSubType {
  nightDriving('night', 'Night Driving'),
  badWeather('weather', 'Adverse Weather'),
  highwayDriving('highway', 'Highway Driving'),
  collisions('collisions', 'Collisions');

  final String value;
  final String displayName;
  const SpecialSubType(this.value, this.displayName);
}

/// Test difficulty levels
enum Difficulty {
  easy('easy', 'Easy'),
  medium('medium', 'Medium'),
  hard('hard', 'Hard');

  final String value;
  final String displayName;
  const Difficulty(this.value, this.displayName);
}

/// Language enum
enum Language {
  english('en', 'English', '🇨🇦'),
  french('fr', 'Français', '🇫🇷');

  final String code;
  final String displayName;
  final String flag;
  const Language(this.code, this.displayName, this.flag);

  static Language fromCode(String code) {
    return Language.values.firstWhere(
      (l) => l.code == code,
      orElse: () => Language.english,
    );
  }
}

/// Individual question
class Question {
  final String id;
  final String stem;
  final List<String> options;
  final int correctAnswer;
  final String explanation;
  final QuestionType type;
  final String subType;
  final Difficulty difficulty;

  const Question({
    required this.id,
    required this.stem,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.type,
    required this.subType,
    this.difficulty = Difficulty.medium,
  });

  /// Create a copy with shuffled options (and updated correct answer index)
  Question withShuffledOptions(Random random) {
    final indexed = List.generate(options.length, (i) => MapEntry(i, options[i]));
    indexed.shuffle(random);
    final newOptions = indexed.map((e) => e.value).toList();
    final newCorrect = indexed.indexWhere((e) => e.key == correctAnswer);
    return Question(
      id: id,
      stem: stem,
      options: newOptions,
      correctAnswer: newCorrect,
      explanation: explanation,
      type: type,
      subType: subType,
      difficulty: difficulty,
    );
  }

  @override
  String toString() => 'Question($id: $stem)';
}

/// User's answer to a question
class UserAnswer {
  final String questionId;
  final int selectedOption;
  final bool isCorrect;
  final Duration timeTaken;

  const UserAnswer({
    required this.questionId,
    required this.selectedOption,
    required this.isCorrect,
    required this.timeTaken,
  });
}

/// Test configuration
class TestConfiguration {
  final TestType testType;
  final int questionCount;
  final int timeInMinutes;
  final Difficulty difficulty;
  final List<QuestionType>? selectedTypes;
  final List<String>? selectedSubTypes;
  final bool shuffleQuestions;

  const TestConfiguration({
    required this.testType,
    required this.questionCount,
    required this.timeInMinutes,
    required this.difficulty,
    this.selectedTypes,
    this.selectedSubTypes,
    this.shuffleQuestions = true,
  });
}

/// Test types
enum TestType {
  quickAssessment('Quick Check', 'Quick 10-question assessment', 10, 10),
  standardPractice('Standard Practice', '20-question practice test', 20, 20),
  fullMock('Full Mock Test', 'Official G1 test format (40 questions)', 40, 40);

  final String displayName;
  final String description;
  final int questionCount;
  final int timeInMinutes;
  const TestType(
    this.displayName,
    this.description,
    this.questionCount,
    this.timeInMinutes,
  );
}

/// Complete test result
class TestResult {
  final String id;
  final DateTime completedAt;
  final TestConfiguration configuration;
  final List<UserAnswer> answers;
  final int totalQuestions;
  final int correctAnswers;
  final Duration totalTime;
  final Map<QuestionType, int> scoreByType;
  final Map<String, int> scoreBySubType;

  const TestResult({
    required this.id,
    required this.completedAt,
    required this.configuration,
    required this.answers,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.totalTime,
    required this.scoreByType,
    required this.scoreBySubType,
  });

  double get percentage =>
      totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0;

  bool get passed => percentage >= 80; // Ontario G1 requires 80% to pass
}

// ==================== SMART LEARNING MODELS ====================

class PerformanceStats {
  final String subType;
  int totalAttempts;
  int correctAttempts;

  PerformanceStats({
    required this.subType,
    this.totalAttempts = 0,
    this.correctAttempts = 0,
  });

  double get accuracy =>
      totalAttempts > 0 ? correctAttempts / totalAttempts : 0;

  void recordAttempt(bool isCorrect) {
    totalAttempts++;
    if (isCorrect) correctAttempts++;
  }

  Map<String, dynamic> toJson() => {
        'subType': subType,
        'totalAttempts': totalAttempts,
        'correctAttempts': correctAttempts,
      };

  factory PerformanceStats.fromJson(Map<String, dynamic> json) =>
      PerformanceStats(
        subType: json['subType'] as String,
        totalAttempts: json['totalAttempts'] as int,
        correctAttempts: json['correctAttempts'] as int,
      );
}

class TimeStats {
  final String subType;
  int totalTime; // in seconds
  int questionCount;

  TimeStats({
    required this.subType,
    this.totalTime = 0,
    this.questionCount = 0,
  });

  double get averageTime =>
      questionCount > 0 ? totalTime / questionCount : 0;

  void recordTime(int seconds) {
    totalTime += seconds;
    questionCount++;
  }

  Map<String, dynamic> toJson() => {
        'subType': subType,
        'totalTime': totalTime,
        'questionCount': questionCount,
      };

  factory TimeStats.fromJson(Map<String, dynamic> json) => TimeStats(
        subType: json['subType'] as String,
        totalTime: json['totalTime'] as int,
        questionCount: json['questionCount'] as int,
      );
}

class TestSessionRecord {
  final DateTime date;
  final int totalQuestions;
  final int correctAnswers;
  final int totalTimeSeconds;
  final String testType;

  TestSessionRecord({
    required this.date,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.totalTimeSeconds,
    required this.testType,
  });

  double get accuracy =>
      totalQuestions > 0 ? correctAnswers / totalQuestions : 0;

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'totalQuestions': totalQuestions,
        'correctAnswers': correctAnswers,
        'totalTimeSeconds': totalTimeSeconds,
        'testType': testType,
      };

  factory TestSessionRecord.fromJson(Map<String, dynamic> json) =>
      TestSessionRecord(
        date: DateTime.parse(json['date'] as String),
        totalQuestions: json['totalQuestions'] as int,
        correctAnswers: json['correctAnswers'] as int,
        totalTimeSeconds: json['totalTimeSeconds'] as int,
        testType: json['testType'] as String,
      );
}

class TrendPoint {
  final String label;
  final double value;
  TrendPoint({required this.label, required this.value});
}
