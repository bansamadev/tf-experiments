#!/bin/sh
cat <<EOF
{
  "docker_host": "unix:///$XDG_RUNTIME_DIR/podman/podman.sock"
}
EOF
