docs/%.txt: man/%
	mkdir -p docs
	groff -mandoc -Tutf8 < "$<" | col -bx > "$@"

docs: docs/snapperoo.1.txt docs/snapperoo.5.txt
