![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)


# For the Ubuntu VM


# OpenCanary 

**Goal:** Deploy a simple **OpenCanary** honeypot, trigger a few attacks (port scan, **SSH/SMB probe**, simple **HTTP request**), and observe **alerts**

---

# Setup

- Go to its directory

```bash
cd ~/Desktop/openCanary
```

- Activate the **Virtual Environment**
```bash
source env/bin/activate
```

### Create and edit the config
Still inside your virtualenv:

- Create the default config (this prints the location)
```bash
opencanaryd --copyconfig
```

<img width="1920" height="105" alt="image" src="https://github.com/user-attachments/assets/63632a27-543b-44e9-92c9-7752d08d8cd5" />

- Make sure it is there

```bash
sudo ls -l /etc/opencanaryd/opencanary.conf
```

<img width="676" height="28" alt="image" src="https://github.com/user-attachments/assets/02663032-15a1-4636-8bf4-f47d013dd317" />


- Now open the config and make small edits. Example uses `nano` (or `vi`):

```bash
sudo nano /etc/opencanaryd/opencanary.conf
```

- Inside the JSON config make these **minimal** changes to enable a few services and a log file:

1. Locate the `"device.node_id"` and set a friendly name  

<img width="330" height="30" alt="image" src="https://github.com/user-attachments/assets/a6c1293c-c846-40dd-a163-622f4b9d39b7" />


2. In the `"logger"` section make sure there is a `file` part under `handlers` and set a path like `/var/log/opencanary.log`

<img width="426" height="193" alt="image" src="https://github.com/user-attachments/assets/cddf72a1-c116-498a-85a2-0641a672052b" />

3. In the `"modules"` (or top-level service entries) enable the following:

```json
"ssh": {"enabled": true},
"ssh": {"port": 222},
"http": {"enabled": true},
"http": {"port": 8082},
"ftp": {"enabled": false},
"smb": {"enabled": true},
"portscan": {"enabled": true}
```

<img width="214" height="28" alt="image" src="https://github.com/user-attachments/assets/f117736a-64b7-4015-a3d7-d31cff4cc54e" />

<img width="166" height="24" alt="image" src="https://github.com/user-attachments/assets/ad2623c3-d977-4263-a284-3f663d20f62d" />

<img width="214" height="30" alt="image" src="https://github.com/user-attachments/assets/44f81b20-b793-4396-8d94-12ec76e7bf89" />

<img width="231" height="28" alt="image" src="https://github.com/user-attachments/assets/7249cdca-f315-474b-af08-b21c3e54f568" />

<img width="231" height="28" alt="image" src="https://github.com/user-attachments/assets/35cfb47e-e3ee-49a8-9ac8-3f7889bfc955" />

<img width="214" height="28" alt="image" src="https://github.com/user-attachments/assets/c535dde2-fd4e-4a70-91c9-6afe0c04b4b7" />

<img width="231" height="28" alt="image" src="https://github.com/user-attachments/assets/bc2a9520-e551-44a8-9bdd-f0d5d64782f7" />


- Save and exit with `Ctrl + x` and `y` and `Enter`


---

## Start

- Run it

>[!NOTE]
> Make sure you are in **~/Desktop/openCanary** with **venv** activated

```bash
opencanaryd --start
# To stop:
opencanaryd --stop
```

- If you configured file logging as above, check the log:

```bash
sudo tail -n 50 /var/log/opencanary.log
```

<img width="1920" height="804" alt="image" src="https://github.com/user-attachments/assets/d2cf3738-0bd5-483f-9355-17d5b261a086" />

---

## Simple attacker 
Perform these actions from a second terminal (or another device on the same network). Replace `<CANARY_IP>` with the IP address of the VM.

1. Port scan (nmap)
```bash
sudo nmap -sS -Pn -p 222,8082 localhost
```

<img width="139" height="74" alt="image" src="https://github.com/user-attachments/assets/303a017f-520f-4032-94bf-5a34548067f5" />


- **OpenCanary's** `portscan` module should flag the scan, so let's check!

```bash
sudo tail -n 50 /var/log/opencanary.log
```

<img width="1920" height="126" alt="image" src="https://github.com/user-attachments/assets/f07186ed-337b-4f92-b620-abaed7a41aab" />

BOOM!

2. SSH probe (attempt to connect)
```bash
ssh -o ConnectTimeout=5 fakeuser@localhost
```
This triggers the `ssh` canary

3. HTTP request
```bash
curl -I http://localhost/
```
This triggers the `http` canary logs

4. SMB enum
```bash
smbclient -L localhost -N
```

- After each action, check the canary log or journal on the honeypot host to see alerts:

```bash
sudo tail -n 50 /var/log/opencanary.log
```



***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/Beelzebub.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/HoneyPorts/HoneyPorts.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
