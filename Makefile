.PHONY: clean setup

bin = node_modules/.bin

lib/contenteditable.js: src/contenteditable.coffee
	@mkdir -p $(@D)
	@cat $< | $(bin)/coffee --compile --stdio > $@

clean:
	@rm -rf lib
	@rm -rf node_modules

setup:
	@npm install
