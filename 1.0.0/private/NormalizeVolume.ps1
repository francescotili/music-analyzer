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
    fullFilePath = $inputFile.path + "\" + $inputFile.name + $outputSuffix + "." + $inputFile.extension
    path         = $inputFile.path
    name         = $inputFile.name + $outputSuffix
    extension    = $inputFile.extension
  }

  $params = @(
    "-i", $inputFile.fullFilePath,
    "-filter:a", "volume=$([string]($maxVolume * -1))dB",
    $outputFile.fullFilePath
  )

  # Check if outputfile already exists
  $i = 0
  while (Test-Path -path $outputFile.fullFilePath) {
    # Output fileName already exist, increment CopyNum
    $i += 1
    $copyNum = '{0:d3}' -f $i
    $newOutputFilename = "$($outputFile.name)+$($copyNum)"
    $outputFile.fullFilePath = $outputFile.path + "\" + $newOutputFilename + "." + $outputFile.extension
    $outputFile.name = $newOutputFilename
    write-Host $outputFile.fullFilePath
  }

  # Execute normalization
  # 2> $null is to cutoff output
  # ffmpeg $params 2> $null
}