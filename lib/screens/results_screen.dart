import 'package:flutter/material.dart';
import '../controllers/gamification_controller.dart';
import '../controllers/settings_controller.dart';
import '../l10n/app_strings.dart';
import '../models/question.dart';
import 'review_screen.dart';

class ResultsScreen extends StatelessWidget {
  final TestResult result;
  final List<Question> questions;
  final int pointsEarned;
  final int xpEarned;
  final bool leveledUp;
  final int? newLevel;

  const ResultsScreen({
    super.key,
    required this.result,
    required this.questions,
    this.pointsEarned = 0,
    this.xpEarned = 0,
    this.leveledUp = false,
    this.newLevel,
  });

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(SettingsController().language);
    return Scaffold(
      appBar: AppBar(
        title: Text(s.testResults),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (leveledUp) _buildLevelUpBanner(context, s),
          _buildScoreCard(context, s),
          if (pointsEarned > 0 || xpEarned > 0) ...[
            const SizedBox(height: 16),
            _buildRewardsCard(context, s),
          ],
          const SizedBox(height: 24),
          Text(
            s.performanceBreakdown,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildBreakdownList(context, s),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReviewScreen(result: result, questions: questions),
              ),
            ),
            icon: const Icon(Icons.assignment_turned_in),
            label: Text(s.reviewAnswers),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(s.backToHome),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLevelUpBanner(BuildContext context, AppStrings s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade400, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Text('🎉', style: TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.levelUp,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                Text(
                  s.youReachedLevel(newLevel ?? GamificationController().currentLevel),
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const Text('⭐', style: TextStyle(fontSize: 40)),
        ],
      ),
    );
  }

  Widget _buildScoreCard(BuildContext context, AppStrings s) {
    final percentage = result.percentage;
    final color = _getScoreColor(percentage);
    final passed = result.passed;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: percentage / 100,
                    strokeWidth: 12,
                    backgroundColor: color.withAlpha(25),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${percentage.toInt()}%',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      passed ? s.passedBadge : s.tryAgain,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(context, '${result.correctAnswers}/${result.totalQuestions}', s.correct, Icons.check_circle, Colors.green),
                _buildStatItem(context, _formatDuration(result.totalTime), s.time, Icons.timer, Colors.orange),
                _buildStatItem(context, '${(100 - percentage).toInt()}%', s.incorrect, Icons.cancel, Colors.red),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: passed ? Colors.green.shade50 : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: passed ? Colors.green.shade200 : Colors.orange.shade200,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    passed ? Icons.emoji_events : Icons.info_outline,
                    color: passed ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      passed ? s.passMessage : s.failMessage,
                      style: TextStyle(
                        color: passed ? Colors.green.shade800 : Colors.orange.shade800,
                        fontSize: 13,
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

  Widget _buildRewardsCard(BuildContext context, AppStrings s) {
    return Card(
      color: Colors.amber.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildRewardItem('💰', '+$pointsEarned', s.points, Colors.amber.shade700),
            Container(width: 1, height: 40, color: Colors.amber.shade200),
            _buildRewardItem('⚡', '+$xpEarned', s.xp, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardItem(String emoji, String value, String label, Color color) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        Text(label, style: TextStyle(color: color.withAlpha(180))),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildBreakdownList(BuildContext context, AppStrings s) {
    return Column(
      children: QuestionType.values.map((type) {
        final typeAnswers = result.answers.where(
          (a) => questions.firstWhere((q) => q.id == a.questionId, orElse: () => questions.first).type == type,
        ).toList();
        if (typeAnswers.isEmpty) return const SizedBox.shrink();
        final correct = typeAnswers.where((a) => a.isCorrect).length;
        final total = typeAnswers.length;
        final pct = total > 0 ? correct / total : 0.0;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(_getCategoryIcon(type), color: _getCategoryColor(type), size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.questionTypeName(type), style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: pct,
                          backgroundColor: Colors.grey.shade200,
                          color: pct >= 0.8 ? Colors.green : pct >= 0.6 ? Colors.orange : Colors.red,
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text('$correct/$total', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '${m}m ${s}s';
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

  Color _getCategoryColor(QuestionType type) {
    switch (type) {
      case QuestionType.graduatedLicensing: return Colors.blue;
      case QuestionType.trafficSigns: return Colors.red;
      case QuestionType.rulesOfRoad: return Colors.purple;
      case QuestionType.safeDriving: return Colors.green;
      case QuestionType.sharingRoad: return Colors.teal;
      case QuestionType.specialSituations: return Colors.orange;
    }
  }
}
