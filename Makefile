include config.mk

.SUFFIXES:
.SUFFIXES: .o .c

HDR =\
	arg.h\
	compat.h\
	crypt.h\
	fs.h\
	md5.h\
	queue.h\
	sha1.h\
	sha224.h\
	sha256.h\
	sha384.h\
	sha512.h\
	sha512-224.h\
	sha512-256.h\
	text.h\
	utf.h\
	util.h

LIBUTFOBJ =\
	libutf/fgetrune.o\
	libutf/fputrune.o\
	libutf/isalnumrune.o\
	libutf/isalpharune.o\
	libutf/isblankrune.o\
	libutf/iscntrlrune.o\
	libutf/isdigitrune.o\
	libutf/isgraphrune.o\
	libutf/isprintrune.o\
	libutf/ispunctrune.o\
	libutf/isspacerune.o\
	libutf/istitlerune.o\
	libutf/isxdigitrune.o\
	libutf/lowerrune.o\
	libutf/rune.o\
	libutf/runetype.o\
	libutf/upperrune.o\
	libutf/utf.o\
	libutf/utftorunestr.o

LIBUTILOBJ =\
	libutil/concat.o\
	libutil/cp.o\
	libutil/crypt.o\
	libutil/ealloc.o\
	libutil/enmasse.o\
	libutil/eprintf.o\
	libutil/eregcomp.o\
	libutil/estrtod.o\
	libutil/fnck.o\
	libutil/fshut.o\
	libutil/getlines.o\
	libutil/human.o\
	libutil/linecmp.o\
	libutil/md5.o\
	libutil/memmem.o\
	libutil/mkdirp.o\
	libutil/mode.o\
	libutil/parseoffset.o\
	libutil/putword.o\
	libutil/reallocarray.o\
	libutil/recurse.o\
	libutil/rm.o\
	libutil/sha1.o\
	libutil/sha224.o\
	libutil/sha256.o\
	libutil/sha384.o\
	libutil/sha512.o\
	libutil/sha512-224.o\
	libutil/sha512-256.o\
	libutil/strcasestr.o\
	libutil/strlcat.o\
	libutil/strlcpy.o\
	libutil/strsep.o\
	libutil/strnsubst.o\
	libutil/strtonum.o\
	libutil/unescape.o\
	libutil/writeall.o

LIB = libutf.a libutil.a

BIN =\
	basename\
	cal\
	cat\
	chgrp\
	chmod\
	chown\
	chroot\
	cksum\
	cmp\
	cols\
	comm\
	cp\
	cron\
	cut\
	date\
	dd\
	dirname\
	du\
	echo\
	ed\
	env\
	expand\
	expr\
	false\
	find\
	flock\
	fold\
	getconf\
	grep\
	head\
	hostname\
	join\
	kill\
	link\
	ln\
	logger\
	logname\
	ls\
	md5sum\
	mkdir\
	mkfifo\
	mknod\
	mktemp\
	mv\
	nice\
	nl\
	nohup\
	od\
	paste\
	pathchk\
	printenv\
	printf\
	pwd\
	readlink\
	renice\
	rev\
	rm\
	rmdir\
	sed\
	seq\
	setsid\
	sha1sum\
	sha224sum\
	sha256sum\
	sha384sum\
	sha512sum\
	sha512-224sum\
	sha512-256sum\
	sleep\
	sort\
	split\
	sponge\
	strings\
	sync\
	tail\
	tar\
	tee\
	test\
	tftp\
	time\
	touch\
	tr\
	true\
	tsort\
	tty\
	uname\
	unexpand\
	uniq\
	unlink\
	uudecode\
	uuencode\
	wc\
	which\
	whoami\
	xargs\
	xinstall\
	yes

OBJ = $(BIN:=.o) $(LIBUTFOBJ) $(LIBUTILOBJ)
MAN = $(BIN:=.1)

all: $(BIN)

$(BIN): $(LIB) $(@:=.o)

$(OBJ): $(HDR) config.mk

.o:
	$(CC) $(LDFLAGS) -o $@ $< $(LIB)

.c.o:
	$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ -c $<

libutf.a: $(LIBUTFOBJ)
	$(AR) $(ARFLAGS) $@ $?
	$(RANLIB) $@

libutil.a: $(LIBUTILOBJ)
	$(AR) $(ARFLAGS) $@ $?
	$(RANLIB) $@

getconf.o: getconf.h

getconf.h: getconf.sh
	./getconf.sh > $@

install: all
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f $(BIN) $(DESTDIR)$(PREFIX)/bin
	cd $(DESTDIR)$(PREFIX)/bin && ln -f test [ && chmod 755 $(BIN)
	mv -f $(DESTDIR)$(PREFIX)/bin/xinstall $(DESTDIR)$(PREFIX)/bin/install
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	for m in $(MAN); do sed "s/^\.Os sbase/.Os sbase $(VERSION)/g" < "$$m" > $(DESTDIR)$(MANPREFIX)/man1/"$$m"; done
	cd $(DESTDIR)$(MANPREFIX)/man1 && chmod 644 $(MAN)
	mv -f $(DESTDIR)$(MANPREFIX)/man1/xinstall.1 $(DESTDIR)$(MANPREFIX)/man1/install.1

uninstall:
	cd $(DESTDIR)$(PREFIX)/bin && rm -f $(BIN) [ install
	cd $(DESTDIR)$(MANPREFIX)/man1 && rm -f $(MAN) install.1

dist: clean
	mkdir -p sbase-$(VERSION)
	cp -r LICENSE Makefile README TODO config.mk *.c *.1 *.h libutf libutil sbase-$(VERSION)
	tar -cf sbase-$(VERSION).tar sbase-$(VERSION)
	gzip sbase-$(VERSION).tar
	rm -rf sbase-$(VERSION)

sbase-box: $(BIN)
	scripts/mkbox
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -o $@ build/*.c $(LIB)

sbase-box-install: sbase-box
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f sbase-box $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/sbase-box
	for f in $(BIN); do ln -sf sbase-box $(DESTDIR)$(PREFIX)/bin/"$$f"; done
	ln -sf sbase-box $(DESTDIR)$(PREFIX)/bin/[
	mv -f $(DESTDIR)$(PREFIX)/bin/xinstall $(DESTDIR)$(PREFIX)/bin/install
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	for m in $(MAN); do sed "s/^\.Os sbase/.Os sbase $(VERSION)/g" < "$$m" > $(DESTDIR)$(MANPREFIX)/man1/"$$m"; done
	cd $(DESTDIR)$(MANPREFIX)/man1 && chmod 644 $(MAN)
	mv -f $(DESTDIR)$(MANPREFIX)/man1/xinstall.1 $(DESTDIR)$(MANPREFIX)/man1/install.1

sbase-box-uninstall: uninstall
	cd $(DESTDIR)$(PREFIX)/bin && rm -f sbase-box

clean:
	rm -f $(BIN) $(OBJ) $(LIB) sbase-box sbase-$(VERSION).tar.gz
	rm -f getconf.h
	rm -rf build

.PHONY: all install uninstall dist sbase-box-install sbase-box-uninstall clean
