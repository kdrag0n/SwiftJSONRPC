// ----------------------------------------------------------------------------
//
//  ParcelableArrayResultParser.swift
//
//  @author Denis Kolyasev <kolyasev@gmail.com>
//
// ----------------------------------------------------------------------------

class ParcelableArrayResultParser<Element: Parcelable>: ResultParser {

    // MARK: Functions

    func parse(_ object: AnyObject) throws -> Result {
        guard let objects = object as? [[String: AnyObject]] else {
            throw ResultParserError.invalidFormat(object: object)
        }

        return try objects.map { try Element(params: $0) }
    }

    // MARK: - Inner Types

    typealias Result = Array<Element>

}

extension RPCService {

    // MARK: Functions

    open func invoke<Element: Parcelable>(_ method: String, params: Invocation<[Element]>.Params? = nil) async throws -> [Element] {
        return try await invoke(method, params: params, parser: ParcelableArrayResultParser())
    }
}
