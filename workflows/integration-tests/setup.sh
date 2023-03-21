#!/bin/bash
set -e
set +x

SELF_VERSION=${1:-release\-1}

echo " >> Downloading env.mk"
curl -Ls https://raw.githubusercontent.com/riotkit-org/.github/${SELF_VERSION}/workflows/integration-tests/workspace/env.mk --output env.mk

echo " >> Downloading .env (if not exists)"
if [[ ! -f .env ]]; then
    curl -Ls https://raw.githubusercontent.com/riotkit-org/.github/${SELF_VERSION}/workflows/integration-tests/workspace/.env --output .env
fi

echo " >> Configuring git ignore"
if [[ ! -f .gitignore ]]; then
    echo "" > .gitignore
fi
if [[ $(cat .gitignore) != *".build/"* ]]; then
    echo "/.build/*" > .gitignore
fi

echo " >> Configuring Skaffold"
if [[ ! -f skaffold.yaml ]]; then
    curl -Ls https://raw.githubusercontent.com/riotkit-org/.github/${SELF_VERSION}/workflows/integration-tests/workspace/skaffold.yaml --output skaffold.yaml
fi

echo " >> Adding files to git and pushing changes"
git add .env env.mk .gitignore
git commit -m "chore: Configure environment setup (automatic) / Riotkit"
git push
