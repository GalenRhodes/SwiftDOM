/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: DocumentFragmentNodeImpl.swift
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

public class DocumentFragmentNodeImpl: ParentNodeImpl, DocumentFragmentNode {
    @inlinable public override var nodeType: NodeTypes { .DocumentFragmentNode }
    @inlinable public override var nodeName: String { "#document-fragment" }

    public override init(_ owningDocument: DocumentNode) { super.init(owningDocument) }

    public override func cloneNode(owningDocument: DocumentNode, notify: Bool, deep: Bool) -> Node {
        let df = owningDocument.createDocumentFragment()
        if deep { for n in _nodes { df.append(child: n.cloneNode(owningDocument: owningDocument, notify: notify, deep: deep)) } }
        if notify { postUserDataEvent(action: .Cloned, destination: df) }
        return df
    }
}
