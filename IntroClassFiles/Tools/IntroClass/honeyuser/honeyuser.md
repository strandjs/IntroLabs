![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)
 

# Honey User 

  

In this lab we will be setting up a poor persons SIEM with an "alert" generated whenever the Honey Account Frank is accessed. 

  

Why Frank? 

  

Because. 

  

Let's get started. 

  

First, we will need to create the users and the Frank account. 

Let's open a command prompt:

![image](https://github.com/user-attachments/assets/1abaf0d9-e8ed-4bfb-afab-1de17ad0f081)



Now, we will need to navigate to the C:\Tool directory and add the example users and Frank. 

  

`cd \IntroLabs` 

  

`200-user-gen.bat` 

  

It should look like this: 

  
![image](https://github.com/user-attachments/assets/d659078e-4504-4e8e-9800-b15db7aebb64)


  

Now, we need to create the Custom View in event viewer to capture anytime someone logs in as Frank. 

  

To do this click the Windows Start button then type Event Viewer. 

  

It should look like this: 

  

![](attachment/Clipboard_2021-03-12-11-16-35.png) 

  

When in the Event Viewer, select Windows Logs > Security then Create Custom View on the far-right hand side. 

  

It should look like this: 

  

![](attachment/Clipboard_2021-03-12-11-18-15.png) 

When Create Custom View opens, please select XML: 

  

![](attachment/Clipboard_2021-03-12-11-19-02.png) 

  

Then, select Edit query Manually, Press Yes on the Alert Box and then replace the text in the query with the text below: 

~~~~~~ 
<QueryList>
  <Query Id="0" Path="Security">
    <Select Path="Security">* [EventData[Data[@Name='TargetUserName']='Frank']]</Select>
  </Query>
</QueryList>

~~~~~~

It should look like this: 

  

![](attachment/Clipboard_2021-03-12-11-21-57.png) 

  

Now, press OK. 

  

When the Save Filter to Custom View box opens, name the filter Frank then press OK. 


When we click on our new View we will see the Events associated with the Frank Account Being Created: 

  

![](attachment/Clipboard_2021-03-12-11-24-20.png) 

  

Now, let's trip a few more. 

  

Back at your Windows Command Prompt 

  

  


`cd \IntroLabs`


 `powershell` 

  

 `Set-ExecutionPolicy Unrestricted` 

  

 `Import-Module .\LocalPasswordSpray.ps1` 

  

It should look like this: 

  
![image](https://github.com/user-attachments/assets/04441fb8-95ba-441c-8ccd-a18027b064da)


  

Now, let’s try some password spraying against the local system! 

  

  
`Invoke-LocalPasswordSpray -Password Winter2020` 

  

It should look like this: 

  ![image](https://github.com/user-attachments/assets/42e83694-5305-411e-bae8-b28f4cbb7598)



  

Now we need to clean up and make sure the system is ready for the rest of the labs: 

  

PS C:\IntroLabs> `exit` 

  

C:\IntroLabs> `user-remove.bat` 

  

![](attachment/Clipboard_2021-03-12-11-30-08.png) 

  

Now, let's see if any alerts were generated. 

  

Go back to your Event Viewer and refresh (Action > Refresh). 

  

You should see the "Alerts"! 

  

![](attachment/Clipboard_2021-03-12-11-32-18.png) 

  

Just for a bit of reference.  We did this locally as an example of setting this up on a full SIEM.  We did it in less than 20 min.  Your SIEM team working with your AD Ops team should be able to pull this off. 

[Return To Lab List](https://github.com/strandjs/IntroLabs/blob/master/IntroClassFiles/navigation.md)

  

 

 
