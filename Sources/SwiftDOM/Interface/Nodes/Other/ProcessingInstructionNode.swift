/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: ProcessingInstructionNode.swift
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

public protocol ProcessingInstructionNode: Node {
//@f:0
    var data:   String { get set }
    var target: String { get     }
//@f:1
}

public class AnyProcessingInstructionNode: AnyNode, ProcessingInstructionNode {
    var pi: ProcessingInstructionNode { (node as! ProcessingInstructionNode) }

    public init(_ pi: ProcessingInstructionNode) { super.init(pi) }

    //@f:0
    public var target: String { pi.target }
    public var data:   String { get { pi.data } set { pi.data = newValue } }
    //@f:1
}
