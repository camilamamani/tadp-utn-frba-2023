class EmptyInputStringException extends Exception("Input String is empty")
class CharMismatchException extends Exception("The expected char mismatches the head of input string")
class NotLetterException extends Exception("The consumed char is not a letter")
class NotDigitException extends Exception("The consumed char is not a digit")
class NotAlphaNumException extends Exception("The consumed char is not alphanumeric")
class PrefixMismatchException extends Exception("The expected prefix mismatches the head of input string")
class ConcatCombinatorException extends Exception("Concat combinator fails with parsers provided")
class SatisfiesException extends Exception("Satisfies operation fails with parser and condition provided")
class MapException extends Exception("Fails map parser with the parser provided")


