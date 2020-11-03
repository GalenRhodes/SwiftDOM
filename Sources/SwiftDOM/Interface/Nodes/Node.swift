/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: Node.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/14/20
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

public protocol Node: AnyObject {
    //@f:0
    var nodeType        : NodeTypes                   { get     }
    var nodeName        : String                      { get     }
    var nodeValue       : String?                     { get set }
    var textContent     : String                      { get set }
    var baseURI         : String?                     { get     }
    var namespaceURI    : String?                     { get     }
    var localName       : String?                     { get     }
    var prefix          : String?                     { get set }
    var count           : Int                         { get     }
    var startIndex      : Int                         { get     }
    var endIndex        : Int                         { get     }
    var attributes      : NamedNodeMap<AttributeNode> { get     }
    var isEmpty         : Bool                        { get     }
    var isReadOnly      : Bool                        { get     }
    var hasAttributes   : Bool                        { get     }
    var hasChildNodes   : Bool                        { get     }
    var hasNamespace    : Bool                        { get     }
    var owningDocument  : DocumentNode                { get     }
    var parentNode      : Node?                       { get     }
    var firstChild      : Node?                       { get     }
    var lastChild       : Node?                       { get     }
    var nextSibling     : Node?                       { get     }
    var previousSibling : Node?                       { get     }
    //@f:1

    func normalize()

    @discardableResult func append(child childNode: Node) -> Node

    @discardableResult func insert(childNode: Node, before refNode: Node?) -> Node

    @discardableResult func replace(childNode oldChildNode: Node, with newChildNode: Node) -> Node

    @discardableResult func remove(childNode: Node) -> Node

    @discardableResult func removeAllChildNodes() -> [Node]

    func userData(key: String) -> Any?

    func setUserData(key: String, userData: Any?, handler: UserDataEventHandler?)

    func cloneNode(deep: Bool) -> Node

    func forEachChild(do block: (Node) throws -> Void) rethrows

    func contains(_ node: Node) -> Bool

    func isNodeType(_ types: NodeTypes...) -> Bool

    func isEqualTo(_ other: Node) -> Bool

    func isSameNode(as otherNode: Node) -> Bool

    func isDefaultNamespace(namespaceURI uri: String) -> Bool

    func lookupNamespaceURL(prefix: String) -> String?

    func lookupPrefix(namespaceURI uri: String) -> String?

    func asHashable() -> AnyNode

    func getHash(into hasher: inout Hasher)

    subscript(position: Int) -> Node { get }

    subscript(bounds: Range<Int>) -> ArraySlice<Node> { get }
}

extension Node {
    @inlinable public var count:   Int { (endIndex - startIndex) }
    @inlinable public var isEmpty: Bool { (count == 0) }

    @inlinable public func isNodeType(_ types: [NodeTypes]) -> Bool { for t in types { if nodeType == t { return true } }; return false }

    @inlinable public func isNodeType(_ types: NodeTypes...) -> Bool { isNodeType(types) }

    @inlinable public func forEachChild(do block: (Node) throws -> Void) rethrows { var n0 = firstChild; while let n1 = n0 { try block(n1); n0 = n1.nextSibling } }

    @inlinable public func isSameNode(as otherNode: Node) -> Bool { self === otherNode }

    @inlinable @discardableResult public func append(child childNode: Node) -> Node { insert(childNode: childNode, before: nil) }
}

extension Node where Self: Hashable {
    @inlinable public func hash(into hasher: inout Hasher) { getHash(into: &hasher) }

    @inlinable public static func == (lhs: Self, rhs: Self) -> Bool { lhs.isSameNode(as: rhs) }
}

extension Array where Element: Node {
    @inlinable public static func == (lhs: [Node], rhs: [Node]) -> Bool { lhs.map({ $0.asHashable() }) == rhs.map({ $0.asHashable() }) }
}
