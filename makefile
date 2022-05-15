.SECONDEXPANSION:

all: all-clean

DRECK_PLUGIN_NAMES = $(notdir $(shell find ./submodules/plugins -mindepth 1 -maxdepth 1 -type d))

DRECK_EXPECTED_PLUGINS_WITH_EXTRACTED_BUNDLES = $(addprefix ./persistent/plugins-with-extracted-bundles/, ${DRECK_PLUGIN_NAMES})

ifneq ($(wildcard ./persistent/plugins-with-extracted-bundles),)
	DRECK_ACTUAL_PLUGINS_WITH_EXTRACTED_BUNDLES = $(shell find ./persistent/plugins-with-extracted-bundles -mindepth 1)
endif

DRECK_FILES_TO_DELETE += $(filter-out ${DRECK_EXPECTED_PLUGINS_WITH_EXTRACTED_BUNDLES}, ${DRECK_ACTUAL_PLUGINS_WITH_EXTRACTED_BUNDLES})

DRECK_CORE_BUNDLED_FILES = $(patsubst ./submodules/dreck/bundled/%, ./%, $(shell find ./submodules/dreck/bundled -type f))

ifneq ($(strip $(wildcard ./src)),)
	DRECK_SRC_DIRECTORIES += ./src
	DRECK_SRC_PATHS += $(patsubst ./src/%, ./%, $(shell find ./src -type f))
endif

ifneq ($(strip $(wildcard ./submodules/plugins/*/src)),)
	DRECK_SRC_DIRECTORIES += $(shell find ./submodules/plugins -mindepth 2 -maxdepth 2 -type d -name "src")
	DRECK_SRC_PATHS += $(addprefix ./, $(foreach path, $(shell find $(shell find ./submodules/plugins -mindepth 2 -maxdepth 2 -type d -name "src") -type f), $(shell echo ${path} | cut -d'/' -f6-)))
endif

ifneq ($(strip ${DRECK_SRC_DIRECTORIES}),)
	DRECK_ABSOLUTE_SRC_PATHS = $(shell find ${DRECK_SRC_DIRECTORIES} -type f)
endif

DRECK_EXPECTED_ABSOLUTE_SRC_PATHS = $(addprefix ./ephemeral/src/, ${DRECK_SRC_PATHS})

ifneq ($(strip $(wildcard ./ephemeral/src)),)
	DRECK_ACTUAL_ABSOLUTE_SRC_PATHS = $(shell find ./ephemeral/src -type f)
endif

DRECK_FILES_TO_DELETE += $(filter-out ${DRECK_EXPECTED_ABSOLUTE_SRC_PATHS}, ${DRECK_ACTUAL_ABSOLUTE_SRC_PATHS})

include $(shell find ./submodules/plugins -mindepth 2 -maxdepth 2 -type f -name "makefile")

DRECK_EXPECTED_ABSOLUTE_INTERMEDIATE_PATHS = $(addprefix ./ephemeral/intermediate/, ${DRECK_INTERMEDIATE_PATHS})

ifneq ($(strip $(wildcard ./ephemeral/intermediate)),)
	DRECK_ACTUAL_ABSOLUTE_INTERMEDIATE_PATHS = $(shell find ./ephemeral/intermediate -type f)
endif

DRECK_FILES_TO_DELETE += $(filter-out ${DRECK_EXPECTED_ABSOLUTE_INTERMEDIATE_PATHS}, ${DRECK_ACTUAL_ABSOLUTE_INTERMEDIATE_PATHS})

ifneq ($(strip ${DRECK_FILES_TO_DELETE}),)
	DRECK_DELETION_DUMMY = dreck-deletion-dummy
endif

all-clean: ${DRECK_CORE_BUNDLED_FILES} ${DRECK_EXPECTED_PLUGINS_WITH_EXTRACTED_BUNDLES} ${DRECK_ABSOLUTE_SRC_PATHS} | ${DRECK_DELETION_DUMMY}

	make --jobs --file ./submodules/dreck/makefile all-post-clean

all-post-clean: ${DRECK_EXPECTED_ABSOLUTE_SRC_PATHS} ${DRECK_EXPECTED_ABSOLUTE_INTERMEDIATE_PATHS}

dreck-deletion-dummy:
	rm ${DRECK_FILES_TO_DELETE}

./persistent/plugins-with-extracted-bundles/%:
	mkdir -p $(dir $@)
	if [ "$(strip $(wildcard ./submodules/plugins/$*/bundled))" != "" ] ; then cp -r ./submodules/plugins/$*/bundled/. . ; fi
	touch $@

$(DRECK_CORE_BUNDLED_FILES): %: | ./submodules/dreck/bundled/%
	mkdir -p $(dir $@)
	cp ./submodules/dreck/bundled/$@ ./$@

./ephemeral/src/./%: $$(filter $$(addsuffix /%, ${DRECK_SRC_DIRECTORIES}), ${DRECK_ABSOLUTE_SRC_PATHS})
	mkdir -p $(dir $@)
	cp $< $@
