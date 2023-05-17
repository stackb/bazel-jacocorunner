// Copyright 2023 Stack.Build LLC. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package com.google.testing.coverage;

import com.google.common.annotations.VisibleForTesting;
import com.google.common.collect.ImmutableSet;

/**
 * Optional features for the JacocoCoverageRunner.
 */
public class JacocoCoverageFeatures {

    public static final String JACOCO_REMAP_SRC_TEST_PATHS_FEATURE_NAME = "JACOCO_REMAP_SRC_TEST_PATHS";
    private static final String EXEC_PATH_DELIMITER = "///";

    private JacocoCoverageFeatures() {
    }

    /**
     * wantRemapSrcTestPaths returns true if the environment has an entry like
     * "JACOCO_REMAP_SRC_TEST_PATHS=1".
     * 
     * @return true if enabled.
     */
    static boolean wantRemapSrcTestPaths() {
        final String value = System.getenv(JACOCO_REMAP_SRC_TEST_PATHS_FEATURE_NAME);
        final boolean wantFeatureRemapSrcTestPaths = value != null ? !value.equals("0")
                : false;
        return wantFeatureRemapSrcTestPaths;
    }

    /**
     * remapSrcTestPaths takes a path like "path/to/dir/Foo.java" and a
     * delimiter to split on. If the delimiter matches, it is removed form the
     * path and added as a mapping entry.
     * 
     * @see addEntriesToExecPathsSet.
     * 
     * @param path
     * @param delim
     * @param pathsForCoverageBuilder
     */
    @VisibleForTesting
    static void remapSrcTestPaths(
            final String path,
            final String delim,
            final ImmutableSet.Builder<String> pathsForCoverageBuilder) {
        final String[] parts = path.split(delim, 2);
        if (parts.length != 2 || parts[0].isEmpty() || parts[1].isEmpty()) {
            return;
        }
        final String mappedLine = path + EXEC_PATH_DELIMITER + "/" + parts[0] + "/" + parts[1];
        pathsForCoverageBuilder.add(mappedLine);
    }

}
