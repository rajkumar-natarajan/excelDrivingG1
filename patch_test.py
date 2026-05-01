import re

file_path = "test/question_data_manager_test.dart"
with open(file_path, "r") as f:
    text = f.read()

# total is 352. So expecting 350
text = re.sub(r"expect\(allQuestions\.length, greaterThanOrEqualTo\(\d+\)\);", 
              "expect(allQuestions.length, greaterThanOrEqualTo(350));", text)

# update categories
text = re.sub(r"expect\(manager\.getQuestionsByCategory\(QuestionType\.graduatedLicensing\)\.length,\s*greaterThanOrEqualTo\(\d+\)\);",
              "expect(manager.getQuestionsByCategory(QuestionType.graduatedLicensing).length, greaterThanOrEqualTo(40));", text)

text = re.sub(r"expect\(manager\.getQuestionsByCategory\(QuestionType\.trafficSigns\)\.length,\s*greaterThanOrEqualTo\(\d+\)\);",
              "expect(manager.getQuestionsByCategory(QuestionType.trafficSigns).length, greaterThanOrEqualTo(70));", text)

text = re.sub(r"expect\(manager\.getQuestionsByCategory\(QuestionType\.rulesOfRoad\)\.length,\s*greaterThanOrEqualTo\(\d+\)\);",
              "expect(manager.getQuestionsByCategory(QuestionType.rulesOfRoad).length, greaterThanOrEqualTo(75));", text)

text = re.sub(r"expect\(manager\.getQuestionsByCategory\(QuestionType\.safeDriving\)\.length,\s*greaterThanOrEqualTo\(\d+\)\);",
              "expect(manager.getQuestionsByCategory(QuestionType.safeDriving).length, greaterThanOrEqualTo(60));", text)

text = re.sub(r"expect\(manager\.getQuestionsByCategory\(QuestionType\.sharingRoad\)\.length,\s*greaterThanOrEqualTo\(\d+\)\);",
              "expect(manager.getQuestionsByCategory(QuestionType.sharingRoad).length, greaterThanOrEqualTo(45));", text)

text = re.sub(r"expect\(manager\.getQuestionsByCategory\(QuestionType\.signsAndSituations\)\.length,\s*greaterThanOrEqualTo\(\d+\)\);",
              "expect(manager.getQuestionsByCategory(QuestionType.signsAndSituations).length, greaterThanOrEqualTo(62));", text)

with open(file_path, "w") as f:
    f.write(text)

