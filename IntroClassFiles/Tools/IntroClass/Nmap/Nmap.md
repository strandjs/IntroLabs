# Host Firewalls and Nmap

In this lab we will be scanning your **Windows** system from your **Linux** terminal with the firewall both on and off. 

The goal is to show you how a system is very different to the network with a firewall enabled. 

Remember, treat your internal network as hostile, because it is.

Let's get started by opening a command prompt terminal. You can do this by clicking the icon in the taskbar.

![](attachments/openingcommandprompt%20-%20Copy.png)

From the command prompt we need to get the IP address of your **Windows** system:

<pre>ipconfig</pre>

![](attachments/nmap_ipconfig.png)

Please note your IP for **your** system. Mine is 10.10.1.209. **Yours will be different.**

Let’s try and scan your Windows system from within a Kali terminal. Go ahead and open a Kali terminal up.

![](attachments/OpeningKaliInstance.png)

Alternatively, you can click on the Kali logo in the taskbar.

![](attachments/TaskbarKaliIcon.png)

In the Kali terminal, let’s become root:

<pre>sudo su -</pre>

We will scan your Windows system:

<pre>nmap 10.10.1.209</pre>

You can hit the spacebar to get status.

It should look like this:

![](attachments/nmap_nmap.png)

Please note the open ports. These are ports and services that an attacker could use to authenticate to your system or attack if an exploit is available. 

Go back to the Windows command prompt.  

![](attachments/openingcommandprompt%20-%20Copy.png)

Let’s enable the Windows firewall:

<pre>netsh advfirewall set allprofiles state on</pre>

![](attachments/nmap_advfirewallon.png)

Now, let’s rescan from the Kali terminal. You can navigate back to it by pressing the Kali logo in the taskbar:

![](attachments/TaskbarKaliIcon.png)

Rerun the scan: 

<pre>nmap 10.10.1.209</pre>

Please note, you can just hit the up arrow key to view previously run commands.  

You can hit the spacebar to see status.

It should look like this:

![](attachments/nmap_nmapscanwfirewall.png)

Now, using the same process as before, let’s disable the Windows firewall to go back to the base state:

<pre>netsh advfirewall set allprofiles state off</pre>

![](attachments/nmap_turnbackon.png)

***
[Back to Navigation Menu](/IntroClassFiles/navigation.md)

