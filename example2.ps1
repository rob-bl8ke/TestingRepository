
<########################################################################################
Initialize required state
<########################################################################################>

$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition
Set-Location -Path $ScriptPath

<########################################################################################
Build Header
<########################################################################################>

function Show-Header {
    Clear-Host
    . $ScriptPath\_deploy\common\common.ps1
    Write-Host (Get-Header "Main Menu")
}

<########################################################################################
Build Deployment Menu
<########################################################################################>

function Show-Deployment-Menu {
    Show-Header

    Write-Host "1 xchangedocs-webclient (Deploy)"
    Write-Host "2 xchangedocs-webclient (Create Release Branch)"
    write-Host "3 xchangedocs-server (Deploy)"
    write-Host "4 xchangedocs-template-parser"
    Write-Host "q: Press 'q' to quit."
    Write-Host ""
}

function Set-Deployment-Version {
    $version = Read-Host "Enter version being deployed"
    return $version
}


function Set-Release-Branch-To-Origin {
    $version = Read-Host "Enter version being deployed"
    return $version
}

function Set-Release-Branch-To-Origin {
    . $ScriptPath\_deploy\common\common.ps1
    $writeToOrigin = Prompt-Continue "Do you want to upload the release branch to origin?`n - If testing you may just want keep things local!"
    return $writeToOrigin
}

function Set-Release-Branch-Strategy {
    $result = Read-Host @"
How do you want to handle the release branch?
    - Create a new one? (C) [Default]
    - Fetch an existing one matching the version? (F)
    - Use a local existing branch matching your version? (L)
"@

    switch ($selection)
    {
        'C' 
        { 
            return "new"
        } 
        'F' 
        { 
            return "fetch_existing"
        } 
        'L' 
        { 
            return "existing"
        } 
        default
        { 
            return "new"
        } 
    }
}


# function Get-Deployment-Inputs {
#     $version = Read-Host "Enter the deployment version"

#     . $ScriptPath\_deploy\common\common.ps1
#     $writeToOrigin = Prompt-Continue "Do you want to upload the release branch to origin?"
    
#    #
#    # TODO (Rob) Need to work out how this will be done.
#     # $releaseBranchStrategy = Prompt-Continue

#     return $version, $writeToOrigin    
# }

function Get-User-Deployment-Decision {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $version,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [bool] $writeToOrigin,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $releaseBranchStrategy
    )
    . $ScriptPath\_deploy\common\common.ps1
    $response = "Version: " + $version + "`nWrite back to origin: " + $writeToOrigin + "`nStrategy: " + $releaseBranchStrategy + "`n`tSure you'd like to continue?"
    return (Prompt-Continue $response) -eq $false
}

<########################################################################################
Program Flow
<########################################################################################>
do
 {
    Show-Deployment-Menu

    $selection = Read-Host "Please make a selection"  

    # NimbleText: '$rownumOne' { $projectPath = 'C:\Code\$0' } 
    switch ($selection)
    {
        '1' 
        { 
            $version = Set-Deployment-Version
            $writeToOrigin = Set-Release-Branch-To-Origin
            $releaseBranchStrategy = Set-Release-Branch-Strategy
            # $version, $writeToOrigin = Get-Deployment-Inputs
            # Write-Output $version
            $response = Get-User-Deployment-Decision -version $version -writeToOrigin $writeToOrigin -releaseBranchStrategy $releaseBranchStrategy

            if ($response -eq $false) { 
                # Write-Host "Starting deployment..."
                # Start-Sleep 20
                # Write-Host "... deploy successful."
                # &"$ScriptPath\_deploy\projects\xd-template-parser.ps1"
                &"$ScriptPath\_deploy\projects\xd-test.ps1" -version $version -writeToOrigin $writeToOrigin -releaseBranchStrategy $releaseBranchStrategy
            }
            pause
        } 
        '2' 
        { 
            $version = Set-Deployment-Version
            $writeToOrigin = Set-Release-Branch-To-Origin
            $releaseBranchStrategy = Set-Release-Branch-Strategy
            # $version, $writeToOrigin = Get-Deployment-Inputs
            # Write-Output $version
            $response = Get-User-Deployment-Decision -version $version -writeToOrigin $writeToOrigin -releaseBranchStrategy $releaseBranchStrategy

            if ($response -eq $false) { 
                # Write-Host "Starting deployment..."
                # Start-Sleep 20
                # Write-Host "... deploy successful."
                # &"$ScriptPath\_deploy\projects\xd-template-parser.ps1"
                &"$ScriptPath\_deploy\projects\xd-test.ps1" -version $version -writeToOrigin $writeToOrigin -releaseBranchStrategy $releaseBranchStrategy
            }
            pause
        } 
        '3' 
        { 
            $version = Set-Deployment-Version
            $writeToOrigin = Set-Release-Branch-To-Origin
            $releaseBranchStrategy = Set-Release-Branch-Strategy
            # $version, $writeToOrigin = Get-Deployment-Inputs
            # Write-Output $version
            $response = Get-User-Deployment-Decision -version $version -writeToOrigin $writeToOrigin -releaseBranchStrategy $releaseBranchStrategy

            if ($response -eq $false) { 
                # Write-Host "Starting deployment..."
                # Start-Sleep 20
                # Write-Host "... deploy successful."
                # &"$ScriptPath\_deploy\projects\xd-template-parser.ps1"
                &"$ScriptPath\_deploy\projects\xd-test.ps1" -version $version -writeToOrigin $writeToOrigin -releaseBranchStrategy $releaseBranchStrategy
            }
            pause
        } 
        '4' 
        { 
            $version = Set-Deployment-Version
            $writeToOrigin = Set-Release-Branch-To-Origin
            $releaseBranchStrategy = Set-Release-Branch-Strategy
            # $version, $writeToOrigin = Get-Deployment-Inputs
            # Write-Output $version
            $response = Get-User-Deployment-Decision -version $version -writeToOrigin $writeToOrigin -releaseBranchStrategy $releaseBranchStrategy

            if ($response -eq $false) { 
                # Write-Host "Starting deployment..."
                # Start-Sleep 20
                # Write-Host "... deploy successful."
                # &"$ScriptPath\_deploy\projects\xd-template-parser.ps1"
                &"$ScriptPath\_deploy\projects\xd-test.ps1" -version $version -writeToOrigin $writeToOrigin -releaseBranchStrategy $releaseBranchStrategy
            }
            pause
        } 
        'q' 
        { 
            "Quitting"
        }
        default
        {
            "Bad Selection"
            pause
        }
    }
 }
 until ($selection -eq 'q')

 Set-Location -Path $ScriptPath
