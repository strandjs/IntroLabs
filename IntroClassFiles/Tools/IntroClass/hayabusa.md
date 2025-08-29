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
```bash
docker run -it --rm -v /home/ubuntu/logs/:/data clausing/hayabusa eid-metrics --file /data/sysmon.evtx
```

<img width="1270" height="848" alt="image" src="https://github.com/user-attachments/assets/9744c36b-dc22-4cc5-bd28-4a9239758cd4" />


Important observations:
1. **Process Creation (ID 1 = 90%)**, that's extremely high volume, and now our primary hunting ground
2. **WMI Activity (IDs 19, 20, 21)**, rare in normal activities, could be remote execution
3. **Network Connections (ID 3)**, check what process made the connection, destination IP/port, and timing.<br><br>



- Now let's proceed with a **Full Timeline Analysis**
```bash
docker run -it --rm -v /home/ubuntu/logs/:/data clausing/hayabusa csv-timeline  --file /data/sysmon.evtx -o timeline.csv
```

>[!TIP]
>
>(include all rules)

Option choices displayed below:

<img width="1402" height="669" alt="image" src="https://github.com/user-attachments/assets/8bdc77a0-2391-4543-9ced-9d31b6bd11ed" />

Immediately we can see some really telling information, we got hits on 50 events(8.85%), 11 of them being critical alerts of a known backdoor and ransomware

Let's dig deeper

- We can also do some **Hunting Scenarios**, searching for special keywords
- 
```bash
docker run -it --rm -v /home/ubuntu/logs/:/data clausing/hayabusa search --file /data/sysmon.evtx --regex '(?i)(cmd\.e
xe|powershell|whoami|mimikatz)'
```

<img width="1405" height="66" alt="image" src="https://github.com/user-attachments/assets/b8485f59-a4d7-4982-804d-e56aa051eede" />

This is a run of Atomic Red Team so there will be a lot of data.






