function AutoAnalyzeFiles {
  <#
    .SYNOPSIS
      Completely automated AnalyzeFIles
    
    .PARAMETER workingFolder
      The folder to scan and to elaborate
  #>

  [CmdletBinding(DefaultParameterSetName)]
  param (
    [Parameter(Mandatory = $true)]
    [String]
    $workingFolder
  )
  
  Write-Host "Working main function"
  Write-Host "Folder passed:"
  Write-Host $workingFolder
}