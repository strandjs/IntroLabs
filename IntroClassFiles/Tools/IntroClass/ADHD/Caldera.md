![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)


# MITRE CALDERA

This lab is designed to be **fully hands-on**, beginner-friendly, and runnable on **one Ubuntu Linux VM** (or any Linux host)

You will install **MITRE CALDERA**, deploy a **Sandcat agent**, run a small **attack operation**, run a simple **defense operation**, and finish with a **cyber deception demo** using a “honeyfile” + alert

---

## In this lab we will

- Log in and verify CALDERA is working
- Deploy a **Sandcat** agent (on the same machine)
- Run an **Adversary (red)** operation: basic discovery + collection
- Run a **Defender (blue)** operation: basic response actions
- Do a **Cyber Deception** mini-demo:
  - Create a **honeyfile** with fake “secrets”
  - Set a simple **file access alert**
  - Use CALDERA to “touch” the honeyfile and observe the alert

---

## Start the server

On the first boot, use `--build` to build the web UI and plugin assets

```bash
cd ~/Desktop/caldera
python3 server.py --insecure --build
```

- Leave this terminal running.
- You should see log output showing the server is listening.

## Log in to the web UI

Open a browser on the VM (or forward port 8888 via SSH) and go to:

- `http://localhost:8888`

Log in as:
- Username: `red`
- Password: `admin`

---

# Part 2 — Deploy a Sandcat agent (local)

The **Sandcat plugin** is CALDERA’s default agent. It can be deployed using the server’s built-in delivery commands or by downloading it from CALDERA

## 1) Download and run the agent (Linux)

In a new terminal:

```bash
server="http://localhost:8888"
curl -s -X POST -H "file:sandcat.go" -H "platform:linux" "$server/file/download" > sandcat
chmod +x sandcat
./sandcat -server "$server" -group red -v
```

You should see the agent running and “beaconing” (calling back to CALDERA)

<img width="805" height="322" alt="image" src="https://github.com/user-attachments/assets/4bdab989-edff-4735-b240-5afeb9c81112" />


> This uses CALDERA’s `/file/download` endpoint (documented in the official CALDERA API docs) to get payloads from the server

## 2) Confirm the agent shows up in the UI

In the CALDERA web UI:
- Go to **Agents**
- You should see a new agent appear (often “trusted” within a minute)

<img width="430" height="319" alt="image" src="https://github.com/user-attachments/assets/b28951c9-621c-4a52-a66d-2ec2477b7f90" />


If it doesn’t show:
- Make sure `python3 server.py ...` is still running
- Make sure you used `server="http://localhost:8888"` (same as your UI URL)

---

# Part 3 — Run a simple ATT&CK operation (Red / Attack)

CALDERA’s **Stockpile** plugin contains lots of built-in abilities and adversary profiles

We’ll run a simple “Discovery/Collection” style operation

## 1) Pick an adversary profile (easy starter)

In the UI:

- Click on the **"Mountain"** on the top left to get back to the **Start Page**

<img width="224" height="168" alt="image" src="https://github.com/user-attachments/assets/9f1d2533-c4d1-4557-a8ed-c71db8d32494" />

- Go to **Adversaries** and click `Manage Adversaries`

<img width="435" height="342" alt="image" src="https://github.com/user-attachments/assets/49d24f7f-9410-4f44-b604-5ac3d94220e4" />

- Choose one of the built-in “discovery/collection” style adversaries (names vary by version), but for this lab we will use the **Discovery** one, select it

<img width="1692" height="700" alt="image" src="https://github.com/user-attachments/assets/14520373-cd4e-4bbc-935b-85b5af5d079e" />

## 2) Start an operation

In the UI:

- Click on the **"Mountain"** on the top left to get back to the **Start Page**

<img width="224" height="168" alt="image" src="https://github.com/user-attachments/assets/9f1d2533-c4d1-4557-a8ed-c71db8d32494" />

- Go to **Operations** and click `Manage Operations`

<img width="428" height="336" alt="image" src="https://github.com/user-attachments/assets/b18033bc-0454-4a4b-80e4-56f1087d0bf5" />

- Click **New operation**

<img width="151" height="60" alt="image" src="https://github.com/user-attachments/assets/16e007c3-9b21-4d4d-b2e1-be6d11333fbc" />

- Set:
  - **Operation Name** `Caldera Lab`
  - **Group:** `red`
  - **Adversary:** `Discovery`

<img width="805" height="665" alt="image" src="https://github.com/user-attachments/assets/5f3982d8-28a1-4666-a805-3ce9ad85e7cf" />

Start the operation by clicking **Start**

## 3) Watch it run

Click the operation and watch the **links** appear:
- Each link is an executed step (like “whoami”, “hostname”, “find files”, etc)
- Click a link to see:
  - the command sent
  - the output returned

<img width="1690" height="671" alt="image" src="https://github.com/user-attachments/assets/9009f4bf-d894-4cef-a9e0-6bf0e7077904" />


---

# Part 4 — Run a simple Defense operation (Blue / Response)

CALDERA can also run **defensive actions**

The idea: you can push response actions to endpoints the same way you push adversary actions

## 1) Create a “blue” agent (quick way)

- In the **UI**, press the **Square** under **Running** to stop the operation

<img width="195" height="70" alt="image" src="https://github.com/user-attachments/assets/0bb6d1e3-ec75-4223-989d-fcf8affcd863" />

- Then go to your **Agent Terminal**

- Stop the running agent (**CTRL+C**) and re-run it as group `blue`:

```bash
./sandcat -server "http://localhost:8888" -group blue -v
```

Now in the UI:

- Click on the **"Mountain"** on the top left to get back to the **Start Page**

<img width="224" height="168" alt="image" src="https://github.com/user-attachments/assets/9f1d2533-c4d1-4557-a8ed-c71db8d32494" />

- Go to **Agents**

<img width="424" height="325" alt="image" src="https://github.com/user-attachments/assets/312e5749-bd25-4e75-9682-7b936df71ddd" />

- You should see an agent in group **blue**

## 2) Run a basic defender profile

In the UI:
- Go to **Defenders**
- Pick an easy “incident response” / “collection” defender (names vary by version)
- Go to **Operations**
- Create a new operation:
  - **Group:** `blue`
  - **Adversary:** (for blue ops CALDERA still uses the same “operation” screen; pick the defender profile you selected)
  - **Manual mode** is nice here so students see each action before it runs

Start and observe results.

> Note: Some CALDERA setups separate “defender profiles” vs “adversary profiles” depending on plugins and version. If you don’t see **Defenders** in your UI, skip this section and treat “blue” as “response operations” using any safe built-in abilities (like listing processes, listing connections, etc.).

---

# Part 5 — Cyber Deception mini-demo (Honeyfile + alert)

This is intentionally simple: we will plant a fake “secret” file and create an alert that fires when anything reads it.

## 1) Create a honeyfile

In a terminal:

```bash
mkdir -p ~/deception
cat > ~/deception/DO_NOT_OPEN_secrets.txt << 'EOF'
# INTERNAL SECRETS (TRAINING DECOY)
AWS_ACCESS_KEY_ID=AKIAFAKEFAKEFAKEFAKE
AWS_SECRET_ACCESS_KEY=FAKE/FAKE/FAKE/FAKE/FAKEFAKEFAKEFAKE
VPN_PASSWORD=Winter2026!
EOF
```

## 2) Start a “file access” monitor (alert)

Install `inotify-tools`:

```bash
sudo apt -y install inotify-tools
```

Now start a watcher (leave it running):

```bash
inotifywait -m -e open,access,modify ~/deception/DO_NOT_OPEN_secrets.txt
```

This will print a line whenever the file is opened/accessed/modified.

## 3) Create a CALDERA ability to “touch” the honeyfile

We’ll add a tiny custom ability that reads the file (simulating an attacker discovering and opening it).

### Option A (easy): Create ability in the UI

In CALDERA UI:
- Go to **Abilities**
- Click **Add ability**
- Fill:
  - **Name:** Read honeyfile
  - **Tactic:** collection
  - **Technique:** (pick any “Data from Local System” / similar)
  - **Platform:** linux
  - **Executor:** sh
  - **Command:**
    ```bash
    cat ~/deception/DO_NOT_OPEN_secrets.txt
    ```

Save it.

### Option B (no-UI editing): Quick YAML ability file

Create this file on the CALDERA server:

```bash
mkdir -p ~/caldera/data/abilities
cat > ~/caldera/data/abilities/read-honeyfile.yml << 'EOF'
- id: 11111111-2222-3333-4444-555555555555
  name: Read honeyfile
  description: Reads a decoy secrets file (training deception demo)
  tactic: collection
  technique:
    attack_id: T1005
    name: Data from Local System
  platforms:
    linux:
      sh:
        command: |
          cat ~/deception/DO_NOT_OPEN_secrets.txt
EOF
```

Then restart CALDERA so it loads the new ability:
- Go to the server terminal and press `CTRL+C`
- Start again:

```bash
cd ~/caldera
python3 server.py --insecure --build
```

## 4) Run the deception test operation

In the UI:
- Go to **Operations**
- Create a new operation:
  - **Group:** `red` (or `blue`, either is fine)
  - **Adversary:** create a small adversary that contains only your “Read honeyfile” ability  
    (or add the ability to an existing adversary)
- Start the operation

## 5) Observe the alert

Look at the terminal running `inotifywait`.

You should see an event like `OPEN` / `ACCESS` when CALDERA runs `cat`.

### What this demonstrates

- **Deception idea:** A decoy asset (honeyfile) that should never be opened
- **Detection hook:** Any access is suspicious and triggers an alert
- **Automation:** CALDERA can simulate “attacker behavior” repeatedly to test your alerting/response

---

# Cleanup (optional)

## Stop the agent

In the agent terminal:
- `CTRL+C`

## Stop CALDERA

In the server terminal:
- `CTRL+C`

## Remove the deception files

```bash
rm -rf ~/deception
```

---

# Troubleshooting quick fixes

### UI loads, but agent never shows up
- Confirm server is reachable:
  ```bash
  curl -I http://localhost:8888
  ```
- Confirm you used the same URL in the agent:
  ```bash
  ./sandcat -server "http://localhost:8888" -group red -v
  ```

### “Permission denied” running sandcat
```bash
chmod +x sandcat
```

### Port 8888 already in use
Find the process:
```bash
sudo ss -tulnp | grep 8888
```
Stop it, or change CALDERA port in config (advanced; not needed for this lab).

---

## References (for instructors)

- Official CALDERA install docs (quick install + password location). citeturn1view1  
- CALDERA basic usage (abilities/adversaries/operations concepts). citeturn1view2  
- Sandcat plugin docs (default agent + deployment). citeturn2search1turn2search5  
- CALDERA API docs: `/file/download` example. citeturn2search3  













***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/FileAudit/FileAudit.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/Metta.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
