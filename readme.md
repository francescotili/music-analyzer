# Music Analyzer

A powershell module for music manipulation, normalization and consolidation.

## Functions

To be implemented

## File supported

The script will search and analyze this type of files, at the moment:

```powershell
$SupportedExtensions = @("mp3", "MP3")
```

## Requirementes

- `ffmpeg.exe` copied in one the PATH folder of Windows

## Installation

1. Clone the repository _or download the latest `.zip` release_
2. Find the Powershell Module folder on your PC
   - The **PSModulePath** powershell environment variable (`$Env:PSModulePath`) contains the locations of Windows PowerShell modules. Cmdlets rely on the value of this einvornment variable to find modules.
   - By default, the _PSModulePath_ environment variable value contains three folder locations:
     1. `$PSHome\Modules` (`%Windir%\System32\WindowsPowerShell\v1.0\Modules`) -> this folder should remain reserved for Powershell modules that ships with Windows
     2. `$Home\Documents\WindowsPowerShell\Modules` (`%UserProfile%\Documents\WindowsPowerShell\Modules`) -> I've used this folder
     3. `$Env:ProgramFiles\WindowsPowerShell\Modules` (`%ProgramFiles%\WindowsPowerShell\Modules`)
3. Copy the module folder into the choosen Powershell Module folder. i.E. `%UserProfile%\Documents\WindowsPowerShell\Modules\music-analyzer\1.0.0`
4. Download `ffmpeg.exe` ([⬇ Download here](https://www.gyan.dev/ffmpeg/builds/)), extract and copy its `.exe` onto one of the `PATH` folder of Windows. Then rename it to `ffmpeg.exe` to enable usage from command line.
5. You will need to reopen a Cmdlet to let it find the newly installed module.

For additional informations on how to install Powershell Modules, refer to the [official guide](https://docs.microsoft.com/en-us/powershell/scripting/developer/module/installing-a-powershell-module?view=powershell-7.1).

## Usage

Use the command `MusicAnalyzer` to start the script.
