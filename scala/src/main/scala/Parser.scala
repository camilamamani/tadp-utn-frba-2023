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

def char(expectedChar: Char)(text: String): Parser[Char] = {
  text.headOption match {
    case Some(actualChar) if actualChar == expectedChar =>
      Success(actualChar)
    case _ =>
      Failure(new Exception(s"Se esperaba el carácter '$expectedChar'"))
  }
}
def void(text: String): Try[Unit] = {
  text.headOption match {
    case Some(_) => Success(())
    case None => Failure(new Exception("El texto está vacío"))
  }
}

def letter(text: String): Parser[Char] = {
  text.headOption match {
    case Some(char) if char.isLetter => Success(char)
    case _ => Failure(new Exception("No se encontró un carácter válido"))
  }
}

def digit(text: String): Parser[Char] = {
  text.headOption match {
    case Some(char) if char.isDigit => Success(char)
    case _ => Failure(new Exception("No se encontró un dígito válido"))
  }
}

def alphaNum(text: String): Parser[Char] = {
  letter(text) match {
    case Success(char) => Success(char)
    case Failure(_) => digit(text) match {
      case Success(char) => Success(char)
      case Failure(_) => Failure(new Exception("No se encontró un carácter alfanumérico válido"))
    }
  }
}
//uso parser aca??? nos conviene normalizar(quitarle espacios al text y al expected)
def string(expected: String, text: String): Try[String] = {
  text.startsWith(expected) match {
    case true => Success(expected)
    case false => Failure(new Exception("No se encontró el string esperado"))
  }
}