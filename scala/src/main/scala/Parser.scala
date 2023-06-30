import scala.Array.copy
import scala.collection.mutable.ListBuffer
import scala.util.{Failure, Success, Try}

abstract class Parser[T]{
  def apply(input: String): Try[Result[T]]
  def <|> (oneParser: Parser[T]): Parser[T] = {
    (input: String) => this.apply(input) match {
      case Success(Result(head, tail)) => Success(Result(head, tail))
      case Failure(_) => oneParser.apply(input)
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

  def ~>(oneParser: Parser[T]): Parser[T] = {
    ???
  }

  def <~(oneParser: Parser[T]): Parser[T] = {
    ???
  }

  def satisfies(function: T => Boolean): Parser[T] = {
    (input:String) => this.apply(input) match {
        case Success(Result(parsedInput, tail)) if function(parsedInput) => Success(Result(parsedInput, tail))
        case Success(Result(_, _)) => Failure(new SatisfiesException)
        case Failure(_) => Failure(new SatisfiesException)
    }
  }

  def opt(): Parser[Option[T]] = {
    (input: String) => this.apply(input) match {
        case Success(Result(parsed, tail)) => Success(Result(Some(parsed), tail))
        case Failure(_) => Success(Result(None, input))
      }
  }
  def *(): Parser[List[T]] = {
    (input: String) => {
      Try{parseNtimes(input)}
    }
  }
  private def parseNtimes(input:String): Result[List[T]] = {
    val result = this.apply(input) match {
      case Success(Result(parsed, tail) ) => val Result(newParsed, newTail) = parseNtimes(tail)
        (parsed :: newParsed, newTail)
      case Failure (_) => (List(), input)
    }
    Result(result._1, result._2)
  }

  /*
  la clausura de Kleene se aplica a un parser, convirtiéndolo en otro que se puede aplicar todas
  las veces que sea posible o 0 veces. El resultado debería ser una lista que contiene todos los
  valores que hayan sido parseados (podría no haber ninguno).
  * */



}
case class Result[T](parsedInput: T, unparsedInput: String)