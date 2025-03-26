#!/bin/bash

export SHELL="/bin/bash"
export PATH="/opt/oss-cad-suite/bin:$PATH"

# Ensure proper permissions for virtual environment
if [ -d "$VIRTUAL_ENV" ]; then
    sudo chown -R user:user "$VIRTUAL_ENV"
fi

eval $(ssh-agent)

exec "$@"
