# PostgreSQL schema migration with Sqitch

We manage our database with [sqitch] via the sqitch.plan, usually located in our repository's `/schema` directory.
If you're new to Sqitch, the best place to start is with [the tutorial](https://sqitch.org/docs/manual/sqitchtutorial/) and other [docs](https://sqitch.org/docs/).

To add something to the database:

- `sqitch add <new database entity> --require <dependency for new entity> --set schema=<schema>` (--require can be repeated for many dependencies)
  To deploy changes:
- `sqitch deploy <Name of change>` (Name of change is optional, & deploys up to that change. If not set, it will deploy all changes)
  To roll back changes:
- `sqitch revert <Name of change>` (Name of change is optional, & reverts back to that change. If not set, it will revert all changes)

## Changes naming convention

When adding a sqitch change to create an object, we follow the `<object_type>/<object_name>` naming convention, where `<object_type>` is one of the following:

- `schemas`: we shouldn't need to add more than the public and private schemas
- `tables`: all tables go in there
- `types`: all composite or enum types go in there.
- `functions`: for functions that would result in a [postgraphile custom query](https://www.graphile.org/postgraphile/custom-queries/)
- `computed_columns`: for functions that would result in a [postgraphile computed column](https://www.graphile.org/postgraphile/computed-columns/)
- `mutations`: for [custom mutations](https://www.graphile.org/postgraphile/custom-mutations/)
- `trigger_functions`: for any function returning a trigger
- `util_functions`: for any function used primarily to increase code reuse, either in the public or private schema
- `views`: all views go in there

## Incremental Database changes

To identify which changes are released in production environments and therefore are immutable, we rely on sqitch tags: changes that are above a tag (a line starting with `@`, e.g.: `@v1.0.0-rc.7 2020-06-18T18:52:29Z database user <db_user@mail.com> # release v1.0.0-rc.7`) in the `sqitch.plan` file should be considered immutable.

Once a change is released, updating the deploy script is not possible. To update the object, the following options are available:

### Tables (or other non-idempotent changes)

The naming convention should be `<name_of_original_change>_00x_<short_description_of_change>`
Changes to tables require creating a new entry in the sqitch plan for that table, for example:
`sqitch add tables/application_001_add_some_column --require tables/application`
This will create a deploy,revert and verify files for tables/application_001

- In the deploy file, any necessary changes can be made to the table with `alter table`.
- In the revert file, any changes made in the deploy file must be undone, again with `alter table`
- The verify file should just verify the existence of the table, and can probably be the same as the original verify file

### Functions (or other idempotent changes)

Changes to functions are done via the [`sqitch rework`] command, which only works with idempotent changes, e.g `create or replace function`.
example: `sqitch rework -c <NAME OF FILE TO BE CHANGED>`
This will create deploy, revert and verify files, for the changed item like so: `function_file_name@TAG.sql`
The `TAGGED` files should contain the original deploy, revert, verify code.
The `UNTAGGED` files will contain the changes:

- The deploy file will contain the updated function code
- The revert file will contain the original, (or in the case of several changes, the previous) function code to return the function to its previous state
- The verify file will likely be the same as the original verify file

[`sqitch rework`]: (https://sqitch.org/docs/manual/sqitch-rework/)
[sqitch]: https://sqitch.org/docs/manual/sqitchtutorial/

## Database change management tool review

In 2019, we reviewed several tools which would allow us to handle database migrations. The following features were considered required for the tool:

- The tool should support migration scripts written in SQL and PL/PGSQL
- The tool should allow us to define releases following semantic versioning
- The tool should be able to handle failing migrations, and deploy migrations in a transaction

The two tools we analyzed in depth are sqitch ([https://sqitch.org/](https://sqitch.org/)) and Flyway ([https://flywaydb.org/](https://flywaydb.org/)).

### Migrations and releases

In database change management tools, a migration is a set of SQL commands creating, deleting or altering a set of database object. In both sqitch and flyway, migrations can be stored in SQL files. Additionally, flyway supports writing migrations in Java files, for more complex processes.

The mechanism used to define the migrations order is different for both tools.

- Sqitch uses a &quot;plan&quot; file, listing the migrations names in the order in which they should be deployed, and their dependencies. The sqitch tag command allows to cut releases
- Flyway uses version numbers, stored in the file name, e.g. _V1.44.23.76\_\_migration_description.sql_ for &quot;versioned migrations&quot; and supports &quot;repeatable migrations&quot; (filename starting with &quot;R\_\_&quot;), which are executed after all the versioned migrations are deployed, in order of their descriptions (e.g. _R\_\_0001_viewA.sql_, then _R\_\_0002_viewB.sql_)

### Reverting migrations

_Note: although the ability to revert migrations was a requirement in our initial assessment, we are yet to make use of this feature in production in over 3 years of use. CI guardrails and QA have ensured that no so-called "bad" release reaches the production enviroment. The ability to revert migrations is however useful in local development, to quickly revert and redeploy migrations as they are being worked on_

In development and test environments, reverting migrations is required to start from a clean database. In production, this can be needed to undo a &quot;bad&quot; release.

- For both use cases, sqitch requires the developer to write a &quot;revert&quot; migration for each &quot;deploy&quot; migration they write (a sqitch &quot;change&quot; has as _deploy_, a _revert_, and a _verify_ file)
- For dev/test environments, Flyway has a &quot;clean&quot; command that deletes all the objects in the schemas managed by Flyway. For production reverts, the &quot;pro&quot; version of Flyway supports &quot;undo&quot; migrations, but this could be accomplished by deploying another release with migrations that undo the changes.

### Handling Errors in Migrations

Errors occurring during the migrations are common in dev and test environments, due to bugs in the migration files. They can also occur in production if, for instance, there are issues connecting to the database.

Flyway handles errors by wrapping each migration in a transaction. Optionally, the entire set of migrations being deployed can be wrapped in a single transaction by setting the _group_ property to _true_.

Sqitch makes use of the verify scripts to ensure that a migration is deployed. If a migration fails, it will revert the previous migrations that were deployed in the current run, using the revert script. Sqitch does not wrap migrations in transactions, requiring the developer to add begin and commit/rollback statements to each script. Additionally, sqitch does not support wrapping the entire set of migrations in a single transaction. Furthermore, it does not reuse the connection to the database, making it very sensitive to DNS issues. Such issues have even led to the database and the sqitch changelog to be in inconsistent state, requiring manual fixes, because executing a migration and adding it to the database changelog is not done in a transaction.

### Other tools

Other tools such as alembic ([https://alembic.sqlalchemy.org/](https://alembic.sqlalchemy.org/)) and liquibase ([https://www.liquibase.org/](https://www.liquibase.org/)) were reviewed but were not selected as

- Alembic does not use plain SQL files for migrations (uses python files)
- Liquibase has a very verbose format for the changelog, plain SQL files are supported but are not the default, and documentation is lacking.
