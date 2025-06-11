docker compose -f ./domain-services/datasource/compose.yaml down -v
docker compose -f ./domain-services/ddn/compose.yaml down -v
docker image rm -f datasource-sample-gql:latest
docker image rm -f datasource-idp:latest