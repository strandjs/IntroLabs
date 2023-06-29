# What has the attacker done with RMM access?

[*Download the log file to follow along*](./logs/Activities-rmm.csv)

At this point in our investigation it is becoming clear that the attacker didn't just compromise one machine, but may have compromised the entire domain.

An RMM (Realtime Monitoring and Management) is a tool that is used to remote manage and monitor workstations, most all rmms have the capabillity to access the CLI of a workstation and push automated scripts to assist an IT admin help push updates en mass.

Let's crack open the log and confirm out worst fears and suspicions.

![rmm execution](./images/fullpwn.PNG)

It is worth noting the lack of logs here, thats because these RMM logs are mostly recording things that itself does. It is not logging the data from the computer its connected to, and we see that a script has recently been run.

It looks like the attacker has pushed a script to execute  malware on every machine with the RMM tool running on it, including the domain controller.

This means that it is safe to assume that every single machine on the network is compromised, this is not good.

This small breach has just become a huge disaster and will need escalation and Incident Response.
