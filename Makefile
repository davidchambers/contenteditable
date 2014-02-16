COFFEE = node_modules/.bin/coffee

JS_FILES = $(patsubst src/%.coffee,lib/%.js,$(shell find src -type f))


.PHONY: all
all: $(JS_FILES)

lib/%.js: src/%.coffee
	mkdir -p $(@D)
	cat $< | $(COFFEE) --compile --stdio > $@


.PHONY: clean
clean:
	rm -f $(JS_FILES)


.PHONY: release-patch release-minor release-major
VERSION = $(shell node -p 'require("./package.json").version')
release-patch: NEXT_VERSION = $(shell node -p 'require("semver").inc("$(VERSION)", "patch")')
release-minor: NEXT_VERSION = $(shell node -p 'require("semver").inc("$(VERSION)", "minor")')
release-major: NEXT_VERSION = $(shell node -p 'require("semver").inc("$(VERSION)", "major")')
release-patch: release
release-minor: release
release-major: release

.PHONY: release
release:
	rm -rf lib
	make
	sed -i '' 's/"version": "[^"]*"/"version": "$(NEXT_VERSION)"/' package.json
	git commit --all --message $(NEXT_VERSION)
	git tag $(NEXT_VERSION)


.PHONY: setup
setup:
	npm install
