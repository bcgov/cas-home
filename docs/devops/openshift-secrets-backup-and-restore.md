
# Backing up and restoring Openshift secrets

## Backup Strategy

Openshift secrets are timestamped, and backed up on a rolling schedule by this [helm chart](https://github.com/bcgov/cas-pipeline/tree/master/helm/oc-secrets-backup). The chart is deployed in the AIRFLOW namespace.

Schedule:
- daily, rollover every 14 days
- weekly, rollover every 10 weeks
- monthly, rollover every 12 months
- yearly

The backups can be accessed on the backup PVC declared by this chart, with backups in the `/daily`, `/weekly`, `/monthly` and `/yearly` folders.

## Restore Strategy

#### 1. If the backup PVC is accessible
- Create a new pod that mounts the PVC, and retrieve the relevant backup.

#### 2. If the backup PVC is not accessible

In the case of an incident (cluster down, ...), the backup PVC may not be accessible through openshift:

- A PVC ID is stored in the team 1password under **Openshift Secrets Backup PVC ID**. An additional copy of that ID can be retrieved from our data custodian.

- The Platform Services folks at CITZ can be provided with that ID to start the [restore procedure](https://developer.gov.bc.ca/docs/default/component/platform-developer-docs/docs/automation-and-resiliency/netapp-backup-restore/).

