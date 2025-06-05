# Synopsys
Project for running an example Haura project both fully locally and in a hybrid mode with the Hasura Cloud Console with all services running on your local workstation.

# running the local project
<!-- - open a console in VS Code using "git bash" instead of "PowerShell"
- run the following command in the console `./utils/build.sh domain-services` from the project root -->
- for the first time you run the project, or if you change anything (database or Hasura metadata) please run the `./build.ps1` command. If you just want to start the project run the `./start.ps1`, if you want to stop all the containers, but keep the volumes intact run the `./stop.ps1`. To wipe everything out and start from scratch, run the `./scorched-earth.ps1` command, if you want to re-run it all after doing that you'll need to run the `./build.ps1` command again.
- you have two options to view your GraphiQL UI
 - [Local Host](http://localhost:3280/) - run 100% from your local host, you will be able to explore, write, and run GraphQL queries
 - [Using the Hasura "Local" Web Console](https://console.hasura.io/local/graphql) - this will launch you into the Hasura website and give you the same functionality as the "Local Host" with some additional functionality, you will need to Authenticate to use this feature, please use a GMAIL account to authenticate.
 - To access Elasticsearch use the locally hosted click on the [Kibana](http://localhost:5601) link.

# Training and Informational Links
- [Local Development Examples with different DBs](https://github.com/hasura/ddn-examples/blob/main/README.md)
- [DDN CLI Installation](https://hasura.io/docs/3.0/reference/cli/installation/) - **REQUIRED** for Hasura Development going forward.
- [Hasura DDN VS Code Plugin](https://marketplace.visualstudio.com/items?itemName=HasuraHQ.hasura)

# Video Links
- [Setup Hasura DDN in under 1 minute speed run](https://www.youtube.com/watch?v=OsO6TzwFb30)
- [Hasura DDN Developer Experience (DX)](https://www.youtube.com/watch?v=PKt1WMPjq5w)
- [Local Development plus API Refinement](https://www.youtube.com/watch?v=WuyOhGThm8c)
- [Create Hasura generated REST APIs](https://www.youtube.com/watch?v=Iuxhjo7Ko9c)
= [GraphQL Federation (v2 Remote Schemas) as a connector in DDN](https://www.youtube.com/watch?v=LJBTBIOB44U)