#import "../minimal-template.typ": ijimai
#show: ijimai
#set figure(placement: none)

// There is a requirement from Editor-in-Chief from IJIMAI, for table captions
// (`table` figures) to never have period at the end.
//
// See https://github.com/pammacdotnet/IJIMAI/pull/13 for details.

Period is not included in the caption and should be absent:

#figure(table()) // No caption
#figure(table(), caption: "") // Empty caption
#figure(table(), caption: "String caption")
#figure(table(), caption: []) // Empty caption
#figure(table(), caption: [Simple content caption])
#figure(table(), caption: [Simple content caption with space ])
#figure(table(), caption: [_Complex_ --- *content* caption])
#figure(table(), caption: emph[Emphasized content caption])
#figure(table(), caption: strong[Strong content caption])
#figure(table(), caption: [Referencing @a])
#figure(table(), caption: [Caption with comment
  // Some comment.
])
#figure(table(), caption: [Caption with `raw`])
#figure(table(), caption: [Caption with `linebreak` \
])
#figure(table(), caption: [Caption with `parbreak`

])

#pagebreak()

Period is included in the caption but should be removed:

#figure(table(), caption: ".") // Empty caption with period
#figure(table(), caption: "String caption.")
#figure(table(), caption: [.]) // Empty caption with period
#figure(table(), caption: [Simple content caption.])
#figure(table(), caption: [Simple content caption with space. ])
#figure(table(), caption: [_Complex_ --- *content* caption.])
#figure(table(), caption: emph[Emphasized content caption.])
#figure(table(), caption: strong[Strong content caption.])
#figure(table(), caption: [Referencing @a.])
#figure(table(), caption: [Caption with comment.
  // Some comment.
])
#figure(table(), caption: [Caption with `raw.`])
#figure(table(), caption: [Caption with `linebreak`. \
])
#figure(table(), caption: [Caption with `parbreak`.

])
