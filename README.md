ggplot.multistats [![Workflow badge][]](https://github.com/flying-sheep/ggplot.multistats/commits/master)
=================

[Workflow badge]: https://github.com/flying-sheep/ggplot.multistats/workflows/Build%20R%20package/badge.svg

<!-- badges: start -->
<!-- badges: end -->

`ggplot.multistats` currently provides `stat_summaries_hex` and some helpers.

`stat_summaries_hex` is similar to [`ggplot2::stat_summary_hex`][stat_summary_2d],
but allows specifying multiple stats using the `funs` parameter (see [Example](#Example)).

[stat_summary_2d]: https://ggplot2.tidyverse.org/reference/stat_summary_2d.html

Installation
------------
`ggplot.multistats` is not yet on [CRAN](https://CRAN.R-project.org).
Install it using the `devtools` package from GitHub:

```r
# install.packages('devtools')
devtools::install_github('flying-sheep/ggplot.multistats')
```

Example
-------
Specify a summary variable using the `z` aesthetic
and specify a list of `funs` to provide `stat`s for you:

```r
library(ggplot2)
library(ggplot.multistats)

ggplot(iris, aes(Sepal.Width, Sepal.Length)) +
  stat_summaries_hex(
    aes(z = Petal.Width, fill = stat(median), alpha = stat(n)),
    funs = c('median', n = 'length'),
    bins = 5
  )
```

![](example.png)
