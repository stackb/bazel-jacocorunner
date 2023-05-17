package com.google.testing.coverage;

import org.junit.Assert;
import org.junit.Test;

import com.google.common.collect.ImmutableSet;

public class TestJacocoCoverageFeatures {
    @Test
    public void testRemapSrcTestPathsEmpty() {
        ImmutableSet.Builder<String> builder = new ImmutableSet.Builder<>();
        JacocoCoverageFeatures.remapSrcTestPaths("", "/src/", builder);
        Assert.assertTrue(builder.build().isEmpty());
    }

    @Test
    public void testRemapSrcTestPathsEmpty2() {
        ImmutableSet.Builder<String> builder = new ImmutableSet.Builder<>();
        JacocoCoverageFeatures.remapSrcTestPaths("/src/", "/src/", builder);
        Assert.assertTrue(builder.build().isEmpty());
    }

    @Test
    public void testRemapSrcTestPathsNoMatch() {
        ImmutableSet.Builder<String> builder = new ImmutableSet.Builder<>();
        JacocoCoverageFeatures.remapSrcTestPaths("a/srcFoo.java", "/src/", builder);
        Assert.assertTrue(builder.build().isEmpty());
    }

    @Test
    public void testRemapSrcTestPathsSrc() {
        ImmutableSet.Builder<String> builder = new ImmutableSet.Builder<>();
        JacocoCoverageFeatures.remapSrcTestPaths("a/src/b/Foo.java", "/src/", builder);
        Assert.assertFalse(builder.build().isEmpty());
        Assert.assertTrue(builder.build().contains("a/src/b/Foo.java////a/b/Foo.java"));
    }

    @Test
    public void testRemapSrcTestPathsTest() {
        ImmutableSet.Builder<String> builder = new ImmutableSet.Builder<>();
        JacocoCoverageFeatures.remapSrcTestPaths("a/test/b/Foo.java", "/test/", builder);
        Assert.assertFalse(builder.build().isEmpty());
        Assert.assertTrue(builder.build().contains("a/test/b/Foo.java////a/b/Foo.java"));
    }
}
