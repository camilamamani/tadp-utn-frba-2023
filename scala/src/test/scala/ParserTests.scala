import org.scalatest.matchers.should.Matchers._
import org.scalatest.flatspec._
import scala.util.Success


class ParserTests extends AnyFlatSpec{

  "AnyChar Parser" should " return a succesful result" in {
    AnyChar("pokemon") shouldBe Success(Result('p', "okemon"))
  }
}


