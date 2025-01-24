# Main entry point for the PowerShell application

param (
    [string]$CsvFilePath
)

# Import the module
Import-Module -Name ".\src\modules\module.psm1"

# Main script logic
Write-Host "Log Monitoring Application"

# Check if the CSV file path is provided
if (-not $CsvFilePath) {
    Write-Host "Please provide the path to the CSV file using the -CsvFilePath parameter."
    exit
}

# Parse the CSV file
try {
    $csvData = Parse-CsvFile -FilePath $CsvFilePath
    Write-Host "CSV Data:"
    $csvData | Format-Table -AutoSize

    # Track start and end times of each job
    $jobs = @{}
    foreach ($row in $csvData) {
        $description = $row.description
        $timestamp = [datetime]::Parse($row.timestamp)
        $state = $row.state

        if ($state -eq "start") {
            if (-not $jobs.ContainsKey($description)) {
                $jobs[$description] = @{}
            }
            $jobs[$description].Start = $timestamp
        } elseif ($state -eq "end") {
            if ($jobs.ContainsKey($description)) {
                $jobs[$description].End = $timestamp
                $jobs[$description].Duration = $jobs[$description].End - $jobs[$description].Start
            }
        }
    }

    # Initialize counters for summary
    $jobStuckCount = 0
    $jobErrorCount = 0
    $jobWarningCount = 0
    $jobSuccessCount = 0

    # Output the tracked jobs and produce the report
    Write-Host "Tracked Jobs:"
    foreach ($job in $jobs.GetEnumerator()) {
        $description = $job.Key
        $start = $job.Value.Start
        $end = $job.Value.End
        $duration = $job.Value.Duration
        Write-Host "Job: $description"
        Write-Host "  Start: $start"
        Write-Host "  End: $end"
        Write-Host "  Duration: $duration"

        # Produce the report
        if (-not $start -or -not $end) {
            Write-Host "  Status: Job stuck"
            $jobStuckCount++
        } elseif ($duration.TotalMinutes -gt 10) {
            Write-Host "  Status: Error - Job took longer than 10 minutes"
            $jobErrorCount++
        } elseif ($duration.TotalMinutes -gt 5) {
            Write-Host "  Status: Warning - Job took longer than 5 minutes"
            $jobWarningCount++
        } else {
            Write-Host "  Status: Job completed successfully"
            $jobSuccessCount++
        }
    }

    # Output the summary
    Write-Host "Summary:"
    Write-Host "  Jobs stuck: $jobStuckCount"
    Write-Host "  Jobs with errors: $jobErrorCount"
    Write-Host "  Jobs with warnings: $jobWarningCount"
    Write-Host "  Jobs completed successfully: $jobSuccessCount"

} catch {
    Write-Host "Error: $_"
}

# Additional script logic can be added here