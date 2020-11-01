/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: Document.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/15/20
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

public protocol DocumentNode: Node {
//@f:0
    var docType               : DocumentTypeNode? { get     }
    var documentElement       : ElementNode       { get     }
    var documentURI           : String?           { get set }
    var inputEncoding         : String.Encoding   { get     }
    var isStrictErrorChecking : Bool              { get set }
    var xmlEncoding           : String            { get     }
    var xmlStandalone         : Bool              { get set }
    var xmlVersion            : String            { get set }
//@f:1

    func adopt(node: Node) -> Node

    func createAttribute(name: String) -> AttributeNode

    func createAttribute(namespaceURI: String, name: String) -> AttributeNode

    func createElement(name: String) -> ElementNode

    func createElement(namespaceURI: String, name: String) -> ElementNode

    func createTextNode(content: String) -> TextNode

    func createCDataSectionNode(content: String) -> CDataSectionNode

    func createComment(content: String) -> CommentNode

    func createDocumentFragment() -> DocumentFragmentNode

    func createProcessingInstruction(data: String, target: String) -> ProcessingInstructionNode

    func createNotation(name: String, publicId: String, systemId: String) -> NotationNode

    func createDocType(name: String, publicId: String, systemId: String, internalSubset: String) -> DocumentTypeNode

    func normalizeDocument()

    func getElementBy(elementId: String) -> ElementNode?

    func getElementsBy(name: String) -> NodeList<ElementNode>

    func getElementsBy(namespaceURI: String, name: String) -> NodeList<ElementNode>

    func importNode(node: Node, deep: Bool) -> Node

    @discardableResult func renameNode(node: Node, namespaceURI: String, qualifiedName: String) -> Node

    @discardableResult func renameNode(node: Node, nodeName: String) -> Node
}

public class AnyDocumentNode: AnyNode, DocumentNode {

    var document: DocumentNode { node as! DocumentNode }

    public init(_ document: DocumentNode) { super.init(document) }

//@f:0
    public var docType         : DocumentTypeNode? { document.docType         }
    public var documentElement : ElementNode       { document.documentElement }
    public var inputEncoding   : String.Encoding   { document.inputEncoding   }
    public var xmlEncoding     : String            { document.xmlEncoding     }

    public var documentURI           : String? { get { document.documentURI           } set { document.documentURI = newValue           } }
    public var isStrictErrorChecking : Bool    { get { document.isStrictErrorChecking } set { document.isStrictErrorChecking = newValue } }
    public var xmlStandalone         : Bool    { get { document.xmlStandalone         } set { document.xmlStandalone = newValue         } }
    public var xmlVersion            : String  { get { document.xmlVersion            } set { document.xmlVersion = newValue            } }
//@f:1

    public func adopt(node: Node) -> Node {
        document.adopt(node: node)
    }

    public func createAttribute(name: String) -> AttributeNode {
        document.createAttribute(name: name)
    }

    public func createAttribute(namespaceURI: String, name: String) -> AttributeNode {
        document.createAttribute(namespaceURI: namespaceURI, name: name)
    }

    public func createElement(name: String) -> ElementNode {
        document.createElement(name: name)
    }

    public func createElement(namespaceURI: String, name: String) -> ElementNode {
        document.createElement(namespaceURI: namespaceURI, name: name)
    }

    public func createTextNode(content: String) -> TextNode {
        document.createTextNode(content: content)
    }

    public func createCDataSectionNode(content: String) -> CDataSectionNode {
        document.createCDataSectionNode(content: content)
    }

    public func createComment(content: String) -> CommentNode {
        document.createComment(content: content)
    }

    public func createDocumentFragment() -> DocumentFragmentNode {
        document.createDocumentFragment()
    }

    public func normalizeDocument() {
        document.normalizeDocument()
    }

    public func getElementBy(elementId: String) -> ElementNode? {
        document.getElementBy(elementId: elementId)
    }

    public func getElementsBy(name: String) -> NodeList<ElementNode> {
        document.getElementsBy(name: name)
    }

    public func getElementsBy(namespaceURI: String, name: String) -> NodeList<ElementNode> {
        document.getElementsBy(namespaceURI: namespaceURI, name: name)
    }

    public func importNode(node: Node, deep: Bool) -> Node {
        document.importNode(node: node, deep: deep)
    }

    @discardableResult public func renameNode(node: Node, namespaceURI: String, qualifiedName: String) -> Node {
        document.renameNode(node: node, namespaceURI: namespaceURI, qualifiedName: qualifiedName)
    }

    @discardableResult public func renameNode(node: Node, nodeName: String) -> Node {
        document.renameNode(node: node, nodeName: nodeName)
    }

    public func createProcessingInstruction(data: String, target: String) -> ProcessingInstructionNode {
        document.createProcessingInstruction(data: data, target: target)
    }

    public func createNotation(name: String, publicId: String, systemId: String) -> NotationNode {
        document.createNotation(name: name, publicId: publicId, systemId: systemId)
    }

    public func createDocType(name: String, publicId: String, systemId: String, internalSubset: String) -> DocumentTypeNode {
        document.createDocType(name: name, publicId: publicId, systemId: systemId, internalSubset: internalSubset)
    }
}
