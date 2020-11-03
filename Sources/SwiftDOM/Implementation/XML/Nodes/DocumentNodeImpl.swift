/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: DocumentNodeImpl.swift
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

public class DocumentNodeImpl: ParentNodeImpl, DocumentNode {
    //@f:0
    public override      var nodeType              : NodeTypes         { .DocumentNode }
    public internal(set) var docType               : DocumentTypeNode? = nil
    public               var documentElement       : ElementNode?      = nil
    public internal(set) var inputEncoding         : String.Encoding   = String.Encoding.utf8
    public               var documentURI           : String?           = nil
    public internal(set) var xmlEncoding           : String            = ""
    public               var xmlVersion            : String            = ""
    public               var xmlStandalone         : Bool              = false
    public               var isStrictErrorChecking : Bool              = false
    //@f:1

    public override init() { super.init() }

    public func adopt(node: Node) -> Node {
        fatalError("adopt(node:) has not been implemented")
        /* TODO: Implement me... */
    }

    public func createAttribute(name: String) -> AttributeNode {
        fatalError("createAttribute(name:) has not been implemented")
        /* TODO: Implement me... */
    }

    public func createAttribute(namespaceURI: String, name: String) -> AttributeNode {
        fatalError("createAttribute(namespaceURI:name:) has not been implemented")
        /* TODO: Implement me... */
    }

    public func createElement(name: String) -> ElementNode {
        fatalError("createElement(name:) has not been implemented")
        /* TODO: Implement me... */
    }

    public func createElement(namespaceURI: String, name: String) -> ElementNode {
        fatalError("createElement(namespaceURI:name:) has not been implemented")
        /* TODO: Implement me... */
    }

    public func createTextNode(content: String) -> TextNode {
        fatalError("createTextNode(content:) has not been implemented")
        /* TODO: Implement me... */
    }

    public func createCDataSectionNode(content: String) -> CDataSectionNode {
        fatalError("createCDataSectionNode(content:) has not been implemented")
        /* TODO: Implement me... */
    }

    public func createComment(content: String) -> CommentNode {
        fatalError("createComment(content:) has not been implemented")
        /* TODO: Implement me... */
    }

    public func createDocumentFragment() -> DocumentFragmentNode {
        fatalError("createDocumentFragment() has not been implemented")
        /* TODO: Implement me... */
    }

    public func createProcessingInstruction(data: String, target: String) -> ProcessingInstructionNode {
        fatalError("createProcessingInstruction(data:target:) has not been implemented")
        /* TODO: Implement me... */
    }

    public func createNotation(name: String, publicId: String, systemId: String) -> NotationNode {
        fatalError("createNotation(name:publicId:systemId:) has not been implemented")
        /* TODO: Implement me... */
    }

    public func createDocType(name: String, publicId: String, systemId: String, internalSubset: String) -> DocumentTypeNode {
        fatalError("createDocType(name:publicId:systemId:internalSubset:) has not been implemented")
        /* TODO: Implement me... */
    }

    public func normalizeDocument() { /* TODO: Implement me... */ }

    public func getElementBy(elementId: String) -> ElementNode? {
        fatalError("getElementBy(elementId:) has not been implemented")
        /* TODO: Implement me... */
    }

    public func getElementsBy(name: String) -> NodeList<ElementNode> {
        fatalError("getElementsBy(name:) has not been implemented")
        /* TODO: Implement me... */
    }

    public func getElementsBy(namespaceURI: String, name: String) -> NodeList<ElementNode> {
        fatalError("getElementsBy(namespaceURI:name:) has not been implemented")
        /* TODO: Implement me... */
    }

    public func importNode(node: Node, deep: Bool) -> Node {
        fatalError("importNode(node:deep:) has not been implemented")
        /* TODO: Implement me... */
    }

    public func renameNode(node: Node, namespaceURI: String, qualifiedName: String) -> Node {
        fatalError("renameNode(node:namespaceURI:qualifiedName:) has not been implemented")
        /* TODO: Implement me... */
    }

    public func renameNode(node: Node, nodeName: String) -> Node {
        fatalError("renameNode(node:nodeName:) has not been implemented")
        /* TODO: Implement me... */
    }
}
