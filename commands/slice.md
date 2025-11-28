---
description: Plan next Rust learning task based on current level
---

## Initialization

First, check if `.claude/tutor/state.json` exists in the current project.

If it does NOT exist, initialize the tutor structure:

1. **Handle CLAUDE.md with version checking:**
   - Check if `CLAUDE.md` exists in project root
   - If it EXISTS:
     - Read the file and search for marker: `<!-- RUST TUTOR PLUGIN INSTRUCTIONS v1.0.4 -->`
     - If marker with version `1.0.4` found: Skip CLAUDE.md update (already current)
     - If marker with older version found (e.g., `v1.0.0`): Remove old tutor section (everything between `<!-- RUST TUTOR PLUGIN INSTRUCTIONS v*` and `<!-- END RUST TUTOR PLUGIN INSTRUCTIONS -->`), then append new version
     - If NO marker found: Append tutor instructions to the end with markers
   - If it DOES NOT exist: Copy `${CLAUDE_PLUGIN_ROOT}/config/CLAUDE.md` → `./CLAUDE.md` and add version marker at the top

   **When appending or updating, use this format:**
   ```markdown

   <!-- ========================================= -->
   <!-- RUST TUTOR PLUGIN INSTRUCTIONS v1.0.4 -->
   <!-- Auto-added by tutor plugin -->
   <!-- ========================================= -->

   [Full contents of ${CLAUDE_PLUGIN_ROOT}/config/CLAUDE.md]

   <!-- END RUST TUTOR PLUGIN INSTRUCTIONS -->
   <!-- ========================================= -->
   ```

2. **Create directories and copy template files:**
   - Create directories: `.claude/tutor/` and `.claude/tutor/logs/`
   - Copy template files from the plugin to the user's project:
     - `${CLAUDE_PLUGIN_ROOT}/config/state.template.json` → `.claude/tutor/state.json`
     - `${CLAUDE_PLUGIN_ROOT}/config/levels.yaml` → `.claude/tutor/levels.yaml`
     - `${CLAUDE_PLUGIN_ROOT}/config/complexity-map.yaml` → `.claude/tutor/complexity-map.yaml`
   - Create log directory placeholder: `.claude/tutor/logs/.gitkeep` (empty file)

3. **Inform the user:**
   - If CLAUDE.md was created fresh: "Tutor initialized! Learning state created at `.claude/tutor/` and CLAUDE.md installed. Let's start your first learning task!"
   - If CLAUDE.md was appended/updated: "Tutor initialized! Learning state created at `.claude/tutor/` and tutor instructions added to your existing CLAUDE.md. Let's start your first learning task!"
   - If CLAUDE.md was skipped (already current): "Tutor initialized! Learning state created at `.claude/tutor/`. Your CLAUDE.md already has current tutor instructions. Let's start your first learning task!"

If state.json DOES exist, proceed directly to planning the next slice.

## Plan Next Slice

Read `.claude/tutor/state.json` to determine the user's current level, completed slices, and streak.

Read `.claude/tutor/levels.yaml` to get the topics, constraints, and examples for the current level.

Read `CLAUDE.md` for the full workflow, Rust best practices, and tutoring methodology.

## Your Task

Propose a learning task that:
1. Chooses ONE topic from the current level's topic list
2. Respects the `max_loc` constraint from levels.yaml
3. Teaches a practical Rust pattern (not a toy example)
4. Builds on previously completed slices (check history if available)

## Output Format

```markdown
Level {level} ({level_name}) - Slice {completed + 1}

**Goal**: {Clear, one-sentence description of what to implement}

**Topic**: {Which learning topic(s) this covers}

**File**: {Exact path where code should go, e.g., `crates/core/src/lib.rs` or `src/lib.rs`}

**Test** (add to {test_file_path}):
```rust
{Comprehensive failing test code - include multiple test cases covering happy path and edge cases}
```

**Stub** (add to {implementation_file_path}):
```rust
{Function signature with doc comment + placeholder return value}
{The stub MUST compile but WILL fail the tests}
```

**Acceptance Criteria**:
- {Criterion 1, e.g., "All tests pass"}
- {Criterion 2, e.g., "No allocations (use iterators)"}
- {Criterion 3, e.g., "Handles empty slice gracefully"}
- {...}

**Resources**: {Links to relevant Rust documentation or blog posts, if helpful}

---

Now implement the function. When done, run `/gate` to verify your work.
```

## Important Constraints

- **DO NOT implement the function body** - only provide the signature and placeholder
- **The stub must compile** - correct types, correct signature
- **Tests must be comprehensive** - happy path + at least 2 edge cases
- **Be encouraging** - this is a learning exercise, not a test to fail

## Workspace Detection

- If `crates/` directory exists: assume workspace, suggest `crates/core/src/lib.rs` or similar
- If only `src/` exists: assume single crate, suggest `src/lib.rs` or `src/main.rs`
- If neither exists: warn user to initialize a Rust project first

## Examples

See `.claude/tutor/levels.yaml` for example tasks per level. Draw inspiration but create variations to keep learning fresh.
