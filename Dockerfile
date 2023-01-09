FROM python:3.9-slim
# install the notebook package
RUN pip install --no-cache --upgrade pip && \
    pip install --no-cache notebook jupyterlab

# install dynawo dependencies:
RUN apt-get install -y g++ unzip curl

# create user with a home directory UID 1000 is defined by binder
ARG NB_USER=dynawaltz
ARG NB_UID=1000

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
RUN curl -L $(curl -s -L -X GET https://api.github.com/repos/dynawo/dynawo/releases/latest | grep "Dynawo_Linux" | grep url | cut -d '"' -f 4) -o Dynawo_Linux_latest.zip
RUN unzip Dynawo_Linux_latest.zip
RUN mv dynawo /home/${USER}/dynawo
# install pypowsybl
RUN pip install pypowsybl
# moving config to the right place (~/.itools/config.yml)
RUN mkdir .itools
RUN mv config.yaml .itools/config.yml