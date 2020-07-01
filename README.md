# CloudVE CI scripts

Automatically packages and pushes chart on pull request

## How to use

Make a file at `.github/workflow/packaging.yml` with the following:

```
name: Package
on:
  pull_request:
    types: [closed]
jobs:
  package:
    name: Package and push
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - uses: cloudve/helm-ci@master
        with:
          chart-name: CHART_NAME
          charts-repo: CHARTS_REPO
          github-token: ${{ secrets.GITHUB_TOKEN }}
          chart-token: ${{ secrets.CHARTS_TOKEN }}
          github-context: ${{ toJson(github) }}
          git-branch: ${{ github.event.pull_request.base.ref }}
```

Make sure to replace `CHART_NAME` and `CHARTS_REPO` with the correct values and to set `CHARTS_TOKEN` to a correct GitHub token.

