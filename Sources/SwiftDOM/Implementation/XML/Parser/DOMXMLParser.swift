/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: DOMXMLParser.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 11/3/20
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

//@f:0
public typealias SAXAttributeDeclFunc         = (DOMXMLParser, String?, String, Int, Int, String?, SAXEnumeration)   -> Void
public typealias SAXAttributeFunc             = (DOMXMLParser, String, String)                                       -> Void
public typealias SAXCdataBlockFunc            = (DOMXMLParser, String)                                               -> Void
public typealias SAXCharactersFunc            = (DOMXMLParser, String)                                               -> Void
public typealias SAXCommentFunc               = (DOMXMLParser, String)                                               -> Void
public typealias SAXElementDeclFunc           = (DOMXMLParser, String, Int, SAXElementContent)                       -> Void
public typealias SAXEndDocumentFunc           = (DOMXMLParser)                                                       -> Void
public typealias SAXEndElementFunc            = (DOMXMLParser, String)                                               -> Void
public typealias SAXEntityDeclFunc            = (DOMXMLParser, String, Int, String?, String?, [String])              -> Void
public typealias SAXErrorFunc                 = (DOMXMLParser, Error)                                                -> Void
public typealias SAXExternalSubsetFunc        = (DOMXMLParser, String, String?, String?)                             -> Void
public typealias SAXFatalErrorFunc            = (DOMXMLParser, Error)                                                -> Void
public typealias SAXGetEntityFunc             = (DOMXMLParser, String)                                               -> SAXEntity?
public typealias SAXGetParameterEntityFunc    = (DOMXMLParser, String)                                               -> SAXEntity?
public typealias SAXHasExternalSubsetFunc     = (DOMXMLParser)                                                       -> Bool
public typealias SAXHasInternalSubsetFunc     = (DOMXMLParser)                                                       -> Bool
public typealias SAXIgnorableWhitespaceFunc   = (DOMXMLParser, String)                                               -> Void
public typealias SAXInternalSubsetFunc        = (DOMXMLParser, String, String?, String?)                             -> Void
public typealias SAXIsStandaloneFunc          = (DOMXMLParser)                                                       -> Bool
public typealias SAXNotationDeclFunc          = (DOMXMLParser, String, String?, String?)                             -> Void
public typealias SAXProcessingInstructionFunc = (DOMXMLParser, String, String)                                       -> Void
public typealias SAXReferenceFunc             = (DOMXMLParser, String)                                               -> Void
public typealias SAXResolveEntityFunc         = (DOMXMLParser, String?, String?)                                     -> InputStream?
public typealias SAXSetDocumentLocatorFunc    = (DOMXMLParser, SAXLocator)                                           -> Void
public typealias SAXStartDocumentFunc         = (DOMXMLParser)                                                       -> Void
public typealias SAXStartElementFunc          = (DOMXMLParser, String, [SAXAttribute])                               -> Void
public typealias SAXUnparsedEntityDeclFunc    = (DOMXMLParser, String, String?, String?, String?)                    -> Void
public typealias SAXWarningFunc               = (DOMXMLParser, Error)                                                -> Void
public typealias SAXStartElementNsFunc        = (DOMXMLParser, String, String?, String?, [SAXNSMap], [SAXAttribute]) -> Void
public typealias SAXEndElementNsFunc          = (DOMXMLParser, String, String?, String?)                             -> Void

public protocol DOMXMLParserDelegate {
     var parseAttributeDecl         : SAXAttributeDeclFunc?         { get set }
     var parseAttribute             : SAXAttributeFunc?             { get set }
     var parseCdataBlock            : SAXCdataBlockFunc?            { get set }
     var parseCharacters            : SAXCharactersFunc?            { get set }
     var parseComment               : SAXCommentFunc?               { get set }
     var parseElementDecl           : SAXElementDeclFunc?           { get set }
     var parseEndDocument           : SAXEndDocumentFunc?           { get set }
     var parseEndElement            : SAXEndElementFunc?            { get set }
     var parseEntityDecl            : SAXEntityDeclFunc?            { get set }
     var parseError                 : SAXErrorFunc?                 { get set }
     var parseExternalSubset        : SAXExternalSubsetFunc?        { get set }
     var parseFatalError            : SAXFatalErrorFunc?            { get set }
     var parseGetEntity             : SAXGetEntityFunc?             { get set }
     var parseGetParameterEntity    : SAXGetParameterEntityFunc?    { get set }
     var parseHasExternalSubset     : SAXHasExternalSubsetFunc?     { get set }
     var parseHasInternalSubset     : SAXHasInternalSubsetFunc?     { get set }
     var parseIgnorableWhitespace   : SAXIgnorableWhitespaceFunc?   { get set }
     var parseInternalSubset        : SAXInternalSubsetFunc?        { get set }
     var parseIsStandalone          : SAXIsStandaloneFunc?          { get set }
     var parseNotationDecl          : SAXNotationDeclFunc?          { get set }
     var parseProcessingInstruction : SAXProcessingInstructionFunc? { get set }
     var parseReference             : SAXReferenceFunc?             { get set }
     var parseResolveEntity         : SAXResolveEntityFunc?         { get set }
     var parseSetDocumentLocator    : SAXSetDocumentLocatorFunc?    { get set }
     var parseStartDocument         : SAXStartDocumentFunc?         { get set }
     var parseStartElement          : SAXStartElementFunc?          { get set }
     var parseUnparsedEntityDecl    : SAXUnparsedEntityDeclFunc?    { get set }
     var parseWarning               : SAXWarningFunc?               { get set }
     var parseStartElementNs        : SAXStartElementNsFunc?        { get set }
     var parseEndElementNs          : SAXEndElementNsFunc?          { get set }
}
//@f:1
