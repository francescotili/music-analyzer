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
  for ($i = 0; $i -le 10; $i++) { Write-Host "" }
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