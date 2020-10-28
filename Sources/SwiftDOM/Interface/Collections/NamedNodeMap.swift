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

open class NamedNodeMap<Element>: Hashable, RandomAccessCollection {

    public typealias Element = Element
    public typealias SubSequence = ArraySlice<Element>
    public typealias Index = Int
    public typealias Indices = Range<Index>

    open var startIndex: Index { 0 }
    open var endIndex:   Index { 0 }
    open var count:      Int { 0 }

    public let uuid: String = UUID().uuidString

    public init() {}

    open subscript(nodeName: String) -> Element? { nil }
    open subscript(namespaceURI uri: String, localName lName: String) -> Element? { nil }
    open subscript(position: Int) -> Element { fatalError("Index out of bounds.") }
    open subscript(bounds: Range<Int>) -> ArraySlice<Element> { Array<Element>()[bounds] }

    open func hash(into hasher: inout Hasher) { hasher.combine(uuid) }

    open func clone(deep: Bool = false, postEvents: Bool = true) -> NamedNodeMap<Element> { NamedNodeMap<Element>() }

    open func mapAs<S>(_ transform: (Element) throws -> S) rethrows -> NamedNodeMap<S> { NamedNodeMap<S>() }

    public static func == (lhs: NamedNodeMap<Element>, rhs: NamedNodeMap<Element>) -> Bool { (lhs === rhs) || (lhs.uuid == rhs.uuid) }
}

extension NamedNodeMap where Element: Node {
    public func hash(into hasher: inout Hasher) { hasher.combine(map { $0.asHashable() }) }

    public func contains(_ node: Element) -> Bool { contains { $0.isSameNode(as: node) } }

    public subscript(nodeName: String) -> Element? { first { $0.nodeName == nodeName } }

    public subscript(namespaceURI uri: String, localName lName: String) -> Element? { first { $0.namespaceURI == uri && $0.localName == lName } }

    public static func == (lhs: NamedNodeMap<Element>, rhs: NamedNodeMap<Element>) -> Bool {
        if (lhs === rhs) || (lhs.uuid == rhs.uuid) { return true }
        guard lhs.count == rhs.count else { return false }
        for o: Element in lhs { if !rhs.contains(where: { $0.isEqualTo(o) }) { return false } }
        return true
    }
}

extension NamedNodeMap where Element: Equatable {
    public static func == (lhs: NamedNodeMap<Element>, rhs: NamedNodeMap<Element>) -> Bool {
        if (lhs === rhs) || (lhs.uuid == rhs.uuid) { return true }
        guard lhs.count == rhs.count else { return false }
        for o: Element in lhs { if !rhs.contains(where: { $0 == o }) { return false } }
        return true
    }
}

extension NamedNodeMap where Element: Hashable {
    public func hash(into hasher: inout Hasher) { for o: Element in self { hasher.combine(o) } }
}
