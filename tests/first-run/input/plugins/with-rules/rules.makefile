dummy-rule:
	exit 1

./plugins/with-rules/generated/%-in-lower-case.txt: ./%.txt
	mkdir -p $(dir $@)
	cat $< | tr A-Z a-z > $@
