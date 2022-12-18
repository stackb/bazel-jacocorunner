load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_jar")

def _maybe(repo_rule, name, **kwargs):
    if name not in native.existing_rules():
        repo_rule(name = name, **kwargs)

def repositories():
    pass

    apache_maven()
    rules_jvm_external()
    org_jacoco_org_jacoco_agent_0_8_6_org_jacoco_agent_0_8_6_runtime_jar()

def rules_jvm_external():
    _maybe(
        http_archive,
        name = "rules_jvm_external",
        sha256 = "b17d7388feb9bfa7f2fa09031b32707df529f26c91ab9e5d909eb1676badd9a6",
        strip_prefix = "rules_jvm_external-4.5",
        urls = [
            "https://github.com/bazelbuild/rules_jvm_external/archive/4.5.zip",
        ],
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
