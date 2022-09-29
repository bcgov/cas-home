# PostGraphile

### Database Views and PostGraphile

We use PostGraphile [smart comments](https://www.graphile.org/postgraphile/smart-comments/#constraints) in order to add constraints like primary and foreign keys to views (and types where necessary). Adding a primary key to a view or type via a smart comment makes views more 'table like', allowing postgraphile to add a [nodeId](https://www.graphile.org/postgraphile/node-id/) to that entity. This ID in turn is used by Relay's [GraphQL Global Object Identification Specification](https://relay.dev/graphql/objectidentification.htm) to uniquely identify, cache and refetch data.

Note: We use the PostGraphile `--classic-ids` flag to rename `nodeId` to `id` and the database `id` column to `rowId` as required by the Relay specification. Details [here](https://www.graphile.org/postgraphile/node-id/).

#### Mutation Chains

- Individual mutations can be chained on the front-end, but this approach does not effectively cover transactionality.
- To make all actions transactional (succeed as one block or fail as one block), Whenever a mutation has cascading effect we have written some custom mutation chains in the database
- For example: creating a new application in the ggircs_portal schema also requires (among other. things) the creation of a row in the application_status table.
- The creation of the row in the application table and the row in the application_status table is completed in one transactional block in a custom defined mutation chain function written in sql, which can then be used in place of the front-end chained mutations.
- Be careful to define the proper return type for any custom functions as an incorrect function return can cause the mutation to fail.
