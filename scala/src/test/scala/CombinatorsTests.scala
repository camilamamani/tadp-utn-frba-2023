import org.scalatest.TryValues.convertTryToSuccessOrFailure
import org.scalatest.matchers.should.Matchers._
import org.scalatest.flatspec._
import scala.util.Success

class CombinatorsTests extends AnyFlatSpec{

  "<|> Or Combinator" should " return a successful result with char parsers" in {
    (char('a') <|> char('b'))("argentina") shouldBe Success(Result('a', "rgentina"))
  }

  "<> And Combinator" should " return a successful result with char parsers" in {
    (char('a') <> char('r'))("argentina") shouldBe Success(Result(('a', 'r'), "gentina"))
  }

  "<> And Combinator" should " return a successful result with string parsers" in {
    (string("hello") <> string(" world"))("hello world!") shouldBe Success(Result(("hello", " world"), "!"))
  }

}


