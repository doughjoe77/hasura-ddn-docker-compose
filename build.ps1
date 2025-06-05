# Define Git Bash executable path
$GitBashPath = "C:\Program Files\Git\bin\bash.exe"

# Run a Git Bash command (example: check Git version)
$Command = "git --version"
& $GitBashPath -c $Command

# Run multiple commands
$Commands = "./utils/build.sh domain-services"
& $GitBashPath -c $Commands