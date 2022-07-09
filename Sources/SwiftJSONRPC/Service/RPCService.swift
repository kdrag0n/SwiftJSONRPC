// ----------------------------------------------------------------------------
//
//  RPCService.swift
//
//  @author Denis Kolyasev <kolyasev@gmail.com>
//
// ----------------------------------------------------------------------------

open class RPCService {

    // MARK: - Private Properties

    private let client: RPCClient

    // MARK: - Initialization

    public init(client: RPCClient) {
        self.client = client
    }

    // MARK: - Public Functions

    open func invoke<Result, Parser: ResultParser>(_ method: String, params: Invocation<Result>.Params? = nil, parser: Parser) async throws -> Result
    where Parser.Result == Result {
        // Init invocation object
        let invocation = makeInvocation(method: method, params: params, parser: parser)

        // Perform invocation
        return try await client.invoke(invocation)
    }

    open func makeInvocation<Result, Parser: ResultParser>(method: String, params: Invocation<Result>.Params?, parser: Parser) -> Invocation<Result>
    where Parser.Result == Result {
        return Invocation<Result>(method: method, params: params, parser: parser)
    }
}
