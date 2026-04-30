import 'package:flutter/material.dart';
import '../controllers/settings_controller.dart';
import '../l10n/app_strings.dart';
import '../models/question.dart';
import '../widgets/ontario_theme.dart';

class StudyGuideScreen extends StatelessWidget {
  const StudyGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(SettingsController().language);
    return Scaffold(
      appBar: AppBar(title: Text(s.studyGuideTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          OntarioHeaderCard(
            child: Row(
              children: [
                const Icon(Icons.menu_book, color: Colors.white, size: 36),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Ontario G1 Study Guide 🇨🇦', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 4),
                      Text('Key facts from the MTO Driver\'s Handbook', style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildCategoryCard(
            context,
            icon: '🎓',
            color: Colors.blue,
            title: QuestionType.graduatedLicensing.displayName,
            description: 'Ontario uses a two-stage graduated licensing system (GLS) to ease new drivers onto the road.',
            facts: [
              'G1 licence: 8 months minimum, zero blood alcohol allowed',
              'Must always drive with a fully licensed driver (4+ yrs) in front seat',
              'May not drive on 400-series highways or expressways',
              'No driving between midnight and 5 AM',
              'G2 test: Book after 8 months (or 4 with certified driver training)',
              'G2: No alcohol, limited passengers at night (under 19 in first 6 months)',
              'G Road test: Book 12+ months after G2',
              'Full G licence allows all privileges with no supervision requirement',
            ],
          ),
          const SizedBox(height: 12),
          _buildCategoryCard(
            context,
            icon: '🚦',
            color: Colors.red,
            title: QuestionType.trafficSigns.displayName,
            description: 'Traffic signs use colors and shapes to quickly communicate road rules.',
            facts: [
              'STOP sign: Red octagon — full stop required',
              'YIELD sign: Red/white triangle — give right-of-way',
              'Warning signs: Diamond-shaped, yellow background',
              'Regulatory signs: White background with black/red markings',
              'Blue signs: Services (gas, food, lodging, hospital)',
              'Green signs: Direction and distance information',
              'White markings: Lane lines, stop lines, crosswalks',
              'Yellow markings: Centre lines, no-passing zones',
              'Orange: Construction / work zone signs',
            ],
          ),
          const SizedBox(height: 12),
          _buildCategoryCard(
            context,
            icon: '🛣️',
            color: Colors.purple,
            title: QuestionType.rulesOfRoad.displayName,
            description: 'Core rules every Ontario driver must know.',
            facts: [
              'Default city speed: 50 km/h unless posted otherwise',
              'School/playground zones: 40 km/h when children present',
              'Highway maximum: 100 km/h (110 km/h on some 400-series)',
              'Right turn on red allowed after full stop (unless signed)',
              'Left on one-way to one-way: may turn on red after stop',
              'Right-of-way at 4-way stop: first to stop, first to go',
              'Tie at 4-way stop: driver to the right goes first',
              'Following distance: at least 2–3 seconds in good conditions',
              'No U-turn near school, church, hill, curve, or intersection',
            ],
          ),
          const SizedBox(height: 12),
          _buildCategoryCard(
            context,
            icon: '🛡️',
            color: Colors.green,
            title: QuestionType.safeDriving.displayName,
            description: 'Safe habits protect everyone on the road.',
            facts: [
              'Blood alcohol limit: under 0.08; G1/G2 = 0.00 (zero tolerance)',
              'Cannabis impairs driving same as alcohol',
              'Distracted driving: \$2,000 fine + 6 demerit points in Ontario',
              'Never use handheld phone while driving',
              'Seatbelts required for driver and all passengers',
              'Child seats required until 18 kg; booster until 36 kg',
              'Scan mirrors every 5–8 seconds',
              'Defensive driving: anticipate risks, maintain space cushion',
              'Before driving: check mirrors, lights, tires, wipers, fluids',
            ],
          ),
          const SizedBox(height: 12),
          _buildCategoryCard(
            context,
            icon: '🤝',
            color: Colors.teal,
            title: QuestionType.sharingRoad.displayName,
            description: 'Sharing the road with other users safely.',
            facts: [
              'Pedestrians always have right-of-way in marked crosswalks',
              'At uncontrolled crosswalks: yield to pedestrians waiting',
              'Cyclists ride in right lane; pass with at least 1 metre clearance',
              'Cyclists may ride on road marked for general traffic',
              'School bus: STOP when red lights flash (both directions, undivided road)',
              'Divided highway: only vehicles behind bus must stop',
              'Emergency vehicles (lights/sirens): pull right and stop',
              'Move over for stopped emergency/tow trucks (adjacent lanes)',
              'Never cut off large trucks (their blind spots are big)',
            ],
          ),
          const SizedBox(height: 12),
          _buildCategoryCard(
            context,
            icon: '⚡',
            color: Colors.orange,
            title: QuestionType.specialSituations.displayName,
            description: 'Handling unusual or hazardous conditions.',
            facts: [
              'Night driving: use low beams within 150 m of oncoming traffic',
              'High beams: only rural areas, switch to low at 150 m',
              'Rain: increase following distance, slow down',
              'Black ice: brake gently, steer in slide direction',
              'Hydroplaning: lift foot off gas, don\'t brake hard',
              'Highway: signal, check mirrors & blind spot before merging',
              'Minimum highway speed varies; hazard lights if stopped on shoulder',
              'Collision: stop, give aid, call police if \$2,000+ damage or injury',
              'Collision report form needed within 24 hrs for low-damage accidents',
            ],
          ),
          const SizedBox(height: 24),
          _buildQuickReferenceCard(context),
          const SizedBox(height: 12),
          _buildAlcoholLimitsCard(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String icon,
    required Color color,
    required String title,
    required String description,
    required List<String> facts,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: color.withAlpha(20), shape: BoxShape.circle),
          child: Center(child: Text(icon, style: const TextStyle(fontSize: 20))),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description, style: const TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
        iconColor: color,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(description, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                const SizedBox(height: 12),
                ...facts.map((fact) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6, right: 8),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                          ),
                          Expanded(child: Text(fact, style: const TextStyle(fontSize: 13))),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickReferenceCard(BuildContext context) {
    final rows = [
      ['Speed (City)', '50 km/h'],
      ['Speed (School Zone)', '40 km/h'],
      ['Speed (Highway max)', '100 km/h'],
      ['Following Distance', '2–3 seconds'],
      ['High Beam Distance', 'Switch at 150 m'],
      ['Pass Cyclists', 'Min 1 metre'],
      ['Stop for School Bus', 'When red lights flash'],
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.table_chart, color: Color(0xFF003F8A)),
                const SizedBox(width: 8),
                Text('Quick Reference', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            ...rows.map((row) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(row[0], style: const TextStyle(fontSize: 13)),
                      Text(row[1], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF003F8A))),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildAlcoholLimitsCard(BuildContext context) {
    final rows = [
      ['G1 / G2 licence', '0.00 (zero tolerance)'],
      ['Full G licence', '0.05 – warn zone'],
      ['Full G licence', '>0.08 – criminal offence'],
      ['24-hr licence suspension', '0.05 – 0.079 BAC'],
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_bar, color: Colors.red),
                const SizedBox(width: 8),
                Text('Alcohol & Drug Limits', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            ...rows.map((row) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Text(row[0], style: const TextStyle(fontSize: 13))),
                      const SizedBox(width: 8),
                      Text(row[1], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.red)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
