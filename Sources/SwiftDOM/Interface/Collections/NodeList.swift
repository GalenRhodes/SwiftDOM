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

open class NodeList<Element>: Hashable, RandomAccessCollection {

    public typealias Element = Element
    public typealias SubSequence = ArraySlice<Element>
    public typealias Index = Int
    public typealias Indices = Range<Int>

    open var startIndex: Int { 0 }
    open var endIndex:   Int { 0 }
    open var count:      Int { 0 }

    public let uuid: String = UUID().uuidString

    init() {}

    open func hash(into hasher: inout Hasher) { hasher.combine(uuid) }

    open subscript(position: Int) -> Element { Array<Element>()[position] }

    open subscript(bounds: Range<Int>) -> ArraySlice<Element> { Array<Element>()[bounds] }

    open func clone(deep: Bool = false, postEvents: Bool = false) -> NodeList<Element> { NodeList<Element>() }

    open func mapAs<S>(transform: (Element) throws -> S) rethrows -> NodeList<S> { NodeList<S>() }

    public static func == (lhs: NodeList, rhs: NodeList) -> Bool { ((lhs === rhs) || (lhs.uuid == rhs.uuid)) }
}

extension NodeList where Element: Node {
    public func contains(node: Element) -> Bool { contains { $0.isSameNode(as: node) } }

    public static func == (lhs: NodeList<Element>, rhs: NodeList<Element>) -> Bool {
        guard lhs.count == rhs.count else { return false }
        for (i, n): (Int, Element) in lhs.enumerated() { if !n.isEqualTo(rhs[i]) { return false } }
        return true
    }

    public func hash(into hasher: inout Hasher) { hasher.combine(map { $0.asHashable() }) }
}

extension NodeList where Element: Equatable {
    public static func == (lhs: NodeList<Element>, rhs: NodeList<Element>) -> Bool {
        guard lhs.count == rhs.count else { return false }
        for (i, n): (Int, Element) in lhs.enumerated() { if n != rhs[i] { return false } }
        return true
    }
}

extension NodeList where Element: Hashable {
    public func hash(into hasher: inout Hasher) { for o: Element in self { hasher.combine(o) } }
}
