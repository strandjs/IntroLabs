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
```

```bash
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

# Part 2 - Deploy a Sandcat agent

The **Sandcat plugin** is CALDERA’s default agent. It can be deployed using the server’s built-in delivery commands or by downloading it from CALDERA

## 1) Download and run the agent

In a new terminal:

```bash
server="http://localhost:8888"
```

```bash
curl -s -X POST -H "file:sandcat.go" -H "platform:linux" "$server/file/download" > sandcat
```

```bash
chmod +x sandcat
```

```bash
./sandcat -server "$server" -group red -v
```

You should see the agent running and “beaconing” (calling back to CALDERA)

<img width="805" height="322" alt="image" src="https://github.com/user-attachments/assets/4bdab989-edff-4735-b240-5afeb9c81112" />


## 2) Confirm the agent shows up in the UI

In the CALDERA web UI:
- Go to **Agents**
- You should see a new agent appear (often “trusted” within a minute)

<img width="430" height="319" alt="image" src="https://github.com/user-attachments/assets/b28951c9-621c-4a52-a66d-2ec2477b7f90" />


If it doesn’t show:
- Make sure `python3 server.py ...` is still running
- Make sure you used `server="http://localhost:8888"` (same as your UI URL)

---

# Part 3 - Run a simple ATT&CK operation (Red / Attack)

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

# Part 4 - Run a simple Defense operation

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

- Now look at the left tab of actions, scroll down until you see the **Log out** button, click it

<img width="214" height="47" alt="image" src="https://github.com/user-attachments/assets/c2048e0c-95ff-4d36-badd-d4f0a77c5c64" />

Log in as:
- Username: `blue`
- Password: `admin`

- Go to **Agents**

<img width="424" height="325" alt="image" src="https://github.com/user-attachments/assets/f91b983a-e600-4dcc-833c-852536a3ea1e" />

- You should see an agent in group **blue**

## 2) Run a basic defender profile

In the UI:
- Go to **Adversaries** and click `Manage Adversaries`

<img width="435" height="342" alt="image" src="https://github.com/user-attachments/assets/49d24f7f-9410-4f44-b604-5ac3d94220e4" />

- Pick `Incident responder`

- Click on the **"Mountain"** on the top left to get back to the **Start Page**

<img width="224" height="168" alt="image" src="https://github.com/user-attachments/assets/9f1d2533-c4d1-4557-a8ed-c71db8d32494" />

- Go to **Operations** and click `Manage Operations`

<img width="428" height="336" alt="image" src="https://github.com/user-attachments/assets/b18033bc-0454-4a4b-80e4-56f1087d0bf5" />

- Click **New operation**

<img width="151" height="60" alt="image" src="https://github.com/user-attachments/assets/16e007c3-9b21-4d4d-b2e1-be6d11333fbc" />

- Create a new operation:
  - **Operation Name:** 
  - **Group:** `blue`
  - **Adversary:** `Incident responder`
  - **Autonomous** `Require manual approval` - we use this to have more control and see in real time everything that happens

<img width="799" height="651" alt="image" src="https://github.com/user-attachments/assets/027fce1f-b055-42f0-a040-4c095e7e2a4e" />

- Start it!

- Now, for every command, we need to approve it

<img width="172" height="92" alt="image" src="https://github.com/user-attachments/assets/6bc315a6-975d-4143-b0b9-477fc836c1e3" />

<br>

<img width="345" height="204" alt="image" src="https://github.com/user-attachments/assets/b64b6357-d8e2-46c6-87ae-e858b284f99c" />

- From here on, you can play with it however you like, EXPERIMENT!!!

***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/FileAudit/FileAudit.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/bluespawn/Bluespawn.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
