#!/bin/bash

export SHELL="/bin/bash"
export PATH="/opt/oss-cad-suite/bin:$PATH"

eval $(ssh-agent)

exec "$@"
