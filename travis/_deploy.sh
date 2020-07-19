#!/bin/sh
# Push HTML files to gh-pages automatically

# skip if build is triggered by pull request
if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  echo "this is PR, exiting"
  exit 0
fi

# Bundler output directory
BUILD_DIR=dist
# Maybe create a special user for CI in the future
EMAIL=Overseer.O5.X@gmail.com

set -e

[ -z "${GITHUB_PAT}" ] && exit 0
[ "${TRAVIS_BRANCH}" != "master" ] && exit 0

git config user.email "$EMAIL"
git config user.name "Travis Build"

# cleanup "site"
rm -rf site

# clone remote repo to "site"
git clone -b gh-pages https://${GITHUB_PAT}@github.com/${TRAVIS_REPO_SLUG}.git site

cd site
git rm -rf .
touch .nojekyll
cp -r ../$BUILD_DIR/* ./
git add --all *
git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
git push --force origin gh-pages