import 'package:flutter/material.dart';
import '../controllers/gamification_controller.dart';
import '../controllers/settings_controller.dart';
import '../data/question_data_manager.dart';
import '../l10n/app_strings.dart';
import '../models/question.dart';
import '../widgets/ontario_theme.dart';
import 'achievements_screen.dart';
import 'test_session_screen.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int) onNavigate;

  const DashboardScreen({super.key, required this.onNavigate});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GamificationController _gamification = GamificationController();
  final SettingsController _settings = SettingsController();

  @override
  void initState() {
    super.initState();
    _gamification.addListener(_refresh);
    _settings.addListener(_refresh);
  }

  @override
  void dispose() {
    _gamification.removeListener(_refresh);
    _settings.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  void _startCategoryPractice(QuestionType type) {
    final dataManager = QuestionDataManager();
    final lang = _settings.language;
    final questions = dataManager.getRandomQuestions(10, types: [type], language: lang);
    if (questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings(lang).noQuestionsAvailable)),
      );
      return;
    }
    final config = TestConfiguration(
      testType: TestType.standardPractice,
      questionCount: questions.length,
      timeInMinutes: 10,
      difficulty: _settings.defaultDifficulty,
      selectedTypes: [type],
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestSessionScreen(configuration: config, questions: questions),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(_settings.language);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🚗', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(
              s.appTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events),
            tooltip: s.achievements,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AchievementsScreen()),
            ),
          ),
        ],
      ),
      body: OntarioBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildGamificationCard(context, s),
            const SizedBox(height: 16),
            _buildWelcomeCard(context, s),
            const SizedBox(height: 24),
            Text(
              s.quickActions,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildQuickActionGrid(context, s),
            const SizedBox(height: 24),
            Text(
              s.studyByTopic,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildTopicCards(context, s),
          ],
        ),
      ),
    );
  }

  Widget _buildGamificationCard(BuildContext context, AppStrings s) {
    final stats = _gamification.getStats();
    return Card(
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AchievementsScreen())),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [OntarioColors.blue, OntarioColors.blueLight],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    'L${stats.currentLevel}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.levelDriver(stats.currentLevel),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: stats.levelProgress.clamp(0.0, 1.0),
                        backgroundColor: OntarioColors.blue.withAlpha(30),
                        color: OntarioColors.blue,
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s.xpToNextLevel(stats.xpToNextLevel),
                      style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withAlpha(153)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🔥', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 4),
                      Text(
                        '${stats.dailyStreak}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  Text(s.streak, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface.withAlpha(153))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context, AppStrings s) {
    final dataManager = QuestionDataManager();
    final totalQ = dataManager.allQuestions.length;

    return OntarioHeaderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.isFr ? 'Préparation à l\'examen G1 de l\'Ontario 🇨🇦' : 'Ontario G1 Test Prep 🇨🇦',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 8),
          Text(
            s.isFr
                ? 'Maîtrisez les $totalQ questions du Manuel du conducteur MTO officiel.'
                : 'Master all $totalQ questions from the official MTO Driver\'s Handbook.',
            style: const TextStyle(color: Colors.white70, height: 1.4),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => widget.onNavigate(1),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: OntarioColors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(s.isFr ? 'Commencer à pratiquer' : 'Start Practising'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionGrid(BuildContext context, AppStrings s) {
    final actions = [
      (s.isFr ? 'Vérif. rapide\n(10 Q)' : 'Quick Check\n(10 Q)', Icons.flash_on, Colors.orange, TestType.quickAssessment),
      (s.isFr ? 'Test pratique\n(20 Q)' : 'Practice Test\n(20 Q)', Icons.assignment, Colors.blue, TestType.standardPractice),
      (s.isFr ? 'Exam G1 simulé\n(40 Q)' : 'Mock G1 Test\n(40 Q)', Icons.quiz, Colors.purple, TestType.fullMock),
      (s.isFr ? 'Points faibles' : 'Weak Areas', Icons.trending_up, Colors.red, null),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: actions.map((action) {
        return InkWell(
          onTap: () => action.$4 != null ? _startTest(action.$4!) : widget.onNavigate(1),
          borderRadius: BorderRadius.circular(16),
          child: Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: action.$3.withAlpha(20),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(action.$2, color: action.$3, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      action.$1,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTopicCards(BuildContext context, AppStrings s) {
    final topics = [
      (QuestionType.graduatedLicensing, Icons.school, Colors.blue,
          s.isFr ? 'Règles G1/G2' : 'Learn G1/G2 rules'),
      (QuestionType.trafficSigns, Icons.stop, Colors.red,
          s.isFr ? 'Panneaux & signaux' : 'Signs & signals'),
      (QuestionType.rulesOfRoad, Icons.rule, Colors.purple,
          s.isFr ? 'Vitesse, virages & stationnement' : 'Speed, turns & parking'),
      (QuestionType.safeDriving, Icons.shield, Colors.green,
          s.isFr ? 'Alcool, distractions' : 'Alcohol, distractions'),
      (QuestionType.sharingRoad, Icons.people, Colors.teal,
          s.isFr ? 'Cyclistes, piétons' : 'Cyclists, pedestrians'),
      (QuestionType.specialSituations, Icons.warning_amber, Colors.orange,
          s.isFr ? 'Nuit, météo, autoroutes' : 'Night, weather, highways'),
    ];

    return Column(
      children: topics.map((t) {
        final count = QuestionDataManager().getQuestionsByType(t.$1).length;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: t.$3.withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(t.$2, color: t.$3),
              ),
              title: Text(s.questionTypeName(t.$1), style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(t.$4, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withAlpha(153))),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: t.$3.withAlpha(15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$count Q',
                      style: TextStyle(fontSize: 12, color: t.$3, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              onTap: () => _startCategoryPractice(t.$1),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _startTest(TestType testType) {
    final dataManager = QuestionDataManager();
    final lang = _settings.language;
    final config = TestConfiguration(
      testType: testType,
      questionCount: testType.questionCount,
      timeInMinutes: testType.timeInMinutes,
      difficulty: _settings.defaultDifficulty,
    );
    final questions = dataManager.getConfiguredQuestions(config, language: lang);
    if (questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings(lang).noQuestionsAvailable)),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TestSessionScreen(configuration: config, questions: questions),
      ),
    );
  }
}
