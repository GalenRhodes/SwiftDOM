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

public protocol DOMLocator: AnyObject {
//@f:0
    var byteOffset:   Int    { get }
    var lineNumber:   Int    { get }
    var columnNumber: Int    { get }
    var utf16Offset:  Int    { get }
    var uri:          String { get }
    var relatedNode:  Node   { get }
//@f:1

    func isEqualTo(_ other: DOMLocator) -> Bool

    func asHashable() -> AnyDOMLocator

    func getHash(into hasher: inout Hasher)
}

public class AnyDOMLocator: DOMLocator, Hashable {
    @usableFromInline var loc: DOMLocator

//@f:0
    public var byteOffset:   Int    { loc.byteOffset   }
    public var lineNumber:   Int    { loc.lineNumber   }
    public var columnNumber: Int    { loc.columnNumber }
    public var utf16Offset:  Int    { loc.utf16Offset  }
    public var uri:          String { loc.uri          }
    public var relatedNode:  Node   { loc.relatedNode  }
//@f:1

    public init(_ loc: DOMLocator) { self.loc = loc }

    @inlinable public func hash(into hasher: inout Hasher) { loc.getHash(into: &hasher) }

    @inlinable public static func == (lhs: AnyDOMLocator, rhs: AnyDOMLocator) -> Bool { lhs.loc.isEqualTo(rhs.loc) }

    @inlinable public func asHashable() -> AnyDOMLocator { self }

    @inlinable public func isEqualTo(_ other: DOMLocator) -> Bool { loc.isEqualTo(other) }
}

extension DOMLocator where Self: Hashable {
    @inlinable public func asHashable() -> AnyDOMLocator { AnyDOMLocator(self) }

    @inlinable public func getHash(into hasher: inout Hasher) { hash(into: &hasher) }
}

extension Array where Element: DOMLocator {
    @inlinable public static func == (lhs: [DOMLocator], rhs: [DOMLocator]) -> Bool { lhs.map({ $0.asHashable() }) == rhs.map({ $0.asHashable() }) }
}

