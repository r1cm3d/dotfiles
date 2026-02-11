# Commit Command

Create a commit following the project's commit guidelines (based on Linux kernel patch submission guidelines).

## Instructions

1. **Analyze the staged changes** by running `git diff --cached` to understand what is being committed.
2. **Craft a commit message** following these rules:

### Describe your changes
- **CRITICAL**: Describe the problem that motivated the change
- Describe user-visible impact (crashes, lockups, performance regressions)
- Quantify optimizations and trade-offs with actual numbers when applicable
- Explain what you are actually doing in technical details

### Commit message format
- Use **imperative mood**: "make xyzzy do frotz" instead of "This patch makes xyzzy do frotz"
- Reference bug entries by number and URL when fixing logged bugs (e.g., JIRA tickets)
- Incluse SHA-1 (at least first 12 characters) when referencing commits
- Keep the summary live under 70-75 characters
- **ALWAYS** end the commit with a `Signed-off-by` line using the current git user (get name and email from `git config user.name` and `git config user.email`)

### Good vs Bad examples

**Problem description:**
 ```
# ❌BAD: Vague description
Fix bug in driver

# ✅ GOOD: Clear problem and impact description
Fix null pointer deference in network driver

The network driver crashes when the interface is brought up without a cable connected. This affects users running the driver on laptops where cables are frequently disconnected.
```

**Technical explanation:**
```
# ❌ BAD: No technical detail
Changed the code to work better

# ✅ GOOD: Technical detail in plain English
Initialize the rx_buffer pointer before checking the link status to prevent dereferencing uninitialized memory when no cable is present.
```

### Separation of concerns
- Each commit should make an easily understood change
- Bug fixes and performance enhancements should be different commits
- Each commit shoudl be verifiable by reviwers on its own merits

3. **Execute the commit** using the crafted message with propert formatting.

## Process

1. Run `git status` to se all changes (staged and unstaged)
2. Run `git add .` to stage ALL changes (both tracked and untracked files)
3. Run `git diff --cached` to see what will be commited
4. Review recent commits with `git log --oneline -5` to match the project's style
5. Get the current git user with `git config user.name` and `git config user.email`
6. Create a well-structured commit message following the guidelines above, ending with `Signed-off-by: <name> <email>
7. Execute `git commit` with the message (do NOT use Co-Authored-By, only use Signed-off-by with the git user)
