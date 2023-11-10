# NimbleText
# [PSCustomObject]@{ Num = $rownumOne; Section = "$0"; SectionGroup = "Section Group A"; Course = "AZ-400" },

$courseObjects = @(
[PSCustomObject]@{ Num = 1; Section = "Explore Azure Pipelines"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 2; Section = "Manage Azure Pipeline Agents and Pools"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 3; Section = "Describe Pipelines and Concurrency"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 4; Section = "Explore Continuous Integration"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 5; Section = "Implement Pipeline Strategy"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 6; Section = "Integrate with Azure Pipelines"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 7; Section = "Introduction to GitHub Actions"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 8; Section = "Learn Continuous Integration with GitHub Actions"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 9; Section = "Design a Container Build Strategy"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 10; Section = "Introduction to Continuous Delivery"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 11; Section = "Create a Release Pipeline"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 12; Section = "Explore Release Recommendations"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 13; Section = "Provision Test Environments"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 14; Section = "Manage and Modularize Tasks and Templates"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 15; Section = "Automate Inspection of Health"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 16; Section = "Introduction to Deployment Patterns"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 17; Section = "Implement Blue-Green Deployment Feature Toggles"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 18; Section = "Implement Canary Releases and Dark Launching"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 19; Section = "Implement AB Testing and Progressive Explosure Deployment"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 20; Section = "Integrate with Identity Management Systems"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 21; Section = "Manage Application Configuration Data"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 22; Section = "Explore Infrastructure as Code and Configuration Management"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 23; Section = "Create Azure Resources Using ARM Templates"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 24; Section = "Create Azure Resources by using Azure CLI"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 25; Section = "Explore Automation with DevOps"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 26; Section = "Implement Desired State Configuration"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 27; Section = "Implement BICEP"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 28; Section = "Explore Package Management Dependencies"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 29; Section = "Understand Package Management"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 30; Section = "Migrate Consolidating and Secure Artifacts"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 31; Section = "Implement Versioning Strategy"; SectionGroup = "Section Group C"; Course = "AZ-400" },
[PSCustomObject]@{ Num = 32; Section = "Introduction to GitHub Packages"; SectionGroup = "Section Group C"; Course = "AZ-400" }
)

$commandLines = @()

function MakeValidLinuxDirectoryName($folderName) {
    $validChars = [regex]::Escape('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_')
    $output = ($folderName -replace "[^$validChars]+", "-").TrimStart("-")
    return $output
}

$scriptPath = $MyInvocation.MyCommand.Path
$scriptDirectory = (Split-Path -Parent $scriptPath)
$rootDirectory = (Resolve-Path (Join-Path -Path $scriptDirectory -ChildPath "Sylabus")).Path

$existingFolders = @()

foreach ($course in $courseObjects) {
    $line = "qikconsole gen simple -f ./project.json -i ""Num=$($course.Num);Section=$($course.Section);SectionGroup=$($course.SectionGroup);Course=$($course.Course)"""

    $sectionFolder = "{0:D3}-{1}" -f $course.Num, ($course.Section -replace ' ', '-')
    $sectionFolder = $sectionFolder.ToLower()
    $sectionFolder = MakeValidLinuxDirectoryName $sectionFolder

    $sectionGroupFolder = ($course.SectionGroup -replace ' ', '-')
    $sectionGroupFolder = $sectionGroupFolder.ToLower()
    $sectionGroupFolder = MakeValidLinuxDirectoryName $sectionGroupFolder

    $combinedSectionFolder = Join-Path -Path $rootDirectory -ChildPath $sectionGroupFolder | Join-Path -ChildPath $sectionFolder    

    $commandLineObject = [PSCustomObject]@{
        CommandLine = $line
        SectionFolder = $combinedSectionFolder
        Num = $course.Num
        Section = $course.Section
        SectionGroup = $course.SectionGroup
        Course = $course.Course
    }

    $commandLines += $commandLineObject

    if (Test-Path -Path $commandLineObject.SectionFolder -PathType Container) {
        $existingFolders += $commandLineObject.SectionFolder
    }
}

if ($existingFolders.Count -gt 0) {
    Write-Host "The following Section Folders already exist:" -ForegroundColor Red
    $existingFolders | ForEach-Object { Write-Host $_ -ForegroundColor Red }
    Write-Host "Script terminated."
} else {
    foreach ($cmdLine in $commandLines) {
        Write-Host "Command Line: $($cmdLine.CommandLine)"
        Write-Host "Section Folder: $($cmdLine.SectionFolder)"
        Write-Host "Num: $($cmdLine.Num)"
        Write-Host "Section: $($cmdLine.Section)"
        Write-Host "SectionGroup: $($cmdLine.SectionGroup)"
        Write-Host "Course: $($cmdLine.Course)"
        Write-Host "..."
        Write-Host

        if (-not (Test-Path -Path $cmdLine.SectionFolder -PathType Container)) {
            Write-Host "Creating directory: $($cmdLine.SectionFolder)"
            New-Item -Path $cmdLine.SectionFolder -ItemType Directory -Force
        }

        $mindMapTemplatePath = Join-Path -Path $scriptDirectory -ChildPath "generate-folders-mindmap-template.txt"
        $mindmapPath = Join-Path -Path $cmdLine.SectionFolder -ChildPath "main-mindmap.plantuml"
        Copy-Item -Path $mindMapTemplatePath -Destination $mindmapPath -Force

        $mindmapContent = Get-Content -Path $mindmapPath -Raw

        $modifiedMindmapContent = $mindmapContent -replace '@{Title}', "$($cmdLine.Course)\n$($cmdLine.SectionGroup) - $($cmdLine.Section)"
        $modifiedMindmapContent = $modifiedMindmapContent -replace '@{Caption}', "$($cmdLine.Course) - $($cmdLine.Section)"
        $modifiedMindmapContent = $modifiedMindmapContent -replace '@{Footer}', "..."
        $modifiedMindmapContent = $modifiedMindmapContent -replace '@{RootNode}', "\n$($cmdLine.Section)"

        $modifiedMindmapContent | Set-Content -Path $mindmapPath

        $filesToCreate = @(
            "main-content.md",
            "main-questions.md",
            "main-summary.md"
        )

        foreach ($file in $filesToCreate) {
            $filePath = Join-Path -Path $cmdLine.SectionFolder -ChildPath $file
            Write-Host "Creating file: $filePath"
            New-Item -Path $filePath -ItemType File -Force
        }
    }
}
