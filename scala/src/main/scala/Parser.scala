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
  def <>[S](oneParser: Parser[S]): Parser[(T, S)] = {
    (input: String) => this.apply(input) match {
      case Success(Result(consumed1, tail)) => oneParser.apply(tail) match {
        case Success(Result(consumed2, tail)) => Success(Result((consumed1, consumed2), tail))
        case Failure(_) => Failure(new ConcatCombinatorException)
      }
      case Failure(_) => Failure(new ConcatCombinatorException)
    }
  }
}
case class Result[T](parsedInput: T, unparsedInput: String)