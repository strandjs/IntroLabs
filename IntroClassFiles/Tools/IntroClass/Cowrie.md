
Cowrie
============

Website
-------

<https://github.com/adhdproject/cowrie>

Description
-----------

Cowrie is a medium interaction SSH honeypot designed to log brute force attacks and,
most importantly, the entire shell interaction performed by the attacker.

Cowrie is developed by Michel Oosterhof and is based on Kippo by Upi Tamminen (desaster).

The first thing we need to do is install/start cowrie.

Open a Kali prompt:

![image](https://github.com/user-attachments/assets/1174968b-9c56-485e-8563-054aca72cf60)

Then become root:

`sudo su -`

![image](https://github.com/user-attachments/assets/e0d1da47-9291-40e5-aded-7d0e1deabb75)

Getting cowrie running is really easy if you have docker installed on your system.

All you need to do is run the following:

`docker run -p 2222:2222 cowrie/cowrie`

This will take a few moments.

When it is running you should be able to see the logs like this:

![image](https://github.com/user-attachments/assets/ba63568c-d813-4a84-be63-8462f7683aea)

Now, open another Kali terminal while keeping the first terminal open with the logs open as well:

![image](https://github.com/user-attachments/assets/1174968b-9c56-485e-8563-054aca72cf60)

Let’s delete any other previous ssh known_hosts connections to the honeypot.

This helps reduce any errors from starting and restarting the honeypot.

You should run this command in the /home/kali directory.

`rm .ssh/known_hosts`

￼![image](https://github.com/user-attachments/assets/a103057f-0f1c-47b5-8e7d-ec8eabadbe53)


*The above command is critical because the key fingerprint for Cowrie changes every time you restart it!*

Then, try to connect to the honeypot with the following command:

`ssh -p 2222 root@localhost`

When you get prompted to accept the key fingerprint, type `yes`:

![image](https://github.com/user-attachments/assets/f1a218b7-55ba-475a-9ff2-bf8ea99f372d)

For the password, try `12345`:

![image](https://github.com/user-attachments/assets/2044c147-0a09-46bb-b159-9110cd4fa3fa)

Now, run the following commands:

`id`

`whoami`

`pwd`

`AAAAAAAAAAAAAAAAAAAAAAAAAA`

Notice, the commands and authentication are being tracked in the other terminal with the log info:

![image](https://github.com/user-attachments/assets/33e3cd1c-28a1-4a4c-874e-b9b600e41be8)

Take a few moments and note the results are always the same.  As in, they are the same for all Cowrie instances.

Let's change a few things about our Cowrie honeypot to make it unique.

Did you notice the system name in the prompt?

![image](https://github.com/user-attachments/assets/b3e7d546-1328-42e1-a7a7-db0f094e64aa)

It is the same for all default instalations. Let's change that.

Let’s kill our Cowrie session.  

To do this, click into the Terminal with our log output and press ctrl+c at the same time.

![image](https://github.com/user-attachments/assets/deea16c1-cc94-459e-a2ac-d94d7663f88f)

As we said above, one of the ways that people have been detecting honeypots like Cowrie for years is looking at the key fingerprint and the hostname. 

Because the key fingerprint changes every time you restart Cowrie, we need to next focus on changing the hostname.  To do this we need to change the following file as root on our Kali system:

/var/lib/docker/overlay2/49cb1d1569dac74ee9793c9efb526ae1ba35b8e4a31b14a1a1c8c30bc70dc953/diff/cowrie/cowrie-git/etc/cowrie.cfg.dist

Ok, that path is just horrid.  The long number is a unique idea for our Cowrie system.  Apparently, Docker Reaaaaalllly did not collisions.  The overlay2 denotes this a a writeable layer for our container.  

Basically, this means we can edit our Docker container system in this directory.

Let's edit this file.

As root, run the following:

`vim /var/lib/docker/overlay2/49cb1d1569dac74ee9793c9efb526ae1ba35b8e4a31b14a1a1c8c30bc70dc953/diff/cowrie/cowrie-git/etc/cowrie.cfg.dist`


![image](https://github.com/user-attachments/assets/a87a5e25-a731-4567-ae46-38a340aad32a)

Copy and paste are your friends.

Once in the file, use the down arrow and go to roughly line 30 and change the hostname

![image](https://github.com/user-attachments/assets/36c901de-1a3e-45b1-b24c-3c07666884c5)

To do this in vim, press `a` then make the change.

![image](https://github.com/user-attachments/assets/d3d7a3d4-99e6-48cd-ad07-c20489974802)

When done, hit the following keys in the following order

`esc`

`:`

`wq!`

`return`


Now, let's restart and connect:

`docker run -p 2222:2222 cowrie/cowrie`

![image](https://github.com/user-attachments/assets/9390fd7a-7468-44ef-aa70-d52160c6d005)

Then, in another Kali terminal connect with a password of 12345:

`rm .ssh/known_hosts`

`ssh -p 2222 root@localhost`

Then type `yes` on the key fingerprint verification.

![image](https://github.com/user-attachments/assets/485efdb7-7cf9-4ee5-a59a-fc0375db817c)

Your hostname should now be changed.


Now, let’s edit the Message of the Day (MOTD).  Because the default one is not fun at all.


`vim /var/lib/docker/overlay2/49cb1d1569dac74ee9793c9efb526ae1ba35b8e4a31b14a1a1c8c30bc70dc953/diff/cowrie/cowrie-git/honeyfs/etc/motd`

![image](https://github.com/user-attachments/assets/e60c8de7-1026-4507-9e03-fb0718799a4f)

Change it to something better!

![image](https://github.com/user-attachments/assets/a99a4447-c2a7-4eb5-bb6c-0bf2861abf8e)

When done, hit the following keys in the following order

`esc`

`:`

`wq!`

`return`

Now, let's restart and connect:

`docker run -p 2222:2222 cowrie/cowrie`

![image](https://github.com/user-attachments/assets/9390fd7a-7468-44ef-aa70-d52160c6d005)

Then, in another Kali terminal connect with a password of 12345:

`rm .ssh/known_hosts`

`ssh -p 2222 root@localhost`

Then type `yes` on the key fingerprint verification.

![image](https://github.com/user-attachments/assets/485efdb7-7cf9-4ee5-a59a-fc0375db817c)

![image](https://github.com/user-attachments/assets/1a8b732b-2a04-413e-8039-dd7d04ac6360)


There!

That is much better!

There is far more than we can change in this short lab.

For a great resource on changing the way Cowrie looks and feels, check out the following site:

https://cryptax.medium.com/customizing-your-cowrie-honeypot-8542c888ca49

[Return To Lab List](https://github.com/strandjs/IntroLabs/blob/master/IntroClassFiles/navigation.md)

<!--

THIS SECTION IS BEING REMOVED FOR THE TIME BEING PER JOHN



Install Location
----------------

`/opt/cowrie`

Usage
-----

Cowrie is incredibly easy to use.

It basically has two parts you need to be aware of:

  * A config file
  * A launch script

The config file is located at

`/opt/cowrie/etc/cowrie.cfg`


Example 1: Running Cowrie
------------------------

By default Cowrie listens on port 2222 and emulates an ssh server.

To run Cowrie, cd into the Cowrie directory and execute:

`~$` **`cd /opt/cowrie`**
`~$` **`./bin/cowrie start`**

        Not using Python virtual environment
        version check
        Starting cowrie: [twistd   --umask=0022 --pidfile=var/run/cowrie.pid --logger cowrie.python.logfile.logger cowrie ]...

We can confirm Cowrie is listening with Cowrie's own `status` command:

`~$` **`./bin/cowrie status`**

        cowrie is running (PID: 21473).

We can also confirm Cowrie is listening with lsof:

`~$` **`sudo lsof -i -P | grep twistd`**

        twistd  548 adhd    6u  IPv4 523637      0t0  TCP *:2222 (LISTEN)

Looks like we're good.

Example 2: Cowrie In Action
--------------------------

Assuming Cowrie is already running and listening on port 2222, (if not see [Example 1: Running Cowrie]),
 we can now ssh to Cowrie in order to see what an attacker would see.

`~$` **`ssh -p 2222 localhost`**

        The authenticity of host '[localhost]:2222 ([127.0.0.1]:2222)' can't be established.
        RSA key fingerprint is 05:68:07:f9:47:79:b8:81:bd:8a:12:75:da:65:f2:d4.
        Are you sure you want to continue connecting (yes/no)? yes
        Warning: Permanently added '[localhost]:2222' (RSA) to the list of known hosts.
        Password:
        Password:
        Password:
        adhd@localhost's password:
        Permission denied, please try again.

It looks like our attempts to authenticate were met with failure.

Example 3: Viewing Cowrie's Logs
-------------------------------

Change into the Cowrie log Directory:

`~$` **`cd /opt/cowrie/var/log/cowrie`**

Now tail the contents of cowrie.log:

`/opt/cowrie/var/log/cowrie$` **`tail cowrie.log`**

        2016-02-17 21:52:12-0700 [-] unauthorized login:
        2016-02-17 21:54:51-0700 [SSHService ssh-userauth on HoneyPotTransport,0,127.0.0.1] adhd trying auth password
        2016-02-17 21:54:51-0700 [SSHService ssh-userauth on HoneyPotTransport,0,127.0.0.1] login attempt [adhd/asdf] failed
        2016-02-17 21:54:52-0700 [-] adhd failed auth password
        2016-02-17 21:54:52-0700 [-] unauthorized login:
        2016-02-17 21:54:53-0700 [SSHService ssh-userauth on HoneyPotTransport,0,127.0.0.1] adhd trying auth password
        2016-02-17 21:54:53-0700 [SSHService ssh-userauth on HoneyPotTransport,0,127.0.0.1] login attempt [adhd/adhd] failed
        2016-02-17 21:54:54-0700 [-] adhd failed auth password
        2016-02-17 21:54:54-0700 [-] unauthorized login:
        2016-02-17 21:54:54-0700 [HoneyPotTransport,0,127.0.0.1] connection lost

Here we can clearly see my login attempts and the username/password combos I employed as I tried
to gain access in [Example 2: Cowrie In Action].  This could be very useful!

Also, when you get a chance, take a look at the command configuration files in the `/opt/cowrie/honeyfs` directory.

Finally, user accounts for logging into the fake ssh server can be placed in a `/opt/cowrie/etc/userdb.txt` file. This file no longer exists by default, so Cowrie uses credentials specified near the top of `/opt/cowrie/src/cowrie/core/auth.py` by default

An example userdb file can be found in `/opt/cowrie/etc/userdb.example`. Cowrie
credentials can be specified using patterns. These patterns are explained in the
example file.

What happens when you log in with one of the valid userID and password combos?

What happens when you exit the session?

What are some solid IOCs that this is a honeypot?
--!>
 
