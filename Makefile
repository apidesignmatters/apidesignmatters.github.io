build:
	bundle exec jekyll build --incremental
serve:
	bundle exec jekyll serve --incremental --baseurl="" --watch

clean:
	rm -rf _site
