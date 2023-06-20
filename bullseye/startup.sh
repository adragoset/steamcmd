#!/bin/bash
echo "UPDATING ${APPID}"
./steamcmd.sh +force_install_dir "${DATA_DIR}" +login "${USERNAME}" "${PASSWORD}" +app_update "${APPID}" validate +quit && su "${USER}" -c $@