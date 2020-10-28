/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: DocumentNodeImpl.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/23/20
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

open class DocumentNodeImpl: ParentNode, DocumentNode {

    open internal(set) var docType:       DocumentTypeNode? = nil
    open internal(set) var inputEncoding: String.Encoding   = String.Encoding.utf8
    open internal(set) var xmlEncoding:   String            = "UTF-8"

    open var documentURI:           String? = nil
    open var isStrictErrorChecking: Bool    = false
    open var xmlStandalone:         Bool    = false
    open var xmlVersion:            String  = ""

    open override var nodeType:    NodeTypes { .DocumentNode }
    open override var nodeName:    String { "#document" }
    open override var textContent: String? {
        get { nil }
        set {}
    }

    open var documentElement: ElementNode {
        if _docElem == nil {
            insert(childNode: ElementNodeImpl(self, tagName: "root"), before: nil)
        }
        return _docElem!
    }

    var _docElem: ElementNodeImpl?      = nil
    var _docType: DocumentTypeNodeImpl? = nil

    public override init() {
        super.init()
        _owningDocument = self
    }

    @discardableResult open override func insert(childNode: Node, before refNode: Node?) -> Node {
        switch childNode.nodeType {
            case .ElementNode:
                if let _ = _docElem { fatalError("Document element already exists.") }
                _docElem = (childNode as! ElementNodeImpl)
                if refNode?.nodeType == .DocumentTypeNode { super.insert(childNode: childNode, before: refNode?.nextSibling) }
                else { super.insert(childNode: childNode, before: refNode) }
                return childNode
            case .DocumentTypeNode:
                if let dt: DocumentTypeNodeImpl = _docType { remove(childNode: dt) }
                _docType = (childNode as! DocumentTypeNodeImpl)
                return super.insert(childNode: childNode, before: _firstChild)
            case .CommentNode:
                return super.insert(childNode: childNode, before: refNode)
            case .ProcessingInstructionNode:
                return super.insert(childNode: childNode, before: refNode)
            default: fatalError("Incorrect node type.")
        }
    }

    open func adopt(node: Node) -> Node {
        guard let node: NodeImpl = (node as? NodeImpl) else { fatalError("Cannot adopt node.") }
        node.owningDocument = self
        node.triggerUserData(event: .Adopted, src: node, dst: nil)
        return node
    }

    open func createAttribute(name: String) -> AttributeNode {
        AttributeNodeImpl(self, attributeName: name, value: "")
    }

    open func createAttribute(namespaceURI: String, name: String) -> AttributeNode {
        AttributeNodeImpl(self, namespaceURI: namespaceURI, qualifiedName: name, value: "")
    }

    open func createElement(name: String) -> ElementNode {
        ElementNodeImpl(self, tagName: name)
    }

    open func createElement(namespaceURI: String, name: String) -> ElementNode {
        ElementNodeImpl(self, namespaceURI: namespaceURI, qualifiedName: name)
    }

    open func createTextNode(content: String) -> TextNode {
        TextNodeImpl(self, content: content)
    }

    open func createCDataSectionNode(content: String) -> CDataSectionNode {
        CDataSectionNodeImpl(self, content: content)
    }

    open func createComment(content: String) -> CommentNode {
        CommentNodeImpl(self, content: content)
    }

    open func createDocumentFragment() -> DocumentFragmentNode {
        DocumentFragmentNodeImpl(self)
    }

    open func createProcessingInstruction(data: String, target: String) -> ProcessingInstructionNode {
        ProcessingInstructionNodeImpl(self, data: data, target: target)
    }

    open func createNotation(name: String, publicId: String, systemId: String) -> NotationNode {
        NotationNodeImpl(self, name: name, publicId: publicId, systemId: systemId)
    }

    open func createDocType(name: String, publicId: String, systemId: String, internalSubset: String) -> DocumentTypeNode {
        DocumentTypeNodeImpl(self, name: name, publicId: publicId, systemId: systemId, internalSubset: internalSubset)
    }

    open func normalizeDocument() {
        /* TODO: Implement me... */
    }

    open func getElementBy(elementId id: String) -> ElementNode? {
        guard let parent: ElementNodeImpl = _docElem else { return nil }
        var elem: ElementNodeImpl? = nil
        parent.forEachChild(deep: true) { if let e: ElementNodeImpl = ($0 as? ElementNodeImpl) { if e._attributes.contains(where: { $0.isId && $0.value == id }) { elem = e } } }
        return elem
    }

    open func getElementsBy(name: String) -> NodeList<ElementNode> {
        ElementNodeListImpl(documentElement as! ElementNodeImpl, nodeName: name)
    }

    open func getElementsBy(namespaceURI: String, name: String) -> NodeList<ElementNode> {
        ElementNodeListImpl(documentElement as! ElementNodeImpl, namespaceURI: namespaceURI, localName: name)
    }

    open func importNode(node: Node, deep: Bool) -> Node {
        guard let node: NodeImpl = (node as? NodeImpl) else { fatalError("Unable to import node.") }
        let clone: NodeImpl = node.baseClone(self, postEvent: false, deep: deep)
        node.triggerUserData(event: .Imported, src: node, dst: clone)
        return clone
    }

    @discardableResult open func renameNode(node: Node, namespaceURI: String, qualifiedName: String) -> Node {
        guard let nsNode: NamespaceNode = (node as? NamespaceNode) else { fatalError("Node cannot be renamed.") }
        nsNode.rename(namespaceURI: namespaceURI, qualifiedName: qualifiedName)
        return node
    }

    @discardableResult open func renameNode(node: Node, nodeName: String) -> Node {
        guard let namedNode: NamedNode = (node as? NamedNode) else { fatalError("Node cannot be renamed.") }
        namedNode._nodeName = nodeName
        return node
    }

    open override func baseClone(_ doc: DocumentNodeImpl, postEvent: Bool, deep: Bool) -> NodeImpl {
        let d = DocumentNodeImpl()
        d.inputEncoding = inputEncoding
        d.xmlEncoding = xmlEncoding
        d.xmlStandalone = xmlStandalone
        d.xmlVersion = xmlVersion
        d.documentURI = documentURI
        d.isStrictErrorChecking = isStrictErrorChecking
        if deep { forEachChild { d.append(child: $0.cloneNode(d, postEvent: postEvent, deep: deep)) } }
        return d
    }

    public static func == (lhs: DocumentNodeImpl, rhs: DocumentNodeImpl) -> Bool { lhs === rhs }
}
