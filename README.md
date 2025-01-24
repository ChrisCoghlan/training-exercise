# Log Monitoring Application - Training Exercise

## Overview
This is a PowerShell application designed to parse a CSV file, identify the jobs within and report on statuses. It includes a main script and a module for reusable functions.

## Project Structure
```
training-exercise
├── src
│   ├── main.ps1         # Entry point of the application
│   └── modules
│       └── module.psm1  # PowerShell module with custom functions
├── README.md            # Documentation for the project
└── .gitignore           # Files and directories to ignore by Git
```

## Getting Started

### Prerequisites
- PowerShell 5.1 or later

### Installation
1. Clone the repository:
   ```
   git clone https://github.com/ChrisCoghlan/training-exercise.git
   ```
2. Navigate to the project directory:
   ```
   cd training-exercise
   ```

### Running the Application
To run the application, execute the main script:
```
powershell -ExecutionPolicy Bypass -File .\src\main.ps1 -CsvFilePath "C:\path\to\file\logs.log"
```

## Testing Conducted
Application was developed and tested locally for script functionality. Additional entries were added to the log file to ensure they were correctly identified by the application, examples used:

08:14:20,scheduled task test-stuck, START,62922
08:14:20,scheduled task test-success, START,15871
08:18:20,scheduled task test-success, END,15871
08:14:20,scheduled task test-stuck, START,62922
08:14:20,scheduled task test-warn, START,15873
08:19:35,scheduled task test-warn, END,15873
08:14:20,scheduled task test-error, START,15879
08:39:35,scheduled task test-error, END,15879

## Suggested Improvements
1. The application currently matches jobs based on description, which in the sample file are unique and run only once. To improve reliability, and to capture what happens if a job runs more than once, the match should be on both description and PID.
2. The summary could also print which jobs had errors, warnings or had got stuck.