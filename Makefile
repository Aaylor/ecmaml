############################################################################
#  CONFIGURATION VARIABLES                                                 #
############################################################################

## UTILS

SHELL = /bin/bash
HEAD = printf "%-10s %s\n"


## BINARIES

JBUILDER = jbuilder


## OUT

LIB_FOLDER = lib
LIB_NAME = ecmaml
LIB_CMA = $(LIB_FOLDER)/$(LIB_NAME).cma


############################################################################
#  RULES                                                                   #
############################################################################

.PHONY: all
all: build

.PHONY: build
build:
	@$(HEAD) "Building" "$(LIB_CMA)"
	@$(JBUILDER) build --dev $(LIB_CMA) @install

doc:
	@$(HEAD) "Building" "Documentation"
	@$(JBUILDER) build @doc

.PHONY: install
install:
	@$(HEAD) "Installing"
	@$(JBUILDER) install

.PHONY: uninstall
uninstall:
	@$(HEAD) "Uninstall"
	@$(JBUILDER) uninstall

.PHONY: reinstall
reinstall:
	$(MAKE) uninstall
	$(MAKE) install

.PHONY: test
test:
	@$(HEAD) "Testing"
	@$(JBUILDER) runtest

.PHONY: all-supported-ocaml-versions
all-supported-ocaml-versions:
	@$(JBUILDER) runtest --workspace jbuild-workspace.dev

.PHONY: clean
clean:
	@$(HEAD) "Cleaning"
	@rm -rf _build *.install lib/_build
	@find . -name .merlin -delete
