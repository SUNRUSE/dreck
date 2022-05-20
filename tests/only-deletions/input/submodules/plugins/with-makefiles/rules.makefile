dummy-rule:
	exit 1

./ephemeral/intermediate/%-in-lower-case.txt: ./ephemeral/src/%.txt
	mkdir -p $(dir $@)
	cat $< | tr A-Z a-z > $@

./ephemeral/dist/%-in-upper-case.txt: ./ephemeral/intermediate/%-in-lower-case.txt
	mkdir -p $(dir $@)
	cat $< | tr a-z A-Z > $@
