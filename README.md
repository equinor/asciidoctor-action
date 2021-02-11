# Asciidoctor GitHub Action

To use this action add the below config to  **.github/workflows/adocs-build.yml**

```
name: build adocs

on:
  push:
    branches:
    - main

jobs:
  adoc_build:
    runs-on: ubuntu-18.04
    name: asciidoctor -D docs --backend=html5 -o index.html -a toc2 docs/index.adoc 
    steps:
    - name: Checkout code
      uses: actions/checkout@v2
    - name: Get build container
      id: adocbuild
      uses: avattathil/asciidoctor-action@master
      with:
          program: "asciidoctor -D docs --backend=html5 -o index.html docs/index.adoc"
    - name: Print execution time
      run: echo "Time ${{ steps.adocbuild.outputs.time }}"
    - name: Deploy docs to ghpages
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_branch: gh-pages
        publish_dir: ./
```

Run locally:

```
docker run -it mdc /bin/bash
docker run -it --security-opt seccomp=chrome.json  mdc /bin/bash
asciidoctor -r asciidoctor-diagram  -D docs --backend=html5 -o index.html docs/index.adoc
```