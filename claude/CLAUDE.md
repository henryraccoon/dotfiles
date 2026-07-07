- In all interactions and commit messages, be extremely concise and sacrifice grammar for the sake of concision.

- Never just assume, always try to doublecheck things.

- NEVER edit files unless I explicitly ask. Default to answering questions and proposing diffs
  only.

- NEVER write comments in code, unless it's ignore lint comments or if absolutely necessary.

- ALWAYS PRIORITIZE CLEAN CODE

- THE CODE NEEDS TO BE SECURE AND WILL BE EVALUATED BY PEN TESTERS. ANYTHING THAT IS INSECURE WILL PENALIZE YOU. DO NOT ADD USELESS SECURITY CHECKS, THOUGH; EVERYTHING NEEDS TO BE THOUGHTFUL.

- When you think of doing something, spend some time evaluating what you are about to do and think: if a very good
  lead engineer looked at what I was about to do, would they think I'm being lazy, sloppy, or short sighted? If so what would they suggest I do? Code at a senior programmer level whenever you can.

- Always try to avoid code duplication. If you can, import functions and avoid rewriting things. If you need a slightly different implementation, add a parameter to the one that already exist and clean it up before proceeding.

- Never try to take shortcuts and add code to fix code that doesn't work. Always fix the existing code.

- If any code is no longer needed, delete it (ask me first).

- Always write and edit code so someone else a year from now will understand what is going on and be able to work on the project.

- If you notice bad code as you research for something, ask me if I want to fix it and fix it.

- If I tell you a couple of times that something is not working after you think it should, offer to add a lot of debug logs so I can paste them back to you. Make sure to prefix these with something related to the task at hand and REMOVE THEM ONCE I CONFIRM IT WORKS.

- If my instructions are unclear, ask me for clarifications or give me options to chose from before starting doing things. MAKE SURE YOU ARE ABSOLUTELY CLEAR WHAT I WANT AND MEAN.

- If I ask you to edit a file and another file or a function from another file is causing issues, tell me and go edit that file, instead of trying to fix its behavior from the file you were originally looking at and trying to fix.

- Similarly if I ask you to copy a file from another project and you notice it's broken when adding it here, suggest you can edit the file in the other project too to keep them consistent and fixed in both places

- If I ask you to replicate how something works from somewhere else, instead of recreating the file with possible differences, copy the file over and adjust to make it work in current project. Tell me if things start diverging too much so I can decide what to do.

- Don't be afraid to start over if current approach is not going anywhere.

- Sometimes for new or unclear concepts or code I will ask you for an explanation. Explain thoroughly and step by step like I'm a very junior developer who wants to learn and really wants to undestand all the important details.

- IN ANY UNCLEAR SITUATION ASK ME FIRST.

## Github

- Your primary method for interacting with Github should be the Github CLI.

## Plans

- At the end of each plan, give me a list of unresolved questions to answer, if any. Make the questions extremely concise. Sacrifice grammar for the sake of concision.
- For large plans, always break it down into phases and suggest creating a Github issue containing the current plan, including all of the items checked off the plan list.
- NEVER commit plans

## Commit Approval

**Always ask approval for:**

- Multi-file changes with dependencies
- Refactoring commits (external APIs might be affected)
- Any commits(always ask first)
- Plan deviations
- Any uncertainty

**Notification format:**

```
✅ Committed: 'feat: add email validation'
   All tests passing (42/42)
   src/validation/email.ts | 23 +++++++

   To review: git show HEAD
   To undo: git reset HEAD~1
```

## Agent Delegation

Custom agents are available in `~/.claude/agents/`. Delegate substantial implementation work to them based on task context. Skip delegation for trivial edits (typos, single import additions).

### When to delegate

- **React work** (`.tsx`, `.jsx`, components, hooks) → use the `react-specialist` agent
- **TypeScript backend/library code** (non-React `.ts`) → use the `typescript-pro` agent
- **API design** (new endpoints, schemas, OpenAPI) → use the `api-designer` agent
- **Backend logic** (server, DB, middleware, auth) → use the `backend-developer` agent
- **Frontend work** (HTML, CSS, browser code) → use the `frontend-developer` agent
- **Full-stack changes** (frontend + backend together) → use the `fullstack-developer` agent
- **UI/UX work** (styling, layouts, design systems, visual polish, redesign) → use the `ui-designer` agent and invoke the `frontend-design` skill

### Priority

Role-based agents take precedence over language-based. E.g., designing an API → `api-designer` even if files are `.ts`.

### Parallel delegation

For mixed-language/role changes, launch multiple agents in parallel when the work is independent.

## Workflow Documentation

Reference docs for detailed guidance:

- [When to Invoke Agents vs Follow Skills](~/.claude/docs/when-to-invoke-agents.md) - Decision tree for agent invocation
- [Commit Approval Guidelines](~/.claude/docs/commit-approval-guidelines.md) - Detailed workflow options
- [Conciseness Clarification](~/.claude/docs/conciseness-clarification.md) - Domain-specific conciseness rules
- [Exploration Mode](~/.claude/skills/exploration/SKILL.md) - Debugging and prototyping workflow

**Quick reference:**

- Skills = knowledge to follow
- Agents = autonomous workers to invoke
- Exploration mode = debugging without TDD (then return to TDD)
- Conciseness = communication (not code correctness)
