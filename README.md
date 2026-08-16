# Fitness Tracker API — Rails 8

A JSON API for a fitness tracking app. Users keep a profile, browse a workout catalogue, favourite what they like, log the sessions they actually do, and get recommendations back from that history. Admins manage the catalogue.

Auth is **hand-rolled JWT** rather than Devise — access tokens plus refresh, with a `jti` column on `users` so tokens can be invalidated on logout.

## Features

- **JWT authentication** — signup, login, refresh, logout, and password reset by token
- **Profiles** — age, weight, gender, goals, muscle focus, training intensity
- **Workout catalogue** — read-only for users, full CRUD under an admin namespace
- **Favourites** — save workouts to come back to
- **Selections** — session history with `started_at`, `completed_at`, `duration_seconds`
- **Analytics** — most-selected workouts, globally and per user
- **Recommendations** — trending across all users, and personalised from your own history
- **Todos** — a simple companion checklist resource

## Data model

```
User ─┬─ Profile          (1:1)
      ├─ Favorite ── Workout
      └─ Selection ── Workout   (with timing columns)
Todo                            (standalone)
```

An ERD is committed as [`app_erd.png`](app_erd.png).

## API surface

**Auth**

| Method | Route |
|---|---|
| `POST` | `/signup` |
| `POST` | `/login` |
| `POST` | `/refresh` |
| `DELETE` | `/logout` |
| `POST` | `/password/forgot` |
| `POST` | `/password/reset` |

**Resources**

| Method | Route | Notes |
|---|---|---|
| `GET/PATCH` | `/profile` | Singular resource for the current user |
| `GET` | `/workouts`, `/workouts/:id` | Read-only for regular users |
| `GET/POST/DELETE` | `/favorites` | |
| `GET/POST` | `/selections` | Session history |
| `GET` | `/me/most_selected_workouts` | Per-user analytics |
| `GET` | `/analytics/most_selected` | Global analytics |
| `GET` | `/recommendations/trending` | Global |
| `GET` | `/recommendations/personalized` | Per-user |
| — | `/todos` | Full CRUD |
| — | `/admin/workouts` | Admin-only catalogue management |

## Stack

Rails 8 · MySQL · JWT (`app/lib/json_web_token.rb`) · Active Storage · Docker · Kamal for deploy · RuboCop + Brakeman · GitHub Actions CI

## Running it locally

```bash
bundle install
bin/rails db:create db:migrate db:seed
bin/dev
```

Requires Ruby as pinned in `.ruby-version` and a running MySQL instance.

## Quality gates

CI runs on every push via [`.github/workflows/ci.yml`](.github/workflows/ci.yml) — Brakeman for security scanning, RuboCop for style, and the test suite.

```bash
bin/rubocop      # style
bin/brakeman     # security scan
bin/rails test   # tests
```
