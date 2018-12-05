#!/bin/bash
# build and run; used when we're working on the proxy itself
cd /dw/src/proxy; go build

/dw/src/proxy/proxy -salt_file=/proxy-salt