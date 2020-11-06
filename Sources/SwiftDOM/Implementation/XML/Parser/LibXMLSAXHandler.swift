/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: LibXMLSAXHandler.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 11/5/20
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
import LibXML2Helper
import libxml2

@inlinable func getParser(_ ctx: UnsafeMutableRawPointer?) -> DOMXMLParser? {
    ctx?.bindMemory(to: LibXmlSAXUserData.self, capacity: 1).pointee.parser?.bindMemory(to: DOMXMLParser.self, capacity: 1).pointee
}

func createSAXHandler(delegate d: DOMXMLParserDelegate) -> UnsafeMutablePointer<LibXmlSAXHandler> {
    let saxHandler = UnsafeMutablePointer<LibXmlSAXHandler>.allocate(capacity: 1)
    saxHandler.initialize(to: LibXmlSAXHandler())
    initializeLibXml(saxHandler: saxHandler, delegate: d)
    return saxHandler
}

func getAttributes1(attributes: XStrArr?) -> [SAXAttribute] {
    var arr: [SAXAttribute] = []

    if let attributes = attributes {
        var idx: Int = 0
        while let name = attributes[idx] {
            if let value = attributes[idx + 1] {
                arr.append(SAXAttribute(name: String(cString: name), value: String(cString: value)))
                idx += 2
            }
            else {
                break
            }
        }
    }

    return arr
}

func initializeLibXml(saxHandler: UnsafeMutablePointer<LibXmlSAXHandler>, delegate d: DOMXMLParserDelegate) {
    var sxh = saxHandler.pointee
    sxh.saxHandler.initialized = XML_SAX2_MAGIC
    addErrorHandlers(saxHandler)

    if let _ = d.parseInternalSubset {
        sxh.saxHandler.internalSubset = { (ctx: UnsafeMutableRawPointer?, name: XStr?, externalId: XStr?, systemId: XStr?) -> Void in
            guard let ctx: DOMXMLParser = getParser(ctx), let f = ctx.delegate?.parseInternalSubset, let name = stringFromXStr(name) else { return }
            f(ctx, name, stringFromXStr(externalId), stringFromXStr(systemId))
        }
    }

    if let _ = d.parseIsStandalone {
        sxh.saxHandler.isStandalone = { (ctx: UnsafeMutableRawPointer?) -> Int32 in
            guard let ctx: DOMXMLParser = getParser(ctx), let f = ctx.delegate?.parseIsStandalone else { return 0 }
            return (f(ctx) ? 1 : 0)
        }
    }

    if let _ = d.parseHasInternalSubset {
        sxh.saxHandler.hasInternalSubset = { (ctx: UnsafeMutableRawPointer?) -> Int32 in
            guard let ctx: DOMXMLParser = getParser(ctx), let f = ctx.delegate?.parseHasInternalSubset else { return 0 }
            return (f(ctx) ? 1 : 0)
        }
    }

    if let _ = d.parseHasExternalSubset {
        sxh.saxHandler.hasExternalSubset = { (ctx: UnsafeMutableRawPointer?) -> Int32 in
            guard let ctx: DOMXMLParser = getParser(ctx), let f = ctx.delegate?.parseHasExternalSubset else { return 0 }
            return (f(ctx) ? 1 : 0)
        }
    }

    if let _ = d.parseResolveEntity {
        sxh.saxHandler.resolveEntity = { (ctx: UnsafeMutableRawPointer?, publicId: XStr?, systemId: XStr?) -> xmlParserInputPtr? in
            guard let ctx = getParser(ctx), let f = ctx.delegate?.parseResolveEntity else { return nil }
            // REVISIT: We are making the assumption that the data stream for the entity is UTF-8 data. This might be wrong.
            // The more correct approach will probably be to read it as raw bytes and feed that into the xmlNewStringInputStream.
            guard let input = f(ctx, stringFromXStr(publicId), stringFromXStr(systemId)), let str = String(inputStream: input) else { return nil }
            return xmlNewStringInputStream(ctx.ctx, str)
        }
    }

    if let _ = d.parseGetEntity {
        sxh.saxHandler.getEntity = { (ctx: UnsafeMutableRawPointer?, name: XStr?) -> xmlEntityPtr? in
            guard let ctx = getParser(ctx), let f = ctx.delegate?.parseGetEntity, let name = stringFromXStr(name) else { return nil }
            print("getEntity: \(name)")
            // TODO: Implement....
            return f(ctx, name)?.xEntity
        }
    }

    if let _ = d.parseEntityDecl {
        sxh.saxHandler.entityDecl = { (ctx: UnsafeMutableRawPointer?, name: XStr?, type: Int32, publicId: XStr?, systemId: XStr?, content: XMuStr?) -> Void in
            guard let ctx = getParser(ctx), let f = ctx.delegate?.parseEntityDecl, let name = stringFromXStr(name) else { return }
            var data: [String] = []
            if let s = stringFromXStr(content) { data.append(s) }
            f(ctx, name, Int(type), stringFromXStr(publicId), stringFromXStr(systemId), data)
        }
    }

    if let _ = d.parseNotationDecl {
        sxh.saxHandler.notationDecl = { (ctx: UnsafeMutableRawPointer?, name: XStr?, publicId: XStr?, systemId: XStr?) -> Void in
            guard let ctx = getParser(ctx), let f = ctx.delegate?.parseNotationDecl, let name = stringFromXStr(name) else { return }
            f(ctx, name, stringFromXStr(publicId), stringFromXStr(systemId))
        }
    }

    if let _ = d.parseAttributeDecl {
        sxh.saxHandler.attributeDecl = { (ctx: UnsafeMutableRawPointer?,
                                                  element: XStr?,
                                                  fullName: XStr?,
                                                  type: Int32,
                                                  defType: Int32,
                                                  defaultValue: XStr?,
                                                  tree: xmlEnumerationPtr?) -> Void in
            guard let ctx = getParser(ctx), let f = ctx.delegate?.parseAttributeDecl, let fullName = stringFromXStr(fullName) else { return }
            // TODO
            f(ctx, stringFromXStr(element), fullName, Int(type), Int(defType), stringFromXStr(defaultValue), SAXEnumeration())
        }
    }

    if let _ = d.parseElementDecl {
        sxh.saxHandler.elementDecl = { (ctx: UnsafeMutableRawPointer?, name: XStr?, type: Int32, content: xmlElementContentPtr?) -> Void in
            guard let ctx = getParser(ctx), let f = ctx.delegate?.parseElementDecl, let name = stringFromXStr(name) else { return }
            // TODO
            f(ctx, name, Int(type), SAXElementContent())
        }
    }

    if let _ = d.parseUnparsedEntityDecl {
        sxh.saxHandler.unparsedEntityDecl = { (ctx: UnsafeMutableRawPointer?, name: XStr?, publicId: XStr?, systemId: XStr?, notation: XStr?) -> Void in
            guard let ctx = getParser(ctx), let f = ctx.delegate?.parseUnparsedEntityDecl, let name = stringFromXStr(name) else { return }
            f(ctx, name, stringFromXStr(publicId), stringFromXStr(systemId), stringFromXStr(notation))
        }
    }

    if let _ = d.parseSetDocumentLocator {
        sxh.saxHandler.setDocumentLocator = { (ctx: UnsafeMutableRawPointer?, locator: xmlSAXLocatorPtr?) -> Void in
            guard let parser = getParser(ctx), let f = parser.delegate?.parseSetDocumentLocator else { return }
            if let _l = locator, let _c = ctx { f(parser, SAXLocator(locator: _l, ctx: _c)) }
        }
    }

    if let _ = d.parseStartDocument {
        sxh.saxHandler.startDocument = { (ctx: UnsafeMutableRawPointer?) -> Void in
            guard let ctx = getParser(ctx), let f = ctx.delegate?.parseStartDocument else { return }
            f(ctx)
        }
    }

    if let _ = d.parseEndDocument {
        sxh.saxHandler.endDocument = { (ctx: UnsafeMutableRawPointer?) -> Void in
            guard let ctx = getParser(ctx), let f = ctx.delegate?.parseEndDocument else { return }
            f(ctx)
        }
    }

    if let _ = d.parseStartElement {
        sxh.saxHandler.startElement = { (ctx: UnsafeMutableRawPointer?, name: XStr?, attributes: XStrArr?) -> Void in
            guard let ctx = getParser(ctx), let f = ctx.delegate?.parseStartElement, let name = stringFromXStr(name) else { return }
            f(ctx, name, getAttributes1(attributes: attributes))
        }
    }

    if let _ = d.parseEndElement {
        sxh.saxHandler.endElement = { (ctx: UnsafeMutableRawPointer?, name: XStr?) -> Void in
            guard let ctx = getParser(ctx), let f = ctx.delegate?.parseEndElement, let name = stringFromXStr(name) else { return }
            f(ctx, name)
        }
    }

    if let _ = d.parseReference {
        sxh.saxHandler.reference = { (ctx: UnsafeMutableRawPointer?, name: XStr?) -> Void in
            guard let ctx = getParser(ctx), let f = ctx.delegate?.parseReference, let name = stringFromXStr(name) else { return }
            f(ctx, name)
        }
    }

    if let _ = d.parseCharacters {
        sxh.saxHandler.characters = { (ctx: UnsafeMutableRawPointer?, chars: XStr?, length: Int32) -> Void in
            guard let ctx = getParser(ctx), let f = ctx.delegate?.parseCharacters, let str = stringFromOXStr(chars, length: length) else { return }
            f(ctx, str)
        }
    }

    if let _ = d.parseIgnorableWhitespace {
        sxh.saxHandler.ignorableWhitespace = { (ctx: UnsafeMutableRawPointer?, chars: XStr?, length: Int32) -> Void in
            guard let ctx = getParser(ctx), let f = ctx.delegate?.parseIgnorableWhitespace, let str = stringFromOXStr(chars, length: length) else { return }
            f(ctx, str)
        }
    }

    if let _ = d.parseProcessingInstruction {
        sxh.saxHandler.processingInstruction = { (ctx: UnsafeMutableRawPointer?, target: XStr?, data: XStr?) -> Void in
            guard let ctx = getParser(ctx), let f = ctx.delegate?.parseProcessingInstruction, let target = stringFromXStr(target), let data = stringFromXStr(data) else { return }
            f(ctx, target, data)
        }
    }

    if let _ = d.parseComment {
        sxh.saxHandler.comment = { (ctx: UnsafeMutableRawPointer?, chars: XStr?) -> Void in
            guard let ctx = getParser(ctx), let f = ctx.delegate?.parseComment, let str = stringFromXStr(chars) else { return }
            f(ctx, str)
        }
    }

    if let _ = d.parseGetParameterEntity {
        sxh.saxHandler.getParameterEntity = { (ctx: UnsafeMutableRawPointer?, name: XStr?) -> xmlEntityPtr? in
            guard let ctx = getParser(ctx), let f = ctx.delegate?.parseGetParameterEntity, let name = stringFromXStr(name) else { return nil }
            // TODO
            return f(ctx, name)?.xEntity
        }
    }

    if let _ = d.parseCdataBlock {
        sxh.saxHandler.cdataBlock = { (ctx: UnsafeMutableRawPointer?, chars: XStr?, length: Int32) -> Void in
            guard let ctx = getParser(ctx), let f = ctx.delegate?.parseCdataBlock, let str = stringFromOXStr(chars, length: length) else { return }
            f(ctx, str)
        }
    }

    if let _ = d.parseExternalSubset {
        sxh.saxHandler.externalSubset = { (ctx: UnsafeMutableRawPointer?, name: XStr?, externalId: XStr?, systemId: XStr?) -> Void in
            guard let ctx = getParser(ctx), let f = ctx.delegate?.parseExternalSubset, let name = stringFromXStr(name) else { return }
            f(ctx, name, stringFromXStr(externalId), stringFromXStr(systemId))
        }
    }

    if let _ = d.parseStartElementNs {
        sxh.saxHandler.startElementNs = { (ctx: UnsafeMutableRawPointer?,
                                                   name: XStr?,
                                                   prefix: XStr?,
                                                   uri: XStr?,
                                                   nsCount: Int32,
                                                   nsMaps: XStrArr?,
                                                   attrCount: Int32,
                                                   defCount: Int32,
                                                   attrs: XStrArr?) -> Void in
            guard let ctx = getParser(ctx), let f = ctx.delegate?.parseStartElementNs, let name = stringFromXStr(name) else { return }
            var nsMapss: [SAXNSMap] = []
            var attribs: [SAXAttribute] = []

            if let nsMaps = nsMaps {
                for idx in (0 ..< Int(nsCount)) {
                    if let m = SAXNSMap(nsMaps + (idx * 2)) { nsMapss.append(m) }
                }
            }

            if let attrs = attrs {
                for idx in (0 ..< Int(attrCount)) {
                    let d = (idx >= Int(attrCount - defCount))
                    if let a = SAXAttribute((attrs + (idx * 5)), isDefault: d) { attribs.append(a) }
                }
            }

            f(ctx, name, stringFromXStr(prefix), stringFromXStr(uri), nsMapss, attribs)
        }
    }

    if let _ = d.parseEndElementNs {
        sxh.saxHandler.endElementNs = { (ctx: UnsafeMutableRawPointer?, name: XStr?, prefix: XStr?, uri: XStr?) -> Void in
            guard let ctx = getParser(ctx), let f = ctx.delegate?.parseEndElementNs, let name = stringFromXStr(name) else { return }
            f(ctx, name, stringFromXStr(prefix), stringFromXStr(uri))
        }
    }

    if let _ = d.parseWarning {
        sxh.warningSaxSwiftFunc = { (ctx: UnsafeMutableRawPointer?, msg: UnsafePointer<Int8>?) -> Void in
            guard let ctx: DOMXMLParser = getParser(ctx), let f = ctx.delegate?.parseWarning, let msg = stringFromCStr(msg) else { return }
            f(ctx, DOMXMLParserError.ParserWarning(description: msg))
        }
    }

    if let _ = d.parseError {
        sxh.errorSaxSwiftFunc = { (ctx: UnsafeMutableRawPointer?, msg: UnsafePointer<Int8>?) -> Void in
            guard let ctx: DOMXMLParser = getParser(ctx), let f = ctx.delegate?.parseError, let msg = stringFromCStr(msg) else { return }
            f(ctx, DOMXMLParserError.ParserError(description: msg))
        }
    }

    if let _ = d.parseFatalError {
        sxh.fatalErrorSaxSwiftFunc = { (ctx: UnsafeMutableRawPointer?, msg: UnsafePointer<Int8>?) -> Void in
            guard let ctx: DOMXMLParser = getParser(ctx), let f = ctx.delegate?.parseFatalError, let msg = stringFromCStr(msg) else { return }
            f(ctx, DOMXMLParserError.ParserFatalError(description: msg))
        }
    }
}
