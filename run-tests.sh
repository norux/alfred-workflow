#!/bin/bash
# Copied from flask-login
# https://github.com/maxcountryman/flask-login

# OUTPUT_PATH=$(pwd)/tests_output

rootdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# workflow="${rootdir}/workflow"
logpath="${rootdir}/test.log"
# testroot="/tmp/alfred-wörkflöw-$$"
# testdir="${testroot}/tests"
# curdir=$(pwd)

function log() {
    echo "$@" | tee -a $logpath
}

# Delete old log file if it exists
if [[ -f "${logpath}" ]]; then
    rm -rf "${logpath}"
fi


###############################################################################
# Set test options and run tests
###############################################################################

# Most options are in tox.ini
PYTEST_OPTS="--cov workflow"

log "Running tests..."

# nosetests $NOSETEST_OPTIONS 2>&1 | tee -a $logpath
py.test $PYTEST_OPTS 2>&1 | tee -a $logpath
ret=${PIPESTATUS[0]}

echo

case "$ret" in
    0) log -e "SUCCESS" ;;
    *) log -e "FAILURE" ;;
esac

# Test coverage
coverage report --fail-under 100
ret=${PIPESTATUS[0]}

echo

case "$ret" in
    0) log -e "SUCCESS" ;;
    *) log -e "FAILURE" ;;
esac

###############################################################################
# Delete test environment
###############################################################################

# cd "$curdir"

# if [[ -d "${testroot}" ]]; then
#     rm -rf "${testroot}"
# fi

exit $ret
