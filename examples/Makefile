
LIB_PATH=..
LIB_NAME=ecmaml.cma

EXAMPLES = \
		integer_iterator.js


all: $(EXAMPLES)

%.js: %.ml ../ecmaml.cma
		@echo " -- $<"
		@echo "   - Compiling."
		@ocamlfind ocamlc -g -I $(LIB_PATH) $(LIB_PATH)/$(LIB_NAME) \
			-package js_of_ocaml -package js_of_ocaml.ppx -linkpkg $< \
			-o $(<:.ml=.byte)
		@echo "   - Applying js_of_ocaml."
		@js_of_ocaml --debug-info --pretty $(<:.ml=.byte)
		@echo "   - Done."
		@echo

.PHONY: clean
clean:
		rm -f *.cm* *.js *.byte
