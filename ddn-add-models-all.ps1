Clear-Host

$defaultValue = "my_pg"
"Enter a valid Connector name ('my_pg' for Postgres or 'my_graphql' for the custom GraphQL API"
$inputValue = Read-Host "Press Enter for '$defaultValue')"
if ([string]::IsNullOrWhiteSpace($inputValue)) {
    $inputValue = $defaultValue
}

# check to see if you are logged in to the DDN, if you are not logged in you
# will be prompted to login to get your PAT
ddn auth login

# you must be in the metadata folder for the commands to work correctly
Push-Location "./domain-services/ddn"

# add all tables from the my_pg datasource
# (https://github.com/hasura/ddn-docs/blob/main/docs/data-modeling/model.mdx)
ddn model add my_pg "*"

# add all relationships from the my_pg datasource, this only works for existing
# foreign key relationships, otherwise you will need to add the relationships 
# manually
# (https://github.com/hasura/ddn-docs/blob/main/docs/data-modeling/relationship.mdx)
ddn relationship add my_pg "*"

# permisions are added by default for Admin, any other Permissions must be manually
# updated in the ModelPermissions section of appropriate .HML file
# (https://github.com/hasura/ddn-docs/blob/main/docs/data-modeling/permissions.mdx)

# rebuild the build / update the DDN metadata and restart
# the engine's docker containers
ddn supergraph build local
ddn run docker-start -- -d

# return to the folder you started in
Pop-Location