---
name: step-review
description: Review a pushed commit of the floating-note.nvim rework against its step's done criteria and record the findings on the step's GitHub issue. Use when the owner asks for a review or says a step is finished ("step 2 が終わりました", "review をお願いします", "見てください").
---

# Reviewing a step

The review supplies the evidence; the owner makes the call. Criteria cannot
capture whether a name feels right or the tests feel sufficient, and only the
person who wrote the code can judge that.

## Working contract

- **The owner writes and commits all code and tests.** The agent never edits
  `lua/` or `tests/`, including to fix something a review found.
- **Findings are failure scenarios, not patches.** Say which input or sequence
  produces which wrong result. Do not post corrected code; finding the fix is
  the part the owner wants to do. Show code only when explicitly asked, and
  only the part asked for.
- **Pushed commits are not rewritten.** Review comments point at hashes, so
  fixes arrive as new commits on `rework`, never by amend or rebase of
  something already pushed.
- **The agent commits documents only when asked**, and asks before every push.
  The one exception is a progress update to `docs/roadmap.md` (ticking a
  step's checkbox): the owner gave standing permission to commit and push
  those on `rework` without asking.

## Before starting

1. Get the commit hash to review from the owner. It must be pushed and on
   `rework`. Resolve a branch name to a hash and state the hash.
2. Read the step's done criteria and the design decisions in
   `docs/roadmap.md`, and the step's GitHub issue including earlier review
   comments.
3. Read the actual contents at that hash (`git show`, `git diff` against the
   previous step) rather than the working tree, which may be ahead.

## What to do

- Run `make test` at that hash and report the real output. If the working
  tree is not at that hash, say so and ask before switching.
- Check each done criterion and mark it met, not met, or not verifiable, with
  the evidence.
- Look for behaviour the criteria do not mention but the design decisions
  imply, and for cases the specs do not cover.

## What to produce

One comment on the step's issue, in English (see `github-language`):

- the reviewed commit hash;
- the `make test` result;
- each done criterion with its verdict and evidence;
- findings, most serious first, each as a failure scenario;
- an overall verdict: all criteria met, or what remains.

A re-review is a new comment against the new hash; earlier comments are not
edited.

## Order

1. Show the comment in the conversation and wait for the owner's go-ahead.
   The repository is public.
2. Post it with `gh issue comment`.

## When the step is done

The owner declares it. Meeting every criterion does not close the step, and
the owner may also close a step with findings outstanding — record the reason
on the issue when they do.

After the declaration:

1. Tick the step's checkbox in `docs/roadmap.md`, then commit it as
   `docs: mark Step N as done` with `Refs #<issue>` and push it to `rework`.
   No confirmation is needed for this.
2. Close the issue.
3. After Step 8, remind the owner that `rework` is ready to merge into `main`
   and that their Neovim configuration needs the new `setup()` call. That
   configuration lives outside this repository; do not edit it from here.
