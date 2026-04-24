---
name: discuss-codex
description: Run an autonomous multi-round debate between the current session and Codex (OpenAI) via `codex exec` to stress-test an idea and converge on a conclusion. Use this whenever the user says "discuss with Codex", "codexと議論して", "codexと相談して", "codexの意見を聞いて", "codexとブレストして", or otherwise asks for a Codex/GPT second opinion on a design, strategy, architecture choice, or tradeoff. Also a good fit when the user wants a cross-vendor check against Claude. Summarises the conversation to `discussions/YYYYMMDD_<topic>.md`.
---

# Discuss with Codex

Facilitate a multi-round autonomous debate between this session and Codex (OpenAI GPT), then write up the result.

## Why this skill exists

Different model families have different blind spots. A Codex/GPT perspective often surfaces angles a Claude session misses, especially on system-design tradeoffs and language-idiomatic choices. The facilitator (this session) drives the debate.

## How to talk to Codex

```bash
codex exec --dangerously-bypass-approvals-and-sandbox "<prompt>"
```

Each invocation is a fresh stateless session. Include a running summary of prior rounds in every prompt. Prompts go out in English (Codex reasons better in English); the final writeup follows the user's language.

## Running the discussion

### 1. Prep

- Project layout (quick `ls`)
- Relevant file contents
- User's concrete question or decision point

### 2. Round loop

**Opening round.** Topic + context + specific question. Ask for a direct opinionated take.

**Subsequent rounds.**

```
We are discussing: <topic>

Project context:
<relevant snippets, file paths, constraints>

Discussion so far:
- Round 1: <one-line summary>
- Round 2: <one-line summary>
...

Your last point was: <summary of their previous reply>

My response: <agree-with, push back on, or extend; propose the next question>

Give me your direct take. Be specific and concrete.
```

Synthesise honestly between rounds. Acknowledge landing points, push back on weak reasoning, introduce missing angles.

### 3. Convergence

Stop when:
- Both sides agree on substantive points
- Argument space exhausted
- 5+ rounds with agreement on major questions
- 8 rounds max

### 4. Writeup

Save to `discussions/YYYYMMDD_<topic>.md`:

```markdown
# <topic>

**Date:** YYYY-MM-DD
**Participants:** Claude (Anthropic), Codex (OpenAI)
**Rounds:** N

## Summary
<3-5 sentence synthesis>

## Decisions
- ...

## Key points

### <point 1>
- **Claude:** ...
- **Codex:** ...
- **Resolution:** ...

## Open questions (if any)
- ...

## Next actions (if any)
- ...
```

## Notes

- Bash timeout: 180000 ms+; `codex exec` substantive responses can be long
- Escape double quotes in the prompt carefully; prefer heredocs
- Run autonomously — deliver the writeup at the end, not round-by-round
- Compress the running summary as it grows
