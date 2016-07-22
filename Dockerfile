FROM ubuntu:16.04
MAINTAINER Vsevolod Kaloshin <vsevolod.kaloshin@gmail.com>

RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y curl jq postgresql-${POSTGRES_VERSION} python-psycopg2 python-yaml \
        python-requests python-six python-click python-dateutil python-tzlocal python-urllib3 \
        python-dnspython python-pip python-setuptools python-kazoo python-prettytable python \
    && pip install python-etcd==0.4.3 --upgrade \
    && apt-get remove -y python-pip python-setuptools \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /root/.cache

ADD patronictl.py patroni.py docker/entrypoint.sh /
ADD patroni /patroni/
RUN ln -s /patronictl.py /usr/local/bin/patronictl

### Setting up a simple script that will serve as an entrypoint
RUN mkdir /data/ && \
    touch /pgpass /patroni.yml && \
    chown postgres:postgres -R /patroni/ /data/ /pgpass /patroni.yml /var/run/ /var/lib/ /var/log/ 

EXPOSE 2379 5432 8008

ENTRYPOINT ["python", "/patroni.py"]
USER postgres
