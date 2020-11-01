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
//@f:0
    var wholeText:                  String { get set }
    var isElementContentWhitespace: Bool   { get     }
//@f:1

    func splitText(offset: Int) -> TextNode

    @discardableResult func replaceWholeText(text: String) -> TextNode
}

public class AnyTextNode: AnyCharacterData, TextNode {
//@f:0
    public var wholeText:                  String { get { textNode.wholeText } set { textNode.wholeText = newValue } }
    public var isElementContentWhitespace: Bool   { textNode.isElementContentWhitespace                              }
//@f:1

    var textNode: TextNode { cd as! TextNode }

    public init(_ textNode: TextNode) { super.init(textNode) }

    public func splitText(offset: Int) -> TextNode { textNode.splitText(offset: offset) }

    public func replaceWholeText(text: String) -> TextNode { textNode.replaceWholeText(text: text) }
}
