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

  # Detect total number of files
  $fileNumber = 0
  $folderListObj = Get-ChildItem -Path $workingFolder -Directory -Recurse -ErrorAction SilentlyContinue

  # Create an array of folder paths
  $folderList = [System.Collections.ArrayList]::new()
  $folderListObj | ForEach-Object {
    $folderList.Add($_.FullName) 1> $null
  }
  $folderList.Add($workingFolder) 1> $null # Include also $working Folder

  # Initialize folder progress bar variable
  $folderCompleted = 0
  $folderNumber = $folderList.Count
  $folderActivity = "   WORKING ON YOUR MUSIC FILES"
  $folderProgressBar = [ProgressBar]::new($folderActivity, 0, $folderNumber)

  # Start looping on all the folders
  foreach ($folderPath in $folderList) {
    $folderCompleted += 1
    $folderName = Split-Path -Path $folderPath -Leaf
    $folderProgressBar.UpdateProgress("Analyzing folder: $($folderName)", $folderCompleted)
    Write-Host " Now analyzing folder: $($folderName) " -Background DarkYellow -Foreground Black

    $fileList = Get-ChildItem -Path $folderPath -File
    $fileNumber = $fileList.Count

    if ($fileNumber -gt 0 ) {
      # Initialize file progress bar variables
      $fileCompleted = 0
      $fileActivity = " " # Leaved empty for output purpouse
      $fileProgressBar = [ProgressBar]::new($fileActivity, 1, $fileNumber * 2)
    
      # Analyzing-Block
      $volumeAnalysis = [System.Collections.ArrayList]::new()
      Write-Host " Analyzing volume ... " -Background Yellow -Foreground Black
      $fileList | ForEach-Object {
        # Variables for the file
        $currentFile = @{
          fullFilePath = $_.FullName
          path         = Split-Path -Path $_.FullName -Parent
          name         = (GetFilename( Split-Path -Path $_.FullName -Leaf )).fileName
          extension    = (GetFilename( Split-Path -Path $_.FullName -Leaf )).extension
        }

        $fileCompleted += 1
        $fileProgressBar.UpdateProgress("Analyzing $($currentFile.name).$($currentFile.extension)", $fileCompleted)

        # Volume Analysis
        if ( (CheckFileType $currentFile) -eq 'Supported' ) {
          $maxVolume = Get-VolumeInfo $currentFile
          if ($maxVolume -ne 0) {
            OutputVolumeAnalysis "adjustmentNeeded" "$($currentFile.name).$($currentFile.extension)" $maxVolume
            $volumeAnalysis.Add(@{
                file      = $currentFile
                maxVolume = $maxVolume
                normalize = $true
              }) 1> $null
          }
          else {
            OutputVolumeAnalysis "noAdjustment" "$($currentFile.name).$($currentFile.extension)" $maxVolume
            $volumeAnalysis.Add(@{
                file      = $currentFile
                maxVolume = $maxVolume
                normalize = $false
              }) 1> $null
          }
        }
      }

      # Find minimum volume_max
      $maxVolumeGain = -100
      foreach ($analysis in $volumeAnalysis) {
        if ($analysis.maxVolume -gt $maxVolumeGain) {
          $maxVolumeGain = $analysis.maxVolume
        }
      }
      Write-Host ""
    
      # Normalizing block
      Write-Host " Normalizing files ... " -Background Yellow -Foreground Black
      if ($maxVolumeGain -eq 0) {
        OutputVolumeAnalysis "noNormalizing"
      }
      else {
        foreach ($analysis in $volumeAnalysis) {
          $fileCompleted += 1
          $fileProgressBar.UpdateProgress("Normalizing $($currentFile.name).$($currentFile.extension)", $fileCompleted)

          if ( $analysis.normalize ) {
            #OutputVolumeAnalysis "normalizing" $analysis.file.name
            NormalizeVolume $analysis.file $maxVolumeGain
          }
          else {
            OutputVolumeAnalysis "skipping" $analysis.file.name
          }
        }      
      }
      Write-Host ""
    }
    else {
      OutputFolderAnalysis "noFiles"
      Write-Host ""
    }
  }
}