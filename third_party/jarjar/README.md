# jarjar

The bazel rule `genrule rule
//src/java_tools/junitrunner/java/com/google/testing/coverage:Jacoco_jarjar`
requires jarjar for building the final jar.  I'm not sure why renaming classes
within the coverage jar is needed, but preserving it.

Unfortunately jarjar is not exposed in `@bazel_tools` and I'd rather not take on
additional dependencies to build it from source here.  Instead, the deploy jar
is vendored here.

To rebuild, check out the bazel source and `bazel build
//third_party/jarjar:jarjar_command_deploy.jar`, then replace the artifact here
with the appropriately named bazel tag version that it was built from.

Other option would be to use github.com/johnynek/bazel_jar_jar.