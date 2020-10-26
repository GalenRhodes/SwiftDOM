/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: TextNodeImpl.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/23/20
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

open class CharacterDataImpl: NodeImpl, CharacterData {
    @inlinable open var data: String {
        get { _data }
        set { _data = newValue }
    }
    @inlinable open override var nodeValue:   String? {
        get { _data }
        set { if let v: String = newValue { _data = v } }
    }
    @inlinable open override var textContent: String? {
        get { _data }
        set { if let v: String = newValue { _data = v } }
    }
    @usableFromInline var _data: String = ""

    public init(_ owningDocument: DocumentNodeImpl, content: String) {
        super.init(owningDocument)
        _data = content
    }
}

open class TextNodeImpl: CharacterDataImpl, TextNode {
    @inlinable open var wholeText: String {
        get {
            var _str: String = ""
            TextNodeImpl.getWholeTextBackwards(text: &_str, node: previousSibling, parent: parentNode)
            TextNodeImpl.getWholeTextForewards(text: &_str, node: self, parent: parentNode)
            return _str
        }
        set { replaceWholeText(text: newValue) }
    }

    @inlinable open override var nodeType: NodeTypes { NodeTypes.TextNode }
    @inlinable open override var nodeName: String { "#text" }

    open private(set) var isElementContentWhitespace: Bool = false

    public override init(_ owningDocument: DocumentNodeImpl, content: String) { super.init(owningDocument, content: content) }

    @inlinable open func splitText(offset: Int) -> TextNode {
        let index: String.Index = _data.index(_data.startIndex, offsetBy: offset)
        let other: String       = String(_data[index ..< _data.endIndex])
        let txt:   TextNodeImpl = TextNodeImpl(owningDocument as! DocumentNodeImpl, content: other)
        if let n: Node = parentNode, let p: ParentNode = (n as? ParentNode) {
            p.insert(childNode: txt, before: nextSibling as? NodeImpl)
        }
        _data = String(_data[_data.startIndex ..< index])
        return txt
    }

    @inlinable func createLikeMe(_ text: String) -> TextNodeImpl {
        (owningDocument.createTextNode(content: text) as! TextNodeImpl)
    }

    @inlinable @discardableResult open func replaceWholeText(text: String) -> TextNode {
        if !(TextNodeImpl.canModifyPrev(self) && TextNodeImpl.canModifyNext(self)) { fatalError("No Modification Allowed.") }

        var currentNode: TextNodeImpl = self
        if currentNode.isReadOnly {
            currentNode = createLikeMe(text)
            if let aParent: Node = parentNode { aParent.replace(childNode: self, with: currentNode) }
            else { return currentNode }
        }
        currentNode._data = text

        var _prev: Node? = currentNode.previousSibling
        while var prev: Node = _prev {
            if nodeTypeIs(prev, .TextNode, .CDataSectionNode) || (prev.nodeType == .EntityReferenceNode && TextNodeImpl.hasTextOnlyChildren(prev)) {
                parentNode?.remove(childNode: prev)
                prev = currentNode
            }
            else {
                break
            }
            _prev = prev.previousSibling
        }

        var _next: Node? = currentNode.nextSibling
        while var next: Node = _next {
            if nodeTypeIs(next, .TextNode, .CDataSectionNode) || (next.nodeType == .EntityReferenceNode && TextNodeImpl.hasTextOnlyChildren(next)) {
                parentNode?.remove(childNode: next)
                next = currentNode
            }
            else {
                break
            }
            _next = next.nextSibling
        }

        return currentNode
    }

    @usableFromInline @discardableResult static func getWholeTextBackwards(text: inout String, node aNode: Node?, parent aParent: Node?) -> Bool {
        var _node: Node? = aNode

        while let node: Node = _node {
            if nodeTypeIs(node, .TextNode, .CDataSectionNode) {
                if let t: String = node.textContent { text = (t + text) }
            }
            else if nodeTypeIs(node, .EntityReferenceNode) {
                if getWholeTextBackwards(text: &text, node: node.lastChild, parent: node) { return true }
            }
            else {
                return true
            }
            _node = node.previousSibling
        }

        if (nodeTypeIs(aParent, .EntityReferenceNode)) {
            getWholeTextBackwards(text: &text, node: aParent?.previousSibling, parent: aParent?.parentNode)
            return true
        }

        return false
    }

    @usableFromInline @discardableResult static func getWholeTextForewards(text: inout String, node aNode: Node?, parent aParent: Node?) -> Bool {
        var _node: Node? = aNode

        while let node: Node = _node {
            if nodeTypeIs(node, .TextNode, .CDataSectionNode) {
                if let t: String = node.textContent { text += t }
            }
            else if nodeTypeIs(node, .EntityReferenceNode) {
                if getWholeTextBackwards(text: &text, node: node.firstChild, parent: node) { return true }
            }
            else {
                return true
            }
            _node = node.nextSibling
        }

        if nodeTypeIs(aParent, .EntityReferenceNode) {
            getWholeTextForewards(text: &text, node: aParent?.nextSibling, parent: aParent?.parentNode)
            return true
        }

        return false
    }

    @usableFromInline static func canModifyNext(_ node: Node?) -> Bool {
        var textFirstChild: Bool  = false
        var _next:          Node? = node?.nextSibling

        while let next: Node = _next {
            if next.nodeType == .EntityReferenceNode {
                var _firstChild: Node? = next.firstChild

                if _firstChild == nil { return false }

                while let firstChild: Node = _firstChild {
                    if nodeTypeIs(firstChild, .CDataSectionNode, .TextNode) {
                        textFirstChild = true
                    }
                    else if firstChild.nodeType == .EntityReferenceNode {
                        if canModifyNext(firstChild) {
                            textFirstChild = true
                        }
                        else {
                            return false
                        }
                    }
                    else {
                        return !textFirstChild
                    }

                    _firstChild = firstChild.nextSibling
                }
            }
            else if !nodeTypeIs(next, .TextNode, .CDataSectionNode) {
                return true
            }

            _next = next.nextSibling
        }

        return true
    }

    @usableFromInline static func canModifyPrev(_ node: Node?) -> Bool {
        var textLastChild: Bool  = false
        var _prev:         Node? = node?.previousSibling

        while let prev: Node = _prev {
            if prev.nodeType == .EntityReferenceNode {
                var _lastChild: Node? = prev.lastChild

                if _lastChild == nil { return false }

                while let lastChild: Node = _lastChild {
                    if nodeTypeIs(lastChild, .CDataSectionNode, .TextNode) {
                        textLastChild = true
                    }
                    else if lastChild.nodeType == .EntityReferenceNode {
                        if canModifyNext(lastChild) {
                            textLastChild = true
                        }
                        else {
                            return false
                        }
                    }
                    else {
                        return !textLastChild
                    }

                    _lastChild = lastChild.previousSibling
                }
            }
            else if !nodeTypeIs(prev, .TextNode, .CDataSectionNode) {
                return true
            }

            _prev = prev.previousSibling
        }

        return true
    }

    @usableFromInline static func hasTextOnlyChildren(_ node: Node?) -> Bool {
        var child: Node? = node

        if child == nil { return false }

        child = child?.firstChild

        while let _child: Node = child {
            if nodeTypeIs(_child, .EntityReferenceNode) && !hasTextOnlyChildren(_child) { return false }
            else if !nodeTypeIs(_child, .TextNode, .CDataSectionNode, .EntityReferenceNode) { return false }
            child = _child.nextSibling
        }

        return true
    }

    @inlinable public static func == (lhs: TextNodeImpl, rhs: TextNodeImpl) -> Bool { lhs === rhs }
}
