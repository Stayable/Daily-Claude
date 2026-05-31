Snapshot this conversation and commit it to git. Execute exactly these steps:

1. Read `session.md` to get the active chat file path (the `Chat:` line).
2. Read that chat file.
3. Rewrite its `## SUMMARY` section (replace everything between `## SUMMARY` and the next `##` heading, or end of file) with:

```
## SUMMARY
*Last saved: [today's date and time]*

### Accomplished
[Bullet list — what was done, decided, or produced this session]

### Key Decisions
[Bullet list — specific decisions with enough context to understand them cold]

### Open Items
[Checkbox list — carry forward any unchecked items from previous summary, plus new ones]

### Next Steps
[1–2 sentences on exactly where to pick up]
```

4. Update the `last_saved:` field in the file's frontmatter to today's date.
5. Read `chats/_index.md`, find the row matching this chat file, and update its status/description if needed.
6. Run these git commands sequentially:
   - `git add -A`
   - `git commit -m "save: [3-5 word description of this session]"`
   - `git push origin main`
7. Reply with a single line: `Saved. [One sentence recap of what was committed.]`

Keep the entire SUMMARY under 400 words. The goal is minimum context to resume cold — not a transcript.
