
[![CI](https://github.com/stackb/bazel_jacocorunner/actions/workflows/ci.yaml/badge.svg)](https://github.com/stackb/bazel_jacocorunner/actions/workflows/ci.yaml)

# bazel_jacocorunner

- [rules\_scala\_coverage](#bazel_jacocorunner)
  - [What is this?](#what-is-this)
  - [Links](#links)

## What is this?

- Bazel's [`jacocorunner` source
  code](https://github.com/bazelbuild/bazel/blob/master/src/java_tools/junitrunner/java/com/google/testing/coverage/BUILD),
  copied here so we can more easily build it outside of bazel itself using
  different jacoco jar dependencies.
  (see `//java/com/google/testing/coverage`).
- A custom http_archive rule that downloads @gergelyfabian's [scala-improved
  fork of jacoco](https://github.com/gergelyfabian/jacoco), builds it with
  `mvn`, and exposes the maven artifacts as deps (`jacoco_http_archive`).
- A `default_java_toolchain` that consumes this custom jacocorunner, which could
  be used directly but more likely serves as an example (ses
  `//tools/java:java17_toolchain`).
- Example `scala_toolchain` and `scala_test_toolchain` (see
  `//tools/scala:compile_toolchain` and `//tools/scala:testing_toolchain`).
- A set of scala+java examples, shamelessly copied from
  https://github.com/gergelyfabian/bazel-scala-example, which serves as a
  test-base so we can check that things are working.
- A `coverage.sh` script that runs `bazel coverage` and then performs
  lcov/genhtml post-processing on the combined `_coverage_report.dat`.  The
  final generated report HTML files are packed as a [redbean
  app](https://redbean.dev/) (fancy zip file) for easy serving.
- A CI job (github actions) that runs the tests on new PRs and the `master`
  branch.

## Links

- https://www.youtube.com/watch?v=P51Rgcbxhyk