/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: ProcessingInstructionNodeImpl.swift
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

open class ProcessingInstructionNodeImpl: NodeImpl, ProcessingInstructionNode {
    open override var nodeType:    NodeTypes { .ProcessingInstructionNode }
    open override var nodeName:    String { target }
    open override var nodeValue:   String? {
        get { data }
        set { if let d = newValue { data = d } }
    }
    open override var textContent: String? {
        get { data }
        set { if let d = newValue { data = d } }
    }

    open var data: String = ""
    open internal(set) var target: String = ""

    init(_ owningDocument: DocumentNodeImpl, data: String, target: String) {
        self.data = data
        self.target = target
        super.init(owningDocument)
    }

    open override func baseClone(_ doc: DocumentNodeImpl, postEvent: Bool, deep: Bool) -> NodeImpl {
        ProcessingInstructionNodeImpl(doc, data: data, target: target)
    }

    public static func == (lhs: ProcessingInstructionNodeImpl, rhs: ProcessingInstructionNodeImpl) -> Bool { lhs === rhs }
}
