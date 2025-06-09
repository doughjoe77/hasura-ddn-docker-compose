const { ApolloServer, gql } = require('apollo-server');

// Define your GraphQL schema
const typeDefs = gql`
  type Query {
    hello: String
  }
`;

// Define resolvers for your schema
const resolvers = {
  Query: {
    hello: () => 'Hello from Apollo Server!',
  },
};

// Create the Apollo Server instance
const server = new ApolloServer({ typeDefs, resolvers });

// Start the server on port 4000
server.listen({ port: 4000 }).then(({ url }) => {
  console.log(`🚀 Server ready at ${url}`);
});
