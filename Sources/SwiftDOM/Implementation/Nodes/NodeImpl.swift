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

    open internal(set) var isReadOnly: Bool    = false
    open internal(set) var baseURI:    String? = nil

    @inlinable open var nodeType:        NodeTypes { fatalError("No Node Type for this node.") }
    @inlinable open var nodeName:        String { "" }
    @inlinable open var localName:       String? { nil }
    @inlinable open var namespaceURI:    String? { nil }
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
    @inlinable open var prefix:          String? {
        get { nil }
        set {}
    }
    @inlinable open var nodeValue:       String? {
        get { nil }
        set {}
    }
    @inlinable open var textContent:     String? {
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
    @inlinable open var owningDocument: DocumentNode {
        get { _owningDocument }
        set {
            if let newDoc: DocumentNodeImpl = newValue as? DocumentNodeImpl {
                _owningDocument = newDoc
                attributes.forEach { ($0 as! AttributeNodeImpl).owningDocument = newDoc }
                forEach { ($0 as! ElementNodeImpl).owningDocument = newDoc }
            }
        }
    }

    @usableFromInline var _userData:       [String: UserDataInfo] = [:]
    @usableFromInline var _owningDocument: DocumentNodeImpl!      = nil

    internal init() {}

    @usableFromInline init(_ owningDocument: DocumentNodeImpl) {
        _owningDocument = owningDocument
    }

    deinit {
        triggerUserData(event: .Deleted, src: nil, dst: nil)
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
        guard let od: DocumentNodeImpl = _owningDocument else { fatalError("Unable to clone node.") }
        return _clone(od, postEvent: true, deep: deep)
    }

    @usableFromInline func _clone(_ doc: DocumentNodeImpl, postEvent: Bool, deep: Bool) -> NodeImpl {
        var theClone: NodeImpl? = nil

        switch nodeType {
            case .AttributeNode:
                if let me: AttributeNode = (self as? AttributeNode) {
                    let clone: AttributeNodeImpl = (me.hasNamespace ? AttributeNodeImpl(doc, namespaceURI: me.namespaceURI!, qualifiedName: me.nodeName, value: me.value)
                                                                    : AttributeNodeImpl(doc, attributeName: me.name, value: me.value))
                    clone.isId = me.isId
                    clone.isSpecified = true
                    theClone = clone
                }
            case .CDataSectionNode:
                theClone = CDataSectionNodeImpl(doc, content: textContent ?? "")
            case .CommentNode:
                theClone = CommentNodeImpl(doc, content: textContent ?? "")
            case .DocumentFragmentNode:
                if let me: DocumentFragmentNodeImpl = (self as? DocumentFragmentNodeImpl) {
                    let clone = DocumentFragmentNodeImpl(doc)
                    if deep { me.forEachChild { clone.append(child: $0._clone(doc, postEvent: postEvent, deep: deep)) } }
                    theClone = clone
                }
            case .DocumentNode:
                if let me: DocumentNodeImpl = self as? DocumentNodeImpl {
                    let clone = DocumentNodeImpl()
                    clone.isStrictErrorChecking = me.isStrictErrorChecking
                    clone.inputEncoding = me.inputEncoding
                    clone.xmlEncoding = me.xmlEncoding
                    clone.xmlVersion = me.xmlVersion
                    clone.xmlStandalone = me.xmlStandalone
                    clone.documentURI = me.documentURI
                    if deep { me.forEachChild { clone.append(child: $0._clone(clone, postEvent: postEvent, deep: deep)); return false } }
                    theClone = clone
                }
            case .DocumentTypeNode:
                if let me: DocumentTypeNodeImpl = (self as? DocumentTypeNodeImpl) {
                    let docType = DocumentTypeNodeImpl(doc, name: me.name, publicId: me.publicId, systemId: me.systemId, internalSubset: me.internalSubset)
                    docType.entities = me.entities.clone()
                    docType.notations = me.notations.clone()
                    theClone = docType
                }
            case .ElementNode:
                if let me: ElementNodeImpl = (self as? ElementNodeImpl) {
                    let elem: ElementNodeImpl = (me.hasNamespace ? ElementNodeImpl(doc, namespaceURI: me.namespaceURI!, qualifiedName: me.tagName) : ElementNodeImpl(doc, tagName: me.tagName))
                    me.forEachAttribute { elem._attributes.append($0._clone(doc, postEvent: postEvent, deep: deep)) }
                    if deep { me.forEachChild { elem.append(child: $0._clone(doc, postEvent: postEvent, deep: deep)) } }
                    theClone = elem
                }
            case .EntityNode:
                if let me: EntityNodeImpl = (self as? EntityNodeImpl) {
                    let ent = EntityNodeImpl(doc,
                                             entityName: me.nodeName,
                                             notationName: me.notationName,
                                             publicId: me.publicId,
                                             systemId: me.systemId,
                                             xmlEncoding: me.xmlEncoding,
                                             xmlVersion: me.xmlVersion)
                    if deep { me.forEachChild { ent.append(child: $0._clone(doc, postEvent: postEvent, deep: deep)) } }
                    theClone = ent
                }
            case .EntityReferenceNode:
                if let me: EntityRefNodeImpl = (self as? EntityRefNodeImpl) {
                    let entRef = EntityRefNodeImpl(doc, entityName: me.nodeName)
                    if deep { me.forEachChild { entRef.append(child: $0._clone(doc, postEvent: postEvent, deep: deep)) } }
                    theClone = entRef
                }
            case .NotationNode:
                if let me: NotationNode = (self as? NotationNode) { theClone = NotationNodeImpl(doc, name: nodeName, publicId: me.publicId, systemId: me.systemId) }
            case .ProcessingInstructionNode:
                theClone = ProcessingInstructionNodeImpl(doc, data: nodeName, target: nodeValue ?? "")
            case .TextNode:
                theClone = TextNodeImpl(doc, content: textContent ?? "")
        }

        guard let tc: NodeImpl = theClone else { fatalError("Unable to clone node.") }
        if postEvent { triggerUserData(event: .Cloned, src: self, dst: tc) }
        return tc
    }

    @usableFromInline func triggerUserData(event: UserDataEvents, src: Node?, dst: Node?) {
        for (key, userDataInfo): (String, UserDataInfo) in _userData {
            if let h: UserDataHandler = userDataInfo.body {
                h(event, key, userDataInfo.data, src, dst)
            }
        }
    }

    @inlinable open func contains(_ node: Node) -> Bool {
        contains { $0.isSameNode(as: node) }
    }

    @inlinable open func isEqualTo(_ other: Node) -> Bool {
        guard nodeType == other.nodeType && nodeName == other.nodeName && nodeValue == other.nodeValue else { return false }
        guard localName == other.localName && namespaceURI == other.namespaceURI && prefix == other.prefix else { return false }
        guard attributes == other.attributes && count == other.count else { return false }
        for (i, node): (Int, Node) in enumerated() { if !node.isEqualTo(other[i]) { return false } }
        return true
    }

    @inlinable open func isSameNode(as otherNode: Node) -> Bool {
        if let other: NodeImpl = (otherNode as? NodeImpl) { return (self === other) }
        else { return false }
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

    @inlinable func removeAllChildren() {
        var children: [Node] = []
        for child: Node in self { children.append(child) }
        for child: Node in children { remove(childNode: child) }
    }

    @inlinable public static func == (lhs: NodeImpl, rhs: NodeImpl) -> Bool { lhs === rhs }
}
