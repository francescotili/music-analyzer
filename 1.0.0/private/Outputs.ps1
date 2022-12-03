Function OutputScriptHeader {
  $title = @"
 _____________________________________________________
|                __  __           _                   |
|               |  \/  |         (_)                  |
|               | \  / |_   _ ___ _  ___              |
|               | |\/| | | | / __| |/ __|             |
|               | |  | | |_| \__ \ | (__              |
|               |_|  |_|\__,_|___/_|\___|             |
|                           _                         |
|         /\               | |                        |
|        /  \   _ __   __ _| |_   _ _______ _ __      |
|       / /\ \ | '_ \ / _' | | | | |_  / _ \ '__|     |
|      / ____ \| | | | (_| | | |_| |/ /  __/ |        |
|     /_/    \_\_| |_|\__,_|_|\__, /___\___|_|        |
|                              __/ |                  |
|                             |___/                   |
|                                                     |
|                                                     |
|           ~~ Welcome to Music Analzyer ~~           |
|          A script for music consolidation           |
|                                                     |
|                                                     |
|  Author: Francesco Tili                             |
|_____________________________________________________|
"@

  for ( $i = 0; $i -lt $title.Length; $i++ ) {
    Write-Host $title[$i] -NoNewline
  }
  Write-Host ""
  Write-Host ""
}

function OutputSpacer {
  for ($i = 0; $i -le 14; $i++) { Write-Host "" }
}

function OutputUserError {
  [CmdLetBinding(DefaultParameterSetName)]
  Param (
    [Parameter(Mandatory = $true)]
    [String]$Value
  )

  switch ($Value) {
    'invalidPath' { Write-Error -Message " $($Emojis["error"]) Specified path is not valid! Exiting..." -ErrorAction Stop }
    'emptyPath' { Write-Error -Message " $($Emojis["error"]) You have not specified a path. Exiting..." -ErrorAction Stop }
    Default {}
  }
}

function OutputVolumeAnalysis {
  [CmdletBinding(DefaultParameterSetName)]
  param (
    [Parameter(Mandatory = $true)]
    [String]$Value,

    [Parameter(Mandatory = $false)]
    [String]$fileName,

    [Parameter(Mandatory = $false)]
    [String]$Volume

  )

  if ( [float]$volume -ge 0 ) {
    [string]$stringVolume = "+{0:N1} dB" -f [float]$Volume
  }
  else {
    [string]$stringVolume = "{0:N1} dB" -f [float]$Volume
  }

  switch ($Value) {
    'noAdjustment' { Write-Host (" {0} {1} | {2}" -f $Emojis["check"], $stringVolume, $fileName ) }
    'adjustmentNeeded' { Write-Host (" {0} {1} | {2}" -f $Emojis["warning"], $stringVolume, $fileName ) }
    'noNormalizing' { Write-Host (" $($Emojis["check"]) No need to normalize, max volume is alread 0 dB at the album level") }
    'normalizing' { Write-Host " $($Emojis["volume"]) Normalizing ...    | $($fileName)" }
    'skipping' { Write-Host " $($Emojis["check"]) Already normalized | $($fileName)" }
    Default {}
  }
}

function OutputFolderAnalysis {
  [CmdletBinding(DefaultParameterSetName)]
  param (
    [Parameter(Mandatory = $true)]
    [String]$Value
  )

  switch ($value) {
    'noFiles' { Write-Host " $($Emojis["check"]) No supported files in this folder" }
    Default {}
  }
}

function OutputScriptFooter {
  Write-Host "                               " -BackgroundColor DarkGreen -ForegroundColor White
  Write-Host "     OPERATIONS  COMPLETED     " -BackgroundColor DarkGreen -ForegroundColor White
  Write-Host "                               " -BackgroundColor DarkGreen -ForegroundColor White

  (New-Object System.Media.SoundPlayer "$env:windir\Media\Alarm03.wav").Play()
  for ( $i = 0; $i -lt $completed.Length; $i++ ) {
    Write-Host $completed[$i] -NoNewline
  }
  Write-Host ""
  Write-Host ""
  Write-Host ""
}