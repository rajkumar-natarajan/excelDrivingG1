import 'package:flutter/material.dart';
import '../controllers/settings_controller.dart';
import '../controllers/smart_learning_controller.dart';
import '../l10n/app_strings.dart';
import '../models/question.dart' hide PerformanceStats, TestSessionRecord, TrendPoint, TimeStats;

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> with SingleTickerProviderStateMixin {
  final SmartLearningController _smartLearning = SmartLearningController();
  late TabController _tabController;
  AppStrings get _s => AppStrings(SettingsController().language);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _smartLearning,
      builder: (context, _) {
        final allStats = _smartLearning.allStats;
        int totalAttempts = allStats.values.fold(0, (sum, s) => sum + s.totalAttempts);

        return Scaffold(
          appBar: AppBar(
            title: Text(_s.progressTitle),
            bottom: TabBar(
              controller: _tabController,
              tabs: [Tab(text: _s.overview), Tab(text: _s.trends), Tab(text: _s.timeStats)],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(context, totalAttempts),
              _buildTrendsTab(context),
              _buildTimeStatsTab(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOverviewTab(BuildContext context, int totalAttempts) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSummaryCard(context, totalAttempts),
        const SizedBox(height: 16),
        _buildSmartLearningCard(context),
        const SizedBox(height: 24),
        Text(_s.performanceByCategory, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildCategoryProgress(context, QuestionType.graduatedLicensing, Colors.blue),
        _buildCategoryProgress(context, QuestionType.trafficSigns, Colors.red),
        _buildCategoryProgress(context, QuestionType.rulesOfRoad, Colors.purple),
        _buildCategoryProgress(context, QuestionType.safeDriving, Colors.green),
        _buildCategoryProgress(context, QuestionType.sharingRoad, Colors.teal),
        _buildCategoryProgress(context, QuestionType.specialSituations, Colors.orange),
        const SizedBox(height: 24),
        Text(_s.weakAreas, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildWeakAreasSection(context),
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context, int totalAttempts) {
    final allStats = _smartLearning.allStats;
    int totalCorrect = allStats.values.fold(0, (sum, s) => sum + s.correctAttempts);
    double overallAccuracy = totalAttempts > 0 ? (totalCorrect / totalAttempts) * 100 : 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(_s.overallPerformance, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn('$totalAttempts', _s.questionsAnswered, Icons.quiz, Colors.blue),
                _buildStatColumn('$totalCorrect', _s.correctAnswers, Icons.check_circle, Colors.green),
                _buildStatColumn('${overallAccuracy.toInt()}%', _s.overallAccuracy, Icons.percent, _getAccuracyColor(overallAccuracy)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn('${_smartLearning.masteredCount}', _s.mastered, Icons.star, Colors.amber),
                _buildStatColumn('${_smartLearning.reviewCount}', _s.toReview, Icons.replay, Colors.orange),
                _buildStatColumn('${_smartLearning.bookmarkCount}', _s.bookmarks, Icons.bookmark, Colors.purple),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: color)),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey), textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildSmartLearningCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Learning Status', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildStatusRow(Icons.star, Colors.amber, 'Mastered Questions', _smartLearning.masteredCount),
            _buildStatusRow(Icons.replay, Colors.orange, 'Due for Review', _smartLearning.reviewCount),
            _buildStatusRow(Icons.bookmark, Colors.purple, 'Bookmarked', _smartLearning.bookmarkCount),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(IconData icon, Color color, String label, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(label)),
          Text('$count', style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildCategoryProgress(BuildContext context, QuestionType type, Color color) {
    final allStats = _smartLearning.allStats;
    double accuracy = _calculateCategoryAccuracy(allStats, type);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(_s.questionTypeName(type), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: accuracy / 100,
                    backgroundColor: color.withAlpha(20),
                    color: color,
                    minHeight: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            child: Text(
              '${accuracy.toInt()}%',
              style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeakAreasSection(BuildContext context) {
    final weakAreas = _smartLearning.getWeakSubTypes();
    if (weakAreas.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('No weak areas!', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Keep it up — you\'re doing great!', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      children: weakAreas.map((subType) {
        final stats = _smartLearning.getStats(subType);
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.trending_down, color: Colors.red),
            title: Text(subType, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            subtitle: Text('${stats?.correctAttempts ?? 0}/${stats?.totalAttempts ?? 0} correct'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${stats?.accuracy.toInt() ?? 0}%',
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTrendsTab(BuildContext context) {
    final trend = _smartLearning.getAccuracyTrend();
    final recentSessions = _smartLearning.getRecentSessions(10);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildAccuracyTrendChart(context, trend),
        const SizedBox(height: 24),
        Text(_s.recentTestSessions, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        if (recentSessions.isEmpty)
          const Card(child: Padding(padding: EdgeInsets.all(20), child: Center(child: Text('No tests completed yet'))))
        else
          ...recentSessions.map((session) => _buildSessionCard(context, session)),
      ],
    );
  }

  Widget _buildAccuracyTrendChart(BuildContext context, List<TrendPoint> trend) {
    if (trend.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(Icons.trending_up, color: Colors.grey, size: 48),
              const SizedBox(height: 8),
              Text('Complete some tests to see trends', style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        ),
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Accuracy Trend', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: trend.map((point) {
                  final height = (point.value / 100 * 100).clamp(8.0, 100.0);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('${point.value.toInt()}%', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Container(
                        width: 36,
                        height: height,
                        decoration: BoxDecoration(
                          color: _getAccuracyColor(point.value),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(point.label.split('-').last, style: const TextStyle(fontSize: 9)),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionCard(BuildContext context, TestSessionRecord session) {
    final pct = (session.accuracy * 100).toInt();
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getAccuracyColor(pct.toDouble()).withAlpha(20),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text('$pct%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: _getAccuracyColor(pct.toDouble()))),
          ),
        ),
        title: Text(session.testType, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(
          '${session.correctAnswers}/${session.totalQuestions} • ${_formatDate(session.date)}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Text(
          _formatDuration(session.totalTimeSeconds),
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildTimeStatsTab(BuildContext context) {
    final timeStats = _smartLearning.allTimeStats;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (timeStats.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: Text('Complete some tests to see time statistics')),
            ),
          )
        else ...[
          Text('Time per Category', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...timeStats.entries.map((e) {
            final avg = e.value.averageTime;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.timer, color: Colors.orange),
                title: Text(e.key, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                subtitle: Text('${e.value.questionCount} questions answered'),
                trailing: Text(
                  '${avg.toInt()}s avg',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                ),
              ),
            );
          }),
        ],
      ],
    );
  }

  double _calculateCategoryAccuracy(Map<String, PerformanceStats> allStats, QuestionType type) {
    final subtypes = _getSubtypesForType(type);
    int totalAttempts = 0, totalCorrect = 0;
    for (final st in subtypes) {
      if (allStats.containsKey(st)) {
        totalAttempts += allStats[st]!.totalAttempts;
        totalCorrect += allStats[st]!.correctAttempts;
      }
    }
    return totalAttempts > 0 ? (totalCorrect / totalAttempts) * 100 : 0;
  }

  List<String> _getSubtypesForType(QuestionType type) {
    switch (type) {
      case QuestionType.graduatedLicensing:
        return ['g1_req', 'g1_restrict', 'g2_req', 'g2_restrict', 'g_licence'];
      case QuestionType.trafficSigns:
        return ['regulatory', 'warning', 'information', 'signals', 'markings'];
      case QuestionType.rulesOfRoad:
        return ['speed', 'right_of_way', 'turns', 'parking', 'intersections'];
      case QuestionType.safeDriving:
        return ['alcohol', 'distracted', 'defensive', 'seatbelts', 'inspection'];
      case QuestionType.sharingRoad:
        return ['pedestrians', 'cyclists', 'trucks', 'emergency', 'school_bus'];
      case QuestionType.specialSituations:
        return ['night', 'weather', 'highway', 'collisions'];
    }
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 80) return Colors.green;
    if (accuracy >= 60) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m}m ${s}s';
  }
}
