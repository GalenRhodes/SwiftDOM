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

public class NodeList<Element>: RandomAccessCollection {
//@f:0
    public typealias Element     = Element
    public typealias Index       = Int
    public typealias Indices     = Range<Int>
    public typealias SubSequence = ArraySlice<Element>

               public var startIndex : Index { 0                     }
               public var endIndex   : Index { 0                     }
    @inlinable public var count      : Int   { endIndex - startIndex }
    @inlinable public var isEmpty    : Bool  { count == 0            }
//@f:1

    init() {}

    public subscript(position: Int) -> Element { Array<Element>()[position] }

    public subscript(bounds: Range<Int>) -> ArraySlice<Element> { Array<Element>()[bounds] }
}

extension NodeList: Hashable, Equatable where Element: Node {
    public func hash(into hasher: inout Hasher) { forEach { node in node.getHash(into: &hasher) } }

    public static func == (lhs: NodeList<Element>, rhs: NodeList<Element>) -> Bool {
        if lhs === rhs {
            return true
        }
        else if lhs.count == rhs.count {
            for (i, n) in lhs.enumerated() { if !n.isSameNode(as: rhs[i]) { return false } }
            return true
        }
        return false
    }
}
