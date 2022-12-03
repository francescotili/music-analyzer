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

  # Build output file object
  $outputSuffix = "_norm"
  $outputFile = @{
    fullFilePath = "$($inputFile.path)\$($inputFile.name)$($outputSuffix).$($inputFile.extension)"
    path         = $inputFile.path
    name         = $inputFile.name + $outputSuffix
    extension    = $inputFile.extension
  }

  # Check if outputfile already exists
  $i = 0
  while (Test-Path -path $outputFile.fullFilePath) {
    # Output file already exist, increment CopyNum
    $i += 1
    $copyNum = '{0:d3}' -f $i
    $newOutputFilename = "$($inputFile.name + $outputSuffix)+$($copyNum)"
    $outputFile.fullFilePath = $outputFile.path + "\" + $newOutputFilename + "." + $outputFile.extension
    $outputFile.name = $newOutputFilename
  }

  # Build parameters for normalization
  $params = @(
    "-i", $inputFile.fullFilePath,
    "-filter:a", "volume=$([string]($maxVolume * -1))dB",
    $outputFile.fullFilePath
  )

  # Execute normalization
  # 2> $null is to cutoff output
  OutputVolumeAnalysis 'normalizing' $inputFile.name
  ffmpeg $params 2> $null

  # Build backup file object
  $backupSuffix = "backup"
  $backupFile = @{
    fullFilePath = "$($inputFile.path)\$($inputFile.name).$($inputFile.extension).$($backupSuffix)"
    path         = $inputFile.path
    name         = "$($inputFile.name).$($inputFile.extension)"
    extension    = $backupSuffix
  }
  
  # Check if backup file already exist
  $i = 0
  while (Test-Path -path $backupFile.fullFilePath) {
    # Backup file already exist, increment CopyNum
    $i += 1
    $copyNum = '{0:d3}' -f $i
    $newBackupFilename = "$($inputFile.name).$($inputFile.extension)+$($copyNum)"
    $backupFile.fullFilePath = "$($backupFile.path)\$($newBackupFilename).$($backupSuffix)"
    $backupFile.name = $newBackupFilename
  }

  # Rename original file to create a backup
  Rename-Item -Path $inputFile.fullFilePath -NewName "$($backupFile.name).$($backupFile.extension)"

  # Rename output file to input file
  Rename-Item -Path $outputFile.fullFilePath -NewName "$($inputFile.name).$($inputFile.extension)"
}