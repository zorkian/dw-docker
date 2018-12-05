#!/bin/bash
if [[ ! -L $LJHOME/ext/__local ]]; then
    ln -s /dw-config $LJHOME/ext/__local
fi

if [[ ! -L $LJHOME/extlib ]]; then
    ln -s /extlib $LJHOME/extlib
fi

/usr/sbin/apache2ctl start
