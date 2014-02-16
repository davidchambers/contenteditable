COFFEE = node_modules/.bin/coffee

JS_FILES = $(patsubst src/%.coffee,lib/%.js,$(shell find src -type f))


.PHONY: all
all: $(JS_FILES)

lib/%.js: src/%.coffee
	mkdir -p $(@D)
	cat $< | $(COFFEE) --compile --stdio > $@


.PHONY: release
release:
ifndef VERSION
	$(error VERSION not set)
endif
	rm -rf lib
	make
	sed -i '' 's/"version": "[^"]*"/"version": "$(VERSION)"/' package.json
	git commit --all --message $(VERSION)
	git tag $(VERSION)


.PHONY: setup
setup:
	npm install
