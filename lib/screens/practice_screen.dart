import 'package:flutter/material.dart';
import '../models/question.dart';
import '../data/question_data_manager.dart';
import '../controllers/settings_controller.dart';
import '../controllers/smart_learning_controller.dart';
import '../widgets/ontario_theme.dart';
import 'test_session_screen.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  late Difficulty _selectedDifficulty;
  Set<QuestionType> _selectedTypes = Set.from(QuestionType.values);
  final SmartLearningController _smartLearning = SmartLearningController();

  @override
  void initState() {
    super.initState();
    _selectedDifficulty = SettingsController().defaultDifficulty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Practice')),
      body: OntarioBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildConfigurationCard(),
            const SizedBox(height: 16),
            _buildSmartPracticeCard(),
            const SizedBox(height: 24),
            Text('Select Test Type', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildTestTypeCard(context, TestType.quickAssessment, Icons.flash_on, Colors.orange),
            const SizedBox(height: 12),
            _buildTestTypeCard(context, TestType.standardPractice, Icons.assignment_outlined, Colors.blue),
            const SizedBox(height: 12),
            _buildTestTypeCard(context, TestType.fullMock, Icons.quiz_outlined, Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigurationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Configuration', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            DropdownButtonFormField<Difficulty>(
              value: _selectedDifficulty,
              decoration: const InputDecoration(
                labelText: 'Difficulty Level',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.tune),
              ),
              items: Difficulty.values.map((d) => DropdownMenuItem(value: d, child: Text(d.displayName))).toList(),
              onChanged: (v) { if (v != null) setState(() => _selectedDifficulty = v); },
            ),
            const SizedBox(height: 16),
            Text('Topics', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: QuestionType.values.map((type) {
                final isSelected = _selectedTypes.contains(type);
                return FilterChip(
                  label: Text(type.displayName, style: const TextStyle(fontSize: 12)),
                  selected: isSelected,
                  onSelected: (v) {
                    setState(() {
                      if (v) {
                        _selectedTypes.add(type);
                      } else if (_selectedTypes.length > 1) {
                        _selectedTypes.remove(type);
                      }
                    });
                  },
                  selectedColor: OntarioColors.blue.withAlpha(40),
                  checkmarkColor: OntarioColors.blue,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartPracticeCard() {
    final reviewCount = _smartLearning.reviewCount;
    final bookmarkCount = _smartLearning.bookmarkCount;
    final weakAreas = _smartLearning.getWeakSubTypes();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Smart Practice', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (reviewCount > 0)
              _buildSmartOption(
                icon: Icons.replay,
                color: Colors.orange,
                title: 'Review Mistakes',
                subtitle: '$reviewCount questions to revisit',
                onTap: () => _startSmartSession('review'),
              ),
            if (bookmarkCount > 0)
              _buildSmartOption(
                icon: Icons.bookmark,
                color: OntarioColors.blue,
                title: 'Bookmarked Questions',
                subtitle: '$bookmarkCount saved questions',
                onTap: () => _startSmartSession('bookmarks'),
              ),
            if (weakAreas.isNotEmpty)
              _buildSmartOption(
                icon: Icons.trending_down,
                color: Colors.red,
                title: 'Weak Area Focus',
                subtitle: '${weakAreas.length} topics below 70%',
                onTap: () => _startSmartSession('weak'),
              ),
            if (reviewCount == 0 && bookmarkCount == 0 && weakAreas.isEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Start practising to unlock smart features!'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartOption({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withAlpha(20), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          minimumSize: const Size(70, 32),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Start', style: TextStyle(fontSize: 12)),
      ),
    );
  }

  Widget _buildTestTypeCard(BuildContext context, TestType type, IconData icon, Color color) {
    return Card(
      child: InkWell(
        onTap: () => _startTest(type),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color.withAlpha(20), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(type.displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(type.description, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildBadge('${type.questionCount} questions', Icons.quiz_outlined, color),
                        const SizedBox(width: 8),
                        _buildBadge('${type.timeInMinutes} min', Icons.timer_outlined, color),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: color),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _startTest(TestType testType) {
    final dataManager = QuestionDataManager();
    final config = TestConfiguration(
      testType: testType,
      questionCount: testType.questionCount,
      timeInMinutes: testType.timeInMinutes,
      difficulty: _selectedDifficulty,
      selectedTypes: _selectedTypes.toList(),
    );
    final questions = dataManager.getConfiguredQuestions(config);
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TestSessionScreen(configuration: config, questions: questions),
      ),
    );
  }

  void _startSmartSession(String type) {
    final dataManager = QuestionDataManager();
    List<Question> questions = [];
    if (type == 'review') {
      final ids = _smartLearning.getQuestionsForReview();
      questions = ids.map((id) => dataManager.getQuestionById(id)).whereType<Question>().toList();
    } else if (type == 'bookmarks') {
      final ids = _smartLearning.bookmarkedQuestionIds.toList();
      questions = ids.map((id) => dataManager.getQuestionById(id)).whereType<Question>().toList();
    } else if (type == 'weak') {
      final weakSubTypes = _smartLearning.getWeakSubTypes();
      questions = dataManager.allQuestions.where((q) => weakSubTypes.contains(q.subType)).toList();
    }
    if (questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No questions available')));
      return;
    }
    questions.shuffle();
    final config = TestConfiguration(
      testType: TestType.standardPractice,
      questionCount: questions.length.clamp(1, 20),
      timeInMinutes: 20,
      difficulty: _selectedDifficulty,
    );
    final selected = questions.take(config.questionCount).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TestSessionScreen(configuration: config, questions: selected),
      ),
    );
  }
}
