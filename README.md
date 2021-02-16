# Asciidoctor GitHub Action

To use this action add the below config to  **.github/workflows/docs-build.yml**

```
name: build adocs

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

## Testing

You may run this locally by using `run-locally.sh`.

## Acknowledgements

 - https://github.com/tonynv/asciidoctor-action
