// test/app_strings_test.dart
// Comprehensive tests for AppStrings localisation layer.

import 'package:flutter_test/flutter_test.dart';
import 'package:excel_driving_g1/l10n/app_strings.dart';
import 'package:excel_driving_g1/models/question.dart';

void main() {
  const en = AppStrings(Language.english);
  const fr = AppStrings(Language.french);

  // ────────────────────────────────────────────────────────────────────────
  // Language flag
  // ────────────────────────────────────────────────────────────────────────
  group('isFr flag', () {
    test('english is not French', () => expect(en.isFr, isFalse));
    test('french is French', () => expect(fr.isFr, isTrue));
  });

  // ────────────────────────────────────────────────────────────────────────
  // Navigation labels
  // ────────────────────────────────────────────────────────────────────────
  group('Navigation labels', () {
    test('navHome EN', () => expect(en.navHome, 'Home'));
    test('navHome FR', () => expect(fr.navHome, 'Accueil'));
    test('navPractice EN', () => expect(en.navPractice, 'Practice'));
    test('navPractice FR', () => expect(fr.navPractice, 'Pratique'));
    test('navProgress EN', () => expect(en.navProgress, 'Progress'));
    test('navProgress FR', () => expect(fr.navProgress, 'Progrès'));
    test('navStudy EN', () => expect(en.navStudy, 'Study'));
    test('navStudy FR', () => expect(fr.navStudy, 'Étude'));
    test('navSettings EN', () => expect(en.navSettings, 'Settings'));
    test('navSettings FR', () => expect(fr.navSettings, 'Paramètres'));
  });

  // ────────────────────────────────────────────────────────────────────────
  // All string getters are non-empty
  // ────────────────────────────────────────────────────────────────────────
  group('All string getters are non-empty', () {
    void checkNonEmpty(String label, String enVal, String frVal) {
      test('$label EN is non-empty', () => expect(enVal.trim(), isNotEmpty));
      test('$label FR is non-empty', () => expect(frVal.trim(), isNotEmpty));
    }

    checkNonEmpty('appTitle',         en.appTitle,         fr.appTitle);
    checkNonEmpty('practiceTitle',    en.practiceTitle,    fr.practiceTitle);
    checkNonEmpty('settingsTitle',    en.settingsTitle,    fr.settingsTitle);
    checkNonEmpty('achievementsTitle',en.achievementsTitle,fr.achievementsTitle);
    checkNonEmpty('testResults',      en.testResults,      fr.testResults);
    checkNonEmpty('reviewAnswers',    en.reviewAnswers,    fr.reviewAnswers);
    checkNonEmpty('smartPractice',    en.smartPractice,    fr.smartPractice);
    checkNonEmpty('reviewMistakes',   en.reviewMistakes,   fr.reviewMistakes);
    checkNonEmpty('bookmarkedQs',     en.bookmarkedQs,     fr.bookmarkedQs);
    checkNonEmpty('weakAreaFocus',    en.weakAreaFocus,    fr.weakAreaFocus);
    checkNonEmpty('startPractising',  en.startPractising,  fr.startPractising);
    checkNonEmpty('selectTestType',   en.selectTestType,   fr.selectTestType);
    checkNonEmpty('configuration',    en.configuration,    fr.configuration);
    checkNonEmpty('topics',           en.topics,           fr.topics);
    checkNonEmpty('start',            en.start,            fr.start);
    checkNonEmpty('cancel',           en.cancel,           fr.cancel);
    checkNonEmpty('delete',           en.delete,           fr.delete);
    checkNonEmpty('accuracy',         en.accuracy,         fr.accuracy);
    checkNonEmpty('unlocked',         en.unlocked,         fr.unlocked);
    checkNonEmpty('locked',           en.locked,           fr.locked);
    checkNonEmpty('aboutSection',     en.aboutSection,     fr.aboutSection);
    checkNonEmpty('legalSection',     en.legalSection,     fr.legalSection);
    checkNonEmpty('privacyPolicy',    en.privacyPolicy,    fr.privacyPolicy);
    checkNonEmpty('termsConditions',  en.termsConditions,  fr.termsConditions);
    checkNonEmpty('supportLabel',     en.supportLabel,     fr.supportLabel);
    checkNonEmpty('appGuideLabel',    en.appGuideLabel,    fr.appGuideLabel);
  });

  // ────────────────────────────────────────────────────────────────────────
  // Parameterised strings
  // ────────────────────────────────────────────────────────────────────────
  group('Parameterised strings', () {
    test('questionsToRevisit EN contains number', () {
      expect(en.questionsToRevisit(5), contains('5'));
    });
    test('questionsToRevisit FR contains number', () {
      expect(fr.questionsToRevisit(5), contains('5'));
    });
    test('savedQuestions EN contains number', () {
      expect(en.savedQuestions(3), contains('3'));
    });
    test('savedQuestions FR contains number', () {
      expect(fr.savedQuestions(3), contains('3'));
    });
    test('topicsBelowThreshold EN contains number', () {
      expect(en.topicsBelowThreshold(2), contains('2'));
    });
    test('levelDriver EN contains level', () {
      expect(en.levelDriver(7), contains('7'));
    });
    test('xpToNextLevel EN contains xp', () {
      expect(en.xpToNextLevel(45), contains('45'));
    });
    test('questions EN contains count', () {
      expect(en.questions(20), contains('20'));
    });
    test('minutes EN contains minutes', () {
      expect(en.minutes(30), contains('30'));
    });
    test('categoryQuestions EN contains count', () {
      expect(en.categoryQuestions(12), contains('12'));
    });
  });

  // ────────────────────────────────────────────────────────────────────────
  // Enum name helpers
  // ────────────────────────────────────────────────────────────────────────
  group('difficultyName', () {
    test('easy EN', () => expect(en.difficultyName(Difficulty.easy), isNotEmpty));
    test('medium EN', () => expect(en.difficultyName(Difficulty.medium), isNotEmpty));
    test('hard EN', () => expect(en.difficultyName(Difficulty.hard), isNotEmpty));
    test('easy FR is different from EN',
        () => expect(fr.difficultyName(Difficulty.easy),
            isNot(equals(en.difficultyName(Difficulty.easy)))));
  });

  group('questionTypeName', () {
    for (final type in QuestionType.values) {
      test('$type EN is non-empty',
          () => expect(en.questionTypeName(type).trim(), isNotEmpty));
      test('$type FR is non-empty',
          () => expect(fr.questionTypeName(type).trim(), isNotEmpty));
    }
  });

  group('testTypeName', () {
    for (final type in TestType.values) {
      test('$type EN is non-empty',
          () => expect(en.testTypeName(type).trim(), isNotEmpty));
      test('$type FR is non-empty',
          () => expect(fr.testTypeName(type).trim(), isNotEmpty));
    }
  });

  // ────────────────────────────────────────────────────────────────────────
  // EN and FR are different for key strings (no accidental copy-paste)
  // ────────────────────────────────────────────────────────────────────────
  group('EN != FR for key labels', () {
    test('practiceTitle differs', () => expect(en.practiceTitle, isNot(equals(fr.practiceTitle))));
    test('settingsTitle differs', () => expect(en.settingsTitle, isNot(equals(fr.settingsTitle))));
    test('navProgress differs', () => expect(en.navProgress, isNot(equals(fr.navProgress))));
    test('unlocked differs', () => expect(en.unlocked, isNot(equals(fr.unlocked))));
  });

  // ────────────────────────────────────────────────────────────────────────
  // Legal link labels exist
  // ────────────────────────────────────────────────────────────────────────
  group('Legal section labels', () {
    test('legalSection EN', () => expect(en.legalSection, contains('Legal')));
    test('privacyPolicy EN', () => expect(en.privacyPolicy, contains('Privacy')));
    test('termsConditions EN', () => expect(en.termsConditions, isNotEmpty));
    test('supportLabel EN', () => expect(en.supportLabel, 'Support'));
    test('appGuideLabel EN', () => expect(en.appGuideLabel, contains('Guide')));
  });
}
