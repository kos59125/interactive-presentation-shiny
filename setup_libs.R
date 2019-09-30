##
## This script should run with --vanilla option.
##

options(
   repos = Sys.getenv('R_CRAN_MIRROR', 'https://cloud.r-project.org')
)

if (!('remotes' %in% rownames(installed.packages()))) {
   install.packages('remotes')
}

remotes::install_cran(c('magrittr', 'dplyr', 'httr'))
remotes::install_cran(c('shiny', 'shinyjs', 'shinyWidgets', 'V8', 'knitr', 'rmarkdown'))
remotes::install_cran(c('logging', 'config', 'glue'))
remotes::install_cran(c('ggplot2', 'plotly', 'DiagrammeR', 'qrencoder', 'raster'))
remotes::install_cran(c('uuid', 'urltools', 'xml2'))
remotes::install_github(c('cloudyr/aws.signature', 'cloudyr/aws.dynamodb'))
