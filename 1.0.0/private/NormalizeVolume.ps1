function NormalizeVolume {
  <#
    .SYNOPSIS
      This function normalize audio of the specified audio file, bringing it to gain 0 dB.
    
    .EXAMPLE
      NormalizeVolume $inputFile $maxVolume
    
    .PARAMETER inputFile
      Required. Complete file object to analyze.
    
    .PARAMETER maxVolume
      The detected max volume of the audio file
  #>

  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    $inputFile,

    [Parameter(Mandatory = $true)]
    [Float]$maxVolume
  )

  $outputSuffix = "_norm"
  $outputFile = @{
    fullFilePath = $inputFile.path + "\" + $inputFile.name + $outputSuffix + 
    "." + $inputFile.extension
    path         = $inputFile.path
    name         = $inputFile.name + $outputSuffix
    extension    = $inputFile.extension
  }
  Write-Host $inputFile.fullFilePath
  Write-Host ([math]::Round(($maxVolume * -1), 2))
  Write-Host $outputFile.fullFilePath

  $params = @(
    "-i", $inputFile.fullFilePath,
    "-filter:a", "volume=$([string]($maxVolume * -1))dB",
    $outputFile.fullFilePath
  )
  # TODO: Check if outputfile already exists

  # Execute normalization
  # 2> $null is to cutoff output
  # Warning: if output file already exist, the script could hang!
  # ffmpeg $params 2> $null
}