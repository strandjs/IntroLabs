# For the Ubuntu VM

## The objective of this lab is to use Hayabusa to analyze Sysmon logs and detect suspicious activity related to process creation, network connections, and authentication events.

Let's become root:

`sudo su -`

Let's make a directory for our logs

`mkdir logs`

`cd logs`

Let's also get the logs that we will be working with and rename them:

```bash
curl -L -o sysmon.evtx https://raw.githubusercontent.com/sbousseaden/EVTX-ATTACK-SAMPLES/master/AutomatedTestingTools/PanacheSysmon_vs_AtomicRedTeam01.evtx
```

```bash
mv PanacheSysmon_vs_AtomicRedTeam01.evtx sysmon.evtx
```

- First thing we will do to start disecting the logs is to get some basic **metrics** to understand what system the logs came from, number of events, time range.

```bash
docker run -it --rm -v /home/ubuntu/logs/:/data clausing/hayabusa log-metrics --file /data/sysmon.evtx
```

<img width="1475" height="579" alt="image" src="https://github.com/user-attachments/assets/832e0c7e-fb52-4495-85db-965e02a077a5" />

- Next let's see the Event **ID Distribution** to dentify common or suspicious Sysmon events, we are looking for **1**, **3**, **10**, **11** or even **8**



<img width="1270" height="848" alt="image" src="https://github.com/user-attachments/assets/9744c36b-dc22-4cc5-bd28-4a9239758cd4" />




