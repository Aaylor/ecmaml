OCAMLBUILD = ocamlbuild

# FILES
ROOT = lib
BUILD_ROOT = _build/$(ROOT)
LIB_NAME = ecmaml

# FLAGS
FOLDERS =	$(shell find $(ROOT) -type d)
FOLDERS_FLAG = $(foreach folder,$(FOLDERS),-I $(folder))
WARNING_FLAGS = -w @1..3@5..8@10..26@28..31+32..38@39..43@46..49+50
PACKAGES = js_of_ocaml,js_of_ocaml.ppx

# COMMANDS
OCAMLC_COMMAND = -ocamlc 'ocamlc -annot -g'
OCAMLBUILD_FLAG	= -use-ocamlfind -classic-display

.PHONY: all
all: clean-copy
		$(OCAMLBUILD) $(OCAMLBUILD_FLAG) $(OCAMLC_COMMAND) $(FOLDERS_FLAG) \
				-pkgs $(PACKAGES) $(LIB_NAME).cma
		cp $(BUILD_ROOT)/$(LIB_NAME).cm* .

# ocamldoc does not support packed modules...
# workaround find there:
# http://stackoverflow.com/questions/17368613/using-ocamldoc-with-packs

.PHONY: doc
doc: clean-copy
		rm -rf docs/*
		ocp-pack -mli -o lib/ecmaml.ml.tmp lib/ecmaml/*.ml
		echo "(** ecmaml implementation. *)" > lib/ecmaml.mli
		cat lib/ecmaml.ml.tmpi >> lib/ecmaml.mli; rm lib/ecmaml.ml.tmpi
		mv lib/ecmaml.ml.tmp lib/ecmaml.ml
		$(OCAMLBUILD) $(OCAMLBUILD_FLAG) $(FOLDERS_FLAG) -pkgs $(PACKAGES) \
				$(LIB_NAME).docdir/index.html
		rm $(LIB_NAME).docdir
		mkdir -p docs
		cp -r _build/$(LIB_NAME).docdir/* docs
		rm -f lib/ecmaml.{ml,mli}

# Opem rules
install: META $(LIB_NAME).cma
	ocamlfind install $(LIB_NAME) $(LIB_NAME).cm* META

uninstall:
	ocamlfind remove $(LIB_NAME)

reinstall: uninstall install

.PHONY: clean
clean: clean-copy
		$(OCAMLBUILD) -clean

.PHONY: clean-copy
clean-copy:
		rm -f *.cm*
		rm -f lib/ecmaml.{ml,mli}
