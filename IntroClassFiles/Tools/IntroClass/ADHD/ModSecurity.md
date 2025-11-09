![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# For the Ubuntu VM

# ModSecurity 

**Goal:** Install **ModSecurity** (with Apache) and perform simple hands‑on detections and blocks (XSS, SQLi, command injection), view logs, and write a simple custom rule

---

## Lab overview
- Install Apache and ModSecurity (libapache2-mod-security2)
- Install OWASP CRS (Core Rule Set)
- Enable ModSecurity (Detection/Prevention mode)
- Test attacks with `curl` (XSS, SQLi, command injection)
- Inspect audit logs and Apache logs
- Create a simple custom rule to block a pattern
- Toggle rule states and observe behavior

---

## Step 0 — Open a terminal
If you're remote, use SSH. This lab uses `localhost` (the VM itself).

---

## Step 1 — Update and install Apache + tools
```bash
sudo apt update
sudo apt install -y apache2 curl git nano
```

Start and enable Apache:
```bash
sudo systemctl enable --now apache2
sudo systemctl status apache2 --no-pager
```

Check Apache is serving:
```bash
curl -I http://localhost
# Expected: HTTP/1.1 200 OK (or 302), and a Server header with Apache
```

---

## Install ModSecurity (libapache2-mod-security2)
```bash
sudo apt install -y libapache2-mod-security2
```

Confirm module installed:
```bash
apachectl -M | grep security
# you should see: security2_module (shared)
```

The default configuration file lives at: `/etc/modsecurity/modsecurity.conf-recommended`
Copy and enable a basic config:
```bash
sudo cp /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf
```

Edit the config to enable the engine and set log locations (we'll use defaults). Ensure `SecRuleEngine` is set to `DetectionOnly` initially:
```bash
sudo sed -i "s/SecRuleEngine DetectionOnly/SecRuleEngine DetectionOnly/" /etc/modsecurity/modsecurity.conf
# (if it was set to 'On' change as needed). Open to inspect:
sudo nano /etc/modsecurity/modsecurity.conf
```

Important lines to check:
- `SecRuleEngine DetectionOnly` — detects but does not block.
- `SecAuditLog` — path to the audit log (usually `/var/log/apache2/modsec_audit.log`).

Restart Apache:
```bash
sudo systemctl restart apache2
```

---

## Install OWASP ModSecurity Core Rule Set (CRS)
CRS provides many working detection rules (XSS, SQLi, RCE patterns).

```bash
cd /tmp
sudo git clone https://github.com/coreruleset/coreruleset.git
sudo mkdir -p /usr/share/modsecurity-crs
sudo cp -r coreruleset/* /usr/share/modsecurity-crs/
```

Copy the recommended setup:
```bash
sudo cp /usr/share/modsecurity-crs/crs-setup.conf.example /usr/share/modsecurity-crs/crs-setup.conf
```

Enable CRS in Apache ModSecurity configuration by creating a small include file:

```bash
sudo bash -c 'cat > /etc/apache2/mods-enabled/security2.conf <<EOF
<IfModule security2_module>
    IncludeOptional /usr/share/modsecurity-crs/crs-setup.conf
    IncludeOptional /usr/share/modsecurity-crs/rules/*.conf
</IfModule>
EOF'
```

Reload Apache:
```bash
sudo systemctl restart apache2
```

---

## SConfirm ModSecurity is running
Check Apache error log for ModSecurity startup messages:
```bash
sudo tail -n 200 /var/log/apache2/error.log
```

Check the audit log file exists (may be empty initially):
```bash
ls -l /var/log/apache2/modsec_audit.log || ls -l /var/log/modsec_audit.log
```

---

## Step 5 — Simple detection tests (DetectionOnly mode)
With `SecRuleEngine DetectionOnly` ModSecurity will log but not block.

### 5.1 XSS test (reflected)
```bash
curl -v "http://localhost/?q=<script>alert(1)</script>" -s -o /dev/null
```
Now tail the audit log (open another terminal or background `tail -f`):
```bash
sudo tail -n 120 /var/log/apache2/modsec_audit.log
```
Look for entries mentioning `XSS` or `Cross-Site Scripting` or rule ids from CRS (e.g., 942100-ish). The entry contains the matched request and relevant rule id.

### 5.2 SQL Injection test
```bash
curl -v "http://localhost/?id=1%20OR%201=1" -s -o /dev/null
sudo tail -n 120 /var/log/apache2/modsec_audit.log
```

### 5.3 Command injection-like input
```bash
curl -v "http://localhost/?cmd=|ls" -s -o /dev/null
sudo tail -n 120 /var/log/apache2/modsec_audit.log
```

Each curl should create ModSecurity audit events. Study the audit log format: it is split into sections (`--A--`, `--B--`, etc.) with request, response, and matched rule details.

---

## Switch to prevention mode (blocking)
Now turn ModSecurity into blocking mode.

**Important:** On some rules and setups enabling blocking will return `403` for many requests. This is expected — we want to see blocking.

Edit the config:
```bash
sudo sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/modsecurity/modsecurity.conf
sudo systemctl restart apache2
```

Test the same payloads:

```bash
curl -v "http://localhost/?q=<script>alert(1)</script>" -s -o /dev/null -w "%{http_code}\n"
# Expected: 403 (or another non-200)
```

```bash
curl -v "http://localhost/?id=1%20OR%201=1" -s -o /dev/null -w "%{http_code}\n"
```

Review the audit log and Apache error log for blocked events:
```bash
sudo tail -n 120 /var/log/apache2/modsec_audit.log
sudo tail -n 200 /var/log/apache2/error.log
```

---

## Create a simple custom rule
Create a local rules file to block a simple string like `ATTACK-LAB` for demonstration.

```bash
sudo mkdir -p /etc/modsecurity/custom-rules
sudo bash -c 'cat > /etc/modsecurity/custom-rules/900900-block-attacklab.conf <<EOF
# Custom demonstration rule: block requests containing ATTACK-LAB
SecRule REQUEST_URI|ARGS "@contains ATTACK-LAB" \
    "id:900900,phase:2,deny,log,msg:'Blocked ATTACK-LAB test string',severity:2"
EOF'
```

Include this custom rules folder by adding to `security2.conf` or `modsecurity.conf`:
```bash
sudo sed -i '/IncludeOptional \/usr\/share\/modsecurity-crs\/rules\/*/a \    IncludeOptional /etc/modsecurity/custom-rules/*.conf' /etc/apache2/mods-enabled/security2.conf
sudo systemctl restart apache2
```

Test it:
```bash
curl -v "http://localhost/?test=ATTACK-LAB" -s -o /dev/null -w "%{http_code}\n"
# Expected: 403 and an audit log entry with id 900900
sudo tail -n 80 /var/log/apache2/modsec_audit.log
```

---

## Toggle rule to DetectionOnly (ignore/block)
If you want to test without blocking, you can change the action from `deny` to `log` or set SecRuleEngine back to `DetectionOnly`.

Example: edit file and change `deny` to `log`:
```bash
sudo sed -i "s/deny/log/" /etc/modsecurity/custom-rules/900900-block-attacklab.conf
sudo systemctl restart apache2
curl -v "http://localhost/?test=ATTACK-LAB" -s -o /dev/null -w "%{http_code}\n"
sudo tail -n 80 /var/log/apache2/modsec_audit.log
```

---

## Whitelisting a safe path (disabling CRS for a specific location)
You might want to exclude a path from CRS rules (e.g., `/health` endpoint). Add a rule to disable checking for that path.

Create an exclusion file:
```bash
sudo bash -c 'cat > /etc/modsecurity/custom-rules/900910-whitelist-health.conf <<EOF
# Disable CRS for /health
SecRule REQUEST_URI "@beginsWith /health" "id:900910,phase:1,pass,nolog,ctl:ruleEngine=DetectionOnly"
EOF'
sudo systemctl restart apache2
```

Test:
```bash
curl -v "http://localhost/health?q=<script>alert(1)</script>" -s -o /dev/null -w "%{http_code}\n"
# Should not be blocked if whitelist works (200)
```

---

## Useful file locations
- Main config: `/etc/modsecurity/modsecurity.conf`
- Apache include: `/etc/apache2/mods-enabled/security2.conf`
- CRS rules: `/usr/share/modsecurity-crs/rules/`
- CRS setup: `/usr/share/modsecurity-crs/crs-setup.conf`
- Audit log: `/var/log/apache2/modsec_audit.log` (or `/var/log/modsec_audit.log`)
- Apache error log: `/var/log/apache2/error.log`
- Custom rules: `/etc/modsecurity/custom-rules/`


---

## Clean up (optional)
To return the machine to pre‑lab state:
```bash
sudo systemctl stop apache2
sudo apt remove --purge -y libapache2-mod-security2
sudo apt autoremove -y
sudo rm -rf /usr/share/modsecurity-crs /etc/modsecurity/custom-rules
```




***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/Haraka.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/Glastopf.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
