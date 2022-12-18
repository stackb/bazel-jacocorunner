package mypackage

import org.scalatest.{FlatSpecLike, Matchers}

class TestSuite extends FlatSpecLike with Matchers {
  it should "succeed" in {
    assert(Foo.message == "hello world")
  }

  it should "work" in {
    assert(Foo.testLambdas(1) == List(10))
    assert(Foo.testLambdas(11) == List(30))
    Foo.main(List("").toArray)
  }
}
