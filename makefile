.SECONDEXPANSION:

DRECK_PLUGIN_NAMES = $(notdir $(shell find ./submodules/plugins -mindepth 1 -maxdepth 1 -type d))
DRECK_LIBRARIES_WITH_EXTRACTED_BUNDLES = $(addprefix ./persistent/libraries-with-extracted-bundles/, ${DRECK_PLUGIN_NAMES})
DRECK_CORE_BUNDLED_FILES = $(patsubst ./submodules/dreck/bundled/%, ./%, $(shell find ./submodules/dreck/bundled -type f))

ifneq ($(wildcard ./src),)
	DRECK_SRC_DIRECTORIES += ./src
endif

ifneq ($(wildcard ./submodules/plugins),)
	DRECK_SRC_DIRECTORIES += $(shell find ./submodules/plugins -mindepth 2 -maxdepth 2 -type d -name "src")
endif

ifneq (${DRECK_SRC_DIRECTORIES},)
	DRECK_SRC_PATHS = $(shell find ${DRECK_SRC_DIRECTORIES} -type f -printf "%P\n")
	DRECK_ABSOLUTE_SRC_PATHS = $(shell find ${DRECK_SRC_DIRECTORIES} -type f)
endif

DRECK_EXPECTED_ABSOLUTE_SRC_PATHS = $(addprefix ./ephemeral/src/, ${DRECK_SRC_PATHS})

ephemeral/build: ${DRECK_CORE_BUNDLED_FILES} ${DRECK_LIBRARIES_WITH_EXTRACTED_BUNDLES} ${DRECK_ABSOLUTE_SRC_PATHS}

ifneq ($(wildcard ./persistent/libraries-with-extracted-bundles),)
ifneq ($(filter-out ${DRECK_LIBRARIES_WITH_EXTRACTED_BUNDLES}, $(shell find ./persistent/libraries-with-extracted-bundles -mindepth 1)),)
	rm $(filter-out ${DRECK_LIBRARIES_WITH_EXTRACTED_BUNDLES}, $(shell find ./persistent/libraries-with-extracted-bundles -mindepth 1))
endif
endif

ifneq ($(wildcard ./ephemeral/src),)
ifneq ($(filter-out ${DRECK_EXPECTED_ABSOLUTE_SRC_PATHS}, $(shell find ./ephemeral/src -mindepth 1 -type f)),)
	rm $(filter-out ${DRECK_EXPECTED_ABSOLUTE_SRC_PATHS}, $(shell find ./ephemeral/src -mindepth 1 -type f))
endif
endif

	make --jobs --file ./submodules/dreck/makefile all-post-clean

all-post-clean: ${DRECK_EXPECTED_ABSOLUTE_SRC_PATHS}
	touch ephemeral/build

./persistent/libraries-with-extracted-bundles/%:
	mkdir -p $(dir $@)
	if [ "$(wildcard ./submodules/plugins/$*/bundled)" != "" ] ; then cp -r ./submodules/plugins/$*/bundled/. . ; fi
	touch $@

$(DRECK_CORE_BUNDLED_FILES): %: | ./submodules/dreck/bundled/%
	mkdir -p $(dir $@)
	cp ./submodules/dreck/bundled/$@ ./$@

./ephemeral/src/%: $$(filter $$(addsuffix /%, ${DRECK_SRC_DIRECTORIES}), ${DRECK_ABSOLUTE_SRC_PATHS})
	mkdir -p $(dir $@)
	cp $< $@
