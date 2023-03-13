# Writing Effective Documentation

This is a summary of some best practices to help write and maintain effective documentation. The primary resource for this summary is the [Google documentation style guide](https://developers.google.com/style). Other resources are listed at the bottom of this document for further reference.

## Summary of Best Practices

### **Consistency**

Maintaining consistency throughout your documentation makes it more readable and reduces ambiguity.
- Use the same language and terms to explain like-concepts.
- Be consistent in how you emphasize within your documentation. For example, don't swap between bold and italics for emphasis.
- Use consistent naming conventions. If your documentation is broken up into several files, make sure they are named consistently in a way that describes what they contain.
- Store your documentation files in a consistent location. A centralized documentation directory ensures anyone looking for documentation knows exactly where to look for it.

### **Brevity & Separation**

Nobody likes reading large, unbroken blocks of text. Separate documentation into smaller, more manageable blocks. This will make documentation easier to read and more manageable to maintain. Similarly, avoid long sentences. A common pitfall when writing documentation is trying to cram too much information into a single sentence. Look for opportunities to use shorter sentences to make things easier to understand and absorb for the reader.

### **Jargon & Acronyms**

The tech domain is full of jargon and acronyms. Some are widely understood (ie: Camel Case, CSS, Regex) and probably don't require any extra context. More obscure jargon and acronyms though, particularly those that are internal to your project, need some context added. There are a few ways to do this.
- Maintain a glossary of terms (and link to this glossary when using these terms in your documentation).
- Provide a definition or explanation in parenthesis beside the jargon/acronym when using it.
- Add a link to an approved definition (if the [jargon](https://www.merriam-webster.com/dictionary/jargon) or acronym is external).

### **Time & Date**

Dates and times can be ambiguous without context.

Using 12-hour time with AM/PM specified is recommended when expressing time. If you use 24-hour time, use it consistently throughout your documentation and include the '0' when expressing AM hours (ex: 03:45 = 3:45am). It's important to include timezone information. If you intend the reader to interpret the time as their local time, make that clear (ie: *10 AM your local time*). When describing a specific timezone, write out the region followed the UTC label in parenthesis, (ex: Pacific Standard Time (UTC-8)).

Dates expressed in sentences are best expressed with the month and days of the week spelled out (Tuesday, January 17). Be consistent with abbreviations, don't mix abbreviated days of the week with non-abbreviated months (Tues, January 17). If expressing a date numerically, use the format `YYYY-MM-DD`, as per the [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) international standard.

### **Timelessness**

Avoid language in your documentation that anchors it to a point in time. Referencing past or future using words like *previous*, *soon* or *new* can quickly become outdated. Referencing *"the previous version"*, for example, immediately becomes outdated as soon as a new version is released. As does *"X is a new feature..."*. Writing documentation with how the code currently works in mind reduces the maintenance required to keep documentation up to date.

### **Dead Docs**

Take the time to delete dead documentation. Leaving documentation that is no longer relevant in the codebase can cause frustration or can mislead the reader. Here are some good tips on dead doc curation from the [Chromium documentation best practices](https://chromium.googlesource.com/chromium/src/+/HEAD/docs/documentation_best_practices.md):
- Take it slow, doc health is a gradual accumulation.
- First delete what you‘re certain is wrong, ignore what’s unclear.
- Get the whole community involved. Devote time to quickly scan every doc and make a simple decision: Keep or delete?
- Default to delete or leave behind if migrating. Stragglers can always be recovered.
- Iterate.

### **Freshness**

Similar to dead docs, stale documentation can be frustrating and misleading. Keep documentation up to date at the same time changes are made to the codebase. Adding documentation as a step in your [definition of done](https://www.wrike.com/project-management-guide/faq/what-is-definition-of-done-agile/) is an effective way to remind yourself and your team to keep on top of this.

### **Overdocumentation**

Not every little thing needs documentation. Keeping a minimal set of fresh and accurate docs should be the goal. A sprawling assortment of documentation is both hard to navigate as a reader and hard to maintain as a developer.

## Futher Reading

[Google documentation style guide](https://developers.google.com/style)
[Swimm developer documentation done right](https://swimm.io/blog/developer-documenting-done-right)
[Chromium documentation best practices](https://chromium.googlesource.com/chromium/src/+/HEAD/docs/documentation_best_practices.md)
