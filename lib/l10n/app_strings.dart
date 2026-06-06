import '../models/question.dart';

/// Localized UI strings for ExcelDriving G1 (English + French)
class AppStrings {
  final Language lang;
  const AppStrings(this.lang);

  bool get isFr => lang == Language.french;

  // ── App / Navigation ──────────────────────────────────────────
  String get appTitle => isFr ? 'ExcelDriving G1' : 'ExcelDriving G1';
  String get navHome => isFr ? 'Accueil' : 'Home';
  String get navPractice => isFr ? 'Pratique' : 'Practice';
  String get navProgress => isFr ? 'Progrès' : 'Progress';
  String get navStudy => isFr ? 'Étude' : 'Study';
  String get navSettings => isFr ? 'Paramètres' : 'Settings';

  // ── Dashboard ─────────────────────────────────────────────────
  String get achievements => isFr ? 'Succès' : 'Achievements';
  String get quickActions => isFr ? 'Actions rapides' : 'Quick Actions';
  String get studyByTopic => isFr ? 'Étude par thème' : 'Study by Topic';
  String get quickCheck => isFr ? 'Vérification rapide' : 'Quick Check';
  String get startMockTest => isFr ? 'Démarrer l\'examen simulé' : 'Start Mock Test';
  String get studyGuide => isFr ? 'Guide d\'étude' : 'Study Guide';
  String get viewProgress => isFr ? 'Voir les progrès' : 'View Progress';
  String levelDriver(int level) =>
      isFr ? 'Conducteur niveau $level' : 'Level $level Driver';
  String xpToNextLevel(int xp) =>
      isFr ? '$xp XP au prochain niveau' : '$xp XP to next level';
  String get streak => isFr ? 'série' : 'streak';
  String get noQuestionsAvailable =>
      isFr ? 'Aucune question disponible' : 'No questions available';
  String categoryQuestions(int count) =>
      isFr ? '$count questions disponibles' : '$count questions available';

  // ── Practice ─────────────────────────────────────────────────
  String get practiceTitle => isFr ? 'Pratique' : 'Practice';
  String get configuration => isFr ? 'Configuration' : 'Configuration';
  String get difficultyLevel => isFr ? 'Niveau de difficulté' : 'Difficulty Level';
  String get topics => isFr ? 'Thèmes' : 'Topics';
  String get selectTestType => isFr ? 'Choisir le type d\'examen' : 'Select Test Type';
  String get smartPractice => isFr ? 'Pratique intelligente' : 'Smart Practice';
  String get reviewMistakes => isFr ? 'Réviser les erreurs' : 'Review Mistakes';
  String questionsToRevisit(int n) =>
      isFr ? '$n questions à revoir' : '$n questions to revisit';
  String get bookmarkedQs => isFr ? 'Questions sauvegardées' : 'Bookmarked Questions';
  String savedQuestions(int n) =>
      isFr ? '$n questions sauvegardées' : '$n saved questions';
  String get weakAreaFocus => isFr ? 'Concentration sur points faibles' : 'Weak Area Focus';
  String topicsBelowThreshold(int n) =>
      isFr ? '$n thèmes en dessous de 70 %' : '$n topics below 70%';
  String get startPractising =>
      isFr ? 'Commencez à pratiquer pour débloquer les fonctions intelligentes !'
          : 'Start practising to unlock smart features!';
  String get start => isFr ? 'Démarrer' : 'Start';
  String questions(int n) => isFr ? '$n questions' : '$n questions';
  String minutes(int n) => isFr ? '$n min' : '$n min';

  // TestType labels
  String testTypeName(TestType t) {
    if (isFr) {
      switch (t) {
        case TestType.quickAssessment:
          return 'Vérification rapide';
        case TestType.standardPractice:
          return 'Pratique standard';
        case TestType.fullMock:
          return 'Examen complet simulé';
      }
    }
    return t.displayName;
  }

  String testTypeDesc(TestType t) {
    if (isFr) {
      switch (t) {
        case TestType.quickAssessment:
          return 'Évaluation rapide de 10 questions';
        case TestType.standardPractice:
          return 'Examen pratique de 20 questions';
        case TestType.fullMock:
          return 'Format officiel de l\'examen G1 (40 questions)';
      }
    }
    return t.description;
  }

  // ── Test Session ──────────────────────────────────────────────
  String questionOf(int current, int total) =>
      isFr ? 'Question $current/$total' : 'Question $current/$total';
  String get explanation => isFr ? 'Explication' : 'Explanation';
  String get previous => isFr ? 'Précédent' : 'Previous';
  String get next => isFr ? 'Suivant' : 'Next';
  String get finish => isFr ? 'Terminer' : 'Finish';

  // ── Results ───────────────────────────────────────────────────
  String get testResults => isFr ? 'Résultats de l\'examen' : 'Test Results';
  String get levelUp => isFr ? 'NIVEAU SUPÉRIEUR !' : 'LEVEL UP!';
  String youReachedLevel(int level) =>
      isFr ? 'Vous avez atteint le niveau $level !' : 'You reached Level $level!';
  String get passedBadge => isFr ? 'RÉUSSI 🎉' : 'PASSED 🎉';
  String get tryAgain => isFr ? 'RÉESSAYER' : 'TRY AGAIN';
  String get correct => isFr ? 'Correct' : 'Correct';
  String get time => isFr ? 'Temps' : 'Time';
  String get incorrect => isFr ? 'Incorrect' : 'Incorrect';
  String get passMessage =>
      isFr ? 'Excellent ! Vous avez obtenu plus de 80 % — vous êtes prêt(e) pour l\'examen G1 !'
           : 'Excellent! You scored above 80% — you\'re ready for the G1 test!';
  String get failMessage =>
      isFr ? 'Continuez à pratiquer ! Vous avez besoin de 80 % pour réussir l\'examen G1.'
           : 'Keep practising! You need 80% to pass the G1 test.';
  String get points => isFr ? 'Points' : 'Points';
  String get xp => isFr ? 'XP' : 'XP';
  String get performanceBreakdown =>
      isFr ? 'Bilan des performances' : 'Performance Breakdown';
  String get reviewAnswers => isFr ? 'Réviser les réponses' : 'Review Answers';
  String get backToHome => isFr ? 'Retour à l\'accueil' : 'Back to Home';

  // ── Review Screen ─────────────────────────────────────────────
  String get reviewQuestions => isFr ? 'Révision des questions' : 'Review Questions';
  String get yourAnswer => isFr ? 'Votre réponse' : 'Your answer';
  String get correctAnswer => isFr ? 'Bonne réponse' : 'Correct answer';
  String get incorrectOnly => isFr ? 'Incorrect seulement' : 'Incorrect only';
  String get allAnswersCorrect => isFr ? 'Toutes les réponses sont correctes ! 🎉' : 'All answers correct! 🎉';

  // ── Study Guide ───────────────────────────────────────────────
  String get studyGuideTitle => isFr ? 'Guide d\'étude' : 'Study Guide';
  String get quickReference => isFr ? 'Référence rapide' : 'Quick Reference';
  String get detail => isFr ? 'Détail' : 'Detail';
  String get rule => isFr ? 'Règle' : 'Rule';
  String get studyGuideSubtitle =>
      isFr ? 'Résumé du Manuel du conducteur MTO de l\'Ontario'
           : 'Ontario MTO Driver\'s Handbook Summary';

  // ── Progress Screen ───────────────────────────────────────────
  String get progressTitle => isFr ? 'Progrès' : 'Progress';
  String get overview => isFr ? 'Aperçu' : 'Overview';
  String get trends => isFr ? 'Tendances' : 'Trends';
  String get timeStats => isFr ? 'Statistiques de temps' : 'Time Stats';
  String get performanceByCategory => isFr ? 'Performance par catégorie' : 'Performance by Category';
  String get overallPerformance => isFr ? 'Performance globale' : 'Overall Performance';
  String get questionsAnswered => isFr ? 'Questions\nRépondues' : 'Questions\nAnswered';
  String get correctAnswers => isFr ? 'Bonnes\nRéponses' : 'Correct\nAnswers';
  String get overallAccuracy => isFr ? 'Précision\nglobale' : 'Overall\nAccuracy';
  String get mastered => isFr ? 'Maîtrisé' : 'Mastered';
  String get toReview => isFr ? 'À revoir' : 'To Review';
  String get bookmarks => isFr ? 'Signets' : 'Bookmarks';
  String get accuracyTrend => isFr ? 'Tendance de précision' : 'Accuracy Trend';
  String get recentTestSessions => isFr ? 'Sessions récentes' : 'Recent Test Sessions';
  String get categoryAccuracy => isFr ? 'Précision par catégorie' : 'Category Accuracy';
  String get weakAreas => isFr ? 'Points faibles' : 'Weak Areas';
  String get noDataYet => isFr ? 'Aucune donnée encore' : 'No data yet';
  String get startPractice => isFr ? 'Commencez à pratiquer pour voir les statistiques !' : 'Start practising to see stats!';
  String get sessionsHistory => isFr ? 'Historique des sessions' : 'Sessions History';
  String get avgTime => isFr ? 'Temps moyen par question' : 'Avg Time per Question';
  String get totalTime => isFr ? 'Temps total d\'étude' : 'Total Study Time';
  String get totalSessions => isFr ? 'Sessions totales' : 'Total Sessions';
  String get accuracy => isFr ? 'Précision' : 'Accuracy';
  String get seconds => isFr ? 's' : 's';
  String get mins => isFr ? 'min' : 'min';
  String get hrs => isFr ? 'h' : 'h';
  String get keepPractising => isFr ? 'Continuez à pratiquer pour débloquer ce succès' : 'Keep practising to unlock this achievement';

  // ── Achievements ──────────────────────────────────────────────
  String get achievementsTitle => isFr ? 'Succès' : 'Achievements';
  String get unlocked => isFr ? 'Déverrouillé' : 'Unlocked';
  String get locked => isFr ? 'Verrouillé' : 'Locked';
  String get achievementsUnlocked =>
      isFr ? 'succès déverrouillés' : 'achievements unlocked';

  // ── Settings ─────────────────────────────────────────────────
  String get settingsTitle => isFr ? 'Paramètres' : 'Settings';
  String get appearance => isFr ? 'Apparence' : 'Appearance';
  String get theme => isFr ? 'Thème' : 'Theme';
  String get themeSystem => isFr ? 'Système' : 'System';
  String get themeLight => isFr ? 'Clair' : 'Light';
  String get themeDark => isFr ? 'Sombre' : 'Dark';
  String get languageLabel => isFr ? 'Langue' : 'Language';
  String get practiceSection => isFr ? 'Pratique' : 'Practice';
  String get defaultDifficulty => isFr ? 'Difficulté par défaut' : 'Default Difficulty';
  String get dataSection => isFr ? 'Données' : 'Data';
  String get clearAllData => isFr ? 'Effacer toutes les données' : 'Clear All Data';
  String get clearDataConfirm =>
      isFr ? 'Confirmer la suppression' : 'Confirm Delete';
  String get clearDataMessage =>
      isFr ? 'Cela supprimera tout votre progrès et vos succès. Cette action est irréversible.'
           : 'This will delete all your progress and achievements. This action cannot be undone.';
  String get cancel => isFr ? 'Annuler' : 'Cancel';
  String get delete => isFr ? 'Supprimer' : 'Delete';
  String get aboutSection => isFr ? 'À propos' : 'About';
  String get appNameLabel => isFr ? 'Nom de l\'application' : 'App Name';
  String get versionLabel => isFr ? 'Version' : 'Version';
  String get contentSource => isFr ? 'Source du contenu' : 'Content Source';
  String get contentSourceValue =>
      isFr ? 'Manuel du conducteur MTO de l\'Ontario 2026'
           : 'Ontario MTO Driver\'s Handbook 2026';
  String get province => isFr ? 'Province' : 'Province';
  String get provinceValue => isFr ? 'Ontario, Canada' : 'Ontario, Canada';
  String get testPassingScore => isFr ? 'Score de réussite' : 'Test Passing Score';
  String get testPassingScoreValue =>
      isFr ? '80 % (16/20 ou 32/40)' : '80% (16/20 or 32/40)';

  String get legalSection => isFr ? 'Légal & Support' : 'Legal & Support';
  String get privacyPolicy => isFr ? 'Politique de confidentialité' : 'Privacy Policy';
  String get termsConditions => isFr ? 'Conditions d\'utilisation' : 'Terms & Conditions';
  String get supportLabel => isFr ? 'Support' : 'Support';
  String get appGuideLabel => isFr ? 'Guide de l\'application' : 'App Guide';

  // Difficulty names
  String difficultyName(Difficulty d) {
    if (isFr) {
      switch (d) {
        case Difficulty.easy:   return 'Facile';
        case Difficulty.medium: return 'Moyen';
        case Difficulty.hard:   return 'Difficile';
      }
    }
    return d.displayName;
  }

  // QuestionType display names
  String questionTypeName(QuestionType t) {
    if (isFr) {
      switch (t) {
        case QuestionType.graduatedLicensing: return 'Permis progressif';
        case QuestionType.trafficSigns:       return 'Panneaux de signalisation';
        case QuestionType.rulesOfRoad:        return 'Règles de la route';
        case QuestionType.safeDriving:        return 'Conduite sécuritaire';
        case QuestionType.sharingRoad:        return 'Partage de la route';
        case QuestionType.specialSituations:  return 'Situations spéciales';
      }
    }
    return t.displayName;
  }
}
