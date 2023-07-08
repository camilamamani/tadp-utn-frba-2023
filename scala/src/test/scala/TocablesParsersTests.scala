import org.scalatest.TryValues.convertTryToSuccessOrFailure
import org.scalatest.matchers.should.Matchers._
import org.scalatest.flatspec._
import scala.util.Success
import Musica._

class TocablesParsersTests extends AnyFlatSpec{

  "silencio Parser parsea un silencio de Blanca" should "parsear correctamente" in {
    silencio("_") shouldBe Success(Result(Silencio(Blanca), ""))
  }
  "silencio Parser parsea un silencio de Negra" should "parsear correctamente" in {
    silencio("-") shouldBe Success(Result(Silencio(Negra), ""))
  }
  "silencio Parser parsea un silencio de Corchea" should "parsear correctamente" in {
    silencio("~") shouldBe Success(Result(Silencio(Corchea), ""))
  }
  "silencio Parser" should "falla correctamente cuando recibe cualquier input" in {
    silencio("**").failure.exception shouldBe a[CharMismatchException]
  }
  "silencio Parser" should "falla correctamente cuando recibe cadena vacia" in {
    silencio("").failure.exception shouldBe a[EmptyInputStringException]
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
  "sonido Parser 6Z#1/1" should " parsear correctamente" in {
    parserSonido("6Z#1/1").failure.exception shouldBe a[MapException]
  }
}