![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Conpot


**Goal:** Conpot (an ICS/SCADA honeypot), interact with it, collect evidence, and learn analysis/detection techniques

## Let's start

- Open a **terminal** unless you are connected with **SSH**

- Go to **compot's** directory

```bash
cd ~/Desktop/conpot
```

- Start it up
```bash
sudo docker compose up -d
```

- Check container logs
```bash
sudo docker logs -f conpot
```

<img width="1820" height="903" alt="image" src="https://github.com/user-attachments/assets/f6faab44-7cf4-41ff-8df1-91d596953c3a" />


If you want to run multiple templates later, we'll cover adding config files into `./conpot-data`.

---

## 3) Lab network topology (simple & safe)
- Single Linux host with Docker (honeypot) and attacker machine (could be same host using `localhost`, or separate VM).
- Recommended: two VMs on the same host network (Host-only or NAT with port forwarding disabled) so honeypot traffic doesn’t leak to the wider internet.

Topology:
```
[Attacker VM] ---- [Lab network switch/virtual network] ---- [Conpot VM]
```

IP examples:
- Conpot VM: `192.168.56.101`
- Attacker VM: `192.168.56.102`

Ensure firewall rules on your host do not accidentally expose the honeypot to the public internet.

---

## 4) Conpot configuration — idiot‑proof `conpot.cfg`

By default Conpot uses built-in templates. We'll create a small `conpot.cfg` and template directory in `~/conpot-lab/conpot-data`. This lets you control services and logging.

Create `~/conpot-lab/conpot-data/conpot.cfg`:
```ini
[conpot]
logfile = /data/conpot.log
pidfile = /data/conpot.pid
interface = 0.0.0.0
autostart = true

[server]
http_port = 80
modbus_port = 502
bacnet_port = 47808

[logging]
level = INFO
```

Create `~/conpot-lab/conpot-data/templates/default.cfg` with minimal identity:
```ini
[conpot]
name = "Conpot-Lab-Simple"
description = "Lab template for hands-on exercises"
vendor = "LabInc"
model = "Simulated PLC v1"
```

If using Docker with the `docker-compose.yml` above, the `/data` folder maps to `./conpot-data` so Conpot will read these files automatically.

---

## 5) Start the honeypot and verify

### Docker
```bash
cd ~/conpot-lab
docker compose up -d
docker ps --filter "name=conpot"
docker logs -f conpot
```

### Verify services are listening (on Conpot host)
```bash
# on conpot host
ss -tunlp | egrep ':(80|502|47808)'
```

### From attacker VM
Replace `TARGET` with the Conpot IP (e.g. 192.168.56.101)

Basic reachability:
```bash
ping -c 2 TARGET
```

Port scan with nmap:
```bash
nmap -sS -sV -p 1-2000 TARGET -oN conpot-nmap.txt
# Expected: port 80 open (HTTP), 502 open (Modbus)
```

HTTP check:
```bash
curl -i http://TARGET/
```

Modbus probe (read one register) — using `pymodbus` client (example later) or `modpoll` if available.

---

## 6) Interaction exercises (step-by-step)

### 6.1 Exercise 1 — Fingerprinting with nmap
Goal: identify services and versions.
```bash
nmap -sS -sV -p80,502 TARGET -oN task1-nmap.txt
```
Expected findings:
- HTTP service with a basic web page (Conpot sim)
- Modbus TCP port 502 open

Discuss: How accurate is the fingerprint? Conpot typically advertises fake banners. Record results.

### 6.2 Exercise 2 — HTTP exploration
```bash
curl -I http://TARGET/
curl http://TARGET/ | head -n 40
```
Open in browser and look for any ICS-specific pages or default images.

### 6.3 Exercise 3 — Modbus basic read (safe, read-only)
Install `pymodbus` on attacker VM:
```bash
python3 -m pip install pymodbus
```

Create `modbus_read.py`:
```python
from pymodbus.client.sync import ModbusTcpClient as ModbusClient
c = ModbusClient("TARGET", port=502, timeout=3)
if c.connect():
    rr = c.read_holding_registers(0, 6, unit=1)
    print(rr)
    c.close()
else:
    print("Connection failed")
```
Run:
```bash
python3 modbus_read.py
```
Expected: register values (fake/simulated). This is safe — read-only.

### 6.4 Exercise 4 — Simulate attacker scanning heavily
Run aggressive nmap scan and observe logs.
```bash
nmap -A -p- TARGET -oN task4-aggressive-nmap.txt
```
Observe Conpot logs (docker logs) and note any IDS triggers if present.

---

## 7) Logging and evidence collection

### Where Conpot logs
If using our `conpot.cfg`, logs are at `~/conpot-lab/conpot-data/conpot.log`. Docker mapping ensures they persist.

Tail logs:
```bash
tail -F ~/conpot-lab/conpot-data/conpot.log
# or via docker logs: docker logs -f conpot
```

### Capture network traffic (pcap)
On Conpot host:
```bash
sudo tcpdump -i any host TARGET -w ~/conpot-lab/conpot_capture.pcap
# or on attacker side capture from attacker
sudo tcpdump -i any port 502 or port 80 -w ~/conpot-lab/attacker_capture.pcap
```
Open captures in Wireshark for deeper analysis (look for Modbus function codes, suspicious payloads).

### Structured logs (JSON) — optional advanced
Conpot can be integrated with ELK; for this lab we'll keep file logs. If you want, redirect logs into a simple `filebeat` later.

---

## 8) Detection & analysis exercises (learning outcomes)

### 8.1 Correlate nmap scan to conpot logs
- While running `nmap -A`, watch `conpot.log`. Note the timestamps and commands logged.
- Task: find the nmap fingerprint in the log and quote the lines.

### 8.2 Analyze Modbus traffic in Wireshark
- Filter: `tcp.port==502` or `modbus`
- Identify function codes: `Read Holding Registers` (function 03), `Read Coils` (01).
- Task: Capture a read from `modbus_read.py` and identify the request/response pairs by transaction id.

### 8.3 Create a simple signature: detect repeated failed writes
- Use `grep` to find repeated write attempts in `conpot.log`:
```bash
grep -i "write" ~/conpot-lab/conpot-data/conpot.log | wc -l
```
- Task: write a one-liner that alerts when writes exceed N within M seconds (example using `watch`+`wc` or a small Python script). (Instructor can demo.)

### 8.4 Forensics: timeline
- Build a timeline from PCAP and logs:
  - Extract Modbus transactions with tshark:
```bash
tshark -r conpot_capture.pcap -Y modbus -Tfields -e frame.time -e ip.src -e ip.dst -e modbus.func_code -e modbus.reference_num -e modbus.value
```
- Import into a spreadsheet and sort by time.

---

## 9) Cleanup
Stop and remove container & data (Docker):
```bash
cd ~/conpot-lab
docker compose down
# if you want to remove data:
rm -rf ~/conpot-lab
```

If installed with pip and venv:
```bash
# in conpot repo
deactivate
rm -rf ~/conpot
```

---

## 10) Troubleshooting & FAQ

- **Ports not visible on attacker:** Check network mode and firewall. Ensure both VMs are on same virtual network. Use `ss -tunlp` on conpot host to confirm listening.
- **Docker image pull fails:** Check network, try `docker pull conpot/conpot:latest` manually.
- **Conpot not starting (python):** Activate venv, check `pip install -r requirements.txt`, run `conpot -f` to see verbose errors.
- **Modbus reads empty/no response:** Conpot unit id may differ. Try `unit=1` and different register offsets. Conpot simulates values but may not implement all registers.

---

## 11) Appendix — Useful one‑liners & scripts

### Quick log watch
```bash
# follow logs and show only modbus/read messages
tail -F ~/conpot-lab/conpot-data/conpot.log | grep --line-buffered -i modbus
```

### Quick modbus read script (replace TARGET)
```bash
cat > modbus_read.py <<'PY'
from pymodbus.client.sync import ModbusTcpClient as ModbusClient
import sys
host = sys.argv[1]
c = ModbusClient(host, port=502, timeout=3)
if c.connect():
    print("Connected to", host)
    rr = c.read_holding_registers(0, 10, unit=1)
    print(rr.registers if hasattr(rr, 'registers') else rr)
    c.close()
else:
    print("Connection failed")
PY
```
Run:
```bash
python3 modbus_read.py TARGET
```

### Simple write-detection alert (bash)
```bash
# prints whenever write attempts appear in log
sudo apt install -y inotify-tools
inotifywait -m ~/conpot-lab/conpot-data/conpot.log -e modify |
while read path _ file; do
  tail -n 20 "$path$file" | grep -i write && echo "Possible write attempt detected at $(date)"
done
```

---

## Suggested Lab Tasks (grading rubric suggestions)
1. Successfully install and run Conpot (Docker) — 20pt  
2. Identify open ports and services via nmap — 15pt  
3. Execute safe Modbus read and capture traffic — 20pt  
4. Correlate a scan to Conpot logs and produce timeline — 25pt  
5. Propose one detection rule based on observed logs/pcap — 20pt

---

## Final notes / Safety
- Do **not** expose this lab to the public Internet. Keep it isolated.
- Keep interactions read-only whenever possible. If you demonstrate writes, label them and run in a controlled environment.
- This lab focuses on learning detection, not exploitation.




***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/IoTPOT.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/openCanary.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---


