#!/bin/bash

version=$1
persistent="_coke.sh "

[ "$version" = "" ] && {
	echo "usage: $0 version"
	exit 0
}

set -xe

export LANG=C

go install -tags sqlite github.com/gobuffalo/cli/cmd/buffalo@$version
buffalo version

rm -rf `ls -A |grep -v '^.git$'`
git restore $persistent

buffalo new coke --db-type sqlite3
rm -rf coke/.git
mv coke/.* coke/* .

rm -rf node_modules .pnp.*
if [ -d ".yarn" ]; then
	mv .yarn _y
	mkdir .yarn
	mv _y/patches _y/plugins _y/releases _y/sdks _y/versions .yarn/ || true
	rm -rf _y
fi

sed -i 's,/.*/coke_,,' database.yml
rmdir coke

git add -f . .gitignore
git commit -m "coke webapp generated with buffalo $version"
git tag webapp-$version -m "webapp-$version"
