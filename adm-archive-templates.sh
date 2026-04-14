#!/usr/bin/env bash

# Generate insertion template files, one for each post, to make it easier to
# add the Marklown link for it via my M-x it
# Emacs command that support file-based template includes.
#
# For example for the file _posts/2023-12-26-we-talk-api-one-day
# the title is 'We Talk "API" One Day'
# we create a file of that name ~/insert/markdown-mode/We Talk "API" One Day
# with the Markdown text
#
# [We Talk "API" One Day]({{'2023/12/26/we-talk-api-one-day'|relative_url}})
#
# We change the yyyy-mm-dd- part of the Jekyll post file name
# to /yyyy/mm/dd/ and drop the .md suffix
#
for file in _posts/*.md
do
    base=$(basename $file)
    relative_url=$(echo $base | sed -e 's/\(....\)-\(..\)-\(..\)-/\1\/\2\/\3\//'  -e 's/.md$//')
    title=$(egrep '^title: ' $file | head -1 | sed -e 's/title: //')
    echo "[${title}]({{'/${relative_url}'|relative_url}})" | tee "${HOME}/insert/markdown-mode/${title}"
done
