DRECK_PLUGIN_NAMES = $(shell find ./submodules/plugins -mindepth 1 -maxdepth 1 -printf "%P\n" -type d)
DRECK_BUNDLED_MARKERS = $(addprefix ./tmp/bundled-markers/, ${DRECK_PLUGIN_NAMES})

all:
	rm $(filter-out ${DRECK_BUNDLED_MARKERS}, $(shell find ./tmp/bundled-markers -mindepth 1))
	make --jobs --file ./submodules/dreck/makefile all-post-clean

all-post-clean: ${DRECK_BUNDLED_MARKERS}

./tmp/bundled-markers/%:
	mkdir -p $(dir $@)
ifneq ($(wildcard ./submodules/plugins/$*/bundled),)
		cp -r ./submodules/plugins/$*/bundled/. .
endif
	touch $@
