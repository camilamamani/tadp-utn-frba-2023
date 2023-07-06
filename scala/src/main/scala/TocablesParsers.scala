import Musica._
import scala.util.{Failure, Success, Try}
case object silencio extends Parser[Silencio]{
  def apply(input: String): Try[Result[Silencio]] = {
    val silencioBlanca = char('_').const(Silencio(Blanca))
    val silencioNegra = char('-').const(Silencio(Negra))
    val silencioCorchea = char('~').const(Silencio(Corchea))
    (silencioBlanca <|> silencioNegra <|> silencioCorchea)(input)
  }
}