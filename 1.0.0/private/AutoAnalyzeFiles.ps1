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

  $fileList = Get-ChildItem -Path $workingFolder -File

  # Initialize progress bar variables
  $fileCompleted = 0
  $progress = 0
  $activity = "   ANALYZING FOLDER: $(($workingFolder.split("\"))[-1])"
  $fileNumber = $fileList.Count
  $etaStartTime = Get-Date

  # Start looping on all the files of the workingFolder
  $fileList | ForEach-Object {
    # Initialize progress bar
    $etaOutput = CalculateEtaOutput $etaStartTime $fileCompleted $fileNumber
    $progress = 100 * (($fileCompleted) / ($fileNumber))
    $barStatus = "{0:N1}% - Time remaining: {1}" -f $progress, $etaOutput
    $status = "{0:N1}%" -f $progress

    # Variables for the file
    $currentFile = @{
      fullFilePath = $_.FullName
      path         = Split-Path -Path $_.FullName -Parent
      name         = (GetFilename( Split-Path -Path $_.FullName -Leaf )).fileName
      extension    = (GetFilename( Split-Path -Path $_.FullName -Leaf )).extension
    }

    $fileCompleted += 1
    Write-Progress -Activity $activity -PercentComplete $progress -CurrentOperation "Analyzing $($currentFile.name).$($currentFile.extension) ..." -Status "$($barStatus)"
    Write-Host " $($fileCompleted)/$($fileNumber) | $($status) | $($currentFile.name).$($currentFile.extension) " -Background Yellow -Foreground Black

    $maxVolume = Get-VolumeInfo $currentFile
    if ($maxVolume -ne 0) {
      OutputVolumeAnalysis "adjustmentNeeded" $maxVolume
    }
    else {
      OutputVolumeAnalysis "noAdjustment"      
    }
    Write-Host ""
  }
}