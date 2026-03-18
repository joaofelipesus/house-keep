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

Rails 8.1 monolith with PostgreSQL, Hotwire (Turbo + Stimulus), and Propshaft for assets.

**Solid adapters** are used for cache, queue, and cable (no Redis required).

### Key conventions

- **i18n**: Default locale is `pt-BR`. All view strings must use `t('.')` lazy lookup. Attribute labels in views reuse `activerecord.attributes.*` via `Model.human_attribute_name(:attr)`. Locale files are at `config/locales/en.yml` and `config/locales/pt-BR.yml`.
- **CSS**: Design tokens are defined as CSS custom properties in `application.css` (`:root`). All spacing uses `--space-*` tokens, colors use `--color-*`, and pixel values must use `calc(var(--base) * n)` where `--base: 4px`. Component styles go in `components.css`, form styles in `form.css`.
- **Forms**: The shared error partial is at `app/views/layouts/components/forms/_errors.html.erb` and accepts a `record:` local. Form fields use `.form-field` / `.form-field-inline` classes. Rails' `field_with_errors` wrapper is neutralized with `display: contents`.
- **Rubocop**: Max line length is 120. `Style/HashSyntax` and `Style/Documentation` are disabled.
