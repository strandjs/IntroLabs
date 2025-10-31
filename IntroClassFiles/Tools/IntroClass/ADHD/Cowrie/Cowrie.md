![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Cowrie

Website
-------

<https://github.com/adhdproject/cowrie>

Description
-----------

Cowrie is a medium interaction SSH honeypot designed to log brute force attacks and, most importantly, the entire shell interaction performed by the attacker.

>[!TIP]
>
>Cowrie is developed by <b>Michel Oosterhof</b> and is based on <i>Kippo</i> by <b>Upi Tamminen</b> (desaster).

The first thing we need to do is instal and start Cowrie.

To begin, let's open a Kali terminal. 

You can do this by right clicking the icon on the desktop by selecting open...

![](/IntroClassFiles/Tools/IntroClass/Cowrie/attachments/OpeningKaliInstance.png)

Or by clicking the icon in the taskbar...

![](/IntroClassFiles/Tools/IntroClass/Cowrie/attachments/TaskbarKaliIcon.png)

Then become root by running the following command:

<pre>sudo su -</pre>

![](/IntroClassFiles/Tools/IntroClass/Cowrie/attachments/gettingroot.png)

Getting Cowrie running is really easy if you have docker installed on your system.

>[!NOTE]
>
>If you don't have docker installed run the following command to get it set up:
><pre>snap install docker</pre>
>
>Once you run this, you can continue!

All you need to do is run the following:

<pre>docker run -p 2222:2222 cowrie/cowrie</pre>

This will take a few moments.

When running for the first time, you will see an output like this:

![](/IntroClassFiles/Tools/IntroClass/Cowrie/attachments/runningprocessdocker.png)

![](/IntroClassFiles/Tools/IntroClass/Cowrie/attachments/dockercowriecommand.png)

Once you see **"Ready to accept SSH connections"** in the command output, you are ready to continue.

Open another Kali terminal while keeping the first terminal open with the logs open as well. 

You can do this by clicking the icon in the taskbar:

![](/IntroClassFiles/Tools/IntroClass/Cowrie/attachments/TaskbarKaliIcon.png)

We need to delete any other previous `ssh known_hosts` connections to the honeypot.

This helps reduce any errors from starting and restarting the honeypot.

>[!TIP]
>
>You should run the following command in the `/home/kali` directory.

<pre>rm .ssh/known_hosts</pre>

![](/IntroClassFiles/Tools/IntroClass/Cowrie/attachments/rmsshhosts.png)

>[!IMPORTANT]
>
>The above command is critical because the key fingerprint for Cowrie changes every time you restart it!

Then, try to connect to the honeypot with the following command:

<pre>ssh -p 2222 root@localhost</pre>

When you get prompted to accept the key fingerprint, type `yes`:

![](/IntroClassFiles/Tools/IntroClass/Cowrie/attachments/rootlocalhost.png)

For the password, try `12345`:

![](/IntroClassFiles/Tools/IntroClass/Cowrie/attachments/enterpassword.png)

Now, run the following commands:

`id`

`whoami`

`pwd`

`AAAAAAAAAAAAAAAAAAAAAAAAAA`

![](/IntroClassFiles/Tools/IntroClass/Cowrie/attachments/terminalcommands.png)

Notice, the commands and authentication are being tracked in the other terminal with the log info:

![](/IntroClassFiles/Tools/IntroClass/Cowrie/attachments/reflection.png)

Take a few moments and notice that the results are always the same... for all Cowrie instances.

Let's change a few things about our Cowrie honeypot to make it unique.

Did you notice the system name in the prompt?

![](/IntroClassFiles/Tools/IntroClass/Cowrie/attachments/systemname.png)

It is the same for all default installations. Let's change that.

First, we need to kill our Cowrie session.  

To do this, click into the first terminal with our log output and press `ctrl + c` at the same time.

![](/IntroClassFiles/Tools/IntroClass/Cowrie/attachments/servershutdown.png)
>[!TIP] 
>
>If done correctly, you should see **"Server Shut Down"**

As we said above, one of the ways that people have been detecting honeypots like Cowrie for years is looking at the key fingerprint and the hostname. 

Because the key fingerprint changes every time you restart Cowrie, we need to next focus on changing the hostname. 

To do this we need to change the following file as root on our Kali system:

<pre>/var/lib/docker/overlay2/49cb1d1569dac74ee9793c9efb526ae1ba35b8e4a31b14a1a1c8c30bc70dc953/diff/cowrie/cowrie-git/etc/cowrie.cfg.dist</pre>

>[!NOTE]
>
>This is not a command, just the directory of the file we will be changing.

Ok, that path is just horrid.  The long number is a unique ID for our Cowrie system. Apparently, Docker <i>reaaaaalllly</i> does not like collisions.  

However, `overlay2` denotes this a a writeable layer for our container. Basically, this means we can edit our Docker container system within this directory.

So let's edit this file using `vim`.

As root, run the following:

<pre>vim /var/lib/docker/overlay2/49cb1d1569dac74ee9793c9efb526ae1ba35b8e4a31b14a1a1c8c30bc70dc953/diff/cowrie/cowrie-git/etc/cowrie.cfg.dist</pre>

![](/IntroClassFiles/Tools/IntroClass/Cowrie/attachments/vimfileedit.png)

>[!TIP]
>
>Copy and paste are your friends!

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

<pre>docker run -p 2222:2222 cowrie/cowrie</pre>

![image](https://github.com/user-attachments/assets/9390fd7a-7468-44ef-aa70-d52160c6d005)

Then, in another Kali terminal connect with a password of 12345:

<pre>rm .ssh/known_hosts</pre>

<pre>ssh -p 2222 root@localhost</pre>

Then type `yes` on the key fingerprint verification.

![image](https://github.com/user-attachments/assets/485efdb7-7cf9-4ee5-a59a-fc0375db817c)

Your hostname should now be changed.


Now, let’s edit the Message of the Day (MOTD).  Because the default one is not fun at all.


<pre>vim /var/lib/docker/overlay2/49cb1d1569dac74ee9793c9efb526ae1ba35b8e4a31b14a1a1c8c30bc70dc953/diff/cowrie/cowrie-git/honeyfs/etc/motd</pre>

![image](https://github.com/user-attachments/assets/e60c8de7-1026-4507-9e03-fb0718799a4f)

Change it to something better!

![image](https://github.com/user-attachments/assets/a99a4447-c2a7-4eb5-bb6c-0bf2861abf8e)

When done, hit the following keys in the following order

`esc`

`:`

`wq!`

`return`

Now, let's restart and connect:

<pre>docker run -p 2222:2222 cowrie/cowrie</pre>

![image](https://github.com/user-attachments/assets/9390fd7a-7468-44ef-aa70-d52160c6d005)

Then, in another Kali terminal connect with a password of 12345:

<pre>rm .ssh/known_hosts</pre>

<pre>ssh -p 2222 root@localhost</pre>

Then type `yes` on the key fingerprint verification.

![image](https://github.com/user-attachments/assets/485efdb7-7cf9-4ee5-a59a-fc0375db817c)

![image](https://github.com/user-attachments/assets/1a8b732b-2a04-413e-8039-dd7d04ac6360)


There!

That is much better!

There is far more than we can change in this short lab.

For a great resource on changing the way Cowrie looks and feels, check out the following site:

https://cryptax.medium.com/customizing-your-cowrie-honeypot-8542c888ca49

***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/Portspoof/Portspoof.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/Spidertrap/Spidertrap.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---

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
 
