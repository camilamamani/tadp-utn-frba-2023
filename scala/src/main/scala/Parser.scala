import scala.util.{Failure, Success, Try}

abstract class Parser[T]{
  def apply(input: String): Try[Result[T]]
}
case class Result[T](parsedInput: T, unparsedInput: String)