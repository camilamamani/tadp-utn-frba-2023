import org.scalatest.TryValues.convertTryToSuccessOrFailure
import org.scalatest.matchers.should.Matchers._
import org.scalatest.flatspec._

import scala.util.Success


class ParserTests extends AnyFlatSpec{

  "AnyChar Parser" should " return a succesful result" in {
    AnyChar("pokemon") shouldBe Success(Result('p', "okemon"))
  }

  "AnyChar Parser" should " return a failure result" in {
    AnyChar("").failure.exception shouldBe a[EmptyInputStringException]
  }

  "char Parser" should " return a succesful result" in {
    val charParser = new char('c')
    charParser("charmander") shouldBe Success(Result('c', "harmander"))
  }

  "char Parser" should " return a failure result" in {
    val charParser = new char('c')
    charParser("pikachu").failure.exception shouldBe a[CharMismatchException]
  }

  "void Parser" should " return a succesful result" in {
    void("psyduck") shouldBe Success(Result((), "syduck"))
  }

  "void Parser" should " return a failure result" in {
    void("").failure.exception shouldBe a[EmptyInputStringException]
  }

  "letter Parser" should " return a succesful result" in {
    letter("vulpix") shouldBe Success(Result('v', "ulpix"))
  }

  "letter Parser" should " return a failure result" in {
    letter("1010").failure.exception shouldBe a[NotLetterException]
  }

}


