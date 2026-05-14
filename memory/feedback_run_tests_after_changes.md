---
name: feedback-run-tests-after-changes
description: Always run the full test suite after making changes to the codebase
metadata:
  type: feedback
---

Always run `rails test` after completing any code changes.

**Why:** User wants continuous test validation to catch regressions immediately after edits.

**How to apply:** After finishing a set of code changes in any conversation, run `rails test` and report the results before considering the task done.
