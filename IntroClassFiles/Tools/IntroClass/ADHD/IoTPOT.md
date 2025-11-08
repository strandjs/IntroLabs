![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# For the Ubuntu VM

# IoTPOT

**Goal:** build a tiny, completely hands-on "IoTPOT" that emulates common IoT services (Telnet, HTTP, MQTT), logs attacker activity, and lets students play attacker and analyst roles. No complicated dependencies or external honeypot projects required — everything runs with Python, Docker (optional), and common tools.

---
## Overview
- Run a simple IoT honeypot and view live logs.
- Simulate attacks: telnet brute-force, HTTP command injection, MQTT publish abuse, simple port scans.
- Capture and inspect artifacts (commands, credentials, payloads).

---
## Quick summary of what we'll build
1. A small folder `iotpot/` with three tiny services:
   - `telnet-honeypot.py` — a fake Telnet server that collects username/password attempts and mimics responses.
   - `http-honeypot.py` — a tiny HTTP server that logs GET/POST and shows a fake admin page vulnerable to simple command injection (for demonstration only).
   - `mqtt-honeypot.py` — a very small MQTT broker emulator that accepts publishes and logs messages.
2. A `binaries/` and `logs/` folder where captured artifacts and logs are saved.
3. Step-by-step attacker simulations using `hydra`, `curl`, `mosquitto_pub`, and `nmap`.
4. Investigator steps: `tail -f` logs, inspect saved payloads, and discuss improvements.

---
## Setup — one terminal at a time (follow commands exactly)

### 1) Prepare system (run once)
Open a terminal and run:
```bash
# update packages
sudo apt update && sudo apt upgrade -y

# install required tools
sudo apt install -y python3 python3-venv python3-pip git netcat-openbsd curl nmap

# optional but useful tools for attacks
sudo apt install -y hydra mosquitto-clients
```

If `hydra` is not available in your distro, you can skip that step and use `netcat` or `expect` scripts to simulate password attempts.

### 2) Create project directory and virtualenv
```bash
mkdir -p ~/iotpot && cd ~/iotpot
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install paho-mqtt
mkdir logs binaries
```
`paho-mqtt` is used by the MQTT emulator client/server logic.

### 3) Create the honeypot server scripts
Create `telnet-honeypot.py` with the following content (use `nano`, `vim` or your editor):
```python
#!/usr/bin/env python3
# telnet-honeypot.py — Minimal Telnet-like honeypot that logs credentials

import socket, threading, datetime, os

HOST = "0.0.0.0"
PORT = 2323  # non-privileged telnet port
LOGDIR = "logs"
os.makedirs(LOGDIR, exist_ok=True)

def log(msg):
    ts = datetime.datetime.utcnow().isoformat() + "Z"
    with open(f"{LOGDIR}/telnet.log", "a") as f:
        f.write(f"[{ts}] {msg}\\n")
    print(msg)

def handle_client(conn, addr):
    try:
        conn.sendall(b"Welcome to TinyTelnet\\r\\nlogin: ")
        data = conn.recv(1024).decode(errors="ignore").strip()
        username = data or "<empty>"
        conn.sendall(b"password: ")
        pwd = conn.recv(1024).decode(errors="ignore").strip()
        password = pwd or "<empty>"
        log(f"CONN {addr[0]}:{addr[1]} USER='{username}' PASS='{password}'")
        # emulate a fake shell prompt then close
        conn.sendall(b"Login incorrect\\r\\nBye\\r\\n")
    except Exception as e:
        log(f"ERROR handle_client {addr} {e}")
    finally:
        conn.close()

def main():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind((HOST, PORT))
    s.listen(5)
    print(f"Telnet honeypot listening on {HOST}:{PORT}")
    while True:
        conn, addr = s.accept()
        thr = threading.Thread(target=handle_client, args=(conn, addr), daemon=True)
        thr.start()

if __name__ == '__main__':
    main()
```
Make it executable:
```bash
chmod +x telnet-honeypot.py
```

Create `http-honeypot.py`:
```python
#!/usr/bin/env python3
# http-honeypot.py — Tiny HTTP honeypot that logs requests and demonstrates "cmd" injection

from http.server import BaseHTTPRequestHandler, HTTPServer
import urllib.parse as up
import datetime, os

LOGDIR = "logs"
os.makedirs(LOGDIR, exist_ok=True)

def log(msg):
    ts = datetime.datetime.utcnow().isoformat() + "Z"
    with open(f"{LOGDIR}/http.log", "a") as f:
        f.write(f"[{ts}] {msg}\\n")
    print(msg)

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        qs = up.urlparse(self.path).query
        params = up.parse_qs(qs)
        log(f"GET {self.path} FROM {self.client_address[0]}")
        # show a simple page with a "cmd" parameter (for demo only)
        page = f\"\"\"<html><body>
<h2>Device Admin Page (Demo)</h2>
<form method='GET'>
CMD: <input name='cmd' /> <input type='submit' value='Send' />
</form>
<pre>Last: {qs}</pre>
</body></html>\"\"\"
        self.send_response(200)
        self.send_header('Content-Type','text/html')
        self.end_headers()
        self.wfile.write(page.encode())

    def do_POST(self):
        cl = int(self.headers.get('Content-Length', 0))
        body = self.rfile.read(cl).decode(errors='ignore')
        log(f"POST {self.path} FROM {self.client_address[0]} BODY={body}")
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"OK")
        
def run(server_class=HTTPServer, handler=Handler):
    server_address = ('', 8080)
    httpd = server_class(server_address, handler)
    print("HTTP honeypot listening on 0.0.0.0:8080")
    httpd.serve_forever()

if __name__ == '__main__':
    run()
```
Make it executable:
```bash
chmod +x http-honeypot.py
```

Create `mqtt-honeypot.py`:
```python
#!/usr/bin/env python3
# mqtt-honeypot.py — Minimal MQTT acceptor (NOT a full broker). Logs connect/publish messages.
import socket, threading, datetime, os

HOST = "0.0.0.0"
PORT = 1883  # MQTT default port (non-root may need port range / use firewall nat)
LOGDIR = "logs"
os.makedirs(LOGDIR, exist_ok=True)

def log(msg):
    ts = datetime.datetime.utcnow().isoformat() + "Z"
    with open(f"{LOGDIR}/mqtt.log", "a") as f:
        f.write(f"[{ts}] {msg}\\n")
    print(msg)

def handle(conn, addr):
    log(f"MQTT-CONN {addr[0]}:{addr[1]}")
    try:
        # This is a very naive listener: it reads bytes and logs them.
        data = conn.recv(4096)
        if data:
            log(f"MQTT-BYTES {addr[0]}:{addr[1]} LEN={len(data)} DATA={data[:200]!r}")
            # dump full capture for analyst
            with open(f"binaries/mqtt-{addr[0]}-{addr[1]}-{int(datetime.datetime.utcnow().timestamp())}.bin","wb") as f:
                f.write(data)
        conn.close()
    except Exception as e:
        log(f"ERROR MQTT {e}")

def main():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind((HOST, PORT))
    s.listen(5)
    print("MQTT honeypot listening on 0.0.0.0:1883")
    while True:
        conn, addr = s.accept()
        threading.Thread(target=handle, args=(conn, addr), daemon=True).start()

if __name__ == '__main__':
    main()
```
Make executable:
```bash
chmod +x mqtt-honeypot.py
```

### 4) Start the honeypot services (open three terminals or use tmux/screen)
Terminal A — Telnet honeypot:
```bash
cd ~/iotpot
source .venv/bin/activate
./telnet-honeypot.py
```
Terminal B — HTTP honeypot:
```bash
cd ~/iotpot
source .venv/bin/activate
./http-honeypot.py
```
Terminal C — MQTT honeypot:
```bash
cd ~/iotpot
source .venv/bin/activate
./mqtt-honeypot.py
```

You should see printed messages when connections arrive. If any port fails due to permission, choose alternative high ports (e.g., 2223 for Telnet, 18883 for MQTT).

---
## Attacker simulation — run these from another terminal (attacker role) on the same machine or different machine pointed at lab host

> Replace `TARGET` with `localhost` if testing locally, or the lab VM IP (e.g., `192.168.56.101`).

### 1) Telnet brute force (Hydra) — attacker
Download a small password list (or use a short custom list):
```bash
# small sample wordlist
printf "admin\nroot\n1234\npassword\n" > cheap-words.txt

# run hydra against telnet-like service on port 2323
hydra -L <(printf "root\nadmin\nuser\n") -P cheap-words.txt -s 2323 TARGET telnet -V
```
If `hydra` isn't available, simulate attempts with `nc`:
```bash
# attempt a login sequence with netcat
printf "admin\r\n12345\r\n" | nc TARGET 2323
```

Watch the honeypot telnet log (analyst view):
```bash
tail -f ~/iotpot/logs/telnet.log
```

You should see entries like `CONN 127.0.0.1:XXXXX USER='admin' PASS='12345'`

### 2) HTTP command injection demo — attacker
Open in browser or use curl to send a `cmd` parameter:
```bash
# from attacker machine (replace TARGET)
curl "http://TARGET:8080/?cmd=ls%20-la%20/"
```
Observe HTTP honeypot log:
```bash
tail -f ~/iotpot/logs/http.log
```
The honeypot will log the request and query string. Discuss why real devices exposing `cmd` style parameters are dangerous.

### 3) MQTT message publish — attacker
Publish a message to the fake MQTT server:
```bash
mosquitto_pub -h TARGET -p 1883 -t "device/alert" -m "reboot now"
```
Analyst view (tail log):
```bash
tail -f ~/iotpot/logs/mqtt.log
ls -l binaries/ | tail -n 10
```
You should see captured bytes and a small binary file with raw MQTT bytes saved in `binaries/`.

### 4) Port scan — attacker
From attacker machine:
```bash
nmap -sS -p 2000-9000 -A TARGET
```
Analyst view: observe logs and new connection prints in the three honeypot terminals.

---
## Investigator tasks (what your students should do)
1. Use `tail -f logs/*.log` to watch activity in real time while attacks run.
2. Search logs for interesting patterns (e.g., repeated username/password combos).
3. Inspect raw MQTT capture files in `binaries/` — they contain the raw bytes attackers sent.
4. Try uploading a tiny binary (simulate malware) to the HTTP honeypot:
```bash
curl -X POST -d "dropper=evil" http://TARGET:8080/upload
# our small honeypot doesn't implement /upload but logs POST bodies — check http.log
```
5. Change the telnet honeypot to accept any username but record commands: modify `telnet-honeypot.py` to sleep after login and echo received lines into a per-connection `.session` file in `binaries/`.





***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/webhoneypot/webhoneypot.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/openCanary.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
