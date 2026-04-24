---
name: discuss-grok
description: Run an autonomous multi-round debate between the current session and Grok (xAI) to stress-test an idea and converge on a conclusion. Use this whenever the user says "discuss with Grok", "grokと議論して", "grokと相談して", "grokの意見を聞いて", "grokとブレストして", "xaiと議論して", or otherwise asks for a Grok second opinion on a design, strategy, architecture choice, or tradeoff. Summarises the conversation to `discussions/YYYYMMDD_<topic>.md`.
---

# Discuss with Grok

Facilitate a multi-round autonomous debate between this session and Grok (xAI), then write up the result.

## Why this skill exists

Grok has a distinct training signal and can give takes that differ from Claude/GPT/Gemini, particularly on contrarian framings and on topics where its reasoning variants (`*-reasoning`) shine. The facilitator (this session) drives the debate.

## How to talk to Grok

```bash
python3 ~/.claude/skills/discuss-grok/scripts/grok_chat.py "<prompt>"
```

Under Codex: `~/.codex/skills/discuss-grok/scripts/grok_chat.py`.

The script:
- Reads `XAI_API_KEY` from environment, then `$PWD/.env`, then `$HOME/.env`
- Queries the models endpoint and prefers reasoning variants when available
- Uses a 120s timeout

Prompts in English; final writeup in the user's language. Heredocs for multi-line.

## Running the discussion

### 1. Prep

- Project layout
- Relevant file contents
- User's question

### 2. Round loop

Same structure as other `discuss-*` skills:

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
**Participants:** Claude (Anthropic), Grok (xAI)
**Rounds:** N

## Summary
<3-5 sentences>

## Decisions
- ...

## Key points

### <point 1>
- **Claude:** ...
- **Grok:** ...
- **Resolution:** ...

## Open questions (if any)
- ...

## Next actions (if any)
- ...
```

## Notes

- Allow ample Bash timeout (180000 ms+), especially for reasoning variants
- Run autonomously
