# RLSeq

<!-- badges: start -->
[![R-CMD-check](https://github.com/Bishop-Laboratory/RLSeq/workflows/R-CMD-check/badge.svg)](https://github.com/Bishop-Laboratory/RLSeq/actions)
[![Codecov test coverage](https://codecov.io/gh/Bishop-Laboratory/RLSeq/branch/main/graph/badge.svg)](https://codecov.io/gh/Bishop-Laboratory/RLSeq?branch=main)
[![BioC status](http://www.bioconductor.org/shields/build/release/bioc/RLSeq.svg)](https://bioconductor.org/checkResults/release/bioc-LATEST/RLSeq)
<!-- badges: end -->

## Development notes
Make sure to open the Rproject 
To build this package, document, test, Document, and check, use the controls on the Build panel


## Installation

Once the repo is no longer private, the following will work:

```R
devtools::install_github("Bishop-Laboratory/RLSeq")
```

Prior to publicizing the repo, you will need a personal access token. Follow [these instructions](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token) to create one. And then do the following:

```R
remotes::install_github("Bishop-Laboratory/RLSeq", dependencies = "Imports", force = TRUE,
                         auth_token = "<your_access_token>")
```

This should allow you to install the package from github. You can also build the package locally by using the build tools inside of RStudio:

![image](https://user-images.githubusercontent.com/44813811/124140672-4b443e80-da4e-11eb-9be8-b68bf512a4a9.png)


