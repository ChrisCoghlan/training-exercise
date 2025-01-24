function Get-Greeting {
    param (
        [string]$Name = "World"
    )
    return "Hello, $Name!"
}

function Get-DateInfo {
    return Get-Date -Format "yyyy-MM-dd HH:mm:ss"
}

function Parse-CsvFile {
    param (
        [string]$FilePath
    )
    $Headers = @("timestamp", "description", "state", "PID")
    if (Test-Path $FilePath) {
        return Import-Csv -Path $FilePath -Header $Headers
    } else {
        throw "File not found: $FilePath"
    }
}

Export-ModuleMember -Function Get-Greeting, Get-DateInfo, Parse-CsvFile