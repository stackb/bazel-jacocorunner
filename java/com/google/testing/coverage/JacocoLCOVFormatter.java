// Copyright 2016 The Bazel Authors. All Rights Reserved.
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

import com.google.common.collect.ImmutableSet;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.TreeMap;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.jacoco.core.analysis.IBundleCoverage;
import org.jacoco.core.analysis.IClassCoverage;
import org.jacoco.core.analysis.ICounter;
import org.jacoco.core.analysis.IMethodCoverage;
import org.jacoco.core.analysis.IPackageCoverage;
import org.jacoco.core.analysis.ISourceFileCoverage;
import org.jacoco.core.data.ExecutionData;
import org.jacoco.core.data.SessionInfo;
import org.jacoco.report.IReportGroupVisitor;
import org.jacoco.report.IReportVisitor;
import org.jacoco.report.ISourceFileLocator;

/**
 * Simple lcov formatter to be used with lcov_merger.par.
 *
 * <p>
 * The lcov format is documented here:
 * http://ltp.sourceforge.net/coverage/lcov/geninfo.1.php
 */
public class JacocoLCOVFormatter {
  private static final Logger logger = Logger.getLogger(JacocoLCOVFormatter.class.getName());

  // Exec paths of the uninstrumented files that are being analyzed. This is
  // helpful for files in
  // jars passed through java_import or some custom rule where blaze doesn't have
  // enough context to
  // compute the right paths, but relies on these pre-computed exec paths.
  // Exec paths can be provided in two formats, either as a plain string or as a
  // delimited
  // string mapping source file paths to class paths. Coverage entries whose
  // class-paths are not the
  // suffix of any file in this list are discarded. If not provided (as is
  // the case when class is initialized with the zero-argument constructor), the
  // entries are
  // returned unchanged (but note this may result in LCOV output which do not
  // reference actual
  // file-paths).
  private final Optional<ImmutableSet<String>> execPathsOfUninstrumentedFiles;

  private static final String EXEC_PATH_DELIMITER = "///";

  public JacocoLCOVFormatter(ImmutableSet<String> execPathsOfUninstrumentedFiles) {
    this.execPathsOfUninstrumentedFiles = Optional.of(execPathsOfUninstrumentedFiles);
  }

  public JacocoLCOVFormatter() {
    this.execPathsOfUninstrumentedFiles = Optional.empty();
  }

  public IReportVisitor createVisitor(
      PrintWriter output, final Map<String, BranchCoverageDetail> branchCoverageDetail) {
    return new IReportVisitor() {

      private Map<String, Map<String, IClassCoverage>> sourceToClassCoverage = new TreeMap<>();
      private Map<String, ISourceFileCoverage> sourceToFileCoverage = new TreeMap<>();

      private String getExecPathForEntryName(String pkgName, String fileName) {

        final String classPath = pkgName + "/" + fileName;
        if (execPathsOfUninstrumentedFiles.isEmpty()) {
          return classPath;
        }

        String matchingFileName = classPath.startsWith("/") ? classPath : "/" + classPath;

        for (final String execPath : execPathsOfUninstrumentedFiles.get()) {

          if (execPath.contains(EXEC_PATH_DELIMITER)) {
            String[] parts = execPath.split(EXEC_PATH_DELIMITER, 2);
            if (parts.length != 2) {
              continue;
            }
            final boolean matched = parts[1].equals(matchingFileName);
            if (matched) {
              return parts[0];
            }
          } else if (execPath.endsWith(matchingFileName)) {
            return execPath;
          } else if (matchingFileName.equals("/" + execPath)) {
            return execPath;
          } else {
            final String baseName = Path.of(execPath).getFileName().toString();
            if (baseName.equals(fileName) && execPath.contains(pkgName)) {
              return execPath;
            }
          }
        }

        return null;
      }

      @Override
      public void visitInfo(List<SessionInfo> sessionInfos, Collection<ExecutionData> executionData)
          throws IOException {
      }

      @Override
      public void visitEnd() throws IOException {
        for (String sourceFile : sourceToClassCoverage.keySet()) {
          processSourceFile(output, sourceFile);
        }
      }

      @Override
      public void visitBundle(IBundleCoverage bundle, ISourceFileLocator locator)
          throws IOException {
        // Jacoco's API is geared towards HTML/XML reports which have a hierarchical
        // nature. The
        // following loop would call the report generators for packages, classes,
        // methods, and
        // finally link the source view (which would be generated by walking the actual
        // source file
        // and annotating the coverage data). For lcov, we don't really need the source
        // file, but
        // we need to output FN/FNDA pairs with method coverage, which means we need to
        // index this
        // information and process everything at the end.
        for (IPackageCoverage pkgCoverage : bundle.getPackages()) {
          for (IClassCoverage clsCoverage : pkgCoverage.getClasses()) {
            String fileName = getExecPathForEntryName(
                clsCoverage.getPackageName(),
                clsCoverage.getSourceFileName());
            // clsCoverage.getPackageName() + "/" + clsCoverage.getSourceFileName());
            if (fileName == null) {
              continue;
            }
            if (!sourceToClassCoverage.containsKey(fileName)) {
              sourceToClassCoverage.put(fileName, new TreeMap<String, IClassCoverage>());
            }
            sourceToClassCoverage.get(fileName).put(clsCoverage.getName(), clsCoverage);
          }
          for (ISourceFileCoverage srcCoverage : pkgCoverage.getSourceFiles()) {
            String sourceName = getExecPathForEntryName(srcCoverage.getPackageName(), srcCoverage.getName());
            if (sourceName != null) {
              sourceToFileCoverage.put(sourceName, srcCoverage);
            }
          }
        }
      }

      @Override
      public IReportGroupVisitor visitGroup(String name) throws IOException {
        return null;
      }

      private void processSourceFile(PrintWriter writer, String sourceFile) {
        writer.printf("SF:%s\n", sourceFile);

        ISourceFileCoverage srcCoverage = sourceToFileCoverage.get(sourceFile);
        if (srcCoverage != null) {
          // List methods, including methods from nested classes, in FN/FNDA pairs
          for (IClassCoverage clsCoverage : sourceToClassCoverage.get(sourceFile).values()) {
            for (IMethodCoverage mthCoverage : clsCoverage.getMethods()) {
              String name = constructFunctionName(mthCoverage, clsCoverage.getName());
              writer.printf("FN:%d,%s\n", mthCoverage.getFirstLine(), name);
              writer.printf("FNDA:%d,%s\n", mthCoverage.getMethodCounter().getCoveredCount(), name);
            }
          }

          // List branches
          for (IClassCoverage clsCoverage : sourceToClassCoverage.get(sourceFile).values()) {
            BranchCoverageDetail detail = branchCoverageDetail.get(clsCoverage.getName());
            if (detail != null) {
              for (int line : detail.linesWithBranches()) {
                int numBranches = detail.getBranches(line);
                boolean executed = detail.getExecutedBit(line);
                if (executed) {
                  for (int branchIdx = 0; branchIdx < numBranches; branchIdx++) {
                    // We haven't got execution counts for branches; just record if they were hit or
                    // not.
                    if (detail.getTakenBit(line, branchIdx)) {
                      writer.printf("BRDA:%d,%d,%d,%d\n", line, 0, branchIdx, 1); // executed, taken
                    } else {
                      writer.printf(
                          "BRDA:%d,%d,%d,%d\n", line, 0, branchIdx, 0); // executed, not taken
                    }
                  }
                } else {
                  for (int branchIdx = 0; branchIdx < numBranches; branchIdx++) {
                    writer.printf("BRDA:%d,%d,%d,%s\n", line, 0, branchIdx, "-"); // not executed
                  }
                }
              }
            }
          }

          // List of DA entries matching source lines
          int firstLine = srcCoverage.getFirstLine();
          int lastLine = srcCoverage.getLastLine();
          for (int line = firstLine; line <= lastLine; line++) {
            ICounter instructionCounter = srcCoverage.getLine(line).getInstructionCounter();
            if (instructionCounter.getTotalCount() != 0) {
              // All we can do is say if a line was hit, we do not have execution counts.
              int execCount = instructionCounter.getCoveredCount() > 0 ? 1 : 0;
              writer.printf("DA:%d,%d\n", line, execCount);
            }
          }
        }
        writer.println("end_of_record");
      }

      private String constructFunctionName(IMethodCoverage mthCoverage, String clsName) {
        // The lcov spec doesn't of course cover Java formats, so we output the method
        // signature.
        // lcov_merger doesn't seem to care about these entries.
        return clsName + "::" + mthCoverage.getName() + " " + mthCoverage.getDesc();
      }
    };
  }
}
