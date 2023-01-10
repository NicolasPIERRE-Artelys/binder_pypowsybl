FROM jupyter/base-notebook:python-3.9.7
USER root
# install the notebook package
RUN pip install --no-cache --upgrade pip && \
    pip install --no-cache notebook jupyterlab

# install dynawo dependencies:
RUN apt-get update
RUN apt-get install -y g++ unzip curl

ENV DYNAWO_VER=1.3.2
ENV JUPYTER_ENABLE_LAB=yes

# copy repo into the image and change rights
USER jovyan
WORKDIR $HOME
COPY . $HOME/


# installing dynawo in $HOME/dynawo folder
RUN curl -sSL https://github.com/dynawo/dynawo/releases/download/v${DYNAWO_VER}/Dynawo_Linux_centos7_v${DYNAWO_VER}.zip -o Dynawo_Linux_latest.zip
RUN unzip Dynawo_Linux_latest.zip
# install pypowsybl
RUN pip install pypowsybl
# moving config to the right place (~/.itools/config.yml)
RUN mkdir .itools
RUN mv config.yaml .itools/config.yml
