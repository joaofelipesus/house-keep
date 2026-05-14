---
name: feedback-use-rails-generators
description: User prefers using rails generate commands for migrations, Stimulus controllers, and other generated files instead of creating them manually
metadata:
  type: feedback
---

Always use `rails generate` (or `rails g`) for anything Rails can generate: migrations, Stimulus controllers, models, scaffolds, etc. Do not manually create these files with Write/Edit.

**Why:** User explicitly requested this approach — generators ensure correct file placement, naming conventions, and boilerplate.

**How to apply:** Before creating a migration, controller, Stimulus controller, or model file manually, check if `rails generate` can do it. Use it instead. Examples:
- Migrations: `rails generate migration AddColumnToTable column:type`
- Stimulus: `rails generate stimulus controller_name`
- Models: `rails generate model ModelName attr:type`
