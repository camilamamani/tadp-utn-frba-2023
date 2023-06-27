import scala.util.{Failure, Success, Try}

abstract class Parser[T]{
  def apply(input: String): Try[Result[T]]
}
case class Result[T](parsedInput: T, unparsedInput: String)

case object AnyChar extends Parser[Char] {
  def apply(input: String) = input.toList match {
    case List() => Failure(new EmptyInputStringException)
    case head :: tail => Success(Result(head, tail.mkString("")))
  }
}