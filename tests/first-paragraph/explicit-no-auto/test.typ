#import "../../minimal-template.typ": first-paragraph, ijimai-no-content as ijimai
#show: ijimai.with(auto-first-paragraph: false)
// You can explicitly use `first-paragraph` function in case implicit approach
// gives an error. It is unlikely, but there is no guarantee that implicit
// approach is 100% reliable. Prefer the implicit approach.
//
// In cases where template's par show rule breaks user's par show rule (if it
// exists at all) or anything related to it, `ijimai.auto-first-paragraph` can
// be set to `false`, mitigating any potential error.
= Introduction
#first-paragraph[The][first paragraph.]
= CRediT authorship contribution statement
= Data statement
= Declaration of conflicts of interest
= Acknowledgment
