
# Memory Analysis

In this lab we will be looking at a memory dump of a compromised system.  We will first need to decompress it and then use Volatility to look at the network connections and process information for the malware.

Please keep in mind that we are using a free tool for this lab.  While Volatility is great, it does have some limitations.  Specifically in the area of network PIDs.  So, while we are using Volatility, the same concepts can also be applied to any commercial tools you may be using in your environment as well.

To get started, we first need to extract the memory dump using 7zip.

To do this, first open file explorer and navigate to the memory dump and extract it.

First, click on the file explorer icon:

![](attachments/Clipboard_2020-12-09-14-10-04.png)

Next, select the tools folder:

![](attachments/Clipboard_2020-12-09-14-10-53.png)

Now, select the volatility_2.6_win64_standalone directory:

![](attachments/Clipboard_2020-12-09-14-11-23.png)

Next, right click on the memdump file and then select 7-Zip and then Extract Here.  Please note that the file name does not end with 7z on the left display column.  However, on the far right column you can see it is a 7Z file.:

![](attachments/Clipboard_2020-12-09-14-12-09.png)

Now we have it extracted!  Let's open a command prompt and look at it with Volatility!

Please note this memory dump was created from VMWare snapshot feature. There are multiple tools like winpmem and FTK Imager that can also create memory dumps.

To start, we will be working with the Ubuntu-18.04 Prompt in Windows Terminal.   This is on your desktop and can be opened by right-clicking it and selecting Run as administrator then selecting Ubuntu-18.04 from the down carrot menu:

Now we need to extract Volatility:

<pre>
adhd@DESKTOP-I1T2G01:~$ cd /mnt/c/IntroLabs/
adhd@DESKTOP-I1T2G01:/mnt/c/IntroLabs$
adhd@DESKTOP-I1T2G01:/mnt/c/IntroLabs$ tar xvfz ./volatility3-1.0.0.tar.gz
</pre>











