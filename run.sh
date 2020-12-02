#!/bin/sh

CHART_NAME="$1"
CHARTS_REPO="$2"
GIT_BRANCH="$3"
PR_LABELS="$4"
GIT_TOKEN="$5"
CHARTS_TOKEN="$6"
PACKAGING_COMMAND="$7"

GIT_BRANCH=${GIT_BRANCH:-master}
CHART_FILE="$CHART_NAME/Chart.yaml"
REPOSITORY=${INPUT_REPOSITORY:-$GITHUB_REPOSITORY}
CHART_REMOTE="https://$GITHUB_ACTOR:$GIT_TOKEN@github.com/$REPOSITORY.git"

CHARTS_BRANCH=${CHARTS_BRANCH:-$GIT_BRANCH}
CHARTS_REMOTE="https://$GITHUB_ACTOR:$CHARTS_TOKEN@github.com/$CHARTS_REPO.git"
CHARTS_DIR=$(cd .. && realpath "$(basename "$CHARTS_REPO")")

# exit on error
set -e

error() {
  exit 1
}

setup_git() {
  # initializes git info
  git config --local user.email "action@github.com"
  git config --local user.name "GitHub Action"
}

extract_label() {
  # decides which part of the version to increment (if any)
  echo "Extracting label information"
  bump=$(echo "$PR_LABELS" | awk \
    '/version/{print "1"; exit;}
    /feature/{print "2"; exit;}
    /patch/{print "3"; exit;}
	//{print ""; exit;}')
}

bump_version() {
  # bumps the part of the version defined by $bump and updates
  # the chart 
  echo "Bumping version"
  version=$(awk '/^version/{print $2}' "$CHART_FILE")
  new_version=$(echo "$version" | awk "BEGIN {OFS=FS=\".\"} \$$bump += 1")
  sed -i "s/^version: .\+/version: $new_version/" "$CHART_FILE"
}

push_version() {
  # pushes the updated version to the charts repo
  echo "Pushing to branch $GIT_BRANCH"
  git add .
  git commit -m "Automatic Version Bumping"
  git push "$CHART_REMOTE" "HEAD:$GIT_BRANCH" -v -v
}

package() {
  # packages helm chart
  (cd "$CHART_NAME" || error
  rm -rf charts requirements.lock
  helm dependency update)

  (cd ..
  git clone "$CHARTS_REMOTE"
  echo $(pwd)
  cd "$CHARTS_DIR" || error
  echo $(pwd)
  git checkout "$CHARTS_BRANCH")

  # custom packaging command
  eval "$PACKAGING_COMMAND"
}

push_package() {
  # push updated chart
  echo "Pushing to branch $CHARTS_BRANCH of repo $CHARTS_REPO"
  (cd "$CHARTS_DIR" || error
  helm repo index . --url "https://raw.githubusercontent.com/$CHARTS_REPO/$CHARTS_BRANCH/"
  setup_git
  git add . && git commit -m "Automatic Packaging of $CHART_NAME chart" 
  git push "$CHARTS_REMOTE" "HEAD:$CHARTS_BRANCH")
}

echo "Bumping version if necessary..."
setup_git
git remote -v
git pull
if ! git diff --name-status origin/"$GIT_BRANCH" | grep "$CHART_FILE"; then
  extract_label
  if [ "$bump" ]; then
    bump_version
    push_version
  fi
fi

echo "Packaging and pushing..."
package
push_package
