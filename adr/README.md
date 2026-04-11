# Architecture Decision Records

ADRs capture significant decisions — what was decided, why, what alternatives were considered, and the current status.

## Where ADRs Live

**This directory** is for decisions that genuinely span multiple projects — e.g., "we always use PAM8403 for amplification across all builds" or "we standardise on Python 3 for all Pi scripts."

**Project-level ADRs** live in `projects/<name>/adr/` and cover decisions specific to that project. This is where most ADRs end up.

Currently there are no cross-project ADRs. When one is needed, use the naming convention `NNN-short-title.md` and add it here.

## When to Write an ADR

Write an ADR when:
- You evaluated real alternatives before deciding
- You want future-you (or your son) to understand *why* things are set up a particular way
- The decision involved significant research or experimentation

Minor project-specific choices (e.g., "I soldered the speaker on the left") belong in the project's `DECISIONS.md` instead.
