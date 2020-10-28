/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: AnyNode.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/22/20
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

open class AnyNode: Node, Hashable, RandomAccessCollection {

    public typealias Element = Node
    public typealias Index = Int
    public typealias SubSequence = ArraySlice<Element>
    public typealias Indices = Range<Index>

    var node: Node

    open var owningDocument:  DocumentNode { node.owningDocument }
    open var nodeName:        String { node.nodeName }
    open var baseURI:         String? { node.baseURI }
    open var localName:       String? { node.localName }
    open var namespaceURI:    String? { node.namespaceURI }
    open var parentNode:      Node? { node.parentNode }
    open var firstChild:      Node? { node.firstChild }
    open var lastChild:       Node? { node.lastChild }
    open var nextSibling:     Node? { node.nextSibling }
    open var previousSibling: Node? { node.previousSibling }
    open var hasAttributes:   Bool { node.hasAttributes }
    open var hasChildNodes:   Bool { node.hasChildNodes }
    open var hasNamespace:    Bool { node.hasNamespace }
    open var nodeType:        NodeTypes { node.nodeType }
    open var attributes:      NamedNodeMap<AttributeNode> { node.attributes }
    open var startIndex:      Int { node.startIndex }
    open var endIndex:        Int { node.endIndex }
    open var count:           Int { node.count }

    open var nodeValue:   String? {
        get { node.nodeValue }
        set { node.nodeValue = newValue }
    }
    open var textContent: String? {
        get { node.textContent }
        set { node.textContent = newValue }
    }
    open var prefix:      String? {
        get { node.prefix }
        set { node.prefix = newValue }
    }

    public init(_ node: Node) { self.node = node }

    @discardableResult open func append(child childNode: Node) -> Node { node.append(child: childNode) }

    @discardableResult open func insert(childNode: Node, before refNode: Node?) -> Node { node.insert(childNode: childNode, before: refNode) }

    @discardableResult open func replace(childNode oldChildNode: Node, with newChildNode: Node) -> Node { node.replace(childNode: oldChildNode, with: newChildNode) }

    @discardableResult open func remove(childNode: Node) -> Node { node.remove(childNode: childNode) }

    open func cloneNode(deep: Bool) -> Node { node.cloneNode(deep: deep) }

    open func userData(key: String) -> Any? { node.userData(key: key) }

    open func isDefaultNamespace(namespaceURI uri: String) -> Bool { node.isDefaultNamespace(namespaceURI: uri) }

    open func isSameNode(as otherNode: Node) -> Bool { node.isSameNode(as: otherNode) }

    open func lookupNamespaceURL(prefix: String) -> String? { node.lookupNamespaceURL(prefix: prefix) }

    open func lookupPrefix(namespaceURI uri: String) -> String? { node.lookupPrefix(namespaceURI: uri) }

    open func normalize() { node.normalize() }

    open func setUserData(key: String, userData: Any?, handler: UserDataHandler?) { node.setUserData(key: key, userData: userData, handler: handler) }

    open func hash(into hasher: inout Hasher) { node.getHash(into: &hasher) }

    open func asHashable() -> AnyNode { self }

    open func isEqualTo(_ other: Node) -> Bool { node.isEqualTo(other) }

    open func contains(_ node: Node) -> Bool { node.contains(node) }

    open func getHash(into hasher: inout Hasher) { node.getHash(into: &hasher) }

    open subscript(position: Int) -> Node { node[position] }

    open subscript(bounds: Range<Int>) -> ArraySlice<Node> { node[bounds] }

    public static func == (lhs: AnyNode, rhs: AnyNode) -> Bool { ((lhs === rhs) || lhs.node.isSameNode(as: rhs.node)) }
}

extension Node where Self: Hashable {
    public func getHash(into hasher: inout Hasher) { hash(into: &hasher) }
}

extension Array where Element: Node {
    public static func == (lhs: [Node], rhs: [Node]) -> Bool { lhs.map({ $0.asHashable() }) == rhs.map({ $0.asHashable() }) }
}

extension Dictionary where Value: Node {
    public static func == (lhs: [Key: Node], rhs: [Key: Node]) -> Bool { lhs.mapValues({ $0.asHashable() }) == rhs.mapValues({ $0.asHashable() }) }
}

extension Set where Element: Node {
    public static func == (lhs: Set<Element>, rhs: Set<Element>) -> Bool { lhs.map({ $0.asHashable() }) == rhs.map({ $0.asHashable() }) }
}
