#!/bin/bash

# Push HTML files to gh-pages automatically

# Exit with nonzero exit code if anything fails
set -e

# skip if build is triggered by pull request
if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  echo "this is PR, exiting"
  exit 0
fi

# Make sure GITHUB_PAT environment variable is set up
[ -z "${GITHUB_PAT}" ] && exit 0
# Only pushing to master should initiate the process
[ "${TRAVIS_BRANCH}" != "master" ] && exit 0

# Bundler output directory
BUILD_DIR=dist
# Maybe create a special user for CI in the future
EMAIL=travis@travis-ci.org

git config --global user.email "$EMAIL"
git config --global user.name "Travis CI"

# cleanup "site"
rm -rf site

# clone remote repo to "site"
git clone -b gh-pages https://${GITHUB_PAT}@github.com/${TRAVIS_REPO_SLUG}.git site

cd site
git rm -rf .
touch .nojekyll
cp -r ../$BUILD_DIR/* ./
git add --all *
git commit -a -m "Travis build: #$TRAVIS_BUILD_NUMBER"
git push --force origin gh-pages