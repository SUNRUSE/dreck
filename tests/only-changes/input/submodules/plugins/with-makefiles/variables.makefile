DRECK_DIST_PATHS += $(patsubst ./%-in-lower-case.txt, ./%-in-upper-case.txt, $(filter %-plugin-src-file-in-subdirectory-in-lower-case.txt, $(DRECK_INTERMEDIATE_PATHS)))

DRECK_INTERMEDIATE_PATHS += $(patsubst ./%.txt, ./%-in-lower-case.txt, $(filter %-in-subdirectory.txt, $(DRECK_SRC_PATHS)))
