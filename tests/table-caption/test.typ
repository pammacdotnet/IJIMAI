#import "../minimal-template.typ": ijimai
#show: ijimai

// Period is not included in the caption:
#figure(table[]) // No caption
#figure(table[], caption: "") // Empty caption
#figure(table[], caption: "String caption")
#figure(table[], caption: []) // Empty caption
#figure(table[], caption: [Simple content caption])
#figure(table[], caption: [Complex --- `content` caption])
#figure(table[], caption: emph[Emphasized content caption])
#figure(table[], caption: strong[Strong content caption])
#figure(table[], caption: [_Styled_ *content* caption])
#figure(table[], caption: [Referencing @a])
#figure(table(), caption: [Caption with space ])
#figure(table(), caption: [Caption with comment
  // Some comment.
])
#figure(table(), caption: [Caption with `raw `])
#figure(table(), caption: [Caption with `linebreak` \
])
#figure(table(), caption: [Caption with `parbreak`

])

// Period is included in the caption:
#figure(table[], caption: ".") // Empty caption with period
#figure(table[], caption: "String caption.")
#figure(table[], caption: [.]) // Empty caption with period
#figure(table[], caption: [Simple content caption.])
#figure(table[], caption: [Complex --- `content` caption.])
#figure(table[], caption: emph[Emphasized content caption.])
#figure(table[], caption: strong[Strong content caption.])
#figure(table[], caption: [_Styled_ *content* caption.])
#figure(table[], caption: [Referencing @a.])
#figure(table(), caption: [Caption with space. ])
#figure(table(), caption: [Caption with comment.
  // Some comment.
])
#figure(table(), caption: [Caption with `raw.`])
#figure(table(), caption: [Caption with `linebreak`. \
])
#figure(table(), caption: [Caption with `parbreak`.

])
