#import "../minimal-template.typ": ijimai-no-content as ijimai
#show: ijimai
// The 2 different assertion are triggered when:
// - no first paragraph is specified (empty Introduction section)
// - the first paragraph is a single letter (grapheme cluster)
//
// Can't check if the first letter (grapheme cluster) of the first paragraph is
// not uppercase. See comment in `first-paragraph`.

#let first-paragraph = [A simple (short) sentence. #lorem(40)]
#let sequence = [].func()
#assert(first-paragraph.func() == sequence)
= Introduction
#first-paragraph
= CRediT authorship contribution statement
= Data statement
= Declaration of conflicts of interest
= Acknowledgment
