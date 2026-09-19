#!/bin/sh
set -eu

cd /home/container

echo "Starting RustFS..."

/usr/bin/rustfs /home/container/data &
RUSTFS_PID=$!

cleanup() {
    echo "Stopping RustFS..."
    kill "$RUSTFS_PID" 2>/dev/null || true
    wait "$RUSTFS_PID" 2>/dev/null || true
}

trap cleanup TERM INT

echo "Waiting for RustFS to become ready..."

while ! wget -q --spider http://127.0.0.1:9000/health/live 2>/dev/null; do
    if ! kill -0 "$RUSTFS_PID" 2>/dev/null; then
        echo "RustFS process exited unexpectedly."
        wait "$RUSTFS_PID"
        exit 1
    fi

    sleep 1
done

echo "RustFS is ready"

wait "$RUSTFS_PID"
