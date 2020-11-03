/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: ParentNodeImpl.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/30/20
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

public class ParentNodeImpl: ChildNodeImpl {
//@f:0
    public override   var startIndex    : Int             { _worker.sync { () -> Int  in _nodes.startIndex } }
    public override   var endIndex      : Int             { _worker.sync { () -> Int  in _nodes.endIndex   } }
    public            var count         : Int             { _worker.sync { () -> Int  in _nodes.count      } }
    public            var isEmpty       : Bool            { _worker.sync { () -> Bool in _nodes.isEmpty    } }
    public override   var hasChildNodes : Bool            { _firstChild != nil                               }
    public override   var firstChild    : Node?           { _firstChild                                      }
    public override   var lastChild     : Node?           { _lastChild                                       }
    @usableFromInline var _firstChild   : ChildNodeImpl?  = nil
    @usableFromInline var _lastChild    : ChildNodeImpl?  = nil
    @usableFromInline var _nodes        : [ChildNodeImpl] = []
    @usableFromInline let _worker       : DispatchQueue   = DispatchQueue(label: UUID().uuidString, qos: .background, autoreleaseFrequency: .workItem)
//@f:1

    public override init() { super.init() }

    public override init(_ owningDocument: DocumentNode) { super.init(owningDocument) }

    @discardableResult public func append(child childNode: Node) -> Node {
        let childNode = validateNew(child: childNode)
        if let p = childNode._parentNode { p.remove(childNode: childNode) }

        _worker.sync {
            if let last = _lastChild {
                childNode._previousSibling = last
                last._nextSibling = childNode
            }
            else {
                childNode._previousSibling = nil
                _firstChild = childNode
            }
            childNode._nextSibling = nil
            childNode._parentNode = self
            _lastChild = childNode
            _nodes.append(childNode)
        }

        notifyListeners()
        return childNode
    }

    public override func insert(childNode: Node, before refNode: Node?) -> Node {
        guard let refNode = (refNode as? ChildNodeImpl) else { return append(child: childNode) }
        guard (refNode._parentNode?.isSameNode(as: self) ?? false) else { fatalError("Invalid reference node.") }

        let childNode = validateNew(child: childNode)
        if let p = childNode._parentNode { p.remove(childNode: childNode) }

        _worker.sync {
            childNode._parentNode = self
            childNode._nextSibling = refNode
            childNode._previousSibling = refNode._previousSibling
            refNode._previousSibling = childNode

            if let rPrevSib = childNode._previousSibling { rPrevSib._nextSibling = childNode }
            else { _firstChild = childNode }

            _worker.async { [weak self] () -> Void in
                if let s = self {
                    if let i = s._nodes.firstIndex(where: { $0.isSameNode(as: refNode) }) {
                        // Happy path...
                        s._nodes.insert(childNode, at: i)
                    }
                    else {
                        // Sad path...
                        s._nodes.removeAll(keepingCapacity: true)
                        var _n = s._firstChild
                        while let n = _n {
                            s._nodes.append(n)
                            _n = n._nextSibling
                        }
                    }
                }
            }
        }
        notifyListeners()
        return childNode
    }

    public override func replace(childNode oldChildNode: Node, with newChildNode: Node) -> Node {
        let newChildNode = validateNew(child: newChildNode)

        guard let oldChildNode = (oldChildNode as? ChildNodeImpl), (oldChildNode._parentNode?.isSameNode(as: self) ?? false) else { fatalError("Invalid old child node") }
        if newChildNode.isSameNode(as: oldChildNode) { return oldChildNode }
        if let p = newChildNode._parentNode { p.remove(childNode: newChildNode) }

        _worker.sync {
            newChildNode._previousSibling = oldChildNode._previousSibling
            newChildNode._nextSibling = oldChildNode._nextSibling
            if let s = newChildNode._previousSibling { s._nextSibling = newChildNode }
            if let s = newChildNode._nextSibling { s._previousSibling = newChildNode }

            oldChildNode._nextSibling = nil
            oldChildNode._previousSibling = nil
            oldChildNode._parentNode = nil

            if _firstChild?.isSameNode(as: oldChildNode) ?? true { _firstChild = newChildNode }
            if _lastChild?.isSameNode(as: oldChildNode) ?? true { _lastChild = newChildNode }

            _worker.async { [weak self] in
                if let s = self {
                    if let idx = s._nodes.firstIndex(where: { oldChildNode.isSameNode(as: $0) }) { s._nodes[idx] = newChildNode }
                }
            }
        }

        notifyListeners()
        return oldChildNode
    }

    @discardableResult public override func remove(childNode: Node) -> Node {
        _worker.sync {
            guard let childNode = (childNode as? ChildNodeImpl), (childNode._parentNode?.isSameNode(as: self) ?? false) else { fatalError("Invalid node.") }
            let prev = childNode._previousSibling
            let next = childNode._nextSibling

            prev?._nextSibling = next
            next?._previousSibling = prev

            if prev == nil { _firstChild = next }
            if next == nil { _lastChild = prev }

            childNode._parentNode = nil
            childNode._nextSibling = nil
            childNode._previousSibling = nil

            _worker.async { [weak self] in if let s = self { s._nodes.removeAll { childNode.isSameNode(as: $0) } } }
        }
        notifyListeners()
        return childNode
    }

    @discardableResult public override func removeAllChildNodes() -> [Node] {
        let arr = _worker.sync { () -> [Node] in
            let arr: [Node] = Array(_nodes)
            _nodes.removeAll()

            _firstChild = nil
            _lastChild = nil

            for n in arr {
                if let node = (n as? ChildNodeImpl) {
                    node._parentNode = nil
                    node._nextSibling = nil
                    node._previousSibling = nil
                }
            }

            return arr
        }

        notifyListeners()
        return arr
    }

    public func forEachChild(do block: (Node) throws -> Void) rethrows {
        var _node = _firstChild
        while let node = _node {
            try block(node)
            _node = node._nextSibling
        }
    }

    public override func contains(_ node: Node) -> Bool { _worker.sync { _nodes.contains { $0.isSameNode(as: node) } } }

    public override subscript(position: Int) -> Node { _worker.sync { _nodes[position] } }

    public override subscript(bounds: Range<Int>) -> ArraySlice<Node> { _worker.sync { _nodes.map({ n -> Node in n })[bounds] } }

    public override var textContent: String {
        get {
            var txt: String = ""
            forEachChild { txt += $0.textContent }
            return txt
        }
        set {
            removeAllChildNodes()
            if !newValue.isEmpty { append(child: owningDocument.createTextNode(content: newValue)) }
        }
    }

    func notifyListeners() {
        NotificationCenter.default.post(name: DOMNodeListDidChange, object: self)
        if let p = _parentNode { p.notifyListeners() }
    }

    func canBeParentTo(child: Node) -> Bool { false }

    func hierarchyCheck(node: Node) -> Bool {
        var _n: ChildNodeImpl? = self
        while let n = _n {
            if n.isSameNode(as: node) { return false }
            _n = n._parentNode
        }
        return true
    }

    func validateNew(child: Node) -> ChildNodeImpl {
        guard let child = (child as? ChildNodeImpl) else { fatalError("Invalid Node Type.") }
        guard canBeParentTo(child: child) else { fatalError("Invalid Node Type.") }
        guard hierarchyCheck(node: child) else { fatalError("Hierarchy Error.") }
        return child
    }
}
