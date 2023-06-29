import scala.util.{Failure, Success, Try}
case object AnyChar extends Parser[Char] {
  def apply(input: String): Try[Result[Char]] = input.toList match {
    case List() => Failure(new EmptyInputStringException)
    case head :: tail => Success(Result(head, tail.mkString("")))
  }
}
case class char(charExpected: Char) extends Parser[Char]{
  def apply(input: String): Try[Result[Char]] = input.toList match {
    case List() => Failure(new EmptyInputStringException)
    case head :: _ if head != charExpected => Failure(new CharMismatchException)
    case head :: tail if head == charExpected => Success(Result(head, tail.mkString("")))
  }
}
case object void extends Parser[Unit] {
  def apply(input: String): Try[Result[Unit]] = input.toList match {
    case List() => Failure(new EmptyInputStringException)
    case _ :: tail => Success(Result((), tail.mkString("")))
  }
}
case object letter extends Parser[Char]{
  def apply(input: String): Try[Result[Char]] = input.toList match {
    case List() => Failure(new EmptyInputStringException)
    case head :: _ if !head.isLetter => Failure(new NotLetterException)
    case head :: tail if head.isLetter => Success(Result(head, tail.mkString("")))
  }
}
case object digit extends Parser[Char]{
  def apply(input: String): Try[Result[Char]] = input.toList match {
    case List() => Failure(new EmptyInputStringException)
    case head :: _ if !head.isDigit => Failure(new NotDigitException)
    case head :: tail if head.isDigit => Success(Result(head, tail.mkString("")))
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
case class string(prefixExpected: String) extends Parser[String]{
  def apply(input: String): Try[Result[String]] = input.startsWith(prefixExpected) match {
    case true => Success(Result(prefixExpected, input.stripPrefix(prefixExpected)))
    case false => Failure(new PrefixMismatchException)
  }
}