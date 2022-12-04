Function MusicAnalyzer {
  [CmdletBinding(DefaultParameterSetName)]
  param (
    [Parameter(Mandatory = $false)]
    [switch]
    $cleanBackups = $false
  )

  if ( $cleanBackups ) {
    Clear-Host
    OutputScriptHeader "CleanBackups"
    CleanBackups
  }
  else {
    # Show script header
    Clear-Host
    OutputScriptHeader
    
    # Ask for path
    $workingFolder = Set-Path
    Clear-Host
    OutputSpacer
    AutoAnalyzeFiles $workingFolder
    OutputScriptFooter

    # Start cleanup workflow
    CleanBackups $workingFolder

    # Delete workingFolder global variable
    $WorkingFolder = ""
  }
}