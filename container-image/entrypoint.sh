#!/bin/bash

env

DIR_NAME="${DIR_NAME:-bareos-dir}"
CLIENT_NAME="${CLIENT_NAME:-$HOSTNAME}"

# generate a bareos-fd config-file
sed \
  --expression="s/@DIR_NAME@/$DIR_NAME/" \
  --expression="s/@DIR_PASSWORD@/$DIR_PASSWORD/" \
  --expression="s/@DIR_ADDRESS@/$DIR_ADDRESS/" \
  --expression="s/@CLIENT_NAME@/$CLIENT_NAME/" \
  bareos-fd.conf.in > /tmp/bareos-fd.conf

# generate mysql config-file
sed \
  --expression="s/@MYSQL_DB_HOST@/$MYSQL_DB_HOST/" \
  --expression="s/@MYSQL_DB_USER@/$MYSQL_DB_USER/" \
  --expression="s/@MYSQL_DB_PASSWORD@/$MYSQL_DB_PASSWORD/" \
  mysql-defaults.cnf.in > /etc/my.cnf.d/backup.cnf

exec bareos-fd -c /tmp/bareos-fd.conf "$@"
