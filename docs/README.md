# Stack Documentation and Style Guide

This document defines the interactions between the elements of the stack used by the CAS digital services team, the tools we use and the various style conventions used across the code base.
The choices documented here are defaults, meanining that they may be overriden in individual projects as needed.

## Stack Overview

- Local development tools
  - asdf
  - pre-commit
- Backend
  - [PostgreSQL](./backend/postgresql.md)
  - [Sqitch (schema migration tool)](./backend/sqitch.md)
  - [API generation with PostGraphile]
- Frontend
  - React
  - Relay
  - React JSONSchema Form
- Testing
  - [Unit testing with pgTap]
  -
- CI/CD
  - GitHub actions
  - Helm
  - Continuous deployment
- Version Control
  - Commit signing
  - Branching and merging model
  - [Peer review process](./version_control/pull-request-review-process.md)

### Express + PostGraphile

### Next.js (incl. React)

### Relay

### Typescript

### Yarn

We are using Yarn for package management as opposed to NPM. One of the advantages to using Yarn is the use of [resolutions](https://classic.yarnpkg.com/en/docs/selective-version-resolutions/). Resolutions can be used to specify package versions, which is helpful when addressing vulnerabilities in sub-dependencies. Using a glob pattern any package dependency or sub-dependency can be set to a specific version not affected by the vulnerability.

### Authentication and Authorization

Authentication is performed using the Red Hat SSO provider (Keycloak). We use the [`keycloak-connect`](https://github.com/keycloak/keycloak-nodejs-connect) package to manage authentication from our application server.

#### Session expiry

> In order to minimize the time period an attacker can launch attacks over active sessions and hijack them, it is mandatory to set expiration timeouts for every session, establishing the amount of time a session will remain active.
> -- [OWASP cheatsheet](https://github.com/OWASP/CheatSheetSeries/blob/master/cheatsheets/Session_Management_Cheat_Sheet.md#session-expiration)

Keycloak session timeouts are dictated by the `SSO Session Idle`, `SSO Session Max` and `Access Token Lifespan` configured in the keycloak realm. The keycloak session will automatically expire if there is no activity for the time specified in `SSO Session Idle`.

Our application client uses the `/session-idle-remaining-time` endpoint to check whether the session has automatically expired due to inactivity, and redirects the user to a login page, indicating that their session expired. Without that feature, the user would encounter an error on their next interaction with the page, as they would potentially trigger a request that requires them to be authenticated.

For every request, Our application server uses the `Grant.ensureFreshness` method to extend the session and ensures it does not idle. That method will only use the refresh token (and thus bump the `SSO Session Idle` timeout) if the access token is expired, which means that our idle timeout is technically `(SSO Session Idle) - (Access Token Lifespan)`.

## Documentation

### Tips for writing effective documentation

[Effective Documentation](./effectiveDocumentation.md)

### Writing to the database using Relay mutations

### React JsonSchema Forms

[rjsf documentation](https://react-jsonschema-form.readthedocs.io/en/latest/)

We use the react-jsonschema-form library to render many of our more complicated forms. The rjsf library makes our forms highly customizable. We override the default behaviour of the form components in several places to tailor the templated layouts and internal logic to our specific needs.

#### Custom template example

[custom templates](https://react-jsonschema-form.readthedocs.io/en/latest/advanced-customization/custom-templates/)
Example: app/containers/Forms/SummaryFormArrayFieldTemplate.tsx

Overriding a template is done by creating a new component with the appropriate rjsf props (in the example above, ArrayFieldTemplateProps) and redefining the template to suit specific needs. In the example above, we have rewritten the template to customize how each field in an array should be displayed when shown on the Summary page. We use some logic in the custom template to add display:none css to each field that has a value of zero to block those fields from rendering on the Summary page.

The custom template is applied by defining it in the props where the JsonSchemaForm is instantiated (see app/containers/Applications/ApplicationDetailsCardItem.tsx for where the example custom template above is applied).

#### Custom field example

[custom fields](https://react-jsonschema-form.readthedocs.io/en/latest/advanced-customization/custom-widgets-fields/)
Example: app/containers/Forms/FuelRowIdField.tsx

Overriding a field is done the same way as a template, by creating a new component with the appropriate rjsf props (in the example above we extend FieldProps). In the example we have customized the behaviour of the RowId field. This field is a numeric ID that corresponds to an enumerated list of fuel names. Our custom field makes use of [useMemo()](https://reactjs.org/docs/hooks-reference.html#usememo) to only render values when necessary and matches the ID with the corresponding name, rendering the name of the fuel in the list rather than the numerical ID.

A custom field is applied in the same way as the template, defining it in the props where the JsonSchemaForm is instantiated. This FuelRowId example is one of several custom fields we apply to this form, so we have wrapped all the customized fields in one component (see app/components/Application/ApplicationDetailsCardItemCustomFields.tsx) and passed that wrapper to be defined in the props (see app/containers/Applications/ApplicationDetailsCardItem for where this wrapper is applied).

## Style Guide

###

### Database naming conventions

Snake case. Don&#39;t use reserved words (c.f. style test)

### Front-end naming conventions

### \*status properties

When an entity has a 'status' context we create a new table (with a foreign key to the associated entity), type and computed_column function for the status.

- A separate table for the status allows us to keep the status rows immutable and create an audit trail that can be traced backwards to follow all the states an entity passed through as each status change is logged as a new row in the status table. Previous rows in the status table are immutable ensuring historical integrity.
- Creating a type associated with the status allows us to define an enum with only the pre-defined statuses as acceptable values.
- Since a new row in the status table is created on each status change, we use a computed column on the associated entity's table to return the latest status row for that entity. The computed column is an SQL function that receives an entity as a parameter and returns either a query (set of values) or a value. Relay then uses this function to add the results of the computed column to the shape of the entity. This results in an easily accessible status column on the entity whose value is derived from the status table and is always the current status.

### Organize next.js pages according to roles

### Use Guard Clauses

# Testing

### Linting

### Database unit tests

### Components unit tests

### Integration tests

### End-to-end testing

End-to-end tests run the entire stack, from the UI to the database, in a production build, to ensure that the flow of the deployed application performs well from start to finish.

Our end-to-end tests are written using Cypress, which allows us to interact with the browser and test that the expected elements are being displayed. The Cypress tests and configurations are located in the app/cypress directory. Reading through the cypress core concepts guide is strongly recommended before starting to write tests ([https://docs.cypress.io/guides/core-concepts/introduction-to-cypress.html#Cypress-Can-Be-Simple-Sometimes](https://docs.cypress.io/guides/core-concepts/introduction-to-cypress.html#Cypress-Can-Be-Simple-Sometimes))

#### Tools

- Cypress (https://www.cypress.io/)
- io (https://percy.io/)

#### Login flow and environment variables

Cypress allows developers to write custom commands (defined in app/cypress/support/commands.js). Two such commands that we implemented are cy.login(username, password) and cy.logout() . They allow us to log in the application using the Keycloak single-sign-on server deployed on Pathfinder. We created three test accounts on the realm used in this application, one for each user role.

A `cypress.env.json` file is available on the CAS Scrum team SharePoint (TODO: Should be moved to OpenShift). This file should be downloaded into the project&#39;s `app` folder. This file defines the username and passwords for the test users in environment variables, which can be retrieved using the cy.env(&#39;VAR_NAME&#39;) function.

#### Running end-to-end tests

- Start the database
- Deploy the development data using `.bin/deploy-data.sh -p -dev`
- Start the application using your favorite command. On CI, it will run it in production mode, with auth enabled. While developing, however, you can run `yarn dev NO_AUTH` in most cases
- The feature flag `yarn dev AS_CYPRESS` is available for running Cypress tests
- This flags enables mocking the current using using the `mocks.auth` cookie, allowing cypress tests to bypass authentication.
- Run `yarn cypress` to open the Cypress UI

#### Visual testing with Percy

Percy allow us to record screenshots of the application, using the `cy.percySnapshot()` method. Unless the tests are run using Percy, with `yarn test:e2e-snapshots`, which requires the PERCY_TOKEN environment variable to be defined (see the project settings here: [https://percy.io/bcgov-cas/cas-ciip-portal/settings](https://percy.io/bcgov-cas/cas-ciip-portal/settings)). Percy will be run on the CI server, once the end-to-end tests are successful, so you do not need to run them locally. Until the Percy GitHub integration is added in the bcgov org, our pull request review process will include a manual approval (see the Version Control, Mandatory peer review section).

#### Alternatives to Percy

We explored two alternatives to Percy:

- Using `cypress-plugin-snapshots` ([https://github.com/meinaart/cypress-plugin-snapshots](https://github.com/meinaart/cypress-plugin-snapshots)) and storing the files using Git LFS. The advantage is that developers can run snapshot tests and comparison locally. However, GitHub does not display the differences in the files stored with LFS in pull requests, which would make the review process difficult. Moreover, the LFS quota is for the entire organization.
- Applitools eyes ([https://applitools.com/](https://applitools.com/)) provides functionalities like Percy. However, its user interface isn&#39;t as intuitive, its API requires more configuration, and the GitHub integration isn&#39;t available with the free plan.

#### What to test with cypress

#### Data setup and teardown

#### Known Issues

- Cypress has an open issue[https://github.com/cypress-io/cypress/issues/4443] regarding dom snapshots and select tags where the value of the select is lost.
