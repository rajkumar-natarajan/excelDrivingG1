import 'dart:async';
import 'package:flutter/material.dart';
import '../models/question.dart';
import '../controllers/smart_learning_controller.dart';
import '../controllers/gamification_controller.dart';
import '../widgets/ontario_theme.dart';
import 'results_screen.dart';

class TestSessionScreen extends StatefulWidget {
  final TestConfiguration configuration;
  final List<Question> questions;

  const TestSessionScreen({
    super.key,
    required this.configuration,
    required this.questions,
  });

  @override
  State<TestSessionScreen> createState() => _TestSessionScreenState();
}

class _TestSessionScreenState extends State<TestSessionScreen> {
  int _currentIndex = 0;
  final Map<String, int> _answers = {};
  final Map<String, int> _timeSpent = {};
  late Timer _timer;
  int _secondsRemaining = 0;
  DateTime _startTime = DateTime.now();
  DateTime _questionStartTime = DateTime.now();
  final SmartLearningController _smartLearning = SmartLearningController();
  final GamificationController _gamification = GamificationController();
  int _totalPointsEarned = 0;
  int _totalXPEarned = 0;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.configuration.timeInMinutes * 60;
    _startTime = DateTime.now();
    _questionStartTime = DateTime.now();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _finishTest();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _timerText {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Color get _timerColor {
    if (_secondsRemaining < 60) return Colors.red;
    if (_secondsRemaining < 180) return Colors.orange;
    return OntarioColors.blue;
  }

  void _recordTimeForCurrentQuestion() {
    final questionId = widget.questions[_currentIndex].id;
    final duration = DateTime.now().difference(_questionStartTime).inSeconds;
    _timeSpent[questionId] = (_timeSpent[questionId] ?? 0) + duration;
  }

  void _selectAnswer(int optionIndex) {
    final question = widget.questions[_currentIndex];
    if (_answers.containsKey(question.id)) return;
    setState(() {
      _answers[question.id] = optionIndex;
    });
    final reward = _gamification.recordAnswer(
      isCorrect: optionIndex == question.correctAnswer,
      questionType: question.type.toString(),
    );
    _totalPointsEarned += reward.pointsEarned;
    _totalXPEarned += reward.xpEarned;
  }

  void _nextQuestion() {
    _recordTimeForCurrentQuestion();
    if (_currentIndex < widget.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _questionStartTime = DateTime.now();
      });
    } else {
      _finishTest();
    }
  }

  void _previousQuestion() {
    _recordTimeForCurrentQuestion();
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _questionStartTime = DateTime.now();
      });
    }
  }

  void _finishTest() {
    _timer.cancel();
    _recordTimeForCurrentQuestion();

    List<UserAnswer> userAnswers = [];
    int correctCount = 0;
    Map<QuestionType, int> scoreByType = {};
    Map<String, int> scoreBySubType = {};

    for (var question in widget.questions) {
      int selectedOption = _answers[question.id] ?? -1;
      bool isCorrect = selectedOption == question.correctAnswer;
      if (isCorrect) {
        correctCount++;
        scoreByType[question.type] = (scoreByType[question.type] ?? 0) + 1;
        scoreBySubType[question.subType] = (scoreBySubType[question.subType] ?? 0) + 1;
      }
      userAnswers.add(UserAnswer(
        questionId: question.id,
        selectedOption: selectedOption,
        isCorrect: isCorrect,
        timeTaken: Duration(seconds: _timeSpent[question.id] ?? 0),
      ));
    }

    final totalTimeSeconds = DateTime.now().difference(_startTime).inSeconds;
    _smartLearning.recordTestSessionWithTime(widget.questions, userAnswers, totalTimeSeconds);

    final completionReward = _gamification.recordTestCompletion(
      totalQuestions: widget.questions.length,
      correctAnswers: correctCount,
      totalTimeSeconds: totalTimeSeconds,
    );
    _totalPointsEarned += completionReward.pointsEarned;
    _totalXPEarned += completionReward.xpEarned;

    final result = TestResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      completedAt: DateTime.now(),
      configuration: widget.configuration,
      answers: userAnswers,
      totalQuestions: widget.questions.length,
      correctAnswers: correctCount,
      totalTime: DateTime.now().difference(_startTime),
      scoreByType: scoreByType,
      scoreBySubType: scoreBySubType,
    );

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
          result: result,
          questions: widget.questions,
          pointsEarned: _totalPointsEarned,
          xpEarned: _totalXPEarned,
          leveledUp: completionReward.leveledUp,
          newLevel: completionReward.newLevel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentIndex];
    final progress = (_currentIndex + 1) / widget.questions.length;
    final selectedAnswer = _answers[question.id];

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentIndex + 1}/${widget.questions.length}'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: OntarioColors.blue.withAlpha(30),
            color: OntarioColors.blue,
          ),
        ),
        actions: [
          // Timer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _timerColor.withAlpha(20),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _timerColor.withAlpha(80)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer_outlined, size: 16, color: _timerColor),
                  const SizedBox(width: 4),
                  Text(
                    _timerText,
                    style: TextStyle(
                      color: _timerColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bookmark
          IconButton(
            onPressed: () => setState(() => _smartLearning.toggleBookmark(question.id)),
            icon: Icon(
              _smartLearning.isBookmarked(question.id) ? Icons.bookmark : Icons.bookmark_border,
              color: _smartLearning.isBookmarked(question.id) ? OntarioColors.blue : null,
            ),
          ),
        ],
      ),
      body: OntarioBackground(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Category chip
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: OntarioColors.blue.withAlpha(20),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_getCategoryIcon(question.type), size: 14, color: OntarioColors.blue),
                            const SizedBox(width: 6),
                            Text(
                              question.type.displayName,
                              style: const TextStyle(
                                fontSize: 12,
                                color: OntarioColors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(question.difficulty).withAlpha(20),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          question.difficulty.displayName,
                          style: TextStyle(
                            fontSize: 11,
                            color: _getDifficultyColor(question.difficulty),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Question
                  OntarioQuestionCard(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        question.stem,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Options
                  ...List.generate(question.options.length, (index) {
                    final isSelected = selectedAnswer == index;
                    final isCorrect = index == question.correctAnswer;
                    final hasAnswered = selectedAnswer != null;

                    Color cardColor = Colors.white;
                    Color borderColor = Colors.grey.shade200;
                    Color textColor = Colors.black87;
                    Widget? trailingIcon;

                    if (hasAnswered) {
                      if (isCorrect) {
                        cardColor = Colors.green.shade50;
                        borderColor = Colors.green;
                        textColor = Colors.green.shade800;
                        trailingIcon = const Icon(Icons.check_circle, color: Colors.green);
                      } else if (isSelected && !isCorrect) {
                        cardColor = Colors.red.shade50;
                        borderColor = Colors.red;
                        textColor = Colors.red.shade800;
                        trailingIcon = const Icon(Icons.cancel, color: Colors.red);
                      }
                    } else if (isSelected) {
                      cardColor = OntarioColors.blue.withAlpha(10);
                      borderColor = OntarioColors.blue;
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: hasAnswered ? null : () => _selectAnswer(index),
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor, width: hasAnswered && (isCorrect || isSelected) ? 2 : 1),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: (isSelected || (hasAnswered && isCorrect))
                                      ? (isCorrect ? Colors.green : isSelected ? Colors.red : OntarioColors.blue)
                                      : OntarioColors.blue.withAlpha(15),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    String.fromCharCode(65 + index),
                                    style: TextStyle(
                                      color: (isSelected || (hasAnswered && isCorrect)) ? Colors.white : OntarioColors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  question.options[index],
                                  style: TextStyle(color: textColor, fontSize: 14, height: 1.4),
                                ),
                              ),
                              if (trailingIcon != null) ...[
                                const SizedBox(width: 8),
                                trailingIcon,
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  // Explanation
                  if (selectedAnswer != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline, color: OntarioColors.blue, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Explanation',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: OntarioColors.blue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            question.explanation,
                            style: TextStyle(color: Colors.blue.shade900, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 80),
                ],
              ),
            ),
            // Bottom navigation
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 8, offset: const Offset(0, -2)),
                ],
              ),
              child: Row(
                children: [
                  if (_currentIndex > 0)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _previousQuestion,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Previous'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  if (_currentIndex > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: selectedAnswer != null ? _nextQuestion : null,
                      icon: Icon(_currentIndex < widget.questions.length - 1
                          ? Icons.arrow_forward
                          : Icons.check),
                      label: Text(_currentIndex < widget.questions.length - 1 ? 'Next' : 'Finish'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(QuestionType type) {
    switch (type) {
      case QuestionType.graduatedLicensing: return Icons.school;
      case QuestionType.trafficSigns: return Icons.stop;
      case QuestionType.rulesOfRoad: return Icons.rule;
      case QuestionType.safeDriving: return Icons.shield;
      case QuestionType.sharingRoad: return Icons.people;
      case QuestionType.specialSituations: return Icons.warning_amber;
    }
  }

  Color _getDifficultyColor(Difficulty d) {
    switch (d) {
      case Difficulty.easy: return Colors.green;
      case Difficulty.medium: return Colors.orange;
      case Difficulty.hard: return Colors.red;
    }
  }
}
