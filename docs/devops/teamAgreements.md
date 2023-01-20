# Team Agreements (DevOps)

## Deployment and Cluster Management

- When deploying to `prod`, make sure that the exact same migration path has been tested in `test`
- Always use Helm locally with the `-n` flag specifying the namespace
- Do not deploy after 16:00, or on a Friday
- Never touch production environments alone. However confident you are in what you are doing, ask for a second pair of eyes
- Do not delete PVCs with certificates on them

## Security

- Save certificate keys in 1Password
- Tokens and keys should be rotated on a regular schedule, and secrets should be cleaned up annually

## Incidents

- DevOps and incident reports are blameless. The aim is to determine what happened, how or why it happened, and what the team can do to help prevent it from happening again in the future
- Write postmortems after the incident has been resolved, including a write up of the incident itself, how to solve it, and any lessons learned in the process ([google postmortem culture](https://sre.google/sre-book/postmortem-culture/))
- If incidents of a certain type are recurring, consider writing a runbook for them

## Resources

- [Rocket.Chat](https://chat.developer.gov.bc.ca/channel/general), notably the `devops-sos`, `devops-security`, and `devops-alerts` channels
- BCGov courses in OpenShift: [OpenShift 101](https://cloud.gov.bc.ca/private-cloud/support-and-community/platform-training-and-resources/openshift-101/), [OpenShift 201](https://cloud.gov.bc.ca/private-cloud/support-and-community/platform-training-and-resources/openshift-201/)

## Tools

- Kubernetes / K8s
  - docs: https://kubernetes.io/docs/home/ , kubectl cheatsheet: https://kubernetes.io/docs/reference/kubectl/cheatsheet/
- Helm
  - docs: https://helm.sh/docs/
- Openshift UI
  - docs: https://docs.developer.gov.bc.ca/
- Openshift CLI
  - docs: https://docs.openshift.com/container-platform/4.8/cli_reference/openshift_cli/getting-started-cli.html
  - Note: If you prefer, once you have authenticated with openshift, you can also use the kubernetes command line tool, `kubectl` if you have it installed.
- Sysdig
  - docs: https://docs.sysdig.com/en/
- CrunchyDB Operator
  - docs: https://access.crunchydata.com/documentation/postgres-operator/v5
- Airflow
  - docs: https://airflow.apache.org/docs/apache-airflow/stable/
- Sentry
  - docs: https://docs.sentry.io/
- Google Cloud Storage
  - docs: https://cloud.google.com/storage/docs
- Terraform
  - docs: https://developer.hashicorp.com/terraform/docs
- cas-provision repository
  - https://github.com/bcgov/cas-pipeline
- Shipit
- Keycloak shared SSO
  - https://github.com/bcgov/sso-keycloak
  - docs: https://www.keycloak.org/
