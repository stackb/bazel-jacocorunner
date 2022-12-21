# jarjar

The bazel genrule
`//src/java_tools/junitrunner/java/com/google/testing/coverage:Jacoco_jarjar`
uses jarjar for building the final jar (with shading of some dependencies).  I'm
not sure why renaming classes within the coverage jar is needed, but preserving
this behavior regardless.

Unfortunately, `jarjar` is not exposed in `@bazel_tools` and I'd rather not take
on additional dependencies to build it from source.  Instead, the deploy jar is
vendored here.

To rebuild it, check out the bazel source and `bazel build
//third_party/jarjar:jarjar_command_deploy.jar`, then replace the artifact here
with the appropriately named bazel tag version that it was built from.
