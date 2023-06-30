import scala.util.{Failure, Success, Try}

abstract class Parser[T]{
  def apply(input: String): Try[Result[T]]
  def <|> (oneParser: Parser[T]): Parser[T] = {
    (input: String) => {
      this.apply(input) match {
        case Success(Result(head, tail)) => Success(Result(head, tail))
        case Failure(_) => oneParser.apply(input)
      }
    }
  }
}
case class Result[T](parsedInput: T, unparsedInput: String)