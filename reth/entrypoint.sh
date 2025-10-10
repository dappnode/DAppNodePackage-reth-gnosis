#!/bin/sh

# shellcheck disable=SC1091
. /etc/profile

JWT_SECRET=$(get_jwt_secret_by_network "${NETWORK}")
echo "${JWT_SECRET}" >"${JWT_PATH}"

# NETWORK is always gnosis
NETWORK_FLAGS="--gnosis"

# Optionally, add any gnosis-specific flags here if needed

# Log info
echo "[INFO - entrypoint] Starting reth with network flags: $NETWORK_FLAGS"

post_jwt_to_dappmanager "${JWT_PATH}"

# shellcheck disable=SC2086
exec reth \
  node \
  $( [ "${ARCHIVE_NODE}" = false ] && printf -- "--block-interval 5 --prune.senderrecovery.full --prune.receipts.before 0 --prune.accounthistory.distance 10064 --prune.storagehistory.distance 10064" ) \
  --chain "${NETWORK}" \
  --metrics 0.0.0.0:6060 \
  --datadir "${DATA_DIR}" \
  --addr 0.0.0.0 \
  --port "${P2P_PORT}" \
  --http \
  --http.addr 0.0.0.0 \
  --http.port 8545 \
  --http.corsdomain "*" \
  --ws \
  --ws.addr 0.0.0.0 \
  --ws.port 8546 \
  --ws.origins "*" \
  --rpc.max-blocks-per-filter="${RPC_MAX_BLOCKS_PER_FILTER}" \
  --authrpc.addr 0.0.0.0 \
  --authrpc.port 8551 \
  --authrpc.jwtsecret "${JWT_PATH}" ${EXTRA_OPTS}
