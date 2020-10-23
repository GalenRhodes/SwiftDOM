/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: NodeImpl.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/21/20
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

open class NodeImpl: Node, Hashable {

    @usableFromInline static let _emptyAttributes: NamedNodeMap<AnyAttributeNode> = NamedNodeMap()
    @usableFromInline static let _emptyChildren:   NodeList<AnyNode>              = NodeList()

    @inlinable open var owningDocument:  DocumentNode { _owningDocument }
    @inlinable open var nodeName:        String { "" }
    @inlinable open var nodeType:        NodeTypes { NodeTypes.Unknown }
    @inlinable open var hasAttributes:   Bool { !attributes.isEmpty }
    @inlinable open var hasChildNodes:   Bool { !children.isEmpty }
    @inlinable open var hasNamespace:    Bool { !(namespaceURI ?? "").isEmpty }
    @inlinable open var baseURI:         String? { nil }
    @inlinable open var localName:       String? { nil }
    @inlinable open var namespaceURI:    String? { nil }
    @inlinable open var firstChild:      Node? { nil }
    @inlinable open var lastChild:       Node? { nil }
    @inlinable open var parentNode:      Node? { nil }
    @inlinable open var nextSibling:     Node? { nil }
    @inlinable open var previousSibling: Node? { nil }
    @inlinable open var attributes:      NamedNodeMap<AnyAttributeNode> { NodeImpl._emptyAttributes }
    @inlinable open var children:        NodeList<AnyNode> { NodeImpl._emptyChildren }

    @inlinable open var nodeValue:   String? {
        get { nil }
        set {}
    }
    @inlinable open var textContent: String? {
        get { nil }
        set {}
    }
    @inlinable open var prefix:      String? {
        get { nil }
        set {}
    }

    @usableFromInline var _owningDocument: DocumentNode
    @usableFromInline var _userData:       [String: UserDataInfo] = [:]

    public init(_ owningDocument: DocumentNode) {
        _owningDocument = owningDocument
    }

    open func hash(into hasher: inout Hasher) {
        hasher.combine(nodeName)
        hasher.combine(nodeType)
        hasher.combine(attributes)
        hasher.combine(children)
    }

    open func cloneNode(deep: Bool) -> Node { fatalError("cloneNode(deep:) has not been implemented") }

    open func normalize() {}

    @discardableResult open func insert<T: Node, E: Node>(childNode: T, before refNode: E?) -> T { fatalError("insert(childNode:before:) has not been implemented") }

    @discardableResult open func remove<T: Node>(childNode: T) -> T { fatalError("remove(childNode:) has not been implemented") }

    @discardableResult @inlinable open func replace<O: Node, T: Node>(childNode oldChildNode: O, with newChildNode: T) -> O {
        insert(childNode: newChildNode, before: oldChildNode)
        return remove(childNode: oldChildNode)
    }

    @discardableResult @inlinable open func append<T: Node>(child childNode: T) -> T { let e: NodeImpl? = nil; return insert(childNode: childNode, before: e) }

    @inlinable open func isDefaultNamespace(namespaceURI uri: String) -> Bool { fatalError("isDefaultNamespace(namespaceURI:) has not been implemented") }

    @inlinable open func lookupNamespaceURL(prefix: String) -> String? { fatalError("lookupNamespaceURL(prefix:) has not been implemented") }

    @inlinable open func lookupPrefix(namespaceURI uri: String) -> String? { fatalError("lookupPrefix(namespaceURI:) has not been implemented") }

    @inlinable open func userData(key: String) -> Any? { _userData[key]?.data }

    @inlinable open func setUserData(key: String, userData ud: Any?, handler: UserDataHandler?) {
        if let ud: Any = ud { _userData[key] = UserDataInfo(data: ud, body: handler) }
        else { _userData.removeValue(forKey: key) }
    }

    @inlinable open func isSameNode(as otherNode: Node) -> Bool {
        guard let _other: NodeImpl = (otherNode as? NodeImpl) else { return false }
        return (self === _other)
    }

    @inlinable open func isEqualTo(_ other: Node) -> Bool {
        guard type(of: other) == NodeImpl.self, let _other: NodeImpl = (other as? NodeImpl) else { return false }
        return (self == _other)
    }

    @inlinable open func asHashable() -> AnyNode { AnyNode(self) }

    @inlinable public static func == (lhs: NodeImpl, rhs: NodeImpl) -> Bool { lhs === rhs }
}
