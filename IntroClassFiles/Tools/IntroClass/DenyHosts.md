
DenyHosts
=========

Website
-------

<https://github.com/denyhosts/denyhosts>

Description
-----------

DenyHosts is a utility developed by Phil Schwartz and maintained by a number of developers which aims
to thwart sshd (ssh server) brute force attacks. Upon discovering a repeatedly malicious host, the `/etc/hosts.deny` 
file is updated to prevent future break-in attempts from that host.


Install Location
----------------
`/opt/denyhosts`

`/usr/share/denyhosts/`

Example 1: Installing DenyHosts
-------------------------------

`~$` **`wget https://github.com/denyhosts/denyhosts/releases/download/v3.1/DenyHosts-3.1.2.tar.gz`**

`~$` **`tar zxvf DenyHosts-3.1.tar.gz`**

The rest of the install process requires elevated privileges. You can either switch to root, or run the 
following commands with `sudo`.

`~#` **`mv DenyHosts-3.1 /opt`**

`~#` **`cd /opt/DenyHosts-3.1`**

`~#` **`python3 setup.py install`**

`~#` **`cp denyhosts.conf /etc`**

`~#` **`cp denyhosts.py /usr/bin`**

It really doesn't get much simpler than that.

Example 2: Enabling DenyHosts
-----------------------------

To enable DenyHosts, simply start its service.

`~$` **`sudo /opt/denyhosts/daemon-control start`**

This command launces DenyHosts and runs it in the background. The /etc/denyhosts.conf
file can be edited to configure its behavour.

Example 3: Basic Configuration
------------------------------

A majority of DenyHosts’ configurations can be made by editing the configuration file 
`/etc/denyhosts.conf`.

DenyHosts makes use of the default Linux whitelist and blacklist.

With a blacklisting service like DenyHosts it can be incredibly important to properly configure 
your whitelist prior to launch.  

The default whitelist file for Linux is `/etc/hosts.allow` (this can be changed in the DenyHosts conf file).  

The rule structure is the same for the files `/etc/hosts.deny` (blacklist) and `/etc/hosts.allow` (whitelist).

The pattern is `<service> : <host>`

You will have to be root to run any of the following commands by default.

So for example, if you wanted to allow access to a vsftp service for connections from ‘192.168.1.1’:

`~$` **`sudo su`**

`~#` **`echo “vsftpd : 192.168.1.1” >> /etc/hosts.allow`**

To whitelist a specific host’s connection to all services (example: 192.168.1.1):

`~#` **`echo “ALL : 192.168.1.1” >> /etc/hosts.allow`**

The `ALL` selector can also be used to whitelist or blacklist all hosts on a specific service:

`~#` **`echo “sshd : ALL” >> /etc/hosts.allow`**

