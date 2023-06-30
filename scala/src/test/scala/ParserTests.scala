import org.scalatest.TryValues.convertTryToSuccessOrFailure
import org.scalatest.matchers.should.Matchers._
import org.scalatest.flatspec._

import scala.util.Success


class ParserTests extends AnyFlatSpec{

  "AnyChar Parser" should " return a succesful result when a non empty string is parsed" in {
    AnyChar("pokemon") shouldBe Success(Result('p', "okemon"))
  }

  "AnyChar Parser" should " return a failure result when an empty string is parsed" in {
    AnyChar("").failure.exception shouldBe a[EmptyInputStringException]
  }

  "char Parser" should " return a succesful result when a string starts with the expected char" in {
    val charParser = new char('c')
    charParser("charmander") shouldBe Success(Result('c', "harmander"))
  }

  "char Parser" should " return a succesful result when an empty string is parsed" in {
    val charParser = new char('c')
    charParser("").failure.exception shouldBe a[EmptyInputStringException]
  }

  "char Parser" should " return a failure result when a string doesn't start with the expected char" in {
    val charParser = new char('c')
    charParser("pikachu").failure.exception shouldBe a[CharMismatchException]
  }

  "void Parser" should " return a succesful result when a non empty string is parsed" in {
    void("psyduck") shouldBe Success(Result((), "syduck"))
  }

  "void Parser" should " return a failure result" in {
    void("").failure.exception shouldBe a[EmptyInputStringException]
  }

  "letter Parser" should " return a succesful result when a string contains only letters" in {
    letter("vulpix") shouldBe Success(Result('v', "ulpix"))
  }

  "letter Parser" should " return a failure result when a string contains at least one non letter char " in {
    letter("1010").failure.exception shouldBe a[NotLetterException]
  }

  "digit Parser" should " return a succesful result wher a string contains only digits" in {
    digit("1010") shouldBe Success(Result('1', "010"))
  }

  "digit Parser" should " return a failure result when a string contains at least one non digit char"  in {
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

  "string Parser" should " return a succesful result when the string contains expected string argument " in {
    val stringParser = new string("Ash")
    stringParser("Ash Ketchum") shouldBe Success(Result("Ash", " Ketchum"))
  }

  "string Parser" should " return a failure result when the string doesn't contain the expdcted string" in {
    val stringParser = new string("Misty")
    stringParser("Profesor Oak").failure.exception shouldBe a[PrefixMismatchException]
  }

/*  "Parser Combinator <|> " should "return success with 'a' when combinates char('a') <|> char('b') of 'arbol'" in {
    val newParser = char('a').<|> (char('b'))
    newParser("arbol")

  }*/



}


