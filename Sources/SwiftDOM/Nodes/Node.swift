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
    var owningDocument:  DocumentNode { get }
    var nodeName:        String { get }
    var baseURI:         String? { get }
    var localName:       String? { get }
    var namespaceURI:    String? { get }
    var parentNode:      Node? { get }
    var firstChild:      Node? { get }
    var lastChild:       Node? { get }
    var nextSibling:     Node? { get }
    var previousSibling: Node? { get }
    var hasAttributes:   Bool { get }
    var hasChildNodes:   Bool { get }
    var hasNamespace:    Bool { get }
    var nodeType:        NodeTypes { get }
    var nodeValue:       String? { get set }
    var textContent:     String? { get set }
    var prefix:          String? { get set }
    var attributes:      NamedNodeMap<AnyAttributeNode> { get }
    var children:        NodeList<AnyNode> { get }

    func append<T: Node>(child childNode: T) -> T

    func cloneNode(deep: Bool) -> Node

    func userData(key: String) -> Any?

    func insert<T: Node, E: Node>(childNode: T, before refNode: E?) -> T

    func isDefaultNamespace(namespaceURI uri: String) -> Bool

    func isSameNode(as otherNode: Node) -> Bool

    func lookupNamespaceURL(prefix: String) -> String?

    func lookupPrefix(namespaceURI uri: String) -> String?

    func normalize()

    func remove<T: Node>(childNode: T) -> T

    func replace<O: Node, T: Node>(childNode oldChildNode: O, with newChildNode: T) -> O

    func setUserData(key: String, userData: Any?, handler: UserDataHandler?)

    func isEqualTo(_ other: Node) -> Bool

    func asHashable() -> AnyNode

    func getHash(into hasher: inout Hasher)
}

