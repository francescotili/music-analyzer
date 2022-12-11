function RestoreBackups {
  <#
    .SYNOPSIS
      Restore from the file generated as backup, deleting/overwriting original ones
  #>

  # Set the workingFolder
  $userPath = Read-Host ">> Please specify the path to restore"
  if ($userPath -ne "") {
    $userPath = $userPath -replace '["]', ''
    if (Test-Path -Path "$($userPath)") { RestoreFiles $userPath }
    else { OutputUserError "invalidPath" }
  }
  else { OutputUserError "emptyPath" }
}

function RestoreFiles {
  <#
    .SYNOPSIS
      This function search all the .backup files in the specified folder and its subfolders and then restore them
    
    .PARAMETER workingPath
      Required. The folder to scan
  #>
  [CmdLetBinding(DefaultParameterSetName)]
  Param (
    [Parameter(Mandatory = $true)]
    [String]$workingPath
  )

  $filesToRestore = Get-ChildItem -Path $workingPath -Filter "*.backup" -Recurse
  
  # Initialize file progress bar variables
  $fileCompleted = 0
  $fileNumber = $filesToRestore.Count
  $activity = "Restoring from backup files"
  $activityProgressBar = [ProgressBar]::new($activity, 0, $fileNumber)

  if ((-Not $global:AnalyzeOnlyActive) -and ($fileNumber -gt 0)) {
    $filesToRestore | ForEach-Object {
      # File object
      $currentFile = @{
        fullFilePath = $_.FullName
        path         = Split-Path -Path $_.FullName -Parent
        name         = (GetFilename( Split-Path -Path $_.FullName -Leaf)).fileName
        extension    = (GetFilename( Split-Path -Path $_.FullName -Leaf)).extension
      }

      # Delete converted file
      $fileCompleted += 1
      if ( Test-Path -Path "$($currentFile.path)/$($currentFile.name)" ) {
        $activityProgressBar.UpdateProgress("Deleting $($currentFile.name)", $fileCompleted)
        Remove-Item "$($currentFile.path)/$($currentFile.name)"
        OutputRestoreResult "converted_deleted" "$($currentFile.name)"
      }

      # Restore backup file      
      Rename-Item -Path $currentFile.fullFilePath -NewName "$($currentFile.name)"
      OutputRestoreResult "backup_restored" "$($currentFile.name)"
    }
    OutputRestoreResult "completed"
  }
  elseif ($global:AnalyzeOnlyActive -and ($fileNumber -gt 0)) {
    OutputRestoreResult "files_detected" $fileNumber
  }
  else {
    # No files found
    OutputRestoreResult "noFiles"
  }
}