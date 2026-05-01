import re

file_path = "lib/data/question_data_manager.dart"
with open(file_path, "r") as f:
    text = f.read()

# 1. Imports
if "question_bank_extra2.dart" not in text:
    text = text.replace("import 'question_bank_extra.dart';", 
                        "import 'question_bank_extra.dart';\nimport 'question_bank_extra2.dart';\nimport 'french_translations_extra2.dart';")

# 2. Add extra2 questions to categories
to_replace = {
    "_graduatedLicensing.addAll(QuestionBankExtra.graduatedLicensing());":
    "_graduatedLicensing.addAll(QuestionBankExtra.graduatedLicensing());\n    _graduatedLicensing.addAll(QuestionBankExtra2.graduatedLicensing());",

    "_trafficSigns.addAll(QuestionBankExtra.trafficSigns());":
    "_trafficSigns.addAll(QuestionBankExtra.trafficSigns());\n    _trafficSigns.addAll(QuestionBankExtra2.trafficSigns());",

    "_rulesOfRoad.addAll(QuestionBankExtra.rulesOfRoad());":
    "_rulesOfRoad.addAll(QuestionBankExtra.rulesOfRoad());\n    _rulesOfRoad.addAll(QuestionBankExtra2.rulesOfRoad());",

    "_safeDriving.addAll(QuestionBankExtra.safeDriving());":
    "_safeDriving.addAll(QuestionBankExtra.safeDriving());\n    _safeDriving.addAll(QuestionBankExtra2.safeDriving());",

    "_sharingRoad.addAll(QuestionBankExtra.sharingRoad());":
    "_sharingRoad.addAll(QuestionBankExtra.sharingRoad());\n    _sharingRoad.addAll(QuestionBankExtra2.sharingRoad());",

    "_signsAndSituations.addAll(QuestionBankExtra.signsAndSituations());":
    "_signsAndSituations.addAll(QuestionBankExtra.signsAndSituations());\n    _signsAndSituations.addAll(QuestionBankExtra2.signsAndSituations());",
}

for k, v in to_replace.items():
    text = text.replace(k, v)

# 3._localizeQuestion fallback
if "kFrenchTranslationsExtra2[q.id];" not in text:
    text = text.replace("kFrenchTranslationsExtra[q.id];",
                        "kFrenchTranslationsExtra[q.id] ??\n            kFrenchTranslationsExtra2[q.id];")

with open(file_path, "w") as f:
    f.write(text)

