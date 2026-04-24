---
name: smart-push
description: Commit any uncommitted local work with well-written, appropriately-scoped messages that match the repo's existing commit style, then push to the tracking remote. Use this whenever the user says "push", "commit and push", "smart-push", "ship it", "land this", "コミットしてpushして", "上げて", or otherwise signals they want their current work on the remote — even if they do not explicitly ask for commits to be written. Splits logically unrelated changes into separate commits rather than bundling them. Refuses to force-push, amend, skip hooks, or blindly stage unknown files.
---

# smart-push

Land the user's current local work on the remote, in one step, with commits that are well-scoped and have messages written in the repo's style.

"Smart" means: do not just dump everything into one commit and push. Group logically unrelated changes into separate commits so the history reads cleanly and each commit can be reviewed or reverted on its own.

## Workflow

### 1. Survey the state

Run these in parallel to get the full picture in one turn:

- `git status` — untracked and modified files (do not pass `-uall`)
- `git diff` and `git diff --cached` — the actual content changes
- `git log --oneline -10` — the repo's commit message style
- `git branch --show-current` — current branch
- `git status -sb` — ahead/behind the tracking remote

Then branch on what you found:

| State                                  | Action                               |
| -------------------------------------- | ------------------------------------ |
| No changes, no unpushed commits        | Report "nothing to push" and stop    |
| No changes, N unpushed commits         | Skip to step 6 (push)                |
| Uncommitted changes present            | Continue to step 2                   |

### 2. Screen for secrets before staging anything

Before grouping or staging, scan the untracked/modified list for files that plausibly contain secrets:

- `.env`, `.env.*`
- `*_secret*`, `secrets.*`, anything under `secrets/`
- `*.pem`, `*.key`, `id_rsa*`, `*.credentials`, `credentials.*`
- Config files named like `*config.local*` where local often means machine-specific secrets

If any match, stop and ask the user whether to include them. Do not silently skip — the user may have staged a secret by accident and needs to know. Do not silently include — the user may not have realized it was picked up.

### 3. Group logically unrelated changes

Read the diffs and decide whether the changes belong in one commit or more.

Signals to split:

- Unrelated files touched for different reasons (e.g. an auth bug fix plus an unrelated README typo)
- Mixed refactor + new feature + bug fix in the same pass
- A noisy generated/lock file bundled with a meaningful change — give the noise its own commit
- Reversible work (a temp workaround) mixed with durable work — keep them separate so the temp one is easy to revert later

Signals to keep together:

- A code change plus the test that exercises it
- A schema/config change that the code change depends on
- Small follow-up touches to the same component or same thought

When in doubt, one commit is fine. The goal is a readable history, not maximum fragmentation.

### 4. Stage each group explicitly

For each group, stage only the files that belong to it by listing them:

```bash
git add path/to/file1 path/to/file2
```

Do not use `git add -A`, `git add .`, or `git commit -a`. They sweep in files you haven't reasoned about, including anything that slipped past the secret scan.

### 5. Write and create each commit

Match the style observed in `git log --oneline -10` (and read the bodies of a couple of recent commits if the format is not obvious from subjects alone). Mirror:

- Subject line length and capitalization
- Imperative mood (`Fix X`, not `Fixed X` or `Fixes X`)
- Whether a body is customary and how it's wrapped
- Whether scope prefixes like `feat(api):` are used
- Any trailers such as `Co-Authored-By:` or `Signed-off-by:`

The subject captures intent in one line. If a body is warranted, use it to answer **why**, not what — the diff already shows what. Single plain sentences beat bullet points when the motivation is linear. Pass multi-line messages through a heredoc to preserve formatting:

```bash
git commit -m "$(cat <<'EOF'
Subject line in imperative mood

Short paragraph explaining the motivation for this change and any
non-obvious constraint or tradeoff. Wrap at ~72 columns.
EOF
)"
```

After each commit, run `git status` to confirm the tree is clean before moving to the next group.

If a pre-commit hook fails: read the failure, fix the underlying problem, re-stage, and create a **new** commit. Do not `--amend` — the previous commit did not actually happen, so amending would modify the wrong commit.

### 6. Push

Plain `git push`. No flags. The branch already tracks a remote in the normal case; if it doesn't, `git push -u origin <branch>` is acceptable on the first push of a new branch.

Never `--force`, never `--force-with-lease`, and never `--no-verify` unless the user has explicitly asked for that specific flag in this conversation.

### 7. Handle push rejections gracefully

If the push is rejected — commonly with a message like "Pushing directly to main/master bypasses PR review" from a safety hook — do not try to work around it.

Report the rejection to the user and offer the realistic paths forward:

1. Open a feature branch and create a pull request
2. User approves the direct push (e.g. adds a permission rule, or pushes themselves from their terminal)
3. Adjust the repo's branch protection settings

Let the user pick. Do not retry with `--force` to bypass protection.

If the rejection is `non-fast-forward` (someone else pushed), offer a `git pull --rebase` followed by a fresh push — but confirm with the user before running a rebase if there are any merge commits or unusual history on the current branch.

## What this skill will not do

- Force-push, even with `--force-with-lease`, unless the user explicitly asked for it in this conversation
- Amend an existing commit to fold in new work — always make a new commit
- Skip hooks via `--no-verify`, `--no-gpg-sign`, or similar
- Use `git add -A`, `git add .`, or `git commit -a`
- Commit files that pattern-match secrets without explicit user approval
- Push to a branch other than the current one without the user asking

## Example

**User:** "push"

**Agent:**

1. Parallel: `git status`, `git diff`, `git log --oneline -10`, `git branch --show-current`.
2. Finds `src/auth.ts` (token refresh fix), `README.md` (unrelated typo), branch `feature/login`, tracking `origin/feature/login`.
3. Recent log style: short imperative subject, no body on small changes, `Co-Authored-By:` trailer.
4. Splits into two commits:
   ```bash
   git add src/auth.ts
   git commit -m "$(cat <<'EOF'
   Retry token refresh on 401 instead of surfacing error

   Co-Authored-By: ...
   EOF
   )"

   git add README.md
   git commit -m "$(cat <<'EOF'
   Fix typo in install instructions

   Co-Authored-By: ...
   EOF
   )"
   ```
5. `git push` → success → report both SHAs and the branch.
