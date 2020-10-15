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
    var nodeName:        String { get }
    var baseURI:         String? { get }
    var localName:       String? { get }
    var namespaceURI:    String? { get }
    var firstChild:      Node? { get }
    var lastChild:       Node? { get }
    var nextSibling:     Node? { get }
    var previousSibling: Node? { get }
    var nodeType:        NodeTypes { get }
    var parentNode:      Node? { get }
    var nodeValue:       String? { get set }
    var textContent:     String? { get set }
    var prefix:          String? { get set }
    var attributes:      NamedNodeMap<AttributeNode> { get }
    var children:        NodeList { get }

    func isEqualTo(other: Node) -> Bool

    func asHashable() -> AnyNode

    func getHash(into hasher: inout Hasher)
}

open class AnyNode: Node, Hashable {
    @usableFromInline var node: Node

    @inlinable open var nodeName:        String { node.nodeName }
    @inlinable open var baseURI:         String? { node.baseURI }
    @inlinable open var localName:       String? { node.localName }
    @inlinable open var namespaceURI:    String? { node.namespaceURI }
    @inlinable open var firstChild:      Node? { node.firstChild }
    @inlinable open var lastChild:       Node? { node.lastChild }
    @inlinable open var nextSibling:     Node? { node.nextSibling }
    @inlinable open var previousSibling: Node? { node.previousSibling }
    @inlinable open var nodeType:        NodeTypes { node.nodeType }
    @inlinable open var parentNode:      Node? { node.parentNode }
    @inlinable open var attributes:      NamedNodeMap<AttributeNode> { node.attributes }
    @inlinable open var nodeValue:       String? {
        get { node.nodeValue }
        set { node.nodeValue = newValue }
    }
    @inlinable open var textContent:     String? {
        get { node.textContent }
        set { node.textContent = newValue }
    }
    @inlinable open var prefix:          String? {
        get { node.prefix }
        set { node.prefix = newValue }
    }
    @inlinable open var children:        NodeList { node.children }

    public init(_ node: Node) { self.node = node }

    @inlinable public static func == (lhs: AnyNode, rhs: AnyNode) -> Bool { lhs.node.isEqualTo(other: rhs.node) }

    @inlinable open func hash(into hasher: inout Hasher) { node.getHash(into: &hasher) }

    @inlinable open func asHashable() -> AnyNode { self }

    @inlinable open func isEqualTo(other: Node) -> Bool { ((self === other) || ((type(of: other) == AnyNode.self) && (self == (other as! AnyNode)))) }
}

extension Node where Self: Hashable {
    public func getHash(into hasher: inout Hasher) { self.hash(into: &hasher) }

    public func asHashable() -> AnyNode { AnyNode(self) }
}

extension Array where Element: Node {
    @inlinable public static func == (lhs: [Node], rhs: [Node]) -> Bool { lhs.map({ $0.asHashable() }) == rhs.map({ $0.asHashable() }) }
}

extension Dictionary where Value: Node {
    @inlinable public static func == (lhs: [Key: Node], rhs: [Key: Node]) -> Bool { lhs.mapValues({ $0.asHashable() }) == rhs.mapValues({ $0.asHashable() }) }
}
