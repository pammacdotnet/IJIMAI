#import "../minimal-template.typ": ijimai
#show: ijimai
#set figure(placement: none)

// There is a requirement from Editor-in-Chief from IJIMAI, for figure captions
// (`image` figures) to always have period at the end.
//
// See https://github.com/pammacdotnet/IJIMAI/pull/13 for details.

Period is not included in the caption but should be appended (if caption is not
empty). There must be no spaces before the period:

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

Period is included in the caption and exactly 1 period should exist:

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
