import scala.util.{Failure, Success, Try}
case object AnyChar extends Parser[Char] {
  def apply(input: String): Try[Result[Char]] = input.toList match {
    case List() => Failure(new EmptyInputStringException)
    case head :: tail => Success(Result(head, tail.mkString("")))
  }
}

case class char(expectedChar: Char) extends Parser[Char]{
  def apply(input: String): Try[Result[Char]] = input.toList match {
    case List() => Failure(new EmptyInputStringException)
    case head :: _ if head != expectedChar => Failure(new CharMismatchException)
    case head :: tail if head == expectedChar => Success(Result(head, tail.mkString("")))
  }
}

case object void extends Parser[Unit] {
  def apply(input: String): Try[Result[Unit]] = input.toList match {
    case List() => Failure(new EmptyInputStringException)
    case _ :: tail => Success(Result((), tail.mkString("")))
  }
}
