Clear-Host

# you must be in the metadata folder for the commands to work correctly
Push-Location "./domain-services/ddn"

# check to see if you are logged in to the DDN, if you are not logged in you
# will be prompted to login to get your PAT
ddn auth login

# rebuild the build / update the DDN metadata and restart
# the engine's docker containers
ddn supergraph build local
ddn run docker-start -- -d

# return to the folder you started in
Pop-Location