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

`~#` **`iptables -t nat -A PREROUTING -p tcp -m tcp --dport 1:65535 -j REDIRECT --to-ports 4444`**

Then run Portspoof with no options, which defaults it to "open port" mode. This mode will just return OPEN state for every connection attempt.

`~#` **`portspoof`**

If you were to scan using Nmap from another Windows command prompt. Now you would see something like this:

Note: You *must* run Nmap from a different machine. Scanning from the same machine will not reach Portspoof.

`~C:\>` **`nmap -p 1-10 <YOUR LINUX IP>`**

        Starting Nmap 6.47 ( http://nmap.org )
        Nmap scan report for 172.16.215.138
        Host is up (0.0018s latency).
        PORT   STATE SERVICE
        1/tcp  open  tcpmux
        2/tcp  open  compressnet
        3/tcp  open  compressnet
        4/tcp  open  unknown
        5/tcp  open  unknown
        6/tcp  open  unknown
        7/tcp  open  echo
        8/tcp  open  unknown
        9/tcp  open  discard
        10/tcp open  unknown
   

All ports are reported as open! When run this way, Nmap reports the service that typically runs on each port.

To get more accurate results, an attacker might run an Nmap service scan, which would actively try to detect the services running. But performing an Nmap service detection scan shows that something is amiss because all ports are reported as running the same type of service.

`~C:\>` **`nmap -p 1-10 -sV <YOUR LINUX IP>`**

        Starting Nmap 6.47 ( http://nmap.org )
        Nmap scan report for 172.16.215.138
        Host is up (0.00047s latency).
        PORT   STATE SERVICE    VERSION
        1/tcp  open  tcpwrapped
        2/tcp  open  tcpwrapped
        3/tcp  open  tcpwrapped
        4/tcp  open  tcpwrapped
        5/tcp  open  tcpwrapped
        6/tcp  open  tcpwrapped
        7/tcp  open  tcpwrapped
        8/tcp  open  tcpwrapped
        9/tcp  open  tcpwrapped
        10/tcp open  tcpwrapped


Example 2: Spoofing Service Signatures
--------------------------------------

Showing all ports as open is all well and good. But the same thing could be accomplished with a simple netcat listener (`nc -l -k 4444`). To make things more interesting, how about we have Portspoof fool Nmap into actually detecting real services running?

`~#` **`portspoof -s /usr/local/etc/portspoof_signatures`**

This mode will generate and feed port scanners like Nmap bogus service signatures.

Now running an Nmap service detection scan against the top 100 most common ports (a common hacker activity) will turn up some very interesting results.

`~C:\>` **`nmap -p 1-10 -sV 172.16.215.138`**

        Starting Nmap 6.47 ( http://nmap.org )
        Stats: 0:00:49 elapsed; 0 hosts completed (1 up), 1 undergoing Service Scan
        Service scan Timing: About 90.00% done; ETC: 01:11 (0:00:05 remaining)
        Nmap scan report for 172.16.215.138
        Host is up (0.21s latency).
     PORT   STATE SERVICE       VERSION
        1/tcp  open  tcpmux?
        2/tcp  open  compressnet?
        3/tcp  open  compressnet?
        4/tcp  open  pioneers-meta Pioneers game meta server 9
        5/tcp  open  rje?
        6/tcp  open  g15daemon     g15daemon (Logitech G15 keyboard control)
        7/tcp  open  echo?
        8/tcp  open  unknown
        9/tcp  open  nagios-nsca   Nagios NSCA
                10/tcp open  unknown
        7 services unrecognized despite returning data. If you know the service/version, please submit the following fingerprints at https://nmap.org/cgi-b                     in/submit.cgi?new-service :
        ==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
        SF-Port1-TCP:V=7.91%I=7%D=3/14%Time=604E7AC1%P=i686-pc-windows-windows%r(N
        SF:ULL,6D,"HTTP/1\.0\x20400\x20Invalid\x20Request\r\nContent-Type:\x20text

Notice how all of the ports are still reported as open, but now Nmap reports a unique service on each port. This will either 1) lead an attacker down a rabbit hole investigating each port while wasting their time, or 2) the attacker may discard the results as false positives and ignore this machine altogether, leaving any legitimate service running untouched.

Example 3: Cleaning Up
----------------------

To reset ADHD, you may reboot (recommended) or:

1. Kill Portspoof by pressing Ctrl-C.
2. Flush all iptables rules by running the command (as root): `sudo iptables -t nat -F`
