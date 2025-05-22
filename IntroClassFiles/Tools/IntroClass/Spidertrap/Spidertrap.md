![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

Spidertrap
==========

Website
-------

<https://github.com/adhdproject/spidertrap>

Description
-----------

Trap web crawlers and spiders in an infinite set of dynamically
generated webpages.

Install Location
----------------

`/opt/spidertrap/`

Usage
-----

`/opt/spidertrap$` **`python3 spidertrap.py --help`**

        Usage: spidertrap.py [FILE]

        FILE is file containing a list of webpage names to serve, one per line.
        If no file is provided, random links will be generated.


Example 1: Basic Usage
----------------------

Let's get started by opening a Kali terminal. 
You can do this by right clicking the icon on the desktop by selecting open...

![](/IntroClassFiles/Tools/IntroClass/Spidertrap/OpeningKaliInstance.png)

Or... you can simply click on the Kali logo in the taskbar.

![](/IntroClassFiles/Tools/IntroClass/Spidertrap/TaskbarKaliIcon.png)

First, let's get your Kali Linux systems IP address by running the following command:

<pre>ifconfig</pre>

![](/IntroClassFiles/Tools/IntroClass/Spidertrap/ifconfig.png)

Next, let's cd into the proper directory:

<pre>cd /opt/spidertrap</pre>

![](/IntroClassFiles/Tools/IntroClass/Spidertrap/cdoptspidertrap.png)

Now, lets start Spidertrap by running the following command:

<pre>python3 spidertrap.py</pre>

![](/IntroClassFiles/Tools/IntroClass/Spidertrap/startspidertrap.png)

Then visit the following site in a web browser:
<pre>http://[YOUR_LINUX_IP]:8000</pre> 

You should see a page containing randomly generated links. If you click on a link it will take you to a page with more randomly generated links.

![](/IntroClassFiles/Tools/IntroClass/Spidertrap/links.png)

![](/IntroClassFiles/Tools/IntroClass/Spidertrap/morelinks.png)

Example 2: Providing a List of Links
------------------------------------


For this example, we are going to start Spidertrap again, but this time, we are going to give it a file to generate its links.

>[!TIP]
>
>You may need to press ctrl+c to kill your existing Spidertrap session.

Now, let's start Spidertrap again but with the following options:

<pre>python3 spidertrap.py directory-list-2.3-big.txt</pre>

![](/IntroClassFiles/Tools/IntroClass/Spidertrap/startwithoptions.png)

Then visit http://<YOUR_LINUX_IP>:8000 in a web
browser. You should see a page containing links taken from the file. If
you click on a link it will take you to a page with more links from the
file.

![](Spidertrap_files/image003.png) ![](Spidertrap_files/image004.png)

Example 3: Trapping a Wget Spider
---------------------------------

Follow the instructions in [Example 1: Basic Usage] or
[Example 2: Providing a List of Links] to start Spidertrap. Then
open a new Kali Linux terminal and tell wget to mirror the website. Wget will run
until either it or Spidertrap is killed. Type Ctrl-c to kill wget.

`$` **`sudo wget -m http://127.0.0.1:8000`**

        --2013-01-14 12:54:15-- http://127.0.0.1:8000/

        Connecting to 127.0.0.1:8000... connected.

        HTTP request sent, awaiting response... 200 OK

        <<<snip>>>

        HTTP request sent, awaiting response... ^C


![image](https://github.com/user-attachments/assets/8369ef4c-1298-4321-a4b2-40a94cd2de16)


[Return To Lab List](https://github.com/strandjs/IntroLabs/blob/master/IntroClassFiles/navigation.md)


