bin = node_modules/.bin


lib/contenteditable.js: src/contenteditable.coffee
	@mkdir -p $(@D)
	@cat $< | $(bin)/coffee --compile --stdio > $@


.PHONY: release
release:
ifndef VERSION
	$(error VERSION not set)
endif
	@rm -rf lib
	@make
	@sed -i '' 's/"version": "[^"]*"/"version": "$(VERSION)"/' package.json
	@git commit --all --message $(VERSION)
	@git tag $(VERSION)
	@echo 'remember to run `npm publish`'


.PHONY: setup
setup:
	@npm install
