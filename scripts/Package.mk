
FREEDOM_CUSTOM_GITURL := https://github.com/sifive/freedom-spike-dasm.git
FREEDOM_CUSTOM_COMMIT := 2ef2c24fe30454682b927be13d6da7c48a824f15

ifneq ($(CUSTOM_GITURL),)
FREEDOM_CUSTOM_GITURL := $(CUSTOM_GITURL)
endif
ifneq ($(CUSTOM_COMMIT),)
FREEDOM_CUSTOM_COMMIT := $(CUSTOM_COMMIT)
endif

SRCNAME_FREEDOM_CUSTOM := freedom-custom
SRCPATH_FREEDOM_CUSTOM := $(SRCDIR)/$(SRCNAME_FREEDOM_CUSTOM)

.PHONY: custom custom-package custom-regress custom-regress custom-cleanup
custom: custom-package

$(SRCPATH_FREEDOM_CUSTOM).$(FREEDOM_CUSTOM_COMMIT):
	mkdir -p $(dir $@)
	rm -rf $(SRCPATH_FREEDOM_CUSTOM)
	rm -rf $(SRCPATH_FREEDOM_CUSTOM).*
	git clone $(FREEDOM_CUSTOM_GITURL) $(SRCPATH_FREEDOM_CUSTOM)
	cd $(SRCPATH_FREEDOM_CUSTOM) && git checkout --detach $(FREEDOM_CUSTOM_COMMIT)
	cd $(SRCPATH_FREEDOM_CUSTOM) && git submodule update --init --recursive
	date > $@

custom-package: \
		$(SRCPATH_FREEDOM_CUSTOM).$(FREEDOM_CUSTOM_COMMIT)
	$(MAKE) -C $(SRCPATH_FREEDOM_CUSTOM) package POSTFIXPATH=$(abspath .)/ EXTRA_OPTION=$(EXTRA_OPTION) EXTRA_SUFFIX=$(EXTRA_SUFFIX)

custom-regress: \
		$(SRCPATH_FREEDOM_CUSTOM).$(FREEDOM_CUSTOM_COMMIT)
	$(MAKE) -C $(SRCPATH_FREEDOM_CUSTOM) regress POSTFIXPATH=$(abspath .)/ EXTRA_OPTION=$(EXTRA_OPTION) EXTRA_SUFFIX=$(EXTRA_SUFFIX)

custom-cleanup:
	$(MAKE) -C $(SRCPATH_FREEDOM_CUSTOM) cleanup POSTFIXPATH=$(abspath .)/
	rm -rf $(SRCPATH_FREEDOM_CUSTOM).*
	rm -rf $(SRCPATH_FREEDOM_CUSTOM)
