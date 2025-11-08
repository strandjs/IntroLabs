![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)


# For the Ubuntu VM


# OpenCanary 

**Goal:** Deploy a simple **OpenCanary** honeypot, trigger a few attacks (port scan, **SSH/SMB probe**, simple **HTTP request**), and observe **alerts**

---

## C. Create and edit the config
Still inside your virtualenv:

- Create the default config (this prints the location)
```bash
opencanaryd --copyconfig
```

<img width="1920" height="105" alt="image" src="https://github.com/user-attachments/assets/63632a27-543b-44e9-92c9-7752d08d8cd5" />

- Make sure it is there

```bash
sudo ls -l /etc/opencanaryd/opencanary.conf
```

<img width="676" height="28" alt="image" src="https://github.com/user-attachments/assets/02663032-15a1-4636-8bf4-f47d013dd317" />


- Now open the config and make small edits. Example uses `nano` (or `vi`):

```bash
sudo nano /etc/opencanaryd/opencanary.conf
```

- Inside the JSON config make these **minimal** changes to enable a few services and a log file:

1. Locate the `"device.node_id"` and set a friendly name  

<img width="330" height="30" alt="image" src="https://github.com/user-attachments/assets/a6c1293c-c846-40dd-a163-622f4b9d39b7" />


2. In the `"logger"` section make sure there is a `file` part under `handlers` and set a path like `/var/log/opencanary.log`

<img width="426" height="193" alt="image" src="https://github.com/user-attachments/assets/cddf72a1-c116-498a-85a2-0641a672052b" />

3. In the `"modules"` (or top-level service entries) enable the following:

```json
"ssh": {"enabled": true},
"http": {"enabled": true},
"ftp": {"enabled": false},
"smb": {"enabled": true},
"portscan": {"enabled": true}
```

<img width="214" height="28" alt="image" src="https://github.com/user-attachments/assets/f117736a-64b7-4015-a3d7-d31cff4cc54e" />

<img width="214" height="30" alt="image" src="https://github.com/user-attachments/assets/44f81b20-b793-4396-8d94-12ec76e7bf89" />

<img width="214" height="28" alt="image" src="https://github.com/user-attachments/assets/cd3c2c07-cc83-4ef0-8d6d-0ef25ab80259" />

<img width="214" height="28" alt="image" src="https://github.com/user-attachments/assets/c535dde2-fd4e-4a70-91c9-6afe0c04b4b7" />

<img width="231" height="28" alt="image" src="https://github.com/user-attachments/assets/bc2a9520-e551-44a8-9bdd-f0d5d64782f7" />


- Save and exit with `Ctrl + x` and `y` and `Enter`


---

## Create a systemd service (so OpenCanary runs in background)
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

(Community guides often recommend placing the service unit and pointing ExecStart at a venv — this pattern is common.)

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



***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/IoTPOT.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/HoneyPorts/HoneyPorts.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
