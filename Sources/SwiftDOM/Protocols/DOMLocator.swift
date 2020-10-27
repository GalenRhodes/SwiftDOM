/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: DOMLocator.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/21/20
 *
 * Copyright © 2020 Galen Rhodes. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *//************************************************************************/

import Foundation

public protocol DOMLocator {
    var byteOffset:   Int { get }
    var lineNumber:   Int { get }
    var columnNumber: Int { get }
    var utf16Offset:  Int { get }
    var uri:          String { get }
    var relatedNode:  Node { get }

    func isEqualTo(_ other: DOMLocator) -> Bool

    func asHashable() -> AnyDOMLocator

    func getHash(into hasher: inout Hasher)
}

@frozen public struct AnyDOMLocator: DOMLocator, Hashable {
    var loc: DOMLocator

    public init(_ loc: DOMLocator) { self.loc = loc }

    public func hash(into hasher: inout Hasher) { loc.getHash(into: &hasher) }

    public static func == (lhs: AnyDOMLocator, rhs: AnyDOMLocator) -> Bool { lhs.loc.isEqualTo(rhs.loc) }

    public func asHashable() -> AnyDOMLocator { self }

    public var byteOffset:   Int { loc.byteOffset }
    public var lineNumber:   Int { loc.lineNumber }
    public var columnNumber: Int { loc.columnNumber }
    public var utf16Offset:  Int { loc.utf16Offset }
    public var uri:          String { loc.uri }
    public var relatedNode:  Node { loc.relatedNode }
}

extension DOMLocator where Self: Hashable {
    public func isEqualTo(_ other: DOMLocator) -> Bool { guard let other: Self = (other as? Self) else { return false }; return (self == other) }

    public func asHashable() -> AnyDOMLocator { AnyDOMLocator(self) }

    public func getHash(into hasher: inout Hasher) { hash(into: &hasher) }
}

extension Array where Element: DOMLocator {
    public static func == (lhs: [DOMLocator], rhs: [DOMLocator]) -> Bool { lhs.map({ $0.asHashable() }) == rhs.map({ $0.asHashable() }) }
}

extension Dictionary where Value: DOMLocator {
    public static func == (lhs: [Key: DOMLocator], rhs: [Key: DOMLocator]) -> Bool { lhs.mapValues({ $0.asHashable() }) == rhs.mapValues({ $0.asHashable() }) }
}

extension Set where Element: DOMLocator {
    public static func == (lhs: Set<Element>, rhs: Set<Element>) -> Bool { lhs.map({ $0.asHashable() }) == rhs.map({ $0.asHashable() }) }
}
