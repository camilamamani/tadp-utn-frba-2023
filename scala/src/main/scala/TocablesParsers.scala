import Musica._
import scala.util.{Failure, Success, Try}

case object silencio extends Parser[Silencio]{
  def apply(input: String): Try[Result[Silencio]] = input.toList match {
    case List() => Failure(new EmptyInputStringException)
    case head :: tail if head == '_' => Success(Result(Silencio(Blanca), tail.mkString("")))
    case head :: tail if head == '-' => Success(Result(Silencio(Negra), tail.mkString("")))
    case head :: tail if head == '~' => Success(Result(Silencio(Corchea), tail.mkString("")))
    case _ :: _  => Failure(new NotSilencioException)
  }
}