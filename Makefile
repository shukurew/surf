SHELL :=/bin/bash -e -o pipefail
PWD   := $(shell pwd)

.DEFAULT_GOAL := all
.PHONY: all
all: ## build pipeline
all: setup format analyze test

.PHONY: precommit
precommit: ## validate the branch before commit
precommit: all

.PHONY: ci
ci: ## CI build pipeline
ci: analyze test

.PHONY: git-hooks
git-hooks: ## install git hooks
	@git config --local core.hooksPath .githooks/

.PHONY: help
help:
	@echo 'Usage: make <OPTIONS> ... <TARGETS>'
	@echo ''
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: setup
setup: ## setup environment
	$(call print-target)
	@fvm dart --disable-analytics
	@fvm flutter config --no-analytics --enable-android --enable-web
	$(call get)

.PHONY: version
version: ## show current flutter version
	$(call print-target)
	@fvm flutter --version

.PHONY: get
get: ## get dependencies
	$(call print-target)
	@fvm flutter pub get

.PHONY: upgrade
upgrade: get ## upgrade dependencies
	$(call print-target)
	@fvm flutter pub get

.PHONY: outdated
outdated: ## check for outdated dependencies
	$(call print-target)
	@fvm flutter pub outdated

.PHONY: fix
fix: get ## format and fix code
	$(call print-target)
	@fvm dart format . -l 80 lib/
	@fvm dart fix --apply lib/

.PHONY: format
format: fix

.PHONY: fmt
fmt: fix

.PHONY: clean
clean: ## remove files created during build pipeline
	$(call print-target)
	@fvm flutter clean
	@rm -rf .dart_tool build coverage .flutter-plugins .flutter-plugins-dependencies
	$(call get)

.PHONY: analyze
analyze: get ## check source code for errors and warnings
	$(call print-target)
	@fvm dart format --set-exit-if-changed -l 80 -o none lib/
	@fvm flutter analyze --fatal-infos --fatal-warnings lib/

.PHONY: check
check: analyze

.PHONY: lint
lint: analyze

.PHONY: test
test: ## run tests
	$(call print-target)
	@fvm flutter test --color --coverage --concurrency=50 --platform=tester --reporter=compact --timeout=30s

.PHONY: coverage
coverage: test ## generate coverage report
	$(call print-target)
	@lcov --list coverage/lcov.info

.PHONY: diff
diff: ## git diff
	$(call print-target)
	@git diff --exit-code
	@RES=$$(git status --porcelain) ; if [ -n "$$RES" ]; then echo $$RES && exit 1 ; fi

define print-target
    @printf "Executing target: \033[36m$@\033[0m\n"
endef


.PHONY: dartdoc
dartdoc: ## generate dart documentation
	$(call print-target)
	@rm -rf doc
	@fvm dart doc .

.PHONY: releasedryrun
releasedryrun:
	$(call print-target)
	@fvm dart pub publish -n


.PHONY: build
build:
	$(call print-target)
	@fvm flutter packages pub run build_runner build --delete-conflicting-outputs