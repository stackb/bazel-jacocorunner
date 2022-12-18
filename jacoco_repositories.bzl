load("//:jacoco_http_archive.bzl", "jacoco_http_archive")

def _maybe(repo_rule, name, **kwargs):
    if name not in native.existing_rules():
        repo_rule(name = name, **kwargs)

def jacoco_repositories():
    com_github_gergelyfabian_jacoco()

def com_github_gergelyfabian_jacoco():
    # Commit: 2974b221b7f2882cf95510abd81344f93c43e54b
    # Date: 2022-06-01 03:10:09 +0000 UTC
    # URL: https://github.com/gergelyfabian/jacoco/commit/2974b221b7f2882cf95510abd81344f93c43e54b
    #
    # Filter out macros for com.typesafe.scalalogging
    # Size: 648770 (649 kB)
    _maybe(
        jacoco_http_archive,
        name = "com_github_gergelyfabian_jacoco",
        patch_args = ["-p1"],
        patches = ["//third_party/jacoco:min-distribution-size.patch"],
        sha256 = "98dc417be46a60df250eb8e497267f661577af4f4b2408eb0f2a40806b4798b8",
        strip_prefix = "jacoco-2974b221b7f2882cf95510abd81344f93c43e54b",
        urls = ["https://github.com/gergelyfabian/jacoco/archive/2974b221b7f2882cf95510abd81344f93c43e54b.tar.gz"],
    )
