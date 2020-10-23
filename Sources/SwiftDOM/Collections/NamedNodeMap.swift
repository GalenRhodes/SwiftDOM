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

open class NamedNodeMap<T: Node>: Hashable, RandomAccessCollection, LiveCollection {

    public typealias Element = T
    public typealias SubSequence = NamedNodeMap<Element>
    public typealias Index = Int
    public typealias Indices = Range<Index>

    @inlinable open var startIndex: Index { 0 }
    @inlinable open var endIndex:   Index { 0 }
    @inlinable open var count:      Int { 0 }

    public let uuid: String = UUID().uuidString

    public init() {}

    @inlinable open subscript(nodeName: String) -> T? { nil }

    @inlinable open subscript(name: String, namespaceURI: String) -> T? { nil }

    @inlinable open func contains(node: T) -> Bool {
        for n: T in self { if n.isEqualTo(node) { return true } }
        return false
    }

    @inlinable open func hash(into hasher: inout Hasher) { hasher.combine(uuid) }

    public static func == (lhs: NamedNodeMap<T>, rhs: NamedNodeMap<T>) -> Bool {
        if lhs === rhs || lhs.uuid == rhs.uuid {
            return true
        }
        else if lhs.count == rhs.count {
            for n: T in lhs { if !rhs.contains(node: n) { return false } }
            return true
        }

        return false
    }

    @inlinable open subscript(position: Int) -> T { fatalError("Index out of bounds.") }
    @inlinable open subscript(bounds: Range<Int>) -> NamedNodeMap<T> {
        if bounds.isEmpty { return self }
        fatalError("Range out of bounds.")
    }

    @inlinable open func domCollectionDidChange(_ node: Node) {}

    @inlinable open func isEqualTo(_ other: LiveCollection) -> Bool {
        guard type(of: other) == NamedNodeMap.self, let _other: NamedNodeMap<T> = (other as? NamedNodeMap) else { return false }
        return self == _other
    }
}
