PROJECT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
VIRTUALENV_DIR := $(PROJECT_DIR)/venv
VIRTUAL_ENV_DISABLE_PROMPT = true
PYENV_VERSION ?= $(shell cat "$(PROJECT_DIR)/.python-version")
PYTHON_BIN ?= $(shell which python3)
PATH := $(VIRTUALENV_DIR)/bin:$(PATH)
SHELL := /usr/bin/env bash

.DEFAULT_GOAL := help
.SHELLFLAGS := -eu -o pipefail -c

export PATH

UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Linux)
PACKAGE_MANAGER := sudo apt
PACKAGE_MANAGER_INSTALL_OPTION := -y
PACKAGE_LIST := git \
                gnome \
                python3-apt \
                python3-pip \
                python3-virtualenv \
                vim
endif

ifeq ($(UNAME_S),Darwin)
PACKAGE_MANAGER := brew
PACKAGE_MANAGER_INSTALL_OPTION :=
PACKAGE_LIST := bash \
								bash-completion@2 \
								bat \
								firefox \
								fzf \
								git \
								gnu-tar \
								keepassxc \
								kitty \
								nextcloud \
								node@20 \
								php@8.2 \
								pyenv \
								the_silver_searcher \
								vim \
								virtualenv
endif

help: ## Print this help
	@grep -E '^[a-zA-Z1-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN { FS = ":.*?## " }; { printf "\033[36m%-30s\033[0m %s\n", $$1, $$2 }'


$(VIRTUALENV_DIR)/bin/python3: $(PROJECT_DIR)/.python-version
	command -v pyenv && pyenv install -s $(PYENV_VERSION) \
		|| echo "Skip python install, pyenv is not installed !"

$(VIRTUALENV_DIR):
	env PYENV_VERSION=$(PYENV_VERSION) \
		virtualenv -p $(PYTHON_BIN) $(VIRTUALENV_DIR)

$(VIRTUALENV_DIR)/bin/ansible: $(PROJECT_DIR)/requirements.txt
	pip3 install -r $(PROJECT_DIR)/requirements.txt
	@touch '$(@)'

install-pip-packages: $(VIRTUALENV_DIR)/bin/python3 $(VIRTUALENV_DIR) $(VIRTUALENV_DIR)/bin/ansible ## Install python requirements

install-pre-commit-hooks: ## Install pre-commit hooks
	pre-commit install --hook-type pre-commit --hook-type commit-msg

install: install-dependencies install-pip-packages install-pre-commit-hooks ansible-run ## Run all tasks to install everything
	$(info --> Run all tasks to install everything)

install-dependencies: ## Install dependencies
	$(PACKAGE_MANAGER) update;
	$(PACKAGE_MANAGER) install $(PACKAGE_MANAGER_INSTALL_OPTION) $(PACKAGE_LIST)
	# TODO move this to ansible
	#sudo timedatectl set-timezone Europe/Paris
	#sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1

ansible-run: ## Run ansible
	ansible-playbook -K --diff playbook.yml

tests: ## Run all tests
	ansible-lint playbook.yml
	ansible-playbook playbook.yml --syntax-check
	pre-commit run --all-files
