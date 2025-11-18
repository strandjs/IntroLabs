![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)


# For the Ubuntu VM

# Haraka 

**Goal:** Build a simple, completely hands‑on Haraka (Node.js SMTP) lab that demonstrates SMTP interaction and emphasizes *cyber deception* by using the `tarpit` plugin to slow and frustrate attackers. Steps are step‑by‑step commands so anyone can follow.

---

# Start

- Open a **terminal**

- Go to the lab directory and make sure **Haraka** is set up

```bash
cd ~/Desktop/haraka
```

```bash
haraka -i .
```

```bash
ls -la
```

<img width="531" height="185" alt="image" src="https://github.com/user-attachments/assets/cde6a428-b452-4f14-a59f-efdf6bbc5edb" />


- You now have a **Haraka** instance with `config/`, `plugins/`, etc.

---

## Configure Haraka for tarpit deception

1. Set **Haraka** to listen on **port 2525**. Edit `config/smtp.ini`:

```bash
nano config/smtp.ini
```

- Add at the end:

```ini
listen=0.0.0.0:2525
```

- To exit and save the file do `Ctrl + x` and `y` and `Enter`

2. Enable a tiny **HTTP endpoint** for live observation. Create `config/http.ini`:

```bash
nano config/http.ini
```

```ini
listen=0.0.0.0:8080
```

- To exit and save the file do `Ctrl + x` and `y` and `Enter`

3. Edit `config/plugins` so it contains these lines (order matters - keep `tarpit` early):

```bash
rm config/plugins
```

```bash
nano config/plugins
```

- Paste the following:

```
tarpit
access
helo.checks
recipient
rcpt_to.in_host_list
queue/smtp_forward
save_msg
watch
```

- To exit and save the file do `Ctrl + x` and `y` and `Enter`

* `tarpit` will slow connections (deception).
* `watch` gives a basic web UI at `http://localhost:8080/watch/`.
* `save_msg` (we will add next) stores message files for analysis.

---

## Add a simple message‑saving plugin

- Create `plugins/save_msg.js` with this content. It writes received messages to `logs/msgs/`:

```bash
nano plugins/save_msg.js
```

- Paste the following:

```javascript
// plugins/save_msg.js
exports.hook_data = function (next, connection) {
    const txn = connection.transaction;
    txn.parse_body_stream(function (err, body) {
        if (err) return next(DENYSOFT, 'failed to parse body');
        const fs = require('fs');
        const path = require('path');
        const outdir = path.join(__dirname, '..', 'logs', 'msgs');
        fs.mkdirSync(outdir, { recursive: true });
        const fname = path.join(outdir, Date.now() + '-' + Math.floor(Math.random()*10000) + '.eml');
        const content = 'From: ' + txn.mail_from.original + '
' + 'To: ' + txn.rcpt_to.map(r=>r.original).join(',') + '

' + body;
        fs.writeFileSync(fname, content);
        connection.loginfo(this, 'saved message to ' + fname);
        next();
    });
};
```

- To exit and save the file do `Ctrl + x` and `y` and `Enter`

- Make the plugin executable:

```bash
chmod 644 plugins/save_msg.js
```

---

## Tarpit configuration

- Create `config/tarpit.ini` to customize tarpit behavior. Example (conservative delays):

```bash
nano config/tarpit.ini
```

- Paste the following:

```ini
# config/tarpit.ini
# base delay in seconds
base_delay=2
# random extra delay (0..n seconds)
rand_delay=3
# apply to all connections
enabled=1
```


- To exit and save the file do `Ctrl + x` and `y` and `Enter`

- You can increase `base_delay` and `rand_delay` to make attacks slower during demonstrations

---

## Start Haraka and confirm it is listening

```bash
# start in foreground to see logs
cd ~/haraka-lab
haraka -c .

# or background it
nohup haraka -c . > haraka.out 2>&1 &

# check listen port
ss -ltnp | grep 2525
```

If using background mode, check `tail -f haraka.out` for live logs.

---

## 7) Observe the Watch UI

Open a browser to:

```
http://localhost:8080/watch/
```

It displays active SMTP connections and commands so you can watch how `tarpit` affects interaction.

If you don't have a browser, `curl http://localhost:8080/watch/` will show a response.

---

## 8) Simulate attacker behavior and observe tarpit

### 8a) Manual SMTP session (telnet / netcat)

```bash
nc localhost 2525
# then type:
HELO attacker.example.com
MAIL FROM:<evil@attacker.test>
RCPT TO:<victim@localhost>
DATA
Subject: test tarpit

This is a tarpit test.
.
QUIT
```

Watch the logs or the Watch UI. Connections will be slower depending on `tarpit.ini` settings.

### 8b) Scripted load with `swaks`

Install `swaks` and run a burst of messages to demonstrate delayed responses:

```bash
sudo apt install -y swaks

# single message
swaks --server localhost:2525 --from attacker@evil.test --to victim@localhost --data "Subject: swaks test

hello"

# rapid loop to show tarpit effect
for i in {1..8}; do
  swaks --server localhost:2525 --from t$i@x.test --to victim@localhost --data "Subject: loop $i

hello $i" &
done
```

Because `tarpit` intentionally delays responses, the loop will take noticeably longer than without tarpit. Observe connection times in `haraka.out` or the Watch UI.

---

## 9) Demonstrate attacker frustration (timing comparison)

1. Stop Haraka and set `base_delay=0` and `rand_delay=0` in `config/tarpit.ini` (or temporarily remove `tarpit` from `config/plugins`) and restart Haraka.
2. Run the same `swaks` loop and measure how long it takes:

```bash
time bash -c 'for i in {1..8}; do swaks --server localhost:2525 --from t$i@x.test --to victim@localhost --data "Subject: quick $i

ok" & done; wait'
```

3. Re-enable tarpit (set delays back) and run the same `time` command again. The second run should take longer - this demonstrates the deceptive slowdown.

---

## 10) Inspect captured messages and logs

```bash
ls -la logs/msgs
cat logs/msgs/*.eml | sed -n '1,200p'

# if backgrounded
tail -n 200 haraka.out
```

`save_msg` files contain basic headers and the message body for analysis.

---

## 11) Clean up

```bash
# stop background Haraka
pkill -f "haraka -c"
# remove lab folder carefully
rm -rf ~/haraka-lab
```













***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/dionaea.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/ModSecurity.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
