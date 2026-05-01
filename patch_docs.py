import os
import glob

# Replace "192" with "352" in docs
for filepath in glob.glob("**/*.md", recursive=True):
    with open(filepath, "r") as f:
        text = f.read()
    
    if "192" in text:
        text = text.replace("192", "352")
        with open(filepath, "w") as f:
            f.write(text)

