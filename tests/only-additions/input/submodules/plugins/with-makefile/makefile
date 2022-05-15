DRECK_INTERMEDIATE_PATHS += $(patsubst ./%.txt, ./%-in-lower-case.txt, $(filter %-in-subdirectory.txt, $(DRECK_SRC_PATHS)))

dummy-rule:
	exit 1

./ephemeral/intermediate/%-in-lower-case.txt: ./ephemeral/src/%.txt
	mkdir -p $(dir $@)
	cat $< | tr A-Z a-z > $@
