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
//@f:0
     var inputEncoding : String.Encoding { get }
     var entityName    : String          { get }
     var notationName  : String          { get }
     var publicId      : String?         { get }
     var systemId      : String          { get }
     var xmlEncoding   : String          { get }
     var xmlVersion    : String          { get }
//@f:1
}

public class AnyEntityNode: AnyNode, EntityNode {
//@f:0
    @inlinable        var entity        : EntityNode      { (node as! EntityNode) }
    @inlinable public var inputEncoding : String.Encoding { entity.inputEncoding  }
    @inlinable public var notationName  : String          { entity.notationName   }
    @inlinable public var publicId      : String?         { entity.publicId       }
    @inlinable public var systemId      : String          { entity.systemId       }
    @inlinable public var xmlEncoding   : String          { entity.xmlEncoding    }
    @inlinable public var xmlVersion    : String          { entity.xmlVersion     }
    @inlinable public var entityName    : String          { entity.entityName     }
//@f:1
    public init(_ entity: EntityNode) { super.init(entity) }
}
