#import "../ijimai.typ": ijimai as base-template, first-paragraph

#let config = ```toml
[[authors]]
name = ""
include = true
corresponding = true
email = ""
institution = ""
credit = []
bio = ""

[paper]
abstract = ""
journal = ""
volume = 0
number = 0
starting-page = 0
publication-year = 0
title = ""
doi = ""
short-author-list = ""
special-issue-title = ""
special-issue = false
keywords = []
received-date = 1970-01-01
accepted-date = 1970-01-01
published-date = 1970-01-01
```.text

#let bib = ```yaml
a:
  type: article
```.text

#let ijimai-no-content(
  config: toml(bytes(config)),
  photos: ("<svg xmlns='http://www.w3.org/2000/svg'></svg>",),
  logo: none,
  bib-data: bytes(bib),
  doc,
) = {
  show: base-template.with(
    config: config,
    photos: photos,
    logo: logo,
    bib-data: bib-data,
  )
  doc
}

#let ijimai(
  config: toml(bytes(config)),
  photos: ("<svg xmlns='http://www.w3.org/2000/svg'></svg>",),
  logo: none,
  bib-data: bytes(bib),
  doc,
) = [
  #show: base-template.with(
    config: config,
    photos: photos,
    logo: logo,
    bib-data: bib-data,
  )
  #state("_ijimai-generate-author-credit-roles").update(false)
  #doc
  = Introduction
  = CRediT authorship contribution statement
  = Data statement
  = Declaration of conflicts of interest
  = Acknowledgment
  // Don't add empty vertical spacing at the start of a test, but at the end.
  // Makes tests look better (since tested content is normally at the start).
  #first-paragraph[][]
]
