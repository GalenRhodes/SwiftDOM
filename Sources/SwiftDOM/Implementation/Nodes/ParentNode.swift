/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: ParentNode.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/22/20
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

open class ParentNode: ChildNode, LiveCollectionNotifier {

    @inlinable open override var firstChild: Node? { _firstChild }
    @inlinable open override var lastChild:  Node? { _lastChild }
    @inlinable open override var children:   NodeList<AnyNode> { ParentNodeList(self) }

    @usableFromInline var _firstChild: ChildNode?             = nil
    @usableFromInline var _lastChild:  ChildNode?             = nil
    @usableFromInline var _listeners:  Set<AnyLiveCollection> = Set()

    @discardableResult open override func insert<T: Node, E: Node>(childNode: T, before refNode: E?) -> T {
        if let _child: ChildNode = (childNode as? ChildNode) {
            /*
             * Let's do some sanity checks starting with making sure
             * we're not the new node or one of it's children.
             */
            if hierachyCheck(node: _child) {
                fatalError("Hierarchy error.")
            }
            else if let n: E = refNode {
                if let refNode: ChildNode = (n as? ChildNode), refNode._parentNode === self { _insert01(childNode: _child, before: refNode) }
                else { fatalError("Reference node is not a chld of this node.") }
            }
            else {
                _insert01(childNode: _child, before: nil)
            }
            notifyListeners()
            return childNode
        }
        else {
            fatalError("The new node is not allowed to be a child node.")
        }
    }

    @discardableResult open override func remove<T: Node>(childNode: T) -> T {
        if let c: ChildNode = (childNode as? ChildNode), c._parentNode === self {
            _remove(childNode: c)
            notifyListeners()
            return childNode
        }
        else {
            fatalError("Node to remove is not a child of this node.")
        }
    }

    @usableFromInline func hierachyCheck(node: Node?) -> Bool {
        guard let n: Node = node else { return false }
        guard let p: ParentNode = (n as? ParentNode) else { return false }
        return self === p || hierachyCheck(node: p._parentNode)
    }

    @usableFromInline func _insert01(childNode: ChildNode, before refNode: ChildNode?) {
        /*
         * Is the new node already a child to this or another node?
         */
        if let cp: ParentNode = childNode._parentNode {
            if self === cp {
                /*
                 * The new node is already one of our children so it must be changing position.
                 * We'll also do this in a way so that only one notification is sent.
                 */
                _remove(childNode: childNode)
                _insert02(childNode: childNode, before: refNode)
            }
            else {
                /*
                 * Remove the node from it's parent before adding it to us.
                 */
                cp.remove(childNode: childNode)
                _insert02(childNode: childNode, before: refNode)
            }
        }
        else {
            /*
             * We're free and clear to move forward.
             */
            _insert02(childNode: childNode, before: refNode)
        }
    }

    @usableFromInline func _insert02(childNode: ChildNode, before refNode: ChildNode?) {
        childNode._parentNode = self
        childNode._previousSibling = nil
        childNode._nextSibling = nil

        if let refNode: ChildNode = refNode {
            if refNode._parentNode === self {
                childNode._nextSibling = refNode

                if let n: Node = refNode.previousSibling, let refNodePrev: ChildNode = (n as? ChildNode) {
                    childNode._previousSibling = refNodePrev
                    refNodePrev._nextSibling = childNode
                }
                else {
                    _firstChild = childNode
                }

                refNode._previousSibling = childNode
            }
            else {
                fatalError("The reference node is not a child of this node.")
            }
        }
        else if let _last: ChildNode = _lastChild {
            childNode._previousSibling = _last
            _last._nextSibling = childNode
            _lastChild = childNode
        }
        else {
            _lastChild = childNode
            _firstChild = childNode
        }
    }

    @usableFromInline func _remove(childNode: ChildNode) {
        if let prev: ChildNode = childNode._previousSibling {
            if let next: ChildNode = childNode._nextSibling {
                /*
                 * I have a previous node and a next node.
                 */
                next._previousSibling = prev
                prev._nextSibling = next
            }
            else {
                /*
                 * I have a previous node but no next node.
                 */
                prev._nextSibling = nil
                _lastChild = prev
            }
        }
        else if let next: ChildNode = childNode._nextSibling {
            /*
             * I have a next node but no previous node.
             */
            next._previousSibling = nil
            _firstChild = next
        }
        else {
            /*
             * I'm an only child.
             */
            _lastChild = nil
            _nextSibling = nil
        }

        childNode._nextSibling = nil
        childNode._previousSibling = nil
        childNode._parentNode = nil
    }

    @usableFromInline func notifyListeners() {
        for l: AnyLiveCollection in _listeners {
            l.domCollectionDidChange(self)
        }
    }

    @inlinable open func addLiveCollection(_ c: LiveCollection) {
        _listeners.insert(c.asHashable())
    }

    @inlinable open func removeLiveCollection(_ c: LiveCollection) {
        _listeners.remove(c.asHashable())
    }
}

@usableFromInline class ParentNodeList: NodeList<AnyNode> {
    @usableFromInline var _nodes:  [AnyNode] = []
    @usableFromInline let _parent: ParentNode

    @usableFromInline var _startIndex: Int
    @usableFromInline var _endIndex:   Int

    @inlinable override var startIndex: Int { _startIndex < 0 ? _nodes.startIndex : _startIndex }
    @inlinable override var endIndex:   Int { _endIndex < 0 ? _nodes.endIndex : _endIndex }
    @inlinable override var count:      Int { endIndex - startIndex }

    @usableFromInline init(_ parent: ParentNode, start: Int = -1, end: Int = -1) {
        _parent = parent
        super.init()
        _parent.addLiveCollection(self)
        domCollectionDidChange(_parent)
    }

    deinit {
        _parent.removeLiveCollection(self)
        _nodes.removeAll()
    }

    @inlinable override func contains(node: AnyNode) -> Bool { _nodes.contains(node) }

    @inlinable override subscript(bounds: Range<Int>) -> NodeList<AnyNode> { NodeList() }
    @inlinable override subscript(position: Int) -> AnyNode { _nodes[position] }

    @inlinable override func domCollectionDidChange(_ node: Node) {
        if let p: ParentNode = (node as? ParentNode) {
            _nodes.removeAll()
            var c: Node? = p.firstChild
            while let _c: Node = c {
                _nodes.append(_c.asHashable())
                c = _c.nextSibling
            }
        }
    }
}
