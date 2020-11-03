/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: EntityNodeImpl.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 11/3/20
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

public class EntityNodeImpl: NamedNodeImpl, EntityNode {
//@f:0
    public internal(set) var inputEncoding : String.Encoding
    public internal(set) var notationName  : String
    public internal(set) var publicId      : String?
    public internal(set) var systemId      : String
    public internal(set) var xmlEncoding   : String
    public internal(set) var xmlVersion    : String
    public               var entityName    : String          { nodeName    }
    public override      var isReadOnly    : Bool            { true        }
    public override      var nodeType      : NodeTypes       { .EntityNode }
//@f:1

    public init(_ owningDocument: DocumentNode,
                entityName: String,
                inputEncoding: String.Encoding,
                notationName: String,
                publicId: String?,
                systemId: String,
                xmlEncoding: String,
                xmlVersion: String) {
        self.inputEncoding = inputEncoding
        self.notationName = notationName
        self.publicId = publicId
        self.systemId = systemId
        self.xmlEncoding = xmlEncoding
        self.xmlVersion = xmlVersion
        super.init(owningDocument, nodeName: entityName)
    }

    public init(_ owningDocument: DocumentNode,
                namespaceURI: String,
                qualifiedName entityName: String,
                inputEncoding: String.Encoding,
                notationName: String,
                publicId: String?,
                systemId: String,
                xmlEncoding: String,
                xmlVersion: String) {
        self.inputEncoding = inputEncoding
        self.notationName = notationName
        self.publicId = publicId
        self.systemId = systemId
        self.xmlEncoding = xmlEncoding
        self.xmlVersion = xmlVersion
        super.init(owningDocument, namespaceURI: namespaceURI, qualifiedName: entityName)
    }
}
