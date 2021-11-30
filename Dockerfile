FROM rocker/r-ver:latest
MAINTAINER Nandhini Santhanam <nandhini.santhanam@medma.uni-heidelberg.de>
LABEL Description="PJT#6 miracum1"
RUN mkdir -p /Ergebnisse
RUN mkdir -p /errors
RUN mkdir -p /Bundles
COPY config_default.yml config_default.yml
COPY config.yml config.yml
COPY miracum_select.R miracum_select.R
COPY install_R_packages.R install_R_packages.R

ENV http_proxy http://proxy.klima.ads.local:2080/
ENV https_proxy http://proxy.klima.ads.local:2080/
ENV no_proxy 127.0.0.1

RUN apt-get update -qq
RUN apt-get install -yqq libxml2-dev libssl-dev curl
RUN install2.r --error \
  --deps TRUE \
  fhircrackr
  
CMD Rscript miracum_select.R