#import "../../minimal-template.typ": ijimai-no-content as ijimai
#show: ijimai
// The 2 different assertion are triggered when:
// - no first paragraph is specified (empty Introduction section)
// - the first paragraph is a single letter (grapheme cluster)
//
// Can't check if the first letter (grapheme cluster) of the first paragraph is
// not uppercase. See comment in `first-paragraph`.

// No punctuation, just a few words and a period at the end.
#let first-paragraph = [#lorem(5)]
#assert(first-paragraph.func() == text)
= Introduction
#first-paragraph
= CRediT authorship contribution statement
= Data statement
= Declaration of conflicts of interest
= Acknowledgment
