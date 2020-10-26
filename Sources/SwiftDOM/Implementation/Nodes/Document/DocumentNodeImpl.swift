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

open class DocumentNodeImpl: NodeImpl, DocumentNode {

    open internal(set) var docType:         DocumentTypeNode? = nil
    open internal(set) var documentElement: ElementNode?      = nil
    open internal(set) var inputEncoding:   String.Encoding   = String.Encoding.utf8
    open internal(set) var xmlEncoding:     String            = "UTF-8"

    open var documentURI:           String? = nil
    open var isStrictErrorChecking: Bool    = false
    open var xmlStandalone:         Bool    = false
    open var xmlVersion:            String  = ""

    @inlinable open override var nodeType: NodeTypes { .DocumentNode }
    @inlinable open override var nodeName: String { "#document" }

    public override init() {
        super.init()
        _owningDocument = self
    }

    @inlinable open func adopt(node: Node) -> Node { /* TODO: Implement me... */ fatalError("adopt(node:) has not been implemented") }

    @inlinable open func createAttribute(name: String) -> AttributeNode { /* TODO: Implement me... */ fatalError("createAttribute(name:) has not been implemented") }

    @inlinable open func createAttribute(namespaceURI: String, name: String) -> AttributeNode { /* TODO: Implement me... */fatalError("createAttribute(namespaceURI:name:) has not been implemented") }

    @inlinable open func createElement(name: String) -> ElementNode { /* TODO: Implement me... */ fatalError("createElement(name:) has not been implemented") }

    @inlinable open func createElement(namespaceURI: String, name: String) -> ElementNode { /* TODO: Implement me... */ fatalError("createElement(namespaceURI:name:) has not been implemented") }

    @inlinable open func createTextNode(content: String) -> TextNode { /* TODO: Implement me... */ fatalError("createTextNode(content:) has not been implemented") }

    @inlinable open func createCDataSectionNode(content: String) -> CDataSectionNode { /* TODO: Implement me... */ fatalError("createCDataSectionNode(content:) has not been implemented") }

    @inlinable open func createComment(content: String) -> CommentNode { /* TODO: Implement me... */ fatalError("createComment(content:) has not been implemented") }

    @inlinable open func createDocumentFragment() -> DocumentFragmentNode { /* TODO: Implement me... */ fatalError("createDocumentFragment() has not been implemented") }

    @inlinable open func createProcessingInstruction(data: String, target: String) -> ProcessingInstructionNode { /* TODO: Implement me... */ fatalError("createProcessingInstruction()") }

    @inlinable open func createNotation(publicId: String, systemId: String) -> NotationNode { fatalError("createNotation(publicId:systemId:) has not been implemented") /* TODO: Implement me... */ }

    @inlinable open func createDocType(name: String, publicId: String, systemId: String) -> DocumentTypeNode { fatalError("createDocType(name:publicId:systemId:)") /* TODO: Implement me... */ }

    @inlinable open func normalizeDocument() { /* TODO: Implement me... */ }

    @inlinable open func getElementBy(elementId: String) -> ElementNode? { /* TODO: Implement me... */ fatalError("getElementBy(elementId:) has not been implemented") }

    @inlinable open func getElementsBy(name: String) -> NodeList<AnyElementNode> { /* TODO: Implement me... */ fatalError("getElementsBy(name:) has not been implemented") }

    @inlinable open func getElementsBy(namespaceURI: String, name: String) -> NodeList<AnyElementNode> { /* TODO: Implement me... */ fatalError("getElementsBy(namespaceURI:name:)") }

    @inlinable open func importNode(node: Node, deep: Bool) -> Node { /* TODO: Implement me... */ fatalError("importNode(node:deep:) has not been implemented") }

    @inlinable open func renameNode(node: Node, namespaceURI: String, qualifiedName: String) -> Node { /* TODO: Implement me... */ fatalError("renameNode(node:namespaceURI:qualifiedName:)") }

    @inlinable public static func == (lhs: DocumentNodeImpl, rhs: DocumentNodeImpl) -> Bool { lhs === rhs }
}
