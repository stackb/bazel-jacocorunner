package mypackage

case class Foo(a: Int, b: String, c: Set[String])

object Foo {
  val message = "hello world"
  val message1 = 1

  def testLambdas(a: Int) = {
    println(message1)
    val foo = Foo(a, message, Set.empty[String])
    foo match {
      case Foo(a, _, _) if a > 10 =>
        println("a is bigger than 10")
      case _ =>
        println("a is not bigger than 10")
    }
    println(foo)
    for {
      a <- List(foo)
      b <- List(2)
      c <- List(3)
      d <- if (foo.a < 10) {
        List(4)
      } else {
        List(14)
      }
    } yield a.a + b + c + d
  }

  def main(args: Array[String]) {
    testLambdas(1)
    testLambdas(11)
  }
}
