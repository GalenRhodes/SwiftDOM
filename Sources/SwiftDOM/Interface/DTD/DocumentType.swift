/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: DocumentType.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/19/20
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

public protocol DocumentTypeNode: Node {
//@f:0
    var name           : String                     { get }
    var publicId       : String                     { get }
    var systemId       : String                     { get }
    var internalSubset : String                     { get }
    var entities       : NamedNodeMap<EntityNode>   { get }
    var notations      : NamedNodeMap<NotationNode> { get }
//@f:1
}

public class AnyDocumentTypeNode: AnyNode, DocumentTypeNode {
//@f:0
           var docType        : DocumentTypeNode           { node as! DocumentTypeNode }
    public var name           : String                     { docType.name              }
    public var publicId       : String                     { docType.publicId          }
    public var systemId       : String                     { docType.systemId          }
    public var internalSubset : String                     { docType.internalSubset    }
    public var entities       : NamedNodeMap<EntityNode>   { docType.entities          }
    public var notations      : NamedNodeMap<NotationNode> { docType.notations         }
//@f:1

    public init(_ docType: DocumentTypeNode) {
        super.init(docType)
    }
}
