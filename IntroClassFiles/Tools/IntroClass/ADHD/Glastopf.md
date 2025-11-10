![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# For the Ubuntu VM

# Glastopf

**Goal:** Run a working Glastopf web-application honeypot, generate simple attacks against it, and inspect captured requests and payloads

---

### Start Glastopf container

- Go the its directory

```bash
cd ~/Desktop/glastopf/
```

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

<img width="1100" height="42" alt="image" src="https://github.com/user-attachments/assets/ca94b522-4f94-420d-b6f0-f481d89b32c5" />


- Tail the main **log**

```bash
sudo docker logs -f glastopf
```

<img width="1141" height="93" alt="image" src="https://github.com/user-attachments/assets/7193287c-5001-4b00-8035-ea5882c804c4" />

---

## Generate attacks 

- Open another **terminal** (attacker) and try the following. These simulate common web malicious requests.

### Simple directory traversal / LFI attempts

```bash
curl -v "http://localhost:8080/index.php?page=../../etc/passwd"
```
```bash
curl -v "http://localhost:8080/?file=../boot.ini"
```

- This is how it looks from a **hacker**'s perspective(**fake information**)

<img width="1100" height="1051" alt="image" src="https://github.com/user-attachments/assets/f19f992e-2178-4c52-889c-c6e11d3fd629" />


<img width="1100" height="943" alt="image" src="https://github.com/user-attachments/assets/e87529c9-9bc6-4edd-b6ca-82ceb4db22be" />

- When in reality, all that is **fake** and it is being logged on the **defender**'s side:

<img width="1165" height="46" alt="image" src="https://github.com/user-attachments/assets/e2975e19-3c0e-4f63-9582-69a712fab5c1" />

### SQL injection-like payloads

```bash
curl -v "http://localhost:8080/search.php?q=1%27%20UNION%20SELECT%20NULL--"
```

- Look at the **fake information** and then back to see how it has been **logged** on the **defender**'s terminal

### Remote command injection attempts

```bash
curl -v "http://localhost:8080/?cmd=whoami"
curl -v "http://localhost:8080/?cmd=;id"
```

### Use automated scanners

Install basic testing tools and run quick scans against `localhost`.

```bash
nikto -h http://localhost:8080
sqlmap -u "http://localhost:8080/index.php?id=1" --batch --level=1
```

> Each of the above requests are recorded by **Glastopf** and should show up in **logs** and the event store.



***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/ModSecurity.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/webhoneypot/webhoneypot.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
