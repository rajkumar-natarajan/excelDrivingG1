import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/settings_controller.dart';
import '../controllers/gamification_controller.dart';
import '../controllers/smart_learning_controller.dart';
import '../models/question.dart';
import '../l10n/app_strings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = SettingsController();
    final gamification = GamificationController();
    final smartLearning = SmartLearningController();

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings(settings.language).settingsTitle)),
      body: AnimatedBuilder(
        animation: settings,
        builder: (context, _) {
          final s = AppStrings(settings.language);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSection(context, s.appearance, [
                _buildThemeTile(context, settings, s),
                _buildLanguageTile(context, settings, s),
              ]),
              const SizedBox(height: 16),
              _buildSection(context, s.practiceSection, [
                _buildDifficultyTile(context, settings, s),
              ]),
              const SizedBox(height: 16),
              _buildSection(context, s.dataSection, [
                _buildClearDataTile(context, gamification, smartLearning, s),
              ]),
              const SizedBox(height: 16),
              _buildSection(context, s.aboutSection, [
                _buildInfoTile(context, Icons.app_registration, s.appNameLabel, 'ExcelDriving G1'),
                _buildInfoTile(context, Icons.code, s.versionLabel, '1.0.0'),
                _buildInfoTile(context, Icons.gavel, s.contentSource, s.contentSourceValue),
                _buildInfoTile(context, Icons.location_on, s.province, s.provinceValue),
                _buildInfoTile(context, Icons.school, s.testPassingScore, s.testPassingScoreValue),
              ]),
              const SizedBox(height: 16),
              _buildSection(context, s.legalSection, [
                _buildLinkTile(context, Icons.privacy_tip_outlined, s.privacyPolicy,
                    'https://rajkumar-natarajan.github.io/excelDrivingG1/privacy.html'),
                _buildLinkTile(context, Icons.description_outlined, s.termsConditions,
                    'https://rajkumar-natarajan.github.io/excelDrivingG1/terms.html'),
                _buildLinkTile(context, Icons.help_outline, s.supportLabel,
                    'https://rajkumar-natarajan.github.io/excelDrivingG1/support.html'),
                _buildLinkTile(context, Icons.menu_book_outlined, s.appGuideLabel,
                    'https://rajkumar-natarajan.github.io/excelDrivingG1/app-guide.html'),
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
          child: Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        ),
        Card(
          margin: EdgeInsets.zero,
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildThemeTile(BuildContext context, SettingsController settings, AppStrings s) {
    return ListTile(
      leading: const Icon(Icons.brightness_6),
      title: Text(s.theme),
      trailing: DropdownButton<ThemeMode>(
        value: settings.themeMode,
        onChanged: (value) {
          if (value != null) settings.setThemeMode(value);
        },
        underline: const SizedBox.shrink(),
        items: [
          DropdownMenuItem(value: ThemeMode.system, child: Text(s.themeSystem)),
          DropdownMenuItem(value: ThemeMode.light, child: Text(s.themeLight)),
          DropdownMenuItem(value: ThemeMode.dark, child: Text(s.themeDark)),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context, SettingsController settings, AppStrings s) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(s.languageLabel),
      trailing: DropdownButton<Language>(
        value: settings.language,
        onChanged: (value) {
          if (value != null) settings.setLanguage(value);
        },
        underline: const SizedBox.shrink(),
        items: Language.values.map((lang) {
          return DropdownMenuItem(value: lang, child: Text('${lang.flag} ${lang.displayName}'));
        }).toList(),
      ),
    );
  }

  Widget _buildDifficultyTile(BuildContext context, SettingsController settings, AppStrings s) {
    return ListTile(
      leading: const Icon(Icons.tune),
      title: Text(s.defaultDifficulty),
      trailing: DropdownButton<Difficulty>(
        value: settings.difficulty,
        onChanged: (value) {
          if (value != null) settings.setDifficulty(value);
        },
        underline: const SizedBox.shrink(),
        items: Difficulty.values.map((d) {
          return DropdownMenuItem(value: d, child: Text(s.difficultyName(d)));
        }).toList(),
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.onSurface.withAlpha(153), size: 22),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Text(label),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withAlpha(153), fontSize: 13),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkTile(BuildContext context, IconData icon, String label, String url) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: const Icon(Icons.open_in_new, size: 18),
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
    );
  }

  Widget _buildClearDataTile(BuildContext context, GamificationController gamification, SmartLearningController smartLearning, AppStrings s) {    return ListTile(
      leading: const Icon(Icons.delete_outline, color: Colors.red),
      title: Text(s.clearAllData, style: const TextStyle(color: Colors.red)),
      subtitle: Text(s.clearDataMessage),
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(s.clearDataConfirm),
            content: Text(s.clearDataMessage),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: Text(s.cancel)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  await gamification.clearAllData();
                  await smartLearning.clearAllData();
                  if (ctx.mounted) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(s.clearAllData), backgroundColor: Colors.red),
                    );
                  }
                },
                child: Text(s.delete, style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }
}
