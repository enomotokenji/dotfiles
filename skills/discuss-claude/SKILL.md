---
name: discuss-claude
description: Run an autonomous multi-round debate between the current session and a fresh Claude instance (via `claude -p`) to stress-test an idea and converge on a conclusion. Use this whenever the user says "discuss with Claude", "claudeと議論して", "claudeと相談して", "claudeの意見を聞いて", "claudeとブレストして", or otherwise asks for a second Claude opinion on a design, strategy, architecture choice, tradeoff, or anything where two Claude sessions batting a problem back and forth would produce a better answer than one. Even if the user only says "let's think this through harder" without naming Claude, this skill is a reasonable fit. Summarises the conversation to `discussions/YYYYMMDD_<topic>.md`.
---

# Discuss with Claude

Facilitate a multi-round autonomous debate between this session and a fresh Claude instance, then write up the result.

## Why this skill exists

Two Claude sessions approaching the same problem from independent contexts often surface tradeoffs, edge cases, and implicit assumptions that a single session misses. The facilitator (this session) drives the debate: proposes the opening frame, challenges responses, introduces new angles, and decides when the discussion has converged.

## How to talk to the other Claude

```bash
claude -p --dangerously-skip-permissions "<prompt>"
```

Each invocation is a fresh stateless session — there is no memory between rounds. Include the running summary of prior rounds in every prompt so the other side retains context. `--dangerously-skip-permissions` suppresses the subprocess's interactive permission prompts so the debate runs autonomously; the sandbox remains in force. This is appropriate because the subagent is reasoning about a topic, not editing the filesystem.

Prompts go out in English (better reasoning quality); the final writeup follows the user's language.

## Running the discussion

### 1. Prep

Before round 1, gather what the other Claude will need to engage substantively:

- Project layout (quick `ls` of relevant dirs)
- Relevant file contents for the topic
- The user's concrete question or decision point, in one paragraph

### 2. Round loop

**Opening round.** Send the topic, the context, and the specific question. Ask for a direct, opinionated take.

**Subsequent rounds.** Use this prompt shape so the other Claude stays grounded:

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

Between rounds, synthesise honestly. Acknowledge points that land. Push back where the reasoning is weak. Introduce angles that are missing. The goal is to converge on something true, not to win.

### 3. Convergence

Stop when any of these hold:

- Both sides agree on the substantive points
- The argument space is exhausted (no new angles appearing)
- 5+ rounds in with agreement on the major questions
- 8 rounds max — beyond this, cut losses and document the disagreement

### 4. Writeup

Save to `discussions/YYYYMMDD_<topic>.md` (create the dir if needed):

```markdown
# <topic>

**Date:** YYYY-MM-DD
**Participants:** Claude (this session), Claude (fresh instance)
**Rounds:** N

## Summary

<3-5 sentence synthesis of the whole debate>

## Decisions

- <concrete agreed-on decisions as bullets>

## Key points

### <point 1>
- **This session's position:** ...
- **Other Claude's position:** ...
- **Resolution:** ...

### <point 2>
...

## Open questions (if any)

- <unresolved>

## Next actions (if any)

- <concrete follow-up>
```

## Notes

- Set the Bash timeout generously (180000 ms+); `claude -p` can take a while on substantive prompts
- Escape quotes in the prompt. Heredoc is the safe default
- Do not interrupt the user between rounds — run autonomously and deliver the writeup at the end
- The terminal shows each round's output live, so the user can follow along
- Compress the running summary when it gets long; never dump the full prior transcript into a new prompt
