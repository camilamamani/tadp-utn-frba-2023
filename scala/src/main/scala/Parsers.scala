import scala.util.{Failure, Success, Try}
case object AnyChar extends Parser[Char] {
  def apply(input: String): Try[Result[Char]] = input.toList match {
    case List() => Failure(new EmptyInputStringException)
    case head :: tail => Success(Result(head, tail.mkString("")))
  }
}
case class char(charExpected: Char) extends Parser[Char]{
  def apply(input: String): Try[Result[Char]] = AnyChar(input) match {
    case Failure(_) => Failure(new EmptyInputStringException)
    case Success(Result(parsedInput, _)) if parsedInput != charExpected => Failure(new CharMismatchException)
    case Success(Result(parsedInput, unparsedInput)) if parsedInput == charExpected => Success(Result(parsedInput, unparsedInput))
  }
}
case object void extends Parser[Unit] {
  def apply(input: String): Try[Result[Unit]] = AnyChar(input) match {
    case Failure(_) => Failure(new EmptyInputStringException)
    case Success(Result(_, unparsedInput)) => Success(Result((), unparsedInput))
  }
}
case object letter extends Parser[Char]{
  def apply(input: String): Try[Result[Char]] = AnyChar(input) match {
    case Failure(_) => Failure(new EmptyInputStringException)
    case Success(Result(parsedInput, _)) if !parsedInput.isLetter => Failure(new NotLetterException)
    case Success(Result(parsedInput, unparsedInput)) if parsedInput.isLetter => Success(Result(parsedInput, unparsedInput))
  }
}
case object digit extends Parser[Char]{
  def apply(input: String): Try[Result[Char]] = AnyChar(input) match {
    case Failure(_) => Failure(new EmptyInputStringException)
    case Success(Result(parsedInput, _)) if !parsedInput.isDigit => Failure(new NotDigitException)
    case Success(Result(parsedInput, unparsedInput)) if parsedInput.isDigit => Success(Result(parsedInput, unparsedInput))
  }
}
case object alphaNum extends Parser[Char] {
  def apply(input: String): Try[Result[Char]] = letter(input) match {
    case Success(Result(_, _)) => Success(Result(input.head, input.tail))
    case Failure(_) => digit(input) match {
      case Success(Result(_, _)) => Success(Result(input.head, input.tail))
      case Failure(_) => Failure(new NotAlphaNumException)
    }
  }
}
case class string(stringExpected: String) extends Parser[String]{
  def apply(input: String): Try[Result[String]] = input.startsWith(stringExpected) match {
    case true => Success(Result(stringExpected, input.stripPrefix(stringExpected)))
    case false => Failure(new PrefixMismatchException)
  }
}