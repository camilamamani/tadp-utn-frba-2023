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
    silencio("**").failure.exception shouldBe a[NotSilencioException]
  }
  "silencio Parser" should "falla correctamente cuando recibe cadena vacia" in {
    silencio("").failure.exception shouldBe a[EmptyInputStringException]
  }

}