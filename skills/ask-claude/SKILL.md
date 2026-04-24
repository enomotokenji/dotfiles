---
name: ask-claude
description: Ask a single well-formed question to a fresh Claude instance (via `claude -p`) and report back its answer plus a short take. Use this whenever the user says "ask Claude", "claudeにきいて", "claudeに尋ねて", "claudeの意見", "もう一人のclaudeに", or otherwise asks for a one-shot second opinion from another Claude — without needing a back-and-forth debate. For anything that warrants several rounds of discussion, use `discuss-claude` instead.
---

# Ask Claude

Send one well-formed question to a fresh Claude instance and return the answer.

## When to use this vs discuss-claude

- **ask-claude**: one-shot — a focused question, a code review, a sanity check, a "does this plan have holes?"
- **discuss-claude**: convergent multi-round debate on an open question with tradeoffs

If unsure, start with ask-claude. Users can always escalate.

## How to talk to the other Claude

```bash
claude -p --dangerously-skip-permissions "<prompt>"
```

Stateless — a single call, no session follow-up. `--dangerously-skip-permissions` suppresses the subprocess's interactive permission prompts so the consultation runs autonomously; the sandbox remains in force. This is appropriate here because the subagent is only answering a question, not editing the filesystem.

Send the prompt in English (better reasoning quality); reply to the user in their language.

## Workflow

1. **Gather context.** Skim relevant files or `ls` the project so the prompt is concrete and answerable. A prompt with no context forces the other Claude to guess.
2. **Form the prompt.** Include:
   - The concrete question, upfront and specific
   - The minimum context needed to answer (file paths, snippets, constraints) — do not dump the whole repo
   - What kind of answer the user wants (a recommendation, a review, a yes/no, a list of risks)
   - A word limit if appropriate, so the reply is usable
3. **Invoke.** Use Bash with a generous timeout (120000 ms+). Heredoc for multi-line prompts; watch quote escaping.
4. **Present.** Show the user the other Claude's answer verbatim (or lightly trimmed if noisy). Then add a short take of your own: whether you agree, anything you would add or push back on, and any next step you recommend.

## Output shape

```
## Claude's answer

<verbatim or lightly-trimmed response>

## My take

<1-3 sentences: agree, disagree, or extend — and the concrete next step>
```

Keep the whole response tight — this skill is for quick consults, not essays.

## Notes

- Do not interrupt the user to clarify unless the prompt is genuinely unanswerable
- If `claude -p` errors (e.g. not on PATH, rate-limited), report it plainly and ask how to proceed
- No file writeup — the result lives in the conversation
