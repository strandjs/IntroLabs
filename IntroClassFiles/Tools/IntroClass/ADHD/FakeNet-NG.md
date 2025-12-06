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

### List listening ports

```bash
sudo ss -tulnp | grep -i fakenet
```

<img width="979" height="250" alt="image" src="https://github.com/user-attachments/assets/6fbfb6fc-8cda-48fb-9e82-f1bb80680697" />


You should see FakeNet-NG listening on multiple ports, for example:
- 53 (**DNS**)
- 80 (**HTTP**)
- 443 (**HTTPS/SSL**)
- 21 (**FTP**)
- 25 (**SMTP**)
- Others depending on your version/config

> This is the **deception**: FakeNet-NG pretends to be many services at once,
> so “**malware**” thinks it is talking to the real **Internet**

---

## Simulate simple web “malware” traffic

- FakeNet-NG is still running in **terminal 1**.  

- In **terminal 2**, we’ll play the role of the “malware” sending traffic.

### HTTP request to a domain

```bash
curl http://totally-not-evil-c2.com/
```

Watch **terminal 1** (FakeNet-NG window):

- You should see a DNS query for `totally-not-evil-c2.com`
- Then an HTTP request logged by FakeNet-NG
- FakeNet-NG will return some default HTML content

<img width="938" height="40" alt="image" src="https://github.com/user-attachments/assets/5312dd38-41f0-45c7-9893-ca29679db31d" />

### HTTPS request (FakeNet as fake TLS server)

```bash
curl https://really-bad-c2.example/ -k
```

<img width="938" height="40" alt="image" src="https://github.com/user-attachments/assets/5abfe875-eb52-46a4-b483-3dc85026129e" />

---

## Simulate DNS beaconing

Let’s imitate beaconing behavior where malware repeatedly talks to random domains.

Now run:

```bash
for i in {1..5}; do
  dig @127.0.0.1 +short c2$i.super-evil-botnet.com
  sleep 1
done
```

Watch **terminal 1**:

- You should see multiple DNS queries for the fake `c2*.super-evil-botnet.com` domains
- FakeNet-NG will respond with fake IP addresses

<img width="916" height="62" alt="image" src="https://github.com/user-attachments/assets/69ef8600-3069-4cd3-b62c-73148f0fa186" />

> In a real analysis, these logs help you extract **network IOCs**
> (domains, IPs, URIs) from malware safely.

---

## Simulate a port-scanning “malware”

Now we’ll pretend the malware is scanning common service ports.

### Scan common ports on localhost

```bash
nmap -Pn -p 211,25,53,8086,1337,443,110 127.0.0.1
```

- From **nmap’s perspective** (attacker view), it will look like these ports are open
  and responding on `127.0.0.1`.

>[!Note]
> When FakeNet is active on Linux, SYN scans (-sS) often show ports as filtered.
> This happens because FakeNet intercepts packets using iptables/NFQUEUE.
> To correctly observe open ports, use a TCP connect scan:

- In **terminal 1** (FakeNet-NG), you’ll see many connection attempts logged
  against the emulated services.

<img width="503" height="144" alt="image" src="https://github.com/user-attachments/assets/bb612132-ceb7-42ed-9953-d62a6c937ab6" />


You can push it further with a more aggressive scan (optional, but noisy):

```bash
nmap -sS -p- 127.0.0.1
```

FakeNet-NG will try to keep up and emulate responses, again acting as a fake, but convincing, network.

---

## Look at captures / logs

Stop FakeNet-NG by going to **terminal 1** and pressing:

```text
Ctrl + C
```

Depending on version/config, FakeNet-NG will:

- Save a **PCAP** file with captured traffic

In the directory where you started FakeNet-NG, run:

```bash
ls
```

Look for `*.pcap` files

If you see a `.pcap` file, you can open it with Wireshark later for deeper analysis:

```bash
wireshark captured_traffic.pcap
```


***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/canarytokens/Canarytokens.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/DNSChef.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
