#!/bin/bash -xe
run_restic () {
    NAME=${1}; shift
    BUCKET=${1}; shift
    TARGET=${1}; shift
    telegram -t ${TELEGRAM_TOKEN} -c ${TELEGRAM_CLIENT} "${NAME}: backup started"
    REPO_EXISTS=$(rclone lsjson ${BUCKET}/config | jq length)
    if [ ${REPO_EXISTS} -ne 1 ];
    then
        restic \
            --cache-dir /cache/${NAME} \
            --repo rclone:${BUCKET} \
            --verbose=2 \
            init
        telegram -t ${TELEGRAM_TOKEN} -c ${TELEGRAM_CLIENT} "${NAME}: remote repo initialized"
    fi
    cd ${TARGET}
    restic \
        --cache-dir /cache/${NAME} \
        --repo rclone:${BUCKET} \
        --verbose=2 \
        backup . \
        | tee /tmp/execution.txt

    if [ 0 -eq ${PIPESTATUS[0]} ]
    then
        export STATUS="success"
    else
        export STATUS="failure"
    fi
    telegram -t "${TELEGRAM_TOKEN}" -c "${TELEGRAM_CLIENT}" "${NAME}: backup ${STATUS}"
}

run_restic $@
