DRECK_PLUGIN_NAMES = $(notdir $(shell find ./submodules/plugins -mindepth 1 -maxdepth 1 -type d))
DRECK_BUNDLED_MARKERS = $(addprefix ./tmp/bundled-markers/, ${DRECK_PLUGIN_NAMES})
DRECK_CORE_BUNDLED_FILES = $(patsubst ./submodules/dreck/bundled/%, ./%, $(shell find ./submodules/dreck/bundled -type f))

all: ${DRECK_CORE_BUNDLED_FILES}
ifneq ($(wildcard ./tmp/bundled-markers),)
ifneq ($(filter-out ${DRECK_BUNDLED_MARKERS}, $(shell find ./tmp/bundled-markers -mindepth 1)),)
		rm $(filter-out ${DRECK_BUNDLED_MARKERS}, $(shell find ./tmp/bundled-markers -mindepth 1))
endif
endif
	make --jobs --file ./submodules/dreck/makefile all-post-clean

all-post-clean: ${DRECK_BUNDLED_MARKERS}

./tmp/bundled-markers/%:
	mkdir -p $(dir $@)
	if [ $(wildcard ./submodules/plugins/$*/bundled) != "" ] ; then cp -r ./submodules/plugins/$*/bundled/. . ; fi
	touch $@

$(DRECK_CORE_BUNDLED_FILES): %: | ./submodules/dreck/bundled/%
	mkdir -p $(dir $@)
	cp ./submodules/dreck/bundled/$@ ./$@
