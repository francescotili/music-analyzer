$global:Emojis = @{
  # Emoji list
  # https://unicode.org/emoji/charts/full-emoji-list.html
  #
  "check"    = [System.Char]::ConvertFromUtf32([System.Convert]::toInt32("2705", 16))
  "error"    = [System.Char]::ConvertFromUtf32([System.Convert]::toInt32("1F534", 16))
  "warning"  = [System.Char]::ConvertFromUtf32([System.Convert]::toInt32("1F7E8", 16))
  "ban"      = [System.Char]::ConvertFromUtf32([System.Convert]::toInt32("26D4", 16))
  "info"     = [System.Char]::ConvertFromUtf32([System.Convert]::toInt32("1F7E6", 16))
  "pen"      = [System.Char]::ConvertFromUtf32([System.Convert]::toInt32("1F4DD", 16))
  "delete"   = [System.Char]::ConvertFromUtf32([System.Convert]::toInt32("274C", 16))
  "volume"   = [System.Char]::ConvertFromUtf32([System.Convert]::toInt32("1F509", 16))
  "question" = [System.Char]::ConvertFromUtf32([System.Convert]::toInt32("2753", 16))
}

# PRIVATE FUNCTIONS
. $PSScriptRoot\private\AutoAnalyzeFiles.ps1
. $PSScriptRoot\private\CheckFileType.ps1
. $PSScriptRoot\private\CleanBackups.ps1
. $PSScriptRoot\private\GetVolumeInfo.ps1
. $PSScriptRoot\private\Helpers.ps1
. $PSScriptRoot\private\NormalizeVolume.ps1
. $PSScriptRoot\private\Outputs.ps1
. $PSScriptRoot\private\ProgressBar.ps1
. $PSScriptRoot\private\RestoreBackups.ps1

# PUBLIC FUNCTIONS
. $PSScriptRoot\public\MusicAnalyzer.ps1