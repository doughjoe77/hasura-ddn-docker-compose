# Synopsys
Project for running an example Haura project both fully locally and in a hybrid mode with the Hasura Cloud Console with all services running on your local workstation. It also shows how you can take Hasura 2.0 compliant YAML and convert that to Hasura DDN (or vice-versa) compliant YAML for any one-to-one feature matches.

# running the local project
- for the first time you run the project, or if you change anything (database or Hasura metadata) please run the `.\build.ps1` command. If you just want to start the project run the `.\start.ps1`, if you want to stop all the containers, but keep the volumes intact run the `.\stop.ps1`. To wipe everything out and start from scratch, run the `.\scorched-earth.ps1` command, if you want to re-run it all after doing that, you'll need to run the `.\build.ps1` command again. If you want to also use Hasura 2.0, run the `.\hasura20\load-metadata.ps1` command after running `.\build.ps1` from a seperate console.
- you have two options to view your GraphiQL UI
  - [Local Host](http://localhost:3280/) - run 100% from your local host, you will be able to explore, write, and run GraphQL queries
  - [Using the Hasura "Local" Web Console](https://console.hasura.io/local/graphql) - this will launch you into the Hasura website and give you the same functionality as the "Local Host" with some additional functionality, you will need to Authenticate to use this feature, please use a GMAIL account to authenticate. If you want to edit Hasura Metadata in a UI verusus using the YAML only approach (add new permissions, database objects, connections, etc.) I have included a [Hasura 2.0](http://localhost:8080) engine to do this editing in a graphical format. There are instructions in this document further down on how to take the metadata generated and convert that over to Hasura DDN compliant YAML.
 - To access Elasticsearch use the locally hosted click on the [Kibana](http://localhost:5601) link.
 - To access a SQL Editor for Postgres, you can click on the [PG Admin](http://localhost:8889/browser/) link.

# using Hasura 2.0 to develop for Hasura DDN
While Hasura 2.0 has a robust UI for development (adding connectors, database objects, authorization, actions, remote schemas, etc.); Hasura DDN **ONLY** has an option for using YAML files to do the same type of work. Due to that, this project loads both Hasura 2.0 AND Hasura DDN and allows you to develop in 2.0 for DDN by exporting the 2.0 YAML files and converting them to DDN compliant YAML files. The following scripts are used to make this happen leveraging the Hasura 2.0 CLI:
- `.\hasura20\load-metadata.ps1` - script will load 2.0 metadata contained in the `./hasura20/metadata` directory into the Hasura 2.0 instance running locally at http://localhost:8080, if you are running the project for the first time and want to load the Hasura 2.0 instance with metadata, run this command ***AFTER*** running `.\build.ps1`
- `.\hasura20\export-metadata.ps1` - script exports the current 2.0 metadata into a YAML files structure found under ./hasura20/metadata
- `.\hasura20\convert20-to-ddn.ps1` - script will take the 2.0 metadata and convert it to Hasura DDN metadata where the feature parity is a one-to-one match; ***THIS IS A Work-in-progress currently***
- `.\hasura20\convertddn-to-20.ps1` - script will take the ddn metadata and convert it to Hasura 2.0 metadata where the feature parity is a one-to-one match; ***THIS IS A Work-in-progress currently***

# Sample GraphQL Queries
Just as a note, there are very ***slight*** differences between Hasura 2.0 and DDN GraphQL queries, the queries below return the same results but have a slightly different syntax.
- Sample Hasura DDN Query
```gql
query CustomersDDNQuery {
  customers(
    where: {lastName: {_ilike: "Jo%"}}
    limit: 35
    order_by: {firstName: Asc}
  ) {
    firstName
    lastName
    email
    ordersAggregate {
      _count
    }
  }
}
```
- Sample 2.0 Query (Hasura 2.0)
```gql
query Customers20Query {
  # 2.0 has a slighlty different syntatax for the order by statement
  customers(where: {lastName: {_ilike: "Jo%"}}, limit: 35, orderBy: {firstName: ASC}) {
    firstName
    lastName
    email
    ordersAggregate {
      # 2.0 has a slightly different syntax for aggregate queries
      aggregate {
        count
      }
    }
  }
}
```
- Sample Query 3 (Hasura 2.0, Remote Schema Custom GraphQL API)
```gql
query States20Query {
  states
}
```

# DDN CLI Cheatsheat
Quick collection of available DDN commands as of 6/2025, you can also run the command `ddn connector --help` to get more detailed help for a specific option.

| Command              | Description                                                                                     | Example Usage                                                        |
|----------------------|-------------------------------------------------------------------------------------------------|----------------------------------------------------------------------|
| **auth**             | Manage authentication—log in or log out of the Hasura DDN CLI.                                  | `ddn auth login`                                                     |
| **supergraph**       | Manage your Hasura DDN supergraph (project configuration, deployment, etc.).                    | `ddn supergraph init my-project`                                     |
| **connector**        | Handle connector-related operations such as initialization and schema introspection.            | `ddn connector init my_connector`<br>`ddn connector introspect my_connector`<br>`ddn connector show-resources my_connector` |
| **connector-link**   | Manage DataConnectorLink operations to link data sources.                                       | `ddn connector-link create my_link`                                  |
| **model**            | Manage data models (the equivalent of tables/entities in your schema).                          | `ddn model list`                                                     |
| **relationship**     | Define and manage relationships between models (e.g., array or object relationships).            | `ddn relationship create orders_customers`                           |
| **subgraph**         | Perform operations on subgraphs—useful when modularizing your API into separate graph sections.  | `ddn subgraph add my_subgraph`                                       |
| **codemod**          | Run codemod transformations to refactor or migrate your project’s configuration and metadata.     | `ddn codemod run`                                                    |
| **run**              | Execute a custom script defined in your project's context.                                      | `ddn run seed`                                                       |
| **completion**       | Generate autocompletion scripts for your shell (bash, zsh, etc.).                                 | `ddn completion bash`                                                |
| **plugins**          | Manage CLI plugins that extend the core functionality of the DDN CLI.                           | `ddn plugins install plugin-name`                                    |
| **config update-cli**| Update the Hasura DDN CLI to the latest (or a specified) version.                               | `ddn config update-cli --version latest`                             |
| **version**          | Show the current version of the Hasura DDN CLI.                                                 | `ddn version`                                                        |
| **help**             | Display help information for a command or the CLI as a whole.                                   | `ddn help` or `ddn [command] --help`                                   |


# Training and Informational Links
- [Local Development Examples with different DBs](https://github.com/hasura/ddn-examples/blob/main/README.md)
- [DDN CLI Installation](https://hasura.io/docs/3.0/reference/cli/installation/) - **REQUIRED** for Hasura DDV Development
- [Hasura DDN VS Code Plugin](https://marketplace.visualstudio.com/items?itemName=HasuraHQ.hasura)

# Video Links
- [Setup Hasura DDN in under 1 minute speed run](https://www.youtube.com/watch?v=OsO6TzwFb30)
- [Hasura DDN Developer Experience (DX)](https://www.youtube.com/watch?v=PKt1WMPjq5w)
- [Local Development plus API Refinement](https://www.youtube.com/watch?v=WuyOhGThm8c)
- [Create Hasura generated REST APIs](https://www.youtube.com/watch?v=Iuxhjo7Ko9c)
= [GraphQL Federation (v2 Remote Schemas) as a connector in DDN](https://www.youtube.com/watch?v=LJBTBIOB44U)

