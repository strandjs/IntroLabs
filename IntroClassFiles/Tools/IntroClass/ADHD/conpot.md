![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)


# For the Ubuntu VM

# Conpot


**Goal:** Conpot (an ICS/SCADA honeypot), interact with it, collect evidence, and learn analysis/detection techniques


# Conpot Lab — Student Guide (SSH into VM, Existing Install)

You will connect to a shared Ubuntu VM over SSH.  
Conpot is already installed on that VM in `~/Desktop/conpot`.  
You will NOT edit any files in `~/Desktop/conpot`.  
You will run the honeypot, interact with it, collect evidence, and stop it.

All your work and evidence will be stored in `~/conpot_artifacts` in your home directory.

---

## 0. Connect to the lab VM
From your own machine (laptop):
```bash
ssh ubuntu@<VM_IP_ADDRESS>
```
After you log in, you are working on the VM.

---

## 1. Create your workspace on the VM
This is where you will save results, pcaps, etc. Do NOT work inside `~/Desktop/conpot`.

```bash
mkdir -p ~/conpot_artifacts
```

You will see files appear in this folder as you go through the lab.

---

## 2. Start the honeypot (Conpot)
Conpot is already prepared in `~/Desktop/conpot`.

Run these commands on the VM:
```bash
cd ~/Desktop/conpot

# (optional but safe) pull latest images
sudo docker compose pull

# start Conpot in the background
sudo docker compose up -d

# confirm the container is running
sudo docker ps --filter "name=conpot"

# look at the live log output (press Ctrl+C to stop watching)
sudo docker logs -f conpot
```
At this point the fake ICS/SCADA device is running on this VM using Docker.

---

## 3. Find out what services are exposed
You will now check which ports are listening so you know what to target (web, Modbus, etc).

```bash
# see what ports Conpot is mapped to on the host
sudo docker compose ps

# double-check which ports are listening on the VM
ss -tunlp | egrep ':(80|502|102|47808)|:161' || true
```

Keep note of which ports are open (for example: `80/tcp`, `502/tcp`).  
Most labs will use:
- port 80 for HTTP (web interface / banners / fingerprints)
- port 502 for Modbus/TCP (industrial control protocol)

---

## 4. Basic service discovery (nmap)
You will now scan the VM itself from inside the VM and record the results.

1. Run nmap against localhost:
```bash
nmap -sS -sV -p1-2000 127.0.0.1 -oN ~/conpot_artifacts/nmap_localhost.txt
```

2. View the saved results:
```bash
less ~/conpot_artifacts/nmap_localhost.txt
```

Answer for yourself:
- Which ports are open?
- What service names / versions does nmap guess?

You will submit `nmap_localhost.txt` later.

---

## 5. Check the HTTP surface (port 80)
Try to talk to the honeypot’s HTTP service using `curl`.  
If port 80 is not open/listening, these commands will fail — that’s OK, still record the output.

```bash
curl -I http://127.0.0.1:80 2>&1 | tee ~/conpot_artifacts/http_headers.txt

curl http://127.0.0.1:80 | head -n 60 > ~/conpot_artifacts/http_body_head.txt 2>/dev/null || true
```

Now look at the results:
```bash
less ~/conpot_artifacts/http_headers.txt
```

You will submit `http_headers.txt` and `http_body_head.txt` later.

---

## 6. Talk Modbus to the fake PLC (read-only)
Conpot emulates ICS protocols like Modbus/TCP on port 502.  
You’ll run a safe read-only Modbus query that requests holding registers.  
This simulates an attacker or operator reading process values from a PLC.

1. Create a Python script (in your artifacts folder, NOT in `~/Desktop/conpot`):
```bash
cat > ~/conpot_artifacts/modbus_read.py <<'PY'
from pymodbus.client.sync import ModbusTcpClient as ModbusClient
c = ModbusClient("127.0.0.1", port=502, timeout=3)
if c.connect():
    rr = c.read_holding_registers(0, 6, unit=1)
    print(getattr(rr, 'registers', rr))
    c.close()
else:
    print("Connection failed")
PY
```

2. Install the required Python package and run the script:
```bash
sudo python3 -m pip install --upgrade pip
sudo python3 -m pip install pymodbus
python3 ~/conpot_artifacts/modbus_read.py | tee ~/conpot_artifacts/modbus_read.txt
```

3. View the result:
```bash
less ~/conpot_artifacts/modbus_read.txt
```

You will submit `modbus_read.txt` later.

If you see register values, you just queried an emulated industrial controller.

---

## 7. Simulate noisy attacker behavior (aggressive scan)
Now you will act like a more aggressive attacker.  
This will generate more interesting activity in Conpot’s logs.

```bash
nmap -A -p- 127.0.0.1 -oN ~/conpot_artifacts/aggressive_nmap.txt
```

Then grab the honeypot logs and save them:
```bash
sudo docker logs conpot --tail 500 > ~/conpot_artifacts/conpot_docker_logs.txt
```

Look at the saved log:
```bash
less ~/conpot_artifacts/conpot_docker_logs.txt
```

You will submit `aggressive_nmap.txt` and `conpot_docker_logs.txt` later.

Question to answer in your notes:  
Do you see evidence in the Conpot logs that someone scanned it? What does it log about the connection(s)?

---

## 8. Capture network traffic (PCAP)
Now you will capture the traffic between your scan / Modbus read and the honeypot.  
This is what defenders collect during an investigation.

1. Start a tcpdump capture (this will run in the background):
```bash
sudo tcpdump -i any port 502 or port 80 -w ~/conpot_artifacts/conpot_capture.pcap &
```

2. While tcpdump is running, repeat two actions:
```bash
# re-run Modbus read
python3 ~/conpot_artifacts/modbus_read.py > /dev/null 2>&1

# run a quick nmap on just port 502
nmap -sS -sV -p502 127.0.0.1 > /dev/null 2>&1
```

3. Stop the capture:
```bash
sudo pkill tcpdump
```

4. Confirm the capture file exists:
```bash
ls -lh ~/conpot_artifacts/conpot_capture.pcap
```

You will submit `conpot_capture.pcap` later.

You can download this file to your own machine and open it in Wireshark:
```bash
scp ubuntu@<VM_IP_ADDRESS>:~/conpot_artifacts/conpot_capture.pcap .
```

---

## 9. Build a simple activity timeline
Now you will document what happened and when.  
This is what an analyst does after the fact.

Run:
```bash
cat > ~/conpot_artifacts/timeline.txt <<'TXT'
nmap discovery results file timestamp:
  $(date -r ~/conpot_artifacts/nmap_localhost.txt 2>/dev/null || echo "n/a")

modbus read results file timestamp:
  $(date -r ~/conpot_artifacts/modbus_read.txt 2>/dev/null || echo "n/a")

aggressive scan results file timestamp:
  $(date -r ~/conpot_artifacts/aggressive_nmap.txt 2>/dev/null || echo "n/a")

pcap capture file timestamp:
  $(date -r ~/conpot_artifacts/conpot_capture.pcap 2>/dev/null || echo "n/a")
TXT
```

Then check it:
```bash
less ~/conpot_artifacts/timeline.txt
```

You will submit `timeline.txt` later.

In your notes, answer:
- What did you do first?
- What did you do next?
- Which thing you did would look most suspicious to a defender, and why?

---

## 10. Stop the honeypot (cleanup)
When you are done with the lab, shut down Conpot so it’s not left running.

```bash
cd ~/Desktop/conpot
sudo docker compose down
```

Your evidence is still saved in `~/conpot_artifacts`.  
To copy everything to your own machine, run this from your own machine (not from inside the VM):
```bash
scp ubuntu@<VM_IP_ADDRESS>:~/conpot_artifacts/* ./
```

---

## 11. What you must submit
When you finish, you should have these files in `~/conpot_artifacts`:

1. `nmap_localhost.txt`  
2. `http_headers.txt`  
   (and `http_body_head.txt` if it exists)  
3. `modbus_read.txt`  
4. `aggressive_nmap.txt`  
5. `conpot_docker_logs.txt`  
6. `conpot_capture.pcap`  
7. `timeline.txt`

Those files prove that you:
- started a live honeypot,
- scanned and fingerprinted it like an attacker,
- spoke Modbus to it,
- captured network evidence,
- built a timeline of activity.


***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/IoTPOT.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/openCanary.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---


