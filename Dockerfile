FROM postgres:9.5
MAINTAINER Vsevolod Kaloshin <vsevolod.kaloshin@gmail.com>

ADD patronictl.py patroni.py requirements.txt /
ADD patroni /patroni/

RUN apt-get update -y && \
    apt-get install -y \
        python \
        python-pip && \
    pip install \
        -r /requirements.txt && \
    apt-get remove -y \
        python-pip && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /root/.cache

RUN ln -s /patronictl.py /usr/local/bin/patronictl
EXPOSE 5432 8008
ENTRYPOINT ["python", "/patroni.py"]
