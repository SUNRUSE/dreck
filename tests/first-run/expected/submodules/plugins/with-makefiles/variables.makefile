DRECK_INTERMEDIATE_PATHS += $(patsubst ./%.txt, ./%-in-lower-case.txt, $(filter %-in-subdirectory.txt, $(DRECK_SRC_PATHS)))
