/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: CharacterData.swift
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

public protocol EntityRefNode: Node {
    var entityName: String { get }
}

public protocol CharacterData: Node {
    var data: String { get set }
}

public protocol TextNode: CharacterData {
//@f:0
    var wholeText:                  String { get set }
    var isElementContentWhitespace: Bool   { get     }
//@f:1

    func splitText(offset: Int) -> TextNode

    @discardableResult func replaceWholeText(content: String) -> TextNode?
}

public protocol CDataSectionNode: TextNode {}

public protocol CommentNode: CharacterData {}

public class AnyEntityRefNode: AnyNode, EntityRefNode {
    var entRef: EntityRefNode { (node as! EntityRefNode) }

    public var entityName: String { entRef.entityName }

    public init(_ entRef: EntityRefNode) { super.init(entRef) }
}

public class AnyCharacterData: AnyNode, CharacterData {
//@f:0
    @usableFromInline var cd   : CharacterData { node as! CharacterData                     }
    public            var data : String        { get { cd.data } set { cd.data = newValue } }
//@f:1

    public init(_ charData: CharacterData) { super.init(charData) }
}

public class AnyTextNode: AnyCharacterData, TextNode {
//@f:0
    public            var wholeText                  : String   { get { textNode.wholeText } set { textNode.wholeText = newValue } }
    public            var isElementContentWhitespace : Bool     { textNode.isElementContentWhitespace                              }
    @usableFromInline var textNode                   : TextNode { cd as! TextNode                                                  }
//@f:1

    public init(_ textNode: TextNode) { super.init(textNode) }

    @inlinable public func splitText(offset: Int) -> TextNode { textNode.splitText(offset: offset) }

    @inlinable public func replaceWholeText(content: String) -> TextNode? { textNode.replaceWholeText(content: content) }
}

public class AnyCDataSectionNode: AnyTextNode, CDataSectionNode {
    var cDataSection: CDataSectionNode { textNode as! CDataSectionNode }

    public init(_ cDataSection: CDataSectionNode) { super.init(cDataSection) }
}

public class AnyCommentNode: AnyCharacterData, CommentNode {
    var comment: CommentNode { cd as! CommentNode }

    public init(_ comment: CommentNode) { super.init(comment) }
}
