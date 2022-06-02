.SECONDEXPANSION:

all: all-clean

DRECK_PLUGIN_NAMES = $(notdir $(shell find ./plugins -mindepth 1 -maxdepth 1 -type d))


DRECK_PLUGIN_BUNDLE_MARKERS = $(addprefix ./persistent/plugins-with-extracted-bundles/, ${DRECK_PLUGIN_NAMES})

ifneq ($(wildcard ./persistent/plugins-with-extracted-bundles),)
	DRECK_PREVIOUS_PLUGIN_BUNDLE_MARKERS = $(shell find ./persistent/plugins-with-extracted-bundles -mindepth 1)
endif

DRECK_FILES_TO_DELETE += $(filter-out ${DRECK_PLUGIN_BUNDLE_MARKERS}, ${DRECK_PREVIOUS_PLUGIN_BUNDLE_MARKERS})


ifneq ($(strip $(wildcard ./plugins/*/src)),)
	DRECK_SRC_PATHS = $(shell find ./plugins/*/src -type f)
endif


include $(shell find ./plugins -mindepth 2 -maxdepth 2 -type f -name "variables.makefile")


ifneq ($(strip $(wildcard ./plugins/*/generated)),)
	DRECK_PREVIOUSLY_GENERATED_PATHS = $(shell find ./plugins/*/generated -type f)
endif

DRECK_FILES_TO_DELETE += $(filter-out ${DRECK_GENERATED_PATHS}, ${DRECK_PREVIOUSLY_GENERATED_PATHS})


ifneq ($(strip ${DRECK_FILES_TO_DELETE}),)
	DRECK_DELETION_DUMMY = dreck-deletion-dummy
endif

all-clean: ${DRECK_PLUGIN_BUNDLE_MARKERS} | ${DRECK_DELETION_DUMMY}
	make --jobs --file ./plugins/dreck/makefile all-post-clean

all-post-clean: ${DRECK_GENERATED_PATHS}

dreck-deletion-dummy:
	rm ${DRECK_FILES_TO_DELETE}

./persistent/plugins-with-extracted-bundles/%:
	mkdir -p $(dir $@)
	if [ "$(strip $(wildcard ./plugins/$*/bundled))" != "" ] ; then cp -r ./plugins/$*/bundled/. . ; fi
	touch $@

include $(shell find ./plugins -mindepth 2 -maxdepth 2 -type f -name "rules.makefile")
