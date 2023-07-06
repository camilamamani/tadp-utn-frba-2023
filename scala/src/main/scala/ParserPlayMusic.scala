import Musica._
object ParserPlayMusic extends App {
  // Si solo hubiese una forma de escribir
  // "4F1/8 4A1/8 4B1/2 4F1/8 4A1/8 4B1/2 4F1/8 4A1/8 4B1/4 5Cs1/8 5Ds1/4 5C1/4"

  val melodiaDeEjemplo = List(
    Sonido(Tono(4, F), Corchea),
    Sonido(Tono(4, A), Corchea),
    Sonido(Tono(4, B), Negra),
    Sonido(Tono(4, F), Corchea),
    Sonido(Tono(4, A), Corchea),
    Sonido(Tono(4, B), Blanca),
    Sonido(Tono(4, F), Corchea),
    Sonido(Tono(4, A), Corchea),
    Sonido(Tono(4, B), Negra),
    Sonido(Tono(5, C.sostenido), SemiCorchea),
    Sonido(Tono(5, D.sostenido), Negra),
    Sonido(Tono(5, C), Blanca),
  )

  AudioPlayer.reproducir(melodiaDeEjemplo)
}

