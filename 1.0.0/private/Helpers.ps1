function Set-Path {
  <#
    .SYNOPSIS
      This function ask the user for the path to be analyzed and save it as a global variable
  #>
  
  $Path = Read-Host "Please specify the folder to analyze"
  
  if ($Path) {
    # Path has been specified
    $WorkingPath = $path -replace '["]', ''    
    if (-Not(Test-Path -Path "$WorkingPath")) {
      # Path not valid
      OutputUserError "invalidPath"
    }
    else {
      # Valid path
      return $WorkingPath
    }
  }
  else {
    # No path specified
    OutputUserError "emptyPath"
  }
}

function CalculateEtaOutput {
  <#
    .SYNOPSIS
      This functions calculate estimated remaining time to complete an operation
    
    .PARAMETER startTime
      The start time of the operation
    
    .PARAMETER itemCompleted
      Number of completed single items
    
    .PARAMETER itemTotal
      Total number of items to be elaborated
   #>

  [CmdletBinding(DefaultParameterSetName)]
  param (
    [Parameter(Mandatory = $true)]
    [DateTime]
    $startTime,
       
    [Parameter(Mandatory = $true)]
    [Int32]
    $itemCompleted,
       
    [Parameter(Mandatory = $true)]
    [Int32]
    $itemTotal
  )

  $output = ""
  $now = Get-Date

  if ( $itemCompleted -gt 0) {
    # Calculate remaining time
    $elapsed = $now - $startTime
    $speed = $elapsed.TotalSeconds / $itemCompleted
    $timeLeft = New-TimeSpan -Seconds (($itemTotal - $itemCompleted) * $speed)

    # Build output string
    if ($timeLeft.Days -gt 0) {
      if ($timeLeft.Days -gt 1) {
        $output += "$($timeLeft.Days) days "
      }
      else {
        $output += "$($timeLeft.Days) day"
      }
    }
    if ($timeLeft.Hours -gt 0) {
      if ($timeLeft.Hours -gt 1) {
        $output += "$($timeLeft.Hours) hours "
      }
      else {
        $output += "$($timeLeft.Hours) hour"
      }
    }
    if ($timeLeft.Minutes -gt 0) {
      if ($timeLeft.Minutes -gt 1) {
        $output += "$($timeLeft.Minutes) minutes "
      }
      else {
        $output += "$($timeLeft.Minutes) minute"
      }
    }
    if ($timeLeft.Seconds -gt 0) {
      if ($timeLeft.Seconds -gt 1) {
        $output += "$($timeLeft.Seconds) seconds "
      }
      else {
        $output += "$($timeLeft.Seconds) second"
      }
    }
  }

  return $output
}

function GetFilename {
  <#
    .SYNOPSIS
      Extract the filename removing the extension
    
    .EXAMPLE
      $response = GetFilename($filename);
      $name = $response.name
      $extension = $response.extension
    
    .PARAMETER File
      Required. The complete name of the file with extension. Do not pass a relative or absolute path
  #>

  [CmdletBinding(DefaultParameterSetName)]
  param (
    [Parameter(Mandatory = $true)]
    [String]$file
  )
  
  $pattern = "(.+?)(\.[^.]*$|$)"

  # Match the file with pattern
  $regMatches = [regex]::Matches($file, $pattern)

  # Return the filename and extension
  return @{
    fileName  = $regMatches.Groups[1].Value
    extension = ($regMatches.Groups[2].Value).replace('.', '')
  }
}