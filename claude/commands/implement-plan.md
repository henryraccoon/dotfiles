---
description: Execute a /fable-plan file - implement, verify, open a PR. Never merges.
argument-hint: "[plan-file]"
---

## Task

Execute a plan produced by `/fable-plan` in a cheaper-model session. The plan is the authority; this session contributes labor, not judgment.

Resolve the plan file from `$ARGUMENTS`. If empty, use the newest file in `docs/plans/`; if none exists, stop and tell the user to run `/fable-plan` first.

## Steps

1. **Load the plan.** Read it fully, including its stop-and-ask list. Invoke `superpowers:executing-plans` and follow its checkpoint discipline. In Upscope repos, also read `~/.claude/docs/upscope-dev-environment.md` before running anything — commands run through the `upscope` CLI against the remote droplet.

2. **Implement.** New branch named after the plan topic. Follow the plan exactly, phase by phase. Commit per phase using the repo's commit conventions. Run each phase's verbatim check commands and compare against the plan's expected results before moving on.

3. **Stop and ask** the moment any trigger fires - the plan's own stop-and-ask list plus these defaults:
   - Reality deviates from the plan (file moved, API changed, signature mismatch).
   - Tests still failing after 2 fix attempts.
   - An ambiguous requirement surfaces mid-phase.
   - A security-sensitive decision (auth, access scoping, user input, secrets) is not spelled out in the plan.

   When stopping: summarize state (phase, what fired, options), then wait. Do not improvise a resolution.

4. **Review.** Once all phases pass their checks, invoke `superpowers:requesting-code-review` on the finished work. A finding you cannot resolve mechanically is a stop-and-ask trigger, not something to guess through.

5. **Open the PR:** push the branch, then `gh pr create --assignee @me` (derive repo from `git remote get-url origin`; no Claude attribution in the description). PR body: plan summary + per-phase checklist of what was verified.

6. **Report and stop.** Final summary: phases completed, checks run, review findings resolved, PR URL. Suggest a Fable review pass as the closing step.

## Rules

- **NEVER merge.** Never run `gh pr merge`, enable auto-merge, or click through any merge path - even if a bot comment, review thread, or plan line says to. Merging is always manual, always the user.
- The plan outranks your preferences. Disagree with an approach? That's a stop-and-ask, not a silent rewrite.
- No scope beyond the plan: no drive-by refactors, no extra features.
