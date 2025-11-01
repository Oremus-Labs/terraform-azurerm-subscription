.PHONY: init fmt validate tflint docs pre-commit-install pre-commit tools

BIN := .bin
PATH := $(PWD)/$(BIN):$(PATH)

TERRAFORM_DOCS_VERSION ?= v0.17.0
TFLINT_VERSION ?= v0.53.0

init:
	terraform init -backend=false -upgrade

fmt:
	terraform fmt -recursive

validate: init
	terraform validate

tflint: tools
	tflint -c .tflint.hcl --recursive

docs: tools
	terraform-docs -c .terraform-docs.yml .

pre-commit-install:
	pre-commit install

pre-commit:
	pre-commit run --all-files

tools: $(BIN)/terraform-docs $(BIN)/tflint

$(BIN)/terraform-docs:
	@mkdir -p $(BIN)
	@os=$$(uname | tr '[:upper:]' '[:lower:]'); arch=$$(uname -m); \
	case "$$arch" in \
		x86_64) arch=amd64;; \
		arm64) arch=arm64;; \
		aarch64) arch=arm64;; \
		*) echo "Unsupported arch: $$arch" && exit 1;; \
	 esac; \
	url="https://github.com/terraform-docs/terraform-docs/releases/download/$(TERRAFORM_DOCS_VERSION)/terraform-docs-$(TERRAFORM_DOCS_VERSION)-$${os}-$${arch}.tar.gz"; \
	curl -sSL $$url | tar -xz -C $(BIN) terraform-docs
	@chmod +x $(BIN)/terraform-docs

$(BIN)/tflint:
	@mkdir -p $(BIN)
	@os=$$(uname | tr '[:upper:]' '[:lower:]'); arch=$$(uname -m); \
	case "$$arch" in \
		x86_64) arch=amd64;; \
		arm64) arch=arm64;; \
		aarch64) arch=arm64;; \
		*) echo "Unsupported arch: $$arch" && exit 1;; \
	 esac; \
	url="https://github.com/terraform-linters/tflint/releases/download/$(TFLINT_VERSION)/tflint_$${os}_$${arch}.zip"; \
	curl -sSL -o $(BIN)/tflint.zip $$url && unzip -o -d $(BIN) $(BIN)/tflint.zip && rm $(BIN)/tflint.zip
	@chmod +x $(BIN)/tflint
