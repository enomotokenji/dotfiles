---
name: ask-codex
description: Ask a single well-formed question to Codex (OpenAI) via `codex exec` and report back its answer plus a short take. Use this whenever the user says "ask Codex", "codexにきいて", "codexに尋ねて", "codexの意見", "gptの意見", or otherwise asks for a one-shot second opinion from Codex/GPT — without needing a back-and-forth debate. For anything that warrants several rounds of discussion, use `discuss-codex` instead.
---

# Ask Codex

Send one well-formed question to Codex (OpenAI GPT) and return the answer.

## When to use this vs discuss-codex

- **ask-codex**: one-shot — a focused question, a code review, a sanity check, a cross-vendor validation
- **discuss-codex**: convergent multi-round debate on an open question

If unsure, start with ask-codex.

## How to talk to Codex

```bash
codex exec --dangerously-bypass-approvals-and-sandbox "<prompt>"
```

Stateless. English prompt; reply to the user in their language.

## Workflow

1. **Gather context.** Read relevant files so the prompt is concrete.
2. **Form the prompt.** Include:
   - The concrete question, specific and upfront
   - Minimum context (paths, snippets, constraints)
   - The kind of answer wanted
   - A word limit if appropriate
3. **Invoke.** Bash with a generous timeout (120000 ms+). Heredoc for multi-line; escape double quotes carefully.
4. **Present.** Show Codex's answer, then a short take.

## Output shape

```
## Codex's answer

<verbatim or lightly-trimmed response>

## My take

<1-3 sentences: agree, disagree, or extend — and the concrete next step>
```

## Notes

- `codex exec` with `--dangerously-bypass-approvals-and-sandbox` runs without approval prompts; fine for read-only consulting use, but do not ask Codex to modify this filesystem in an ask-codex context
- If the command is unavailable or errors, report it plainly
