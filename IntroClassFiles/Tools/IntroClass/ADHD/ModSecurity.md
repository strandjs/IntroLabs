![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# For the Ubuntu VM

# ModSecurity 

**Goal:** Install **ModSecurity** (with Apache) and perform simple hands‑on detections and blocks (XSS, SQLi, command injection), view logs, and write a simple custom rule


>[!NOTE]
>Apache is running on port 8083 on the machine

---

## Lab overview
- Install OWASP CRS (Core Rule Set)
- Enable ModSecurity (Detection/Prevention mode)
- Test attacks with `curl` (XSS, SQLi, command injection)
- Inspect audit logs and Apache logs
- Create a simple custom rule to block a pattern
- Toggle rule states and observe behavior

---

# Start

- Start and enable Apache:
```bash
sudo systemctl enable --now apache2
sudo systemctl status apache2 --no-pager
```

- Check Apache is serving:
```bash
curl -I http://localhost:8083
```

<img width="410" height="186" alt="image" src="https://github.com/user-attachments/assets/6959fa36-fbfe-47e0-873e-fa373aa89ef4" />

>[!IMPORTANT]
>ModSecurity is already installed for this lab

- Confirm module installed:
```bash
apachectl -M | grep security
```

<img width="256" height="27" alt="image" src="https://github.com/user-attachments/assets/02f79861-bb5b-49dd-9a04-f1d8f3609177" />


- The default configuration file lives at: `/etc/modsecurity/modsecurity.conf-recommended`

- We are using the basic config: `/etc/modsecurity/modsecurity.conf`

- Edit the config to **enable** the **engine** and set **log** locations (we'll use defaults). Ensure `SecRuleEngine` is set to `DetectionOnly` initially:
```bash
sudo sed -i "s/SecRuleEngine DetectionOnly/SecRuleEngine DetectionOnly/" /etc/modsecurity/modsecurity.conf
# (if it was set to 'On' change as needed). Open to inspect:
sudo nano /etc/modsecurity/modsecurity.conf
```

- Important lines to check:
- `SecRuleEngine DetectionOnly` — detects but does not block
- `SecAuditLog` — path to the audit log (usually `/var/log/apache2/modsec_audit.log`)

<img width="260" height="32" alt="image" src="https://github.com/user-attachments/assets/cfe24f08-0857-4790-9b10-1e0d96431e18" />

<img width="426" height="27" alt="image" src="https://github.com/user-attachments/assets/719fcdbc-69d9-4a60-9490-7903687253ad" />


- Restart Apache:
```bash
sudo systemctl restart apache2
```

---

## Install OWASP Core Rule Set (v3.3.5)
```bash
cd /tmp
sudo rm -rf /usr/share/modsecurity-crs
sudo git clone --branch v3.3.5 --depth 1 https://github.com/coreruleset/coreruleset.git
sudo mkdir -p /usr/share/modsecurity-crs
sudo cp -r coreruleset/* /usr/share/modsecurity-crs/
sudo cp /usr/share/modsecurity-crs/crs-setup.conf.example /usr/share/modsecurity-crs/crs-setup.conf
```

---

## Enable CRS (Single Include Only)
```bash
sudo tee /etc/apache2/mods-available/security2.conf >/dev/null <<'EOF'
<IfModule security2_module>
    IncludeOptional /etc/modsecurity/modsecurity.conf
    IncludeOptional /usr/share/modsecurity-crs/crs-setup.conf
    IncludeOptional /usr/share/modsecurity-crs/rules/*.conf
    IncludeOptional /etc/modsecurity/custom-rules/*.conf
</IfModule>
EOF

sudo ln -sf /etc/apache2/mods-available/security2.conf /etc/apache2/mods-enabled/security2.conf
sudo apachectl configtest
sudo systemctl restart apache2
```

Test:
```bash
curl -I http://localhost:8083
```

<img width="466" height="191" alt="image" src="https://github.com/user-attachments/assets/6785f37a-1d51-49de-9111-c72790530d5f" />

---

## SConfirm ModSecurity is running
- Check Apache error log for ModSecurity startup messages:
```bash
sudo tail -n 200 /var/log/apache2/error.log
```

<img width="1615" height="188" alt="image" src="https://github.com/user-attachments/assets/81192191-4706-4e7d-b61d-27ddde842119" />


Check the audit log file exists (may be empty initially):
```bash
ls -l /var/log/apache2/modsec_audit.log || ls -l /var/log/modsec_audit.log
```

<img width="663" height="25" alt="image" src="https://github.com/user-attachments/assets/57d65f40-3d62-47d4-8425-3c9d5efe73d5" />


---

## Simple detection tests (DetectionOnly mode)
- With `SecRuleEngine DetectionOnly` ModSecurity will log but not block.

### XSS test (reflected)
```bash
curl -v "http://localhost:8083/?q=<script>alert(1)</script>" -s -o /dev/null
```

<img width="520" height="382" alt="image" src="https://github.com/user-attachments/assets/5abea418-3dbf-4b08-9a38-0e1e09732f79" />

- Now tail the **audit log** (open another terminal or background `tail -f`):
```bash
sudo tail -n 120 /var/log/apache2/modsec_audit.log
```

<img width="1920" height="787" alt="image" src="https://github.com/user-attachments/assets/a32dc4a8-30d1-4ac4-8c68-2e95ee522b9a" />

- **BOOM!** What is cool about **ModSecurity** is that not only does it detect attacks really well, but it also logs them extensively, as you can see, giving details about everything


### SQL Injection test
```bash
curl -v "http://localhost:8083/?id=1%20OR%201=1" -s -o /dev/null
```

```bash
sudo tail -n 120 /var/log/apache2/modsec_audit.log
```

<img width="1920" height="467" alt="image" src="https://github.com/user-attachments/assets/68fd8beb-4557-4d85-bf12-2f365c0334e0" />

### Command injection-like input
```bash
curl -v "http://localhost:8083/?cmd=|ls" -s -o /dev/null
```
```bash
sudo tail -n 120 /var/log/apache2/modsec_audit.log
```

<img width="1920" height="524" alt="image" src="https://github.com/user-attachments/assets/513e8ad9-4f3b-4c8a-836c-b6f7b5de84ee" />


- Each **curl** should create **ModSecurity** audit events. Study the audit log format: it is split into sections (`--A--`, `--B--`) with **request**, **response**, and **matched rule details**

---

## Switch to prevention mode (blocking)
- Now turn ModSecurity into blocking mode.

**Important:** On some rules and setups enabling blocking will return `403` for many requests. This is expected — we want to see blocking.

Edit the config:
```bash
sudo sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/modsecurity/modsecurity.conf
```
```bash
sudo systemctl restart apache2
```

- Test the same payloads:

```bash
curl -v "http://localhost:8083/?q=<script>alert(1)</script>" -s -o /dev/null -w "%{http_code}\n"
# Expected: 403 (or another non-200)
```

<img width="435" height="387" alt="image" src="https://github.com/user-attachments/assets/176ceeb5-26dd-4911-956b-4e833dfa0b8d" />


```bash
curl -v "http://localhost:8083/?id=1%20OR%201=1" -s -o /dev/null -w "%{http_code}\n"
```

Review the audit log and Apache error log for blocked events:
```bash
sudo tail -n 120 /var/log/apache2/modsec_audit.log
```

```bash
sudo tail -n 200 /var/log/apache2/error.log
```

<img width="1920" height="66" alt="image" src="https://github.com/user-attachments/assets/47d2e0ff-d324-4ec7-9964-bc611d258e01" />

---

## Useful file locations
- Main config: `/etc/modsecurity/modsecurity.conf`
- Apache include: `/etc/apache2/mods-enabled/security2.conf`
- CRS rules: `/usr/share/modsecurity-crs/rules/`
- CRS setup: `/usr/share/modsecurity-crs/crs-setup.conf`
- Audit log: `/var/log/apache2/modsec_audit.log` (or `/var/log/modsec_audit.log`)
- Apache error log: `/var/log/apache2/error.log`


***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/Haraka.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/Glastopf.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
