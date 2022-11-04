SHELL          := /usr/bin/env bash
.DEFAULT_GOAL  := docset
DOCSET_VERSION := $(shell cat version/pytorch-lightning)

.PHONY: retrieve_latest_pl_version
retrieve_latest_pl_version: version/pytorch-lightning

.PHONY: version/pytorch-lightning
version/pytorch-lightning:
	@mkdir -p $(dir $@)
	./scripts/pytorch-lightning-version.sh > $@

.PHONY: clone
clone: .build/$(DOCSET_VERSION)/.done-cloning

.build/$(DOCSET_VERSION)/.done-cloning:
	@mkdir -p $(dir $@)
	./scripts/clone.sh $(DOCSET_VERSION) $(dir $@)/src
	@touch $@

.PHONY: requirements
requirements: .build/$(DOCSET_VERSION)/.done-requirements

.build/$(DOCSET_VERSION)/.done-requirements:
	@mkdir -p $(dir $@)
	cd .build/$(DOCSET_VERSION)/src \
	&& python3 setup.py sdist

	cd .build/$(DOCSET_VERSION)/src \
	&& pip install doc2dash -e . -r requirements/pytorch/docs.txt \
        --find-links https://download.pytorch.org/whl/cpu/torch_stable.html \
        --find-links dist
	@touch $@

.PHONY: html
html: .build/$(DOCSET_VERSION)/.done-make-html

.build/$(DOCSET_VERSION)/.done-make-html:
	cd .build/$(DOCSET_VERSION)/src/docs/source-pytorch \
	&& $(MAKE) html --debug --jobs 8 SPHINXOPTS="-W --keep-going"
	@touch $@

.PHONY: doc2dash
doc2dash: .build/$(DOCSET_VERSION)/.done-doc2dash

.build/$(DOCSET_VERSION)/.done-doc2dash:
	./scripts/doc2dash.sh ".build/$(DOCSET_VERSION)/src/docs/build/html" ".build/$(DOCSET_VERSION)"
	@touch $@

.PHONY: tgz
tgz: .build/$(DOCSET_VERSION)/PytorchLightning.tgz

.build/$(DOCSET_VERSION)/PytorchLightning.tgz:
	cd $(dir $@) \
	&& tar --exclude=".DS_Store" -cvzf $(notdir $@) PytorchLightning.docset
	@touch $@

.PHONY: docset
docset:
	$(MAKE) clone
	$(MAKE) requirements
	$(MAKE) html
	$(MAKE) doc2dash
	$(MAKE) .build/latest/PytorchLightning.tgz

.build/latest/%: .build/$(DOCSET_VERSION)/%
	@mkdir -p $(dir $@)
	cp -r $< $@

.PHONY: clean
clean:
	rm -rf .build
