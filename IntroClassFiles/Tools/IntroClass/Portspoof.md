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

`~#` **`iptables -t nat -A PREROUTING -p tcp -m tcp --dport 1:65535 -j REDIRECT --to-ports 4444`**

Then run Portspoof with no options, which defaults it to "open port" mode. This mode will just return OPEN state for every connection attempt.

`~#` **`portspoof`**

If you were to scan using Nmap from another machine now you would see something like this:

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
        11/tcp open  systat
        12/tcp open  unknown
        13/tcp open  daytime
        14/tcp open  unknown
        15/tcp open  netstat
        16/tcp open  unknown
        17/tcp open  qotd
        18/tcp open  unknown
        19/tcp open  chargen
        20/tcp open  ftp-data

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
        11/tcp open  tcpwrapped
        12/tcp open  tcpwrapped
        13/tcp open  tcpwrapped
        14/tcp open  tcpwrapped
        15/tcp open  tcpwrapped
        16/tcp open  tcpwrapped
        17/tcp open  tcpwrapped
        18/tcp open  tcpwrapped
        19/tcp open  tcpwrapped
        20/tcp open  tcpwrapped

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
        PORT      STATE SERVICE          VERSION
        7/tcp     open  http             Milestone XProtect video surveillance http interface (tu-ka)
        9/tcp     open  ntop-http        Ntop web interface 1ey (Q)
        13/tcp    open  ftp              VxWorks ftpd 6.a
        21/tcp    open  http             Grandstream VoIP phone http config 6193206
        22/tcp    open  http             Cherokee httpd X
        23/tcp    open  ftp              MacOS X Server ftpd (MacOS X Server 790751705)
        25/tcp    open  smtp?
        26/tcp    open  http             ZNC IRC bouncer http config 0.097 or later
        37/tcp    open  finger           NetBSD fingerd
        53/tcp    open  ftp              Rumpus ftpd
        79/tcp    open  http             Web e (Netscreen administrative web server)
        80/tcp    open  http             BitTornado tracker dgpX
        81/tcp    open  hosts2-ns?
        88/tcp    open  http             3Com OfficeConnect Firewall http config
        106/tcp   open  pop3pw?
        110/tcp   open  ipp              Virata-EmWeb nbF (HP Laserjet 4200 TN http config)
        111/tcp   open  imap             Dovecot imapd
        113/tcp   open  smtp             Xserve smtpd
        119/tcp   open  nntp?
        135/tcp   open  http             netTALK Duo http config
        139/tcp   open  http             Oversee Turing httpd kC (domain parking)
        143/tcp   open  crestron-control TiVo DVR Crestron control server
        144/tcp   open  http             Ares Galaxy P2P httpd 7942927
        179/tcp   open  http             WMI ViH (3Com 5500G-EI switch http config)
        199/tcp   open  smux?
        389/tcp   open  http-proxy       ziproxy http proxy
        427/tcp   open  vnc              (protocol 3)
        443/tcp   open  https?
        444/tcp   open  snpp?
        445/tcp   open  http             Pogoplug HBHTTP QpwKdZQ
        465/tcp   open  http             Gordian httpd 322410 (IQinVision IQeye3 webcam rtspd)
        513/tcp   open  login?
        514/tcp   open  finger           ffingerd
        515/tcp   open  pop3             Eudora Internet Mail Server X pop3d 4918451
        543/tcp   open  ftp              Dell Laser Printer z printer ftpd k
        544/tcp   open  ftp              Solaris ftpd
        548/tcp   open  http             Medusa httpd Elhmq (Sophos Anti-Virus Home http config)
        554/tcp   open  rtsp?
        587/tcp   open  http-proxy       Pound http proxy
        631/tcp   open  efi-webtools     EFI Fiery WebTools communication
        646/tcp   open  ldp?
        873/tcp   open  rsync?
        990/tcp   open  http             OpenWrt uHTTPd
        993/tcp   open  ftp              Konica Minolta bizhub printer ftpd
        995/tcp   open  pop3s?
        1025/tcp  open  sip-proxy        Comdasys SIP Server D
        1026/tcp  open  LSA-or-nterm?
        1027/tcp  open  IIS?
        1028/tcp  open  rfidquery        Mercury3 RFID Query protocol
        1029/tcp  open  smtp-proxy       ESET NOD32 anti-virus smtp proxy
        1110/tcp  open  http             qhttpd
        1433/tcp  open  http             ControlByWeb WebRelay-Quad http admin
        1720/tcp  open  H.323/Q.931?
        1723/tcp  open  pptp?
        1755/tcp  open  http             Siemens Simatic HMI MiniWeb httpd
        1900/tcp  open  tunnelvision     Tunnel Vision VPN info 69853
        2000/tcp  open  telnet           Patton SmartNode 4638 VoIP adapter telnetd
        2001/tcp  open  dc?
        2049/tcp  open  nfs?
        2121/tcp  open  http             Bosch Divar Security Systems http config
        2717/tcp  open  rtsp             Darwin Streaming Server 104621400
        3000/tcp  open  pop3             Solid pop3d
        3128/tcp  open  irc-proxy        muh irc proxy
        3306/tcp  open  ident            KVIrc fake identd
        3389/tcp  open  ms-wbt-server?
        3986/tcp  open  mapper-ws_ethd?
        4899/tcp  open  printer          QMC DeskLaser printer (Status o)
        5000/tcp  open  http             D-Link DSL-eTjM http config
        5009/tcp  open  airport-admin?
        5051/tcp  open  ssh              (protocol 325257)
        5060/tcp  open  http             apt-cache/apt-proxy httpd
        5101/tcp  open  ftp              OKI BVdqeC-ykAA VoIP adapter ftpd kHttKI
        5190/tcp  open  http             Conexant-EmWeb JqlM (Intertex IX68 WAP http config; SIPGT TyXT)
        5357/tcp  open  wsdapi?
        5432/tcp  open  postgresql?
        5631/tcp  open  irc              ircu ircd
        5666/tcp  open  litecoin-jsonrpc Litecoin JSON-RPC f_
        5800/tcp  open  smtp             Lotus Domino smtpd rT Beta y
        5900/tcp  open  ftp
        6000/tcp  open  http             httpd.js (Songbird WebRemote)
        6001/tcp  open  daap             mt-daapd DAAP TGeiZA
        6646/tcp  open  unknown
        7070/tcp  open  athinfod         Athena athinfod
        8000/tcp  open  amanda           Amanda backup system index server (broken: libsunmath.so.1 not found)
        8008/tcp  open  http?
        8009/tcp  open  ajp13?
        8080/tcp  open  http             D-Link DGL-4300 WAP http config
        8081/tcp  open  http             fec ysp (Funkwerk bintec R232B router; .h.K...z)
        8443/tcp  open  smtp
        8888/tcp  open  smtp             OpenVMS smtpd uwcDNI (OpenVMS RVqcGIr; Alpha)
        9100/tcp  open  jetdirect?
        9999/tcp  open  http             Embedded HTTPD 3BOzejtHW (Netgear MRd WAP http config; j)
        10000/tcp open  http             MikroTik router http config (RouterOS 0982808)
        32768/tcp open  filenet-tms?
        49152/tcp open  unknown
        49153/tcp open  http             ASSP Anti-Spam Proxy httpd XLgR(?)?
        49154/tcp open  http             Samsung AllShare httpd
        49155/tcp open  ftp              Synology DiskStation NAS ftpd
        49156/tcp open  aspi             ASPI server 837305
        49157/tcp open  sip              AVM FRITZ!Box |

Notice how all of the ports are still reported as open, but now Nmap reports a unique service on each port. This will either 1) lead an attacker down a rabbit hole investigating each port while wasting their time, or 2) the attacker may discard the results as false positives and ignore this machine altogether, leaving any legitimate service running untouched.

Example 3: Cleaning Up
----------------------

To reset ADHD, you may reboot (recommended) or:

1. Kill Portspoof by pressing Ctrl-C.
2. Flush all iptables rules by running the command (as root): `sudo iptables -t nat -F`
