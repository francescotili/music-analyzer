Function MusicAnalyzer {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $false)]
    [switch]
    $cleanBackups = $false,

    [Parameter(Mandatory = $false)]
    [switch]
    $restoreBackups = $false
  )

  $flags = "$($cleanBackups)-$($restoreBackups)"

  switch ($flags) {
    "True-True" {
      # Both parameters -cleanBackups and -restoreBackups specified
      Write-Host " $($Emojis["ban"]) Incompatible flags specified!"
    }
    "True-False" {
      # -cleanBackups specified
      Clear-Host
      OutputScriptHeader "CleanBackups"
      CleanBackups
    }
    "False-True" {
      # -restoreBackups specified
      Clear-Host
      OutputScriptHeader "RestoreBackups"
      RestoreBackups
    }
    Default {
      # No parameters specified
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
    }
  }
}