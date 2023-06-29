import scala.util.{Failure, Success, Try}

abstract class Parser[T]{
  def apply(input: String): Try[Result[T]]
}
case class Result[T](parsedInput: T, unparsedInput: String)

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