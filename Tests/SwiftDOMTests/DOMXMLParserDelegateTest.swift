/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: DOMXMLParserDelegateTest.swift
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
@testable import SwiftDOM

class MyDelegate: DOMXMLParserDelegate {
//@f:0
    var parseAttributeDecl        : SAXAttributeDeclFunc?         = { (ctx: DOMXMLParser, element:  String?, name:       String,  type:     Int,     defType:  Int,        defValue:   String?, enumer: SAXEnumeration) in print("parseAttributeDecl:")                        }
    var parseStartElementNs       : SAXStartElementNsFunc?        = { (ctx: DOMXMLParser, name:     String,  uri:        String?, pfx:      String?, nsMaps:   [SAXNSMap], attributes: [SAXAttribute]                 ) in print("parseStartElementNs:")                       }
    var parseEntityDecl           : SAXEntityDeclFunc?            = { (ctx: DOMXMLParser, name:     String,  type:       Int,     publicId: String?, systemId: String?,    content:    [String]                       ) in print("parseEntityDecl:")                           }
    var parseUnparsedEntityDecl   : SAXUnparsedEntityDeclFunc?    = { (ctx: DOMXMLParser, name:     String,  publicId:   String?, systemId: String?, notation: String?                                                ) in print("parseUnparsedEntityDecl:")                   }
    var parseElementDecl          : SAXElementDeclFunc?           = { (ctx: DOMXMLParser, name:     String,  type:       Int,     content:  SAXElementContent                                                         ) in print("parseElementDecl:")                          }
    var parseInternalSubset       : SAXInternalSubsetFunc?        = { (ctx: DOMXMLParser, name:     String,  publicId:   String?, systemId: String?                                                                   ) in print("parseInternalSubset:")                       }
    var parseNotationDecl         : SAXNotationDeclFunc?          = { (ctx: DOMXMLParser, name:     String,  publicId:   String?, systemId: String?                                                                   ) in print("parseNotationDecl:")                         }
    var parseExternalSubset       : SAXExternalSubsetFunc?        = { (ctx: DOMXMLParser, name:     String,  externalId: String?, systemId: String?                                                                   ) in print("parseExternalSubset:")                       }
    var parseEndElementNs         : SAXEndElementNsFunc?          = { (ctx: DOMXMLParser, name:     String,  uri:        String?, pfx:      String?                                                                   ) in print("parseEndElementNs:")                         }
    var parseStartElement         : SAXStartElementFunc?          = { (ctx: DOMXMLParser, name:     String,  attributes: [SAXAttribute]                                                                               ) in print("parseStartElement:")                         }
    var parseResolveEntity        : SAXResolveEntityFunc?         = { (ctx: DOMXMLParser, publicId: String?, systemId:   String?                                                                                      ) in print("parseResolveEntity:")        ; return nil    }
    var parseAttribute            : SAXAttributeFunc?             = { (ctx: DOMXMLParser, name:     String,  value:      String                                                                                       ) in print("parseAttribute:")                            }
    var parseProcessingInstruction: SAXProcessingInstructionFunc? = { (ctx: DOMXMLParser, target:   String,  data:       String                                                                                       ) in print("parseProcessingInstruction:")                }
    var parseSetDocumentLocator   : SAXSetDocumentLocatorFunc?    = { (ctx: DOMXMLParser, locator:  SAXLocator                                                                                                        ) in print("parseSetDocumentLocator:")                   }
    var parseCdataBlock           : SAXCdataBlockFunc?            = { (ctx: DOMXMLParser, content:  String                                                                                                            ) in print("parseCdataBlock:")                           }
    var parseCharacters           : SAXCharactersFunc?            = { (ctx: DOMXMLParser, content:  String                                                                                                            ) in print("parseCharacters:")                           }
    var parseComment              : SAXCommentFunc?               = { (ctx: DOMXMLParser, content:  String                                                                                                            ) in print("parseComment:")                              }
    var parseIgnorableWhitespace  : SAXIgnorableWhitespaceFunc?   = { (ctx: DOMXMLParser, content:  String                                                                                                            ) in print("parseIgnorableWhitespace:")                  }
    var parseEndElement           : SAXEndElementFunc?            = { (ctx: DOMXMLParser, name:     String                                                                                                            ) in print("parseEndElement:")                           }
    var parseGetEntity            : SAXGetEntityFunc?             = { (ctx: DOMXMLParser, name:     String                                                                                                            ) in print("parseGetEntity:")            ;  return nil   }
    var parseGetParameterEntity   : SAXGetParameterEntityFunc?    = { (ctx: DOMXMLParser, name:     String                                                                                                            ) in print("parseGetParameterEntity:")   ;  return nil   }
    var parseReference            : SAXReferenceFunc?             = { (ctx: DOMXMLParser, name:     String                                                                                                            ) in print("parseReference:")                            }
    var parseWarning              : SAXWarningFunc?               = { (ctx: DOMXMLParser, error:    Error                                                                                                             ) in print("parseWarning:")                              }
    var parseError                : SAXErrorFunc?                 = { (ctx: DOMXMLParser, error:    Error                                                                                                             ) in print("parseError:")                                }
    var parseFatalError           : SAXFatalErrorFunc?            = { (ctx: DOMXMLParser, error:    Error                                                                                                             ) in print("parseFatalError:")                           }
    var parseIsStandalone         : SAXIsStandaloneFunc?          = { (ctx: DOMXMLParser                                                                                                                              ) in print("parseIsStandalone:")         ; return false  }
    var parseHasExternalSubset    : SAXHasExternalSubsetFunc?     = { (ctx: DOMXMLParser                                                                                                                              ) in print("parseHasExternalSubset:")    ; return false  }
    var parseHasInternalSubset    : SAXHasInternalSubsetFunc?     = { (ctx: DOMXMLParser                                                                                                                              ) in print("parseHasInternalSubset:")    ; return false  }
    var parseStartDocument        : SAXStartDocumentFunc?         = { (ctx: DOMXMLParser                                                                                                                              ) in print("parseStartDocument:")                        }
    var parseEndDocument          : SAXEndDocumentFunc?           = { (ctx: DOMXMLParser                                                                                                                              ) in print("parseEndDocument:")                          }
//@f:1
}
