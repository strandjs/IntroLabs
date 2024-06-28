
# Host Firewalls and Nmap

In this lab we will be scanning your **Windows** system from your **Linux** terminal with the firewall both on and off. 

The goal is to show you how a system is very different to the network with a firewall enabled. 

Remember, treat your internal network as hostile, because it is.

Let's get started by opening a Terminal as **Administrator**:

![](attachments/Clipboard_2020-06-12-10-36-44.png)

Let's open a command Prompt:

![](attachments/Clipboard_2020-06-16-09-53-18.png)

From the command prompt we need to get the IP address of your **Windows** system:

`ipconfig`

![](attachments/Clipboard_2020-07-07-15-24-29.png)

Please note ==**Y-O-U-R**== IP for your **WSL** address.  Mine is 172.26.176.1.  Yours ==**W-I-L-L**== be different.

Let’s try and scan your **Windows** system from Ubuntu.  To do this open a Ubuntu command prompt:

![](attachments/Clipboard_2020-06-17-08-32-51.png)

Let’s become root:

adhd@DESKTOP-I1T2G01:/mnt/c/Users/adhd$ `sudo su -`

Then, we will scan your Windows system:

root@DESKTOP-I1T2G01:~# `nmap 172.26.176.1`

You can hit the spacebar to get status.

It should look like this:

![](attachments/Clipboard_2020-07-07-15-34-15.png)

Please note the open ports. These are ports and services that an attacker could use to authenticate to your system.  Or, attack if an exploit is available. 

Let’s go back to the Windows command prompt, by selecting the Administrator: Command Prompt tab.

![](attachments/Clipboard_2020-07-07-15-31-07.png)

Let’s enable the Windows firewall:

Turn it back on and rerun.

C:\Users\adhd>`netsh advfirewall set allprofiles state on`

Let’s rescan from Linux.  Please select the Ubuntu tab:

![](attachments/Clipboard_2020-07-07-15-32-44.png)

Rerun the scan

root@DESKTOP-I1T2G01:~# `nmap 172.26.176.1`

Please note, you can just hit the up arrow key.

Once again, you can hit the spacebar to see status.

It should look like this:

![](attachments/Clipboard_2020-07-07-15-30-16.png)

Let’s disable the Windows firewall to go back to the base state:

C:\Users\adhd>`netsh advfirewall set allprofiles state off`

![](attachments/Clipboard_2020-07-07-15-34-15.png)