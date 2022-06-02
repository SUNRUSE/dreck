dummy-rule:
	exit 1

./plugins/with-makefiles/generated/%-in-lower-case.txt: ./%.txt
	mkdir -p $(dir $@)
	cat $< | tr A-Z a-z > $@
