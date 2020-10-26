/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: NamedNodeMap.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/15/20
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

open class NamedNodeMap<T>: Hashable, RandomAccessCollection {

    public typealias Element = T
    public typealias SubSequence = ArraySlice<Element>
    public typealias Index = Int
    public typealias Indices = Range<Index>

    @inlinable open var startIndex: Index { 0 }
    @inlinable open var endIndex:   Index { 0 }
    @inlinable open var count:      Int { 0 }

    public let uuid: String = UUID().uuidString

    public init() {}

    @inlinable open subscript(nodeName: String) -> T? { nil }
    @inlinable open subscript(name: String, namespaceURI: String) -> T? { nil }
    @inlinable open subscript(position: Int) -> T { fatalError("Index out of bounds.") }
    @inlinable open subscript(bounds: Range<Int>) -> ArraySlice<T> { Array<T>()[bounds] }

    @inlinable open func hash(into hasher: inout Hasher) { hasher.combine(uuid) }

    public static func == (lhs: NamedNodeMap<T>, rhs: NamedNodeMap<T>) -> Bool { lhs === rhs }
}

extension NamedNodeMap where T: Node {
    @inlinable public static func == (lhs: NamedNodeMap<T>, rhs: NamedNodeMap<T>) -> Bool { lhs.map({ $0.asHashable() }) == rhs.map({ $0.asHashable() }) }

    @inlinable public func contains(_ node: T) -> Bool { contains { $0.isSameNode(as: node) } }
}
