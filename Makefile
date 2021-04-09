prefix := /usr/local

bindir := $(prefix)/bin
etcdir := $(prefix)/etc
libdir := $(prefix)/lib
mandir := $(prefix)/share/man
licensedir := $(prefix)/share/licenses


.PHONY: install
install: docs-man
	install -D -m 755 snapperoo "$(bindir)/snapperoo"
	install -D -m 644 snapperoo.json "$(etcdir)/snapperoo.json"
	install -D -m 444 license.txt "$(licensedir)/snapperoo/LICENSE"
	install -D -m 444 man/snapperoo.1.gz "$(mandir)/man1/snapperoo.1.gz"
	install -D -m 444 man/snapperoo.5.gz "$(mandir)/man5/snapperoo.5.gz"

.PHONY: install-systemd
install-systemd:
	install -D -m 644 systemd/snapperoo@.service "$(libdir)/systemd/system/snapperoo@.service"
	install -D -m 644 systemd/snapperoo@.timer "$(libdir)/systemd/system/snapperoo@.timer"


docs-man: man/snapperoo.1.gz man/snapperoo.5.gz

man/%.gz: man/%
	gzip -k "$<"


docs-ascii: docs/snapperoo.1.txt docs/snapperoo.5.txt

docs/%.txt: man/%
	mkdir -p docs
	groff -mandoc -Tutf8 < "$<" | col -bx > "$@"
