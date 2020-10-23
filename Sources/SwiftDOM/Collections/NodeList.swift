/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: NodeList.swift
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

open class NodeList<T: Node>: Hashable, RandomAccessCollection, LiveCollection {

    public typealias Element = T
    public typealias SubSequence = NodeList<Element>
    public typealias Index = Int
    public typealias Indices = Range<Index>

    @inlinable open var startIndex: Int { 0 }
    @inlinable open var endIndex:   Int { 0 }
    @inlinable open var count:      Int { 0 }

    public let uuid: String = UUID().uuidString

    @usableFromInline init() {}

    @inlinable open func hash(into hasher: inout Hasher) { hasher.combine(uuid) }

    @inlinable open func contains(node: Element) -> Bool {
        for n: T in self { if node.isEqualTo(n) { return true } }
        return false
    }

    public static func == (lhs: NodeList, rhs: NodeList) -> Bool {
        if lhs === rhs || lhs.uuid == rhs.uuid {
            return true
        }
        else if lhs.count == rhs.count {
            if lhs.count > 0 {
                for (i, n): (Index, T) in lhs.enumerated() {
                    if !n.isEqualTo(rhs[i]) {
                        return false
                    }
                }
            }
            return true
        }
        return false
    }

    @inlinable open subscript(position: Index) -> Element { fatalError("Index out of bounds") }

    @inlinable open subscript(bounds: Indices) -> SubSequence {
        if bounds.isEmpty { return self }
        fatalError("Range out of bounds")
    }

    @inlinable open func domCollectionDidChange(_ node: Node) {}
}

