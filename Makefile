MAIN_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
VIRTUALENV_DIR := $(MAIN_DIR)/venv
SHELL := /usr/bin/env bash

help: ## Print this help
	@grep -E '^[a-zA-Z1-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN { FS = ":.*?## " }; { printf "\033[36m%-30s\033[0m %s\n", $$1, $$2 }'

pre-install: ## Install first packages
	$(info --> Install first packages)
	@( \
		sudo apt update; \
		sudo apt install -y \
			git \
			gnome \
			python3-apt \
			python3-pip \
			python3-virtualenv \
			ruby \
			vim; \
		sudo timedatectl set-timezone Europe/Paris; \
		sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1; \
	)

venv: ## Create python virtualenv
	$(info --> Create python virtualenv)
	[[ -d $(VIRTUALENV_DIR) ]] || virtualenv --system-site-packages $(VIRTUALENV_DIR)

install-dependencies: venv ## Install dependencies
	$(info --> Install dependencies)
	@( \
		source $(VIRTUALENV_DIR)/bin/activate; \
		pip3 install --upgrade setuptools; \
		pip3 install -r requirements.txt; \
	)

ansible-run: ## Run ansible on full playbook
	$(info --> Run ansible on full playbook)
	@export \
		ANSIBLE_STRATEGY_PLUGINS=venv/lib/python2.7/site-packages/ansible_mitogen/plugins/strategy \
		&& ANSIBLE_STRATEGY=mitogen_linear \
		&& if [[ $$DEBUG -eq 1 ]]; then export ANSIBLE_VERBOSITY=3; fi \
		&& source $(VIRTUALENV_DIR)/bin/activate \
		&& ansible-playbook --diff playbook.yml

install: pre-install install-dependencies ansible-run ## Run all tasks to install everything
	$(info --> Run all tasks to install everything)

tests: ## Run all tests
	$(info --> Run all tests)
	@( \
		source $(VIRTUALENV_DIR)/bin/activate; \
		ansible-lint playbook.yml; \
		ansible-playbook playbook.yml --syntax-check; \
		pre-commit run --all-files; \
	)
