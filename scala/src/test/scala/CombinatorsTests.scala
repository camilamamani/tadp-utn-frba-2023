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

  "satisfies operation added to anychar" should " return a successful result" in {
    val anyCharParserWithCharA = AnyChar.satisfies('a'.==)
    anyCharParserWithCharA("andes") shouldBe Success(Result('a', "ndes"))
  }

  "satisfies operation added to letter" should " return a successful result" in {
    val letterParserNotConsumesCharZ = letter.satisfies('z'.!=)
    letterParserNotConsumesCharZ("andes") shouldBe Success(Result('a', "ndes"))
  }

  "satisfies operation added to digit" should " return a successful result" in {
    val digitParserConsumesNum1 = digit.satisfies('1'.==)
    digitParserConsumesNum1("1B") shouldBe Success(Result('1', "B"))
  }
  "optional operation added to string parser" should " return the expected result" in {
    val talVezIn = string("in").opt
    val precedencia = talVezIn <> string("fija")
    precedencia("fijamente") shouldBe Success(Result((None, "fija"), "mente"))
  }

  "* Kleene operation added to char a parser" should " return the expected result" in {
    val kleeneCharA = char('a').*
    kleeneCharA("aahh!") shouldBe Success(Result(List('a', 'a'), "hh!"))
  }
  "* Kleene operation added to char z parser" should " return the expected result" in {
    val kleeneCharZ = char('z').*
    kleeneCharZ("zzz") shouldBe Success(Result(List('z', 'z', 'z'), ""))
  }
  "* Kleene operation added to char x parser" should " return empty list" in {
    val kleeneCharX = char('x').*
    kleeneCharX("not possible") shouldBe Success(Result(List(), "not possible"))
  }
}


