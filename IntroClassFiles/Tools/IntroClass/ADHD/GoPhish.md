![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# For the Ubuntu VM

# GoPhish

This lab demonstrates **what GoPhish can do** from both an attacker and defender perspective
You will **install GoPhish**, **launch a phishing campaign**, and **observe captured credentials and events**

---

## Lab Objectives

In this lab you will:
- Install GoPhish
- Launch the GoPhish web interface
- Create a basic phishing campaign
- Capture submitted credentials
- Analyze campaign results


---

# Start GoPhish

```
cd ~/Desktop/gophish
```

```bash
sudo ./gophish
```

You should see output similar to:
```
Starting admin server at http://0.0.0.0:3333
```

<img width="1063" height="192" alt="image" src="https://github.com/user-attachments/assets/0918fd4f-78ca-46ec-b3c9-37aa941b016e" />

>[!IMPORTANT]
>Leave this terminal open

---

# Step 4 – Access the Admin Panel

Open a browser and go to:

```
http://localhost:3333
```

<img width="563" height="536" alt="image" src="https://github.com/user-attachments/assets/949def60-dbea-431b-affd-1ad2c58d330e" />


### Default credentials:
- **Username:** admin
- **Password:** (shown in terminal output)

<img width="1094" height="21" alt="image" src="https://github.com/user-attachments/assets/140130ae-9237-4f9b-92a2-a547dfc36353" />


Copy the password from the terminal and log in

- Make your own password afterwards:

<img width="574" height="684" alt="image" src="https://github.com/user-attachments/assets/fb7954db-7c5e-4933-a710-405037ab9dc8" />

---

# Step 5 – Create a Sending Profile

1. Click **Sending Profiles** in the **left** tab

<img width="329" height="55" alt="image" src="https://github.com/user-attachments/assets/2aa9f0ba-4567-444e-8862-15ce973d7003" />

2. Click **New Profile**

<img width="153" height="73" alt="image" src="https://github.com/user-attachments/assets/342a74e4-7ac4-4b68-a530-0a453b1cf1da" />

3. Use:
   - Name: `Local SMTP`
   - Host: `127.0.0.1:1025`
   - From: `IT Support <it@company.local>`
4. Click **Save**

>[!NOTES]
>We are using port `1025` because that's the port where **MailHog** will be serving and listening

---

# Step 6 – Create a Landing Page (Credential Capture)

1. Click **Landing Pages**

<img width="331" height="68" alt="image" src="https://github.com/user-attachments/assets/03e2b2a3-db91-4be2-8bd9-f2411b6c27b2" />

2. Click **New Page**

<img width="127" height="62" alt="image" src="https://github.com/user-attachments/assets/c7564680-68ba-4114-9b21-0e8f386d2bda" />

3. Name: `Fake Login`
4. Check:
   - Capture Submitted Data
   - Capture Passwords

<img width="228" height="99" alt="image" src="https://github.com/user-attachments/assets/89a40847-1009-4fe2-98c5-c613bc457f6e" />

5. HTML Content:

```html
<h2>Company Login</h2>
<form method="POST">
  <input name="username" placeholder="Username"><br><br>
  <input name="password" type="password" placeholder="Password"><br><br>
  <button type="submit">Login</button>
</form>
```

6. Click **Save Page**

---

# Step 7 – Create an Email Template

1. Click **Email Templates**

<img width="326" height="64" alt="image" src="https://github.com/user-attachments/assets/96522c2f-5d63-4dd2-bf4a-344ab2f705fd" />

2. Click **New Template**

<img width="160" height="64" alt="image" src="https://github.com/user-attachments/assets/5b8e4d53-bb30-4dc8-8597-79cac373fad6" />

3. Name: `Password Reset`
4. Subject: `Urgent Password Reset`
5. Body(HTML):

```html
<p>Your password is expiring.</p>
<p><a href="{{.URL}}">Click here to reset it</a></p>
```

6. Click **Save Template**

---

# Step 8 – Create a User Group

1. Click **Users & Groups**

<img width="333" height="72" alt="image" src="https://github.com/user-attachments/assets/d964a536-e704-4a8a-bb02-ab1e9edd1d86" />

2. Click **New Group**

<img width="141" height="58" alt="image" src="https://github.com/user-attachments/assets/f62ff2a3-43d5-4985-a15c-cd5075b1d053" />

3. Name: `Test Users`
4. Add user:
   - First Name: `Test`
   - Last Name: `User`
   - Email: `test@company.local`
5. Click **+Add**

<img width="107" height="59" alt="image" src="https://github.com/user-attachments/assets/6cd813f4-d826-491e-86bd-d4776aeb6b7c" />

6. Click **Save Changes**

---

# Step 9 - Run MailHog

```bash
MailHog
```

<img width="550" height="124" alt="image" src="https://github.com/user-attachments/assets/bcdf9d65-2312-4e3c-b30d-38d4fe31305e" />


# Step 10 – Launch a Phishing Campaign

1. Click **Campaigns**

<img width="328" height="63" alt="image" src="https://github.com/user-attachments/assets/b689bf15-cc9d-4fd8-a63e-82c3a03aeab2" />

2. Click **New Campaign**

<img width="163" height="61" alt="image" src="https://github.com/user-attachments/assets/25f5651a-a932-4e9e-b46b-9a7e227b0e8f" />

3. Name: `Demo Campaign`
4. Select:
   - Email Template: `Password Reset`
   - Landing Page: `Fake Login`
   - Sending Profile: `Local SMTP`
   - Users Group: `Test Users`
5. Click **Launch Campaign**

---

- Now go back to the **MailHog Terminal**

- You should see the new mail

<img width="1920" height="1050" alt="image" src="https://github.com/user-attachments/assets/7b0ce4c1-81a8-4d99-bc26-3f2a3e578461" />

- What we get out of it?

1. Sender and recipient accepted
```
MAIL FROM:<it@company.local>
RCPT TO:<test@company.local>
250 ok
```

2. Email content delivered
```
DATA
Subject: Urgent Password Reset
X-Mailer: gophish
```

3. Email stored by MailHog
```
Storing message nYyPFT2-foO9BZ2z...
250 Ok: queued
```

4. Body of the email
```
<p>Your password is expiring.</p>
<p><a href=3D"?rid=3DzKNkt2x">Click here to reset it</a></p>'
```

...

***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/Mailoney.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/canarytokens/Canarytokens.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
