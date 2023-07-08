import Musica.{A, B, F, Negra, _}
object ParserPlayMusic extends App {
  // Si solo hubiese una forma de escribir
  // "4F1/8 4A1/8 4B1/2 4F1/8 4A1/8 4B1/2 4F1/8 4A1/8 4B1/4 5Cs1/8 5Ds1/4 5C1/4"

  val melodiaDeEjemplo = List(Sonido(Tono(4,C),Negra), Sonido(Tono(4,C),Negra), Sonido(Tono(4,D),Blanca), Sonido(Tono(4,C),Negra), Sonido(Tono(4,F),Blanca), Sonido(Tono(4,E),Blanca), Sonido(Tono(4,C),Corchea), Sonido(Tono(4,C),Negra), Sonido(Tono(4,D),Blanca), Sonido(Tono(4,C),Blanca), Sonido(Tono(4,G),Blanca), Sonido(Tono(4,F),Blanca), Sonido(Tono(4,C),Corchea), Sonido(Tono(4,C),Negra), Sonido(Tono(5,C),Blanca), Sonido(Tono(4,A),Blanca), Sonido(Tono(4,F),Corchea), Sonido(Tono(4,F),Negra), Sonido(Tono(4,E),Blanca), Sonido(Tono(4,D),Blanca))

  AudioPlayer.reproducir(melodiaDeEjemplo)
}

