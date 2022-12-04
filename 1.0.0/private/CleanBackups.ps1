function CleanBackups {
  <#
    .SYNOPSIS
      Remove the file generated as backup after normalizing
    
    .PARAMETER workingFolder
      Optional. The folder to scan and to clean. By default it uses the passed path, if present, otherwise it will ask the user.
  #>

  [CmdletBinding(DefaultParameterSetName)]
  param (
    [Parameter(Mandatory = $false)]
    [String]
    $workingFolder
  )

  # Analyze and set the workingFolder
  if ($workingFolder -ne "") {
    # Global working folder is passed - i.E. after normal workflow of analyzing
    $userChoice = Read-Host "$($Emojis["question"]) Would you like to delete *.backup files? All the subdirectories will be also cleaned! [s/n]"
    switch ($userChoice) {
      's' {
        Write-Host ""
        CleanFiles $workingFolder 
      }
      'n' { Read-Host " >> Ok, press enter to exit" }
      Default {
        # False input, do not delete backup files
        OutputUserError "invalidChoice"
      }
    }
  }
  else {
    # No global specified, ask the user
    $userPath = Read-Host ">> Please specify the path to clean"
    if ($userPath -ne "") {
      $userPath = $userPath -replace '["]', ''
      if (Test-Path -Path "$($userPath)") { CleanFiles $userPath }
      else { OutputUserError "invalidPath" }
    }
    else { OutputUserError "emptyPath" }
  }
}

function CleanFiles {
  <#
    .SYNOPSIS
      This function search all the .backup files in the specified folder and its subfolders, then deletes them
    
    .PARAMETER workingPath
      Required. The folder to scan
  #>
  [CmdLetBinding(DefaultParameterSetName)]
  Param (
    [Parameter(Mandatory = $true)]
    [String]$workingPath
  )

  # Analize provided path
  $filesToCleanup = Get-ChildItem -Path $workingPath -Filter "*.backup" -Recurse
  
  # Initialize file progress bar variables
  $fileCompleted = 0
  $fileNumber = $filesToCleanup.Count
  $activity = "Cleaning up backup files"
  $activityProgressBar = [ProgressBar]::new($activity, 0, $fileNumber)

  if ( $fileNumber -gt 0 ) {
    $filesToCleanup | ForEach-Object {
      # File object
      $currentFile = @{
        fullFilePath = $_.FullName
        path         = Split-Path -Path $_.FullName -Parent
        name         = (GetFilename( Split-Path -Path $_.FullName -Leaf)).fileName
        extension    = (GetFilename( Split-Path -Path $_.FullName -Leaf)).extension
      }

      # Deleting the file
      $fileCompleted += 1
      $activityProgressBar.UpdateProgress("Deleting $($currentFile.name).$($currentFile.extension)", $fileCompleted)
      Remove-Item $currentFile.fullFilePath
      OutputCleanResult "deleted" "$($currentFile.name).$($currentFile.extension)"
    }
    OutputCleanResult "completed"
  }
  else {
    # No files found
    OutputCleanResult "noFiles"
  }
}