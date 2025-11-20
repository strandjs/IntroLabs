<img width="134" height="127" alt="image" src="https://github.com/user-attachments/assets/fcc24631-7609-4983-bab0-08f0ae996aef" />![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)




# For the Ubuntu VM

# DNSChef

### In this lab we will

- Install and run **DNSChef** (a DNS proxy / spoofing tool)
- Observe how it **logs DNS queries**
- See how it can **spoof DNS answers** for specific domains
- Use it as a **deception tool** by pointing a domain to a fake service


---

## Understand your normal DNS resolution

- Before using **DNSChef**, see what your **DNS** looks like normally.

### Check where DNS queries go by default

```bash
cat /etc/resolv.conf
```

<img width="228" height="71" alt="image" src="https://github.com/user-attachments/assets/5445c7a8-1490-468f-b654-b8b9bb60e9a6" />

- That’s your current **DNS resolver**

### Resolve a domain normally

```bash
dig example.com +short
```

<img width="134" height="127" alt="image" src="https://github.com/user-attachments/assets/48867827-ad17-4da0-9b4b-2137e21b559f" />

- Note the IP address you get
- This is the **legitimate** DNS answer from your normal resolver

- We’ll **compare** this later with the **spoofed** result

---

## Run DNSChef as a logging DNS proxy

- First, we’ll use DNSChef to **observe** DNS traffic, without spoofing anything.

### Start DNSChef (logging only)

- Open **Terminal 1** and run:

```bash
sudo python3 dnschef.py --interface 0.0.0.0 --port 53530 --nameserver 8.8.8.8
```

Explanation:

- `--interface 0.0.0.0` – listen on all interfaces
- `--nameserver 8.8.8.8` – forward all queries to Google DNS, without changes

You should see DNSChef starting and waiting for queries. Keep this terminal open

<img width="666" height="250" alt="image" src="https://github.com/user-attachments/assets/c9b338be-e84d-4e98-a6c4-15a8c784c70f" />

### Send queries to DNSChef

Open **Terminal 2** and run:

```bash
dig @127.0.0.1 -p 53530 www.google.com
dig @127.0.0.1 -p 53530 example.com
dig @127.0.0.1 -p 53530 www.wikipedia.org
```

- `@127.0.0.1` tells `dig` to use DNSChef (listening on localhost) as the DNS server

Watch **Terminal 1** (DNSChef):

- You should see **logs** of each **query** being made and the response from **upstream**
- This is what a defender/analyst would see when monitoring DNS traffic

<img width="762" height="71" alt="image" src="https://github.com/user-attachments/assets/7cf04e29-5851-4d84-8fa0-50b314c21ba7" />


- You can stop **DNSChef** with `Ctrl + C` in **Terminal 1**

- We’ll restart it in the next steps with **spoofing enabled**

---

## Simple DNS spoofing (fake IP for all domains)

- Now let’s use **DNSChef** to **lie** about where domains point to

- We’ll make **every** DNS query resolve to the same IP

- For demonstration, we’ll use `127.0.0.1` (your own machine)

### Start DNSChef with global IP spoofing

In **Terminal 1**:

```bash
sudo python3 dnschef.py --interface 0.0.0.0 --port 53530 --fakeip 127.0.0.1
```

- `--fakeip 127.0.0.1` – return `127.0.0.1` for **all A-record (IPv4)** DNS queries
- No upstream **DNS server** is specified now – **DNSChef** always responds with the fake IP

### Test spoofing with dig

In **Terminal 2**:

```bash
dig @127.0.0.1 -p 53530 example.com +short
dig @127.0.0.1 -p 53530 www.google.com +short
dig @127.0.0.1 -p 53530 anyrandomdomainthatdoesnotexist123.com +short
```

<img width="1039" height="71" alt="image" src="https://github.com/user-attachments/assets/f95e2c4f-d5f6-431c-a85d-19bd175fa631" />


You should see that all of them return:

```text
127.0.0.1
```

From the **attacker** perspective:

- Any client using this DNS server will be redirected to **your** IP

From the **defender/deception** perspective:

- You can point **malware** or suspicious hosts to a **sinkhole** IP where you log or analyze them

Stop DNSChef with `Ctrl + C` in **Terminal 1** when you’re done

---

## Targeted spoofing of a single domain (with upstream passthrough)

- Global spoofing is noisy and easy to detect

- A more realistic use case is to **spoof only one domain** and let others resolve normally.

### Scenario

- Only `login.badbank.test` should be spoofed to a fake IP (our machine).
- All other domains should resolve via a real DNS server (e.g. `8.8.8.8`).

### Start DNSChef with selective spoofing

In **Terminal 1**:

```bash
sudo python3 dnschef.py \
  --interface 0.0.0.0 \
  --port 53530 \
  --nameserver 8.8.8.8 \
  --fakeip 127.0.0.1 \
  --fakedomains login.badbank.test
```

Explanation:

- `--fakeip 127.0.0.1` – fake IP to return
- `--fakedomains login.badbank.test` – spoof **only** this domain
- `--nameserver 8.8.8.8` – use Google DNS for all other domains (pass-through)

### Test the spoofed domain vs normal domains

In **Terminal 2**:

```bash
# Spoofed domain
dig @127.0.0.1 -p 53530 login.badbank.test +short
```

```bash
# Normal domains (pass-through to real DNS)
dig @127.0.0.1 -p 53530 example.com +short
```

```bash
dig @127.0.0.1 -p 53530 www.google.com +short
```

- `login.badbank.test` should resolve to `127.0.0.1`.
- Other domains should resolve to their **real IP addresses** (similar to your earlier tests).

<img width="1039" height="71" alt="image" src="https://github.com/user-attachments/assets/1c6e8d78-b8c1-4f64-bbab-0249c4b1d0f1" />


This demonstrates:

- A precise **phishing/MitM** scenario (attacker view).
- A **controlled redirection** to a decoy/sinkhole (defender/deception view).


---


## Clean up

Stop all components:

- In **Terminal 1**: press `Ctrl + C` to stop DNSChef.
- In **Terminal 2**: press `Ctrl + C` to stop the Python web server.






***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/FakeNet-NG.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/RITA_ADHD/RITA.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
