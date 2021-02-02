
# Nmap

MITRE Shield
------------

You can deploy defensive and deceptive capabilities to impact the results of a scan.

Applicable MITRE Shield techniques:
* [DTE0013](https://shield.mitre.org/techniques/DTE0013) - Decoy Diversity
* [DTE0016](https://shield.mitre.org/techniques/DTE0016) - Decoy Process
* [DTE0017](https://shield.mitre.org/techniques/DTE0017) - Decoy System
* [DTE0036](https://shield.mitre.org/techniques/DTE0036) - Software Manipulation

Instructions
------------

In this lab we will be scanning your Windows system from your Linux terminal with the firewall both on and off.

The goal is to show you how a system is very different to the network with a firewall enabled.

Remember, treat your internal network as hostile, because it is.

Let's get started by opening a Terminal as Administrator:

![](attachments\Clipboard_2020-06-12-10-36-44.png)

Now, let's open a command Prompt:

![](attachments\Clipboard_2020-06-16-09-53-18.png)

From the command prompt we need to get the IP address of your Windows system:



C:\Users\adhd>`ipconfig`

![](attachments\Clipboard_2020-07-07-15-24-29.png)

Please note your IP for your WSL address.  Mine is 172.26.176.1.  Yours will be different.


Now, let’s try and scan your Windows system from Ubuntu.  To do this open a Ubuntu command prompt:

![](attachments\Clipboard_2020-06-17-08-32-51.png)

Next, let’s become root:

adhd@DESKTOP-I1T2G01:/mnt/c/Users/adhd$ `sudo su -`

Then, we will scan your Windows system:

root@DESKTOP-I1T2G01:~# `nmap 172.26.176.1`

You can hit the spacebar to get status.

It should look like this:

![](attachments\Clipboard_2020-07-07-15-30-16.png)

Now, let’s go back to the Windows command prompt, by selecting the Administrator: Command Prompt tab.

![](attachments\Clipboard_2020-07-07-15-31-07.png)

Now, let’s disable the Windows firewall:

C:\Users\adhd>`netsh advfirewall set allprofiles state off`

It should look like this:

![](attachments\Clipboard_2020-07-07-15-32-12.png)

Now, let’s rescan from Linux.  Please select the Ubuntu tab:

![](attachments\Clipboard_2020-07-07-15-32-44.png)

Then, rerun the scan

root@DESKTOP-I1T2G01:~# `nmap 172.26.176.1`

Please note, you can just hit the up arrow key.

Once again, you can hit the spacebar to see status.

It should look like this:


![](attachments\Clipboard_2020-07-07-15-34-15.png)

Please note the open ports. These are ports and services that an attacker could use to authenticate to your system.  Or, attack if an exploit is available.





