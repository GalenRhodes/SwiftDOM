/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: CharacterDataImpl.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 11/2/20
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

public class CharacterDataImpl: ChildNodeImpl, CharacterData {
//@f:0
    public                     var data        : String  = ""
    @inlinable public override var nodeValue   : String? { get { data } set { data = (newValue ?? "") }  }
    @inlinable public override var textContent : String  { get { data } set { data = newValue         }  }
//@f:1

    public init(_ owningDocument: DocumentNode, data: String) {
        self.data = data
        super.init(owningDocument)
    }
}

public class CommentNodeImpl: CharacterDataImpl, CommentNode {
//@f:0
    public override var nodeType : NodeTypes { .CommentNode }
    public override var nodeName : String    { "#comment"   }
//@f:1

    public override init(_ owningDocument: DocumentNode, data: String) { super.init(owningDocument, data: data) }

    public override func cloneNode(owningDocument: DocumentNode, notify: Bool, deep: Bool) -> Node {
        let t = owningDocument.createComment(content: data)
        if notify { postUserDataEvent(action: .Cloned, destination: t) }
        return t
    }
}

public class TextNodeImpl: CharacterDataImpl, TextNode {
//@f:0
    public internal(set) var isElementContentWhitespace : Bool      = false
    @inlinable  public   var wholeText                  : String    { get { getWholeText() } set { replaceWholeText(content: newValue) } }
    public override      var nodeType                   : NodeTypes { .TextNode                                                       }
    public override      var nodeName                   : String    { "#text"                                                         }
//@f:1

    public override init(_ owningDocument: DocumentNode, data: String) { super.init(owningDocument, data: data) }

    public func splitText(offset: Int) -> TextNode {
        let idx = data.index(data.startIndex, offsetBy: offset)
        let str = String(data[idx ..< data.endIndex])
        let tnd = makeNewMe(content: str)
        parentNode?.insert(childNode: tnd, before: nextSibling)
        data = String(data[data.startIndex ..< idx])
        return tnd
    }

    @discardableResult public func replaceWholeText(content: String) -> TextNode? {
        // Behavior is based on if there's a parent node or not and if the content is empty.

        let noContent = content.isEmpty

        if let parent = parentNode {
            guard canModify(next: true, node: self) && canModify(next: false, node: self) else { fatalError("No modification allowed") }
            let currentNode = (noContent ? self : foo1(content, parent))
            while let prev = currentNode.previousSibling { if foo2(prev, parent) { break } }
            while let next = currentNode.nextSibling { if foo2(next, parent) { break } }
            if noContent { parent.remove(childNode: currentNode) }
            return (noContent ? nil : currentNode)
        }
        else if noContent {
            return nil
        }
        else if isReadOnly {
            return makeNewMe(content: content)
        }
        else {
            data = content
            return self
        }
    }

    @inlinable func makeNewMe(content: String) -> TextNode { owningDocument.createTextNode(content: content) }

    public override func cloneNode(owningDocument: DocumentNode, notify: Bool, deep: Bool) -> Node {
        let t = makeNewMe(content: data)
        if notify { postUserDataEvent(action: .Cloned, destination: t) }
        return t
    }

    @inlinable func getWholeText() -> String {
        var str = ""
        getWholeText(forward: false, str: &str, node: previousSibling, parent: parentNode)
        getWholeText(forward: true, str: &str, node: self, parent: parentNode)
        return str
    }

    @usableFromInline @discardableResult func getWholeText(forward: Bool, str: inout String, node n: Node?, parent: Node?) -> Bool {
        var n = n
        while let node = n {
            switch node.nodeType {
                case .TextNode, .CDataSectionNode: str += node.textContent
                case .EntityReferenceNode: if getWholeText(forward: forward, str: &str, node: forward ? node.firstChild : node.lastChild, parent: node) { return true }
                default: return true
            }
            n = forward ? node.nextSibling : node.previousSibling
        }

        if (parent?.isNodeType(.EntityReferenceNode) ?? false) {
            getWholeText(forward: forward, str: &str, node: forward ? parent?.nextSibling : parent?.previousSibling, parent: parent?.parentNode)
            return true
        }
        return false
    }

    @usableFromInline @discardableResult func canModify(next: Bool, node: Node?) -> Bool {
        var textFirstLastChild: Bool  = false
        var n:                  Node? = (next ? node?.nextSibling : node?.previousSibling)

        while let node = n {
            switch node.nodeType {//@f:0
                case .TextNode, .CDataSectionNode : return true
                case .EntityReferenceNode         : if let r = canModify(next: next, node: node, textFirstLastChild: &textFirstLastChild) { return r }
                default                           : return true
            }//@f:1
            n = (next ? node.nextSibling : node.previousSibling)
        }

        return true
    }

    @inlinable func canModify(next: Bool, node: Node, textFirstLastChild: inout Bool) -> Bool? {
        var n = (next ? node.firstChild : node.lastChild)
        if n == nil { return false }

        while let node = n {
            switch node.nodeType {//@f:0
                case .TextNode, .CDataSectionNode : textFirstLastChild = true
                case .EntityReferenceNode         : if canModify(next: next, node: node) { textFirstLastChild = true } else { return false }
                default                           : return !textFirstLastChild
            }//@f:1
            n = (next ? node.nextSibling : node.previousSibling)
        }

        return nil
    }

    @usableFromInline func hasTextOnlyChildren(node: Node) -> Bool {
        var c = node.firstChild
        while let child = c {
            if child.nodeType == .EntityReferenceNode { if !hasTextOnlyChildren(node: child) { return false } }
            else if !child.isNodeType(.TextNode, .CDataSectionNode) { return false }
            c = child.nextSibling
        }
        return true
    }

    @inlinable final func foo1(_ content: String, _ parent: Node) -> TextNode {
        if isReadOnly {
            let tn = makeNewMe(content: content)
            parent.replace(childNode: self, with: tn)
            return tn
        }
        else {
            data = content
            return self
        }
    }

    @inlinable final func foo2(_ node: Node, _ parent: Node) -> Bool {
        if node.isNodeType(.TextNode, .CDataSectionNode) || (node.isNodeType(.EntityReferenceNode) && hasTextOnlyChildren(node: node)) {
            parent.remove(childNode: node)
            return false
        }
        return true
    }
}

public class CDataSectionNodeImpl: TextNodeImpl, CDataSectionNode {
//@f:0
    public override var nodeType : NodeTypes { .CDataSectionNode }
    public override var nodeName : String    { "#cdata-section"  }
//@f:1

    public override init(_ owningDocument: DocumentNode, data: String) { super.init(owningDocument, data: data) }

    @inlinable override func makeNewMe(content: String) -> TextNode { owningDocument.createCDataSectionNode(content: content) }
}
