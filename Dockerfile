#instalando plugins jenkins
FROM jenkins/jenkins:lts
copy plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
#python
FROM python:3.6
#Copiando os arquivos do projeto para o diretorio usr/src/app 
COPY . /usr/src/app
#Definindo o diretorio onde o CMD será executado e copiando o arquivo de requerimentos
WORKDIR /usr/src/app
COPY requirements.txt ./
# Instalando os requerimentos com o PIP
RUN pip install --no-cache-dir -r requirements.txt
# Expondo a porta da APP
EXPOSE 8000
# Executando o comando para subir a aplicacao.
CMD ["gunicorn", "to_do.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3"]

##salesforce DX 
FROM heroku/heroku:18

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN echo '2d316e55994086e41761b0c657e0027e9d16d7160d3f8854cc9dc7615b99a526  ./nodejs.tar.gz' > node-file-lock.sha \
  && curl -s -o nodejs.tar.gz https://nodejs.org/dist/v12.18.2/node-v12.18.2-linux-x64.tar.gz \
  && shasum --check node-file-lock.sha
RUN mkdir /usr/local/lib/nodejs \
  && tar xf nodejs.tar.gz -C /usr/local/lib/nodejs/ --strip-components 1 \
  && rm nodejs.tar.gz node-file-lock.sha
RUN apt-get install --assume-yes \
  openjdk-11-jdk-headless \
  && mkdir ~/.sfdx-cli \
  && curl https://developer.salesforce.com/media/salesforce-cli/sfdx-linux-amd64.tar.xz | tar xJ -C ~/.sfdx-cli --strip-components 1 \
  && ~/.sfdx-cli/install
  
RUN apt-get autoremove --assume-yes \
  && apt-get clean --assume-yes \
  && rm -rf /var/lib/apt/lists/*

ENV PATH=/usr/local/lib/nodejs/bin:$PATH
ENV SFDX_CONTAINER_MODE true
ENV DEBIAN_FRONTEND=dialog
ENV SHELL /bin/bash

#VARIABLES FOR JENKINS ENVIROMENT
ENV PATH=/usr/local/bin
ENV SF_USERNAME= "TESTEMILY"
ENV SF_INSTANCE_URL = http://login.salesforce.com