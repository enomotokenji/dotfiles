---
name: ask-deepseek
description: Ask a single well-formed question to DeepSeek and report back its answer plus a short take. Use this whenever the user says "ask DeepSeek", "deepseekにきいて", "deepseekに尋ねて", "deepseekの意見", or otherwise asks for a one-shot DeepSeek second opinion — without needing a back-and-forth debate. Particularly useful for reasoning-heavy questions where `deepseek-reasoner` shines. For anything that warrants several rounds of discussion, use `discuss-deepseek` instead.
---

# Ask DeepSeek

Send one well-formed question to DeepSeek and return the answer.

## When to use this vs discuss-deepseek

- **ask-deepseek**: one-shot — a focused question, a review, a reasoning spot-check
- **discuss-deepseek**: convergent multi-round debate

If unsure, start with ask-deepseek.

## How to talk to DeepSeek

Use the script bundled with `discuss-deepseek`:

```bash
python3 ~/.claude/skills/discuss-deepseek/scripts/deepseek_chat.py "<prompt>"
```

Under Codex: `~/.codex/skills/discuss-deepseek/scripts/deepseek_chat.py`.

The script reads `DEEPSEEK_API_KEY` from environment, then `$PWD/.env`, then `$HOME/.env`, and prefers `deepseek-reasoner` when available.

English prompt; reply to the user in their language.

## Workflow

1. **Gather context.** Read relevant files so the prompt is concrete.
2. **Form the prompt.** Include the question, minimum context, the kind of answer wanted, and a word limit.
3. **Invoke.** Bash with timeout 180000 ms+ (reasoner can be slow). Heredoc for multi-line.
4. **Present.** Show DeepSeek's answer, then a short take.

## Output shape

```
## DeepSeek's answer

<verbatim or lightly-trimmed response>

## My take

<1-3 sentences: agree, disagree, or extend — and the concrete next step>
```

## Notes

- `deepseek-reasoner` responses may include `<think>...</think>` blocks; surface the final answer and only keep the reasoning if the user specifically wanted it
- If `DEEPSEEK_API_KEY` is missing, surface the error and ask where to put the key
