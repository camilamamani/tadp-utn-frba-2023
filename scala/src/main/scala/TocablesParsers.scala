import Musica._
import scala.util.{Try}
case object silencio extends Parser[Silencio]{
  def apply(input: String): Try[Result[Silencio]] = {
    val silencioBlanca = char('_').const(Silencio(Blanca))
    val silencioNegra = char('-').const(Silencio(Negra))
    val silencioCorchea = char('~').const(Silencio(Corchea))
    (silencioBlanca <|> silencioNegra <|> silencioCorchea).asInstanceOf[Parser[Silencio]](input)
  }
}
case object parserNota extends Parser[Nota] {
  def apply(input:String): Try[Result[Nota]] = {
    val notaC = char('C').const(C)
    val notaD = char('D').const(D)
    val notaE = char('E').const(E)
    val notaF = char('F').const(F)
    val notaG = char('G').const(G)
    val notaA = char('A').const(A)
    val notaB = char('B').const(B)
    val parserNotaLetra = (notaC <|> notaD <|> notaE <|> notaF <|> notaG <|> notaA <|> notaB).asInstanceOf[Parser[Nota]]
    val funcion: ((Nota, Option[Char])) => Nota = {
      case (nota, None) => nota
      case (nota, Some('#')) => nota.bemol
      case (nota, Some('s')) => nota.sostenido
    }
    (parserNotaLetra <> (char('#') <|> char('s')).opt()).map(funcion)(input)
  }
}
case object parserTono extends Parser[Tono] {
  def apply(input:String): Try[Result[Tono]] ={
    val funcion: ((Char, Nota)) => Tono = {
      case ((octava,nota)) => Tono(Character.getNumericValue(octava), nota)
    }
    (digit <> parserNota).map(funcion)(input)
  }
}
case object parserFigura extends Parser[Figura] {
  def apply(input:String): Try[Result[Figura]] ={
    val redonda = string("1/1").const(Redonda)
    val blanca = string("1/2").const(Blanca)
    val negra = string("1/4").const(Negra)
    val corchea = string("1/8").const(Corchea)
    val semiCorchea = string("1/16").const(SemiCorchea)
    (semiCorchea <|> redonda <|> blanca <|> negra <|> corchea).asInstanceOf[Parser[Figura]](input)
  }
}
case object parserSonido extends Parser[Sonido]{
  def apply(input: String): Try[Result[Sonido]] = {
    val funcion: ((Tono, Figura)) => Sonido = {
      case ((tono, figura)) => Sonido(tono, figura)
    }
    (parserTono <> parserFigura).map(funcion)(input)
  }
}