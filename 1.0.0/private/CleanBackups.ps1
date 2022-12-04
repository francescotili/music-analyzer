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
    # Write-Host "$($Emojis["info"]) $($workingFolder)"
    $userChoice = Read-Host "$($Emojis["question"]) Would you like to delete *.backup files? [s/n]"
    switch ($userChoice) {
      's' { CleanFiles $workingFolder }
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
  [CmdLetBinding(DefaultParameterSetName)]
  Param (
    [Parameter(Mandatory = $true)]
    [String]$workingPath
  )

  Write-Host "It works"
}