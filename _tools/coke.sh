#!/bin/bash

version=$1
persistent="_tools "

[ "$version" = "" ] && {
	echo "usage: $0 version"
	exit 0
}

set -xe

export LANG=C

go install -tags sqlite github.com/gobuffalo/cli/cmd/buffalo@$version
buffalo version

rm -rf * .[A-fh-z0-9]*
git restore $persistent

buffalo new coke --db-type sqlite3 --vcs none
mv coke/.[A-fh-z0-9]* coke/* .
rm -rf node_modules .pnp.* .yarn
sed -i 's,/.*/coke_,,' database.yml
rmdir coke

git add .
git commit -m "coke webapp generated with buffalo $version"
git tag webapp-$version
