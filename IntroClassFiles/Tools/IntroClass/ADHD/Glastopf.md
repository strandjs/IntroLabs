![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# For the Ubuntu VM

# Glastopf

**Goal:** Run a working Glastopf web-application honeypot, generate simple attacks against it, and inspect captured requests and payloads. This lab uses simple commands so anyone can follow along.

---

## 1 — Quick option: Run Glastopf with Docker (recommended)

### Install Docker (if you don’t have it):

```bash
# Ubuntu / Debian
sudo apt update
sudo apt install -y docker.io docker-compose
sudo systemctl enable --now docker
# allow current user to use docker without sudo (log out/in may be required)
sudo usermod -aG docker $USER
```

### Create a workspace and start Glastopf container

```bash
mkdir -p ~/glastopf-lab && cd ~/glastopf-lab
# create a minimal config + data dirs
mkdir -p data logs

# Pull a public Glastopf image (official or community). If network blocks hub, build locally from Dockerfile.
# We'll use a common community image that exposes port 80
sudo docker pull honeynet/glastopf:latest || sudo docker pull decepot/glastopf:latest

# Run container, map port 80 to host and mount data for persistence
sudo docker run --rm -it \
  -p 80:80 \
  -v $(pwd)/data:/var/lib/glastopf \
  -v $(pwd)/logs:/var/log/glastopf \
  --name glastopf honeynet/glastopf:latest
```

> If `docker run` starts interactive logs, open a second terminal for the attack/inspection steps.

---

## 2 — Alternate option: Native pip install (Python2/3 may vary)

> Use this if you want Glastopf files on the host. Docker keeps things cleaner for beginners.

```bash
# Install basic deps
sudo apt update
sudo apt install -y git python3 python3-venv python3-pip build-essential

# Create a folder and virtualenv
cd ~
mkdir -p glastopf-src && cd glastopf-src
python3 -m venv venv
source venv/bin/activate

# Clone and install
git clone https://github.com/mushorg/glastopf.git .
pip install --upgrade pip
pip install -r requirements.txt || true
python setup.py install

# Create a working directory and start
mkdir -p ~/glastopf-run && cd ~/glastopf-run
# This command generates config and runs the honeypot
glastopf-runner
```

> If `hpfeeds` errors appear during install, you may need to `pip install hpfeeds` separately.

---

## 3 — Verify Glastopf is running and listening

Open a new terminal on the same machine and run:

```bash
# Check process or Docker container
ps aux | grep glastopf
sudo docker ps --filter name=glastopf

# Check listening ports (HTTP usually 80)
sudo ss -tulpen | grep -E ":80|glastopf"

# Tail the main log
sudo tail -f ~/glastopf-lab/logs/glastopf.log
# or (native install)
sudo tail -f ~/glastopf-run/log/glastopf.log
```

You should see startup messages and generated "dork pages" as Glastopf initializes.

---

## 4 — Generate attacks (safe, local tests)

Open another terminal (attacker) and try the following. These simulate common web malicious requests.

### 4.1 — Simple directory traversal / LFI attempts

```bash
curl -v "http://localhost/index.php?page=../../etc/passwd"
curl -v "http://localhost/?file=../boot.ini"
```

### 4.2 — SQL injection-like payloads

```bash
curl -v "http://localhost/products.php?id=1' OR '1'='1"
curl -v "http://localhost/search.php?q=1%27%20UNION%20SELECT%20NULL--"
```

### 4.3 — Remote command injection attempts

```bash
curl -v "http://localhost/?cmd=whoami"
curl -v "http://localhost/?cmd=;id"
```

### 4.4 — Use automated scanners (optional)

Install basic testing tools and run quick scans against `localhost`.

```bash
sudo apt install -y nikto sqlmap dirb
nikto -h http://localhost
sqlmap -u "http://localhost/index.php?id=1" --batch --level=1
# dirb will brute-force paths (run carefully)
dirb http://localhost /usr/share/wordlists/dirb/common.txt
```

> Each of the above requests are recorded by Glastopf and should show up in logs and the event store.

---

## 5 — Inspect captured events & payloads

Glastopf stores events and some payloads in an sqlite DB and log files. Location depends on how you ran it:

* Docker mounted dir: `~/glastopf-lab/data` and `~/glastopf-lab/logs`
* Native: `~/glastopf-run/log/` and data under `~/.glastopf` or `/var/lib/glastopf`

### 5.1 — Tail logs while you run attacks

```bash
sudo tail -f ~/glastopf-lab/logs/glastopf.log
# or
sudo tail -f ~/glastopf-run/log/glastopf.log
```

Look for lines mentioning `New request`, `Exploit detected`, `URI`, `POST` data, etc.

### 5.2 — Use sqlite3 to query events

```bash
# find the DB file (example paths)
ls -l ~/glastopf-lab/data
# open sqlite DB (example filename: glastopf.db or events.db)
sqlite3 ~/glastopf-lab/data/glastopf.db

# inside sqlite3 shell
.tables
SELECT id, timestamp, source_ip, uri, attack_type FROM events ORDER BY timestamp DESC LIMIT 20;
.mode column
.headers on
.quit
```

### 5.3 — Inspect raw captured payloads

Captured POST bodies, payloads and samples are usually stored in `data/captured` or inside the DB as blobs. Check the `data` directory you mounted.

```bash
find ~/glastopf-lab/data -type f -maxdepth 3 -print
```

If you see files that look like injected payloads, view them with `less` or `cat` (do not execute anything):

```bash
less ~/glastopf-lab/data/captured/somefile
```

---

## 6 — Play: Observe attacker vs analyst perspectives

* Attacker perspective: the curl/nikto/sqlmap output in the attacker terminal (shows how tools see the target).
* Analyst perspective: glastopf logs and DB entries (shows captured URIs, user-agents, POST data).

Try a small script that sends many SQL injection strings and watch the logs grow:

```bash
for s in "' OR '1'='1" "UNION SELECT" "../etc/passwd" "${@}" "|ls"; do
  curl -s "http://localhost/index.php?q=$s" > /dev/null
done
```

```bash
sudo tail -n 50 ~/glastopf-lab/logs/glastopf.log
```



***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/ModSecurity.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/webhoneypot/webhoneypot.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
