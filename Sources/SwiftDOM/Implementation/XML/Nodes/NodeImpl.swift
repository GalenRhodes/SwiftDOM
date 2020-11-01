/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: NodeImpl.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/30/20
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

public class NodeImpl: Node, Hashable, Equatable, RandomAccessCollection {
    static var emptyAttributeNamedNodeMap: NamedNodeMap<AttributeNode> = NamedNodeMap<AttributeNode>()

//@f:0
    public typealias Element     = Node
    public typealias Index       = Int
    public typealias Indices     = Range<Index>
    public typealias SubSequence = ArraySlice<Element>

    public internal(set) var owningDocument  : DocumentNode
    public               var nodeType        : NodeTypes                   { fatalError() }
    public internal(set) var nodeName        : String                      = ""
    public               var nodeValue       : String?                     { get { nil } set { } }
    public internal(set) var baseURI         : String?                     = nil
    public internal(set) var namespaceURI    : String?                     = nil
    public internal(set) var localName       : String?                     = nil
    public               var prefix          : String?                     = nil
    public internal(set) var startIndex      : Int                         = 0
    public internal(set) var endIndex        : Int                         = 0
    public internal(set) var hasAttributes   : Bool                        = false
    public internal(set) var hasChildNodes   : Bool                        = false
    public internal(set) var hasNamespace    : Bool                        = false
    public internal(set) var parentNode      : Node?                       = nil
    public internal(set) var firstChild      : Node?                       = nil
    public internal(set) var lastChild       : Node?                       = nil
    public internal(set) var nextSibling     : Node?                       = nil
    public internal(set) var previousSibling : Node?                       = nil
    public internal(set) var attributes      : NamedNodeMap<AttributeNode> = NodeImpl.emptyAttributeNamedNodeMap
//@f:1

    var _userData: [String: UserDataItem] = [:]

    public func normalize() {}

    public func insert(childNode: Node, before refNode: Node?) -> Node { childNode }

    public func replace(childNode oldChildNode: Node, with newChildNode: Node) -> Node { oldChildNode }

    public func remove(childNode: Node) -> Node { childNode }

    public func removeAllChildNodes() -> [Node] { [] }

    public func userData(key: String) -> Any? { _userData[key]?.userData }

    public func setUserData(key: String, userData: Any?, handler: UserDataEventHandler?) {
        if let userData = userData { _userData[key] = UserDataItem(userData: userData, eventHandler: handler) }
        else { _userData.removeValue(forKey: key) }
    }

    public func isDefaultNamespace(namespaceURI uri: String) -> Bool { fatalError("isDefaultNamespace(namespaceURI:) has not been implemented") }

    public func lookupNamespaceURL(prefix: String) -> String? { fatalError("lookupNamespaceURL(prefix:) has not been implemented") }

    public func lookupPrefix(namespaceURI uri: String) -> String? { fatalError("lookupPrefix(namespaceURI:) has not been implemented") }

    public func asHashable() -> AnyNode { AnyNode(self) }

    public func getHash(into hasher: inout Hasher) { hashThem(into: &hasher, items: nodeType, nodeName, nodeValue, localName, prefix, namespaceURI, attributes) }

    /// Sub-classes will want to override this with a more efficient implementation.
    ///
    /// - Parameter position: the position of the node to get.
    /// - Returns: the node.
    ///
    public subscript(position: Int) -> Node {
        if position >= startIndex && position < endIndex {
            var ix = startIndex
            var n0 = firstChild

            while let n1 = n0 {
                if ix < position {
                    ix += 1
                    n0 = n1.nextSibling
                }
                else {
                    return n1
                }
            }
        }
        fatalError("Position is out of bounds")
    }

    /// Sub-classes will want to override this with a more efficient implementation.
    ///
    /// - Parameter bounds: the bounds of the nodes to get.
    /// - Returns: and {@link0 ArraySlice} containing the nodes.
    ///
    public subscript(bounds: Range<Int>) -> ArraySlice<Node> {
        if bounds.lowerBound >= startIndex && bounds.upperBound <= endIndex {
            var arr: [Node] = []
            var ix:  Int    = bounds.lowerBound
            var n0:  Node?  = self[ix]

            while let n1 = n0 {
                if ix < bounds.upperBound {
                    arr.append(n1)
                    ix += 1
                    n0 = n1.nextSibling
                }
                else {
                    return arr[arr.startIndex ..< arr.endIndex]
                }
            }
        }
        fatalError("Invalid bounds.")
    }

    public func cloneNode(deep: Bool) -> Node { cloneNode(owningDocument: owningDocument, notify: true, deep: deep) }

    public func cloneNode(owningDocument: DocumentNode, notify: Bool = false, deep: Bool) -> Node {
        fatalError("cloneNode(DocumentNode:notify:deep:) has not been implemented")
    }

    public func isEqualTo(_ other: Node) -> Bool { fatalError("isEqualTo(_:) has not been implemented") }
}
