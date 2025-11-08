![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)





# OpenCanary Hands‑On Lab — Attack, Defense & Cyber Deception (Beginner-friendly)

**Goal:** Deploy a simple OpenCanary honeypot on Ubuntu (or Debian-based VM), trigger a few attacks (port scan, SSH/SMB probe, simple HTTP request), and observe alerts. This lab is entirely hands-on and uses only easy commands.

**Tested on:** Ubuntu 22.04 / 24.04 (instructions use Python3, `virtualenv`, and systemd).  
**Estimated time:** ~30–60 minutes (depending on downloads).

> Sources: OpenCanary project, official docs and community guides. See notes in the lab for references.

---

## Lab overview (what you'll do)
1. Prepare an Ubuntu VM (or container) and update packages.  
2. Create a Python virtual environment and install OpenCanary and small extras.  
3. Generate a default config and enable a few canary services (SSH, HTTP, SMB, port-scan).  
4. Run OpenCanary as a service.  
5. Launch simple attacks from a second machine (or your host) — nmap, curl, smbclient, ssh attempt — and watch alerts and logs.  
6. Clean up.

Key files you will touch:
- `/etc/opencanaryd/opencanary.conf` (the main config created by `opencanaryd --copyconfig`)  
- A systemd service unit that points to the virtualenv's `opencanaryd` executable.

---

## Quick notes & citations
- OpenCanary is a modular honeypot maintained by Thinkst and documented on ReadTheDocs and GitHub. citeturn0search0turn0search8  
- The `opencanaryd --copyconfig` command creates the default config file (typically `/etc/opencanaryd/opencanary.conf`). citeturn0search1turn0search4

---

## A. Environment setup (host VM)
Run these commands on a fresh Ubuntu VM (you can use VirtualBox, cloud VM, or a Raspberry Pi running Ubuntu). Open a terminal and follow **line-by-line**.

```bash
# 1. Update system
sudo apt update && sudo apt upgrade -y

# 2. Install prerequisites
sudo apt install -y python3 python3-venv python3-pip python3-dev build-essential libpcap-dev git

# Optional helpful tools for testing
sudo apt install -y nmap smbclient curl netcat
```

---

## B. Install OpenCanary inside a virtualenv
Staying in the same terminal:

```bash
# 1. Create a working folder and virtualenv
mkdir -p ~/opencanary-lab
cd ~/opencanary-lab
python3 -m venv env
. env/bin/activate

# 2. Upgrade pip and setuptools inside venv
pip install --upgrade pip setuptools

# 3. Install OpenCanary and useful extras
pip install opencanary opencanary-correlator scapy pcapy

# (If pip fails on pcapy, you may need additional headers — libpcap-dev is installed above.)
```

> Tip: Installing from the GitHub source is also possible (`git clone https://github.com/thinkst/opencanary` then `pip install .`) — many community guides use that approach. citeturn0search0turn0search3

---

## C. Create and edit the config
Still inside your virtualenv:

```bash
# Create the default config (this prints the location)
opencanaryd --copyconfig

# Typical location: /etc/opencanaryd/opencanary.conf
sudo ls -l /etc/opencanaryd/opencanary.conf
```

Now open the config and make small edits. Example uses `nano` (or `vi`):

```bash
sudo nano /etc/opencanaryd/opencanary.conf
```

Inside the JSON config make these **minimal** changes to enable a few services and a log file:

1. Locate the `"device.node_id"` and set a friendly name (optional).  
2. In the `"logger"` section enable `"file.enabled": true` and set a path like `/var/log/opencanary.log`.  
3. In the `"modules"` (or top-level service entries) enable the following:

```json
"ssh": {"enabled": true},
"http": {"enabled": true},
"ftp": {"enabled": false},
"smb": {"enabled": true, "share_name": "SHARE"},
"portscan": {"enabled": true, "ignore_localhost": true}
```

Save and exit.

> The docs note the default config placement and the recommended practice of using a venv when installing. citeturn0search1turn0search4

---

## D. Create a systemd service (so OpenCanary runs in background)
Create a systemd unit file so the canary starts automatically. **Important:** change `/home/youruser/opencanary-lab/env` to the full path of your virtualenv.

```bash
# Create service file (run as root or use sudo)
sudo tee /etc/systemd/system/opencanary.service > /dev/null <<'EOF'
[Unit]
Description=OpenCanary Honeypot
After=network.target

[Service]
Type=simple
User=root
# Replace this with the full path to your virtualenv's opencanaryd
ExecStart=/home/$USER/opencanary-lab/env/bin/opencanaryd --start
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable and start
sudo systemctl daemon-reload
sudo systemctl enable --now opencanary.service

# Check status
sudo systemctl status opencanary.service --no-pager
```

If you prefer to run manually (useful for debugging), from the venv run:

```bash
# From ~/opencanary-lab with venv activated:
opencanaryd --start
# To stop:
opencanaryd --stop
```

(Community guides often recommend placing the service unit and pointing ExecStart at a venv — this pattern is common.) citeturn0search7turn0search11

---

## E. Verify logging is working
If you configured file logging as above, check the log:

```bash
# Wait a moment for startup logs then:
sudo tail -n 50 /var/log/opencanary.log
# Or if using syslog:
sudo journalctl -u opencanary.service -n 200 --no-pager
```

You should see a startup banner mentioning which services are listening.

---

## F. Simple attacker (lab) actions — from another machine (or same host using loopback)
Perform these actions from a second terminal (or another device on the same network). Replace `<CANARY_IP>` with the IP address of the VM.

1. Port scan (nmap)
```bash
nmap -sS -Pn -p- <CANARY_IP>
```
OpenCanary's `portscan` module should flag the scan.

2. SSH probe (attempt to connect)
```bash
ssh -o ConnectTimeout=5 fakeuser@<CANARY_IP>
# or use netcat to open a TCP connection
nc -vz <CANARY_IP> 22
```
This triggers the `ssh` canary.

3. HTTP request
```bash
curl -I http://<CANARY_IP>/
```
This triggers the `http` canary logs.

4. SMB enum (if SMB enabled)
```bash
smbclient -L //<CANARY_IP> -N
```

After each action, check the canary log or journal on the honeypot host to see alerts:

```bash
sudo tail -n 50 /var/log/opencanary.log
# or
sudo journalctl -u opencanary.service -f
```

Expect lines indicating which module detected activity, e.g. `"module": "ssh", "event": "connect", ...`

---

## G. Lab exercises (for students)
1. Run nmap from attacker host and count how many portscan alerts appear in `/var/log/opencanary.log`.  
2. Try to authenticate to the fake SSH (use random usernames). Observe logged username fields.  
3. Use `curl` to fetch `/nonexistent` and inspect whether the HTTP canary logs the request path.  
4. Adjust `opencanary.conf` to change the SMB `share_name` and restart the service — then list the share with `smbclient`.

---

## H. Optional: Send alerts to email or webhook
OpenCanary supports different sinks (syslog, file, elastic, webhook). Example: enable `webhook` in the `"logger"` section (or use opencanary-correlator). Advanced routing is documented in official docs. citeturn0search1turn0search2

---

## I. Cleanup / Uninstall
To stop and remove:

```bash
# Stop service
sudo systemctl stop opencanary.service
sudo systemctl disable opencanary.service
sudo rm /etc/systemd/system/opencanary.service
sudo systemctl daemon-reload

# Remove venv and files
rm -rf ~/opencanary-lab

# Optionally uninstall package (if installed system-wide)
# sudo pip3 uninstall opencanary opencanary-correlator scapy pcapy
```

---

## Troubleshooting tips
- If `opencanaryd` is "not found": ensure you activated the venv or used the correct ExecStart path. Many installs put `opencanaryd` in the venv bin directory. citeturn0search4  
- If `pcapy` fails to install, ensure `libpcap-dev` is installed.  
- If SMB has permission errors, consult the OpenCanary Samba wiki and the Samba logs. citeturn0search10

---

## Learning outcomes
- Students will learn how to deploy a low-cost honeypot and observe attacker behaviour.  
- Students will see how simple probes (port scans, ssh connection attempts, HTTP hits) produce correlatable alerts.  
- Students will be introduced to faster detection and the concept of deception in defense.

---

## References (helpful links)
- OpenCanary GitHub repo (official): https://github.com/thinkst/opencanary. citeturn0search0  
- OpenCanary docs (ReadTheDocs): https://opencanary.readthedocs.io. citeturn0search8  
- Community installation notes & examples (blog/HowTo): various community guides were referenced above. citeturn0search6turn0search3

---

**End of lab.**  
Feel free to ask for: (A) a version tailored for Raspberry Pi; (B) a Docker-based exercise; (C) extra student challenge tasks with sample logs and detection playbooks.











***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/IoTPOT.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/HoneyPorts/HoneyPorts.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
