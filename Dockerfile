FROM postgres:9.5
MAINTAINER Vsevolod Kaloshin <vsevolod.kaloshin@gmail.com>

ADD patronictl.py patroni.py requirements.txt /
ADD patroni /patroni/

RUN apt-get update -y && \
    apt-get install -y \
        python \
        python-pip \
        postgresql-contrib \
        libpq-dev \
        python3-requests \ 
        python-dev && \
    pip install -U \
        -r /requirements.txt && \
    apt-get remove -y \
        python-pip && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /root/.cache

RUN ln -s /patronictl.py /usr/local/bin/patronictl
EXPOSE 5432 8008
USER postgres
ENTRYPOINT ["python", "/patroni.py"]
