import org.scalatest.TryValues.convertTryToSuccessOrFailure
import org.scalatest.matchers.should.Matchers._
import org.scalatest.flatspec._
import scala.util.Success

class CombinatorsTests extends AnyFlatSpec{

  "<|> Combinator" should " return a succesful result" in {
    val charA = new char('a')
    val charB = new char('b')
    (charA <|> charB)("argentina") shouldBe Success(Result('a', "rgentina"))
  }

}


