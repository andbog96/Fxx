import NonEmpty

enum Keyword: NonEmptyString {
    case quote
    case setq
    case `func`
    case lambda
    case prog
    case cond
    case `while`
    case `return`
    case `break`
}
