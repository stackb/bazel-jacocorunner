load("@rules_jvm_external//:defs.bzl", "maven_install")
load("//:versions.bzl", "versions")

SCALA_VERSION = "%s.%s" % (versions.scala.major, versions.scala.minor)
JACOCO_VERSION = "%s.%s.%s" % (versions.jacoco.major, versions.jacoco.minor, versions.jacoco.patch)

def _maybe(repo_rule, name, **kwargs):
    if name not in native.existing_rules():
        repo_rule(name = name, **kwargs)

def maven_repositories():
    jacoco_maven()
    build_stack_bazel_jacocorunner_maven()

def jacoco_maven():
    _maybe(
        maven_install,
        name = "jacoco_maven",
        artifacts = [
            "com.google.guava:guava:31.1-jre",
            "com.google.auto.value:auto-value:1.8.2",
            "com.google.auto.value:auto-value-annotations:1.8.2",
            "com.google.code.gson:gson:2.9.1",
            "com.beust:jcommander:1.48",
            "org.jacoco:org.jacoco.agent:" + JACOCO_VERSION,
            "org.jacoco:org.jacoco.core:" + JACOCO_VERSION,
            "org.jacoco:org.jacoco.report:" + JACOCO_VERSION,
        ],
        # bazel run @jacoco_maven//:pin
        maven_install_json = "//:jacoco_maven_install.json",
        repositories = [
            "https://repo1.maven.org/maven2",
            "https://repo.maven.apache.org/maven2",
        ],
    )

def build_stack_bazel_jacocorunner_maven():
    _maybe(
        maven_install,
        name = "build_stack_bazel_jacocorunner_maven",
        artifacts = [
            "junit:junit:4.12",
            "org.scalatest:scalatest_%s:3.0.8" % SCALA_VERSION,
            "com.twitter:algebird-core_%s:0.13.7" % SCALA_VERSION,
            "org.scala-lang:scala-library:jar:2.13.8",
            "org.scala-lang:scala-reflect:jar:2.13.8",
            "org.scala-lang:scala-compiler:jar:2.13.8",
        ],
        # bazel run @build_stack_bazel_jacocorunner_maven//:pin
        maven_install_json = "//:build_stack_bazel_jacocorunner_maven_install.json",
        repositories = [
            "https://repo1.maven.org/maven2",
            "https://repo.maven.apache.org/maven2",
        ],
    )
