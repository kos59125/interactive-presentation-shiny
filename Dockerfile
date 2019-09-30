# FROM  rocker/r-ver

# # setup
# WORKDIR  /tmp
# ADD  ./setup_libs.R ./
# RUN  apt-get -qq update \
#    && apt-get -q install -y --no-install-recommends libxt-dev libcairo2-dev libcurl4-openssl-dev libssl-dev libxml2-dev libv8-dev \
#    && apt-get -q install -y --install-recommends fonts-noto pandoc pandoc-citeproc \
#    && Rscript --vanilla setup_libs.R \
#    && apt-get -qq clean \
#    && rm -rf /var/lib/apt/lists/* \
#    && mkdir /app
# WORKDIR  /app

FROM  asia.gcr.io/interactive-shiny-presentation/interactive-presentation-base

# deploy
ADD  presenter ./presenter/
ADD  respondent ./respondent/
ADD  config.yml ./

ADD  entrypoint.sh ./
RUN  chmod +x entrypoint.sh
ENTRYPOINT  ["./entrypoint.sh"]
