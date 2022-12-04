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
    # Global working folder is set - i.E. after normal workflow of analyzing
    Write-Host "Found a global working folder"
  }
  else {
    # No global specified, ask the user
    Write-Host "Ask the user"
  }
}