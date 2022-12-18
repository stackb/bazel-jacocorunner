workspace(name = "build_stack_rules_scala_coverage")

# --------------------------------------------------
# default workspace dependencies
# --------------------------------------------------

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
# @maven
# --------------------------------------------------

load("@rules_jvm_external//:defs.bzl", "maven_install")

maven_install(
    artifacts = [
        "com.google.guava:guava:31.1-jre",
        "org.jacoco:org.jacoco.agent:0.8.6",  # TODO(pcj): how to get the -runtime.jar also?
        "org.jacoco:org.jacoco.core:0.8.6",
        "org.jacoco:org.jacoco.report:0.8.6",
    ],
    maven_install_json = "//:maven_install.json",
    repositories = [
        "https://repo1.maven.org/maven2",
        "https://repo.maven.apache.org/maven2",
    ],
)

load("@maven//:defs.bzl", "pinned_maven_install")

pinned_maven_install()

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
# toolchains
# --------------------------------------------------

register_toolchains(
    # "//:java17_toolchain",
    # "//:java1_8_toolchain",
)
