![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)


# For the Ubuntu VM

# Conpot

This lab deploys **Conpot** (an industrial control system honeypot) as a deception environment and demonstrates how attackers interact with ICS protocols, how to capture telemetry, and how defenders analyze activity


# Start

### Go to the Conpot directory and activate virtualenv

```bash
cd ~/Desktop/conpot
```

```bash
source .venv311/bin/activate
```

### Run Conpot on high ports 
- Create `conpot.cfg` to change service ports to higher numbers (**8080**, **1502**):

```bash
cat > conpot.cfg <<'EOF'
[modbus]
host = 0.0.0.0
port = 1502          ; high port so no sudo needed

[snmp]
host = 0.0.0.0
port = 1161          ; high port

[http]
host = 0.0.0.0
port = 8080          ; high port

[sqlite]
enabled = False

[hpfriends]
enabled = False      ; keep telemetry local for the lab
host = hpfriends.honeycloud.net
port = 20000
ident = disabled
secret = disabled
channels = ["conpot.events", ]

[fetch_public_ip]
enabled = False
url = http://api-sth01.exip.org/?call=ip
EOF
```

- Then run it!
```bash
TPL="/home/ubuntu/Desktop/conpot/conpot/templates/default"
```
```bash
CFG="/home/ubuntu/Desktop/conpot/conpot.cfg"
```
```bash
conpot --template "$TPL" --config "$CFG"
```

<img width="1920" height="719" alt="image" src="https://github.com/user-attachments/assets/096fb635-ab3f-4319-af64-a9d883178ab0" />

---

# Part E — Attack simulation (hands‑on)

Open another terminal (attacker machine or same host).

### 1) Discovery with nmap
```bash
# scan common ICS ports
sudo nmap -sS -p 5020,10201,8800,16100,47808,6230 -sV -Pn localhost
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


