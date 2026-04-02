all: clean install build serve

rebuild: clean build serve

install:
	bundle install
update:
	bundle update

build:
	bundle exec jekyll build --incremental
serve:
	bundle exec jekyll serve --incremental --baseurl="" --watch

clean:
	rm -rf _site
	rm Gemfile.lock
