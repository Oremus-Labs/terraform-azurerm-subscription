# Contributing

- Install dependencies: Terraform, TFLint, terraform-docs, pre-commit
- Enable hooks: `pre-commit install`
- Run locally before pushing: `pre-commit run --all-files`
- Use Conventional Commits (feat:, fix:, chore:, docs:, refactor:, ci:, build:)

Release process is automated via release-please; merging the release PR will create a tag and GitHub release that the Terraform Registry picks up.
