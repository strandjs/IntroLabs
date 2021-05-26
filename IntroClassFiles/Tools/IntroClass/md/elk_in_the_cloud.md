#### ELK in the Cloud
---

*This is part one of a three-part series.*
	[Part Two](./elastic_agent.md "Elastic Agents")
	[Part Three](./sysmon_logs.md "Configuring Sysmon")

---

ELK combines three technologies and provides a powerful solution when working with large data sets.  In addition, we are able to setup SIEM rules to alert us as defenders to attacks on our organization.

* E - Elasticsearch
* L - Logstash
* K - Kibana

ELK enables defenders to detect attacks and conduct threat hunting.

To learn ELK, we don't need several servers or to spend large sums of money.  We can get into the driver's seat and experiment with ELK by using the Elastic Cloud 14-day trial.  The trial does not require a credit card to get started. You only need an email and a password.

**1. Set up an account.**

[Start your free Elastic Cloud Trial](https://cloud.elastic.co/registration?downloads=true&baymax=rtp&storm=nav-btn "https://cloud.elastic.co/registration?downloads=true&baymax=rtp&storm=nav-btn")


This link is for the trial sign up page. Start a trial by signing up.


![Signup page for Elastic Cloud](./images/cloud_signup.png)


Watch your email for a confirmation. The email will look something similar to this.


![Elastic Confirmation Email](./images/elastic_email.png)


Click "Verify and Accept."  You should be redirected to the cloud login page.  If you're not redirected, you can find it here.


[Elastic Cloud Log In](https://cloud.elastic.co/login "https://cloud.elastic.co/login")


After logging in, the page will look like this.


![First Landing Page](./images/first_landing.png)


**2. Start an ELK instance.**

Start by clicking "Start your free trial."

For our purposes, we want to start an Elastic Security instance.


![Selecting Elastic Secuirty](./images/select_security.png)


After selecting Security, scroll down. There are options to select custom settings and to name the deployment.  For this example, I will use the defaults. Click "Create deployment."


![Creating Delployment](./images/create_deployment.png)


Elastic will present the credentials for this ELK stack.  There is the option to download a CSV of the credentials. However you decide to hold onto these credentials, don't lose them.

<img src="./images/elastic_creds.png" alt="Elastic Credentials"/>

Now we have a complete and working instance of an ELK stack in which we can learn and experiment.

**3. Set up Fleet**

Kibana has a convenient feature called "Fleet." This feature enables users to easily add data to the ELK stack.

At the time of setting up the ELK instance, the "Open Kibana" option can be found here.


![Open Kibana](./images/open_kibana.png)


For future logins, access Kibana by using either of these links.


![Open Kibana](./images/open_kibana_2.png)

In the Kibana landing page, find the navigation menu.


![Kibana Landing](./images/kibana_landing.png)


Scroll to the bottom of the navigation menu and find "Fleet."


![Fleet Menu](./images/menu_fleet.png)


In the Fleet menu, find the "Agents" tab.


![Agents Tab](./images/agents_tab.png)


To activate Fleet, a central user needs to be enabled. Click "Create user and enable central management."


![Enable Central User](./images/enable_central_user.png)


Once a central user is enabled, the agents menu will look like this.


![Agents Menu](./images/agents_menu.png)


Select "Add agent."


![Add Agent](./images/add_agent.png)


A panel window will open.


![Panel Window](./images/panel_window.png)


Scroll to the bottom of the panel. At the bottom of the panel, there is a command that can be copied to the clipboard by clicking the button presented.


![Copy Command](./images/copy_command.png)


Hold onto this command.  It is recommended to paste this command into some file where you won't lose it. In this example, I saved it to a file I called "agent.txt."  We will use this command later.

<img src="./images/agent_txt.png" alt="Pasting information into agent_txt" style="zoom:67%;" />


The ELK stack is now configured and we have our connection information saved.
Part two will cover how to install and configure an Elastic Agent.

[Part Two](./elastic_agent.md "Elastic Agents")