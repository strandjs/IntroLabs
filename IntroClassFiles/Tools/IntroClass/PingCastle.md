# Ping Castle

In this lab we will be looking at ping castle.

Ping Castle is a fantastic tool that can be used to quickly identify security issues in Active Directory.

This is a “freeish” tool for local use. 

However, if you are going to use it in a commercial setting it needs to be paid for.

Which is not much of a problem as it is very affordable.

PingCastle operates by analyzing an AD environment and generating a security risk assessment report. It does this using several key methodologies:
1. Data Collection
	•	PingCastle gathers information from the AD environment using LDAP queries.
	•	It collects details about users, groups, domain controllers, policies, trust relationships, and security configurations.
	•	The tool does not require administrative privileges, making it non-intrusive.

2. Security Scoring & Risk Analysis
	•	The tool assigns a security score based on the AD configuration.
	•	It evaluates risk factors such as:
	◦	Aging objects (e.g., old, inactive accounts).
	◦	Privilege escalation risks (e.g., users with excessive permissions).
	◦	Weak configurations (e.g., poor password policies, weak delegation settings).
	◦	Trust relationships (e.g., insecure inter-domain trusts).

For this lab, we will be reviewing the following report:

https://www.pingcastle.com/PingCastleFiles/ad_hc_test.mysmartlogon.com.html

Review the report and answer the following questions.

1. Any systems with empty passwords? 	
2. Any accounts with passwords that never expire? 
3. What does Everyone and Anyone mean in Active Directory?
5. Any Everyone privs?
6. Any Old Passwords?





