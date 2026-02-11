# Global Claude Code Guidelines

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

What CAN be logged:
- Non-sensitive IDs (UUIDs, generated IDs)
- Operation names and types
- Status codes and error codes
- Timestamps and durations
- Non-sensitive business metrics

**NEVER log whoel objects** - always log specific, direct attributes only.

---

## Commit Guidelines

### Commit Message Format
- Use **imperative mood**: "make xyzzy do frotz" instead of "This patch makes xyzzy do frotz"
- Keep the summary line under 70-75 characters
- Reference bug entries by number and URL when fixing logged bugs
- Include SHA-1 (at least first 12 characters) when referencing commits

### Every commit must have a clear description
- Describe the problem that motivated the change
- Describe user-visible impact (crashes, lockups, performance regressions)
- Quantify optimizations and trade-offs with actual numbers
- Explain what you are actually doing in technical detail

### Commit Separation
- Separate each logical change into a separate commit
- Bug fixes and performance enhancements should be different commits
- API updates and new features using that API should be separate commits
- Each commit should make and easily understood change
- Each commit should be verifiable by reviewers on its own merits

---

## Makefile Best Practices

### Target Naming
- **Namespace all targets** using `/` as delimiter (e.g., `docker/build`)
- **Never use `:` in target names** - breaks dependencies
- Group targets by namespace into separate files (e.g., `tasks/Makefile.docker`)

### Organization
- Use `include` for modular Makefiles
- **Avoid using $(eval ...)** - leads to confusing execution paths
- Use `?=` to set default variable values
- Keep targets small and focused - delegate complex logic to shell scripts

### Standard Targets
Every project should have: `have`, `deps`, `build`, `test`, `clean`

### Best Practices
- Use target dependencies for prerequisites
- Declare non-file targets as `.PHONY`
- Use `@` prefix to suppress command echo for clean output
- Implement a self-documenting help target using `##` comments

---

## Rust Project Guidelines

### Core Style and Formatting
- Always run `cargo fmt` before committing
- Follow standard Rust naming conventions (snake_case for functions/variables, PascalCase for types)
- Use idiomatic Rust patterns and avoid unnecessary clones
- Maximum line length: 100 characters (configured in rustfmt.toml)

### Error Handling
- Use `Result<T, E>` for operations that can fail
- Use `anyhow` or `thiserror` for error handling (specify which one your project uses)
- Avoid unwrap() and expect() in production code except in tests or when panic is truly the correct behavior
- Provide meaningful error messages with context
- Use `?` operator for error propagation

### Documentation
- Add doc comments (///) for all public items
- **DO NOT use comments for complex functions** - keep code as clean as possible
- Run `cargo doc` to verify documentation builds correctly
- Add module-level documentation explaining the purpose of each module

### Testing
- Write unit tests for all public functions
- Place unit tests in a `tests` module at the bottom of each file
- Integration tests go in the `tests/` directory
- Run `cargo test` before committing
- Aim for meaningful test coverage, not just high percentages
- Use test fixtures defined in tests/fixtures.rs
- Mock external services in tests

### Dependencies and Features
- Keep dependencies minimal and well-justified
- Use specific version requirements, avoid wildcards
- Enable only necessary feature flags
- Run `cargo clippy` to catch common mistakes
- Run `cargo check` frequently during development

### Architecture Patterns
- Keep handlers thin - business logic belongs in services
- Use dependency injection via constructor parameters
- Main logic should be in lib.rs, not main.rs (for CLI tools)
- Keep main.rs minimal - just CLI setup and calling lib functions

### Async/Concurrency
- Use tokio runtime for async operations
- All I/O operations must be async
- Use Arc<Mutex<T>> sparingly - prefer message passing with channels
- Don't block the runtime - use spawn_blocking for CPU-intensive work

### Security
- Validate and sanitize all user input
- Use parameterized queries to prevent SQL injection
- Hash passwords with bcrypt or argon2
- Use secure random for tokens (rand crate with OsRng)

### Before Committing Checklist
1. `cargo fmt`
2. `cargo clippy -- -D warnings`
3. `cargo test --all-features`
4. `cargo doc --no-deps` (verify docs build)
5. Check for unused dependencies with cargo-udeps
