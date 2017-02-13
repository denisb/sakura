#!/bin/bash

daemon_index="$1"
shift
operators=$*

cd $(dirname $0)/..
TMPDIR=$(mktemp -d /tmp/daemon$daemon_index.XXXXXXXX)

on_exit()
{
    rm -rf $TMPDIR
}

# whatever happens, call at_exit() at the end.
trap on_exit EXIT

# prepare daemon conf and operators
mkdir -p $TMPDIR/operators
for operator in $operators
do
    cp -r sakura/operators/public/$operator $TMPDIR/operators
done
cat > $TMPDIR/daemon.conf << EOF
{
    "hub-host": "localhost",
    "hub-port": 10432,
    "daemon-desc": "daemon $daemon_index",
    "operators-dir": "$TMPDIR/operators",
    "external-datasets": [ ]
}
EOF

./daemon.py -f $TMPDIR/daemon.conf

