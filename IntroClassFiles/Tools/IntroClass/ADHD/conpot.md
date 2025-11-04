![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)


# For the Ubuntu VM

# Conpot

This lab deploys **Conpot** (an industrial control system honeypot) as a deception environment and demonstrates how attackers interact with ICS protocols, how to capture telemetry, and how defenders analyze activity

---

## Quick decisions (pick one deployment method)
1. **Docker + docker-compose** — easiest to manage and isolate.  
2. **Python virtualenv (recommended for learning internals)** — shows how Conpot runs and where logs/configs are.

This guide includes both. Complete both if you want deeper understanding.

---

# Part A — Preparation (common)
Open a terminal and run:

```bash
# update and install base tools
sudo apt update && sudo apt upgrade -y

# essential packages
sudo apt install -y git curl wget vim build-essential python3 python3-venv python3-pip \
    net-tools tcpdump jq unzip

# install nmap and socat for attacker simulation
sudo apt install -y nmap socat

# create an unprivileged conpot user (optional but recommended)
sudo useradd -m -s /bin/bash conpot || true
sudo passwd -l conpot
```

> Note: Some commands require `sudo`. If you prefer not to create a dedicated user, run as your sudo-enabled account.

---

# Part B — Method 1: Docker & docker‑compose (fast, isolated)

### 1) Install Docker & Docker Compose
```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm get-docker.sh

# Add your user to docker group (log out/in or new shell required)
sudo usermod -aG docker $USER

# Install docker-compose plugin (if not present)
sudo apt install -y docker-compose-plugin
```

Open a new shell or log out/log in to apply group membership.

### 2) Prepare docker-compose file
Create a directory and `docker-compose.yml`:

```bash
mkdir -p ~/conpot-lab-docker
cd ~/conpot-lab-docker
cat > docker-compose.yml <<'EOF'
version: "3.8"
services:
  conpot:
    image: conpot/conpot:latest
    container_name: conpot
    restart: unless-stopped
    network_mode: "bridge"
    ports:
      - "80:80"       # HTTP
      - "502:502"     # Modbus (TCP)
      - "161:161/udp" # SNMP (UDP)
      - "47808:47808" # BACnet (UDP)
    volumes:
      - ./conpot-data:/data
      - ./conpot-templates:/conpot/templates
    cap_add:
      - NET_ADMIN
EOF
```

> The `conpot/conpot:latest` image is used as a common public image name. If unavailable, you can replace with `mushorg/conpot` or build from source (see Method 2).

### 3) Start Conpot
```bash
docker compose up -d
docker ps --filter "name=conpot"
```

Check logs:
```bash
docker logs -f conpot
```

Conpot should be listening on local ports mapped above (80, 502, 161 etc).

---

# Part C — Method 2: Python virtualenv (learning + debug)

### 1) Clone Conpot and create virtualenv
```bash
cd ~
git clone https://github.com/mushorg/conpot.git || git clone https://github.com/conpot/conpot.git conpot || true
cd conpot
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip setuptools wheel
pip install -r requirements.txt
pip install .
```

> If `requirements.txt` is missing in your clone, install `pip install conpot` instead or check the repo layout. The `pip install .` registers the package.

### 2) Run Conpot with default template
```bash
# run as your current user inside venv
conpot -f /etc/conpot/conpot.cfg || conpot -f ./conpot.cfg || conpot
```

If Conpot starts successfully, you'll see it binding to ports (80, 502, 161 etc). If you need root privileges to bind to low ports, run with sudo or use higher port mapping (see below).

### 3) Run Conpot on high ports (no sudo)
Edit `conpot.cfg` (or use CLI flags) to change service ports to higher numbers (e.g., 8080, 1502) if you prefer not to run as root. Example:
```ini
# example in conpot.cfg - modify service ports section
[server]
web_port = 8080
modbus_port = 1502
snmp_port = 1161
```
Then run:
```bash
conpot -f ./conpot.cfg
```

---

# Part D — Configure templates & deception profile
Conpot uses templates that define how the emulated device behaves.

1. Locate templates in Docker volume or cloned repo:

- Docker: `~/conpot-lab-docker/conpot-templates` (or inside container `/conpot/templates`)
- Repo: `./conpot/templates`

2. Inspect `default` and `ics/` templates. To create a custom template, copy and edit YAML files. Example create `myplant` template:

```bash
mkdir -p ~/conpot-lab-docker/conpot-templates/myplant
cat > ~/conpot-lab-docker/conpot-templates/myplant/template.cfg <<'EOF'
name: MyPlant
description: Example plant with Modbus and HTTP
services:
  http:
    enabled: True
    port: 80
  modbus:
    enabled: True
    port: 502
  snmp:
    enabled: True
    port: 161
EOF
```

Reload container or restart conpot for templates to take effect.

---

# Part E — Attack simulation (hands‑on)

Open another terminal (attacker machine or same host).

### 1) Discovery with nmap
```bash
# scan common ICS ports
nmap -sS -p 80,502,161,47808 -sV -Pn <CONPOT_IP>
# or full quick scan
nmap -A -T4 <CONPOT_IP>
```

Expected: Conpot will respond as devices and show banners.

### 2) Modbus interaction (use modpoll)
Install modpoll (if available) or use `socat` to open TCP connection and examine. Example with socat:

```bash
# simple telnet-like connection to Modbus
nc <CONPOT_IP> 502
# Or using modpoll (preferred for real Modbus)
# download modpoll binary or use package manager if available
modpoll -m tcp -t 4 -r 0 -c 10 <CONPOT_IP>
```

### 3) SNMP query
```bash
snmpwalk -v1 -c public <CONPOT_IP>
snmpget -v1 -c public <CONPOT_IP> 1.3.6.1.2.1.1.1.0
```

### 4) HTTP probing & exploitation attempts
```bash
curl -v http://<CONPOT_IP>/
curl -X POST http://<CONPOT_IP>/login -d 'username=admin&password=admin'
# try simple fuzzing using wfuzz or gobuster (install separately)
```

### 5) Simulate more aggressive attacker behavior (port scanning, simple payloads)
```bash
# aggressive scan
nmap -sV -O --script vuln <CONPOT_IP>
# run hydra or medusa for brute force on HTTP basic if present (use responsibly)
```

**Important:** Run aggressions only in your lab.

---

# Part F — Logging, monitoring & analysis

### 1) Conpot logs
- Docker: `docker logs -f conpot`
- Virtualenv: console output or check `~/.conpot` or `./var/log` depending on config.

Look for connections, commands executed, and specific protocol interactions.

### 2) Packet capture
Run tcpdump on the lab host to capture attacker traffic:

```bash
sudo tcpdump -i any host <CONPOT_IP> -w conpot_capture.pcap
# stop with Ctrl-C after reproducing activity
```

Open `conpot_capture.pcap` in Wireshark for protocol analysis.

### 3) Centralize logs (optional)
For richer hands-on, forward logs to an ELK/OPENSEARCH or Splunk instance. Minimal example (send to local syslog):

- Add or configure `logging.handlers.SysLogHandler` in conpot logging config to send events to local syslog.
- Use `rsyslog` to write to file `/var/log/conpot.log`.

(Implementation of ELK is out of scope for this single-file lab but exercise instructions are listed in **Extensions**.)

---

# Part G — Defensive exercises (what the defender should do)

1. **Create detection rules:**  
   - Watch for unexpected Modbus traffic from untrusted networks.  
   - Alert on HTTP requests with suspicious URIs or brute force attempts.  
   - Monitor high-rate TCP connect attempts from single hosts.

2. **Example simple detection using tshark + grep** (demo):
```bash
# detect many connections to modbus port
sudo tshark -i any -Y "tcp.dstport == 502 or tcp.srcport == 502" -T fields -e ip.src | \
  sort | uniq -c | sort -nr | head
```

3. **Block & isolate:** Use `ufw`/`iptables` to block attacker IPs once malicious behavior is confirmed.

4. **Investigate logs:** correlate `docker logs`, pcap and system logs to build an incident timeline.

---

# Part H — Lab tasks & challenges (for students)

1. **Recon task:** run nmap and enumerate services + versions; report findings.
2. **Interact task:** read 5 Modbus registers and fetch SNMP sysDescr; save output.
3. **Attack detection task:** from defender side, create a script that detects and alerts when there are more than 10 new Modbus connections in 60 seconds.
4. **Deception evaluation:** modify the template to add fake "control points" and observe if attackers try to write values — capture and analyze the writes.
5. **Hardening task:** run Conpot with minimal exposure (only internal lab network) and write a short checklist of 5 hardening steps.

---

# Part I — Example helper scripts

**1) Simple Modbus connection counter (bash)**
```bash
#!/bin/bash
# Save as detect_modbus_spike.sh, run as root
IF=any
THRESHOLD=10
INTERVAL=60

count=$(sudo tshark -i $IF -Y "tcp.dstport == 502 || tcp.srcport == 502" -a duration:$INTERVAL -T fields -e ip.src | wc -l)
if [ "$count" -gt "$THRESHOLD" ]; then
  echo "$(date) ALERT: $count Modbus frames detected in last $INTERVAL seconds" >> /var/log/conpot_alerts.log
fi
```

**2) Simple curl-based scanner (attacker simulation)**
```bash
#!/bin/bash
target=$1
for p in 80 443 502 161 47808; do
  echo "Probing port $p"
  timeout 3 bash -c "echo > /dev/tcp/$target/$p" && echo "open" || echo "closed"
done
```

---

# Part J — Cleanup
To stop and remove the Docker deployment:
```bash
cd ~/conpot-lab-docker
docker compose down
docker rm -f conpot || true
docker volume prune -f
```

To stop a virtualenv run:
- If running in foreground, hit Ctrl‑C.
- Remove the cloned repo:
```bash
rm -rf ~/conpot
```

---

# Safety & legal notes
- Only run this lab in an isolated environment or on networks you own/are authorized to use.  
- Do **not** expose honeypots to the public Internet without careful planning — they attract malicious actors and could be abused to launch attacks on third parties.  
- Capture and analyze only your own lab traffic.

---

# Extensions (optional advanced labs)
- Forward Conpot logs to Elasticsearch and build dashboards.  
- Build Suricata/Zeek signatures for ICS protocols and evaluate detection rates.  
- Integrate with MISP to store IOC events.  
- Use multiple Conpot instances (different templates) and run a C2 style simulation.

---

## Appendix: Quick command summary
- Start Docker Conpot: `docker compose up -d`
- Check Conpot logs: `docker logs -f conpot`
- Capture traffic: `sudo tcpdump -i any host <CONPOT_IP> -w conpot_capture.pcap`
- Scan: `nmap -A <CONPOT_IP>`
- SNMP: `snmpwalk -v1 -c public <CONPOT_IP>`

---

## End of lab
Good luck and have fun—capture interesting traffic and learn from it. If you want, I can also:
- Provide a pre-built `docker-compose.yml` with ELK integration,
- Create Suricata rules tuned for Modbus/ICS,
- Or convert this lab into an interactive step-by-step web page.



***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/IoTPOT.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/openCanary.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---


