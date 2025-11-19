![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)






# Cuckoo Sandbox

> **Goal:** See how Cuckoo Sandbox automatically analyzes suspicious files in an isolated Windows VM, and how an analyst can read the results.

---

### In this lab we will

- Install and initialize Cuckoo Sandbox
- Start the Cuckoo daemon and web interface
- Submit a suspicious file for analysis
- Explore the generated report (process tree, files, registry, network, signatures)
- Watch the live Cuckoo logs while an analysis runs

---

## 1. Create a dedicated `cuckoo` user (host hygiene)

We don’t want to run malware analysis as root or as your daily user.

Open a terminal and run:

```bash
sudo adduser cuckoo
```

- Follow the prompts (you can press **Enter** through most fields)
- Add the new user to the `vboxusers` group so it can control VirtualBox:

```bash
sudo usermod -aG vboxusers cuckoo
```

Now switch to that user for the rest of the lab:

```bash
su - cuckoo
```

You should now see a prompt like:

```bash
cuckoo@kali:~$
```

---

## 2. Install Cuckoo Sandbox and basic tools

Still as user `cuckoo` (but using `sudo` when needed), install Cuckoo from the distro repository:

```bash
sudo apt update
sudo apt install -y cuckoo
```

Install a few useful extras (optional but nice to have):

```bash
sudo apt install -y volatility yara ssdeep mongodb
```

Quick check that Cuckoo is available:

```bash
cuckoo --version
```

You should see a version string, not a “command not found” error.

---

## 3. Initialize Cuckoo’s working directory

On first run, Cuckoo will create its **Cuckoo Working Directory (CWD)** under `~/.cuckoo` with config files, logs, and results.

Run:

```bash
cuckoo
```

You should see output saying it’s your first run and that it created configuration under `~/.cuckoo`.  
Press **Ctrl + C** once it finishes initializing (if it doesn’t exit automatically).

Let’s also pull in community signatures (for more interesting reports):

```bash
cuckoo community
```

This may take a bit while it downloads rules/signatures.

---

## 4. Start Cuckoo daemon and web interface

We want two terminals:

### 4.1. Terminal 1 – Cuckoo daemon (backend)

Make sure you are `cuckoo` user in your home directory, then run:

```bash
cuckoo -d
```

- `-d` = debug mode (more verbose logs)
- Leave this terminal **running**. Cuckoo will start workers and wait for submissions.

### 4.2. Terminal 2 – Cuckoo web interface

Open a **second terminal** (also as user `cuckoo`) and run:

```bash
cuckoo web runserver 127.0.0.1:8000
```

Again, leave this running. This is the web UI.

### 4.3. Verify access in the browser

Inside your Linux VM, open a browser (e.g. Firefox) and go to:

```text
http://127.0.0.1:8000
```

You should see the **Cuckoo web dashboard**.

If it loads, your analysis environment is up.

---

## 5. Prepare a test “malicious” file

For a safe demo we’ll use the **EICAR test file**, which is harmless but recognized by many tools as a test virus.

In a third terminal (still as `cuckoo`), create a directory for samples:

```bash
mkdir -p ~/samples
cd ~/samples
```

Download the EICAR test file:

```bash
curl -o eicar.com.txt https://secure.eicar.org/eicar.com.txt
```

List the file to be sure it’s there:

```bash
ls -l
```

You should see `eicar.com.txt`.

> **Note:** Some AV inside the Windows VM may try to delete this file. That’s fine; it’s part of the fun.

---

## 6. Submit a sample from the Cuckoo web UI

Go back to your browser on `http://127.0.0.1:8000`.

1. Click **Submit** (or **Analyze** depending on your version).
2. In **File** upload, choose:
   - `eicar.com.txt` from `/home/cuckoo/samples/`
3. Make sure:
   - Machine: the default Windows VM (your instructor will tell you which name to use if there are several)
   - Analysis options: leave defaults (timeout ~120s is fine)
4. Click **Submit** / **Analyze**.

You should see a message that a task was created (for example, **Task #1**).

### 6.1. Watch the queue

Click on **Tasks** / **Recent** in the web UI. You should see your task moving through states:

- `pending` → `running` → `reported`

This may take a couple of minutes depending on your VM.

Meanwhile, in **Terminal 1** (where `cuckoo -d` is running), you’ll see live logs: starting VM, sending sample, collecting results, etc.

---

## 7. (Optional) Submit via CLI

You can also submit samples from the command line.

In a separate terminal as `cuckoo`:

```bash
cuckoo submit ~/samples/eicar.com.txt
```

It will print the created task ID (e.g., `Task #2`).  
You’ll see it appear in the web UI as well.

---

## 8. Tail Cuckoo logs like an analyst

To get the “blue team” view, we’ll watch the main log file.

Open **another terminal** as `cuckoo` and run:

```bash
tail -f ~/.cuckoo/log/cuckoo.log
```

Now, when you submit a new sample (web or CLI), you can see:

- When Cuckoo queues the task
- When it powers on the analysis VM
- When it starts/stops the agent
- When it processes and stores the report

Leave this running while you trigger analyses.

---

## 9. Explore the analysis report

Once your EICAR task shows as **reported** in the web UI, click its **Task ID** to open the report.

Spend a few minutes browsing each tab. For each, think:

- *What is this showing?*
- *How would this help an analyst or defender?*

### 9.1. Summary

Look at:

- Basic info: sample name, MD5/SHA1/SHA256
- Score (how suspicious it is)
- Quick summary of signatures fired, network activity, dropped files

### 9.2. Behavior / Process Tree

Look at:

- **Process tree** (what process executed the file, what children it spawned)
- **API calls** per process (file/registry/network operations)
- Time line of actions

Ask yourself:

- Which process actually executed the sample?
- Did it spawn any interesting child processes (e.g., `cmd.exe`, `powershell.exe`)?

### 9.3. Files & Registry

Check:

- **Dropped files**: Did the sample write new files to disk?
- **Modified registry keys**: Persistence tricks often live here.

### 9.4. Network

Check:

- DNS requests
- HTTP/HTTPS connections
- IPs and ports contacted

Ask:

- Which domains/IPs were contacted?
- Would you block these in a real network?

### 9.5. Signatures

Cuckoo has built‑in and community **signatures** that look for known behaviors.

- Find which signatures fired (e.g., “EICAR test file detected”, “Suspicious network activity”, etc.)
- Click each one and read its description

This is where defenders get a **high-level interpretation** of the raw behavior.

---

## 10. Mini “attack vs defense” exercise

Let’s play both sides.

### 10.1. Attacker perspective

From the attacker’s point of view, they just:

- Drop or email a suspicious executable
- Get someone to run it on a Windows machine

In our lab, you “play” the attacker by **submitting the sample** into Cuckoo.

### 10.2. Defender / analyst perspective

From the defender’s point of view, they:

- Receive the suspicious file (from email gateway, SOC ticket, etc.)
- Drop it into Cuckoo for **dynamic analysis**
- Read the generated report to decide:
  - Is this malicious?
  - What does it do (IOCs, persistence, callbacks)?
  - What should we block or hunt for?

In this lab, you are the analyst when you:

- Watch `~/.cuckoo/log/cuckoo.log` while the sample runs
- Explore the report tabs and extract:
  - Domains/IPs
  - Filenames/paths
  - Registry keys
  - Suspicious processes / commands

> **Task for students:** Write down at least **3 IOCs** (e.g., domain, file path, hash) from the report that you would feed into SIEM / EDR for hunting.

---

## 11. Bonus: Run a benign file and compare

To see the difference between benign and malicious behavior:

1. Copy a random, benign Windows EXE (e.g., a small tool or viewer) into `~/samples/benign.exe`.
2. Submit it the same way (web or CLI).
3. Compare its report to the EICAR report:
   - Fewer or no signatures firing
   - Simpler process tree
   - Less/no network activity

This contrast helps students understand what **“normal”** vs **“suspicious”** looks like.

---

## 12. Clean up

When you’re done:

1. Stop the web server terminal (**Ctrl + C**).
2. Stop the Cuckoo daemon terminal (**Ctrl + C**).
3. Optionally delete the sample files:

```bash
rm -rf ~/samples
```




***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/RITA_ADHD/RITA.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/dionaea.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
