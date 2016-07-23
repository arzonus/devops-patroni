FROM postgres:9.5
MAINTAINER Vsevolod Kaloshin <vsevolod.kaloshin@gmail.com>

RUN apt-get update -y \
    && apt-get install -y curl jq python-psycopg2 python-yaml \
        python-requests python-six python-click python-dateutil python-tzlocal python-urllib3 \
        python-dnspython python-pip python-setuptools python-kazoo python-prettytable python \
    && pip install python-etcd==0.4.3 --upgrade \
    && apt-get remove -y python-pip python-setuptools \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /root/.cache

ADD patronictl.py patroni.py /
ADD patroni /patroni/
RUN ln -s /patronictl.py /usr/local/bin/patronictl


EXPOSE 2379 5432 8008

ENTRYPOINT ["python", "/patroni.py"]
USER postgres
