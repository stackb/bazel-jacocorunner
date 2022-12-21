
[![CI](https://github.com/stackb/bazel-jacocorunner/actions/workflows/ci.yaml/badge.svg)](https://github.com/stackb/bazel-jacocorunner/actions/workflows/ci.yaml)

# bazel-jacocorunner

- [bazel-jacocorunner](#bazel-jacocorunner)
  - [What is this?](#what-is-this)
- [Usage](#usage)
  - [`WORKSPACE`](#workspace)
  - [`.bazelrc`](#bazelrc)
  - [`coverage.sh`](#coveragesh)

## What is this?

- Bazel's [`jacocorunner` source
  code](https://github.com/bazelbuild/bazel/blob/master/src/java_tools/junitrunner/java/com/google/testing/coverage/BUILD),
  copied here so we can more easily build it outside of bazel itself using
  different jacoco jar dependencies.
  (see `//java/com/google/testing/coverage`).
- A custom http_archive rule that downloads @gergelyfabian's [scala-improved
  fork of jacoco](https://github.com/gergelyfabian/jacoco), builds it with
  `mvn`, and exposes the maven artifacts as deps (`jacoco_http_archive`).
- A set of scala+java examples, shamelessly copied from
  https://github.com/gergelyfabian/bazel-scala-example, which serves as a
  test-base so we can check that things are working.
- A `coverage.sh` script that runs `bazel coverage` and then performs
  lcov/genhtml post-processing on the combined `_coverage_report.dat`.
- A github workflow `ci.yaml` that runs the tests on new PRs and the `master`
  branch.
- A github workflow `release.yaml` that publishes `jacocorunner-{VERSION}.jar`
  as a release asset.
- A set of `java_toolchain` and
  `toolchain<@bazel_tools//tools/jdk:toolchain_type>` in `//tools/jdk` (using
  the same naming patterns in `@bazel_tools//tools/jdk`) that consume the
  release asset jar in the `java_toolchain.jacocorunner` attribute.

# Usage

To use one of the custom java toolchains, you could do something like the
following:

## `WORKSPACE`

```bazel
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# --------------------------------------------------------
# provides @build_stack_bazel_jacocorunner//tools/jdk:*
# --------------------------------------------------------

# Branch: master
# Commit: 6b66562185f2700dcdb33c7a5382bde0c7f7d15f
# Date: 2022-12-20 22:51:53 +0000 UTC
# URL: https://github.com/stackb/bazel-jacocorunner/commit/6b66562185f2700dcdb33c7a5382bde0c7f7d15f
# 
# expand toolchain completely
# Size: 443788 (444 kB)
http_archive(
    name = "build_stack_bazel_jacocorunner",
    sha256 = "8c940052ae59e2bf0d15d36e704222f3a9201cc6599b16e4cac2467c66083378",
    strip_prefix = "bazel-jacocorunner-6b66562185f2700dcdb33c7a5382bde0c7f7d15f",
    urls = ["https://github.com/stackb/bazel-jacocorunner/archive/6b66562185f2700dcdb33c7a5382bde0c7f7d15f.tar.gz"],
)

# --------------------------------------------------------
# provides @bazel_jacocorunner//:jar, needed by 
# toolchains in @build_stack_bazel_jacocorunner//tools/jdk
# --------------------------------------------------------

load("@build_stack_bazel_jacocorunner//:repositories.bzl", "bazel_jacocorunner")

bazel_jacocorunner()

# --------------------------------------------------------
# register a toolchain
# --------------------------------------------------------

register_toolchains("@build_stack_bazel_jacocorunner//tools/jdk:toolchain_java11_definition")
```

## `.bazelrc`

```conf
build:java11 --java_language_version=11
build:java11 --tool_java_language_version=11
build:java11 --java_runtime_version=remotejdk_11
build:java11 --tool_java_runtime_version=remotejdk_11
build:java11 --java_toolchain=@build_stack_bazel_jacocorunner//tools/jdk:toolchain_java11_definition
build:java11 --host_java_toolchain=@build_stack_bazel_jacocorunner//tools/jdk:toolchain_java11_definition

coverage:combined --combined_report=lcov
coverage:combined --coverage_report_generator="@bazel_tools//tools/test/CoverageOutputGenerator/java/com/google/devtools/coverageoutputgenerator:Main"
coverage:combined --experimental_fetch_all_coverage_outputs
coverage:combined --test_env=VERBOSE_COVERAGE=1

build --config=java11
coverage --config=combined
```

## `coverage.sh`

If you want to use lcov/genhtml without having to install them on the host, add
the following to your `WORKSPACE`:

```bazel
load("@build_stack_bazel_jacocorunner//:repositories.bzl", "lcov_repositories")

lcov_repositories()
```

This could be used something like the following in a shell script:

```sh
# prebuild some tools so they are in bazel-bin...
bazel build @linux_test_project_lcov//:genhtml_bin @build_stack_bazel_jacocorunner//tools/covbean

# run your coverage targets and generate the bazel-out/_coverage/_coverage_report.dat file...
bazel coverage //...

# make a temp directory for the report files
reportdir=$(mktemp -d /tmp/bazelcov.XXXXXX)

# run genhtml on the output
bazel-bin/external/linux_test_project_lcov/genhtml_bin \
  -branch-coverage \
  -o $reportdir \
  bazel-out/_coverage/_coverage_report.dat

# optionally, pack the report into an executable zip with an embedded webserver
local covbean_zip="$PWD/covbean.zip"
cp bazel-bin/external/build_stack_bazel_jacocorunner/tools/covbean/covbean.zip $covbean_zip
chmod +wx $covbean_zip
(cd $reportdir && zip $covbean_zip .)

# clean up
rm -rf $reportdir

```

Then you can view your report as follows:

```sh
sh ./covbean.zip &
open http://localhost:8080
```
