/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: Text.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/15/20
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

public protocol TextNode: CharacterData {
    var wholeText:                  String { get }
    var isElementContentWhitespace: Bool { get }

    func replaceWholeText(text: String) -> TextNode

    func splitText(offset: Int) -> TextNode
}

open class AnyTextNode: AnyCharacterData, TextNode {
    @inlinable open var wholeText:                  String { textNode.wholeText }
    @inlinable open var isElementContentWhitespace: Bool { textNode.isElementContentWhitespace }

    @inlinable var textNode: TextNode { cd as! TextNode }

    public init(_ textNode: TextNode) { super.init(textNode) }

    @inlinable open func replaceWholeText(text: String) -> TextNode { textNode.replaceWholeText(text: text) }

    @inlinable open func splitText(offset: Int) -> TextNode { textNode.splitText(offset: offset) }
}
