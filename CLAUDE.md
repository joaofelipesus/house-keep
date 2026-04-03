# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Start the server
rails s

# Run all tests
rails test

# Run a single test file
rails test test/controllers/bills_controller_test.rb

# Run system tests
rails test:system

# Lint
rubocop

# Lint and auto-fix
rubocop -a

# Security audit
brakeman
bundle audit
```

## Architecture

Rails 8.1 monolith with PostgreSQL, Hotwire (Turbo + Stimulus), and Propshaft for assets. Solid adapters are used for cache, queue, and cable (no Redis required). Generators are configured to skip helper file generation.

### Key conventions

- **i18n**: Default locale is `pt-BR`. All view strings must use `t('.')` lazy lookup. Attribute labels reuse `activerecord.attributes.*` via `Model.human_attribute_name(:attr)`. Model name translations use `one`/`other` keys for pluralization. Locale files are at `config/locales/pt-BR.yml` and `config/locales/en.yml`.

- **CSS**: Design tokens in `application.css` (`:root`). Spacing uses `--space-*`, colors use `--color-*`, pixel values use `calc(var(--base) * n)` where `--base: 4px`. No inline styles — always extract to a class. File layout: `application.css` (tokens + global), `components.css` (UI components), `form.css` (form elements), `table.css` (table component).

- **CSS classes**: Page layout uses `.page-header` / `.page-title` / `.page-actions`. Buttons use `.btn` with modifiers `.btn-primary`, `.btn-ghost`, `.btn-danger`, `.btn-sm`. The table component uses `.table-wrapper` > `.table` with inner classes `.table-name`, `.table-logo`, `.table-info`, `.table-title`, `.table-description`, `.table-value`, `.table-muted`, `.table-actions`, `.table-empty`. Detail views use `.detail-card` with `.detail-card-header`, `.detail-card-body`, `.detail-field`, `.detail-field-label`, `.detail-field-value`.

- **Forms**: The shared error partial is at `app/views/layouts/components/forms/_errors.html.erb` and accepts a `record:` local. Form fields use `.form-field` / `.form-field-inline`. Rails' `field_with_errors` wrapper is neutralized with `display: contents`.

- **Stimulus**: Controllers live under `app/javascript/controllers/`. Namespaced controllers use directory nesting (e.g. `bills/form_controller.js` connects via `data-controller="bills--form"`).

- **Partials**: Shared layout components live at `app/views/layouts/components/`. Partials that accept locals use the `<%# locals: (foo:, bar:) %>` magic comment on line 1 to enforce required locals.

- **Rubocop**: Max line length is 120. `Style/HashSyntax` and `Style/Documentation` are disabled.

- **Tests**: Model tests use fixtures (`test/fixtures/`). Controller tests use `ActionDispatch::IntegrationTest`. Helper tests use `ActionView::TestCase`. Error message assertions use the pt-BR locale strings directly.
