import scala.util.{Failure, Success, Try}

abstract class Parser[T] {
  def apply(input: String): Try[Result[T]]

/*  def <|>(parser: Parser[T], input: String): Try[Result[T]] = {
    this.apply(input) match {
      case Success(Result(_, _)) => Success(Result(input.head, input.tail))
      case Failure(_) => parser(input) match {
        case Success(Result(_, _)) => Success(Result(input.head, input.tail))
        case Failure(_) => Failure(new Error)
      }
    }
  }*/
}
case class Result[T](parsedInput: T, unparsedInput: String)


