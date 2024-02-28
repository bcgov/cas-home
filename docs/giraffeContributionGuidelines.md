# 🦒 Giraffe Contribution guidelines 🦒

> [!NOTE]
> _This document tries to outline a process to allow the team to safely contribute to the production-ready 
codebase of the registration application. We aim at:_
> - _Keeping the registration app's contribution process untouched_
> - _Keeping the registration app's release process untouched_
> - _Guaranteeing code compatibility over time_
> - _Minimising the effort to keep both apps in sync_

## Principles
1. We use separate `develop` branch named `giraffe-develop` 
1. Giraffe developers treat `giraffe-develop` as their main develop branch:
    - start new branches from `giraffe-develop`
    - PR and merge into `giraffe-develop`
    - rebase your work from `giraffe-develop`
1. `giraffe-develop` is rebased from `develop` as often as possible:
    - before starting a new branch
    - before requesting a PR review
    - right before merging the PR
Drawback: This means we can't setup branch protections on the `giraffe-develop` branch, we will require
developers to be mindful of which branch they are on when pushing code.

## Alternate flow (in case of recurring rebase conflicts)
  Instead of regular rebases from `develop` into `giraffe-develop` we could do regular merges, which 
  could happen on an intermediate branch.

  Benefits would be to isolate conflicts and prevent them from happening over and over.

  Drawbacks are that we lose the 'single history' when we have the confidence that both apps can share 
  the release process.

## Testing considerations
- After rebase (or merge) from the official `develop` branch, manual regression testing might be useful, in particular when common files have been modified.

## CI/CD considerations
- Shipit will deploy `giraffe-develop` in a separate namespace to avoid interactions
- Helm values will need to be adjusted for that


## Facilitating the process
To facilitate flow of work between team members and with the Moose team:
- Create **Draft** PRs as early as possible to ensure CI passes, and to allow the team to help troubleshooting issues
- When your PR is ready to review, post a message in the appropriate Teams channel and mark your PR as ready.
- Be reactive on comments to allow a quick turnaround, and make time to review other developer's code, so the PR can be merged quickly before we the main `develop` branch moves ahead further.
- Follow the team's [PR process](./version_control/pull-request-review-process.md)