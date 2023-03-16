MAIN_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
ANSIBLE_ARGS ?=
VIRTUALENV_DIR := $(MAIN_DIR)/venv
VIRTUAL_ENV_DISABLE_PROMPT = true
PATH := $(VIRTUALENV_DIR)/bin:$(PATH)
SHELL := /usr/bin/env bash

.DEFAULT_GOAL := help
.SHELLFLAGS := -eu -o pipefail -c

export PATH

help: ## Print this help
	@grep -E '^[a-zA-Z1-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN { FS = ":.*?## " }; { printf "\033[36m%-30s\033[0m %s\n", $$1, $$2 }'

$(VIRTUALENV_DIR):
	virtualenv -p $(shell command -v python3) $(VIRTUALENV_DIR)

$(VIRTUALENV_DIR)/bin/pre-commit: $(MAIN_DIR)/requirements.txt
	pip install -r $(MAIN_DIR)/requirements.txt
	@touch '$(@)'

pre-commit-install: ## Install pre-commit hooks
	pre-commit install

install-pip-packages: $(VIRTUALENV_DIR) $(VIRTUALENV_DIR)/bin/pre-commit ## Install python pip packages in a virtual environment

install: install-dependencies install-pip-packages ansible-run ## Run all tasks to install everything
	$(info --> Run all tasks to install everything)

install-dependencies: ## Install dependencies
		sudo apt update;
		sudo apt install -y \
			git \
			gnome \
			python3-apt \
			python3-pip \
			python3-virtualenv \
			vim
		sudo timedatectl set-timezone Europe/Paris
		sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1
		pip3 install -r requirements.txt

ansible-run: ## Run ansible with ANSIBLE_ARGS
		ansible-playbook --diff playbook.yml $(ANSIBLE_ARGS)

tests: ## Run all tests
		ansible-lint playbook.yml
		ansible-playbook playbook.yml --syntax-check
		pre-commit run --all-files
