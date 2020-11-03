/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: NotationNodeImpl.swift
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

public class NotationNodeImpl: NodeImpl, NotationNode {
//@f:0
    public internal(set)       var publicId   : String?   = ""
    public internal(set)       var systemId   : String    = ""
    public internal(set)       var name       : String    = ""
    @inlinable public override var isReadOnly : Bool      { true          }
    @inlinable public override var nodeName   : String    { name          }
    @inlinable public override var nodeType   : NodeTypes { .NotationNode }
//@f:1

    public init(_ owningDocument: DocumentNode, name: String, publicId: String?, systemId: String) {
        self.publicId = publicId
        self.systemId = systemId
        self.name = name
        super.init(owningDocument)
    }
}
