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

    @usableFromInline static let _emptyAttributes: NamedNodeMap<AttributeNode> = NamedNodeMap()
    @usableFromInline static let _emptyNodeArray:  Array<Node>                 = []

    open internal(set) var isReadOnly: Bool = false

    @inlinable open var nodeType:        NodeTypes { fatalError("No Node Type for this node.") }
    @inlinable open var nodeName:        String { "" }
    @inlinable open var localName:       String? { nil }
    @inlinable open var namespaceURI:    String? { nil }
    @inlinable open var baseURI:         String? { nil }
    @inlinable open var owningDocument:  DocumentNode { _owningDocument }
    @inlinable open var parentNode:      Node? { nil }
    @inlinable open var firstChild:      Node? { nil }
    @inlinable open var lastChild:       Node? { nil }
    @inlinable open var nextSibling:     Node? { nil }
    @inlinable open var previousSibling: Node? { nil }
    @inlinable open var hasAttributes:   Bool { false }
    @inlinable open var hasChildNodes:   Bool { false }
    @inlinable open var hasNamespace:    Bool { !(namespaceURI?.isEmpty ?? true) }
    @inlinable open var startIndex:      Int { 0 }
    @inlinable open var endIndex:        Int { 0 }
    @inlinable open var attributes:      NamedNodeMap<AttributeNode> { NodeImpl._emptyAttributes }

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

    @usableFromInline var _userData:       [String: UserDataInfo] = [:]
    @usableFromInline var _owningDocument: DocumentNodeImpl!      = nil

    internal init() {}

    @usableFromInline init(_ owningDocument: DocumentNodeImpl) {
        _owningDocument = owningDocument
    }

    @inlinable open func normalize() {}

    @discardableResult @inlinable open func insert(childNode: Node, before refNode: Node?) -> Node { childNode }

    @discardableResult @inlinable open func remove(childNode: Node) -> Node { childNode }

    @discardableResult @inlinable open func append(child childNode: Node) -> Node {
        let ref: NodeImpl? = nil
        return insert(childNode: childNode, before: ref)
    }

    @discardableResult @inlinable open func replace(childNode oldChildNode: Node, with newChildNode: Node) -> Node {
        insert(childNode: newChildNode, before: oldChildNode)
        return remove(childNode: oldChildNode)
    }

    @inlinable open func userData(key: String) -> Any? {
        _userData[key]?.data
    }

    @inlinable open func setUserData(key: String, userData: Any?, handler: UserDataHandler?) {
        if let ud: Any = userData { _userData[key] = UserDataInfo(data: ud, body: handler) }
        else { _userData.removeValue(forKey: key) }
    }

    @inlinable open func cloneNode(deep: Bool) -> Node {
        switch nodeType {
            case .AttributeNode:
                if let me: AttributeNode = (self as? AttributeNode) {
                    let clone: AttributeNode = (me.hasNamespace ? owningDocument.createAttribute(namespaceURI: me.namespaceURI!, name: me.localName!) : owningDocument.createAttribute(name: me.name))
                    clone.nodeValue = me.value
                    return clone
                }
            case .CDataSectionNode:
                return owningDocument.createCDataSectionNode(content: textContent ?? "")
            case .CommentNode:
                return owningDocument.createComment(content: textContent ?? "")
            case .DocumentFragmentNode: break // TODO: Finish...
            case .DocumentNode:         break // TODO: Finish...
            case .DocumentTypeNode:     break // TODO: Finish...
            case .ElementNode:          break // TODO: Finish...
            case .EntityNode:           break // TODO: Finish...
            case .EntityReferenceNode:  break // TODO: Finish...
            case .NotationNode:
                if let me: NotationNode = (self as? NotationNode) { return owningDocument.createNotation(publicId: me.publicId, systemId: me.systemId) }
            case .ProcessingInstructionNode:
                if let me: ProcessingInstructionNode = (self as? ProcessingInstructionNode) { return owningDocument.createProcessingInstruction(data: me.data, target: me.target) }
            case .TextNode:
                return owningDocument.createTextNode(content: textContent ?? "")
        }

        fatalError("Unable to clone node.")
    }

    @inlinable open func contains(_ node: Node) -> Bool {
        contains { $0.isSameNode(as: node) }
    }

    @inlinable open func isEqualTo(_ other: Node) -> Bool {
        guard nodeType == other.nodeType && nodeName == other.nodeName && nodeValue == other.nodeValue else { return false }
        guard localName == other.localName && namespaceURI == other.namespaceURI && prefix == other.prefix else { return false }
        guard attributes == other.attributes && count == other.count else { return false }
        for (i, node) in enumerated() { if !node.isEqualTo(other[i]) { return false } }
        return true
    }

    @inlinable open func isSameNode(as otherNode: Node) -> Bool {
        // This method will work for NodeImpl or any of it's subclasses.
        guard let otherNode: NodeImpl = (otherNode as? NodeImpl) else { return false }
        return (self === otherNode)
    }

    @inlinable open func isDefaultNamespace(namespaceURI uri: String) -> Bool {
        /* TODO: Implement me... */
        fatalError("isDefaultNamespace(namespaceURI:) has not been implemented")
    }

    @inlinable open func lookupNamespaceURL(prefix: String) -> String? {
        /* TODO: Implement me... */
        fatalError("lookupNamespaceURL(prefix:) has not been implemented")
    }

    @inlinable open func lookupPrefix(namespaceURI uri: String) -> String? {
        /* TODO: Implement me... */
        fatalError("lookupPrefix(namespaceURI:) has not been implemented")
    }

    @inlinable open func asHashable() -> AnyNode {
        AnyNode(self)
    }

    @inlinable open func hash(into hasher: inout Hasher) {
        hasher.combine(nodeType)
        hasher.combine(nodeName)
        hasher.combine(owningDocument.asHashable())
        hasher.combine(parentNode?.asHashable())
    }

    @inlinable open subscript(bounds: Range<Int>) -> ArraySlice<Node> {
        NodeImpl._emptyNodeArray[bounds]
    }

    @inlinable open subscript(position: Int) -> Node {
        NodeImpl._emptyNodeArray[position]
    }

    @inlinable public static func == (lhs: NodeImpl, rhs: NodeImpl) -> Bool { lhs === rhs }
}
