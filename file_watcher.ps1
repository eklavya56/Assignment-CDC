# PowerShell script to monitor for new files and auto-commit/push to GitHub

# Define the folder to monitor
$folderPath = "C:\Users\eklav\OneDrive\Desktop\assignment"

# Create a FileSystemWatcher
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $folderPath
$watcher.Filter = "*.*"  # Monitor all files
$watcher.IncludeSubdirectories = $false
$watcher.EnableRaisingEvents = $true

# Define the action to take when a file is created
$action = {
    $path = $Event.SourceEventArgs.FullPath
    $changeType = $Event.SourceEventArgs.ChangeType
    Write-Host "File $path was $changeType"

    # Change to the directory
    Set-Location $folderPath

    # Add the new file to Git
    git add $path

    # Commit the changes
    $fileName = [System.IO.Path]::GetFileName($path)
    git commit -m "Add new file: $fileName"

    # Push to GitHub
    git push origin master
}

# Register the event
Register-ObjectEvent $watcher "Created" -Action $action

# Keep the script running
Write-Host "Monitoring for new files in $folderPath. Press Ctrl+C to stop."
while ($true) { Start-Sleep 1 }
