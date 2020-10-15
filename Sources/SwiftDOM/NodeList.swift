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

open class NodeList: Hashable, RandomAccessCollection, LiveCollection {

    public typealias Element = Node
    public typealias SubSequence = NodeList
    public typealias Index = Int
    public typealias Indices = Range<Index>
    public typealias Iterator = IndexingIterator<[Element]>

    public static var empty: NodeList = NodeList()

    open var startIndex: Int { 0 }
    open var endIndex:   Int { 0 }
    open var count:      Int { 0 }

    public let uuid: String = UUID().uuidString

    internal init() {}

    open func hash(into hasher: inout Hasher) {}

    public static func == (lhs: NodeList, rhs: NodeList) -> Bool {
        if type(of: lhs) == type(of: rhs) {
            if type(of: lhs) == NodeList.self {
                return true
            }
            else if lhs.count == rhs.count {
                if lhs.count > 0 {
                    var li: Index = lhs.startIndex
                    var ri: Index = rhs.startIndex

                    while li != lhs.endIndex {
                        guard lhs[li].isEqualTo(other: rhs[ri]) else { return false }
                        li = lhs.index(after: li)
                        ri = rhs.index(after: ri)
                    }
                }

                return true
            }
        }

        return false
    }

    open subscript(position: Index) -> Element { fatalError("Index out of bounds") }

    open subscript(bounds: Indices) -> SubSequence {
        if bounds.isEmpty { return self }
        fatalError("Range out of bounds")
    }

    open func makeIterator() -> IndexingIterator<[Element]> {
        let a: [Element] = []
        return a.makeIterator()
    }

    open func collectionDidChange() {}

}

