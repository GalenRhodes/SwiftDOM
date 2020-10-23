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
    var docType:               DocumentTypeNode { get }
    var documentElement:       ElementNode { get }
    var documentURI:           String? { get set }
    var inputEncoding:         String.Encoding { get }
    var isStrictErrorChecking: Bool { get set }
    var xmlStandalone:         Bool { get set }
    var xmlEncoding:           String { get }
    var xmlVersion:            String { get set }

    func adopt<T: Node>(node: T) -> T

    func createAttribute(name: String) -> AttributeNode

    func createAttribute(namespaceURI: String, name: String) -> AttributeNode

    func createElement(name: String) -> ElementNode

    func createElement(namespaceURI: String, name: String) -> ElementNode

    func createTextNode(content: String) -> TextNode

    func createCDataSectionNode(content: String) -> CDataSectionNode

    func createComment(content: String) -> CommentNode

    func createDocumentFragment() -> DocumentFragmentNode

    func normalizeDocument()

    func getElementBy(elementId: String) -> ElementNode?

    func getElementsBy(name: String) -> NodeList<AnyElementNode>

    func getElementsBy(namespaceURI: String, name: String) -> NodeList<AnyElementNode>

    func importNode<T: Node>(node: T, deep: Bool) -> T

    func renameNode<T: Node>(node: T, namespaceURI: String, qualifiedName: String) -> T
}

open class AnyDocumentNode: AnyNode, DocumentNode {

    @inlinable var document: DocumentNode { node as! DocumentNode }

    public init(_ document: DocumentNode) { super.init(document) }

    @inlinable open var docType:         DocumentTypeNode { document.docType }
    @inlinable open var documentElement: ElementNode { document.documentElement }
    @inlinable open var inputEncoding:   String.Encoding { document.inputEncoding }
    @inlinable open var xmlEncoding:     String { document.xmlEncoding }

    @inlinable open var documentURI:           String? {
        get { document.documentURI }
        set { document.documentURI = newValue }
    }
    @inlinable open var isStrictErrorChecking: Bool {
        get { document.isStrictErrorChecking }
        set { document.isStrictErrorChecking = newValue }
    }
    @inlinable open var xmlStandalone:         Bool {
        get { document.xmlStandalone }
        set { document.xmlStandalone = newValue }
    }
    @inlinable open var xmlVersion:            String {
        get { document.xmlVersion }
        set { document.xmlVersion = newValue }
    }

    @inlinable open func adopt<T: Node>(node: T) -> T {
        document.adopt(node: node)
    }

    @inlinable open func createAttribute(name: String) -> AttributeNode {
        document.createAttribute(name: name)
    }

    @inlinable open func createAttribute(namespaceURI: String, name: String) -> AttributeNode {
        document.createAttribute(namespaceURI: namespaceURI, name: name)
    }

    @inlinable open func createElement(name: String) -> ElementNode {
        document.createElement(name: name)
    }

    @inlinable open func createElement(namespaceURI: String, name: String) -> ElementNode {
        document.createElement(namespaceURI: namespaceURI, name: name)
    }

    @inlinable open func createTextNode(content: String) -> TextNode {
        document.createTextNode(content: content)
    }

    @inlinable open func createCDataSectionNode(content: String) -> CDataSectionNode {
        document.createCDataSectionNode(content: content)
    }

    @inlinable open func createComment(content: String) -> CommentNode {
        document.createComment(content: content)
    }

    @inlinable open func createDocumentFragment() -> DocumentFragmentNode {
        document.createDocumentFragment()
    }

    @inlinable open func normalizeDocument() {
        document.normalizeDocument()
    }

    @inlinable open func getElementBy(elementId: String) -> ElementNode? {
        document.getElementBy(elementId: elementId)
    }

    @inlinable open func getElementsBy(name: String) -> NodeList<AnyElementNode> {
        document.getElementsBy(name: name)
    }

    @inlinable open func getElementsBy(namespaceURI: String, name: String) -> NodeList<AnyElementNode> {
        document.getElementsBy(namespaceURI: namespaceURI, name: name)
    }

    @inlinable open func importNode<T: Node>(node: T, deep: Bool) -> T {
        document.importNode(node: node, deep: deep)
    }

    @inlinable open func renameNode<T: Node>(node: T, namespaceURI: String, qualifiedName: String) -> T {
        document.renameNode(node: node, namespaceURI: namespaceURI, qualifiedName: qualifiedName)
    }
}
