import org.scalatest.TryValues.convertTryToSuccessOrFailure
import org.scalatest.matchers.should.Matchers._
import org.scalatest.flatspec._
import scala.util.Success
import Musica._

class TocablesParsersTests extends AnyFlatSpec{

  "silencio Parser parsea un silencio de Blanca" should "parsear correctamente" in {
    parserSilencio("_") shouldBe Success(Result(Silencio(Blanca), ""))
  }
  "silencio Parser parsea un silencio de Negra" should "parsear correctamente" in {
    parserSilencio("-") shouldBe Success(Result(Silencio(Negra), ""))
  }
  "silencio Parser parsea un silencio de Corchea" should "parsear correctamente" in {
    parserSilencio("~") shouldBe Success(Result(Silencio(Corchea), ""))
  }
  "silencio Parser" should "falla correctamente cuando recibe cualquier input" in {
    parserSilencio("**").failure.exception shouldBe a[CharMismatchException]
  }
  "silencio Parser" should "falla correctamente cuando recibe cadena vacia" in {
    parserSilencio("").failure.exception shouldBe a[EmptyInputStringException]
  }

  "nota Parser C" should " parsear correctamente" in {
    parserNota("C") shouldBe Success(Result(C, ""))
  }
  "nota Parser Cs" should " parsear correctamente" in {
    parserNota("Cs") shouldBe Success(Result(Cs, ""))
  }
  "nota Parser B#" should " parsear correctamente" in {
    parserNota("B#") shouldBe Success(Result(As, ""))
  }
  "nota Parser Bs" should " parsear correctamente" in {
    parserNota("Bs") shouldBe Success(Result(C, ""))
  }

  "tono Parser 4C" should " parsear correctamente" in {
    parserTono("4C") shouldBe Success(Result(Tono(4,C), ""))
  }
  "tono Parser Cs" should " parsear correctamente" in {
    parserTono("5Cs") shouldBe Success(Result(Tono(5, Cs), ""))
  }
  "tono Parser B#" should " parsear correctamente" in {
    parserTono("4B#") shouldBe Success(Result(Tono(4, As), ""))
  }
  "tono Parser Bs" should " parsear correctamente" in {
    parserTono("5Bs") shouldBe Success(Result(Tono(5,C), ""))
  }

  "figura Parser redonda" should " parsear correctamente" in {
    parserFigura("1/1") shouldBe Success(Result(Redonda, ""))
  }
  "figura Parser semiCorchea" should " parsear correctamente" in {
    parserFigura("1/16") shouldBe Success(Result(SemiCorchea, ""))
  }

  "sonido Parser 4C1/1" should " parsear correctamente" in {
    parserSonido("4C1/1") shouldBe Success(Result(Sonido(Tono(4,C),Redonda), ""))
  }
  "sonido Parser 6A#1/4" should " parsear correctamente" in {
    parserSonido("6A#1/4") shouldBe Success(Result(Sonido(Tono(6, Gs), Negra), ""))
  }
  "sonido Parser 6Z#1/1" should " fallar" in {
    parserSonido("6Z#1/1").failure.exception shouldBe a[MapException]
  }
  "acorde Parser 6AM1/2" should " parsear correctamente" in {
    parserAcorde("6AM1/2") shouldBe Success(Result(Acorde(List(Tono(6,A), Tono(6,Cs), Tono(6,E)), Blanca), ""))
  }
  "acorde Parser 6A+6C+4A+5F+4G1/2" should " parsear correctamente" in {
    parserAcorde("6A+6C+4A+5F+4G1/2") shouldBe Success(Result(Acorde(List(Tono(6, A), Tono(6, C), Tono(4,A), Tono(5,F), Tono(4,G)),Blanca), ""))
  }

  "melodia Parser cancion de Saria" should " parsear correctamente" in {
    parserMelodia("4F1/8 4A1/8 4B1/2 4F1/8 4A1/8 4B1/2 4F1/8 4A1/8 4B1/4 5Cs1/8 5Ds1/4 5C1/4") shouldBe
      Success(Result(List(Sonido(Tono(4,F),Corchea), Sonido(Tono(4,A),Corchea), Sonido(Tono(4,B),Blanca),
        Sonido(Tono(4,F),Corchea), Sonido(Tono(4,A),Corchea), Sonido(Tono(4,B),Blanca), Sonido(Tono(4,F),Corchea),
        Sonido(Tono(4,A),Corchea), Sonido(Tono(4,B),Negra), Sonido(Tono(5,Cs),Corchea), Sonido(Tono(5,Ds),Negra),
        Sonido(Tono(5,C),Negra)), ""))
  }
  "melodia Parser Feliz cumpleaños" should " parsear correctamente" in {
    parserMelodia("4C1/4 4C1/4 4D1/2 4C1/4 4F1/2 4E1/2 4C1/8 4C1/4 4D1/2 4C1/2 4G1/2 4F1/2 4C1/8 4C1/4 5C1/2 4A1/2 4F1/8 4F1/4 4E1/2 4D1/2") shouldBe
      Success(Result(List(Sonido(Tono(4,C),Negra), Sonido(Tono(4,C),Negra), Sonido(Tono(4,D),Blanca), Sonido(Tono(4,C),Negra),
        Sonido(Tono(4,F),Blanca), Sonido(Tono(4,E),Blanca), Sonido(Tono(4,C),Corchea), Sonido(Tono(4,C),Negra), Sonido(Tono(4,D),Blanca),
        Sonido(Tono(4,C),Blanca), Sonido(Tono(4,G),Blanca), Sonido(Tono(4,F),Blanca), Sonido(Tono(4,C),Corchea), Sonido(Tono(4,C),Negra),
        Sonido(Tono(5,C),Blanca), Sonido(Tono(4,A),Blanca), Sonido(Tono(4,F),Corchea), Sonido(Tono(4,F),Negra), Sonido(Tono(4,E),Blanca),
        Sonido(Tono(4,D),Blanca)), ""))
  }
}