/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: AttributeNodeImpl.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 11/2/20
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

public class AttributeNodeImpl: NamedNodeImpl, AttributeNode {
//@f:0
    public               var isId           : Bool         = false
    public               var isSpecified    : Bool         = false
    public               var name           : String       { nodeName                                                    }
    public               var ownerElement   : ElementNode? = nil
    public               var schemaTypeInfo : TypeInfo?    = nil
    public               var value          : String       { get { textContent } set { textContent = newValue         }  }
    public override      var nodeValue      : String?      { get { textContent } set { textContent = (newValue ?? "") }  }
//@f:1

    public init(_ owningDocument: DocumentNode, nodeName: String, value: String, isId: Bool, isSpecified: Bool, ownerElement: ElementNode?, schemaTypeInfo: TypeInfo?) {
        self.isId = isId
        self.isSpecified = isSpecified
        self.ownerElement = ownerElement
        self.schemaTypeInfo = schemaTypeInfo
        super.init(owningDocument, nodeName: nodeName)
    }

    public init(_ owningDocument: DocumentNode, namespaceURI: String, qualifiedName: String, value: String, isId: Bool, isSpecified: Bool, ownerElement: ElementNode?, schemaTypeInfo: TypeInfo?) {
        self.isId = isId
        self.isSpecified = isSpecified
        self.ownerElement = ownerElement
        self.schemaTypeInfo = schemaTypeInfo
        super.init(owningDocument, namespaceURI: namespaceURI, qualifiedName: qualifiedName)
    }

    public override init(_ owningDocument: DocumentNode, nodeName: String) { super.init(owningDocument, nodeName: nodeName) }

    public override init(_ owningDocument: DocumentNode, namespaceURI: String, qualifiedName: String) { super.init(owningDocument, namespaceURI: namespaceURI, qualifiedName: qualifiedName) }

    public override func cloneNode(owningDocument: DocumentNode, notify: Bool, deep: Bool) -> Node {
        guard let attr = (hasNamespace ? owningDocument.createAttribute(namespaceURI: namespaceURI ?? "", name: localName ?? name)
                                       : owningDocument.createAttribute(name: name)) as? AttributeNodeImpl else { fatalError("Internal Error") }
        attr.isSpecified = true
        attr.schemaTypeInfo = schemaTypeInfo
        attr.isId = isId
        if deep {
            for n in _nodes { attr.append(child: n.cloneNode(owningDocument: owningDocument, notify: notify, deep: deep)) }
        }
        else {
            attr.value = value
        }
        if notify {

        }
        return attr
    }

    override func canBeParentTo(child: Node) -> Bool { child.isNodeType(.TextNode, .EntityReferenceNode) }

    @usableFromInline var nsName: NsName { NsName(attr: self) }
}

@usableFromInline class NsName: Equatable, Hashable, Comparable {
    @usableFromInline var namespaceURI: String
    @usableFromInline var localName:    String

    @usableFromInline init(_ namespaceURI: String, _ localName: String) {
        self.namespaceURI = namespaceURI
        self.localName = localName
    }

    @usableFromInline init(attr: AttributeNode) {
        guard attr.hasNamespace else { fatalError("No Namespace URI") }
        namespaceURI = (attr.namespaceURI ?? "")
        localName = (attr.localName ?? attr.name)
    }

    @usableFromInline func hash(into hasher: inout Hasher) {
        hasher.combine(namespaceURI)
        hasher.combine(localName)
    }

    @usableFromInline static func == (lhs: NsName, rhs: NsName) -> Bool { ((lhs.namespaceURI == rhs.namespaceURI) && (lhs.localName == rhs.localName)) }

    @usableFromInline static func < (lhs: NsName, rhs: NsName) -> Bool { ((lhs.namespaceURI < rhs.namespaceURI) || ((lhs.namespaceURI == rhs.namespaceURI) && (lhs.localName < rhs.localName))) }
}
