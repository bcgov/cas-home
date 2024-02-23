# Terraform migration from Terraform Cloud to GCP state and jobs

## Reason

Terraform Cloud deprecated it's Government plan, changing cost allocations and necessetating the need to migrate away from it for our uses. It operated as both a storage for State for *all* projects, as well as a runner to execute the changes to state. `cas-shelf` was the main interface with Terraform Cloud.

To replace this, we chose to move our state storage to Google Cloud Platform Storage Buckets and the runner to OpenShift jobs. The storage buckets are provisioned by `cas-pipeline` with a storage bucket created for each namespace (project and `-dev`, `-test`, `-prod`), credentials held as secrets to access the buckets, and a `.tfbackend` that defines the backend for Terraform. The OpenShift

## Reference file descriptions

`./tf-migration-scripts/tf-migration.sh`

This file is the one that does the actual migrations. It runs `terraform state mv` over a set of lists of resources. These are defined by the variables within the script.

## Directions for migration

This is the process that was used during the migration away from Terraform Cloud. They'll likely be adaptable to similar state transfers.

1. Delete any local `.terraform` folders from previous runs.
2. Navigate to the Helm chart's directory for the project (e.g. `/chart/cas-cif`), then to the `terraform` directory within that.
3. Acquire `terraform@ggl-cas-storage.iam.gserviceaccount.com` credentials from the CAS 1Password (named *cas-pipeline/gcp-tf-credentials.json*) and place them in the Helm chart's Terraform directory (e.g. `/chart/cas-cif/terraform/credentials.json). **WARNING: Do _not_ commit these to Git or Helm!**
4. Make a copy of `migration_example.tfvars` named `local.tfvars`. Fill in the values for the various keys based on the project you are in. (See 1Password item named *Migration local.tfvars base* for reusable values)
5. Log in to OpenShift [through the GUI](https://oauth-openshift.apps.silver.devops.gov.bc.ca/oauth/token/request) and then [login through the CLI](https://oauth-openshift.apps.silver.devops.gov.bc.ca/oauth/token/request) (keep this login tab open). **Note**: Your *API token* (used in step 6) changes every time you log in, you will need to copy this each time.
6. Ensure you are in the namespace matching the project you want to work with using the command `oc project {NAMESPACE_WITH_ENVIRNMENT}` (e.g. `oc project c1234-dev`).
7. Copy your your API token from the *login through the CLI tab* that you kept open and paste it into your `local.tfvars` file in the `kubernetes_token` key.
8. Get the Terraform Backend from the OpenShift secret `gcp-credentials-secret`.`tf_backend` with `oc get secret gcp-credentials-secret -o go-template --template="{{.data.tf_backend|base64decode}}" > gcp-dev.tfbackend`. Change the target file name (e.g. `gcp-dev.tfbackend`) depending on the environment (dev, test, prod). **NOTE:** Ensure that the `bucket` value from this file matches your intended namespace!
9. Open `gcp-dev.tfbackend` in your code editor and change the key `credentials` to the value `credentials.json`. This is the path of the credentials file from step 2.
10. Initiate Terraform state with `terraform init -backend-config=gcp-dev.tfbackend`.
11. Run `terraform plan -var-file=local.tfvars` to ensure the state was created. This command is expected to want to create a number of new items.
12. Create the `temp-state` directory within your current directory where Terraform is being run (e.g. `/chart/cas-cif/terraform` => `/chart/cas-cif/terraform/temp-state`).
13. Backup GCS remote state to local with `terraform state pull > ./temp-state/local.tfstate`.
14. Acquire `tfcloud.tfstate` and place it in the `temp-state` directory. This can be acquired via cloud.terraform.com.
15. Ensure resources to migrate are mapped out in `./tf-migrate.sh`. (See [[Shadowing with Josh L#Further notes for tf-migrate.sh script]] below).
    > the App array and the Namespace variable will be what changes.
16. Run the migration script `./tf-migration.sh`.
17. Push the local state to GCS `terraform state push "./temp-state/local.tfstate"`.
18. Check that state pushed properly with `terraform state list` (should expect a list of resources) and then run `terraform plan -var-file=local.tfvars`.
