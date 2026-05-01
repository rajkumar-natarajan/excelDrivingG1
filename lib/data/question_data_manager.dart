import 'dart:math';
import '../models/question.dart';
import 'french_question_translations.dart';
import 'french_translations_extra.dart';
import 'question_bank_extra.dart';
import 'question_bank_extra2.dart';
import 'french_translations_extra2.dart';

/// Manages G1 driving test question data (based on Ontario MTO Driver's Handbook)
class QuestionDataManager {
  static final QuestionDataManager _instance = QuestionDataManager._internal();
  factory QuestionDataManager() => _instance;

  List<Question> _allQuestions = [];

  QuestionDataManager._internal() {
    _allQuestions.addAll(_createGraduatedLicensingQuestions());
    _allQuestions.addAll(_createTrafficSignsQuestions());
    _allQuestions.addAll(_createRulesOfRoadQuestions());
    _allQuestions.addAll(_createSafeDrivingQuestions());
    _allQuestions.addAll(_createSharingRoadQuestions());
    _allQuestions.addAll(_createSpecialSituationsQuestions());
    _allQuestions.addAll(QuestionBankExtra.graduatedLicensing());
    _allQuestions.addAll(QuestionBankExtra.trafficSigns());
    _allQuestions.addAll(QuestionBankExtra.rulesOfRoad());
    _allQuestions.addAll(QuestionBankExtra.safeDriving());
    _allQuestions.addAll(QuestionBankExtra.sharingRoad());
    _allQuestions.addAll(QuestionBankExtra.specialSituations());
  }

  /// Re-initialise questions (useful for testing). In normal app usage the
  /// constructor populates data eagerly so this is rarely needed.
  Future<void> initialize() async {
    _allQuestions = [];
    _allQuestions.addAll(_createGraduatedLicensingQuestions());
    _allQuestions.addAll(_createTrafficSignsQuestions());
    _allQuestions.addAll(_createRulesOfRoadQuestions());
    _allQuestions.addAll(_createSafeDrivingQuestions());
    _allQuestions.addAll(_createSharingRoadQuestions());
    _allQuestions.addAll(_createSpecialSituationsQuestions());
    _allQuestions.addAll(QuestionBankExtra.graduatedLicensing());
    _allQuestions.addAll(QuestionBankExtra.trafficSigns());
    _allQuestions.addAll(QuestionBankExtra.rulesOfRoad());
    _allQuestions.addAll(QuestionBankExtra.safeDriving());
    _allQuestions.addAll(QuestionBankExtra.sharingRoad());
    _allQuestions.addAll(QuestionBankExtra.specialSituations());
  }

  List<Question> get allQuestions => List.from(_allQuestions);

  List<Question> getQuestionsByType(QuestionType type) =>
      _allQuestions.where((q) => q.type == type).toList();

  List<Question> getConfiguredQuestions(TestConfiguration config, {Language language = Language.english}) {
    var questions = List<Question>.from(_allQuestions);
    if (config.selectedTypes != null && config.selectedTypes!.isNotEmpty) {
      questions = questions.where((q) => config.selectedTypes!.contains(q.type)).toList();
    }
    if (questions.isEmpty) questions = List.from(_allQuestions);
    if (config.shuffleQuestions) questions.shuffle(Random());
    while (questions.length < config.questionCount && _allQuestions.isNotEmpty) {
      questions.addAll(List.from(_allQuestions));
      questions.shuffle(Random());
    }
    final selected = questions.take(config.questionCount).toList();
    return _shuffleOptions(_localizeAll(selected, language));
  }

  List<Question> getRandomQuestions(int count, {List<QuestionType>? types, Language language = Language.english}) {
    var questions = List<Question>.from(_allQuestions);
    if (types != null && types.isNotEmpty) {
      questions = questions.where((q) => types.contains(q.type)).toList();
    }
    questions.shuffle(Random());
    return _shuffleOptions(_localizeAll(questions.take(count).toList(), language));
  }

  Question? getQuestionById(String id) {
    try {
      return _allQuestions.firstWhere((q) => q.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Returns a localized version of a single question (public helper for smart sessions).
  Question getLocalizedQuestion(Question q, Language lang) => _localizeQuestion(q, lang);

  List<Question> _shuffleOptions(List<Question> questions) {
    final random = Random();
    return questions.map((q) => q.withShuffledOptions(random)).toList();
  }

  /// Returns a localized version of a question (French if available).
  /// The correctAnswer index is preserved because options are still in their
  /// original order — translation happens before shuffling.
  Question _localizeQuestion(Question q, Language lang) {
    if (lang == Language.english) return q;
    final t = kFrenchTranslations[q.id] ?? kFrenchTranslationsExtra[q.id] ??
            kFrenchTranslationsExtra2[q.id];
    if (t == null) return q;
    return Question(
      id: q.id,
      stem: t['stem'] as String,
      options: List<String>.from(t['options'] as List),
      correctAnswer: q.correctAnswer,
      explanation: t['explanation'] as String,
      type: q.type,
      subType: q.subType,
      difficulty: q.difficulty,
    );
  }

  List<Question> _localizeAll(List<Question> questions, Language lang) {
    if (lang == Language.english) return questions;
    return questions.map((q) => _localizeQuestion(q, lang)).toList();
  }

  // ==================== GRADUATED LICENSING ====================

  List<Question> _createGraduatedLicensingQuestions() => [
    const Question(
      id: 'gl_001',
      stem: 'What is the minimum age to apply for a G1 licence in Ontario?',
      options: ['16 years old', '17 years old', '18 years old', '15 years old'],
      correctAnswer: 0,
      explanation: 'You must be at least 16 years old to apply for a G1 licence in Ontario.',
      type: QuestionType.graduatedLicensing,
      subType: 'g1_req',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'gl_002',
      stem: 'What tests must you pass to get a G1 licence?',
      options: [
        'A vision test and a written knowledge test',
        'A road test and a vision test',
        'Only a written knowledge test',
        'A vision test, written test, and road test',
      ],
      correctAnswer: 0,
      explanation: 'To get a G1 licence you must pass a vision test and a written knowledge test about traffic signs and rules.',
      type: QuestionType.graduatedLicensing,
      subType: 'g1_req',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'gl_003',
      stem: 'When driving with a G1 licence, who must accompany you?',
      options: [
        'A fully licensed driver with at least 4 years of experience sitting in the front passenger seat',
        'Any adult over 18 years old',
        'A parent or guardian only',
        'A licensed driving instructor only',
      ],
      correctAnswer: 0,
      explanation: 'A G1 driver must be accompanied by a fully licensed driver with at least four years of driving experience sitting in the front passenger seat.',
      type: QuestionType.graduatedLicensing,
      subType: 'g1_restrict',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'gl_004',
      stem: 'What is the Blood Alcohol Concentration (BAC) limit for G1 drivers?',
      options: ['Zero (.00)', '0.05', '0.08', '0.03'],
      correctAnswer: 0,
      explanation: 'G1 drivers must have a zero Blood Alcohol Concentration (BAC) — no alcohol is permitted while driving.',
      type: QuestionType.graduatedLicensing,
      subType: 'g1_restrict',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'gl_005',
      stem: 'What are G1 drivers NOT allowed to drive on?',
      options: [
        '400-series highways and high-speed expressways',
        'Municipal roads',
        'Country roads',
        'Residential streets',
      ],
      correctAnswer: 0,
      explanation: 'G1 drivers are not allowed to drive on 400-series highways or high-speed expressways unless accompanied by a licensed driving instructor.',
      type: QuestionType.graduatedLicensing,
      subType: 'g1_restrict',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'gl_006',
      stem: 'When can G1 drivers drive at night?',
      options: [
        'Between midnight and 5 a.m. only with a licensed instructor',
        'Never — G1 drivers cannot drive at night',
        'Only between sunset and midnight',
        'Anytime, there is no night restriction',
      ],
      correctAnswer: 0,
      explanation: 'G1 drivers may not drive between midnight and 5 a.m. unless accompanied by a licensed driving instructor.',
      type: QuestionType.graduatedLicensing,
      subType: 'g1_restrict',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'gl_007',
      stem: 'How long must you hold a G1 licence before taking the G2 road test?',
      options: [
        '12 months (or 8 months with an approved driver education course)',
        '6 months',
        '24 months',
        '18 months',
      ],
      correctAnswer: 0,
      explanation: 'You must hold a G1 licence for at least 12 months before taking the G2 road test, or 8 months if you complete an approved driver education course.',
      type: QuestionType.graduatedLicensing,
      subType: 'g2_req',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'gl_008',
      stem: 'What does the graduated licensing system in Ontario aim to achieve?',
      options: [
        'Help new drivers gain experience gradually in lower-risk conditions',
        'Reduce the number of cars on the road',
        'Make it harder to get a licence',
        'Replace driving schools',
      ],
      correctAnswer: 0,
      explanation: 'The graduated licensing system is designed to help new drivers gain experience and skills gradually, starting in lower-risk conditions.',
      type: QuestionType.graduatedLicensing,
      subType: 'g1_req',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'gl_009',
      stem: 'What happens if a G1 driver is caught driving without a qualified accompanying driver?',
      options: [
        'Demerit points, a fine, and possible licence suspension',
        'Only receives a warning',
        'Must retake the written test',
        'Licence is permanently cancelled',
      ],
      correctAnswer: 0,
      explanation: 'Violating G1 conditions, including driving without a qualified accompanying driver, results in demerit points, fines, and potential licence suspension.',
      type: QuestionType.graduatedLicensing,
      subType: 'g1_restrict',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'gl_010',
      stem: 'How long does the G2 licence stage last before you can take the full G road test?',
      options: ['At least 12 months', '6 months', '24 months', '18 months'],
      correctAnswer: 0,
      explanation: 'You must hold a G2 licence for at least 12 months before taking the full G licence road test.',
      type: QuestionType.graduatedLicensing,
      subType: 'g2_req',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'gl_011',
      stem: 'What BAC limit applies to G2 drivers under 21 years old?',
      options: ['Zero (.00)', '0.05', '0.08', '0.03'],
      correctAnswer: 0,
      explanation: 'G2 drivers who are under 21 years old must have a zero Blood Alcohol Concentration while driving.',
      type: QuestionType.graduatedLicensing,
      subType: 'g2_restrict',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'gl_012',
      stem: 'What is the passenger restriction for a G2 driver during the first 6 months?',
      options: [
        'No more than 1 passenger aged 19 or under between midnight and 5 a.m.',
        'No passengers allowed at any time',
        'Maximum of 3 passengers at any time',
        'No restriction — any number of passengers allowed',
      ],
      correctAnswer: 0,
      explanation: 'During the first 6 months with a G2 licence, you may carry no more than one passenger aged 19 or under between midnight and 5 a.m.',
      type: QuestionType.graduatedLicensing,
      subType: 'g2_restrict',
      difficulty: Difficulty.hard,
    ),
    const Question(
      id: 'gl_013',
      stem: 'What is a Class G licence?',
      options: [
        'A full Ontario driver\'s licence for cars, vans, and small trucks',
        'A licence for large trucks only',
        'A learner\'s permit',
        'A motorcycle licence',
      ],
      correctAnswer: 0,
      explanation: 'Class G is the standard Ontario driver\'s licence, allowing you to drive automobiles, vans, and small trucks (under 11,000 kg).',
      type: QuestionType.graduatedLicensing,
      subType: 'g_licence',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'gl_014',
      stem: 'Does a G1 driver need to wear a seatbelt?',
      options: [
        'Yes — all occupants must wear seatbelts at all times',
        'No — seatbelts are optional for G1 drivers',
        'Only the accompanying driver needs to wear a seatbelt',
        'Only on highways',
      ],
      correctAnswer: 0,
      explanation: 'All occupants in a vehicle must wear a seatbelt at all times, including G1 drivers and their passengers.',
      type: QuestionType.graduatedLicensing,
      subType: 'g1_restrict',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'gl_015',
      stem: 'Can a G1 driver use a hands-free mobile device while driving?',
      options: [
        'No — G1 drivers cannot use any electronic device while driving',
        'Yes — hands-free devices are allowed',
        'Only when stopped at a red light',
        'Yes, but only for navigation',
      ],
      correctAnswer: 0,
      explanation: 'Novice drivers (G1 and G2) are prohibited from using any hand-held or hands-free electronic devices while driving.',
      type: QuestionType.graduatedLicensing,
      subType: 'g1_restrict',
      difficulty: Difficulty.medium,
    ),
  ];

  // ==================== TRAFFIC SIGNS ====================

  List<Question> _createTrafficSignsQuestions() => [
    const Question(
      id: 'ts_001',
      stem: 'What does an octagonal (8-sided) red sign mean?',
      options: ['Stop completely', 'Yield to traffic', 'No entry', 'School zone ahead'],
      correctAnswer: 0,
      explanation: 'An octagonal red STOP sign means you must come to a complete stop before the stop line or crosswalk.',
      type: QuestionType.trafficSigns,
      subType: 'regulatory',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'ts_002',
      stem: 'What shape is a YIELD sign?',
      options: [
        'Downward-pointing triangle (inverted triangle)',
        'Octagon',
        'Rectangle',
        'Diamond',
      ],
      correctAnswer: 0,
      explanation: 'A YIELD sign is an inverted (downward-pointing) triangle. You must slow down and give the right-of-way to traffic on the road you are entering.',
      type: QuestionType.trafficSigns,
      subType: 'regulatory',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'ts_003',
      stem: 'What does a diamond-shaped sign indicate?',
      options: [
        'A warning of a potential hazard ahead',
        'A regulatory requirement you must follow',
        'Information about services',
        'A construction zone',
      ],
      correctAnswer: 0,
      explanation: 'Diamond-shaped signs are warning signs that alert you to potential hazards ahead such as curves, hills, or intersections.',
      type: QuestionType.trafficSigns,
      subType: 'warning',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'ts_004',
      stem: 'What does a white rectangular sign with black letters indicate?',
      options: [
        'Regulatory information (rules you must obey)',
        'Hazard warnings',
        'Tourist information',
        'Service locations',
      ],
      correctAnswer: 0,
      explanation: 'White rectangular signs with black letters are regulatory signs indicating rules and regulations that must be obeyed.',
      type: QuestionType.trafficSigns,
      subType: 'regulatory',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'ts_005',
      stem: 'What should you do when you see a flashing red traffic light?',
      options: [
        'Come to a complete stop, then proceed when safe',
        'Slow down and proceed with caution',
        'Stop and wait for the light to turn green',
        'Proceed without stopping',
      ],
      correctAnswer: 0,
      explanation: 'A flashing red light is treated like a STOP sign — come to a complete stop, then proceed when it is safe to do so.',
      type: QuestionType.trafficSigns,
      subType: 'signals',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'ts_006',
      stem: 'What does a flashing yellow traffic light mean?',
      options: [
        'Slow down and proceed with caution',
        'Stop completely',
        'Speed up to clear the intersection',
        'The light is about to turn red',
      ],
      correctAnswer: 0,
      explanation: 'A flashing yellow light means proceed with caution. Slow down and watch for hazards.',
      type: QuestionType.trafficSigns,
      subType: 'signals',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'ts_007',
      stem: 'What does a solid yellow line on your side of the road mean?',
      options: [
        'Do not pass — passing is not allowed',
        'Pass only when safe',
        'You are in a construction zone',
        'Lane ends ahead',
      ],
      correctAnswer: 0,
      explanation: 'A solid yellow line on your side of the centre line means do not pass — no passing is permitted in this zone.',
      type: QuestionType.trafficSigns,
      subType: 'markings',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'ts_008',
      stem: 'What does a white diamond painted on the road mean?',
      options: [
        'A reserved lane (e.g., HOV or bus lane)',
        'A pedestrian crossing',
        'A turning lane',
        'A speed bump ahead',
      ],
      correctAnswer: 0,
      explanation: 'A white diamond painted on the road marks a reserved lane such as a High Occupancy Vehicle (HOV) lane or a bus lane.',
      type: QuestionType.trafficSigns,
      subType: 'markings',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'ts_009',
      stem: 'What colour are construction and caution zone signs in Ontario?',
      options: ['Orange', 'Yellow', 'Red', 'Blue'],
      correctAnswer: 0,
      explanation: 'Orange signs indicate construction zones and alert drivers to road work and related hazards.',
      type: QuestionType.trafficSigns,
      subType: 'warning',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'ts_010',
      stem: 'What does a green arrow on a traffic light mean?',
      options: [
        'You may proceed in the direction of the arrow — other traffic is stopped',
        'Yield to oncoming traffic before turning',
        'The light is about to change',
        'You must turn in the direction of the arrow',
      ],
      correctAnswer: 0,
      explanation: 'A green arrow means you can safely move in the direction of the arrow — conflicting traffic is stopped by a red light.',
      type: QuestionType.trafficSigns,
      subType: 'signals',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'ts_011',
      stem: 'What does a "Do Not Enter" sign look like?',
      options: [
        'A red circle with a white horizontal bar',
        'A red octagon',
        'A white rectangle with black X',
        'A red diamond with white border',
      ],
      correctAnswer: 0,
      explanation: 'A Do Not Enter sign is a red circle with a white horizontal rectangle in the center. You must not proceed in that direction.',
      type: QuestionType.trafficSigns,
      subType: 'regulatory',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'ts_012',
      stem: 'What does a yellow diamond sign with a picture of a school bus mean?',
      options: [
        'School bus stop ahead',
        'School zone — speed limit 40 km/h',
        'No school buses allowed',
        'Bus terminal ahead',
      ],
      correctAnswer: 0,
      explanation: 'A yellow diamond sign with a school bus picture warns drivers that a school bus stop is ahead — be prepared to stop.',
      type: QuestionType.trafficSigns,
      subType: 'warning',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'ts_013',
      stem: 'What does a blue sign on Ontario highways typically indicate?',
      options: [
        'Services available (gas, food, lodging)',
        'Regulatory rules',
        'Hazard warning',
        'Construction ahead',
      ],
      correctAnswer: 0,
      explanation: 'Blue signs provide information about services available nearby, such as gas stations, restaurants, and accommodations.',
      type: QuestionType.trafficSigns,
      subType: 'information',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'ts_014',
      stem: 'What does a pedestrian walk signal showing a walking figure mean?',
      options: [
        'Pedestrians may cross the street',
        'Pedestrians must stop',
        'Pedestrians have 5 seconds to finish crossing',
        'Drivers must yield to pedestrians',
      ],
      correctAnswer: 0,
      explanation: 'The walking figure (white walking person) means pedestrians may begin crossing the street.',
      type: QuestionType.trafficSigns,
      subType: 'signals',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'ts_015',
      stem: 'What does a flashing orange hand signal at a crosswalk mean for pedestrians?',
      options: [
        'Do not start crossing — finish crossing if already started',
        'Stop immediately',
        'You have plenty of time to cross',
        'Cross quickly',
      ],
      correctAnswer: 0,
      explanation: 'A flashing orange hand means pedestrians who have not started crossing should not begin. Those already crossing should finish quickly.',
      type: QuestionType.trafficSigns,
      subType: 'signals',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'ts_016',
      stem: 'What does a pennant-shaped sign mean?',
      options: [
        'No passing zone',
        'Construction zone ahead',
        'Yield to oncoming traffic',
        'Speed limit zone ends',
      ],
      correctAnswer: 0,
      explanation: 'A pennant-shaped sign marks the beginning of a No Passing Zone — no passing is permitted.',
      type: QuestionType.trafficSigns,
      subType: 'regulatory',
      difficulty: Difficulty.hard,
    ),
    const Question(
      id: 'ts_017',
      stem: 'What does a solid white line separating lanes of traffic mean?',
      options: [
        'Lane changes are discouraged — stay in your lane',
        'Lane changes are permitted',
        'The road is one-way',
        'Turning lane ahead',
      ],
      correctAnswer: 0,
      explanation: 'A solid white line between lanes indicates that lane changes are discouraged in that area.',
      type: QuestionType.trafficSigns,
      subType: 'markings',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'ts_018',
      stem: 'What does a sign with a red circle and diagonal line through a symbol indicate?',
      options: [
        'The action shown is prohibited',
        'The action shown is recommended',
        'Caution for the action shown',
        'The zone for the action shown',
      ],
      correctAnswer: 0,
      explanation: 'A red circle with a diagonal line through a symbol means that action is prohibited (e.g., no left turn, no U-turn).',
      type: QuestionType.trafficSigns,
      subType: 'regulatory',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'ts_019',
      stem: 'What must you do when the traffic light turns yellow?',
      options: [
        'Stop safely if you can — if too close, proceed through carefully',
        'Always speed up to get through',
        'Always stop immediately',
        'Treat it like a green light',
      ],
      correctAnswer: 0,
      explanation: 'A yellow light means stop if you can do so safely. If you are too close to the intersection to stop safely, proceed with caution.',
      type: QuestionType.trafficSigns,
      subType: 'signals',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'ts_020',
      stem: 'What does a broken white line on the road mean?',
      options: [
        'Lane changes and passing are permitted when safe',
        'Lane changes are prohibited',
        'Road ends ahead',
        'No passing zone',
      ],
      correctAnswer: 0,
      explanation: 'A broken (dashed) white line means you may change lanes or pass when it is safe to do so.',
      type: QuestionType.trafficSigns,
      subType: 'markings',
      difficulty: Difficulty.easy,
    ),
  ];

  // ==================== RULES OF ROAD ====================

  List<Question> _createRulesOfRoadQuestions() => [
    const Question(
      id: 'rr_001',
      stem: 'What is the maximum speed limit in a school zone unless otherwise posted?',
      options: ['40 km/h', '50 km/h', '60 km/h', '30 km/h'],
      correctAnswer: 0,
      explanation: 'The maximum speed limit in a school zone in Ontario is 40 km/h unless otherwise posted.',
      type: QuestionType.rulesOfRoad,
      subType: 'speed',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'rr_002',
      stem: 'What is the default maximum speed limit in urban areas in Ontario where no speed limit is posted?',
      options: ['50 km/h', '40 km/h', '60 km/h', '80 km/h'],
      correctAnswer: 0,
      explanation: 'The default speed limit in urban areas in Ontario is 50 km/h unless otherwise posted.',
      type: QuestionType.rulesOfRoad,
      subType: 'speed',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'rr_003',
      stem: 'What is the maximum speed limit on Ontario highways unless otherwise posted?',
      options: ['100 km/h', '80 km/h', '110 km/h', '120 km/h'],
      correctAnswer: 0,
      explanation: 'The maximum speed limit on Ontario\'s provincial highways is 100 km/h unless otherwise posted.',
      type: QuestionType.rulesOfRoad,
      subType: 'speed',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'rr_004',
      stem: 'At an uncontrolled intersection (no signs or signals), who has the right of way?',
      options: [
        'The vehicle that arrived first; if simultaneous, the vehicle on the right',
        'Always the vehicle on the left',
        'The faster vehicle',
        'The larger vehicle',
      ],
      correctAnswer: 0,
      explanation: 'At an uncontrolled intersection, the vehicle that arrives first has the right-of-way. If vehicles arrive at the same time, the vehicle on the right has the right-of-way.',
      type: QuestionType.rulesOfRoad,
      subType: 'right_of_way',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'rr_005',
      stem: 'When must you signal before making a turn?',
      options: [
        'At least 30 metres before turning in cities, 150 metres on highways',
        'Only on highways',
        'Only when other vehicles are nearby',
        '10 metres before turning anywhere',
      ],
      correctAnswer: 0,
      explanation: 'In a city or town, signal at least 30 metres before turning. On open highways, signal at least 150 metres before turning.',
      type: QuestionType.rulesOfRoad,
      subType: 'turns',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'rr_006',
      stem: 'When are you NOT allowed to make a right turn on a red light?',
      options: [
        'When there is a sign prohibiting it or pedestrians are crossing',
        'After the vehicle in front has moved',
        'Only between midnight and 6:00 am',
        'When there is a yield sign',
      ],
      correctAnswer: 0,
      explanation: 'You may not turn right on a red light if there is a sign prohibiting it, or if pedestrians are in the crosswalk.',
      type: QuestionType.rulesOfRoad,
      subType: 'intersections',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'rr_007',
      stem: 'What is the proper position for making a left turn from a one-way street?',
      options: [
        'From the leftmost lane, going into the leftmost lane',
        'From any lane going into the rightmost lane',
        'From the centre lane only',
        'From the right lane only',
      ],
      correctAnswer: 0,
      explanation: 'When turning left from a one-way street, you should be in the leftmost lane and turn into the leftmost available lane of the intersecting street.',
      type: QuestionType.rulesOfRoad,
      subType: 'turns',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'rr_008',
      stem: 'How far from a fire hydrant must you park?',
      options: ['3 metres (about 10 feet)', '1 metre', '5 metres', '6 metres'],
      correctAnswer: 0,
      explanation: 'You must not park within 3 metres (about 10 feet) of a fire hydrant at any time.',
      type: QuestionType.rulesOfRoad,
      subType: 'parking',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'rr_009',
      stem: 'What should you do when you hear or see an emergency vehicle with lights and siren on?',
      options: [
        'Pull over to the right and stop until it passes',
        'Speed up to clear the way',
        'Stop in your current lane',
        'Continue driving at the same speed',
      ],
      correctAnswer: 0,
      explanation: 'When an emergency vehicle is approaching with its siren and/or lights on, you must pull over to the right side of the road and stop until it passes.',
      type: QuestionType.rulesOfRoad,
      subType: 'right_of_way',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'rr_010',
      stem: 'What is the "Move Over" law in Ontario?',
      options: [
        'Slow down and move over to give space to emergency vehicles and tow trucks stopped on the roadside',
        'Merge left when a vehicle is trying to enter the highway',
        'Yield to vehicles changing lanes',
        'Stop completely whenever you see a police car',
      ],
      correctAnswer: 0,
      explanation: 'Ontario\'s Move Over law requires drivers to slow down to 60 km/h (or the posted limit if lower) and move over when passing stopped emergency vehicles, tow trucks, or road maintenance vehicles with lights flashing.',
      type: QuestionType.rulesOfRoad,
      subType: 'right_of_way',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'rr_011',
      stem: 'How far from a pedestrian crossover must you stop?',
      options: [
        'At the stop line, or if none, before the crossover',
        '3 metres before the crossover',
        '10 metres before the crossover',
        'On the crossover line',
      ],
      correctAnswer: 0,
      explanation: 'At a pedestrian crossover, stop at the stop line. If there is no stop line, stop before the crossover to allow pedestrians to cross safely.',
      type: QuestionType.rulesOfRoad,
      subType: 'intersections',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'rr_012',
      stem: 'When two vehicles meet on a narrow road or bridge, who must yield?',
      options: [
        'The vehicle going downhill or having more room to reverse',
        'The vehicle going uphill always has right of way',
        'The larger vehicle',
        'The slower vehicle',
      ],
      correctAnswer: 0,
      explanation: 'The vehicle going downhill, or the one that has more room to pull over, must yield and allow the other vehicle to pass on a narrow road.',
      type: QuestionType.rulesOfRoad,
      subType: 'right_of_way',
      difficulty: Difficulty.hard,
    ),
    const Question(
      id: 'rr_013',
      stem: 'What is the maximum distance you may park from the curb?',
      options: ['30 cm (about 1 foot)', '50 cm', '1 metre', '60 cm'],
      correctAnswer: 0,
      explanation: 'When parking, your vehicle must be within 30 cm (about 1 foot) of the curb.',
      type: QuestionType.rulesOfRoad,
      subType: 'parking',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'rr_014',
      stem: 'What does "following too closely" (tailgating) refer to?',
      options: [
        'Not maintaining a safe following distance from the vehicle ahead',
        'Driving side-by-side with another vehicle',
        'Speeding on the highway',
        'Failing to signal before turning',
      ],
      correctAnswer: 0,
      explanation: 'Following too closely (tailgating) means not leaving enough space between your vehicle and the one ahead. Ontario law requires a safe following distance appropriate to speed and conditions.',
      type: QuestionType.rulesOfRoad,
      subType: 'right_of_way',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'rr_015',
      stem: 'What is the "two-second rule" for following distance?',
      options: [
        'Keep at least 2 seconds of travel time between your vehicle and the one ahead',
        'Check your mirror every 2 seconds',
        'Slow down 2 seconds before stopping',
        'Signal 2 seconds before turning',
      ],
      correctAnswer: 0,
      explanation: 'The two-second rule means you should maintain at least 2 seconds of travel time between your vehicle and the vehicle ahead under normal conditions. Increase this in poor conditions.',
      type: QuestionType.rulesOfRoad,
      subType: 'right_of_way',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'rr_016',
      stem: 'When can you legally make a U-turn?',
      options: [
        'Only when it can be done safely and is not prohibited by signs',
        'Anytime you need to',
        'Only in residential areas',
        'Only on one-way streets',
      ],
      correctAnswer: 0,
      explanation: 'U-turns are permitted only when they can be completed safely and are not prohibited by signs. They are not allowed near hills, curves, or where visibility is limited.',
      type: QuestionType.rulesOfRoad,
      subType: 'turns',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'rr_017',
      stem: 'What is the speed limit in a community safety zone if nothing is posted?',
      options: ['40 km/h', '50 km/h', '30 km/h', '60 km/h'],
      correctAnswer: 0,
      explanation: 'Community safety zones are areas designated around schools, playgrounds, and community centres where the speed limit is typically 40 km/h. Fines in these zones are doubled.',
      type: QuestionType.rulesOfRoad,
      subType: 'speed',
      difficulty: Difficulty.hard,
    ),
    const Question(
      id: 'rr_018',
      stem: 'How many demerit points will you receive for stunt driving in Ontario?',
      options: ['6 demerit points', '2 demerit points', '4 demerit points', '3 demerit points'],
      correctAnswer: 0,
      explanation: 'Stunt driving carries a 6-demerit-point penalty and an immediate 30-day vehicle impoundment and licence suspension.',
      type: QuestionType.rulesOfRoad,
      subType: 'speed',
      difficulty: Difficulty.hard,
    ),
    const Question(
      id: 'rr_019',
      stem: 'What must you do before entering a roundabout?',
      options: [
        'Yield to vehicles already in the roundabout',
        'Come to a complete stop',
        'Signal left',
        'Merge into the nearest lane',
      ],
      correctAnswer: 0,
      explanation: 'Before entering a roundabout, you must yield to all vehicles already travelling within it. Enter when there is a safe gap in traffic.',
      type: QuestionType.rulesOfRoad,
      subType: 'intersections',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'rr_020',
      stem: 'When must you not park in front of a driveway?',
      options: [
        'At all times — you must never block a driveway',
        'Only between 7 a.m. and 9 p.m.',
        'Only on weekdays',
        'You may park there if you leave room to pass',
      ],
      correctAnswer: 0,
      explanation: 'You must never park in front of a driveway — it must always be kept clear so vehicles can enter and exit.',
      type: QuestionType.rulesOfRoad,
      subType: 'parking',
      difficulty: Difficulty.easy,
    ),
  ];

  // ==================== SAFE DRIVING ====================

  List<Question> _createSafeDrivingQuestions() => [
    const Question(
      id: 'sd_001',
      stem: 'What is the legal Blood Alcohol Concentration (BAC) limit for fully licensed drivers in Ontario?',
      options: ['0.08 (80 mg per 100 mL of blood)', '0.05', '0.10', '0.03'],
      correctAnswer: 0,
      explanation: 'The legal BAC limit in Ontario for fully licensed drivers is 0.08. At 0.05–0.079, drivers face escalating Administrative Licence Suspension penalties.',
      type: QuestionType.safeDriving,
      subType: 'alcohol',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'sd_002',
      stem: 'What happens if you are caught with a BAC of 0.05 for the first time in Ontario?',
      options: [
        'Immediate 3-day licence suspension and fine',
        'Criminal charge only',
        'Warning letter',
        'Mandatory jail time',
      ],
      correctAnswer: 0,
      explanation: 'A first-time BAC of 0.05 (warn range) results in an immediate 3-day licence suspension under the Administrative Licence Suspension (ALS) program.',
      type: QuestionType.safeDriving,
      subType: 'alcohol',
      difficulty: Difficulty.hard,
    ),
    const Question(
      id: 'sd_003',
      stem: 'What is distracted driving?',
      options: [
        'Any activity that takes your attention away from driving',
        'Only texting while driving',
        'Driving while tired',
        'Driving over the speed limit',
      ],
      correctAnswer: 0,
      explanation: 'Distracted driving is any activity that diverts your attention from driving, including using a phone, eating, programming a GPS, or talking to passengers.',
      type: QuestionType.safeDriving,
      subType: 'distracted',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'sd_004',
      stem: 'In Ontario, what is the fine for a first-time distracted driving conviction?',
      options: ['Up to \$1,000 plus 3 demerit points', '\$100 fine only', '\$500 fine only', 'No fine — only a warning'],
      correctAnswer: 0,
      explanation: 'First-time distracted driving carries fines up to \$1,000, 3 demerit points, and for novice drivers, a 30-day licence suspension.',
      type: QuestionType.safeDriving,
      subType: 'distracted',
      difficulty: Difficulty.hard,
    ),
    const Question(
      id: 'sd_005',
      stem: 'What is "defensive driving"?',
      options: [
        'Anticipating hazards and being prepared to react to other drivers\' mistakes',
        'Driving aggressively to maintain your speed',
        'Only driving in daylight',
        'Using your horn to warn other drivers',
      ],
      correctAnswer: 0,
      explanation: 'Defensive driving means always anticipating hazards, watching for other drivers\' errors, and being prepared to react in time to avoid an accident.',
      type: QuestionType.safeDriving,
      subType: 'defensive',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'sd_006',
      stem: 'When must all vehicle occupants wear a seatbelt in Ontario?',
      options: [
        'At all times when the vehicle is in motion',
        'Only on highways',
        'Only the driver needs to wear one',
        'Only for trips longer than 30 minutes',
      ],
      correctAnswer: 0,
      explanation: 'Ontario law requires all vehicle occupants to wear a properly adjusted seatbelt at all times while the vehicle is in motion. The driver is responsible for passengers under 16.',
      type: QuestionType.safeDriving,
      subType: 'seatbelts',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'sd_007',
      stem: 'What is the minimum fine for not wearing a seatbelt in Ontario?',
      options: ['\$200', '\$50', '\$100', '\$500'],
      correctAnswer: 0,
      explanation: 'The minimum fine for not wearing a seatbelt in Ontario is \$200, plus 2 demerit points.',
      type: QuestionType.safeDriving,
      subType: 'seatbelts',
      difficulty: Difficulty.hard,
    ),
    const Question(
      id: 'sd_008',
      stem: 'What should you do if you feel drowsy while driving?',
      options: [
        'Pull over safely and rest — do not continue driving',
        'Open the window and turn up music',
        'Drink coffee and continue',
        'Speed up to reach your destination faster',
      ],
      correctAnswer: 0,
      explanation: 'Drowsy driving is dangerous. If you feel sleepy, pull over at a safe location and rest. No trick (coffee, music, etc.) is a substitute for sleep.',
      type: QuestionType.safeDriving,
      subType: 'defensive',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'sd_009',
      stem: 'What is the proper way to hold the steering wheel?',
      options: [
        'Hands at the 9 and 3 o\'clock position',
        'One hand at the 12 o\'clock position',
        'Both hands at the 10 and 2 o\'clock position (older recommendation)',
        'One hand at 9, one hand at 6',
      ],
      correctAnswer: 0,
      explanation: 'Modern driving technique recommends placing hands at the 9 and 3 o\'clock positions for the best control and airbag safety.',
      type: QuestionType.safeDriving,
      subType: 'defensive',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'sd_010',
      stem: 'What is the safest way to check your blind spots?',
      options: [
        'Quickly turn your head to look over your shoulder',
        'Only check your mirrors',
        'Use your peripheral vision',
        'Trust your backup camera',
      ],
      correctAnswer: 0,
      explanation: 'To check a blind spot, quickly turn your head and look over your shoulder in the direction you plan to move. Mirrors alone do not cover blind spots.',
      type: QuestionType.safeDriving,
      subType: 'defensive',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'sd_011',
      stem: 'What should you check before starting your vehicle?',
      options: [
        'Adjust mirrors, check fuel, ensure seatbelt is on, check lights and brakes',
        'Only check the fuel level',
        'Only adjust the seat',
        'Only check the mirrors',
      ],
      correctAnswer: 0,
      explanation: 'Before driving, you should check: fuel level, mirrors and seat adjustment, seatbelt, and ensure lights and brakes are functioning properly.',
      type: QuestionType.safeDriving,
      subType: 'inspection',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'sd_012',
      stem: 'What is the minimum tread depth required for tires in Ontario?',
      options: ['1.5 mm', '4 mm', '3 mm', '2 mm'],
      correctAnswer: 0,
      explanation: 'Ontario law requires a minimum tread depth of 1.5 mm on tires. Winter tires should have at least 4 mm for safe winter driving.',
      type: QuestionType.safeDriving,
      subType: 'inspection',
      difficulty: Difficulty.hard,
    ),
    const Question(
      id: 'sd_013',
      stem: 'When should you use your vehicle\'s horn?',
      options: [
        'Only to warn others of danger',
        'To express frustration to other drivers',
        'Whenever you pass another vehicle',
        'To signal that you are in a hurry',
      ],
      correctAnswer: 0,
      explanation: 'Your vehicle\'s horn should only be used to warn others of a dangerous situation. Using it to express frustration or annoyance is prohibited.',
      type: QuestionType.safeDriving,
      subType: 'defensive',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'sd_014',
      stem: 'How does alcohol affect your ability to drive?',
      options: [
        'It reduces reaction time, impairs judgment, and reduces coordination',
        'It only affects driving if you drink large amounts',
        'It makes you more focused',
        'It only affects night driving',
      ],
      correctAnswer: 0,
      explanation: 'Even small amounts of alcohol impair your reaction time, judgment, coordination, and vision, making driving dangerous.',
      type: QuestionType.safeDriving,
      subType: 'alcohol',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'sd_015',
      stem: 'What should you do if your vehicle starts to skid?',
      options: [
        'Steer in the direction you want to go and ease off the gas',
        'Apply brakes hard immediately',
        'Turn the wheel sharply in the opposite direction',
        'Accelerate to regain control',
      ],
      correctAnswer: 0,
      explanation: 'If your vehicle skids, ease off the accelerator and steer in the direction you want to go. Avoid sudden braking, which can make the skid worse.',
      type: QuestionType.safeDriving,
      subType: 'defensive',
      difficulty: Difficulty.medium,
    ),
  ];

  // ==================== SHARING THE ROAD ====================

  List<Question> _createSharingRoadQuestions() => [
    const Question(
      id: 'sr_001',
      stem: 'When must you stop for a school bus with its red lights flashing?',
      options: [
        'In both directions on all roads, except divided highways',
        'Only if you are behind the bus',
        'Only on residential streets',
        'Only when children are visible',
      ],
      correctAnswer: 0,
      explanation: 'When a school bus has its upper red lights flashing and the stop arm is out, ALL traffic in BOTH directions must stop, except on divided highways where only traffic travelling in the same direction stops.',
      type: QuestionType.sharingRoad,
      subType: 'school_bus',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'sr_002',
      stem: 'How far must you stop from a school bus with flashing red lights?',
      options: ['20 metres', '10 metres', '5 metres', '30 metres'],
      correctAnswer: 0,
      explanation: 'You must stop at least 20 metres from a school bus when its upper red lights are flashing.',
      type: QuestionType.sharingRoad,
      subType: 'school_bus',
      difficulty: Difficulty.hard,
    ),
    const Question(
      id: 'sr_003',
      stem: 'What should you do when passing a cyclist?',
      options: [
        'Give at least 1 metre of space and only pass when safe',
        'Sound your horn to warn them',
        'Pass as closely as possible to save road space',
        'Flash your lights',
      ],
      correctAnswer: 0,
      explanation: 'Ontario law requires drivers to give cyclists a minimum of 1 metre of space when passing. Pass only when it is safe to do so.',
      type: QuestionType.sharingRoad,
      subType: 'cyclists',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'sr_004',
      stem: 'Who has the right of way at a pedestrian crossover?',
      options: [
        'Pedestrians always have the right of way',
        'Drivers always have the right of way',
        'The vehicle that arrives first',
        'Vehicles turning right',
      ],
      correctAnswer: 0,
      explanation: 'Pedestrians always have the right-of-way at pedestrian crossovers. Drivers must stop and yield to pedestrians who are crossing.',
      type: QuestionType.sharingRoad,
      subType: 'pedestrians',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'sr_005',
      stem: 'What is the blind spot of a large truck?',
      options: [
        'Areas directly in front, behind, and to both sides that the driver cannot see',
        'Only the area directly behind the truck',
        'Only the area to the left of the truck',
        'Large trucks do not have blind spots',
      ],
      correctAnswer: 0,
      explanation: 'Large trucks have significant blind spots (No-Zones) in front, behind, and on both sides. If you cannot see the truck driver in their mirrors, they cannot see you.',
      type: QuestionType.sharingRoad,
      subType: 'trucks',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'sr_006',
      stem: 'What should you do when an emergency vehicle approaches from behind with lights and sirens?',
      options: [
        'Pull to the right side of the road and stop until it passes',
        'Speed up and clear the way',
        'Slow down but continue driving',
        'Stop immediately in your current lane',
      ],
      correctAnswer: 0,
      explanation: 'When an emergency vehicle approaches with lights and/or siren on, pull over to the right side of the road and stop completely until it has passed.',
      type: QuestionType.sharingRoad,
      subType: 'emergency',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'sr_007',
      stem: 'When approaching a stopped school bus on a divided highway, what should you do?',
      options: [
        'Only traffic travelling in the same direction as the bus must stop',
        'All traffic in both directions must stop',
        'Continue driving normally',
        'Slow to 20 km/h and proceed',
      ],
      correctAnswer: 0,
      explanation: 'On a divided highway (with a median or raised divider), only vehicles travelling in the same direction as the stopped school bus must stop.',
      type: QuestionType.sharingRoad,
      subType: 'school_bus',
      difficulty: Difficulty.hard,
    ),
    const Question(
      id: 'sr_008',
      stem: 'What lane should a cyclist ride in?',
      options: [
        'As close to the right side of the road as practical, or in a designated bike lane',
        'In the centre of the road',
        'On the left side of the road',
        'On the sidewalk',
      ],
      correctAnswer: 0,
      explanation: 'Cyclists should ride as near to the right side of the road as practical, or in a designated bicycle lane where available.',
      type: QuestionType.sharingRoad,
      subType: 'cyclists',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'sr_009',
      stem: 'What must you do when passing a stopped emergency vehicle on the side of the road with flashing lights in Ontario?',
      options: [
        'Slow down to 60 km/h (or lower if the speed limit is less) and move over if possible',
        'Stop completely until the vehicle moves',
        'Maintain your speed and keep to your lane',
        'Sound your horn as you pass',
      ],
      correctAnswer: 0,
      explanation: 'Under Ontario\'s Move Over law, when passing a stopped emergency vehicle, tow truck, or road maintenance vehicle with flashing lights, you must slow down to 60 km/h and move over a lane if safe to do so.',
      type: QuestionType.sharingRoad,
      subType: 'emergency',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'sr_010',
      stem: 'What should you do if a pedestrian is crossing at a crosswalk controlled by traffic lights?',
      options: [
        'Yield to the pedestrian even if you have a green light',
        'Proceed as normal — green light gives you right of way',
        'Honk to warn the pedestrian',
        'Flash your lights at the pedestrian',
      ],
      correctAnswer: 0,
      explanation: 'Even when you have a green light, you must yield to pedestrians who are already in the crosswalk. Pedestrian safety always takes priority.',
      type: QuestionType.sharingRoad,
      subType: 'pedestrians',
      difficulty: Difficulty.medium,
    ),
  ];

  // ==================== SPECIAL SITUATIONS ====================

  List<Question> _createSpecialSituationsQuestions() => [
    const Question(
      id: 'ss_001',
      stem: 'When should you use your low beam headlights?',
      options: [
        'From half an hour after sunset to half an hour before sunrise, and in poor visibility',
        'Only after midnight',
        'Only in fog',
        'Only on highways',
      ],
      correctAnswer: 0,
      explanation: 'You must use your headlights from one-half hour before sunset to one-half hour after sunrise, and at any other time when visibility is poor.',
      type: QuestionType.specialSituations,
      subType: 'night',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'ss_002',
      stem: 'When must you switch from high beams to low beams?',
      options: [
        'Within 150 metres of an oncoming vehicle, or when following within 60 metres of another vehicle',
        'Only in the city',
        'Only when asked by the other driver',
        'Within 50 metres of any vehicle',
      ],
      correctAnswer: 0,
      explanation: 'Switch to low beams when you are within 150 metres of an oncoming vehicle, or when following within 60 metres of another vehicle.',
      type: QuestionType.specialSituations,
      subType: 'night',
      difficulty: Difficulty.hard,
    ),
    const Question(
      id: 'ss_003',
      stem: 'What should you do when driving in heavy rain or fog?',
      options: [
        'Turn on low beam headlights and reduce speed',
        'Use high beams for better visibility',
        'Turn on hazard lights and drive at normal speed',
        'Stop on the shoulder until conditions improve',
      ],
      correctAnswer: 0,
      explanation: 'In fog or heavy rain, use low beam headlights (high beams reflect off fog/rain and reduce visibility), reduce your speed, and increase your following distance.',
      type: QuestionType.specialSituations,
      subType: 'weather',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'ss_004',
      stem: 'What should you do if your brakes fail while driving?',
      options: [
        'Pump the brakes, downshift, use the emergency brake gradually, and steer to safety',
        'Turn off the engine immediately',
        'Swerve into the curb',
        'Flash your lights and horn repeatedly',
      ],
      correctAnswer: 0,
      explanation: 'If your brakes fail, pump them several times, downshift to a lower gear, gently apply the parking brake, and steer safely off the road. Sound your horn to warn others.',
      type: QuestionType.specialSituations,
      subType: 'collisions',
      difficulty: Difficulty.hard,
    ),
    const Question(
      id: 'ss_005',
      stem: 'What is the proper following distance in icy or snowy conditions?',
      options: [
        'At least 4 times greater than normal (8–10 seconds)',
        'The same as normal conditions',
        'Twice the normal distance',
        'One second for every 10 km/h of speed',
      ],
      correctAnswer: 0,
      explanation: 'In snowy or icy conditions, your stopping distance can be 4 times greater than on dry roads. Increase your following distance to at least 8–10 seconds.',
      type: QuestionType.specialSituations,
      subType: 'weather',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'ss_006',
      stem: 'What must you do if you are involved in a collision causing injury or death?',
      options: [
        'Stop, call 911, render assistance, and report to police',
        'Exchange information and leave',
        'Call your insurance company first',
        'Move all vehicles off the road immediately',
      ],
      correctAnswer: 0,
      explanation: 'If a collision involves injury or death, you must stop, call 911 immediately, provide assistance if safe to do so, and remain at the scene until police arrive.',
      type: QuestionType.specialSituations,
      subType: 'collisions',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'ss_007',
      stem: 'When must you report a collision to the police?',
      options: [
        'When there is injury, death, or damage exceeding \$2,000',
        'Only when someone is injured',
        'Only on highways',
        'All collisions regardless of damage',
      ],
      correctAnswer: 0,
      explanation: 'In Ontario, you must report a collision to police when it involves injury or death, or property/vehicle damage exceeding \$2,000.',
      type: QuestionType.specialSituations,
      subType: 'collisions',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'ss_008',
      stem: 'When merging onto a highway, who has the right of way?',
      options: [
        'Traffic already on the highway — you must yield and find a gap',
        'The merging vehicle — highway traffic must slow down',
        'Whoever is travelling faster',
        'The larger vehicle',
      ],
      correctAnswer: 0,
      explanation: 'When merging onto a highway, you must yield to traffic already on the highway. Use the acceleration lane to match speed and find a safe gap to merge.',
      type: QuestionType.specialSituations,
      subType: 'highway',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'ss_009',
      stem: 'What is the proper way to exit a highway?',
      options: [
        'Move to the right lane well in advance, signal, and slow down once in the exit lane',
        'Slow down on the highway first, then move to the exit lane',
        'Signal and move to the exit lane at the last moment',
        'Use your hazard lights when exiting',
      ],
      correctAnswer: 0,
      explanation: 'To exit a highway, move into the right lane well in advance of your exit. Signal your intention and only reduce speed once you are fully in the exit/deceleration lane.',
      type: QuestionType.specialSituations,
      subType: 'highway',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'ss_010',
      stem: 'What should you do if your tire blows out while driving?',
      options: [
        'Hold the steering wheel firmly, ease off the gas, steer straight, and slow down gradually',
        'Brake hard immediately',
        'Swerve to the side of the road quickly',
        'Accelerate to maintain control',
      ],
      correctAnswer: 0,
      explanation: 'If a tire blows out, grip the steering wheel firmly to maintain control, ease off the accelerator, steer straight, and gradually slow down before pulling off the road safely.',
      type: QuestionType.specialSituations,
      subType: 'collisions',
      difficulty: Difficulty.hard,
    ),
    const Question(
      id: 'ss_011',
      stem: 'What does hydroplaning mean?',
      options: [
        'Your tires lose contact with the road due to a layer of water, causing loss of steering',
        'Your vehicle slides on ice',
        'Your brakes overheat',
        'Water enters your engine',
      ],
      correctAnswer: 0,
      explanation: 'Hydroplaning occurs when a layer of water builds up between your tires and the road, causing you to lose traction and steering control.',
      type: QuestionType.specialSituations,
      subType: 'weather',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'ss_012',
      stem: 'When is it safe to use your hazard lights while driving?',
      options: [
        'When your vehicle is a hazard to others (e.g., slow-moving, pulled over)',
        'Whenever it is raining',
        'As a substitute for turn signals',
        'At all times in construction zones',
      ],
      correctAnswer: 0,
      explanation: 'Hazard lights should be used when your vehicle is stopped or moving slowly and could be a hazard to other drivers. Do not use them as a substitute for turn signals.',
      type: QuestionType.specialSituations,
      subType: 'night',
      difficulty: Difficulty.medium,
    ),
  ];
}
