import 'package:flutter/material.dart';
import '../controllers/gamification_controller.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = GamificationController();
    final achievements = allAchievements;
    final unlockedIds = controller.unlockedAchievements;
    final unlockedCount = unlockedIds.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: Column(
        children: [
          _buildSummaryBanner(context, unlockedCount, achievements.length),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: achievements.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final achievement = achievements[index];
                final isUnlocked = unlockedIds.contains(achievement.id);
                return _buildAchievementCard(context, achievement, isUnlocked);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBanner(BuildContext context, int unlocked, int total) {
    final progress = total > 0 ? unlocked / total : 0.0;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF003F8A), const Color(0xFF1A5BA8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 32),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$unlocked / $total Unlocked',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text('${(progress * 100).toInt()}% complete', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white24,
              color: Colors.amber,
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(BuildContext context, Achievement achievement, bool isUnlocked) {
    final rarityColor = _rarityColor(achievement.rarity);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isUnlocked ? rarityColor.withAlpha(15) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUnlocked ? rarityColor.withAlpha(80) : Colors.grey.shade200,
          width: 1.5,
        ),
        boxShadow: isUnlocked
            ? [BoxShadow(color: rarityColor.withAlpha(30), blurRadius: 8, offset: const Offset(0, 2))]
            : [],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isUnlocked ? rarityColor.withAlpha(25) : Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  isUnlocked ? achievement.icon : '🔒',
                  style: TextStyle(fontSize: 26, color: isUnlocked ? null : Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          isUnlocked ? achievement.name : '???',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: isUnlocked ? Colors.black87 : Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isUnlocked ? rarityColor.withAlpha(20) : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _rarityName(achievement.rarity),
                          style: TextStyle(
                            fontSize: 11,
                            color: isUnlocked ? rarityColor : Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isUnlocked ? achievement.description : 'Keep practising to unlock this achievement',
                    style: TextStyle(fontSize: 12, color: isUnlocked ? Colors.grey.shade600 : Colors.grey.shade400),
                  ),
                  if (isUnlocked) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildRewardChip('⭐ ${achievement.xpReward} XP', Colors.amber),
                        const SizedBox(width: 6),
                        _buildRewardChip('🏅 ${achievement.pointsReward} pts', Colors.blue),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withAlpha(20), borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }

  Color _rarityColor(AchievementRarity rarity) {
    switch (rarity) {
      case AchievementRarity.common:
        return Colors.green;
      case AchievementRarity.uncommon:
        return Colors.blue;
      case AchievementRarity.rare:
        return Colors.purple;
      case AchievementRarity.epic:
        return Colors.orange;
      case AchievementRarity.legendary:
        return Colors.red;
    }
  }

  String _rarityName(AchievementRarity rarity) {
    switch (rarity) {
      case AchievementRarity.common: return 'Common';
      case AchievementRarity.uncommon: return 'Uncommon';
      case AchievementRarity.rare: return 'Rare';
      case AchievementRarity.epic: return 'Epic';
      case AchievementRarity.legendary: return 'Legendary';
    }
  }
}
