# Import logging functions
    . $PSScriptRoot\logging.ps1

# Get/Create logfile
    $Logfile = get-logfile -File "$PSScriptRoot\example-log.log"
# Set defaults 
    $PSDefaultParameterValues["add-logentry:File"]=$Logfile.FullName

add-logentry "This is a test of the emergency logcast system"
