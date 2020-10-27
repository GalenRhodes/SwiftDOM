/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: DocumentFragmentNodeImpl.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/26/20
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

open class DocumentFragmentNodeImpl: ParentNode, DocumentFragmentNode {
    open override var nodeType: NodeTypes { .DocumentFragmentNode }
    open override var nodeName: String { "#document-fragment" }

    override init(_ owningDocument: DocumentNodeImpl) { super.init(owningDocument) }

    open override func baseClone(_ doc: DocumentNodeImpl, postEvent: Bool, deep: Bool) -> NodeImpl {
        let d = DocumentFragmentNodeImpl(doc)
        if deep { forEachChild { d.append(child: $0.cloneNode(doc, postEvent: postEvent, deep: deep)) } }
        return d
    }

    static func == (lhs: DocumentFragmentNodeImpl, rhs: DocumentFragmentNodeImpl) -> Bool { lhs === rhs }
}
