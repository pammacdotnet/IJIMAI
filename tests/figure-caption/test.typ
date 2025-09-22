#import "../minimal-template.typ": ijimai
#show: ijimai
#set figure(placement: none)

// There is a requirement from Editor-in-Chief from IJIMAI, for figure captions
// (`image` figures) to always have period at the end.
//
// See https://github.com/pammacdotnet/IJIMAI/pull/13 for details.

Period is not included in the caption but should be appended (if caption is not
empty). There must be no spaces before the period:

#figure([]) // No caption
#figure([], caption: "") // Empty caption
#figure([], caption: "String caption")
#figure([], caption: []) // Empty caption
#figure([], caption: [Simple content caption])
#figure([], caption: [Complex --- `content` caption])
#figure([], caption: emph[Emphasized content caption])
#figure([], caption: strong[Strong content caption])
#figure([], caption: [_Styled_ *content* caption])
#figure([], caption: [Referencing @a])
#figure([], caption: [Caption with space ])
#figure([], caption: [Caption with comment
  // Some comment.
])
#figure([], caption: [Caption with `raw `])
#figure([], caption: [Caption with `linebreak` \
])
#figure([], caption: [Caption with `parbreak`

])

#pagebreak()

Period is included in the caption and exactly 1 period should exist:

#figure([], caption: ".") // Empty caption with period
#figure([], caption: "String caption.")
#figure([], caption: [.]) // Empty caption with period
#figure([], caption: [Simple content caption.])
#figure([], caption: [Complex --- `content` caption.])
#figure([], caption: emph[Emphasized content caption.])
#figure([], caption: strong[Strong content caption.])
#figure([], caption: [_Styled_ *content* caption.])
#figure([], caption: [Referencing @a.])
#figure([], caption: [Caption with space. ])
#figure([], caption: [Caption with comment.
  // Some comment.
])
#figure([], caption: [Caption with `raw.`])
#figure([], caption: [Caption with `linebreak`. \
])
#figure([], caption: [Caption with `parbreak`.

])
