

# RITA

In this lab we are going to look at detecting command and control traffic on a network.

We will be using Real Intelligence Threat Analytics (RITA) for this lab.

To start we first need to open Windows File Explorer and navigate to the tools directory.

First, open File Explorer:

![](attachments/Clipboard_2020-07-07-16-58-09.png)

Then, select the tools directory:

![](attachments/Clipboard_2020-07-07-16-59-17.png)

Then, select rita-html-report:

![](attachments/Clipboard_2020-07-07-17-00-10.png)

Then, select index.html:

![](attachments/Clipboard_2020-07-07-17-01-18.png)



Let’s select VSAGENT-2017-3-15.

Review Options

The tabs across the top allow you to review the output for all the different analysis modules of RITA.
For VSAgent we will be focusing on Beacons, Blacklisted and User Agents.

Please select Beacons now.

![](attachments/Clipboard_2020-07-07-17-08-00.png)

Beacons

Some backdoors have a very strong “heartbeat”. This is where a backdoor will constantly reconnect to get commands from an attacker at a specific interval. The interval consistency of the “heartbeat” is the TS score where a value of 1 is perfect. The top value in this set is the VSAgent communication. We will talk about the other connections in a few moments.

We also have the number of connections. While some beacons have a “strong” heartbeat, they are very short in nature. Our VSAgent connection had a very large number of connections which had very strong intervals, while some of the others (e.g. the 64.4.54.253 addresses) had a strong heartbeat, but not as many connections. We will also talk about TS Duration. This is detecting how consistent each connection duration is. For example, if every connection is 2 seconds and there are 8000+ it would have a very strong TS Duration score.

The other fields are statistical analysis fields showing things like mode range and skew.
DNSCat2

Now, select RITA and then select DNSCat-2017-03-21. We are going to review a backdoor which does not quite fit the same mold as VSAgent.

![](attachments/Clipboard_2020-07-07-17-08-41.png)

![](attachments/Clipboard_2020-07-07-17-09-00.png)

This does not beacon back to a specific IP address, but rather it beacons through a DNS server. It is very crafty and will highlight how we can review the RAR compressed Bro logs used to generate the RITA data.

For this one, we are going to jump right to the DNS tab. It gives us the clearest look at this backdoor.

![](attachments/Clipboard_2020-07-07-17-09-33.png)

![](attachments/Clipboard_2020-07-07-17-09-56.png)

A couple of things should jump out at an investigator straight away. First, there were over 40K requests for cat.nanobotninjas.com. This is an absurd number for a specific domain. Sure, there are lots of requests for com and org and net and uk, but that is to be expect

Now, let's play with AC Hunter!

Please go to https://training.aihhosted.com/

The creds are:

ID= training@blackhillsinfosec.com
PW = gotbeacons?


When logged in, please select the house in the lower left corner and then the gear in the upper right.


![](attachments/AC_Hunter_Main_1.JPG)

This will open the dataset selection screen

![](attachments/DataSetSelection_2.JPG)

Please select vsagent then Confirm.

This will open the overall scoring screen.  This is the screen that allows you to see the systems that have the top scores across all areas from beacons to cyber deception.

Please select 10.55.100.111, then click on Beason Score on the right.

This will open the beacon score for this system.

![](attachments/BeaconScore_3.JPG)

Notice the histogram on the bottom and the scoring criteria in the middle. 

Notice how on the bottom you can see multiple aspects of this systems connections.  For example, you can see if there are any connections that had a threat intel hit, or if there are any connections that have beacons to a fully qualified domain.

Now, using AC Hunter, answer the following questions:

In the winlab-agent dataset, what is the connection interval for 10.10.98.30?

In the gcat dataset, what is the historic fqdn for the beacon on 10.55.100.111?

For the dnscat2-ja3-strobe-agent dataset, what domain has the highest lookup count?

And!!!!!!

Who is doing the lookups?

