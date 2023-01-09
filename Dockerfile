FROM python:3.9-slim
# install the notebook package
RUN pip install --no-cache --upgrade pip && \
    pip install --no-cache notebook jupyterlab

# install dynawo dependencies:
RUN apt-get update
RUN apt-get install -y g++ unzip curl

# create user with a home directory UID 1000 is defined by binder
ARG NB_USER=dynawaltz
ARG NB_UID=1000

ENV DYNAWO_VER 1.3.2
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}
RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
# copy repo into the image and change rights
COPY . ${HOME}
RUN chown -R ${NB_UID} ${HOME}

WORKDIR ${HOME}
USER ${USER}
# installing dynawo in /home/${USER}/dynawo folder
RUN curl -sSL https://github.com/dynawo/dynawo/releases/download/v${DYNAWO_VER}/Dynawo_Linux_centos7_v${DYNAWO_VER}.zip -o Dynawo_Linux_latest.zip
RUN unzip Dynawo_Linux_latest.zip
# install pypowsybl
RUN pip install pypowsybl
# moving config to the right place (~/.itools/config.yml)
RUN mkdir .itools
RUN mv config.yaml .itools/config.yml