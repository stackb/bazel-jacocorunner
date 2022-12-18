
[![CI](https://github.com/stackb/rules_scala_coverage/actions/workflows/ci.yaml/badge.svg)](https://github.com/stackb/rules_scala_coverage/actions/workflows/ci.yaml)

# rules_scala_coverage

- [rules\_scala\_coverage](#rules_scala_coverage)
  - [What is this?](#what-is-this)

## What is this?

- Bazel's [`jacocorunner` source
  code](https://github.com/bazelbuild/bazel/blob/master/src/java_tools/junitrunner/java/com/google/testing/coverage/BUILD),
  copied here so we can more easily build it outside of bazel itself using
  different jacoco jar dependencies.
  (`//java/com/google/testing/coverage:Jacoco_jarjar`).
- A custom http_archive rule that downloads @gergelyfabian's [scala-improved
  fork of jacoco](https://github.com/gergelyfabian/jacoco), builds it with
  `mvn`, and exposes the maven artifacts as deps (`jacoco_http_archive`).
- A `default_java_toolchain` that consumes this custom jacocorunner, which could
  be used directly but more likely serves as an example.
- A `scala_toolchain` and `scala_test_toolchain`.
- A set of examples, shamelessly copied from
  https://github.com/gergelyfabian/bazel-scala-example, which serves as a
  test-base so we can check that things are working.
- A CI job (github actions) that runs the tests on new PRs and the `master`
  branch.