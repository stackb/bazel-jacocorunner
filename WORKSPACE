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
