![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# For the Ubuntu VM

# Glastopf

**Goal:** Run a working Glastopf web-application honeypot, generate simple attacks against it, and inspect captured requests and payloads. This lab uses simple commands so anyone can follow along.

---

### Start Glastopf container

```bash
sudo docker run -d --rm \
  --name glastopf \
  -p 8080:80 \
  -v $(pwd)/data:/var/lib/glastopf \
  -v $(pwd)/logs:/var/log/glastopf \
  decepot/glastopf:latest
```

---

### Verify Glastopf is running and listening

Open a new terminal on the same machine and run:

```bash
# Check process or Docker container
ps aux | grep glastopf
```

<img width="1091" height="52" alt="image" src="https://github.com/user-attachments/assets/0fe7e604-bf1a-47d4-8d3e-87d9b57893bb" />

- Tail the main **log**

```bash
sudo docker logs -f glastopf
```

<img width="1141" height="93" alt="image" src="https://github.com/user-attachments/assets/7193287c-5001-4b00-8035-ea5882c804c4" />

---

## Generate attacks 

- Open another terminal (attacker) and try the following. These simulate common web malicious requests.

### Simple directory traversal / LFI attempts

```bash
curl -v "http://localhost/index.php?page=../../etc/passwd"
curl -v "http://localhost/?file=../boot.ini"
```

### SQL injection-like payloads

```bash
curl -v "http://localhost/products.php?id=1' OR '1'='1"
curl -v "http://localhost/search.php?q=1%27%20UNION%20SELECT%20NULL--"
```

### Remote command injection attempts

```bash
curl -v "http://localhost/?cmd=whoami"
curl -v "http://localhost/?cmd=;id"
```

### Use automated scanners

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
