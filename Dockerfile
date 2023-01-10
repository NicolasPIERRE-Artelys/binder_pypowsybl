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

# jovyan is the user created by the jupyter/base-notebook image
# It will be used to launch the jupyter lab
USER jovyan
WORKDIR $HOME
# copy all the necessary data
COPY dynawaltz config.yaml dynawaltz.ipynb $HOME/


# installing dynawo in $HOME/dynawo folder
RUN curl -sSL https://github.com/dynawo/dynawo/releases/download/v${DYNAWO_VER}/Dynawo_Linux_centos7_v${DYNAWO_VER}.zip -o Dynawo_Linux_latest.zip
RUN unzip Dynawo_Linux_latest.zip

# installing dynaflow-launcher in $HOME/dynaflow-launcher folder
RUN curl -sSL https://github.com/dynawo/dynaflow-launcher/releases/download/v${DYNAWO_VER}/DynaFlowLauncher_Linux_v${DYNAWO_VER}.zip -o DynaflowLauncher_Linux_latest.zip
RUN unzip DynaflowLauncher_Linux_latest.zip

# install pypowsybl
# RUN pip install pypowsybl
# moving and templating config (~/.itools/config.yml)
RUN mkdir .itools
# we use bash substitution, dockerfile can't do that with ENV variables
RUN export HOME_ESCAPED_SLASH=${HOME//\//\\\/} && \
    sed s/HOME_DIR_TEMPLATE/$HOME_ESCAPED_SLASH/ config.yaml > .itools/config.yml