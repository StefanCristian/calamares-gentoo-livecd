PN ?= calamares-gentoo-livecd
MY_PN ?= calamares
LIVECD_REV ?= 3.3.14a

PREFIX ?= /usr/local/
SYSCONFDIR ?= /etc
LIBDIR ?= $(PREFIX)/lib
DATADIR ?= $(PREFIX)/share
BINDIR ?= $(PREFIX)/bin

DESTDIR ?=
CALAMARES_CONFDIR = $(DESTDIR)$(SYSCONFDIR)/$(MY_PN)
CALAMARES_MODULESDIR = $(DESTDIR)$(LIBDIR)/calamares/modules
DESKTOP_DIR = $(DESTDIR)$(DATADIR)/applications
ICONS_DIR = $(DESTDIR)$(DATADIR)/icons/calamares-gentoo/64x64
BRANDING_DIR = $(DESTDIR)$(SYSCONFDIR)/calamares/branding/gentoo_branding

SRCDIR = .
MODULES_SRCDIR = $(SRCDIR)/modules
ARTWORK_SRCDIR = $(SRCDIR)/artwork

GENTOO_ARTWORK_DIR ?= gentoo-artwork-0.2
GENTOO_LIVECD_DIR ?= gentoo-livecd-2007.0

.PHONY: all install clean help

all: help

help:
	@echo "Calamares Gentoo LiveCD Installation Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  install        - Install all components"
	@echo "  clean          - Remove installed files"
	@echo "  help           - Show this help message"
	@echo ""
	@echo "Variables:"
	@echo "  PREFIX=$(PREFIX)"
	@echo "  DESTDIR=$(DESTDIR)"
	@echo "  PN=$(PN)"
	@echo "  MY_PN=$(MY_PN)"
	@echo "  LIVECD_REV=$(LIVECD_REV)"

install:
	
	install -d "$(CALAMARES_CONFDIR)"
	install -m 644 "$(SRCDIR)/settings.conf" "$(CALAMARES_CONFDIR)/settings.conf"
	
	install -d "$(CALAMARES_CONFDIR)/modules"
	for conf_file in "$(MODULES_SRCDIR)"/*.conf ; do \
		if [ -f "$$conf_file" ]; then \
			install -m 644 "$$conf_file" "$(CALAMARES_CONFDIR)/modules/$$(basename "$$conf_file")"; \
		fi \
	done

	install -d "$(CALAMARES_MODULESDIR)"
	
	if [ -d "$(MODULES_SRCDIR)/downloadstage3" ]; then \
		cp -r "$(MODULES_SRCDIR)/downloadstage3" "$(CALAMARES_MODULESDIR)/"; \
	fi
	
	if [ -d "$(MODULES_SRCDIR)/dracut_gentoo" ]; then \
		cp -r "$(MODULES_SRCDIR)/dracut_gentoo" "$(CALAMARES_MODULESDIR)/"; \
	fi
	
	if [ -d "$(MODULES_SRCDIR)/gentoopkg" ]; then \
		cp -r "$(MODULES_SRCDIR)/gentoopkg" "$(CALAMARES_MODULESDIR)/"; \
	fi

	install -d "$(DESTDIR)$(BINDIR)"
	install -m 755 "$(SRCDIR)/$(MY_PN)-pkexec" "$(DESTDIR)$(BINDIR)/$(MY_PN)-pkexec"

	install -d "$(DESKTOP_DIR)"
	install -m 644 "$(SRCDIR)/gentoo-installer.desktop" "$(DESKTOP_DIR)/gentoo-installer.desktop"

	install -d "$(ICONS_DIR)"
	
	if [ -f "$(GENTOO_ARTWORK_DIR)/icons/gentoo/64x64/gentoo.png" ]; then \
		install -m 644 "$(GENTOO_ARTWORK_DIR)/icons/gentoo/64x64/gentoo.png" "$(ICONS_DIR)/gentoo.png"; \
	else \
		echo "Warning: $(GENTOO_ARTWORK_DIR)/icons/gentoo/64x64/gentoo.png not found"; \
	fi

	install -d "$(BRANDING_DIR)"
	
	if [ -f "$(ARTWORK_SRCDIR)/show.qml" ]; then \
		install -m 644 "$(ARTWORK_SRCDIR)/show.qml" "$(BRANDING_DIR)/show.qml"; \
	fi
	
	if [ -f "$(ARTWORK_SRCDIR)/branding.desc" ]; then \
		install -m 644 "$(ARTWORK_SRCDIR)/branding.desc" "$(BRANDING_DIR)/branding.desc"; \
	fi
	
	if [ -f "$(GENTOO_LIVECD_DIR)/800x600.png" ]; then \
		for i in 1 2 3 4 5 6 7 8 9 10; do \
			install -m 644 "$(GENTOO_LIVECD_DIR)/800x600.png" "$(BRANDING_DIR)/$$i.png"; \
		done; \
		install -m 644 "$(GENTOO_LIVECD_DIR)/800x600.png" "$(BRANDING_DIR)/languages.png"; \
	else \
		echo "Warning: $(GENTOO_LIVECD_DIR)/800x600.png not found"; \
	fi
	
	if [ -f "$(GENTOO_ARTWORK_DIR)/icons/gentoo/64x64/gentoo.png" ]; then \
		install -m 644 "$(GENTOO_ARTWORK_DIR)/icons/gentoo/64x64/gentoo.png" "$(BRANDING_DIR)/gentoo.png"; \
	fi
	

clean:
	rm -f "$(CALAMARES_CONFDIR)/settings.conf"
	rm -f "$(CALAMARES_CONFDIR)/modules"/*.conf
	-rmdir "$(CALAMARES_CONFDIR)/modules" 2>/dev/null || true
	-rmdir "$(CALAMARES_CONFDIR)" 2>/dev/null || true
	
	rm -rf "$(CALAMARES_MODULESDIR)/downloadstage3"
	rm -rf "$(CALAMARES_MODULESDIR)/dracut_gentoo"
	rm -rf "$(CALAMARES_MODULESDIR)/gentoopkg"
	-rmdir "$(CALAMARES_MODULESDIR)" 2>/dev/null || true
	
	rm -f "$(DESTDIR)$(BINDIR)/$(MY_PN)-pkexec"
	
	rm -f "$(DESKTOP_DIR)/gentoo-installer.desktop"
	
	rm -f "$(ICONS_DIR)/gentoo.png"
	-rmdir "$(ICONS_DIR)" 2>/dev/null || true
	-rmdir "$(DESTDIR)$(DATADIR)/icons/calamares-gentoo" 2>/dev/null || true
	
	rm -f "$(BRANDING_DIR)/show.qml"
	rm -f "$(BRANDING_DIR)/branding.desc"
	rm -f "$(BRANDING_DIR)/gentoo.png"
	rm -f "$(BRANDING_DIR)/languages.png"
	for i in 1 2 3 4 5 6 7 8 9 10; do \
		rm -f "$(BRANDING_DIR)/$$i.png"; \
	done
	-rmdir "$(BRANDING_DIR)" 2>/dev/null || true
	-rmdir "$(DESTDIR)$(SYSCONFDIR)/calamares/branding" 2>/dev/null || true
	-rmdir "$(DESTDIR)$(SYSCONFDIR)/calamares" 2>/dev/null || true