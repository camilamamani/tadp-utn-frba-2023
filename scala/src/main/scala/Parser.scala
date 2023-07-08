import scala.::
import scala.collection.immutable.Nil.:::
import scala.util.{Failure, Success, Try}

abstract class Parser[+T] {
  def apply(input: String): Try[Result[T]]

  def <|>[R >: T](oneParser: Parser[R]): Parser[R] = {
    (input: String) => {
      this.apply(input) match {
        case Success(Result(head, tail)) => Success(Result(head, tail))
        case Failure(_) => oneParser.apply(input)
      }
    }
  }

  def <>[R >: T, S](oneParser: Parser[S]): Parser[(R, S)] = {
    (input: String) => {
      this.apply(input) match {
        case Success(Result(consumed1, tail)) => oneParser.apply(tail) match {
          case Success(Result(consumed2, tail)) => Success(Result((consumed1, consumed2), tail))
          case Failure(_) => Failure(new ConcatCombinatorException)
        }
        case Failure(_) => Failure(new ConcatCombinatorException)
      }
    }
  }
  def ~>[S](oneParser: Parser[S]): Parser[S] = {
      (this <> oneParser).map(elem => elem._2)
  }

  def <~[S](oneParser: Parser[S]): Parser[T] = {
      (this <> oneParser).map(elem => elem._1)
  }
  def map[S](function: T => S): Parser[S] = {
    (input: String) => this.apply(input) match {
      case Success(Result(parsed, tail)) => Success(Result(function(parsed), tail))
      case Failure(_) => Failure(new MapException)
    }
  }
  def satisfies(function: T => Boolean): Parser[T] = {
    (input: String) =>
      this.apply(input) match {
        case Success(Result(parsedInput, tail)) if function(parsedInput) => Success(Result(parsedInput, tail))
        case Success(Result(_, _)) => Failure(new SatisfiesException)
        case Failure(_) => Failure(new SatisfiesException)
      }
  }
  def opt(): Parser[Option[T]] = {
    (input: String) =>
      this.apply(input) match {
        case Success(Result(parsed, tail)) => Success(Result(Some(parsed), tail))
        case Failure(_) => Success(Result(None, input))
      }
  }
  def *(): Parser[List[T]] = {
    (input: String) => {
      Try {
        parseNtimes(input)
      }
    }
  }
  private def parseNtimes(input: String): Result[List[T]] = {
    val result = this.apply(input) match {
      case Success(Result(parsed, tail)) => val Result(newParsed, newTail) = parseNtimes(tail)
        (parsed :: newParsed, newTail)
      case Failure(_) => (List(), input)
    }
    Result(result._1, result._2)
  }

  def +(): Parser[List[T]] = {
    val funcion: ((T,List[T])) => List[T] = {
      case (x, lista) => (lista :+ x)
    }
    (this <> this.*).map(funcion)
  }
  def sepBy[S](separatorParser: Parser[S]): Parser[List[T]] = {
      val contentParser = this
      (contentParser <> (separatorParser ~> contentParser).*()).map(tuple => tuple._1 :: tuple._2)
  }

  def const[S >: T](constValue: S): Parser[S] = {
    this.map(_ => constValue)
  }
}
case class Result[+T](parsedInput: T, unparsedInput: String)