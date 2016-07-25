FROM ubuntu:16.04
MAINTAINER Vsevolod Kaloshin <vsevolod.kaloshin@gmail.com>

RUN echo 'APT::Install-Recommends "0";' > /etc/apt/apt.conf.d/01norecommend \
    && echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/01norecommend

ENV PGVERSION 9.5
ENV PATH /usr/lib/postgresql/${PGVERSION}/bin:$PATH
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y \
        curl \
        jq  \ 
        postgresql-${PGVERSION} \
        postgresql-contrib \
        python-psycopg2 \
        python-yaml \
        python-requests \
        python-six \
        python-click \
        python-dateutil \
        python-tzlocal \
        python-urllib3 \
        python-dnspython \
        python-pip \
        python-setuptools \
        python-kazoo \
        python-prettytable \
        python && \
    pip install \
        python-etcd==0.4.3 \
        python-consul==0.6.0 --upgrade && \
    apt-get remove -y \
        python-pip \
        python-setuptools && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /root/.cache

ADD patronictl.py patroni.py /
ADD patroni /patroni/
RUN ln -s /patronictl.py /usr/local/bin/patronictl

EXPOSE 5432 8008
USER postgres
ENTRYPOINT ["python", "/patroni.py"]
