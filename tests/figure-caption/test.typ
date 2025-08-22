#import "../minimal-template.typ": ijimai
#show: ijimai

// Period is not included in the caption:
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

// Period is included in the caption:
#figure(rect(), caption: ".") // Empty caption with period
#figure(rect(), caption: "String caption.")
#figure(rect(), caption: [.]) // Empty caption with period
#figure(rect(), caption: [Simple content caption.])
#figure(rect(), caption: [Complex --- `content` caption.])
#figure(rect(), caption: emph[Emphasized content caption.])
#figure(rect(), caption: strong[Strong content caption.])
#figure(rect(), caption: [_Styled_ *content* caption.])
#figure(rect(), caption: [Referencing @a.])
