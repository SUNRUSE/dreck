DRECK_GENERATED_PATHS += $(patsubst ./%.txt, ./plugins/with-makefiles/generated/%-in-lower-case.txt, $(filter %.txt, $(DRECK_SRC_PATHS)))
