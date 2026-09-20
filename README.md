# Job Tracker Backend

A Rails API for tracking job applications: which companies you've applied to,
what stage each application is in, which resume version you used, and the
metrics job seekers care about (response rate, interview rate, offer rate,
application trends over time, and performance by resume/tag/company).

## Stack

* Ruby 3.1.6, Rails 6.0 (API-only)
* PostgreSQL
* JWT auth (`jwt` gem) with `has_secure_password`
* `active_model_serializers` for JSON responses

## Setup

```bash
bundle install
rails db:create
rails db:migrate
rails db:seed   # optional: creates a demo user + ~40 sample applications
rails server
```

Seeded demo login: `username: demo`, `password: password`.

Run the test suite with `rails test`.

## Data model

* **User** — has many jobs and resumes, authenticates via `has_secure_password`.
* **Resume** — a named resume version (`"Backend Engineer v1"`) belonging to a user.
* **Job** — a single application: company, title, `status` enum
  (`applied`, `phone_screen`, `interviewing`, `offer`, `rejected`, `withdrawn`),
  `applied_date`, free-form `notes`, optional `resume`, and `responded_at`
  (stamped automatically the first time status moves off `applied`).
* **Tag** — a label (e.g. `remote`, `backend`) attached to jobs many-to-many
  through **JobsTag**.

## Auth

Sign up or log in to get a JWT, then send it as `Authorization: Bearer <token>`
on every other request. All job/resume/stat data is scoped to the
authenticated user.

```
POST /api/v1/signup      { username, password }        -> { user, token }
POST /api/v1/login       { username, password }         -> { user, token }
GET  /api/v1/auto_login                                 -> current user (validates token)
GET  /api/v1/profile                                    -> current user
```

## Jobs

```
GET    /api/v1/jobs                 optional ?status=interviewing filter
GET    /api/v1/jobs/:id
POST   /api/v1/jobs                 { company_name, title, status, applied_date, notes,
                                       resume_id, tag_names: ["remote", "backend"] }
PATCH  /api/v1/jobs/:id
DELETE /api/v1/jobs/:id
```

## Resumes / Tags / JobsTags

```
GET/POST/PATCH/DELETE  /api/v1/resumes(/:id)
GET/POST/PATCH/DELETE  /api/v1/tags(/:id)
GET/POST/DELETE        /api/v1/jobs_tags(/:id)   { job_id, tag_id } to link a tag to a job
```

## Metrics

```
GET /api/v1/stats
```

Returns, scoped to the current user:

* `total_applications`, `by_status` counts for every status
* `rates` — `response_rate`, `interview_rate`, `offer_rate`
* `applications_per_week` — a trend line of applications by week
* `average_days_to_first_response`
* `by_tag`, `by_company` — application counts grouped each way
* `by_resume` — total applications, response rate, and offer rate per resume,
  so you can see which resume version performs best
