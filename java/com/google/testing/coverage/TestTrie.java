package com.google.testing.coverage;

import org.junit.Assert;
import org.junit.Test;

public class TestTrie {
    @Test
    public void testInsertAndSearch() {
        Trie trie = new Trie();
        trie.insert("apple");
        trie.insert("banana");
        trie.insert("car");

        Assert.assertTrue(trie.search("apple"));
        Assert.assertTrue(trie.search("banana"));
        Assert.assertTrue(trie.search("car"));
        Assert.assertFalse(trie.search("app"));
        Assert.assertFalse(trie.search("carrot"));
    }

    @Test
    public void testStartsWith() {
        Trie trie = new Trie();
        trie.insert("apple");
        trie.insert("banana");
        trie.insert("car");

        Assert.assertTrue(trie.startsWith("app"));
        Assert.assertTrue(trie.startsWith("ban"));
        Assert.assertTrue(trie.startsWith("car"));
        Assert.assertFalse(trie.startsWith("cat"));
        Assert.assertFalse(trie.startsWith("baa"));
    }
}
