FROM ubuntu:20.04

RUN apt update
RUN apt install -y gnupg curl wget libzmq3-dev

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update -y

RUN wget -q https://repo.saltstack.com/py3/ubuntu/20.04/amd64/3004/SALTSTACK-GPG-KEY.pub && \
    apt-key add SALTSTACK-GPG-KEY.pub && \
    rm SALTSTACK-GPG-KEY.pub
RUN echo "deb [arch=amd64] http://repo.saltstack.com/py3/ubuntu/20.04/amd64/3004 focal main" > /etc/apt/sources.list.d/saltstack.list
RUN apt update
RUN apt install -y salt-minion salt-ssh

# ENV MINION_ID "minion"
ENV MASTER_ADDRESS "salt-master"

# ENTRYPOINT ["salt-minion", "-l", "debug"]
ENTRYPOINT ["bash", "-c", "sed -i \"s|#master: salt|master: ${MASTER_ADDRESS}|g\" /etc/salt/minion && salt-minion -l debug"]
