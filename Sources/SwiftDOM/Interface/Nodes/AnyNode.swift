/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: AnyNode.swift
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

public class AnyNode: Node, Hashable, RandomAccessCollection {

    public typealias Element = Node
    public typealias Index = Int
    public typealias SubSequence = ArraySlice<Element>
    public typealias Indices = Range<Index>

    @usableFromInline var node: Node

//@f:0
    @inlinable public var owningDocument:   DocumentNode                   { node.owningDocument  }
    @inlinable public var nodeType:         NodeTypes                      { node.nodeType        }
    @inlinable public var nodeName:         String                         { node.nodeName        }
    @inlinable public var localName:        String?                        { node.localName       }
    @inlinable public var namespaceURI:     String?                        { node.namespaceURI    }
    @inlinable public var baseURI:          String?                        { node.baseURI         }
    @inlinable public var parentNode:       Node?                          { node.parentNode      }
    @inlinable public var firstChild:       Node?                          { node.firstChild      }
    @inlinable public var lastChild:        Node?                          { node.lastChild       }
    @inlinable public var nextSibling:      Node?                          { node.nextSibling     }
    @inlinable public var previousSibling:  Node?                          { node.previousSibling }
    @inlinable public var hasAttributes:    Bool                           { node.hasAttributes   }
    @inlinable public var hasChildNodes:    Bool                           { node.hasChildNodes   }
    @inlinable public var hasNamespace:     Bool                           { node.hasNamespace    }
    @inlinable public var count:            Int                            { node.count           }
    @inlinable public var startIndex:       Int                            { node.startIndex      }
    @inlinable public var endIndex:         Int                            { node.endIndex        }
    @inlinable public var attributes:       NamedNodeMap<AttributeNode> { node.attributes      }
    @inlinable public var nodeValue:        String?                        { get { node.nodeValue   } set { node.nodeValue   = newValue } }
    @inlinable public var textContent:      String                         { get { node.textContent } set { node.textContent = newValue } }
    @inlinable public var prefix:           String?                        { get { node.prefix      } set { node.prefix      = newValue } }
//@f:1

    public init(_ node: Node) { self.node = node }

    @inlinable public func getHash(into hasher: inout Hasher) { node.getHash(into: &hasher) }

    @inlinable public static func == (lhs: AnyNode, rhs: AnyNode) -> Bool { lhs.node.isEqualTo(rhs.node) }

    @inlinable public func asHashable() -> AnyNode { self }

    @inlinable public func isEqualTo(_ other: Node) -> Bool { node.isEqualTo(other) }

    @inlinable public func normalize() { node.normalize() }

    @inlinable public func append(child childNode: Node) -> Node { node.append(child: childNode) }

    @inlinable public func insert(childNode: Node, before refNode: Node?) -> Node { node.insert(childNode: childNode, before: refNode) }

    @inlinable public func replace(childNode oldChildNode: Node, with newChildNode: Node) -> Node { node.replace(childNode: oldChildNode, with: newChildNode) }

    @inlinable public func remove(childNode: Node) -> Node { node.remove(childNode: childNode) }

    @inlinable public func userData(key: String) -> Any? { node.userData(key: key) }

    @inlinable public func setUserData(key: String, userData: Any?, handler: UserDataEventHandler?) { node.setUserData(key: key, userData: userData, handler: handler) }

    @inlinable public func cloneNode(deep: Bool) -> Node { node.cloneNode(deep: deep) }

    @inlinable public func contains(_ node: Node) -> Bool { node.contains(node) }

    @inlinable public func isSameNode(as otherNode: Node) -> Bool { node.isSameNode(as: otherNode) }

    @inlinable public func isDefaultNamespace(namespaceURI uri: String) -> Bool { node.isDefaultNamespace(namespaceURI: uri) }

    @inlinable public func lookupNamespaceURL(prefix: String) -> String? { node.lookupNamespaceURL(prefix: prefix) }

    @inlinable public func lookupPrefix(namespaceURI uri: String) -> String? { node.lookupPrefix(namespaceURI: uri) }

    @inlinable public func removeAllChildNodes() -> [Node] { node.removeAllChildNodes() }

    @inlinable public func forEachChild(do block: (Node) throws -> Void) rethrows { try node.forEachChild(do: block) }

    @inlinable public func isNodeType(_ types: NodeTypes...) -> Bool { node.isNodeType(types) }

    @inlinable public func hash(into hasher: inout Hasher) { node.getHash(into: &hasher) }

    @inlinable public subscript(position: Index) -> Element { node[position] }

    @inlinable public subscript(bounds: Range<Index>) -> ArraySlice<Element> { node[bounds] }
}
