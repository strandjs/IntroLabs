

# Responder

MITRE Shield
------------

You can deploy defensive and deceptive capabilities to impact what is being targeted and successful.

Applicable MITRE Shield techniques:
* [DTE0010](https://shield.mitre.org/techniques/DTE0010) - Decoy Account
* [DTE0012](https://shield.mitre.org/techniques/DTE0012) - Decoy Credentials
* [DTE0015](https://shield.mitre.org/techniques/DTE0015) - Decoy Persona
* [DTE0036](https://shield.mitre.org/techniques/DTE0036) - Software Manipulation
* [DTE0032](https://shield.mitre.org/techniques/DTE0032) - Security Controls

Instructions
------------

In this lab we are going to walk through how quickly an attacker can take advantage of a common misconfiguration to gain access to a system via a weak password.

Specifically, we are looking to take advantage of LLMNR.

First, we will need to load our terminal and start responder.

Let's get started by opening a Terminal as Administrator

![](attachments\Clipboard_2020-06-12-10-36-44.png)

When you get the User Account Control Prompt, select Yes.

And, open a Ubuntu command prompt:

![](attachments\Clipboard_2020-06-17-08-32-51.png)

Next, let’s become root:

adhd@DESKTOP-I1T2G01:/mnt/c/Users/adhd$ `sudo su -`

Let’s change into the Responder directory:

root@DESKTOP-I1T2G01:~# `cd /opt/Responder/`

And let’s start Responder:

root@DESKTOP-I1T2G01:/opt/Responder# `./Responder.py -I eth0`

![](attachments\Clipboard_2020-06-23-14-22-03.png)

Now, let's go back to your Windows system and open Windows Explorer and put in the string \\\Noooo into the address bar.

![](attachments\Clipboard_2020-06-23-14-22-57.png)

Give it a few moments and you should see some capture data showing up.  Please note there may be an error.  That is OK.


![](attachments\Clipboard_2020-06-23-14-22-23.png)

Next we need to kill Responder with Ctrl + c.  This will return the command prompt.

Now, we need to change to the logs directory.

root@DESKTOP-I1T2G01:/opt/Responder# `cd logs/`

Once there, we will need to start John The Ripper"

root@DESKTOP-I1T2G01:/opt/Responder/logs# `/opt/JohnTheRipper/run/john --format=netntlmv2 ./HTTP-NTLMv2-172.26.16.1.txt`
Remember!  Your IP will be different!!!!

![](attachments\Clipboard_2020-06-23-14-24-11.png)

You should see the Windows password be cracked very quickly.


