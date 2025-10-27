# For the Ubuntu VM

### In this lab we will
- Observe how it captures malicious connection attempts
- View logs and captured malware samples
- Understand its modular architecture

# Let's start

- Open up a terminal if you are not using **SSH**

- Go the Dionaea's directory

```bash
cd ~/Desktop/dionaea
```

 - Start it up:
```bash
sudo dionaea
```

<img width="1526" height="472" alt="image" src="https://github.com/user-attachments/assets/2aa46b95-be12-4086-8efd-f4721b27861b" />

<br>

Let's see it's true power, see what ports it is listening on:
```bash
sudo netstat -tulnp | grep dionaea
```

<img width="1023" height="772" alt="image" src="https://github.com/user-attachments/assets/8e01732a-c6d4-4ee9-8fdb-123875bab14f" />

We can see it's listening on lots of ports (FTP, HTTP, SMB, MONGO, MSSQL, SIP, and more)

Let's simulate and FTP bruteforce attack
```bash
sudo apt install -y hydra
```
```bash
curl -LO https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt
```
- On another terminal tail the logs:
```bash
sudo tail -f /usr/local/var/log/dionaea/dionaea.log
```

- Then on the first terminal

```bash
hydra -l admin -P rockyou.txt localhost ftp -V
```
We can see all perspectives, the one of the attacker, it is saying that it found passwords, despite it being false to simulate a vulnerable service
<img width="1141" height="900" alt="image" src="https://github.com/user-attachments/assets/8cfc1445-67d6-456d-ae6b-a2d21ff03c95" />

<br><br>

And the one of the SOC Analyst, where we see the logs and the credentials used
<img width="1849" height="952" alt="image" src="https://github.com/user-attachments/assets/6dfa629a-207e-4927-a948-3dd2cab8621b" />
<br><br>

Now let's try with mysql instead of ftp:

```bash
hydra -l root -P rockyou.txt localhost mysql
``` 
- Same fake success
<img width="1136" height="316" alt="image" src="https://github.com/user-attachments/assets/5bace506-799f-4378-8c6f-994580d05208" />
<br><br>

You can also try to insert malware, **Dionaea** saves it at `/usr/local/var/lib/dionaea/binaries/`
```bash
curl -T sample.exe ftp://localhost --user admin:123456
```

What about **Command Injection**?
```bash
curl "http://localhost/index.php?cmd=ls"
```

For each of those commands try to understand the logs

Let's try an agressive port scan using **nmap**
```bash
nmap -A localhost
```

## Final thoughts
Dionaea’s true power comes from its purpose-built design as an intelligent malware-catching honeypot — not just a passive listener, but a smart, low-interaction trap

Most important features
- Smart Protocol Emulation
- Binary Capture Engine
- Integrated SQLite Logging
- Wide Protocol Coverage
- Python + C Plugin Architecture
- Visual and Analytical Integration

---
[Back to the Section](/courseFiles/Section_08-deceptionSystems/deceptionSystems.md)

