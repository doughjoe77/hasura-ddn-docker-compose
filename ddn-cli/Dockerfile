FROM alpine:3.20

RUN apk add --no-cache curl bash

# Install Hasura DDN CLI using the official script
RUN curl -L https://graphql-engine-cdn.hasura.io/ddn/cli/v4/get.sh | bash

# Create a mountable directory for HML files
RUN mkdir -p /hml
WORKDIR /hml

ENTRYPOINT ["ddn"]
