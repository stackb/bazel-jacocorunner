#!/bin/bash

set -euo pipefail

GENHTML_PATH='bazel-bin/external/linux_test_project_lcov/genhtml_bin'
COVBEAN_PATH='bazel-bin/tools/covbean/covbean.zip'
COVERAGE_DAT_PATH='bazel-out/_coverage/_coverage_report.dat'
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
    destdir=$(mktemp -d /tmp/gerritcov.XXXXXX)
    "${GENHTML_PATH}" -o "${destdir}" "${COVERAGE_DAT_PATH}"
    cwd=$(pwd)
    bazel_out=$(bazel info output_path)
    coverage_zip="${bazel_out}/_coverage/coverage.zip"
    cp -f "${COVBEAN_PATH}" "${coverage_zip}"
    chmod +wx "${coverage_zip}"
    (cd "${destdir}" && zip -r "${coverage_zip}" .)
    rm -rf "${destdir}"
    echo ""
    echo "Coverage app ready: ${coverage_zip}"
    echo " - view contents: unzip -l ${coverage_zip}"
    echo " - start http server: sh ${coverage_zip}"
}

function main {
    pre_coverage
    coverage
    post_coverage
}

main