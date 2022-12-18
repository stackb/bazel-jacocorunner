#!/bin/bash

set -euox pipefail

GENHTML_PATH='bazel-bin/external/linux_test_project_lcov/genhtml_bin'
COVBEAN_PATH='bazel-bin/tools/covbean/covbean.zip'
COVERAGE_DAT_PATH='bazel-out/_coverage/_coverage_report.dat'

function pre_coverage {
    bazel build @linux_test_project_lcov//:genhtml_bin //tools/covbean
}

function coverage {
    bazel coverage \
        //example/... \
        --combined_report=lcov \
        --coverage_report_generator="@bazel_tools//tools/test/CoverageOutputGenerator/java/com/google/devtools/coverageoutputgenerator:Main" \
        --instrumentation_filter='//example' \
        --experimental_fetch_all_coverage_outputs \
        --test_env=VERBOSE_COVERAGE=1 \
        --test_output=all
}

function post_coverage {
    destdir=$(mktemp -d /tmp/gerritcov.XXXXXX)
    "${GENHTML_PATH}" -o "${destdir}" "${COVERAGE_DAT_PATH}"
    cwd=$(pwd)
    coverage_zip="${cwd}/coverage.zip"
    cp -f "${COVBEAN_PATH}" "${coverage_zip}"
    chmod +w "${coverage_zip}"
    (cd "${destdir}" && zip -r "${coverage_zip}" .)
    rm -rf "${destdir}"
    echo "Coverage app ready: ${coverage_zip}"
}

function main {
    pre_coverage
    coverage
    post_coverage
}

main