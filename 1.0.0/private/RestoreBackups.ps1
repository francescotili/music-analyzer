function RestoreBackups {
  <#
    .SYNOPSIS
      Restore from the file generated as backup, deleting/overwriting original ones
    
    .PARAMETER workingFolder
      Required. The folder to scan and restore.
  #>

  [CmdletBinding(DefaultParameterSetName)]
  param (
    [Parameter(Mandatory = $true)]
    [String]
    $workingFolder
  )

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
}