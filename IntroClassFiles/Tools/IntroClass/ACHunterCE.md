

In this lab we are going to set up the Community Edition of AC Hunter so it can intercept and inspect traffic on a home network without the need for expensive managed switches with SPAN or TAP ports.  This is done through the amazing power of ARP cache poisoning.

Step 0, Download AC Hunter Community Edition Here:

https://www.activecountermeasures.com/ac-hunter-community-edition/download/

![](https://github.com/strandjs/IntroLabs/blob/master/IntroClassFiles/Tools/IntroClass/ACHCE/ACHCE_Download.png)

1. The first thing we will need to do is to change VM to Bridged networking from NAT.  This can be done in the settings for the VM which can be accessed via VM > Settings > Network Adaptor 

![](https://github.com/strandjs/IntroLabs/blob/master/IntroClassFiles/Tools/IntroClass/ACHCE/VMWare_Bridge.png)

2. When the VM is done booting it is essential you copy password before login!!!! It is displayed in the logon banner at first boot and will go away once it is used.


User ID is dataimport	

![](https://github.com/strandjs/IntroLabs/blob/master/IntroClassFiles/Tools/IntroClass/ACHCE/Password2.png)

5. Change the default password after initial login	
6. Get your IP Address 

`ip addr show dev ens33 | grep 'inet '`

5. Switch to Terminal on Windows and open two SSH sessions.  I like to have one as root and another as dataimport for the install.

From Windows Terminal.

Terminal 1:

`ssh dataimport@YourACHCE_IPADDRESS`

Terminal 2:

`ssh dataimport@YOURACHCE_IPADDRESS`

`sudo su -`

6. As dataimport, pull down and install zeek

`sudo wget -O /usr/local/bin/zeek https://raw.githubusercontent.com/activecm/docker-zeek/master/zeek`

`sudo chmod +x /usr/local/bin/zeek`

`zeek pull`

7. Choose your ens adaptor!!

It should look like it does below:

```
? Choose your capture interface(s):  [Use arrows to move, space to select, type to filter, ? for more help]
  [ ]  br-d933eaf5d433      UP      172.18.0.1  fe80::42:4cff:fea7:3586
  [ ]  docker0              UP      172.17.0.1
> [ ]  ens33                UP   192.168.3.122  fe80::20c:29ff:fec7:4f8
  [ ]  lo                   UP       127.0.0.1  ::1
  [ ]  veth07f3680          UP               -  fe80::6c66:1dff:fe22:2de5
  [ ]  veth6f1a6c9          UP               -  fe80::5428:54ff:fe62:b8a0
  [ ]  veth99c741a          UP               -  fe80::1ccd:2aff:fee8:fa3e
  [ ]  vethb857d1b          UP               -  fe80::60d4:3ff:fe88:9500
  [ ]  vethed90b7f          UP               -  fe80::44ef:6fff:fe64:1c26
 
 ```

`zeek start`

8. Add a password for the web user for AC Hunter

`manage_web_user.sh reset -u 'welcome@activecountermeasures.com'`

It should look like it does below:

```dataimport@achce:~$ manage_web_user.sh reset -u 'welcome@activecountermeasures.com'
Please enter a password
Please re-enter to confirm:
achunter_db is up-to-date
MongoDB shell version v4.2.23
connecting to: mongodb://127.0.0.1:27017/users?authSource=admin&compressors=disabled&gssapiServiceName=mongodb
Implicit session: session { "id" : UUID("72e4d3b5-350b-489d-ae29-1f10660648ce") }
MongoDB server version: 4.2.23
WriteResult({ "nRemoved" : 1 })
Creating achunter_auth_run ... done
User created successfully.
{'email': 'welcome@activecountermeasures.com', 'password': '****', 'active': True}
dataimport@achce:~$
```

9. Get the proper scripts to connect the Zeek Sensor

`curl -fsSL https://raw.githubusercontent.com/activecm/zeek-log-transport/master/connect_sensor.sh -O`

`curl -fsSL https://raw.githubusercontent.com/activecm/shell-lib/master/acmlib.sh -O`

`curl -fsSL https://raw.githubusercontent.com/activecm/zeek-log-transport/master/zeek_log_transport.sh -O`

10. Get your hostname

`hostname`

11. run the script with your ac-hunter system hostname:

`bash connect_sensor.sh achce`

It should look like it does below:

```================ Creating a new RSA key with no passphrase ================
Generating public/private rsa key pair.
Your identification has been saved in /home/dataimport/.ssh/id_rsa_dataimport
Your public key has been saved in /home/dataimport/.ssh/id_rsa_dataimport.pub
The key fingerprint is:
SHA256:oKsPovlMN0mYiwA7Q4ap/tSKawXdvU94HdhOqs+KR08 dataimport@achce
The key's randomart image is:
+---[RSA 2048]----+
|                 |
|..               |
|+o. . o   o      |
|=o + o o . +     |
|* + o   S = .    |
|o+ +.o + E o     |
|o.=.=.. B        |
|.*++...o.o       |
|++=+....oo       |
+----[SHA256]-----+

================ Transferring the RSA key to dataimport@achce - please provide the password when prompted.  You may be prompted to accept the ssh host key. ================
The authenticity of host 'achce (127.0.1.1)' can't be established.
ECDSA key fingerprint is SHA256:gh75DHZlG9aFp3JHgD6be74O6jH2ueASZX3aLcE7STg.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'achce' (ECDSA) to the list of known hosts.
dataimport@achce's password:

```

12. Install bettercap as root!!! Please switch to the other Terminal where you are running as root.

`docker pull bettercap/bettercap`

`docker run -it --privileged --net=host bettercap/bettercap -eval "caplets.update; ui.update; q"`

13. Install mlocate

`apt install mlocate`

14. Updated the database

`updatedb`

15. Search for the config files

`locate https-ui.cap`

16. Edit the https-ui.cap file:

Please note your path will be different!!!!!

`vi /var/lib/docker/overlay2/5146307503ac713827d090d51b88a622af068579060d8e1f1d97cda56415e018/diff/app/https-ui.cap`

Change the line set https.server.port to 4443

It should look like it does below:

```# api listening on https://0.0.0.0:8083/ and ui on https://0.0.0.0
set api.rest.address 0.0.0.0
set api.rest.port 8083
set https.server.address 0.0.0.0
set https.server.port 4443

# make sure both use the same https certificate so api requests won't fail
set https.server.certificate ~/.bettercap-https.cert.pem
set https.server.key ~/.bettercap-https.key.pem
set api.rest.certificate ~/.bettercap-https.cert.pem
set api.rest.key ~/.bettercap-https.key.pem
# default installation path of the ui
set https.server.path /usr/local/share/bettercap/ui

# !!! CHANGE THESE !!!
set api.rest.username user
set api.rest.password pass

# go!
api.rest on
https.server on
```


log out of vi with esc :wq!

###Please note, there seems to be a weird bug in Bettercap where it updates the port to 4444443.  If you get a bind error, just re-edit the above file to set the port to 443.

17. Start bettercap


`docker run -it --privileged --net=host bettercap/bettercap -caplet https-ui`


18. Show the network

`net.show`


```

192.168.3.0/24 > 192.168.3.116  » net.show

┌───────────────┬───────────────────┬─────────────────┬───────────────────────┬────────┬────────┬──────────┐
│     IP ▴      │        MAC        │      Name       │        Vendor         │  Sent  │ Recvd  │   Seen   │
├───────────────┼───────────────────┼─────────────────┼───────────────────────┼────────┼────────┼──────────┤
│ 192.168.3.116 │ 00:0c:29:8e:f6:79 │ ens33           │ VMware, Inc.          │ 0 B    │ 0 B    │ 15:25:44 │
│ 192.168.3.1   │ a0:21:b7:7b:0f:59 │ gateway         │ Netgear               │ 11 kB  │ 45 kB  │ 15:25:44 │
│               │                   │                 │                       │        │        │          │
│ 192.168.3.132 │ f0:2f:74:d0:e7:e8 │ DESKTOP-92LVFPS │ ASUSTek COMPUTER INC. │ 364 kB │ 587 kB │ 15:29:25 │
└───────────────┴───────────────────┴─────────────────┴───────────────────────┴────────┴────────┴──────────┘

↑ 6.7 kB / ↓ 962 kB / 3748 pkts


```

19. Show help for options!

`help`

It should look like it does below:

```

192.168.3.0/24 > 192.168.3.116  » help

           help MODULE : List available commands or show module specific help if no module name is provided.
                active : Show information about active modules.
                  quit : Close the session and exit.
         sleep SECONDS : Sleep for the given amount of seconds.
              get NAME : Get the value of variable NAME, use * alone for all, or NAME* as a wildcard.
        set NAME VALUE : Set the VALUE of variable NAME.
  read VARIABLE PROMPT : Show a PROMPT to ask the user for input that will be saved inside VARIABLE.
                 clear : Clear the screen.
        include CAPLET : Load and run this caplet in the current session.
             ! COMMAND : Execute a shell command and print its output.
        alias MAC NAME : Assign an alias to a given endpoint given its MAC address.

Modules

      any.proxy > not running
       api.rest > running
      arp.spoof > running
      ble.recon > not running
             c2 > not running
        caplets > not running
    dhcp6.spoof > not running
      dns.spoof > not running
  events.stream > running
            gps > not running
            hid > not running
     http.proxy > not running
    http.server > not running
    https.proxy > not running
   https.server > running
    mac.changer > not running
    mdns.server > not running
   mysql.server > not running
      ndp.spoof > not running
      net.probe > not running
      net.recon > running
      net.sniff > not running
   packet.proxy > not running
       syn.scan > not running
      tcp.proxy > not running
         ticker > not running
             ui > not running
         update > not running
           wifi > not running
            wol > not running
			
			
			
			
```

20.  Start the poison

`arp.spoof on`

21. Start the https proxy

`https.proxy on`

Now, surf to your AC-Hunter system!!!

https://<YOUR_ACHCE_IP_ADDR>

