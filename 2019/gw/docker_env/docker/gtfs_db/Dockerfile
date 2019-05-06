# syntax =docker/dockerfile:experimental
FROM mysql
LABEL maintainer "@valsitoh"
WORKDIR /root

COPY script/etc_mysql_my.cnf /etc/mysql/my.cnf
COPY script/setup_gtfs_db.sql /tmp/setup_gtfs_db.sql
COPY script/gtfs.sql /tmp/gtfs.sql
COPY script/gtfs_reference.sql /tmp/gtfs_reference.sql
COPY script/kitaena_gtfs_data.sql /tmp/kitaena_gtfs_data.sql

