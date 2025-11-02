![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)


# For the Ubuntu VM

# Conpot


**Goal:** Conpot (an ICS/SCADA honeypot), interact with it, collect evidence, and learn analysis/detection techniques

---
## Quick overview (one-liner)
1. SSH into VM -> `cd ~/Desktop/conpot` -> `sudo docker compose up -d` -> run discovery & Modbus exercises from the VM (host) -> collect logs & pcaps into `~/conpot_artifacts` -> `scp` artifacts to your laptop.

---
## 0) Before students connect (Instructor checklist)
Run or verify these once (on the VM):
```bash
# make artifact folder (safe, outside conpot dir)
mkdir -p ~/conpot_artifacts
sudo chown $USER:$USER ~/conpot_artifacts
# ensure docker is installed and working
sudo docker --version && sudo docker compose version
# ensure firewall/security groups block external access to ports if VM is in cloud
# (Instructor: ensure only SSH is reachable from students; Conpot ports should NOT be public)
ss -tunlp | egrep ':(80|502|102|47808)|:161' || true
```
If Conpot is already running and binding to 0.0.0.0 on those ports, *do not* expose the VM to the internet. Use student SSH sessions to run the lab locally on the VM only.

---
## 1) How students start the honeypot (exact commands they will run)
Tell students to SSH into the VM and run these commands exactly (they do **not** edit any files under `~/Desktop/conpot`):

```bash
ssh ubuntu@<VM_IP>
# on VM now
cd ~/Desktop/conpot
# bring up Conpot (this is how you said it's run)
sudo docker compose pull    # optional: ensure latest images
sudo docker compose up -d
# confirm containers are up
sudo docker ps --filter "name=conpot"
# show logs (instructor/demo can follow in separate terminal)
sudo docker logs -f conpot
# press Ctrl+C to stop following logs
```
If `sudo docker compose up -d` fails, students should paste the `docker compose up` stdout/stderr into a file in `~/conpot_artifacts/compose_error.txt` and notify the instructor:
```bash
sudo docker compose up 2>&1 | tee ~/conpot_artifacts/compose_error.txt
```

---
## 2) Inspect what ports Conpot is listening on (no file edits)
After Conpot is up, students must check which ports are exposed/listening on the VM so we know how to target it safely:

```bash
# quick: docker compose ps shows mapped ports
sudo docker compose ps

# also check host-level listeners
ss -tunlp | egrep ':(80|502|102|47808)|:161' || true

# if ports appear bound to 127.0.0.1, safe for host-only access
# if bound to 0.0.0.0 AND VM is on an unsafe network, STOP and ask instructor.
```

**Instructor note:** If ports are bound to `0.0.0.0` and this VM is internet-facing, instruct students to stop the lab until you reconfigure networking. We are assuming proper isolation.

---
## 3) Where logs and data are (we won't change Conpot files)
Conpot may log into container-internal paths. To avoid editing Conpot files, we will copy runtime logs/artifacts out to `~/conpot_artifacts` for analysis.

Useful commands (students run these after exercises to collect evidence):

```bash
# create artifacts directory (if not already)
mkdir -p ~/conpot_artifacts

# grab last 500 lines of Docker logs
sudo docker logs conpot --tail 500 > ~/conpot_artifacts/conpot_docker_logs.txt

# copy conpot-data if it exists as a host volume (some compose setups already mount it)
# but DO NOT modify existing files inside the repo; we only copy
if [ -d ~/Desktop/conpot/conpot-data ]; then
  cp -r ~/Desktop/conpot/conpot-data ~/conpot_artifacts/conpot-data-copy
fi
```

---
## 4) Lab exercises (students run these — all from VM host SSH session)

**Important:** These commands run from the VM (not a separate attacker VM/container). They target Conpot running on the same machine. Use `127.0.0.1` or container name / internal IP depending on `docker compose ps` output.

### 4.1 Basic discovery — find open ports
```bash
# prefer localhost if ports are published to 127.0.0.1
nmap -sS -sV -p1-2000 127.0.0.1 -oN ~/conpot_artifacts/nmap_localhost.txt

# OR if ports mapped to host IP (example: docker compose ps shows 0.0.0.0:502->502/tcp),
# target localhost too. If docker bind is different, use that IP.
```

### 4.2 Quick HTTP check
```bash
curl -I http://127.0.0.1:80 2>&1 | tee ~/conpot_artifacts/http_headers.txt
curl http://127.0.0.1:80 | head -n 60 > ~/conpot_artifacts/http_body_head.txt 2>/dev/null || true
```
If HTTP isn't published, these commands will show connection refused — that's fine. Note results.

### 4.3 Safe Modbus read (read-only)
Create a small Modbus read script *outside* the Conpot directory (students should run from their home):

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

# install dependency and run
sudo python3 -m pip install --upgrade pip
sudo python3 -m pip install pymodbus
python3 ~/conpot_artifacts/modbus_read.py | tee ~/conpot_artifacts/modbus_read.txt
```

If Conpot is not listening on 127.0.0.1:502, check `docker compose ps` and adapt the host/port accordingly (instructor to help).

### 4.4 Aggressive scan (observe Conpot logs)
Run this only if the instructor allowed it. It generates noisy logs:
```bash
nmap -A -p- 127.0.0.1 -oN ~/conpot_artifacts/aggressive_nmap.txt
# while this runs, in another SSH window:
sudo docker logs -f conpot | sed -n '1,200p'
# then Ctrl+C to stop following
```

### 4.5 Capture network traffic (pcap)
Students capture traffic **on the VM host** to record interactions:
```bash
# capture only relevant ports (tcp 502 modbus, tcp 80 http)
sudo tcpdump -i any port 502 or port 80 -w ~/conpot_artifacts/conpot_capture.pcap &
# run one of the above interactions (modbus_read, nmap, curl)
sleep 5
sudo pkill tcpdump
# verify file exists
ls -lh ~/conpot_artifacts/conpot_capture.pcap
```
If `tcpdump` requires sudo, we used it. The pcap is now on VM and can be `scp`'d to laptop for Wireshark.

---
## 5) Correlate logs & pcap (simple exercise)
After collecting artifacts, students should:

```bash
# examine conpot logs we grabbed
less ~/conpot_artifacts/conpot_docker_logs.txt

# inspect pcap summary (tshark/tcpdump)
sudo tcpdump -r ~/conpot_artifacts/conpot_capture.pcap -n -q | head -n 50

# extract modbus frames with tshark if installed (optional)
sudo apt install -y tshark || true
tshark -r ~/conpot_artifacts/conpot_capture.pcap -Y modbus -T fields -e frame.time -e ip.src -e ip.dst -e modbus.func_code -e modbus.reference_num -e modbus.value | head -n 40
```

Students produce a short timeline file:
```bash
cat > ~/conpot_artifacts/timeline.txt <<'TXT'
- nmap discovery: $(date -r ~/conpot_artifacts/nmap_localhost.txt 2>/dev/null || echo "n/a")
- modbus read: $(date -r ~/conpot_artifacts/modbus_read.txt 2>/dev/null || echo "n/a")
- pcap created: $(date -r ~/conpot_artifacts/conpot_capture.pcap 2>/dev/null || echo "n/a")
TXT
```

---
## 6) Cleanup (stop Conpot) — students must run this when done
```bash
cd ~/Desktop/conpot
sudo docker compose down
# copy artifacts off the VM (instructor or student)
ls -l ~/conpot_artifacts
```

---
## 7) Troubleshooting quick-help (do not edit files!)
- **"Connection refused" on localhost:502** -> run `sudo docker compose ps` to verify whether port 502 is mapped to the host. If not mapped, use `sudo docker inspect CONTAINER_ID` to find container IP and then target that IP (instructor can assist). Do not edit `~/Desktop/conpot` files.
- **"docker compose up" fails due to image pull** -> `sudo docker compose pull` then `sudo docker compose up`. If image name mismatch, notify instructor with `~/conpot_artifacts/compose_error.txt`.
- **Artifacts not created** -> ensure `~/conpot_artifacts` exists and commands used `tee` or redirected output into that folder.

---
## 8) Deliverables (what students hand in)
Students must submit these files from the VM (use `scp` to transfer to their laptops):
- `~/conpot_artifacts/nmap_localhost.txt` (or alternative nmap file)
- `~/conpot_artifacts/modbus_read.txt`
- `~/conpot_artifacts/conpot_capture.pcap`
- `~/conpot_artifacts/conpot_docker_logs.txt`
- `~/conpot_artifacts/timeline.txt`

Instructor will grade based on ability to find services, capture traffic, and correlate events.

---
## 9) Safety reminder (must be read aloud)
- **Do not** expose Conpot to the public Internet. If the `docker compose ps` output shows `0.0.0.0` bindings and this VM is on a public network, pause the lab and contact the instructor.  
- All commands in this lab are read-only except `docker compose up/down` and creating artifacts. We do not modify `~/Desktop/conpot` files.

---
If you want, I will now write a single helper script `~/conpot_artifacts/run_lab_steps.sh` on the VM to automate the sequence (this will create one file on the VM). Say **"write script"** and I'll add it.  




***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/IoTPOT.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/openCanary.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---


