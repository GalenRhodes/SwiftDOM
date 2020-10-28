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

open class NodeImpl: Node, Hashable, RandomAccessCollection {

    public typealias Element = Node
    public typealias Index = Int
    public typealias SubSequence = ArraySlice<Element>
    public typealias Indices = Range<Index>

    static let _emptyAttributes: NamedNodeMap<AttributeNode> = NamedNodeMap()
    static let _emptyNodeArray:  Array<Node>                 = []

    open internal(set) var isReadOnly: Bool    = false
    open internal(set) var baseURI:    String? = nil

    open var nodeType:        NodeTypes { fatalError("No Node Type for this node.") }
    open var nodeName:        String { "" }
    open var localName:       String? { nil }
    open var namespaceURI:    String? { nil }
    open var parentNode:      Node? { nil }
    open var firstChild:      Node? { nil }
    open var lastChild:       Node? { nil }
    open var nextSibling:     Node? { nil }
    open var previousSibling: Node? { nil }
    open var hasAttributes:   Bool { false }
    open var hasChildNodes:   Bool { false }
    open var hasNamespace:    Bool { !(namespaceURI?.isEmpty ?? true) }
    open var startIndex:      Int { 0 }
    open var endIndex:        Int { 0 }
    open var attributes:      NamedNodeMap<AttributeNode> { NodeImpl._emptyAttributes }
    open var prefix:          String? {
        get { nil }
        set {}
    }
    open var nodeValue:       String? {
        get { nil }
        set {}
    }
    open var textContent:     String? {
        get {
            var _s: String = ""
            var _c: Node?  = firstChild
            while let c: Node = _c {
                if let t: String = c.textContent { _s += t }
                _c = c.nextSibling
            }
            return _s
        }
        set {
            removeAllChildren()
            if let t: String = newValue, !t.isEmpty { append(child: _owningDocument.createTextNode(content: t)) }
        }
    }
    open var owningDocument: DocumentNode {
        get { _owningDocument }
        set {
            if let newDoc: DocumentNodeImpl = newValue as? DocumentNodeImpl {
                _owningDocument = newDoc
                attributes.forEach { ($0 as! AttributeNodeImpl).owningDocument = newDoc }
                forEach { ($0 as! ElementNodeImpl).owningDocument = newDoc }
            }
        }
    }

    var _userData:       [String: UserDataInfo] = [:]
    var _owningDocument: DocumentNodeImpl!      = nil

    init() {}

    init(_ owningDocument: DocumentNodeImpl) {
        _owningDocument = owningDocument
    }

    deinit {
        triggerUserData(event: .Deleted, src: nil, dst: nil)
    }

    open func normalize() {}

    @discardableResult open func insert(childNode: Node, before refNode: Node?) -> Node { childNode }

    @discardableResult open func remove(childNode: Node) -> Node { childNode }

    @discardableResult open func append(child childNode: Node) -> Node {
        let ref: NodeImpl? = nil
        return insert(childNode: childNode, before: ref)
    }

    @discardableResult open func replace(childNode oldChildNode: Node, with newChildNode: Node) -> Node {
        insert(childNode: newChildNode, before: oldChildNode)
        return remove(childNode: oldChildNode)
    }

    open func userData(key: String) -> Any? {
        _userData[key]?.data
    }

    open func setUserData(key: String, userData: Any?, handler: UserDataHandler?) {
        if let ud: Any = userData { _userData[key] = UserDataInfo(data: ud, body: handler) }
        else { _userData.removeValue(forKey: key) }
    }

    open func cloneNode(deep: Bool) -> Node {
        guard let od: DocumentNodeImpl = _owningDocument else { fatalError("Unable to clone node.") }
        return cloneNode(od, postEvent: true, deep: deep)
    }

    public final func cloneNode(_ doc: DocumentNodeImpl, postEvent: Bool, deep: Bool) -> NodeImpl {
        let n: NodeImpl = baseClone(doc, postEvent: postEvent, deep: deep)
        if postEvent { triggerUserData(event: .Cloned, src: self, dst: n) }
        return n
    }

    open func baseClone(_ doc: DocumentNodeImpl, postEvent: Bool, deep: Bool) -> NodeImpl {
        fatalError("Unable to clone node.")
    }

    func triggerUserData(event: UserDataEvents, src: Node?, dst: Node?) {
        for (key, userDataInfo): (String, UserDataInfo) in _userData {
            if let h: UserDataHandler = userDataInfo.body {
                h(event, key, userDataInfo.data, src, dst)
            }
        }
    }

    open func contains(_ node: Node) -> Bool {
        contains { $0.isSameNode(as: node) }
    }

    open func isEqualTo(_ other: Node) -> Bool {
        guard nodeType == other.nodeType && nodeName == other.nodeName && nodeValue == other.nodeValue else { return false }
        guard localName == other.localName && namespaceURI == other.namespaceURI && prefix == other.prefix else { return false }
        guard attributes == other.attributes && count == other.count else { return false }
        for (i, node): (Int, Node) in enumerated() { if !node.isEqualTo(other[i]) { return false } }
        return true
    }

    open func isSameNode(as otherNode: Node) -> Bool {
        if let other: NodeImpl = (otherNode as? NodeImpl) { return (self === other) }
        else { return false }
    }

    open func isDefaultNamespace(namespaceURI uri: String) -> Bool {
        /* TODO: Implement me... */
        fatalError("isDefaultNamespace(namespaceURI:) has not been implemented")
    }

    open func lookupNamespaceURL(prefix: String) -> String? {
        /* TODO: Implement me... */
        fatalError("lookupNamespaceURL(prefix:) has not been implemented")
    }

    open func lookupPrefix(namespaceURI uri: String) -> String? {
        /* TODO: Implement me... */
        fatalError("lookupPrefix(namespaceURI:) has not been implemented")
    }

    open func asHashable() -> AnyNode {
        AnyNode(self)
    }

    open func hash(into hasher: inout Hasher) {
        hasher.combine(nodeType)
        hasher.combine(nodeName)
        hasher.combine(owningDocument.asHashable())
        hasher.combine(parentNode?.asHashable())
    }

    open subscript(bounds: Range<Int>) -> ArraySlice<Node> {
        NodeImpl._emptyNodeArray[bounds]
    }

    open subscript(position: Int) -> Node {
        NodeImpl._emptyNodeArray[position]
    }

    func removeAllChildren() {
        var children: [Node] = []
        for child: Node in self { children.append(child) }
        for child: Node in children { remove(childNode: child) }
    }

    public static func == (lhs: NodeImpl, rhs: NodeImpl) -> Bool { lhs === rhs }
}
