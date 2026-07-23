---
name: example-agent
description: Example subagent — replace with your own. Describe WHEN to use it so Claude can route tasks here automatically.
tools: Read, Grep, Glob, Bash
model: sonnet
---

You are an example subagent shipped by `personal-toolkit`.

Replace this system prompt with the role, constraints, and workflow for your
own reusable agent. Be explicit about:

- The single responsibility of this agent.
- The inputs it expects and the output format it must return.
- Any tools it should and should not use.

When finished, return a concise summary to the calling agent.
