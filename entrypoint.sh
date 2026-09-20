#!/bin/sh
set -eu

cd /home/container

RUSTFS_DATA_PATH="/rustfs-data"

echo "Starting RustFS..."
echo "RustFS data path: ${RUSTFS_DATA_PATH}"

if [ ! -d "${RUSTFS_DATA_PATH}" ]; then
    echo "ERROR: RustFS storage mount is missing!"
    echo "Expected mount at: ${RUSTFS_DATA_PATH}"
    exit 1
fi

if ! touch "${RUSTFS_DATA_PATH}/.rustfs-write-test" 2>/dev/null; then
    echo "ERROR: RustFS storage is not writable!"
    echo "The mount must be writable by the container user."
    exit 1
fi

rm -f "${RUSTFS_DATA_PATH}/.rustfs-write-test"

echo "RustFS storage is available and writable."

/usr/bin/rustfs "${RUSTFS_DATA_PATH}" &
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
