![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)


In this lab we’ll use Scapy to demystify how network packets are assembled. The point isn’t to turn you into a Scapy wizard — it’s to give you a concrete, visual way to understand how packets are built, layer by layer, so you stop thinking about them as a single string of ones and zeros and start seeing them as stacked components.

What you’ll learn:

	•	How an IP packet contains a transport header (TCP/UDP) which in turn contains the application data.
	
	•	How Scapy represents those layers like Lego blocks you can stack, inspect, and manipulate.
	
	•	Basic packet creation, sending, and receiving with Scapy so you can see how the pieces fit together.
	

The core concept — packets as stacked components

Packets are not one monolithic blob. Think of them as a stack:

	•	The IP header is one layer.
	
	•	The payload of the IP header is the TCP or UDP header.
	
	•	The payload of the TCP/UDP header is the application data (HTTP, DNS, a custom payload, etc.).
	

Scapy makes those layers explicit. You can construct each layer independently and then combine them, inspect the fields of each layer, and watch how they nest — just like snapping Lego bricks together.

Why Scapy?

Scapy is a Python library for packet crafting and analysis. Its strength is the ability to treat packet layers as discrete objects you can manipulate programmatically. For learning, that’s gold: you can build a packet, change one field, and immediately see how the whole packet changes when you send it or display it.

What we’ll do in this lab:

	•	Build packets from the ground up using Scapy’s layer objects.
	
	•	Create TCP and UDP packets with simple application payloads.
	
	•	Send and receive those packets and observe how Scapy displays each layer.
	
	•	Experiment with changing header fields (for example TTL, ports, flags) to see the real effect on the assembled packet.
	

Expectations

This lab shows the broad strokes of what Scapy can do inside a Python environment. It’s a hands-on way to begin understanding packet structure by seeing actual packets assembled and dissected. It won’t make you an expert in every Scapy capability — but it will give you a solid foundation so you can continue exploring on your own.


In this lab we will be using the Kali VM.

Please open it by clicking on the Kali icon:

<img width="74" height="100" alt="image" src="https://github.com/user-attachments/assets/ab42c9a8-3161-465d-9939-f5c187d1b954" />




# Scapy

First, let's become root:

`sudo su -`

Now, start scapy

`scapy`

*Note, this can take a moment!!

<img width="663" height="366" alt="image" src="https://github.com/user-attachments/assets/bc0090ef-0663-4551-91ea-5d913946cad6" />

In this lab, we are building the most basic structure of a packet: the raw wireframe that must exist for traffic to move across a network. The goal is to start from the ground up using Scapy, beginning with an Ethernet frame and an IP header, then later attaching additional layers like ICMP. This exercise isn’t just about sending a packet—it’s about understanding how a packet is constructed and what each layer contributes to communication.

When you send data across a local network, the Ethernet frame is the first component that hits the wire. It includes source and destination MAC addresses and is used for communication across a local switch. In most environments, when a packet leaves your system headed for a remote IP address somewhere on the internet, the destination MAC address in the Ethernet frame is replaced with the MAC address of your default gateway. Essentially your router. Even though we don’t have much control over the Ethernet frame using Scapy, especially once it leaves our system, it still must be present for the packet to go anywhere at Layer 2.

Once the Ethernet frame is in place, we move to the IP header, which is where things start to get interesting. The IP header contains the essential routing and delivery information used by routers across the internet: source and destination IP addresses, Time to Live (TTL), version, flags, identification, and more. With Scapy, nearly all of these fields can be directly modified by simply assigning new values. This makes Scapy an ideal tool not only for packet crafting but also for truly learning how packets function by modifying real data structures.

Later in this lab, we will be changing the destination IP address to a fully qualified domain name: blackhillsinfosec.com. While that is not an IP address, Scapy is intelligent enough to automatically resolve domain names into IP addresses when constructing packets. This is a good example of how Scapy bridges low-level packet manipulation with the convenience of Python. Once the IP header is complete, we will attach an ICMP layer to the packet, which will allow us to send an echo request similar to a standard ping. From there, we can view the packet breakdown and see each individual layer stacked together exactly as it appears on the wire.

As we go forward, remember that the purpose of this exercise isn’t simply to send packets—it’s to understand them. By crafting raw packets piece by piece, we get to see how data actually travels and gain insight into the structure of network communication from the inside out. Let’s get started.

Let's create a raw packet!

`my_packet = Ether() / IP()`

`my_packet.show()`

<img width="262" height="325" alt="image" src="https://github.com/user-attachments/assets/b7b85f42-8686-4d3c-879e-6d346b376249" />

Let's ping BHIS.

`sr(IP(dst="www.blackhillsinfosec.com")/ICMP())`

<img width="470" height="118" alt="image" src="https://github.com/user-attachments/assets/485fd17a-c341-4c9a-b9f2-743db22e959b" />


We’ll send a simple SYN scan to port 80 on a remote host. While Nmap is faster and easier for port discovery, Scapey lets you embed scanning logic directly into Python scripts—useful when you want to find hosts with port 80 and programmatically probe them for specific content (for example, default web pages or identifying strings).

Now, let's do a port scan on port 80

`sr(IP(dst="45.33.32.156")/TCP(dport=80,flags="S"))`

<img width="440" height="125" alt="image" src="https://github.com/user-attachments/assets/a58d8d7e-e747-46ad-ab3d-e9e325337b68" />

We can scan a range of ports as well.

`unans, ans = sr(IP(dst="45.33.32.156")/TCP(dport=(1,100), flags="S"), timeout=1)`

<img width="878" height="161" alt="image" src="https://github.com/user-attachments/assets/1d81bdfc-c930-49e9-8217-9ec5b168086b" />

Let's look at the results.


`ans.summary()`
<img width="448" height="54" alt="image" src="https://github.com/user-attachments/assets/536a006b-35f0-4dd2-a849-510ee66882f0" />

`unans.summary()`
<img width="890" height="368" alt="image" src="https://github.com/user-attachments/assets/224141be-8287-4c7c-8ba4-12eaf242559c" />


Yes!  We can sniff!

`sniff(count=5).nsummary()`

<img width="576" height="109" alt="image" src="https://github.com/user-attachments/assets/c0fb61bc-f2eb-407b-95aa-1e92d5803195" />

Whant to look at some default packet templates?

`ls()`

<img width="411" height="190" alt="image" src="https://github.com/user-attachments/assets/0bbcbf3c-e901-4e68-b78d-3d794b97d3f8" />

Let's look at what we can modify in a TCP packet.

`ls(TCP)`

<img width="627" height="228" alt="image" src="https://github.com/user-attachments/assets/398458ee-79ac-43a5-96f4-7238325c876f" />

Let's try something like traceroute!

Start typing trace then hit tab

<img width="325" height="55" alt="image" src="https://github.com/user-attachments/assets/e6f3fcf4-60ab-4691-bf58-f99cfa49a8cd" />

It has autocomplete!!

`traceroute('google.com', maxttl=8, timeout=5)`

<img width="467" height="272" alt="image" src="https://github.com/user-attachments/assets/4f12160a-8ba3-448a-8287-48f2bfc7eb91" />

Let's create a DNS query packet.

`dns_query = IP(dst="8.8.8.8") / UDP(dport=53) / DNS(rd=1, qd=DNSQR(qname="www.example.com", qtype="A"))`

What makes up a DNS Packet?

`dns_query.show()`

<img width="412" height="694" alt="image" src="https://github.com/user-attachments/assets/d809b797-a7bb-4746-a674-b66f6a5234ce" />

Let's Send it!

`sr1(dns_query, timeout=2, verbose=0)`

<img width="663" height="225" alt="image" src="https://github.com/user-attachments/assets/b5cebae9-67a0-487a-a3de-78fe0fd8b5fd" />



<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
