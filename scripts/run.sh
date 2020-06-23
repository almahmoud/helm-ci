#! /bin/sh
export CHART_NAME=$1
export CHARTS_REPO=$2
export GIT_BRANCH=$3
export GITHUB_CONTEXT=$4
export GIT_TOKEN=$5
echo "Bumping version if necessary..."
bash scripts/bump.sh
export GIT_TOKEN=$6
echo "Packaging and pushing..."
bash scripts/package.sh
