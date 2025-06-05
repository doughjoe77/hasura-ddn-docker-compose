# take down the data sources, when start is run again any changes made in the databases
# will remain unless a "./scorched_earth.ps1" was run
docker compose -f ./domain-services/datasource/compose.yaml down 
# take down Hasura DDN, all metadata will remain unless a "./scorched_earth.ps1" was run
docker compose -f ./domain-services/ddn/compose.yaml down 