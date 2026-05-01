with open("lib/data/french_translations_extra2.dart", "r") as f:
    content = f.read()

# Re-escape the $ character inside Dart strings
content = content.replace("$", "\\$")

with open("lib/data/french_translations_extra2.dart", "w") as f:
    f.write(content)

