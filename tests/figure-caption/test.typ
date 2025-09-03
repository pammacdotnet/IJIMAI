#import "../minimal-template.typ": ijimai
#show: ijimai
#set figure(placement: none)

Period is not included in the caption:

#figure(rect()) // No caption
#figure(rect(), caption: "") // Empty caption
#figure(rect(), caption: "String caption")
#figure(rect(), caption: []) // Empty caption
#figure(rect(), caption: [Simple content caption])
#figure(rect(), caption: [Complex --- `content` caption])
#figure(rect(), caption: emph[Emphasized content caption])
#figure(rect(), caption: strong[Strong content caption])
#figure(rect(), caption: [_Styled_ *content* caption])
#figure(rect(), caption: [Referencing @a])
#figure(rect(), caption: [Caption with space ])
#figure(rect(), caption: [Caption with comment
  // Some comment.
])
#figure(rect(), caption: [Caption with `raw `])
#figure(rect(), caption: [Caption with `linebreak` \
])
#figure(rect(), caption: [Caption with `parbreak`

])

#pagebreak()

Period is included in the caption:

#figure(rect(), caption: ".") // Empty caption with period
#figure(rect(), caption: "String caption.")
#figure(rect(), caption: [.]) // Empty caption with period
#figure(rect(), caption: [Simple content caption.])
#figure(rect(), caption: [Complex --- `content` caption.])
#figure(rect(), caption: emph[Emphasized content caption.])
#figure(rect(), caption: strong[Strong content caption.])
#figure(rect(), caption: [_Styled_ *content* caption.])
#figure(rect(), caption: [Referencing @a.])
#figure(rect(), caption: [Caption with space. ])
#figure(rect(), caption: [Caption with comment.
  // Some comment.
])
#figure(rect(), caption: [Caption with `raw.`])
#figure(rect(), caption: [Caption with `linebreak`. \
])
#figure(rect(), caption: [Caption with `parbreak`.

])
