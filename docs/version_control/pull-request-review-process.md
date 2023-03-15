# PR Review guidelines

## Step 1: Create a Pull Request

Create a pull request with your changes. It's a good idea to create a `draft pull request` first, so that you can get feedback on your changes before you're ready ask for a review. It's also recommended to add the card number as a link to the pull request description, so that it's easy to find the card in the project management tool.

## Step 2: Post in the PR Reviews Teams Channel

Make a post in the `PR Reviews` Teams channel to let others know that you're ready for a review and move your card to `Pending Dev Review` column. It's highly recommended to include the following information:

- The card number and link to the card in the project management tool
- The link to the pull request
- Tagging the `PR Reviews` team, and reviewers that would be good candidates for reviewing the work
- Any additional context or information that would be helpful for reviewers


Example:

```markdown
`@PR Reviews` this pull request to fix comments in ciip_fuel view
PR: link to GH PR
Card: link to card in project management tool
Reviewers: `@Developer_A` `@Developer_B`
Additional context: quick bug fix so that reporter comments on fuels can be seen in metabase
```

## Step 3: Reviewers Review the Code

Reviewers will assign themselves to the card and review the code by either commenting on the post or thumbs-upping the post. Reviewer/Author is encouraged to move the card to the `Review In Progress` column once they have started reviewing the code.

The Reviewer who starts a review should look at the card description and history of comments to:

- verify acceptance criteria and development checklists are met (click checkboxes)
- QA the work
- ensure no open questions about the work remain

**Note**: It's highly suggested for reviewers to leave a comment on the post if they are not able to continue reviewing the code.

## Step 4: Make Changes and Respond to Comments

Make any necessary changes to your code based on the feedback from the reviewers. You can also respond to the comments and questions to provide additional context or clarify any confusion.

## Step 5: Reviewers Approve or Request Changes

Once you have made changes, the reviewers will review your code again. They can either approve your changes or request additional changes. If they request changes, go back to Step 4 and repeat the process until your changes are approved.

## Step 6: Merge the Pull Request

Once your changes have been approved make sure your code is up to date with the latest changes on the `develop` branch; If it's not, you need to rebase your branch with the latest changes on the `develop` branch. We always use `rebase` to keep the history clean and linear. This is what you need to do:

- `git checkout develop`
- `git pull`
- `git checkout <your-branch>`
- `git rebase -i origin/develop` (`-i` is for interactive mode)
- resolve conflicts if any
- `git push origin <your-branch> --force`

Once your code is up to date and all checks have passed, you can merge your pull request.

## Step 7: Move the card to `Pending PO Approval` column

Before doing this, make sure that the code has been deployed to the dev environment by looking at [shipit](https://cas-shipit.apps.silver.devops.gov.bc.ca/bcgov/cas-cif/dev)

## **While waiting for a review / After posting the card for a review**

While you're waiting for a review, you can decide to pull in a new card and start working on that or review other pull requests depending on how many cards you have in progress, how many cards are awaiting review, and how many cards are in the backlog.
In general, It's a good practice to check if anything needs to be reviewed before you start working on a new card from the sprint backlog.
Note that, For taking cards from `Next Sprint Backlog` or `Backlog` you need to have a discussion with the team and get approval from the Product Owner.

## **Nice to know**

- Posts can disappear from the channel if there are too many posts, It's a good idea to bump your post to keep it visible.
- If the pull request has a lot of changes:
  - try to limit the amount of changes per PR and split work where possible
  - suggest a walkthrough of the code to the reviewer
- Keep the PR reviews channel discussion limited to coordinating logistics of review and merge. Problem-solving belongs in the `Developers` channel.
