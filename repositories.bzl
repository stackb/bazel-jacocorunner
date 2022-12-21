load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file", "http_jar")

def _maybe(repo_rule, name, **kwargs):
    if name not in native.existing_rules():
        repo_rule(name = name, **kwargs)

def repositories():
    apache_maven()
    rules_jvm_external()
    org_jacoco_org_jacoco_agent_0_8_6_org_jacoco_agent_0_8_6_runtime_jar()
    io_bazel_rules_scala()
    com_google_protobuf()
    rules_python()
    zlib()
    rules_scala_jacocorunner()

def lcov_repositories():
    linux_test_project_lcov()
    rules_perl()
    redbean_dev_redbean()

def rules_jvm_external():
    _maybe(
        http_archive,
        name = "rules_jvm_external",
        sha256 = "b17d7388feb9bfa7f2fa09031b32707df529f26c91ab9e5d909eb1676badd9a6",
        strip_prefix = "rules_jvm_external-4.5",
        urls = ["https://github.com/bazelbuild/rules_jvm_external/archive/4.5.zip"],
    )

def org_jacoco_org_jacoco_agent_0_8_6_org_jacoco_agent_0_8_6_runtime_jar():
    # HTTP/2.0 200 OK
    # Content-Length: 291868
    # Content-Type: application/java-archive
    # Etag: "70d661da6d88e2c135243ee40ec564ca"
    # Last-Modified: Tue, 15 Sep 2020 20:34:29 GMT
    # X-Checksum-Md5: 70d661da6d88e2c135243ee40ec564ca
    # X-Checksum-Sha1: dc49f68f604f21737a58cf405623e36183228c46
    # Size: 291868 (292 kB)
    _maybe(
        http_jar,
        name = "org_jacoco_org_jacoco_agent_0_8_6_org_jacoco_agent_0_8_6_runtime_jar",
        sha256 = "7050e4de4063468127b5216b05457493658444994ee018585c97331570d55bf5",
        url = "https://repo1.maven.org/maven2/org/jacoco/org.jacoco.agent/0.8.6/org.jacoco.agent-0.8.6-runtime.jar",
    )

def apache_maven():
    _maybe(
        http_archive,
        name = "apache_maven",
        build_file_content = """
exports_files(["lib/*.jar", "conf/**/*", "bin/**/*"])
    """,
        sha256 = "c7047a48deb626abf26f71ab3643d296db9b1e67f1faa7d988637deac876b5a9",
        strip_prefix = "apache-maven-3.8.6",
        urls = ["https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz"],
    )

def io_bazel_rules_scala():
    # Branch: master
    # Commit: 3e3fdda516f64433762a4de159a0d54077a5dbb7
    # Date: 2022-12-16 12:16:18 +0000 UTC
    # URL: https://github.com/bazelbuild/rules_scala/commit/3e3fdda516f64433762a4de159a0d54077a5dbb7
    #
    # phase_merge_jars: refactor to separate function that merges jars to output (#1403)
    #
    # This is an intermediate step for possible extensions for creating
    # custom outputs.
    # Size: 657708 (658 kB)
    _maybe(
        http_archive,
        name = "io_bazel_rules_scala",
        sha256 = "41723f89675e1655d2f43aad83071c8484d8b1aefed6822f9d13fb545feb125b",
        strip_prefix = "rules_scala-3e3fdda516f64433762a4de159a0d54077a5dbb7",
        urls = ["https://github.com/bazelbuild/rules_scala/archive/3e3fdda516f64433762a4de159a0d54077a5dbb7.tar.gz"],
    )

def com_google_protobuf():
    _maybe(
        http_archive,
        name = "com_google_protobuf",
        sha256 = "c6003e1d2e7fefa78a3039f19f383b4f3a61e81be8c19356f85b6461998ad3db",
        strip_prefix = "protobuf-3.17.3",
        urls = ["https://github.com/protocolbuffers/protobuf/archive/v3.17.3.tar.gz"],
    )

def rules_python():
    _maybe(
        http_archive,
        name = "rules_python",
        sha256 = "a868059c8c6dd6ad45a205cca04084c652cfe1852e6df2d5aca036f6e5438380",
        strip_prefix = "rules_python-0.14.0",
        url = "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.14.0.tar.gz",
    )

def zlib():
    _maybe(
        http_archive,
        name = "zlib",
        build_file = "@com_google_protobuf//:third_party/zlib.BUILD",
        sha256 = "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1",
        strip_prefix = "zlib-1.2.11",
        urls = [
            "https://mirror.bazel.build/zlib.net/zlib-1.2.11.tar.gz",
            "https://zlib.net/zlib-1.2.11.tar.gz",
        ],
    )

def linux_test_project_lcov():
    _maybe(
        http_archive,
        name = "linux_test_project_lcov",
        sha256 = "02eece2802697c079ff51ce056b0a6691020f21082c46ccfe6604bbfd06d7937",
        strip_prefix = "lcov-1.16/bin",
        url = "https://github.com/linux-test-project/lcov/archive/refs/tags/v1.16.tar.gz",
        build_file_content = """
load("@rules_perl//perl:perl.bzl", "perl_binary")

perl_binary(
    name = "genhtml_bin",
    srcs = ["genhtml"],
    data = ["get_version.sh"],
    visibility = ["//visibility:public"],
)
""",
    )

def rules_perl():
    # Commit: 0947461daa8c42a600878251ab243accc4762e0b
    # Date: 2022-12-18 04:56:28 +0000 UTC
    # URL: https://github.com/pcj/rules_perl/commit/0947461daa8c42a600878251ab243accc4762e0b
    #
    # fix darwin toolchain - try 1
    # Size: 34710 (35 kB)
    _maybe(
        http_archive,
        name = "rules_perl",
        sha256 = "3c5e4715fc07a7dc582bb2b1c24a1d70e4652e8aa81aa01e7ebdc25f243845fe",
        strip_prefix = "rules_perl-0947461daa8c42a600878251ab243accc4762e0b",
        urls = ["https://github.com/pcj/rules_perl/archive/0947461daa8c42a600878251ab243accc4762e0b.tar.gz"],
    )

def redbean_dev_redbean():
    # HTTP/1.1 200 OK
    # Last-Modified: Wed, 02 Nov 2022 16:41:11 GMT
    # Server: redbean/2.2.0
    # Size: 2314466 (2.3 MB)
    _maybe(
        http_file,
        name = "redbean_dev_redbean",
        sha256 = "db8fc7cc5a7703b7ccb830a366eb69e728fc7892fd3ecc093c089d837aa5b91b",
        urls = ["https://redbean.dev/redbean-2.2.com"],
    )

def rules_scala_jacocorunner():
    # _maybe(
    #     http_archive,
    #     name = "rules_scala_jacocorunner",
    #     sha256 = "b34effe1771c47c0c78408d2001c4ab96e91b8054ae02cd5f0f18de50721c4e1",
    #     urls = ["https://github.com/stackb/rules_scala_coverage/files/10273204/jacococoverage.v0.0.6.zip"],
    #     build_file_content = """filegroup(name = "jar", srcs = ["jacococoverage.v0.0.6.jar"], visibility = ["//visibility:public"])""",
    # )

    http_archive(
        name = "rules_scala_jacocorunner",
        sha256 = "a7ddf6a65f1a4964254bfffd210fa1e44159efebf8df3c1193065615bea9b296",
        urls = ["https://github.com/stackb/rules_scala_coverage/files/10273262/jacococoverage-experiment.zip"],
        build_file_content = """filegroup(name = "jar", srcs = ["bazel-bin/java/com/google/testing/coverage/JacocoCoverage_jarjar_deploy.jar"], visibility = ["//visibility:public"])""",
    )
