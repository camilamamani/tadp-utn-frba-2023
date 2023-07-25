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

  "digit Parser" should " return a succesful result" in {
    digit("1010") shouldBe Success(Result('1', "010"))
  }

  "digit Parser" should " return a failure result" in {
    digit("weezing").failure.exception shouldBe a[NotDigitException]
  }

  "alphaNum Parser" should " return a succesful result when head is a digit" in {
    alphaNum("1a1a") shouldBe Success(Result('1', "a1a"))
  }

  "alphaNum Parser" should " return a succesful result when head is a letter" in {
    alphaNum("a1a1") shouldBe Success(Result('a', "1a1"))
  }

  "alphaNum Parser" should " return a failure result when is not a digit nor letter" in {
    alphaNum("----").failure.exception shouldBe a[NotAlphaNumException]
  }

  "string Parser" should " return a succesful result" in {
    val stringParser = new string("Ash")
    stringParser("Ash Ketchum") shouldBe Success(Result("Ash", " Ketchum"))
  }

  "string Parser" should " return a failure result" in {
    val stringParser = new string("Misty")
    stringParser("Profesor Oak").failure.exception shouldBe a[PrefixMismatchException]
  }

}


