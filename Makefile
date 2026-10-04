all: rebuild

touch:
	touch archive.md json-schema.md the-language-of-api-design.md api-design-patterns.md

gen: build
site: clean build templates

open:
	open http://127.0.0.1:4000/

reset: clean install

rebuild: clean build serve templates

templates:
	bash ./adm-archive-templates.sh

install:
	bundle install
update:
	bundle update

build:
	bundle exec jekyll build --baseurl=""

auto-build:
	bundle exec jekyll build --baseurl="" --watch

serve:
	bundle exec jekyll serve --baseurl="" --watch

clean:
	rm -rf _site
	rm Gemfile.lock
