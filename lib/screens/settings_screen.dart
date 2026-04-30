import 'package:flutter/material.dart';
import '../controllers/settings_controller.dart';
import '../controllers/gamification_controller.dart';
import '../controllers/smart_learning_controller.dart';
import '../models/question.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = SettingsController();
    final gamification = GamificationController();
    final smartLearning = SmartLearningController();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: AnimatedBuilder(
        animation: settings,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSection(context, 'Appearance', [
                _buildThemeTile(context, settings),
              ]),
              const SizedBox(height: 16),
              _buildSection(context, 'Practice', [
                _buildDifficultyTile(context, settings),
              ]),
              const SizedBox(height: 16),
              _buildSection(context, 'Data', [
                _buildClearDataTile(context, gamification, smartLearning),
              ]),
              const SizedBox(height: 16),
              _buildSection(context, 'About', [
                _buildInfoTile(Icons.app_registration, 'App Name', 'ExcelDriving G1'),
                _buildInfoTile(Icons.code, 'Version', '1.0.0'),
                _buildInfoTile(Icons.gavel, 'Content Source', 'Ontario MTO Driver\'s Handbook 2026'),
                _buildInfoTile(Icons.location_on, 'Province', 'Ontario, Canada'),
                _buildInfoTile(Icons.school, 'Test Passing Score', '80% (16/20 or 32/40)'),
              ]),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: const Color(0xFF003F8A), fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        ),
        Card(
          margin: EdgeInsets.zero,
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildThemeTile(BuildContext context, SettingsController settings) {
    return ListTile(
      leading: const Icon(Icons.brightness_6),
      title: const Text('Theme'),
      trailing: DropdownButton<ThemeMode>(
        value: settings.themeMode,
        onChanged: (value) {
          if (value != null) settings.setThemeMode(value);
        },
        underline: const SizedBox.shrink(),
        items: const [
          DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
          DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
          DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
        ],
      ),
    );
  }

  Widget _buildDifficultyTile(BuildContext context, SettingsController settings) {
    return ListTile(
      leading: const Icon(Icons.tune),
      title: const Text('Default Difficulty'),
      trailing: DropdownButton<Difficulty>(
        value: settings.difficulty,
        onChanged: (value) {
          if (value != null) settings.setDifficulty(value);
        },
        underline: const SizedBox.shrink(),
        items: Difficulty.values.map((d) {
          return DropdownMenuItem(value: d, child: Text(d.displayName));
        }).toList(),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade600, size: 22),
      title: Text(label),
      trailing: Text(value, style: const TextStyle(color: Colors.grey, fontSize: 13)),
    );
  }

  Widget _buildClearDataTile(BuildContext context, GamificationController gamification, SmartLearningController smartLearning) {
    return ListTile(
      leading: const Icon(Icons.delete_outline, color: Colors.red),
      title: const Text('Clear All Progress', style: TextStyle(color: Colors.red)),
      subtitle: const Text('This will reset all XP, streaks, and test history'),
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Clear All Progress?'),
            content: const Text('This permanently deletes your XP, level, streaks, achievements, test history, and smart learning data. This cannot be undone.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  await gamification.clearAllData();
                  await smartLearning.clearAllData();
                  if (ctx.mounted) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('All progress cleared'), backgroundColor: Colors.red),
                    );
                  }
                },
                child: const Text('Clear All', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }
}
