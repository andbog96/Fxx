extension Parser {
    init(output: Output) {
        self.init { rest in
            (output: output, rest: rest)
        }
    }

    func flatMap<T>(_ transform: @escaping (Output) -> Parser<T>) -> Parser<T> {
        Parser<T> { input in
            parse(input).flatMap { output, rest in
                transform(output).parse(rest)
            }
        }
    }

    func map<T>(_ transform: @escaping (Output) -> T) -> Parser<T> {
        flatMap(compose(Parser<T>.init(output:), transform))
    }
}
