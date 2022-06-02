DRECK_GENERATED_PATHS += $(patsubst ./%.txt, ./plugins/with-rules/generated/%-in-lower-case.txt, $(filter %.txt, $(DRECK_SRC_PATHS)))
