/// French translations for all 92 G1 questions.
/// Map key = question id, value = {stem, options, explanation}.
const Map<String, Map<String, dynamic>> kFrenchTranslations = {
  // ── GRADUATED LICENSING ──────────────────────────────────────
  'gl_001': {
    'stem': "Quel est l'âge minimum pour demander un permis G1 en Ontario?",
    'options': ['16 ans', '17 ans', '18 ans', '15 ans'],
    'explanation':
        "Vous devez avoir au moins 16 ans pour demander un permis G1 en Ontario.",
  },
  'gl_002': {
    'stem': "Quels examens devez-vous réussir pour obtenir un permis G1?",
    'options': [
      "Un examen de la vue et un examen écrit de connaissance",
      "Un examen de conduite sur route et un examen de la vue",
      "Seulement un examen écrit de connaissance",
      "Un examen de la vue, un examen écrit et un examen de conduite sur route",
    ],
    'explanation':
        "Pour obtenir un permis G1, vous devez réussir un examen de la vue et un examen écrit de connaissance sur les panneaux de signalisation et les règles de circulation.",
  },
  'gl_003': {
    'stem': "Lorsque vous conduisez avec un permis G1, qui doit vous accompagner?",
    'options': [
      "Un conducteur titulaire d'un permis complet avec au moins 4 ans d'expérience assis sur le siège avant",
      "Tout adulte de plus de 18 ans",
      "Un parent ou tuteur seulement",
      "Un instructeur de conduite agréé seulement",
    ],
    'explanation':
        "Un conducteur G1 doit être accompagné d'un conducteur titulaire d'un permis complet avec au moins quatre ans d'expérience assis sur le siège avant.",
  },
  'gl_004': {
    'stem': "Quelle est la limite d'alcoolémie (BAC) pour les conducteurs G1?",
    'options': ["Zéro (0,00)", "0,05", "0,08", "0,03"],
    'explanation':
        "Les conducteurs G1 doivent avoir une alcoolémie (BAC) de zéro — aucune consommation d'alcool n'est permise lors de la conduite.",
  },
  'gl_005': {
    'stem': "Sur quelles routes les conducteurs G1 ne sont-ils PAS autorisés à conduire?",
    'options': [
      "Les autoroutes de la série 400 et les voies rapides à haute vitesse",
      "Les routes municipales",
      "Les routes de campagne",
      "Les rues résidentielles",
    ],
    'explanation':
        "Les conducteurs G1 ne sont pas autorisés à conduire sur les autoroutes de la série 400 ni sur les voies rapides à haute vitesse, sauf s'ils sont accompagnés d'un instructeur de conduite agréé.",
  },
  'gl_006': {
    'stem': "Quand les conducteurs G1 peuvent-ils conduire la nuit?",
    'options': [
      "Entre minuit et 5 h seulement avec un instructeur agréé",
      "Jamais — les conducteurs G1 ne peuvent pas conduire la nuit",
      "Seulement entre le coucher du soleil et minuit",
      "À tout moment, il n'y a aucune restriction nocturne",
    ],
    'explanation':
        "Les conducteurs G1 ne peuvent pas conduire entre minuit et 5 h, sauf s'ils sont accompagnés d'un instructeur de conduite agréé.",
  },
  'gl_007': {
    'stem': "Combien de temps devez-vous détenir un permis G1 avant de passer l'examen de conduite sur route G2?",
    'options': [
      "12 mois (ou 8 mois avec un cours de conduite approuvé)",
      "6 mois",
      "24 mois",
      "18 mois",
    ],
    'explanation':
        "Vous devez détenir un permis G1 pendant au moins 12 mois avant de passer l'examen de conduite G2, ou 8 mois si vous suivez un cours de conduite approuvé.",
  },
  'gl_008': {
    'stem': "Quel est l'objectif du système de permis progressif en Ontario?",
    'options': [
      "Aider les nouveaux conducteurs à acquérir de l'expérience progressivement dans des conditions à moindre risque",
      "Réduire le nombre de voitures sur la route",
      "Rendre l'obtention du permis plus difficile",
      "Remplacer les auto-écoles",
    ],
    'explanation':
        "Le système de permis progressif est conçu pour aider les nouveaux conducteurs à acquérir de l'expérience et des compétences progressivement, en commençant dans des conditions à moindre risque.",
  },
  'gl_009': {
    'stem': "Que se passe-t-il si un conducteur G1 est surpris à conduire sans un conducteur accompagnateur qualifié?",
    'options': [
      "Points d'inaptitude, amende et possible suspension du permis",
      "Seulement un avertissement",
      "Doit repasser l'examen écrit",
      "Le permis est annulé définitivement",
    ],
    'explanation':
        "Le non-respect des conditions du permis G1, y compris conduire sans conducteur accompagnateur qualifié, entraîne des points d'inaptitude, des amendes et une possible suspension du permis.",
  },
  'gl_010': {
    'stem': "Combien de temps dure l'étape du permis G2 avant que vous puissiez passer l'examen de conduite G complet?",
    'options': ["Au moins 12 mois", "6 mois", "24 mois", "18 mois"],
    'explanation':
        "Vous devez détenir un permis G2 pendant au moins 12 mois avant de passer l'examen de conduite sur route du permis G complet.",
  },
  'gl_011': {
    'stem': "Quelle limite d'alcoolémie s'applique aux conducteurs G2 de moins de 21 ans?",
    'options': ["Zéro (0,00)", "0,05", "0,08", "0,03"],
    'explanation':
        "Les conducteurs G2 de moins de 21 ans doivent avoir une alcoolémie de zéro lors de la conduite.",
  },
  'gl_012': {
    'stem': "Quelle est la restriction concernant les passagers pour un conducteur G2 pendant les 6 premiers mois?",
    'options': [
      "Pas plus d'un passager âgé de 19 ans ou moins entre minuit et 5 h",
      "Aucun passager n'est autorisé à tout moment",
      "Maximum de 3 passagers à tout moment",
      "Aucune restriction — n'importe quel nombre de passagers est autorisé",
    ],
    'explanation':
        "Pendant les 6 premiers mois avec un permis G2, vous ne pouvez pas transporter plus d'un passager âgé de 19 ans ou moins entre minuit et 5 h.",
  },
  'gl_013': {
    'stem': "Qu'est-ce qu'un permis de classe G?",
    'options': [
      "Un permis de conduire complet de l'Ontario pour les voitures, fourgonnettes et petits camions",
      "Un permis pour les gros camions seulement",
      "Un permis d'apprenti conducteur",
      "Un permis de moto",
    ],
    'explanation':
        "La classe G est le permis de conduire standard de l'Ontario, permettant de conduire des automobiles, des fourgonnettes et de petits camions (moins de 11 000 kg).",
  },
  'gl_014': {
    'stem': "Un conducteur G1 doit-il porter une ceinture de sécurité?",
    'options': [
      "Oui — tous les occupants doivent porter une ceinture de sécurité en tout temps",
      "Non — les ceintures de sécurité sont optionnelles pour les conducteurs G1",
      "Seulement le conducteur accompagnateur doit porter une ceinture",
      "Seulement sur les autoroutes",
    ],
    'explanation':
        "Tous les occupants d'un véhicule doivent porter une ceinture de sécurité en tout temps, y compris les conducteurs G1 et leurs passagers.",
  },
  'gl_015': {
    'stem': "Un conducteur G1 peut-il utiliser un appareil mobile mains libres lors de la conduite?",
    'options': [
      "Non — les conducteurs G1 ne peuvent utiliser aucun appareil électronique lors de la conduite",
      "Oui — les appareils mains libres sont autorisés",
      "Seulement lorsqu'arrêté à un feu rouge",
      "Oui, mais seulement pour la navigation",
    ],
    'explanation':
        "Les conducteurs novices (G1 et G2) ont l'interdiction d'utiliser tout appareil électronique tenu en main ou mains libres lors de la conduite.",
  },

  // ── TRAFFIC SIGNS ────────────────────────────────────────────
  'ts_001': {
    'stem': "Que signifie un panneau rouge octogonal (à 8 côtés)?",
    'options': [
      "Arrêt complet",
      "Céder la priorité",
      "Entrée interdite",
      "Zone scolaire en avant",
    ],
    'explanation':
        "Un panneau rouge octogonal STOP signifie que vous devez vous immobiliser complètement avant la ligne d'arrêt ou le passage pour piétons.",
  },
  'ts_002': {
    'stem': "Quelle est la forme d'un panneau CÉDEZ?",
    'options': [
      "Triangle pointant vers le bas (triangle inversé)",
      "Octogone",
      "Rectangle",
      "Losange",
    ],
    'explanation':
        "Un panneau CÉDEZ est un triangle inversé (pointant vers le bas). Vous devez ralentir et céder la priorité au trafic sur la route que vous empruntez.",
  },
  'ts_003': {
    'stem': "Qu'indique un panneau en forme de losange?",
    'options': [
      "Une mise en garde d'un danger potentiel en avant",
      "Une exigence réglementaire que vous devez suivre",
      "Des informations sur les services disponibles",
      "Une zone de construction",
    ],
    'explanation':
        "Les panneaux en forme de losange sont des panneaux d'avertissement qui alertent les conducteurs des dangers potentiels en avant, tels que des virages, des côtes ou des intersections.",
  },
  'ts_004': {
    'stem': "Qu'indique un panneau rectangulaire blanc avec des lettres noires?",
    'options': [
      "Informations réglementaires (règles que vous devez respecter)",
      "Avertissements de danger",
      "Informations touristiques",
      "Emplacements de services",
    ],
    'explanation':
        "Les panneaux rectangulaires blancs avec des lettres noires sont des panneaux réglementaires indiquant des règles et règlements à respecter obligatoirement.",
  },
  'ts_005': {
    'stem': "Que faire lorsque vous voyez un feu de signalisation rouge clignotant?",
    'options': [
      "Vous arrêter complètement, puis avancer quand c'est sécuritaire",
      "Ralentir et avancer avec prudence",
      "Vous arrêter et attendre que le feu devienne vert",
      "Avancer sans vous arrêter",
    ],
    'explanation':
        "Un feu rouge clignotant est traité comme un panneau STOP — immobilisez-vous complètement, puis avancez quand c'est sécuritaire.",
  },
  'ts_006': {
    'stem': "Que signifie un feu de signalisation jaune clignotant?",
    'options': [
      "Ralentir et avancer avec prudence",
      "Vous arrêter complètement",
      "Accélérer pour dégager l'intersection",
      "Le feu est sur le point de devenir rouge",
    ],
    'explanation':
        "Un feu jaune clignotant signifie avancer avec prudence. Ralentissez et soyez attentif aux dangers.",
  },
  'ts_007': {
    'stem': "Que signifie une ligne jaune continue de votre côté de la route?",
    'options': [
      "Ne pas dépasser — le dépassement n'est pas autorisé",
      "Dépasser uniquement quand c'est sécuritaire",
      "Vous êtes dans une zone de construction",
      "La voie se termine en avant",
    ],
    'explanation':
        "Une ligne jaune continue de votre côté de la ligne centrale signifie ne pas dépasser — aucun dépassement n'est permis dans cette zone.",
  },
  'ts_008': {
    'stem': "Que signifie un losange blanc peint sur la route?",
    'options': [
      "Une voie réservée (p. ex., voie covoiturage ou voie d'autobus)",
      "Un passage pour piétons",
      "Une voie de virage",
      "Un dos-d'âne en avant",
    ],
    'explanation':
        "Un losange blanc peint sur la route indique une voie réservée, comme une voie de covoiturage (VOM) ou une voie d'autobus.",
  },
  'ts_009': {
    'stem': "De quelle couleur sont les panneaux de zone de construction en Ontario?",
    'options': ["Orange", "Jaune", "Rouge", "Bleu"],
    'explanation':
        "Les panneaux orange indiquent les zones de construction et alertent les conducteurs des travaux routiers et des dangers connexes.",
  },
  'ts_010': {
    'stem': "Que signifie une flèche verte sur un feu de signalisation?",
    'options': [
      "Vous pouvez vous engager dans la direction de la flèche — les autres véhicules sont arrêtés",
      "Céder la priorité aux véhicules venant en sens inverse avant de tourner",
      "Le feu est sur le point de changer",
      "Vous devez tourner dans la direction de la flèche",
    ],
    'explanation':
        "Une flèche verte signifie que vous pouvez vous déplacer en toute sécurité dans la direction de la flèche — le trafic conflictuel est arrêté par un feu rouge.",
  },
  'ts_011': {
    'stem': "À quoi ressemble un panneau «Sens interdit»?",
    'options': [
      "Un cercle rouge avec une barre horizontale blanche",
      "Un octogone rouge",
      "Un rectangle blanc avec un X noir",
      "Un losange rouge avec une bordure blanche",
    ],
    'explanation':
        "Un panneau «Sens interdit» est un cercle rouge avec un rectangle horizontal blanc en son centre. Vous ne devez pas avancer dans cette direction.",
  },
  'ts_012': {
    'stem': "Que signifie un panneau jaune en forme de losange avec une image d'autobus scolaire?",
    'options': [
      "Arrêt d'autobus scolaire en avant",
      "Zone scolaire — limite de 40 km/h",
      "Autobus scolaires interdits",
      "Terminal d'autobus en avant",
    ],
    'explanation':
        "Un panneau jaune en losange avec une image d'autobus scolaire avertit les conducteurs qu'un arrêt d'autobus scolaire est en avant — soyez prêt à vous arrêter.",
  },
  'ts_013': {
    'stem': "Qu'indique généralement un panneau bleu sur les autoroutes de l'Ontario?",
    'options': [
      "Services disponibles (essence, nourriture, hébergement)",
      "Règles réglementaires",
      "Avertissement de danger",
      "Construction en avant",
    ],
    'explanation':
        "Les panneaux bleus fournissent des informations sur les services disponibles à proximité, tels que les stations-service, les restaurants et les hébergements.",
  },
  'ts_014': {
    'stem': "Que signifie un signal piéton montrant une silhouette qui marche?",
    'options': [
      "Les piétons peuvent traverser la rue",
      "Les piétons doivent s'arrêter",
      "Les piétons ont 5 secondes pour finir de traverser",
      "Les conducteurs doivent céder la priorité aux piétons",
    ],
    'explanation':
        "La silhouette marchante (personne blanche qui marche) signifie que les piétons peuvent commencer à traverser la rue.",
  },
  'ts_015': {
    'stem': "Que signifie pour les piétons un signal de main orange clignotant à un passage piéton?",
    'options': [
      "Ne pas commencer à traverser — finir de traverser si déjà commencé",
      "Arrêtez-vous immédiatement",
      "Vous avez amplement le temps de traverser",
      "Traversez rapidement",
    ],
    'explanation':
        "Une main orange clignotante signifie que les piétons qui n'ont pas commencé à traverser ne doivent pas le faire. Ceux qui traversent déjà doivent terminer rapidement.",
  },
  'ts_016': {
    'stem': "Que signifie un panneau en forme de fanion?",
    'options': [
      "Zone de dépassement interdit",
      "Zone de construction en avant",
      "Céder la priorité au trafic venant en sens inverse",
      "La zone de limite de vitesse se termine",
    ],
    'explanation':
        "Un panneau en forme de fanion marque le début d'une zone de dépassement interdit — aucun dépassement n'est permis.",
  },
  'ts_017': {
    'stem': "Que signifie une ligne blanche continue séparant les voies de circulation?",
    'options': [
      "Les changements de voie sont déconseillés — restez dans votre voie",
      "Les changements de voie sont autorisés",
      "La route est à sens unique",
      "Voie de virage en avant",
    ],
    'explanation':
        "Une ligne blanche continue entre les voies indique que les changements de voie sont déconseillés dans cette zone.",
  },
  'ts_018': {
    'stem': "Qu'indique un panneau avec un cercle rouge et une ligne diagonale barrant un symbole?",
    'options': [
      "L'action représentée est interdite",
      "L'action représentée est recommandée",
      "Prudence pour l'action représentée",
      "La zone pour l'action représentée",
    ],
    'explanation':
        "Un cercle rouge avec une ligne diagonale barrant un symbole signifie que cette action est interdite (p. ex., virage à gauche interdit, demi-tour interdit).",
  },
  'ts_019': {
    'stem': "Que devez-vous faire lorsque le feu de signalisation devient jaune?",
    'options': [
      "Vous arrêter en toute sécurité si possible — si trop proche, avancer avec précaution",
      "Toujours accélérer pour passer",
      "Toujours vous arrêter immédiatement",
      "Traiter comme un feu vert",
    ],
    'explanation':
        "Un feu jaune signifie s'arrêter si vous pouvez le faire en toute sécurité. Si vous êtes trop proche de l'intersection pour vous arrêter, avancez avec prudence.",
  },
  'ts_020': {
    'stem': "Que signifie une ligne blanche discontinue sur la route?",
    'options': [
      "Les changements de voie et les dépassements sont autorisés quand c'est sécuritaire",
      "Les changements de voie sont interdits",
      "La route se termine en avant",
      "Zone de dépassement interdit",
    ],
    'explanation':
        "Une ligne blanche discontinue (pointillée) signifie que vous pouvez changer de voie ou dépasser quand c'est sécuritaire.",
  },

  // ── RULES OF ROAD ────────────────────────────────────────────
  'rr_001': {
    'stem': "Quelle est la limite de vitesse maximale dans une zone scolaire sauf indication contraire?",
    'options': ["40 km/h", "50 km/h", "60 km/h", "30 km/h"],
    'explanation':
        "La limite de vitesse maximale dans une zone scolaire en Ontario est de 40 km/h, sauf indication contraire.",
  },
  'rr_002': {
    'stem': "Quelle est la limite de vitesse maximale par défaut dans les zones urbaines en Ontario où aucune limite n'est affichée?",
    'options': ["50 km/h", "40 km/h", "60 km/h", "80 km/h"],
    'explanation':
        "La limite de vitesse par défaut dans les zones urbaines en Ontario est de 50 km/h sauf indication contraire.",
  },
  'rr_003': {
    'stem': "Quelle est la limite de vitesse maximale sur les autoroutes de l'Ontario sauf indication contraire?",
    'options': ["100 km/h", "80 km/h", "110 km/h", "120 km/h"],
    'explanation':
        "La limite de vitesse maximale sur les autoroutes provinciales de l'Ontario est de 100 km/h sauf indication contraire.",
  },
  'rr_004': {
    'stem': "À une intersection non réglementée (sans panneaux ni signaux), qui a la priorité?",
    'options': [
      "Le véhicule arrivé en premier ; si simultanément, le véhicule à droite",
      "Toujours le véhicule à gauche",
      "Le véhicule le plus rapide",
      "Le plus grand véhicule",
    ],
    'explanation':
        "À une intersection non réglementée, le véhicule arrivé en premier a la priorité. Si les véhicules arrivent en même temps, le véhicule à droite a la priorité.",
  },
  'rr_005': {
    'stem': "Quand devez-vous signaler avant d'effectuer un virage?",
    'options': [
      "Au moins 30 mètres avant de tourner en ville, 150 mètres sur les autoroutes",
      "Seulement sur les autoroutes",
      "Seulement quand d'autres véhicules sont à proximité",
      "10 mètres avant de tourner n'importe où",
    ],
    'explanation':
        "En ville, signalez au moins 30 mètres avant de tourner. Sur les routes ouvertes (autoroutes), signalez au moins 150 mètres avant de tourner.",
  },
  'rr_006': {
    'stem': "Quand n'êtes-vous PAS autorisé à effectuer un virage à droite au feu rouge?",
    'options': [
      "Quand un panneau l'interdit ou que des piétons traversent",
      "Après que le véhicule devant vous s'est déplacé",
      "Seulement entre minuit et 6 h",
      "Quand il y a un panneau de priorité",
    ],
    'explanation':
        "Vous ne pouvez pas tourner à droite au feu rouge s'il y a un panneau l'interdisant, ou si des piétons se trouvent dans le passage pour piétons.",
  },
  'rr_007': {
    'stem': "Quelle est la bonne position pour effectuer un virage à gauche depuis une rue à sens unique?",
    'options': [
      "Depuis la voie la plus à gauche, en entrant dans la voie la plus à gauche",
      "Depuis n'importe quelle voie en entrant dans la voie la plus à droite",
      "Depuis la voie centrale seulement",
      "Depuis la voie de droite seulement",
    ],
    'explanation':
        "En tournant à gauche depuis une rue à sens unique, vous devriez être dans la voie la plus à gauche et tourner dans la voie la plus à gauche disponible de la rue intersectante.",
  },
  'rr_008': {
    'stem': "À quelle distance d'une borne d'incendie devez-vous vous stationner?",
    'options': [
      "3 mètres (environ 10 pieds)",
      "1 mètre",
      "5 mètres",
      "6 mètres",
    ],
    'explanation':
        "Vous ne devez pas vous stationner à moins de 3 mètres (environ 10 pieds) d'une borne d'incendie en tout temps.",
  },
  'rr_009': {
    'stem': "Que devez-vous faire quand vous entendez ou voyez un véhicule d'urgence avec lumières et sirène activées?",
    'options': [
      "Vous ranger à droite et vous arrêter jusqu'à ce qu'il soit passé",
      "Accélérer pour dégager le chemin",
      "Vous arrêter dans votre voie actuelle",
      "Continuer à rouler à la même vitesse",
    ],
    'explanation':
        "Lorsqu'un véhicule d'urgence s'approche avec sa sirène et/ou ses lumières activées, vous devez vous ranger sur le côté droit de la route et vous arrêter jusqu'à ce qu'il soit passé.",
  },
  'rr_010': {
    'stem': "Qu'est-ce que la loi «Dégager la voie» en Ontario?",
    'options': [
      "Ralentir et se déplacer pour laisser de l'espace aux véhicules d'urgence et camions de remorquage arrêtés en bord de route",
      "Fusionner à gauche quand un véhicule essaie d'entrer sur l'autoroute",
      "Céder la priorité aux véhicules qui changent de voie",
      "S'arrêter complètement chaque fois que vous voyez une voiture de police",
    ],
    'explanation':
        "La loi «Dégager la voie» de l'Ontario oblige les conducteurs à ralentir à 60 km/h (ou à la limite affichée si inférieure) et à se déplacer lors du dépassement de véhicules d'urgence, camions de remorquage ou véhicules d'entretien routier arrêtés avec des lumières clignotantes.",
  },
  'rr_011': {
    'stem': "À quelle distance d'un passage pour piétons devez-vous vous arrêter?",
    'options': [
      "À la ligne d'arrêt, ou si absente, avant le passage",
      "3 mètres avant le passage",
      "10 mètres avant le passage",
      "Sur la ligne de passage",
    ],
    'explanation':
        "À un passage pour piétons, arrêtez-vous à la ligne d'arrêt. S'il n'y en a pas, arrêtez-vous avant le passage pour permettre aux piétons de traverser en toute sécurité.",
  },
  'rr_012': {
    'stem': "Quand deux véhicules se rencontrent sur une route ou un pont étroit, qui doit céder la priorité?",
    'options': [
      "Le véhicule descendant ou celui ayant plus de place pour reculer",
      "Le véhicule montant a toujours la priorité",
      "Le plus grand véhicule",
      "Le véhicule le plus lent",
    ],
    'explanation':
        "Le véhicule qui descend, ou celui qui a plus de place pour se ranger, doit céder la priorité et permettre à l'autre de passer sur une route étroite.",
  },
  'rr_013': {
    'stem': "Quelle est la distance maximale à laquelle vous pouvez vous stationner du trottoir?",
    'options': ["30 cm (environ 1 pied)", "50 cm", "1 mètre", "60 cm"],
    'explanation':
        "Lors du stationnement, votre véhicule doit être à moins de 30 cm (environ 1 pied) du trottoir.",
  },
  'rr_014': {
    'stem': "À quoi fait référence «suivre de trop près» (coller aux pare-chocs)?",
    'options': [
      "Ne pas maintenir une distance de suivi sécuritaire avec le véhicule devant",
      "Conduire côte à côte avec un autre véhicule",
      "Excéder la vitesse sur l'autoroute",
      "Ne pas signaler avant de tourner",
    ],
    'explanation':
        "Suivre de trop près signifie ne pas laisser suffisamment d'espace entre votre véhicule et celui devant. La loi de l'Ontario exige une distance de suivi sécuritaire adaptée à la vitesse et aux conditions.",
  },
  'rr_015': {
    'stem': "Qu'est-ce que la «règle des deux secondes» pour la distance de suivi?",
    'options': [
      "Maintenir au moins 2 secondes de temps de parcours entre votre véhicule et celui devant",
      "Vérifier votre rétroviseur toutes les 2 secondes",
      "Ralentir 2 secondes avant de s'arrêter",
      "Signaler 2 secondes avant de tourner",
    ],
    'explanation':
        "La règle des deux secondes signifie que vous devez maintenir au moins 2 secondes de temps de parcours entre votre véhicule et celui devant dans des conditions normales. Augmentez cette distance dans de mauvaises conditions.",
  },
  'rr_016': {
    'stem': "Quand pouvez-vous légalement effectuer un demi-tour?",
    'options': [
      "Seulement quand il peut être effectué en toute sécurité et n'est pas interdit par des panneaux",
      "À tout moment quand vous en avez besoin",
      "Seulement dans les zones résidentielles",
      "Seulement dans les rues à sens unique",
    ],
    'explanation':
        "Les demi-tours sont permis seulement quand ils peuvent être effectués en toute sécurité et ne sont pas interdits par des panneaux. Ils ne sont pas autorisés près des côtes, des virages ou là où la visibilité est limitée.",
  },
  'rr_017': {
    'stem': "Quelle est la limite de vitesse dans une zone de sécurité communautaire si rien n'est affiché?",
    'options': ["40 km/h", "50 km/h", "30 km/h", "60 km/h"],
    'explanation':
        "Les zones de sécurité communautaires sont désignées autour des écoles, terrains de jeux et centres communautaires où la limite de vitesse est généralement de 40 km/h. Les amendes dans ces zones sont doublées.",
  },
  'rr_018': {
    'stem': "Combien de points d'inaptitude recevrez-vous pour conduite acrobatique en Ontario?",
    'options': [
      "6 points d'inaptitude",
      "2 points d'inaptitude",
      "4 points d'inaptitude",
      "3 points d'inaptitude",
    ],
    'explanation':
        "La conduite acrobatique entraîne une pénalité de 6 points d'inaptitude et une immobilisation immédiate du véhicule pendant 30 jours ainsi qu'une suspension du permis.",
  },
  'rr_019': {
    'stem': "Que devez-vous faire avant d'entrer dans un rond-point?",
    'options': [
      "Céder la priorité aux véhicules déjà dans le rond-point",
      "Vous immobiliser complètement",
      "Signaler à gauche",
      "Fusionner dans la voie la plus proche",
    ],
    'explanation':
        "Avant d'entrer dans un rond-point, vous devez céder la priorité à tous les véhicules qui y circulent déjà. Entrez quand il y a un espace sécuritaire dans la circulation.",
  },
  'rr_020': {
    'stem': "Quand ne devez-vous pas vous stationner devant une entrée de cour?",
    'options': [
      "En tout temps — vous ne devez jamais bloquer une entrée de cour",
      "Seulement entre 7 h et 21 h",
      "Seulement les jours de semaine",
      "Vous pouvez vous stationner là si vous laissez de l'espace pour passer",
    ],
    'explanation':
        "Vous ne devez jamais vous stationner devant une entrée de cour — elle doit toujours être libre pour que les véhicules puissent entrer et sortir.",
  },

  // ── SAFE DRIVING ─────────────────────────────────────────────
  'sd_001': {
    'stem': "Quelle est la limite légale d'alcoolémie (BAC) pour les conducteurs pleinement licenciés en Ontario?",
    'options': [
      "0,08 (80 mg par 100 mL de sang)",
      "0,05",
      "0,10",
      "0,03",
    ],
    'explanation':
        "La limite légale d'alcoolémie en Ontario pour les conducteurs pleinement licenciés est de 0,08. Entre 0,05 et 0,079, les conducteurs font face à des pénalités progressives de suspension administrative du permis.",
  },
  'sd_002': {
    'stem': "Que se passe-t-il si vous êtes pris pour la première fois avec une alcoolémie de 0,05 en Ontario?",
    'options': [
      "Suspension immédiate du permis de 3 jours et amende",
      "Accusation criminelle seulement",
      "Lettre d'avertissement",
      "Emprisonnement obligatoire",
    ],
    'explanation':
        "Une première alcoolémie de 0,05 (zone d'avertissement) entraîne une suspension immédiate du permis de 3 jours dans le cadre du programme de suspension administrative du permis (SAP).",
  },
  'sd_003': {
    'stem': "Qu'est-ce que la conduite distraite?",
    'options': [
      "Toute activité qui détourne votre attention de la conduite",
      "Seulement l'envoi de messages textes au volant",
      "Conduire en état de fatigue",
      "Conduire au-dessus de la limite de vitesse",
    ],
    'explanation':
        "La conduite distraite est toute activité qui détourne votre attention de la conduite, y compris l'utilisation d'un téléphone, manger, programmer un GPS ou parler aux passagers.",
  },
  'sd_004': {
    'stem': "En Ontario, quelle est l'amende pour une première condamnation pour conduite distraite?",
    'options': [
      "Jusqu'à 1 000 \$ plus 3 points d'inaptitude",
      "Amende de 100 \$ seulement",
      "Amende de 500 \$ seulement",
      "Aucune amende — seulement un avertissement",
    ],
    'explanation':
        "La première condamnation pour conduite distraite entraîne des amendes pouvant atteindre 1 000 \$, 3 points d'inaptitude et, pour les conducteurs novices, une suspension du permis de 30 jours.",
  },
  'sd_005': {
    'stem': "Qu'est-ce que la «conduite défensive»?",
    'options': [
      "Anticiper les dangers et être préparé à réagir aux erreurs des autres conducteurs",
      "Conduire agressivement pour maintenir sa vitesse",
      "Conduire uniquement de jour",
      "Utiliser son klaxon pour avertir les autres conducteurs",
    ],
    'explanation':
        "La conduite défensive signifie toujours anticiper les dangers, surveiller les erreurs des autres conducteurs et être préparé à réagir à temps pour éviter un accident.",
  },
  'sd_006': {
    'stem': "Quand tous les occupants d'un véhicule doivent-ils porter une ceinture de sécurité en Ontario?",
    'options': [
      "En tout temps lorsque le véhicule est en mouvement",
      "Seulement sur les autoroutes",
      "Seulement le conducteur en a besoin",
      "Seulement pour les trajets de plus de 30 minutes",
    ],
    'explanation':
        "La loi de l'Ontario exige que tous les occupants d'un véhicule portent une ceinture de sécurité correctement ajustée en tout temps lorsque le véhicule est en mouvement. Le conducteur est responsable des passagers de moins de 16 ans.",
  },
  'sd_007': {
    'stem': "Quelle est l'amende minimale pour ne pas porter de ceinture de sécurité en Ontario?",
    'options': ["200 \$", "50 \$", "100 \$", "500 \$"],
    'explanation':
        "L'amende minimale pour ne pas porter de ceinture de sécurité en Ontario est de 200 \$, plus 2 points d'inaptitude.",
  },
  'sd_008': {
    'stem': "Que devez-vous faire si vous vous sentez somnolent au volant?",
    'options': [
      "Vous ranger en toute sécurité et vous reposer — ne pas continuer à conduire",
      "Ouvrir la fenêtre et mettre la musique à fond",
      "Boire un café et continuer",
      "Accélérer pour atteindre votre destination plus rapidement",
    ],
    'explanation':
        "La somnolence au volant est dangereuse. Si vous vous sentez somnolent, rangez-vous à un endroit sécuritaire et reposez-vous. Aucun truc (café, musique, etc.) ne remplace le sommeil.",
  },
  'sd_009': {
    'stem': "Quelle est la bonne façon de tenir le volant?",
    'options': [
      "Mains aux positions 9 h et 3 h",
      "Une main à la position 12 h",
      "Les deux mains aux positions 10 h et 2 h (ancienne recommandation)",
      "Une main à 9 h, l'autre à 6 h",
    ],
    'explanation':
        "La technique de conduite moderne recommande de placer les mains aux positions 9 h et 3 h pour un meilleur contrôle et une meilleure sécurité avec les coussins gonflables.",
  },
  'sd_010': {
    'stem': "Quelle est la façon la plus sécuritaire de vérifier vos angles morts?",
    'options': [
      "Tourner rapidement la tête pour regarder par-dessus votre épaule",
      "Vérifier seulement vos rétroviseurs",
      "Utiliser votre vision périphérique",
      "Faire confiance à votre caméra de recul",
    ],
    'explanation':
        "Pour vérifier un angle mort, tournez rapidement la tête et regardez par-dessus votre épaule dans la direction où vous planifiez vous déplacer. Les rétroviseurs seuls ne couvrent pas les angles morts.",
  },
  'sd_011': {
    'stem': "Que devriez-vous vérifier avant de démarrer votre véhicule?",
    'options': [
      "Ajuster les rétroviseurs, vérifier le carburant, s'assurer que la ceinture est attachée, vérifier les lumières et les freins",
      "Seulement vérifier le niveau de carburant",
      "Seulement ajuster le siège",
      "Seulement vérifier les rétroviseurs",
    ],
    'explanation':
        "Avant de conduire, vérifiez : le niveau de carburant, les rétroviseurs et l'ajustement du siège, la ceinture de sécurité, et assurez-vous que les lumières et les freins fonctionnent correctement.",
  },
  'sd_012': {
    'stem': "Quelle est la profondeur minimale des rainures de pneus requise en Ontario?",
    'options': ["1,5 mm", "4 mm", "3 mm", "2 mm"],
    'explanation':
        "La loi de l'Ontario exige une profondeur minimale des rainures de 1,5 mm. Les pneus d'hiver devraient avoir au moins 4 mm pour une conduite hivernale sécuritaire.",
  },
  'sd_013': {
    'stem': "Quand devriez-vous utiliser le klaxon de votre véhicule?",
    'options': [
      "Seulement pour avertir les autres d'un danger",
      "Pour exprimer votre frustration envers les autres conducteurs",
      "Chaque fois que vous dépassez un autre véhicule",
      "Pour signaler que vous êtes pressé",
    ],
    'explanation':
        "Le klaxon de votre véhicule doit être utilisé seulement pour avertir les autres d'une situation dangereuse. L'utiliser pour exprimer frustration ou agacement est interdit.",
  },
  'sd_014': {
    'stem': "Comment l'alcool affecte-t-il votre capacité à conduire?",
    'options': [
      "Il réduit le temps de réaction, altère le jugement et réduit la coordination",
      "Il n'affecte la conduite que si vous buvez de grandes quantités",
      "Il vous rend plus concentré",
      "Il n'affecte que la conduite de nuit",
    ],
    'explanation':
        "Même de petites quantités d'alcool altèrent votre temps de réaction, votre jugement, votre coordination et votre vision, rendant la conduite dangereuse.",
  },
  'sd_015': {
    'stem': "Que devez-vous faire si votre véhicule commence à déraper?",
    'options': [
      "Diriger dans la direction où vous voulez aller et relâcher l'accélérateur",
      "Appliquer les freins fortement immédiatement",
      "Tourner le volant brusquement dans la direction opposée",
      "Accélérer pour reprendre le contrôle",
    ],
    'explanation':
        "Si votre véhicule dérape, relâchez l'accélérateur et dirigez dans la direction où vous voulez aller. Évitez le freinage brusque qui pourrait aggraver le dérapage.",
  },

  // ── SHARING THE ROAD ─────────────────────────────────────────
  'sr_001': {
    'stem': "Quand devez-vous vous arrêter pour un autobus scolaire avec ses lumières rouges clignotantes?",
    'options': [
      "Dans les deux directions sur toutes les routes, sauf les autoroutes divisées",
      "Seulement si vous êtes derrière l'autobus",
      "Seulement dans les rues résidentielles",
      "Seulement quand des enfants sont visibles",
    ],
    'explanation':
        "Quand un autobus scolaire a ses lumières rouges supérieures clignotantes et son bras d'arrêt déployé, TOUT le trafic dans les DEUX sens doit s'arrêter, sauf sur les autoroutes divisées où seul le trafic dans la même direction s'arrête.",
  },
  'sr_002': {
    'stem': "À quelle distance d'un autobus scolaire avec des lumières rouges clignotantes devez-vous vous arrêter?",
    'options': ["20 mètres", "10 mètres", "5 mètres", "30 mètres"],
    'explanation':
        "Vous devez vous arrêter à au moins 20 mètres d'un autobus scolaire lorsque ses lumières rouges supérieures clignotent.",
  },
  'sr_003': {
    'stem': "Que devez-vous faire en dépassant un cycliste?",
    'options': [
      "Laisser au moins 1 mètre d'espace et dépasser seulement quand c'est sécuritaire",
      "Klaxonner pour les avertir",
      "Passer aussi près que possible pour économiser l'espace de route",
      "Faire clignoter vos phares",
    ],
    'explanation':
        "La loi de l'Ontario exige que les conducteurs laissent un minimum de 1 mètre d'espace lors du dépassement des cyclistes. Dépassez seulement quand c'est sécuritaire.",
  },
  'sr_004': {
    'stem': "Qui a la priorité à un passage pour piétons?",
    'options': [
      "Les piétons ont toujours la priorité",
      "Les conducteurs ont toujours la priorité",
      "Le véhicule arrivé en premier",
      "Les véhicules tournant à droite",
    ],
    'explanation':
        "Les piétons ont toujours la priorité aux passages pour piétons. Les conducteurs doivent s'arrêter et céder la priorité aux piétons qui traversent.",
  },
  'sr_005': {
    'stem': "Qu'est-ce que l'angle mort d'un gros camion?",
    'options': [
      "Les zones directement en avant, derrière et des deux côtés que le conducteur ne peut pas voir",
      "Seulement la zone directement derrière le camion",
      "Seulement la zone à gauche du camion",
      "Les gros camions n'ont pas d'angles morts",
    ],
    'explanation':
        "Les gros camions ont d'importants angles morts (zones de danger) en avant, derrière et des deux côtés. Si vous ne pouvez pas voir le conducteur du camion dans ses rétroviseurs, il ne peut pas vous voir.",
  },
  'sr_006': {
    'stem': "Que devez-vous faire quand un véhicule d'urgence approche par derrière avec lumières et sirènes?",
    'options': [
      "Vous ranger sur le côté droit de la route et vous arrêter jusqu'à ce qu'il soit passé",
      "Accélérer et dégager le chemin",
      "Ralentir mais continuer à rouler",
      "Vous arrêter immédiatement dans votre voie",
    ],
    'explanation':
        "Quand un véhicule d'urgence approche avec lumières et/ou sirène activées, rangez-vous sur le côté droit de la route et arrêtez-vous complètement jusqu'à ce qu'il soit passé.",
  },
  'sr_007': {
    'stem': "En approchant d'un autobus scolaire arrêté sur une autoroute divisée, que devez-vous faire?",
    'options': [
      "Seul le trafic circulant dans la même direction que l'autobus doit s'arrêter",
      "Tout le trafic dans les deux sens doit s'arrêter",
      "Continuer à conduire normalement",
      "Ralentir à 20 km/h et avancer",
    ],
    'explanation':
        "Sur une autoroute divisée (avec terre-plein ou séparateur surélevé), seuls les véhicules circulant dans la même direction que l'autobus scolaire arrêté doivent s'arrêter.",
  },
  'sr_008': {
    'stem': "Dans quelle voie un cycliste doit-il rouler?",
    'options': [
      "Aussi près que possible du côté droit de la route, ou dans une piste cyclable désignée",
      "Au centre de la route",
      "Du côté gauche de la route",
      "Sur le trottoir",
    ],
    'explanation':
        "Les cyclistes devraient rouler aussi près que possible du côté droit de la route, ou dans une piste cyclable désignée là où elle est disponible.",
  },
  'sr_009': {
    'stem': "Que devez-vous faire en dépassant un véhicule d'urgence arrêté en bordure de route avec des lumières clignotantes en Ontario?",
    'options': [
      "Ralentir à 60 km/h (ou moins si la limite est inférieure) et changer de voie si possible",
      "S'arrêter complètement jusqu'à ce que le véhicule se déplace",
      "Maintenir votre vitesse et rester dans votre voie",
      "Klaxonner en passant",
    ],
    'explanation':
        "En vertu de la loi «Dégager la voie» de l'Ontario, en dépassant un véhicule d'urgence, un camion de remorquage ou un véhicule d'entretien routier arrêté avec des lumières clignotantes, vous devez ralentir à 60 km/h et changer de voie si c'est sécuritaire.",
  },
  'sr_010': {
    'stem': "Que devez-vous faire si un piéton traverse à un passage piéton contrôlé par des feux de signalisation?",
    'options': [
      "Céder la priorité au piéton même si vous avez un feu vert",
      "Avancer normalement — le feu vert vous donne la priorité",
      "Klaxonner pour avertir le piéton",
      "Faire clignoter vos phares au piéton",
    ],
    'explanation':
        "Même quand vous avez un feu vert, vous devez céder la priorité aux piétons qui se trouvent déjà dans le passage pour piétons. La sécurité des piétons a toujours priorité.",
  },

  // ── SPECIAL SITUATIONS ────────────────────────────────────────
  'ss_001': {
    'stem': "Quand devez-vous utiliser vos phares de route basse?",
    'options': [
      "De la demi-heure après le coucher du soleil jusqu'à la demi-heure avant le lever du soleil, et en cas de faible visibilité",
      "Seulement après minuit",
      "Seulement dans le brouillard",
      "Seulement sur les autoroutes",
    ],
    'explanation':
        "Vous devez utiliser vos phares de la demi-heure avant le coucher du soleil jusqu'à la demi-heure après le lever du soleil, et à tout autre moment où la visibilité est mauvaise.",
  },
  'ss_002': {
    'stem': "Quand devez-vous passer des phares de route haute aux phares de route basse?",
    'options': [
      "À moins de 150 mètres d'un véhicule venant en sens inverse, ou en suivant à moins de 60 mètres d'un autre véhicule",
      "Seulement en ville",
      "Seulement quand le conducteur adverse vous le demande",
      "À moins de 50 mètres de tout véhicule",
    ],
    'explanation':
        "Passez en phares de route basse lorsque vous êtes à moins de 150 mètres d'un véhicule venant en sens inverse, ou en suivant à moins de 60 mètres d'un autre véhicule.",
  },
  'ss_003': {
    'stem': "Que devez-vous faire lorsque vous conduisez sous une pluie abondante ou dans le brouillard?",
    'options': [
      "Allumer les phares de route basse et réduire la vitesse",
      "Utiliser les phares de route haute pour une meilleure visibilité",
      "Allumer les feux de détresse et conduire à vitesse normale",
      "S'arrêter sur le côté jusqu'à l'amélioration des conditions",
    ],
    'explanation':
        "Dans le brouillard ou sous une pluie abondante, utilisez les phares de route basse (les phares de route haute se réfléchissent sur le brouillard/la pluie et réduisent la visibilité), réduisez votre vitesse et augmentez votre distance de suivi.",
  },
  'ss_004': {
    'stem': "Que devez-vous faire si vos freins tombent en panne pendant la conduite?",
    'options': [
      "Pomper les freins, rétrograder, utiliser progressivement le frein d'urgence, et diriger vers la sécurité",
      "Couper le moteur immédiatement",
      "Se jeter contre le trottoir",
      "Faire clignoter vos phares et klaxonner répétitivement",
    ],
    'explanation':
        "Si vos freins tombent en panne, pompez-les plusieurs fois, rétrogradez à une vitesse inférieure, appliquez doucement le frein de stationnement, et dirigez-vous en toute sécurité hors de la route. Klaxonnez pour avertir les autres.",
  },
  'ss_005': {
    'stem': "Quelle est la bonne distance de suivi dans des conditions de glace ou de neige?",
    'options': [
      "Au moins 4 fois supérieure à la normale (8 à 10 secondes)",
      "La même que dans des conditions normales",
      "Le double de la distance normale",
      "Une seconde pour chaque 10 km/h de vitesse",
    ],
    'explanation':
        "Dans des conditions de neige ou de glace, votre distance d'arrêt peut être 4 fois supérieure à celle sur une route sèche. Augmentez votre distance de suivi à au moins 8 à 10 secondes.",
  },
  'ss_006': {
    'stem': "Que devez-vous faire si vous êtes impliqué dans une collision causant des blessures ou la mort?",
    'options': [
      "S'arrêter, appeler le 911, porter assistance, et signaler à la police",
      "Échanger les informations et partir",
      "Appeler d'abord votre assureur",
      "Déplacer immédiatement tous les véhicules hors de la route",
    ],
    'explanation':
        "Si une collision implique des blessures ou la mort, vous devez vous arrêter, appeler le 911 immédiatement, porter assistance si c'est sécuritaire, et rester sur les lieux jusqu'à l'arrivée de la police.",
  },
  'ss_007': {
    'stem': "Quand devez-vous signaler une collision à la police?",
    'options': [
      "Quand il y a des blessés, des morts ou des dommages supérieurs à 2 000 \$",
      "Seulement quand quelqu'un est blessé",
      "Seulement sur les autoroutes",
      "Toutes les collisions peu importe les dommages",
    ],
    'explanation':
        "En Ontario, vous devez signaler une collision à la police quand elle implique des blessures ou la mort, ou des dommages aux biens/véhicules supérieurs à 2 000 \$.",
  },
  'ss_008': {
    'stem': "En fusionnant sur une autoroute, qui a la priorité?",
    'options': [
      "Le trafic déjà sur l'autoroute — vous devez céder la priorité et trouver un espace",
      "Le véhicule qui fusionne — le trafic sur l'autoroute doit ralentir",
      "Celui qui roule le plus vite",
      "Le plus grand véhicule",
    ],
    'explanation':
        "En fusionnant sur une autoroute, vous devez céder la priorité au trafic déjà sur l'autoroute. Utilisez la voie d'accélération pour ajuster votre vitesse et trouver un espace sécuritaire pour fusionner.",
  },
  'ss_009': {
    'stem': "Quelle est la bonne façon de quitter une autoroute?",
    'options': [
      "Se déplacer dans la voie de droite à l'avance, signaler, et ralentir une fois dans la voie de sortie",
      "Ralentir d'abord sur l'autoroute, puis se déplacer dans la voie de sortie",
      "Signaler et se déplacer dans la voie de sortie au dernier moment",
      "Utiliser les feux de détresse en sortant",
    ],
    'explanation':
        "Pour quitter une autoroute, déplacez-vous dans la voie de droite bien avant votre sortie. Signalez votre intention et ne réduisez la vitesse qu'une fois complètement dans la voie de sortie/décélération.",
  },
  'ss_010': {
    'stem': "Que devez-vous faire si un pneu éclate pendant la conduite?",
    'options': [
      "Tenir fermement le volant, relâcher l'accélérateur, diriger droit et ralentir progressivement",
      "Freiner fortement immédiatement",
      "Virer rapidement sur le côté de la route",
      "Accélérer pour maintenir le contrôle",
    ],
    'explanation':
        "Si un pneu éclate, saisissez fermement le volant pour maintenir le contrôle, relâchez l'accélérateur, dirigez droit et ralentissez progressivement avant de vous ranger en toute sécurité.",
  },
  'ss_011': {
    'stem': "Qu'est-ce que l'aquaplanage?",
    'options': [
      "Vos pneus perdent contact avec la route en raison d'une couche d'eau, causant une perte de direction",
      "Votre véhicule glisse sur la glace",
      "Vos freins surchauffent",
      "De l'eau pénètre dans votre moteur",
    ],
    'explanation':
        "L'aquaplanage se produit quand une couche d'eau s'accumule entre vos pneus et la route, vous faisant perdre la traction et le contrôle de la direction.",
  },
  'ss_012': {
    'stem': "Quand est-il sécuritaire d'utiliser vos feux de détresse pendant la conduite?",
    'options': [
      "Quand votre véhicule représente un danger pour les autres (p. ex., déplacement lent, rangé sur le côté)",
      "Chaque fois qu'il pleut",
      "Comme substitut aux clignotants",
      "En tout temps dans les zones de construction",
    ],
    'explanation':
        "Les feux de détresse doivent être utilisés quand votre véhicule est arrêté ou se déplace lentement et pourrait représenter un danger pour les autres conducteurs. Ne les utilisez pas comme substitut aux clignotants.",
  },
};
