---
name: discuss-gemini
description: Run an autonomous multi-round debate between the current session and Gemini (Google) to stress-test an idea and converge on a conclusion. Use this whenever the user says "discuss with Gemini", "geminiと議論して", "geminiと相談して", "geminiの意見を聞いて", "geminiとブレストして", "googleと議論して", or otherwise asks for a Gemini second opinion on a design, strategy, architecture choice, or tradeoff. Particularly useful for topics that benefit from Google's research/grounding strengths. Summarises the conversation to `discussions/YYYYMMDD_<topic>.md`.
---

# Discuss with Gemini

Facilitate a multi-round autonomous debate between this session and Gemini (Google), then write up the result.

## Why this skill exists

Gemini brings a distinct training signal from a different research lab; its takes on search-heavy, research-heavy, or multimodal-adjacent topics often differ usefully from Claude's. The facilitator (this session) drives the debate.

## How to talk to Gemini

Use the bundled script:

```bash
python3 ~/.claude/skills/discuss-gemini/scripts/gemini_chat.py "<prompt>"
```

If running under Codex, the same file is at `~/.codex/skills/discuss-gemini/scripts/gemini_chat.py` — both paths resolve to the same script via the dotfiles symlinks.

The script:
- Reads `GEMINI_API_KEY` from environment, then `$PWD/.env`, then `$HOME/.env`
- Queries the models endpoint and picks the strongest available Gemini model
- Uses a 120s generation timeout

Prompts go out in English (Gemini reasons better in English); final writeup follows the user's language. Shell-quote carefully — prefer heredocs when the prompt contains backticks, dollars, or single quotes.

## Running the discussion

### 1. Prep

- Project layout
- Relevant file contents
- User's question

### 2. Round loop

**Opening.** Topic + context + specific question, ask for a direct opinionated take.

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

Between rounds, synthesise honestly: acknowledge landing points, push back where weak, introduce missing angles.

### 3. Convergence

Stop when both sides agree, the argument space is exhausted, or after 5-8 rounds.

### 4. Writeup

Save to `discussions/YYYYMMDD_<topic>.md`:

```markdown
# <topic>

**Date:** YYYY-MM-DD
**Participants:** Claude (Anthropic), Gemini (Google)
**Rounds:** N

## Summary
<3-5 sentences>

## Decisions
- ...

## Key points

### <point 1>
- **Claude:** ...
- **Gemini:** ...
- **Resolution:** ...

## Open questions (if any)
- ...

## Next actions (if any)
- ...
```

## Notes

- Bash timeout: 180000 ms+
- Run autonomously; summary at the end
- Compress running summary as it grows
