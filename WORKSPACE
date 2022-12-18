workspace(name = "build_stack_rules_scala_coverage")

# --------------------------------------------------
# default workspace dependencies
# --------------------------------------------------

load("//:versions.bzl", "versions")
load("//:repositories.bzl", "repositories")

repositories()

# --------------------------------------------------
# @rules_jvm_external
# --------------------------------------------------

load("@rules_jvm_external//:repositories.bzl", "rules_jvm_external_deps")

rules_jvm_external_deps()

load("@rules_jvm_external//:setup.bzl", "rules_jvm_external_setup")

rules_jvm_external_setup()

# --------------------------------------------------
# maven deps
# --------------------------------------------------

load("//:maven_repositories.bzl", "maven_repositories")

maven_repositories()

load(
    "@jacoco_maven//:defs.bzl",
    jacoco_pinned_maven_install = "pinned_maven_install",
)

jacoco_pinned_maven_install()

load(
    "@build_stack_rules_scala_coverage_maven//:defs.bzl",
    build_stack_rules_scala_coverage_pinned_maven_install = "pinned_maven_install",
)

build_stack_rules_scala_coverage_pinned_maven_install()

# --------------------------------------------------
# @jacoco
# --------------------------------------------------

load("//:jacoco_http_archive.bzl", "jacoco_http_archive")

# Commit: 2974b221b7f2882cf95510abd81344f93c43e54b
# Date: 2022-06-01 03:10:09 +0000 UTC
# URL: https://github.com/gergelyfabian/jacoco/commit/2974b221b7f2882cf95510abd81344f93c43e54b
#
# Filter out macros for com.typesafe.scalalogging
# Size: 648770 (649 kB)
jacoco_http_archive(
    name = "com_github_gergelyfabian_jacoco",
    patch_args = ["-p1"],
    patches = ["//third_party/jacoco:min-distribution-size.patch"],
    sha256 = "98dc417be46a60df250eb8e497267f661577af4f4b2408eb0f2a40806b4798b8",
    strip_prefix = "jacoco-2974b221b7f2882cf95510abd81344f93c43e54b",
    urls = ["https://github.com/gergelyfabian/jacoco/archive/2974b221b7f2882cf95510abd81344f93c43e54b.tar.gz"],
)

# --------------------------------------------------
# @io_bazel_rules_scala
# --------------------------------------------------

load("@io_bazel_rules_scala//:scala_config.bzl", "scala_config")

scala_config(scala_version = ".".join([
    versions.scala.major,
    versions.scala.minor,
    versions.scala.patch,
]))

load("@io_bazel_rules_scala//scala:scala.bzl", "scala_repositories")

scala_repositories()

# --------------------------------------------------
# toolchains
# --------------------------------------------------

register_toolchains(
    "//tools/scala:compile_toolchain",
    "//tools/scala:testing_toolchain",
    # "//:java17_toolchain",
    # "//:java1_8_toolchain",
)
