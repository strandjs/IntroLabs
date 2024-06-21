

# Wireshark

Now that we have spent a little time working with tcpdump, let's take a look at Wireshark.

First, we need to make it clear, that Wireshark is not "better" than tcpdump.  They each have very strong pros and cons.  

Tcpdump is fast and very lightweight.  It is also scriptable.

But, it is CLI and to be honest, having some visualizations can be very, very helpful when dealing with large datasets.

But, Wireshark tends to give up and freeze on very large files.  Sometimes, we carve data out with tcpdump and open it in Wireshark.  Basically, it is key to learn and know both.

Let's get started.

First, either double click or right click + open the wireshark icon on the desktop:

![](attachments/wireshark_open.png)

Once Wireshark opens, go to File > Open

![](attachments/wireshark_fileopen.png)

Then, select magnitude_1hr in the Open Capture File box. The file is in the C:/IntroLabs folder if you cannot find it.

![](attachments/wireshark_opencapturefile.png)

When Wireshark opens, you will see packets represented in three different windows:

![](attachments/wireshark_windowcomplete.png)

The top window shows each individual packet in order:

![](attachments/wireshark_packetorder.png)

The second window shows a "decode" of any packet that is selected:

![](attachments/wireshark_decode.png)

Any of the lines with a > can be expanded:

![](attachments/wireshark_expandeddecode.png)

This means you do not have to memorize every possible packet and protocol value in hex...  Unless that is your thing.  If it is....  You must be Judy Novak, Mike Poor or Jonathan Ham. 

The last window is the hex for the packet:

![](attachments/wireshark_hex.png)

Hover over some hex in this window:

![](attachments/wireshark_hexselect.png)

Notice that when you do this, the corresponding data is also highlighted on the right side of the window.

This is very, very cool.  This means Wireshark can decode the hex on the fly and automatically highlight the relevant data instantly.

Ok, now, lets play with some statistics.

Please select Statistics > HTTP > Requests:

![](attachments/wireshark_statshttprequests.png)

This will show us the various HTTP requests for the capture:

![](attachments/wireshark_httprequests.png)

Now, let's look at Statistics > Conversations:

![](attachments/wireshark_conversations.png)

This will give us a breakdown of who was talking to whom:

![](attachments/wireshark_inconversations.png)

Please select IPv4:

![](attachments/wireshark_ipv4.png)

Then click on the top of the packets column twice:

![](attachments/wireshark_packetssort.png)

This gives us a breakdown of who was chatting with what system the most.  Click it again and it will sort the opposite direction and show you the least:

![](attachments/wireshark_packetsortlow.png)

Lets click the top of the packets column one more time to sort it by highest frequency.
Now, do we want to know what those systems were saying to each other? This can be done by right clicking on a conversation and selecting Apply as Filter > Selected > A<->B

![](attachments/wireshark_filter.png)

You should see the main Wireshark screen change

Then, close the Conversations window:

Notice the following in the filter bar

![](attachments/wireshark_appliedfilter.png)

In this instance, this is saying:

"IP address equals 192.168.99.52 AND IP address equals 68.183.138.51"

If a packet meets both of those critiera it is displayed:

![](attachments/wireshark_meetscriteria.png)

Now, right-click on any of the packets and select Follow > TCP Stream:

![](attachments/wireshark_followtcp.png)

This is showing the request (in red) and the response (in blue) between our two systems:

![](attachments/wireshark_tcpdata.png)

Anything look strange there?  If you look closely, there is a lot of encoded PowerShell.

Now, let's play with some basic filters in the filter bar.  We have already seen how Wireshark can filter on IP addresses.  But we can also filter on protocols.

To start, just type l.

Notice how Wireshark tries to help you with possible completion options as you type.

![](attachments/wireshark_autocomplete.png)

Now either finish typing llmnr, or scroll down to find it within the suggestions list as pictured above.

Then hit enter.

Notice that when you do this, Wireshark shows you all packets that are that protocol.

![](attachments/wireshark_llmnr.png)

Now try putting in ipv6 and hit enter:

![](attachments/wireshark_ipv6.png)

This allows you to very quickly drill in on any specific protocols you are reviewing in a packet capture.

Remember the PowerShell from tcpdump?  It had the string New-Object? Well, we can search though all the http traffic looking for that specific string:

Put the following into the filter bar:

<pre>http contains "New-Object"</pre>

![](attachments/wireshark_httpcontains.png)

With Wireshark, we can search through all our packets looking for specific strings and data.


















