![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# n8n - Part 1 - General Automation

For **Part 2**, click [here](./n8n-part2.md)

# Ubuntu VM

## In this lab we will

- Deploy n8n using Docker with persistent storage
- Explore the n8n web interface
- Build a simple HTTP-triggered workflow
- Automate a security alert notification via webhook
- Understand how n8n can be used in a SOC context for alert routing and automation

---

> [!NOTE]
> n8n is an open-source workflow automation tool. It lets you connect apps and services together using a visual drag-and-drop editor. In a security context it is used for things like routing alerts, enriching IOCs automatically, or triggering responses based on SIEM events

---

## Step 1 - Create a Directory for n8n Data

Open a **Terminal**

<img width="50" height="54" alt="image" src="https://github.com/user-attachments/assets/181d7470-566f-444e-9463-bba59600aebd" />


n8n stores your workflows, credentials, and settings on disk. We will create a local folder and mount it into the container so your data persists even if the container is removed.

```bash
mkdir -p ~/.n8n
```

---

## Step 2 - Run n8n with Docker

Run the following command to pull and start **n8n** ( it might take a couple of minutes ):

```bash
sudo docker run -d --name n8n -p 5678:5678 -v ~/.n8n:/home/node/.n8n -e N8N_BASIC_AUTH_ACTIVE=true -e N8N_BASIC_AUTH_USER=admin -e N8N_BASIC_AUTH_PASSWORD=securepass --restart unless-stopped n8nio/n8n
```

What each flag does:

| Flag | Purpose |
|---|---|
| `-d` | Run in detached mode (background) |
| `--name n8n` | Give the container a name so you can reference it easily |
| `-p 5678:5678` | Map port 5678 on your host to port 5678 in the container |
| `-v ~/.n8n:/home/node/.n8n` | Mount your local folder into the container for persistent data |
| `-e N8N_BASIC_AUTH_*` | Enable basic auth to protect the UI |
| `--restart unless-stopped` | Auto-restart the container after reboots |

Check that the container is running:

```bash
sudo docker ps
```

<img width="1815" height="69" alt="image" src="https://github.com/user-attachments/assets/94ba4114-37fe-4586-9b1d-07ce6eb0de38" />


---

## Step 3 - Open the n8n Interface

Open your browser and go to:

```
http://localhost:5678
```

You will have to set up the owner account, fill in whatever fake information you want:

- **Email:** `admin@lab.local`
- **First Name:** `John`
- **Last Name:** `Doe`
- **Password:** `Lab12345`

<img width="440" height="657" alt="image" src="https://github.com/user-attachments/assets/e111b0d2-46f0-4adc-921d-74fb3444580f" />

You don't have to pick anything, just press **Get Started**

<img width="454" height="600" alt="image" src="https://github.com/user-attachments/assets/5f7c4d14-7e05-4afd-a7bb-0352917416ae" />





Then press **Skip**

<img width="494" height="529" alt="image" src="https://github.com/user-attachments/assets/5d35082b-22d3-42f7-ac5b-5efd2c42e285" />


Press **Build a workflow**

<img width="652" height="456" alt="image" src="https://github.com/user-attachments/assets/643b4463-52af-4b1a-a75e-fc3bee0ef1f5" />

---
## Step 4 - Open the n8n Workflow

Next we will import the n8n jason file so we can get it working.

First Select "Build a Workflow"

<img width="545" height="334" alt="image" src="https://github.com/user-attachments/assets/3a20750e-e371-49d7-b6d6-1797527e5436" />

Next, select the tree dots in the upper right hand corner.

<img width="387" height="321" alt="image" src="https://github.com/user-attachments/assets/3bb7878c-8b9e-4974-9a20-f36a4f27747a" />

Next, select "Import From URL"

<img width="381" height="448" alt="image" src="https://github.com/user-attachments/assets/ac36cc59-f98d-4f04-b267-bb126661febb" />

Next, put in the following URL.

`https://raw.githubusercontent.com/strandjs/IntroLabs/refs/heads/master/n8n_internetdb_openai_ip_report.json`


<img width="467" height="255" alt="image" src="https://github.com/user-attachments/assets/4fa32201-ece7-4574-965d-0da9fd901c7a" />

It should create the following workflow:

<img width="1438" height="219" alt="image" src="https://github.com/user-attachments/assets/bd64facd-152d-4a29-a172-959f08f419bf" />

Next, let's open another terminal.

<img width="67" height="72" alt="image" src="https://github.com/user-attachments/assets/bd7857d8-da24-4ec7-8292-29fb3b2f03bd" />

Now, let's get a terminal on the Docker instance:

`sudo su -`

`docker exec -it n8n /bin/sh`

<img width="548" height="159" alt="image" src="https://github.com/user-attachments/assets/0450eed5-78af-48d5-9435-56f0eed7e4c7" />

Now we are going to create a file with ip addresses to review in it.

<img width="318" height="115" alt="image" src="https://github.com/user-attachments/assets/d015a9ac-7697-4660-85cc-b1e502019efa" />

`cd /home/node/`
`mkdir .n8n-files`
`cd .n8n-files/`
`vi ips.txt`

Press 'a' to add data to the file.

Then paste the following:

`ip
77.90.185.20
195.178.110.137
2.57.121.25
94.154.43.230
8.8.8.8
8.8.9.9`

It should look like this:

<img width="175" height="178" alt="image" src="https://github.com/user-attachments/assets/cec61244-b769-4307-923b-e94885fb9c10" />


<img width="163" height="30" alt="image" src="https://github.com/user-attachments/assets/b90910a7-fde2-4919-b16f-7084fdaac273" />

Press esc

Next press `:`

then `wq!`

Then Enter

Now, go back into n8n and select Configuration

Put `/home/node/.n8n-files/ips.txt` in the Input File field

<img width="385" height="132" alt="image" src="https://github.com/user-attachments/assets/e5757232-e127-43e3-87ce-2b5076d0d6bd" />


### Get the ChatGPT Api Key
- Go to [ChatGPT](https://chatgpt.com/) and create an account if you don’t have one
- Make sure you have credits or a payment method at [Billing Setting](https://platform.openai.com/settings/organization/billing/overview)
- Go to [API Keys](https://platform.openai.com/api-keys) and create a new key
- Save this key as you will only see it once!

Now, put you OpenAI key in the openAIApiKey field

<img width="402" height="348" alt="image" src="https://github.com/user-attachments/assets/d4ce5a96-d03c-485a-aac8-0aac80167f89" />

Now close the configuration.

Now, press Execute Workflow.

<img width="200" height="53" alt="image" src="https://github.com/user-attachments/assets/a3c91ffe-d969-44c0-a6ba-617d518ad723" />

It should look like this:

<img width="1395" height="165" alt="image" src="https://github.com/user-attachments/assets/8dc45fc7-e58a-4d45-bd19-060c555f3fd4" />

Now, select the Final Report node.

You should see the markdown report code.

<img width="431" height="714" alt="image" src="https://github.com/user-attachments/assets/ab95d01f-d908-4398-ab88-2b6fb7faa10d" />













