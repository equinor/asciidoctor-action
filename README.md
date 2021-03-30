# Asciidoctor GitHub Action

To use this action add the below config to  **.github/workflows/docs-build.yml**

```
name: Build documentation

on:
  push:
    branches:
    - main
    - master

jobs:
  deploy-docs:
    runs-on: ubuntu-18.04
    name: Build and deploy docs to Github pages 
    steps:
    - name: Checkout code
      uses: actions/checkout@v2
    - name: Create docs build directory
      run: mkdir dist && chmod 777 dist
    - name: Build docs
      id: adocbuild
      uses: equinor/asciidoctor-action@main
    - name: Deploy docs to GitHub pages
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_branch: gh-pages
        publish_dir: ./dist
```
## Inputs

### Entry point
Specify if entry point is other than default.

E.g if entry point is README.md, add the following to asciidoctor-action:

```
      with:
        entry_point: README
```

There is no need for a suffix in entry point.

### Docs folder
Specify if docs folder is other than default.

E.g if docs folder is ./, add the following to asciidoctor-action step:

```
      with:
        docs_folder: ./
```

## Example

Please see [docs](docs).

## How to write documentation

* [Ascidoc syntax-quick-reference](https://docs.asciidoctor.org/asciidoc/latest/syntax-quick-reference/)
* [asciidoctor-diagram](https://asciidoctor.org/docs/asciidoctor-diagram/)
* [mermaid](https://mermaid-js.github.io/mermaid/#/)

## Testing

You may run this locally by using `run-locally.sh`.

## Acknowledgements

 - https://github.com/tonynv/asciidoctor-action
