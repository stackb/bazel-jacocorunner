#!/bin/bash

set -euo pipefail

GENHTML_PATH='bazel-bin/external/linux_test_project_lcov/genhtml_bin'
COVBEAN_PATH='bazel-bin/tools/covbean/covbean.zip'
COVERAGE_DAT_PATH='bazel-out/_coverage/_coverage_report.dat'
GOLDEN_COVERAGE_DAT_PATH='example/golden/_coverage_report.dat'
GENHTML_TARGET='@linux_test_project_lcov//:genhtml_bin'
COVBEAN_TARGET='//tools/covbean'
COVERAGE_TARGET='//example/...'

function pre_coverage {
    bazel build "${GENHTML_TARGET}" "${COVBEAN_TARGET}"
}

function coverage {
    bazel coverage "${COVERAGE_TARGET}" --config=combined --instrumentation_filter='//example'
}

function post_coverage {
    local destdir=$(mktemp -d /tmp/gerritcov.XXXXXX)
    "${GENHTML_PATH}" --branch-coverage -o "${destdir}" "${COVERAGE_DAT_PATH}"
    local cwd=$(pwd)
    local bazel_out=$(bazel info output_path)
    local coverage_zip="${bazel_out}/_coverage/coverage.zip"
    cp -f "${COVBEAN_PATH}" "${coverage_zip}"
    chmod +wx "${coverage_zip}"
    (cd "${destdir}" && zip -r "${coverage_zip}" .)
    rm -rf "${destdir}"
    echo ""
    echo "Coverage app ready: ${coverage_zip}"
    echo " - view contents: unzip -l ${coverage_zip}"
    echo " - start http server: sh ${coverage_zip}"
}

function compare_coverage {
    diff "${GOLDEN_COVERAGE_DAT_PATH}" "${COVERAGE_DAT_PATH}" || echo "Coverage output file '${COVERAGE_DAT_PATH}' is different than expected golden file"
}

function main {
    pre_coverage
    coverage
    post_coverage
    compare_coverage
}

main