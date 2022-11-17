
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bis620.2022

<!-- badges: start -->

[![R-CMD-check](https://github.com/denise877/bis620.2022/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/denise877/bis620.2022/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/denise877/bis620.2022/branch/main/graph/badge.svg)](https://app.codecov.io/gh/denise877/bis620.2022?branch=main)
<!-- badges: end -->

The goal of bis620.2022 is to …

## Installation

You can install the development version of bis620.2022 from
[GitHub](https://github.com/) with:

``` r
 #install.packages("devtools")
devtools::install_github("denise877/bis620.2022")
#> Downloading GitHub repo denise877/bis620.2022@HEAD
#> vctrs   (0.5.0 -> 0.5.1) [CRAN]
#> ggplot2 (3.3.6 -> 3.4.0) [CRAN]
#> Installing 2 packages: vctrs, ggplot2
#> 
#>   There is a binary version available but the source version is later:
#>       binary source needs_compilation
#> vctrs  0.5.0  0.5.1              TRUE
#> 
#> 
#> The downloaded binary packages are in
#>  /var/folders/zh/xnk_zk8j0xv3z_3vk5_4qrzh0000gn/T//RtmpbzsvZs/downloaded_packages
#> installing the source package 'vctrs'
#> * checking for file ‘/private/var/folders/zh/xnk_zk8j0xv3z_3vk5_4qrzh0000gn/T/RtmpbzsvZs/remotes72ba114136ef/denise877-bis620.2022-9717f08/DESCRIPTION’ ... OK
#> * preparing ‘bis620.2022’:
#> * checking DESCRIPTION meta-information ... OK
#> * checking for LF line-endings in source and make files and shell scripts
#> * checking for empty or unneeded directories
#> * looking to see if a ‘data/datalist’ file should be added
#> * building ‘bis620.2022_0.1.0.tar.gz’
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(bis620.2022)
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/v1/examples>.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
