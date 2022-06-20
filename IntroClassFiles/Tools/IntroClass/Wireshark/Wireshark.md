

# Wireshark

Now that we have spent a little time working with tcpdump, let's take a look at Wireshark.

First, we need to make it clear, that Wireshark is not "better" than tcpdump.  They each have very strong pros and cons.  

Tcpdump is fast and very lightweight.  It is also scriptable.

But, it is CLI and to be honest, having some visualizations is very, very helpful when dealing with large datasets.

But, Wireshark tends to give up and freeze on very large files.  Sometimes, we carve data out with tcpdump and open it in Wireshark.  Basically, it is key to learn and know both.

Let's get started.

First, select the Windows icon and type in wireshark:

![](attachments/Clipboard_2020-12-09-18-34-50.png)

Now select the Wireshark icon:

![](attachments/Clipboard_2020-12-09-18-35-25.png)

Now, select File > Open

![](attachments/Clipboard_2020-12-09-18-36-11.png)

Then, select magnitude_1hr in the Open Capture File box.  You may need to scroll down, it is at the bottom:

![](attachments/Clipboard_2020-12-09-18-37-14.png)

When Wireshark opens, you will see packets represented in three different windows:

![](attachments/Clipboard_2020-12-09-18-37-57.png)

The top window shows each individual packet in order:

![](attachments/Clipboard_2020-12-09-18-38-26.png)

The second window shows a "decode" of any packet that is selected:

![](attachments/Clipboard_2020-12-09-18-38-57.png)

Any of the lines with a > can be expanded:

![](attachments/Clipboard_2020-12-09-18-39-29.png)

This means you do not have to memorize every possible packet and protocol value in hex...  Unless that is your thing.  If it is....  You must be Judy Novak, Mike Poor or Jonathan Ham. 

The last window is the hex for the packet:

![](attachments/Clipboard_2020-12-09-18-40-47.png)

Click some hex in the bottom window:

![](attachments/Clipboard_2020-12-09-18-41-14.png)

Notice that when you select any of the hex in the bottom window it opens and highlights the corresponding data in the second window.

This is very, very cool.  This means Wireshark can decode the hex on the fly and automatically highlight the relevant data instantly.

Ok, now, lets play with some statistics.

Please select Statistics > HTTP > Requests:

![](attachments/Clipboard_2020-12-09-18-42-30.png)

This will show us the various HTTP requests for the capture:

![](attachments/Clipboard_2020-12-09-18-43-37.png)


Now, let's look at Statistics > Conversations:

![](attachments/Clipboard_2020-12-09-18-45-30.png)

This will give us a breakdown of who was talking to whom:

![](attachments/Clipboard_2020-12-09-18-46-16.png)

Please select IPv4:

![](attachments/Clipboard_2020-12-09-18-46-38.png)

Then click on the top of the packets column twice:

![](attachments/Clipboard_2020-12-09-18-47-21.png)

This gives us a breakdown of who was chatting with what system the most.  Click it again and it will sort the opposite direction and show you the least:

![](attachments/Clipboard_2020-12-09-18-48-14.png)

Really want to know what those systems were saying to each other?  Right click on a conversation and select Apply as Filter > Selected > A<->B

![](attachments/Clipboard_2020-12-09-18-49-33.png)

You should see the main Wireshark screen change

Then, close the Conversations window:

Notice the following in the filter bar

`ip.addr==68.183.138.51 && ip.addr==192.168.99.52`

![](attachments/Clipboard_2020-12-09-18-51-35.png)

This is saying:

"IP address equals 68.183.138.51 And IP address equals 192.168.99.52"

If a packet meets both of those critiera it is displayed:

![](attachments/Clipboard_2020-12-09-18-53-19.png)

Now, right-click on any of the packets and select Follow > TCP Stream:

![](attachments/Clipboard_2020-12-09-18-54-10.png)

This is showing the request (in red) and the response (in blue) between our two systems:

![](attachments/Clipboard_2020-12-09-18-55-09.png)

Anything look strange there?  If you look closely, there is a lot of encoded PowerShell.

Now, let's play with some basic filters in the filter bar.  We have already seen how Wireshark can filter on IP addresses.  But we can also filter on protocols.

To start, just type l.

Notice how Wireshark tries to help you with possible completion options as you type.

Now finish typing llmnr.

Then hit enter.

![](attachments/Clipboard_2020-12-11-08-57-52.png)

Notice that when you type llmnr and hit enter, Wireshark shows you all packets that are that protocol

Now try ipv6 and hit enter:

![](attachments/Clipboard_2020-12-11-08-58-47.png)

This allows you to very quickly drill in on any specific protocols you are reviewing in a packet capture.

Remember the PowerShell from tcpdump?  It had the string New-Object? Well, we can search though all the http traffic looking for that specific string:

Put the following into the filter bar:

http contains "New-Object"

![](attachments/Clipboard_2020-12-11-09-02-28.png)

With Wireshark, we can search through all our packets looking for specific strings and data.


















