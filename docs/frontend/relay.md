# Relay

#### Optimistic Updates

Optimistic update is functionality provided by relay that boosts the perceived responsiveness of mutations. The data sent to the server is used to optimistically update the local relay store before receiving a response from the server in order to more quickly display the mutation effects in a way that assumes the mutation will succeed. Once a response is returned from the server, if the mutation results in an error the optimistic update that was applied to the local store is rolled back. If the mutation succeeds, any temporary optimistic data (ie IDs) will be replaced with the proper data from the server response. Details on how to configure updater and optimisticUpdater functions are detailed in the [Relay docs](https://relay.dev/docs/en/mutations#using-updater-and-optimisticupdater).

#### Debouncing Mutations

Idempotent mutations, for instance mutations that update an object, are candidates for being debounced.

We implemented a middleware for the relay network layer which will ensure that mutations that are dispatched in quick succession (the default debounce timeout is `250ms`) are debounced if needed. In order for the network layer to know which mutations to debounce, the client code should provide a `debounceKey`, is passed as a parameter to `BaseMutation.performMutation()`, which identifies the set of mutations that should be debounced together.
For instance, when updating our form results, we want to debounce the `update-form-result-mutation` based on the input `id`, which results in the following mutation code:

```ts
const m = new BaseMutation<updateFormResultMutationType>(
  "update-form-result-mutation"
);

return m.performMutation(
  environment,
  mutation,
  variables,
  optimisticResponse,
  null,
  `update-form-result${variables.input.id}` // the debounceKey
);
```

Including the `id` in the `debounceKey` ensures that, if the client dispatches two `update-form-result-mutation` for two different `formResult` objects, both mutations will be sent to the server side.

There are a couple of important features with our debounce middleware implementation:

- As the debouncing of mutations is done in the network layer, this means that the `optimisticResponse` does not get debounced, thus immediately updating the client-side relay state.
- For a given client, only one mutation can be debounced at a given time. This ensures that the order of mutations is preserved. For instance if a mutation with `debounceKey='a'` is dispatched, and a mutation with a different `debounceKey` (or no `debounceKey`) is dispatched within the debounce timeout, then the first mutation would be released by the debounce middleware before processing the second one.

### @Connection Directive

The @Connection Directive is a helpful, but poorly documented feature of Relay that helps to 'live update' results in the UI. The best documentation is in [this blogpost](https://www.prisma.io/blog/relay-moderns-connection-directive-1ecd8322f5c8), though it is still a bit outdated and non-comprehensive. There are two different scenarios where @connection needs different implementations:

1. The @connection is defined on a CHILD of an entity.
   EXAMPLE:

Fragment Definition:

```ts
export default createFragmentContainer(OrganisationsComponent, {
  query: graphql`
    fragment Organisations_query on Query {
      session {
        ciipUserBySub {
          id
          ciipUserOrganisationsByUserId(first: 2147483647)
            @connection(key: "Organisations_ciipUserOrganisationsByUserId") {
            edges {
              node {
                id
              }
            }
          }
        }
      }
  `,
});
```

- Notice that the @connection is defined on `ciipUserOrganisationByUserId` which is a child of the ciipUserBySub.
- This means the connection has a ciipUser parent.
- In this case the mutation configs needed to append to this connection can be defined as below.

Mutation definition:

```ts
const mutation = graphql`
  mutation createUserOrganisationMutation(
    $input: CreateCiipUserOrganisationInput!
  ) {
    createCiipUserOrganisation(input: $input) {
      ciipUserOrganisationEdge {
        node {
          ...UserOrganisation_userOrganisation
        }
      }
    }
  }
`;
```

- The return object inside the createCiipUserOrganisation is an object of ciipUserOrganisationEdge, that edge is used in the updater configs:

Mutation config definition:

```ts
const configs: DeclarativeMutationConfig[] = [
  {
    type: "RANGE_ADD",
    parentID: userId,
    connectionInfo: [
      {
        key: "Organisations_ciipUserOrganisationsByUserId",
        rangeBehavior: "append",
      },
    ],
    edgeName: "ciipUserOrganisationEdge",
  },
];
```

- The parentID is the ID of the parent ciipUser, which can be passed to the mutation as a parameter.
- The key is the key defined in the @connection portion of the fragment.
- type/rangeBehaviur is what to do with this edge (in this case, append).
- The edgeName is the edge to add (defined above in the mutation definition).

2. The @connection is defined at the root-level query:
   EXAMPLE:

Fragment Defintion:

```ts
export default createFragmentContainer(ProductList, {
  query: graphql`
    fragment ProductListContainer_query on Query {
      allProducts(first: $pageSize)
        @connection(key: "ProductListContainer_allProducts", filters: []) {
        edges {
          node {
            id
            ...ProductRowItemContainer_product
          }
        }
      }
    }
  `,
});
```

Some root-level @connection gotchas:

- Here the @connection is on the root-level `allProducts` query & thus has no parent entity.
- In this case, notice the @connection needs both the key AND a set of filters (which can be an empty array) in order to be found by relay.
- In our implementation, we have `query` as the root level entity that everything else falls under. All `query` entities have an id of `query` (This is needed in the mutation `RANGE CONFIG`).

The mutation definition remains unchanged from example 1. (productEdge will be the return object under createProductMutation).
The difference is in the mutation config defintion, where we passed a userID as the parentID in example 1, the parentID for a root-level @connection is `query`.
Mutation config definition:

```ts
const configs: DeclarativeMutationConfig[] = [
  {
    type: "RANGE_ADD",
    parentID: "query",
    connectionInfo: [
      {
        key: connectionKey,
        rangeBehavior: "append",
      },
    ],
    edgeName: "productEdge",
  },
];
```
