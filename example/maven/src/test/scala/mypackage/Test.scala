package mypackage

import org.scalatest.{FlatSpecLike, Matchers}

class TestSuite extends FlatSpecLike with Matchers {
  it should "work" in {
    assert(Maven.message == "hello world")
  }
}
