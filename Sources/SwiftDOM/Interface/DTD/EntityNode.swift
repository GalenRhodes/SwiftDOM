/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: EntityNode.swift
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

public protocol EntityNode: Node {
    var inputEncoding: String.Encoding { get }
    var notationName:  String { get }
    var publicId:      String { get }
    var systemId:      String { get }
    var xmlEncoding:   String { get }
    var xmlVersion:    String { get }
}

public class AnyEntityNode: AnyNode, EntityNode {
    var entity: EntityNode { (node as! EntityNode) }

    open var inputEncoding: String.Encoding { entity.inputEncoding }
    open var notationName:  String { entity.notationName }
    open var publicId:      String { entity.publicId }
    open var systemId:      String { entity.systemId }
    open var xmlEncoding:   String { entity.xmlEncoding }
    open var xmlVersion:    String { entity.xmlVersion }

    public init(_ entity: EntityNode) { super.init(entity) }
}
