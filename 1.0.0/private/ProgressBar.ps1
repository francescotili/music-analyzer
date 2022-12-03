class ProgressBar {
  $activity
  $id = 0
  $totalSteps
  $etaStartTime

  ProgressBar(
    [string]$activity,
    [int]$id,
    [int]$totalSteps
  ) {
    $this.activity = $activity
    $this.id = $id
    $this.totalSteps = $totalSteps
    $this.etaStartTime = Get-Date
  }

  [void] UpdateProgress($currentOperation, $completedSteps) {
    $percentComplete = ($completedSteps / $this.totalSteps) * 100
    $etaOputput = CalculateEtaOutput $this.etaStartTime ($completedSteps - 1) $this.totalSteps
    $status = "{0:N1}% - Time remaining: {1}" -f $percentComplete, $etaOputput

    Write-Progress -Activity $this.activity -Status $status -PercentComplete $percentComplete -CurrentOperation $currentOperation -Id $this.id
  }
}
