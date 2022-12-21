workspace(name = "build_stack_bazel_jacocorunner")

# --------------------------------------------------
# default workspace dependencies
# --------------------------------------------------

load("//:repositories.bzl", "lcov_repositories", "repositories")

repositories()

# --------------------------------------------------
# @rules_jvm_external
# --------------------------------------------------

load("@rules_jvm_external//:repositories.bzl", "rules_jvm_external_deps")

rules_jvm_external_deps()

load("@rules_jvm_external//:setup.bzl", "rules_jvm_external_setup")

rules_jvm_external_setup()

# --------------------------------------------------
# maven dependencies
# --------------------------------------------------

load("//:maven_repositories.bzl", "maven_repositories")

maven_repositories()

load(
    "@jacoco_maven//:defs.bzl",
    jacoco_pinned_maven_install = "pinned_maven_install",
)

jacoco_pinned_maven_install()

load(
    "@build_stack_bazel_jacocorunner_maven//:defs.bzl",
    build_stack_bazel_jacocorunner_pinned_maven_install = "pinned_maven_install",
)

build_stack_bazel_jacocorunner_pinned_maven_install()

# --------------------------------------------------
# @com_github_gergelyfabian_jacoco
# --------------------------------------------------

load("//:jacoco_repositories.bzl", "jacoco_repositories")

jacoco_repositories()

# --------------------------------------------------
# @io_bazel_rules_scala
# --------------------------------------------------

load("@io_bazel_rules_scala//:scala_config.bzl", "scala_config")
load("//:versions.bzl", "versions")

scala_config(scala_version = ".".join([
    versions.scala.major,
    versions.scala.minor,
    versions.scala.patch,
]))

load("@io_bazel_rules_scala//scala:scala.bzl", "scala_repositories")

scala_repositories()

# --------------------------------------------------
# @rules_perl, lcov
# --------------------------------------------------

lcov_repositories()

load("@rules_perl//perl:deps.bzl", "perl_register_toolchains", "perl_rules_dependencies")

perl_rules_dependencies()

perl_register_toolchains()

# --------------------------------------------------
# toolchains
# --------------------------------------------------

register_toolchains(
    "//tools/scala:compile_toolchain",
    "//tools/scala:testing_toolchain",
    "//tools/jdk:toolchain_java11_definition",
)
