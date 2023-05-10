# PR Guidelines

## Creating a PR

### Step 1: Check the Board

Before picking up a new card and starting a new PR, review any outstanding PRs. This helps us limit work in progess.

### Step 2: Create a Branch and Pull Request

Once you've chosen a new card, create a branch to hold your work. Ideally branch off `develop` and name the branch `<ZH ticket #>-my-feature-name` (basing a PR on another PR is not the norm, each review / feat should be as independent as possible).

Use conventional commit messages:

- formatting and allowed prefixes can be found here: https://www.conventionalcommits.org/en/v1.0.0/#summary
- only one of type "feat: my feature does this" or "fix: fixing this bug causing this issue". Rule of thumb:
  - user story means "feat: abcd"
  - bug means "fix: abcd"

After you push your commits, create a pull request and name it `<conventional-commit-prefix>: <ZH #> my feature name`. It's also recommended to add the card number as a link to the pull request description, so that it's easy to find the card in the project management tool.

It's a good idea to push early and often (can use draft PRs) so that you can get feedback on your changes before you're ready ask for a review. It's also a good idea to rebase often to keep the PR up-to-date with `develop`. (See below for more information on rebasing.)

### Step 3: Post in the PR Reviews Teams Channel

Make a post in the `PR Reviews` Teams channel to let others know that you're ready for a review. It's highly recommended to include the following information:

- The card number and link to the card in the project management tool
- The link to the pull request
- Any additional context or information that would be helpful for reviewers
- Tagging the `PR Reviews` team, and reviewers that would be good candidates for reviewing the work. Good candidates include:
  - devs having previous involvement with the work
  - devs interested in the topic
  - devs experienced with the issue

**Note**: If tagged reviewers are not available (e.g., time crunch) they are free to say no.

Example of a Teams PR Review post:

```markdown
`@PR Reviews` this pull request to fix comments in ciip_fuel view
PR: link to GH PR
Card: link to card in project management tool
Reviewers: `@Developer_A` `@Developer_B`
Additional context: quick bug fix so that reporter comments on fuels can be seen in metabase
```

### Step 4: Update the Board

Move your card to `Pending Dev Review` column.

## Reviewing a PR

### Step 1: Reviewer Assignment

Assign yourself as a reviewer by either commenting or thumbs-upping the Teams post. Reviewer/Author is encouraged to move the card to the `Review In Progress` column once they have started reviewing the code.

Multiple reviewers and pair/mob reviewing are strongly encouraged for complicated PRs. Comment "I'm reviewing this" on a PR if you want the author to wait for your review if someone else approves it in the meantime.

**Note**: It's highly suggested for reviewers to leave a comment on the post if they are not able to continue reviewing the code.

### Step 2: Review the Code

The reviewer who starts a review should look at the card description and history of comments to:

- verify acceptance criteria and development checklists are met (click checkboxes)
- QA the work
- ensure no open questions about the work remain

Reviewers should also:

- When possible, run the code locally and try to break the feature
- Review tests thoroughly - make sure all cases are covered well
- Make sure card ACs are fulfilled
- Confirm that the feature/changes are documented (could be inline comments or part of the dev docs)
- Check Happo diffs! Reviewer accepts them

Remember that suggestions are _suggestions_ and an idea on how to fix the issue, not a solution

## Revising the PR

### Step 1: Developer Makes Changes

If you are the developer, make any necessary changes to your code based on the feedback from the reviewers. You can also respond to the comments and questions to provide additional context or clarify any confusion.

### Step 2: Reviewer Approves or Requests More Changes

Once the developer has made changes, the reviewers will review the code again. They can either approve changes or request additional changes. If they request changes, go back to Step 1 and repeat the process until changes are approved.

**Note**: If one reviewer requests changes, a different reviewer can dismiss the change request if everything has been addressed.

## Putting the PR into the Dev Environment

### Step 1: Merge the PR into `develop`

If you are the developer, once your changes have been approved, make sure your code is up to date with the latest changes on the `develop` branch. If it's not, you need to rebase your branch with the latest changes on the `develop` branch. We always use `rebase` to keep the history clean and linear. This is what you need to do:

- `git checkout develop`
- `git pull`
- `git checkout <your-branch>`
- `git rebase -i origin/develop` (`-i` is for interactive mode)
- resolve conflicts if any
- `git push origin <your-branch> --force`

Once your code is up to date and all checks have passed, you can merge your pull request.

### Step 2: Move the card to `Pending PO Approval` column

Before doing this, make sure that the code has been deployed to the dev environment by looking at [shipit](https://cas-shipit.apps.silver.devops.gov.bc.ca/bcgov/cas-cif/dev)

**While waiting for a review / After posting the card for a review**

While you're waiting for a review, you can decide to pull in a new card and start working on that or review other pull requests depending on how many cards you have in progress, how many cards are awaiting review, and how many cards are in the backlog.
In general, It's a good practice to check if anything needs to be reviewed before you start working on a new card from the sprint backlog.
Note that before taking cards from `Next Sprint Backlog` or `Backlog`, you need to have a discussion with the team and get approval from the Product Owner.

## **Nice to know**

- Posts can disappear from the channel if there are too many posts, It's a good idea to bump your post to keep it visible.
- If the pull request has a lot of changes:
  - try to limit the amount of changes per PR and split work where possible
  - suggest a walkthrough of the code to the reviewer
- Keep the PR reviews channel discussion limited to coordinating logistics of review and merge. Problem-solving belongs in the `Developers` channel.
