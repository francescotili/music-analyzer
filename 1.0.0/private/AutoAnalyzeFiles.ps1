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

    # Initialize file progress bar variables
    $fileCompleted = 0
    $fileNumber = $fileList.Count
    $fileActivity = " " # Leaved empty for output purpouse
    $fileProgressBar = [PRogressBar]::new($fileActivity, 1, $fileNumber)
    
    # Start looping on all the files of the workingFolder
    $fileList | ForEach-Object {
      # Variables for the file
      $currentFile = @{
        fullFilePath = $_.FullName
        path         = Split-Path -Path $_.FullName -Parent
        name         = (GetFilename( Split-Path -Path $_.FullName -Leaf )).fileName
        extension    = (GetFilename( Split-Path -Path $_.FullName -Leaf )).extension
      }

      $fileCompleted += 1
      $fileProgressBar.UpdateProgress("Analyzing $($currentFile.name).$($currentFile.extension) ...", $fileCompleted)
      Write-Host " $($fileCompleted)/$($fileNumber) | $($currentFile.name).$($currentFile.extension) " -Background Yellow -Foreground Black

      if ( (CheckFileType $currentFile) -eq 'Supported' ) {
        $maxVolume = Get-VolumeInfo $currentFile
        if ($maxVolume -ne 0) {
          OutputVolumeAnalysis "adjustmentNeeded" $maxVolume
          NormalizeVolume $currentFile $maxVolume
        }
        else {
          OutputVolumeAnalysis "noAdjustment"
        }
      }
      else {
        # File probably not supported
        OutputCheckFileType "unsupported"
      }

    
      Write-Host ""
    }
  }
}