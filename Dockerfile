FROM ubuntu:mantic

ENV DEBIAN_FRONTEND noninteractive

RUN groupadd postgres --gid=10077 \
  && useradd --gid postgres --uid=1077 postgres

ENV GOSU_VERSION 1.7
RUN  set -e
RUN  echo "Updating repo data"  && apt-get -qq update \
  && echo "Installing packages" && apt-get -qq install --yes --no-install-recommends ca-certificates wget locales gnupg apt-utils \
  && echo "Cleaning"            && apt-get clean \
  && echo "Cleaning apt lists"  && rm -rf /var/lib/apt/lists/* \
  && echo "Downloadding gosu"   && wget --quiet -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
  && echo "Preparing gosu"      && chmod +x /usr/local/bin/gosu \
  && echo "Running gosu"        && gosu nobody true

RUN localedef --inputfile ru_RU --force --charmap UTF-8 --alias-file /usr/share/locale/locale.alias ru_RU.UTF-8
ENV LANG ru_RU.utf8

ENV SERVER_VERSION 16
ENV PATH /opt/pgpro/1c-$SERVER_VERSION/bin:$PATH

ENV PGDATA /data
RUN  echo "Adding PG16 repos"   && echo deb https://repo.postgrespro.ru/1c-16/ubuntu/ mantic main > /etc/apt/sources.list.d/postgrespro-1c.list \
  && echo "Getting PG16 keys"   && wget --quiet -O- https://repo.postgrespro.ru/keys/GPG-KEY-POSTGRESPRO | apt-key add - \
  && echo "Updating repo"       && apt-get -qq update \
  && echo "Installing packages" && apt-get -qq install --yes --no-install-recommends postgrespro-1c-16-client postgrespro-1c-16-contrib postgrespro-1c-16-libs postgrespro-1c-16-server \
  && echo "Cleaning"            && apt-get clean

RUN  echo "Creating pgdata"     && mkdir --parent /var/run/postgresql "$PGDATA" /docker-entrypoint-initdb.d \
  && echo "Setting acl"         && chown --recursive postgres:postgres /var/run/postgresql "$PGDATA" \
  && echo "Setting acl"         && chmod g+s /var/run/postgresql

COPY container/docker-entrypoint.sh /
COPY container/postgresql.conf.sh /docker-entrypoint-initdb.d

ENTRYPOINT ["/docker-entrypoint.sh"]

VOLUME $PGDATA

EXPOSE 5432

CMD ["postgres"]
