#!/bin/bash
set -ev
git clone https://${GH_REF} .deploy_git
cd .deploy_git
git checkout master
cd ../
mv .deploy_git/.git/ ./docs/
cd ./docs
git init
git config user.name  "dingziqi"
git config user.email "dingziqi_xtu@sina.com"
# add commit timestamp
git add .
git commit -m "Travis CI Auto Builder at `date +"%Y-%m-%d %H:%M"`"
git push --force --quiet "https://${Travis_gh_token}@${GH_REF}" master:gh
