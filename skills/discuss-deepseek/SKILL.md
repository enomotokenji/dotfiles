---
name: discuss-deepseek
description: Run an autonomous multi-round debate between the current session and DeepSeek to stress-test an idea and converge on a conclusion. Use this whenever the user says "discuss with DeepSeek", "deepseekと議論して", "deepseekと相談して", "deepseekの意見を聞いて", "deepseekとブレストして", or otherwise asks for a DeepSeek second opinion on a design, strategy, architecture choice, or tradeoff. Particularly useful when you want a reasoning-heavy response from `deepseek-reasoner`. Summarises the conversation to `discussions/YYYYMMDD_<topic>.md`.
---

# Discuss with DeepSeek

Facilitate a multi-round autonomous debate between this session and DeepSeek, then write up the result.

## Why this skill exists

DeepSeek's reasoning model (`deepseek-reasoner`) is well-suited to extended chain-of-thought on structured problems and is trained differently from western labs' models — it often produces takes that neither Claude nor GPT reach on their own. The facilitator (this session) drives the debate.

## How to talk to DeepSeek

```bash
python3 ~/.claude/skills/discuss-deepseek/scripts/deepseek_chat.py "<prompt>"
```

Under Codex the same file is at `~/.codex/skills/discuss-deepseek/scripts/deepseek_chat.py`.

The script:
- Reads `DEEPSEEK_API_KEY` from environment, then `$PWD/.env`, then `$HOME/.env`
- Queries the models endpoint and prefers `deepseek-reasoner` when available, falling back to `deepseek-chat`
- Uses a 120s timeout

Prompts in English; final writeup in the user's language. Heredocs for multi-line prompts.

## Running the discussion

### 1. Prep

- Project layout
- Relevant file contents
- User's question

### 2. Round loop

Same pattern as other `discuss-*` skills:

```
We are discussing: <topic>

Project context:
<relevant snippets, file paths, constraints>

Discussion so far:
- Round 1: <one-line summary>
...

Your last point was: <summary>
My response: <agree/push back/extend; next question>

Give me your direct take. Be specific and concrete.
```

Synthesise honestly between rounds.

### 3. Convergence

Stop on mutual agreement, exhausted argument space, or after 5-8 rounds.

### 4. Writeup

Save to `discussions/YYYYMMDD_<topic>.md`:

```markdown
# <topic>

**Date:** YYYY-MM-DD
**Participants:** Claude (Anthropic), DeepSeek
**Rounds:** N

## Summary
<3-5 sentences>

## Decisions
- ...

## Key points

### <point 1>
- **Claude:** ...
- **DeepSeek:** ...
- **Resolution:** ...

## Open questions (if any)
- ...

## Next actions (if any)
- ...
```

## Notes

- `deepseek-reasoner` can take noticeably longer than chat models; allow ample timeout (180000 ms+)
- Reasoner responses may include `<think>` blocks; surface the final answer but retain the reasoning in your running summary if it was load-bearing
- Run autonomously
