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
  $folderList = Get-ChildItem -Path $workingFolder -Directory -Recurse -ErrorAction SilentlyContinue -Force
  $folderList | ForEach-Object {
    $fileList = Get-ChildItem -Path $_.FullName -File
    $fileNumber += $fileList.Count
  }
  
  $fileList = Get-ChildItem -Path $workingFolder -File

  # Initialize progress bar variables
  $fileCompleted = 0
  $activity = "   ANALYZING FOLDER: $(($workingFolder.split("\"))[-1])"
  $fileNumber = $fileList.Count
  $fileProgressBar = [ProgressBar]::new($activity, 1, $fileNumber)

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
  }#>
}