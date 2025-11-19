![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)




# For the Ubuntu VM

# DNSChef

### In this lab we will

- Install and run **DNSChef** (a DNS proxy / spoofing tool)
- Observe how it **logs DNS queries**
- See how it can **spoof DNS answers** for specific domains
- Use it as a **deception tool** by pointing a domain to a fake service

---

## 1. Preparation

### 1.1 Update the system and install dependencies

```bash
sudo apt update
sudo apt install -y dnschef dnsutils python3
```

- `dnschef` – our DNS proxy / spoofer
- `dnsutils` – tools like `dig` to test DNS
- `python3` – to run a tiny web server later

> If `dnschef` is **not** found by apt, you can install it via pip:
> ```bash
> sudo apt install -y python3-pip
> sudo pip3 install dnschef
> ```

### 1.2 Create a working directory

```bash
mkdir -p ~/labs/dnschef
cd ~/labs/dnschef
```

We’ll do everything from this folder.

---

## 2. Understand your normal DNS resolution

Before using DNSChef, see what your DNS looks like normally.

### 2.1 Check where DNS queries go by default

```bash
cat /etc/resolv.conf
```

You’ll see one or more `nameserver` IPs (for example `8.8.8.8` or your router).  
That’s your current DNS resolver.

### 2.2 Resolve a domain normally

```bash
dig example.com +short
```

- Note the IP address you get.  
- This is the **legitimate** DNS answer from your normal resolver.

We’ll compare this later with the spoofed result.

---

## 3. Run DNSChef as a logging DNS proxy

First, we’ll use DNSChef to **observe** DNS traffic, without spoofing anything.

### 3.1 Start DNSChef (logging only)

Open **Terminal 1** and run:

```bash
sudo dnschef --interface 0.0.0.0 --nameserver 8.8.8.8
```

Explanation:

- `--interface 0.0.0.0` – listen on all interfaces (port 53/UDP by default)
- `--nameserver 8.8.8.8` – forward all queries to Google DNS, without changes

You should see DNSChef starting and waiting for queries. Keep this terminal open.

### 3.2 Send queries to DNSChef

Open **Terminal 2** and run:

```bash
dig @127.0.0.1 www.google.com
dig @127.0.0.1 example.com
dig @127.0.0.1 www.wikipedia.org
```

- `@127.0.0.1` tells `dig` to use DNSChef (listening on localhost) as the DNS server.

Watch **Terminal 1** (DNSChef):

- You should see logs of each query being made and the response from upstream.
- This is what a defender/analyst would see when monitoring DNS traffic.

You can stop DNSChef with `Ctrl + C` in Terminal 1.  
We’ll restart it in the next steps with spoofing enabled.

---

## 4. Simple DNS spoofing (fake IP for all domains)

Now let’s use DNSChef to **lie** about where domains point to.

We’ll make **every** DNS query resolve to the same IP.  
For demonstration, we’ll use `127.0.0.1` (your own machine).

### 4.1 Start DNSChef with global IP spoofing

In **Terminal 1**:

```bash
sudo dnschef --interface 0.0.0.0 --fakeip 127.0.0.1
```

- `--fakeip 127.0.0.1` – return `127.0.0.1` for **all A-record (IPv4)** DNS queries.
- No upstream DNS server is specified now – DNSChef always responds with the fake IP.

### 4.2 Test spoofing with dig

In **Terminal 2**:

```bash
dig @127.0.0.1 example.com +short
dig @127.0.0.1 www.google.com +short
dig @127.0.0.1 anyrandomdomainthatdoesnotexist123.com +short
```

You should see that all of them return:

```text
127.0.0.1
```

From the attacker perspective:

- Any client using this DNS server will be redirected to **your** IP.

From the defender/deception perspective:

- You can point malware or suspicious hosts to a **sinkhole** IP where you log or analyze them.

Stop DNSChef with `Ctrl + C` in Terminal 1 when you’re done.

---

## 5. Targeted spoofing of a single domain (with upstream passthrough)

Global spoofing is noisy and easy to detect.  
A more realistic use case is to **spoof only one domain** and let others resolve normally.

### Scenario

- Only `login.badbank.test` should be spoofed to a fake IP (our machine).
- All other domains should resolve via a real DNS server (e.g. `8.8.8.8`).

### 5.1 Start DNSChef with selective spoofing

In **Terminal 1**:

```bash
sudo dnschef \
  --interface 0.0.0.0 \
  --nameserver 8.8.8.8 \
  --fakeip 127.0.0.1 \
  --fakedomains login.badbank.test
```

Explanation:

- `--fakeip 127.0.0.1` – fake IP to return
- `--fakedomains login.badbank.test` – spoof **only** this domain
- `--nameserver 8.8.8.8` – use Google DNS for all other domains (pass-through)

### 5.2 Test the spoofed domain vs normal domains

In **Terminal 2**:

```bash
# Spoofed domain
dig @127.0.0.1 login.badbank.test +short

# Normal domains (pass-through to real DNS)
dig @127.0.0.1 example.com +short
dig @127.0.0.1 www.google.com +short
```

- `login.badbank.test` should resolve to `127.0.0.1`.
- Other domains should resolve to their **real IP addresses** (similar to your earlier tests).

This demonstrates:

- A precise **phishing/MitM** scenario (attacker view).
- A **controlled redirection** to a decoy/sinkhole (defender/deception view).

Keep DNSChef running for the next step.

---

## 6. Deception: Point a domain to a fake web page

To make the deception visible, we’ll serve a fake webpage on `127.0.0.1` and see how the spoofed domain points to it.

### 6.1 Create a fake “bank” page

Still in `~/labs/dnschef`:

```bash
cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Fake Bank Portal</title>
</head>
<body>
    <h1>Welcome to BadBank</h1>
    <p><b>Warning:</b> You are on a deceptive DNS training page.</p>
    <p>All activity here is part of a cybersecurity lab.</p>
</body>
</html>
EOF
```

### 6.2 Start a simple HTTP server

In **Terminal 3** (new terminal):

```bash
cd ~/labs/dnschef
python3 -m http.server 8080
```

- This serves `index.html` on `http://127.0.0.1:8080/`.

You can confirm locally:

```bash
curl http://127.0.0.1:8080/
```

You should see the HTML content.

### 6.3 “Visit” the fake bank via the spoofed DNS name

We already force `login.badbank.test` to `127.0.0.1`.  
Now let’s request a page **using that hostname**.

In **Terminal 2**:

```bash
curl http://login.badbank.test:8080/
```

- Even though `login.badbank.test` is a fake domain, DNSChef resolves it to `127.0.0.1`.
- The browser/`curl` connects to your local web server and shows the **fake bank** page.

You’ve just:

- Used **DNS spoofing** to redirect a domain to your machine.
- Simulated a **phishing / credential-harvesting** scenario (if this were a real phishing site).
- Demonstrated a **deception environment** (fake service behind a controlled DNS mapping).

Check **Terminal 1** (DNSChef) and **Terminal 3** (HTTP server) to see logs for this request.

---

## 7. Clean up

Stop all components:

- In **Terminal 1**: press `Ctrl + C` to stop DNSChef.
- In **Terminal 3**: press `Ctrl + C` to stop the Python web server.











***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/FakeNet-NG.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/RITA_ADHD/RITA.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
