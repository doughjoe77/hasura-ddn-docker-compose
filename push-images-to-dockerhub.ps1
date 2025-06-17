# Kubernetes in Docker Desktop can't use the local repo, instead
# we're building images and pushing them to Docker Hub

# create IDP image and load it into k8ts
docker build -t datasource-idp:latest .\idp
#docker save datasource-idp:latest | kubectl apply -f -
docker tag datasource-idp:latest doughjoe77/datasource-idp:latest
docker push doughjoe77/datasource-idp:latest

# create custom GraphQL image
docker build -t datasource-sample-gql:latest .\idp
#docker save datasource-sample-gql:latest | kubectl apply -f -
docker tag datasource-sample-gql:latest doughjoe77/datasource-sample-gql:latest
docker push doughjoe77/datasource-sample-gql:latest