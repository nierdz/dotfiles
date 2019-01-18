MAIN_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
VIRTUALENV_DIR := $(MAIN_DIR)/venv
PATH := $(PATH):$(HOME)/.local/bin
SHELL := /usr/bin/env bash

help: ## Print this help
	@grep -E '^[a-zA-Z1-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN { FS = ":.*?## " }; { printf "\033[36m%-30s\033[0m %s\n", $$1, $$2 }'

pre-install: ## Install dependencies
	$(info --> Install dependencies)
	@( \
		sudo apt update; \
		sudo apt install \
			git \
			python-apt \
			python-pip \
			ruby \
			terminator \
			vim; \
	)
	@make install-ansible
	@make ansible-lint

install: ## Install everything
	$(info --> Install everything)
	@make run-ansible

venv: ## Create python virtualenv if not exists
	[[ -d $(VIRTUALENV_DIR) ]] || virtualenv --system-site-packages $(VIRTUALENV_DIR)

install-ansible: ## Install ansible via pip
	$(info --> Install ansible via `pip`)
	@make venv
	@( \
		source $(VIRTUALENV_DIR)/bin/activate; \
		pip install --upgrade setuptools; \
		pip install -r requirements.txt; \
	)

run-ansible: ## Run ansible on full playbook
	$(info --> Run ansible on full playbook)
	@( \
		source $(VIRTUALENV_DIR)/bin/activate; \
		ansible-playbook playbook.yml; \
	)

ansible-lint: ## Run ansible-lint on all roles
	$(info --> Run ansible-lint on all roles)
	@( \
		source $(VIRTUALENV_DIR)/bin/activate; \
		ansible-lint playbook.yml; \
		ansible-playbook playbook.yml --syntax-check; \
		yamllint -c .yamllint.yml .; \
	)
