---
name: step-start
description: Start the next step of the floating-note.nvim rework. Finds the first unchecked step in docs/roadmap.md, files it as a GitHub issue and presents the spec. Use when the owner asks to begin, resume or move on to the next step ("次の step を始めたい", "step 3 に進みます", "続きをやりましょう").
---

# Starting a step

The owner writes this plugin's code and tests by hand. Starting a step means
handing over a clear target, not a solution.

## Working contract

- **The owner writes and commits all code and tests.** Where to cut a commit
  and what its message says is part of the work, and reviews are pinned to
  commit hashes, so the person who wrote the code decides the boundaries.
- **The agent never edits `lua/` or `tests/`.**
- **The agent writes documents only** — `docs/roadmap.md`, these skills, issue
  and comment text — and commits them only when the owner asks. Ask before
  every push. The one exception is a progress update to `docs/roadmap.md`
  (ticking a step's checkbox), which the agent commits and pushes on
  `rework` without asking.
- **All step work lands on the `rework` branch.** `main` keeps the old
  behaviour until Step 8 is declared done, because the owner uses the plugin
  daily from `main` and Step 4 removes the API their configuration calls.
- **Help stops at explanation.** Explain how a Neovim API behaves, point to
  `:help`, give minimal examples unrelated to this plugin, lay out design
  options with a recommendation. Do not write this plugin's functions or
  tests unless the owner explicitly asks, and then only the part asked for.
  Working out the code is the part the owner wants to do.

## Before starting

1. Read `docs/roadmap.md`: the design decisions, the toggle behaviour table,
   and the first step whose checkbox is unchecked.
2. Check that the previous step's issue is closed. If it is still open, say so
   and ask whether to finish it first.
3. Check `gh issue list` for an existing issue for this step; do not file a
   duplicate.
4. Read the current code on `rework` that the step will touch, so the spec
   describes the real starting point.

## What to produce

A GitHub issue, in English (see `github-language`), titled `Step N: <name>`,
containing:

- the goal of the step in one or two sentences;
- the done criteria from the roadmap as a checklist;
- the design decisions from the roadmap that constrain this step;
- the current state of the code the step starts from;
- `:help` topics worth reading.

It never contains implementation steps, code for this plugin, or test code.

## Order

1. Show the issue body in the conversation and wait for the owner's go-ahead.
   The repository is public; nothing is posted unconfirmed.
2. Create the issue with `gh issue create`.
3. Give the owner the issue number and remind them that commits reference it
   with `Refs #N`.

## When it is done

When the issue exists and the owner has its number. The step itself is closed
by `step-review`, not here.
