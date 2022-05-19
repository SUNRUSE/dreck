dummy-rule:
	exit 1

./ephemeral/intermediate/%-in-lower-case.txt: ./ephemeral/src/%.txt
	mkdir -p $(dir $@)
	cat $< | tr A-Z a-z > $@
