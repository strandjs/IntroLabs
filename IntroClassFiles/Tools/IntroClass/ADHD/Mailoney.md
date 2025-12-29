![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)


# Mailoney

You’ll deploy **Mailoney** (a low-interaction SMTP honeypot) and then **simulate simple email-based attacks** to see what it captures

---

# Setup

- Open a terminal

```bash
cd ~/Desktop/mailoney
```

```bash
source venv/bin/activate
```

---

# Start Mailoney (SQLite + port 2525)

We’ll run Mailoney on:
- IP: `127.0.0.1`
- Port: `2525`
- Database: `sqlite:///mailoney.db` (a file in this folder)

Start it:
```bash
python main.py \
  --ip 127.0.0.1 \
  --port 2525 \
  --server-name mail.lab \
  --db-url sqlite:///mailoney.db \
  --log-level INFO
```

<img width="955" height="361" alt="image" src="https://github.com/user-attachments/assets/9e3d0da7-a64e-477d-9ce4-21b3acb0a5c6" />


Leave this terminal open (it will show logs)

> If you stop it later: press **Ctrl+C**

---

# Verify it’s listening

Open a **second terminal**, go back to the same folder, and activate the venv again:

```bash
cd ~/Desktop/mailoney
```

```bash
source venv/bin/activate
```

Check the listening port:
```bash
ss -lntp | grep 2525
```

<img width="851" height="21" alt="image" src="https://github.com/user-attachments/assets/6e2ac1a2-54f2-4ea9-99a9-4b97922402f0" />


You should see something listening on `127.0.0.1:2525`

---

# Simulate a basic SMTP “email delivery”

We’ll use **swaks** (Swiss Army Knife for SMTP)

Send a test email into the honeypot:
```bash
swaks \
  --server 127.0.0.1 \
  --port 2525 \
  --from alice@demo.local \
  --to bob@demo.local \
  --header "Subject: Hello from the lab" \
  --body "This is a harmless test message captured by Mailoney."
```

- Back in the **Mailoney Terminal**, we can see the hit

<img width="341" height="23" alt="image" src="https://github.com/user-attachments/assets/29b9e1dd-7198-4654-8ef2-787af84b0fa4" />

- Go back to the **Second Terminal** and do this to get the data received by the honeypot from the last hit
```bash
sqlite3 -header -column mailoney.db \
"SELECT id, timestamp, ip_address, session_data
 FROM smtp_sessions
 ORDER BY timestamp DESC
 LIMIT 1;"
```

<img width="1920" height="442" alt="image" src="https://github.com/user-attachments/assets/8388b757-aa83-4975-8346-a2046715a6cc" />


---

# Simulate a credential-harvesting attempt

Attackers often try weak credentials on SMTP servers

Run this to attempt SMTP AUTH LOGIN:
```bash
swaks \
  --server 127.0.0.1 \
  --port 2525 \
  --auth LOGIN \
  --auth-user admin \
  --auth-password 'Password123!' \
  --quit-after AUTH
```

**What to observe**
- Even if auth does not truly “succeed” (it’s a honeypot), Mailoney is designed to **capture the authentication attempt**


## Inspect what Mailoney captured

```bash
sqlite3 -header -column mailoney.db \
"SELECT id, timestamp, ip_address, session_data
 FROM smtp_sessions
 ORDER BY timestamp DESC
 LIMIT 1;"
```


<img width="1920" height="261" alt="image" src="https://github.com/user-attachments/assets/7358e436-5529-4b0a-8bc5-2ab7235025e4" />












***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/bluespawn/Bluespawn.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/GoPhish.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
