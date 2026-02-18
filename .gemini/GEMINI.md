# Global Gemini CLI Guidelines

## General Policies

### Language Policy
- **ALWAYS write code in English** - variable names, function names, class names, files, constants
- **ALWAYS write comments in English** - (when explicitly requested)
- **ALWAYS write documentation in English**
- **ALWAYS write commit messages in English**
- **NEVER use non-English characters** in code identifiers

### Code Comments Policy
- **DO NOT add comments** unless explicitly requested
- Code should be self-documenting through clear naming and structure
- Only add comments when the user specifically asks for them

### Logging Policy
- **NEVER log whole objects** - always log specific, direct attributes only.
- What CAN be logged: Non-sensitive IDs, operation names, status codes, timestamps.

---

## Commit Guidelines
- Use **imperative mood** (e.g., "fix bug", not "fixed bug").
- Keep summary line under 75 characters.
- **CRITICAL**: Describe the problem that motivated the change.
- **ALWAYS** end the commit with a `Signed-off-by` line.
- Separate logical changes into individual commits.

---

## Project Best Practices

### Makefile
- Namespace all targets using `/` (e.g., `docker/build`).
- Every project should have: `have`, `deps`, `build`, `test`, `clean`.
- Use `.PHONY` for non-file targets.

### Rust
- Run `cargo fmt` and `cargo clippy` before committing.
- Use `Result<T, E>` and avoid `unwrap()`.
- Use `anyhow` or `thiserror` for error handling.
- Unit tests in a `tests` module at the bottom of the file.
- Integration tests in the `tests/` directory.
