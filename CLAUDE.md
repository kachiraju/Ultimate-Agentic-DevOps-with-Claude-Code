# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Static HTML/CSS portfolio website deployed to AWS using S3 and CloudFront, provisioned with Terraform, and automated via GitHub Actions

## Architecture

- Pure HTML5 and CSS3. 
- No JavaScript. 
- No build step. 
- No framework.

## Commands
- terraform init
- terraform plan, 
- terraform apply

## Conventions
- All infrastructure changes go through Terraform — never modify AWS resources manually
- No JavaScript in this project
- CSS uses mobile-first approach with breakpoints at 900px, 768px, and 600px

## Safety
> "Never put secrets in this file. No API keys, passwords, or AWS credentials."

## Mandatory Ownership Proof (DMI rule)

Before deploying, edit the `index.html` footer (around line 604) to add a "Deployed by" line identifying the student/cohort/group/date, e.g.:

```html
<p><strong>Deployed by:</strong> DMI Cohort 2 | <Name> | Group 4 | Week 1 | <date></p>
```

This proof must be visible in the browser screenshot submission. See `README.md` for the full assignment rules.

## Deployment

Two paths exist in the repo. **The Nginx path is the actual DMI assignment.**

### 1. Nginx on an Ubuntu VM (assignment target)
Install Nginx, copy the site files (`index.html`, `privacy.html`, `terms.html`, `style.css`, `images/`) into `/var/www/html/`, enable the service, and serve at `http://<public-ip>`.

### 2. AWS S3 + CloudFront via GitHub Actions
`.github/workflows/deploy.yml` triggers on push to `main`: it `aws s3 sync`s the site (excluding `.git`, `.github`, `.claude`, `terraform`, `.mcp.json`, `*.md`) then invalidates CloudFront. It authenticates via GitHub OIDC (no stored keys).

> ⚠️ The workflow is hardcoded to the **original author's** AWS resources — IAM role `arn:aws:iam::533267262133:...`, bucket `pravinmishradmi-site-production`, CloudFront `E3V6O6MRE2E21P`, region `eu-north-1`. To use it yourself, replace all four values with your own account's resources first.

## Skills (`.claude/skills/`)

Four skills exist, all marked `disable-model-invocation: true` (**manual invocation only** — do not auto-run them):

- `/scaffold-terraform [region] [name]` — generates a full `terraform/` config for S3 + CloudFront hosting, following `.claude/skills/scaffold-terraform/template-spec.md`. Defaults: region `ap-south-1`, name `portfolio-site`.
- `/tf-plan` — `terraform plan -no-color` + risk/blast-radius analysis.
- `/tf-apply` — `terraform apply -auto-approve -no-color` + verifies CloudFront reaches "Deployed". Does **not** auto-retry on failure.
- `/deploy` — `aws s3 sync` + CloudFront invalidation, reading bucket/distribution IDs from `terraform output`.

Note: `/tf-plan`, `/tf-apply`, and `/deploy` assume a `terraform/` directory that does **not exist yet** — run `/scaffold-terraform` to generate it first.

## Repo State Caveats

- The working tree currently shows `CLAUDE.md`, `.github/workflows/deploy.yml`, and the four `.claude/skills/*` files as **deleted (uncommitted)**. If that deletion is unintended, `git restore .` before working.
- There is **no** `terraform/` directory, `.claude/agents/`, `.mcp.json`, or hook configuration in the repo, despite any prior documentation referencing them. Don't assume they exist.
