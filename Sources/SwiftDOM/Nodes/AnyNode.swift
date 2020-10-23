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

open class AnyNode: Node, Hashable {
    @usableFromInline var node: Node

    @inlinable open var owningDocument:  DocumentNode { node.owningDocument }
    @inlinable open var nodeName:        String { node.nodeName }
    @inlinable open var baseURI:         String? { node.baseURI }
    @inlinable open var localName:       String? { node.localName }
    @inlinable open var namespaceURI:    String? { node.namespaceURI }
    @inlinable open var parentNode:      Node? { node.parentNode }
    @inlinable open var firstChild:      Node? { node.firstChild }
    @inlinable open var lastChild:       Node? { node.lastChild }
    @inlinable open var nextSibling:     Node? { node.nextSibling }
    @inlinable open var previousSibling: Node? { node.previousSibling }
    @inlinable open var hasAttributes:   Bool { node.hasAttributes }
    @inlinable open var hasChildNodes:   Bool { node.hasChildNodes }
    @inlinable open var hasNamespace:    Bool { node.hasNamespace }
    @inlinable open var nodeType:        NodeTypes { node.nodeType }
    @inlinable open var attributes:      NamedNodeMap<AnyAttributeNode> { node.attributes }
    @inlinable open var children:        NodeList<AnyNode> { node.children }

    @inlinable open var nodeValue:   String? {
        get { node.nodeValue }
        set { node.nodeValue = newValue }
    }
    @inlinable open var textContent: String? {
        get { node.textContent }
        set { node.textContent = newValue }
    }
    @inlinable open var prefix:      String? {
        get { node.prefix }
        set { node.prefix = newValue }
    }

    public init(_ node: Node) {
        self.node = node
    }

    @inlinable open func append<T: Node>(child childNode: T) -> T {
        node.append(child: childNode)
    }

    @inlinable open func cloneNode(deep: Bool) -> Node {
        node.cloneNode(deep: deep)
    }

    @inlinable open func userData(key: String) -> Any? {
        node.userData(key: key)
    }

    @inlinable open func insert<T: Node, E: Node>(childNode: T, before refNode: E?) -> T {
        node.insert(childNode: childNode, before: refNode)
    }

    @inlinable open func isDefaultNamespace(namespaceURI uri: String) -> Bool {
        node.isDefaultNamespace(namespaceURI: uri)
    }

    @inlinable open func isSameNode(as otherNode: Node) -> Bool {
        node.isSameNode(as: otherNode)
    }

    @inlinable open func lookupNamespaceURL(prefix: String) -> String? {
        node.lookupNamespaceURL(prefix: prefix)
    }

    @inlinable open func lookupPrefix(namespaceURI uri: String) -> String? {
        node.lookupPrefix(namespaceURI: uri)
    }

    @inlinable open func normalize() {
        node.normalize()
    }

    @inlinable open func remove<T: Node>(childNode: T) -> T {
        node.remove(childNode: childNode)
    }

    @inlinable open func replace<O: Node, T: Node>(childNode oldChildNode: O, with newChildNode: T) -> O {
        node.replace(childNode: oldChildNode, with: newChildNode)
    }

    @inlinable open func setUserData(key: String, userData: Any?, handler: UserDataHandler?) {
        node.setUserData(key: key, userData: userData, handler: handler)
    }

    @inlinable open func hash(into hasher: inout Hasher) {
        node.getHash(into: &hasher)
    }

    @inlinable open func asHashable() -> AnyNode {
        self
    }

    @inlinable open func isEqualTo(_ other: Node) -> Bool {
        guard let _other: AnyNode = (other as? AnyNode) else { return false }
        return node.isEqualTo(_other.node)
    }

    @inlinable public static func == (lhs: AnyNode, rhs: AnyNode) -> Bool {
        lhs.node.isEqualTo(rhs.node)
    }
}

extension Node where Self: Hashable {
    @inlinable public func getHash(into hasher: inout Hasher) {
        self.hash(into: &hasher)
    }
}

extension Array where Element: Node {
    @inlinable public static func == (lhs: [Node], rhs: [Node]) -> Bool {
        lhs.map({ $0.asHashable() }) == rhs.map({ $0.asHashable() })
    }
}

extension Dictionary where Value: Node {
    @inlinable public static func == (lhs: [Key: Node], rhs: [Key: Node]) -> Bool {
        lhs.mapValues({ $0.asHashable() }) == rhs.mapValues({ $0.asHashable() })
    }
}

extension Set where Element: Node {
    @inlinable public static func == (lhs: Set<Element>, rhs: Set<Element>) -> Bool {
        lhs.map({ $0.asHashable() }) == rhs.map({ $0.asHashable() })
    }
}
