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

    @inlinable public    var owningDocument  : DocumentNode                { _owningDocument }
    @inlinable public    var nodeType        : NodeTypes                   { fatalError() }
    public               var nodeName        : String                      { "" }
    public               var nodeValue       : String?                     { get { nil } set {} }
    public               var baseURI         : String?                     { nil }
    public               var namespaceURI    : String?                     { nil }
    public               var localName       : String?                     { nil }
    public               var prefix          : String?                     { get { nil } set {} }
    public               var textContent     : String                      { get { ""  } set {} }
    public               var startIndex      : Int                         {0}
    public               var endIndex        : Int                         {0}
    public               var hasAttributes   : Bool                        {false}
    public               var hasChildNodes   : Bool                        {false}
    public               var hasNamespace    : Bool                        {false}
    public               var parentNode      : Node?                       { nil }
    public               var firstChild      : Node?                       { nil }
    public               var lastChild       : Node?                       { nil }
    public               var nextSibling     : Node?                       { nil }
    public               var previousSibling : Node?                       { nil }
    public               var attributes      : NamedNodeMap<AttributeNode> { NodeImpl.emptyAttributeNamedNodeMap }
    @usableFromInline    var _userData       : [String: UserDataItem]      = [:]
    @usableFromInline    var _owningDocument : DocumentNode!               = nil
//@f:1


    public init() {
        _owningDocument = nil
    }

    public init(_ owningDocument: DocumentNode) {
        _owningDocument = owningDocument
    }

    public func contains(_ node: Node) -> Bool {
        for n in self { if node.isSameNode(as: n) { return true } }
        return false
    }

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

    public func isDefaultNamespace(namespaceURI uri: String) -> Bool {
        for a in attributes { if a.nodeName == "xmlns" && a.value == uri { return true } }
        return false
    }

    public func lookupNamespaceURL(prefix pfx: String) -> String? {
        if let npfx = prefix, pfx == npfx { return namespaceURI }
        for a in attributes { if let p = a.prefix, p == "xmlns", a.localName == pfx { return a.namespaceURI } }
        return parentNode?.lookupNamespaceURL(prefix: pfx)
    }

    public func lookupPrefix(namespaceURI uri: String) -> String? {
        if let nuri = namespaceURI, uri == nuri { return prefix }
        for a in attributes { if let p = a.prefix, p == "xmlns", a.value == uri { return a.localName } }
        return parentNode?.lookupPrefix(namespaceURI: uri)
    }

    public func asHashable() -> AnyNode { AnyNode(self) }

    public func getHash(into hasher: inout Hasher) {
        hasher.combine(nodeName)
        hasher.combine(nodeType)
        hasher.combine(nodeValue)
        hasher.combine(localName)
        hasher.combine(namespaceURI)
        hasher.combine(prefix)
        for a in attributes { a.getHash(into: &hasher) }
    }

    /*===========================================================================================================================*/
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

    /*===========================================================================================================================*/
    /// Sub-classes will want to override this with a more efficient implementation.
    ///
    /// - Parameter bounds: the bounds of the nodes to get.
    /// - Returns: and <code>[ArraySlice](https://developer.apple.com/documentation/swift/ArraySlice)</code> containing the nodes.
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
        cloneError()
    }

    @inlinable func cloneError() -> Never {
        fatalError("Cannot clone this node.")
    }

    func postUserDataEvent(action: UserDataEvents, destination destNode: Node) {

    }

    public func isEqualTo(_ other: Node) -> Bool { fatalError("isEqualTo(_:) has not been implemented") }
}
