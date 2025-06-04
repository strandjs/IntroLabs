![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)


Portspoof
=========

Website
-------

<http://portspoof.org/>

Description
-----------

Portspoof is meant to be a lightweight, fast, portable and secure addition to any firewall system or security system. The general goal of the program is to make the reconnaissance phase slow and bothersome for your attackers as much it is possible. This is quite a change to the standard aggressive Nmap scan, which will give a full view of your system's running services.

By using all of the techniques mentioned below:

* your attackers will have a tough time while trying to identify all of your listening services.
* the only way to determine if a service is emulated is through a protocol probe (imagine probing protocols for 65k open ports!).
* it takes more than 8 hours and 200MB of sent data in order to get all of the service banners for your system ( nmap -sV -p - equivalent).

---

The Portspoof program's primary goal is to enhance OS security through a set of new techniques:

* All TCP ports are always open

Instead of informing an attacker that a particular port is CLOSED or FILTERED a system with Portspoof will return SYN+ACK for every port connection attempt.

As a result it is impractical to use stealth (SYN, ACK, etc.) port scanning against your system, since all ports are always reported as OPEN. With this approach it is really difficult to determine if a valid software is listening on a particular port (check out the screenshots).

* Every open TCP port emulates a service

Portspoof has a huge dynamic service signature database, which will be used to generate responses to your offenders scanning software service probes.

Scanning software usually tries to determine a service that is running on an open port. This step is mandatory if one would want to identify port numbers on which you are running your services on a system behind the Portspoof. For this reason Portspoof will respond to every service probe with a valid service signature, which is dynamically generated based on a service signature regular expression database.

As a result an attacker will not be able to determine which port numbers your system is truly using.

Install Location
----------------

`/usr/local/bin/portspoof`

Config File Location
--------------------

`/usr/local/etc/portspoof.conf`
`/usr/local/etc/portspoof_signatures`

Usage
-----

`~#` **`portspoof -h`**

        Usage: portspoof [OPTION]...
        Portspoof - service emulator / frontend exploitation framework.

        -i			  ip : Bind to a particular  IP address
        -p			  port : Bind to a particular PORT number
        -s			  file_path : Portspoof service signature regex. file
        -c			  file_path : Portspoof configuration file
        -l			  file_path : Log port scanning alerts to a file
        -f			  file_path : FUZZER_MODE - fuzzing payload file list
        -n			  file_path : FUZZER_MODE - wrapping signatures file list
        -1			  FUZZER_MODE - generate fuzzing payloads internally
        -2			  switch to simple reply mode (doesn't work for Nmap)!
        -D			  run as daemon process
        -d			  disable syslog
        -v			  be verbose
        -h			  display this help and exit



Example 1: Starting Portspoof
-----------------------------

Portspoof, when run, listens on a single port. By default this is port 4444. In order to fool a port scan, we have to allow Portspoof to listen on *every* port. To accomplish this we will use an `iptables` command that redirects every packet sent to any port to port 4444 where the Portspoof port will be listening. This allows Portspoof to respond on any port.

First, let's become root:

`sudo su -`

Now, let's install portspoof

`apt-get update`

`apt-get install portspoof`

*Note, this may take a moment

![image](https://github.com/user-attachments/assets/db0eeae1-d282-448d-b2e6-7b819a091971)

Now, let's add the firewall rules.

`iptables -t nat -A PREROUTING -p tcp -m tcp --dport 1:20 -j REDIRECT --to-ports 4444`

Then run Portspoof with no options, which defaults it to "open port" mode. This mode will just return OPEN state for every connection attempt.

`portspoof`

![image](https://github.com/user-attachments/assets/1e2425d2-796a-4d20-8c05-393a551d1990)


If you were to scan using Nmap from another Windows command prompt. Now you would see something like this:

Note: You *must* run Nmap from a different machine. Scanning from the same machine will not reach Portspoof.

Open a Windows command prompt:

![image](https://github.com/user-attachments/assets/6f8f69a2-ff07-4deb-9f67-52f1fa5842a6)

Then, run nmap:

`nmap -p 1-10 <YOUR LINUX IP>`


![image](https://github.com/user-attachments/assets/d51c7589-8fbf-4b0a-8c69-6c21629e588d)


All ports are reported as open! When run this way, Nmap reports the service that typically runs on each port.

To get more accurate results, an attacker might run an Nmap service scan, which would actively try to detect the services running. But performing an Nmap service detection scan shows that something is amiss because all ports are reported as running the same type of service.

`nmap -p 1-10 -sV <YOUR LINUX IP>`

![image](https://github.com/user-attachments/assets/148e82e4-f8fb-4df5-8fef-6b758d1e05e1)


Example 2: Spoofing Service Signatures
--------------------------------------

Showing all ports as open is all well and good. But the same thing could be accomplished with a simple netcat listener (`nc -l -k 4444`). To make things more interesting, how about we have Portspoof fool Nmap into actually detecting real services running?

Let's kill the running version of portspoof with ctrl+c then restart it with signatures:

`portspoof -s /etc/portspoof/portspoof_signatures`

![image](https://github.com/user-attachments/assets/e1a2857a-7628-46d0-8808-b0af2add49f1)



This mode will generate and feed port scanners like Nmap bogus service signatures.

Now running an Nmap service detection scan against the top 100 most common ports (a common hacker activity) will turn up some very interesting results.

`nmap -p 1-10 -sV 172.16.215.138`

![image](https://github.com/user-attachments/assets/c4281e6f-4937-4477-b6a9-d2344d2a2699)


Notice how all of the ports are still reported as open, but now Nmap reports a unique service on each port. This will either 1) lead an attacker down a rabbit hole investigating each port while wasting their time, or 2) the attacker may discard the results as false positives and ignore this machine altogether, leaving any legitimate service running untouched.

Example 3: Cleaning Up
----------------------

To reset ADHD, you may reboot (recommended) or:

1. Kill Portspoof by pressing Ctrl-C.
2. Flush all iptables rules by running the command (as root): `sudo iptables -t nat -F`


[Return To Lab List](https://github.com/strandjs/IntroLabs/blob/master/IntroClassFiles/navigation.md)
