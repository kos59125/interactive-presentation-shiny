#!/bin/bash

PORT=${PORT:-8080}

case "$RUN_APP" in
   presenter)
      Rscript -e "rmarkdown::run('./presenter/main.Rmd', shiny_args = list(host = '0.0.0.0', port = ${PORT}))"
      ;;
   respondent)
      Rscript -e "shiny::runApp('./respondent', host = '0.0.0.0', port = ${PORT})"
      ;;
   *)
      echo "environ variable 'RUN_APP' must be either 'presenter' or 'respondent'" 1>&2
      exit 1
      ;;
esac
