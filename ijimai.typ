#import "@preview/wrap-it:0.1.1": wrap-content
#import "@preview/datify:0.1.4": custom-date-format, day-name, month-name
#import "@preview/droplet:0.3.1": dropcap
#import "@preview/t4t:0.4.3": get
//#import "@preview/decasify:0.10.1": *
#import "@preview/titleize:0.1.1": titlecase
#let blueunir = rgb("#0098cd")
#let softblueunir = rgb("eaf6fd")
#let space-above-tables = 4.5mm
#let space-above-images = 4.5mm
#let abstract-font-size = 8.8pt

#let ijimai(conf: none, photos: (), logo: none, bib-data: none, body) = {
  set text(font: "Libertinus Serif", size: 9pt, lang: "en")
  set columns(gutter: 0.4cm)
  set math.equation(numbering: n => numbering("(1)", n), supplement: none)
  set page(
    paper: "ansi-a",
    margin: 1.5cm,
    columns: 2,
    header: context {
      set align(center)
      set text(10pt, blueunir, font: "Unit OT", weight: "light", style: "italic")

      if (conf.paper.special-issue == true) {
        let gradient = gradient.linear(white, blueunir, angle: 180deg)
        let stripe = rect.with(width: 165%, height: 17pt - 8%)
        if calc.odd(here().page()) {
          place(dx: -80%, stripe(fill: gradient))
        } else {
          place(dx: -page.margin, stripe(fill: gradient.sharp(5)))
        }
      }

      if calc.odd(here().page()) {
        if (conf.paper.special-issue) {
          conf.paper.special-issue-title
        } else [Regular issue]
      } else {
        let (journal, volume, number) = conf.paper
        [#journal, Vol. #volume, N#super[o]#number]
      }
    },
    footer: context {
      set align(center)
      set text(8pt, blueunir, font: "Unit OT")
      "- " + counter(page).display() + " -"
    },
  )

  show bibliography: it => {
    show link: set text(blue)
    show link: underline
    it
  }

  // Used for table figure caption.
  // See https://github.com/pammacdotnet/IJIMAI/pull/13 for details.
  let remove-trailing-period(element, sep: "") = {
    assert(type(element) == content)
    let sequence = [].func()
    let space = [ ].func()
    let styled = text(red)[].func()
    if element.func() == text {
      element.text.slice(0, -1)
    } else if element.func() == space {
      " "
    } else if element.func() == sequence {
      let (..rest, last) = element.children
      (..rest, remove-trailing-period(last)).join()
    } else if element.func() == styled {
      styled(styles: element.styles, remove-trailing-period(element.child))
    } else if element.func() == emph {
      emph(remove-trailing-period(element.body))
    } else if element.func() == strong {
      strong(remove-trailing-period(element.body))
    } else {
      panic(repr(element.func()) + " was not handled properly")
    }
  }

  // show figure.caption.where(kind: table): smallcaps
  show figure.caption.where(kind: table): it => {
    show: smallcaps
    let text = get.text(it)
    // text == none when caption == [].
    // Don't remove period for empty caption.
    // Don't remove period if doesn't exist.
    if text == none or text.len() == 0 or text.last() != "." { it } else {
      show: block
      it.supplement
      if it.supplement != none { sym.space.nobreak }
      context it.counter.display(it.numbering)
      it.separator
      remove-trailing-period(it.body)
    }
  }

  show figure.caption.where(kind: image): it => {
    let text = get.text(it)
    // text == none when caption == [].
    // Don't add period for empty caption.
    // Don't add period if already exist.
    if text == none or text.len() == 0 or text.last() == "." { return it }
    show: block
    it.supplement
    if it.supplement != none { sym.space.nobreak }
    context it.counter.display(it.numbering)
    it.separator
    it.body + "."
  }

  let in-ref = state("in-ref", false)
  show ref: it => in-ref.update(true) + it + in-ref.update(false)

  // Make floating figures by default to avoid gaps in document flow.
  set figure(placement: auto)
  show figure.where(kind: image): set figure(supplement: "Fig.")
  show figure.where(kind: image): set block(below: space-above-images)
  show figure.where(kind: table): set block(above: space-above-tables)
  show figure.where(kind: table): set block(below: space-above-tables)
  show figure.where(kind: table): set block(breakable: true)
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: table): set figure(
    supplement: context if in-ref.get() [Table] else [TABLE],
    numbering: "I",
  )

  set figure.caption(separator: [. ])

  set heading(numbering: "I.A.a)")

  show heading: it => {
    let levels = counter(heading).get()
    let deepest = if levels != () {
      levels.last()
    } else {
      1
    }

    set text(10pt, weight: "regular")
    if it.level == 1 {
      let is-ack = it.body in ([Acknowledgment], [Acknowledgement], [Acknowledgments], [Acknowledgements])
      set align(center)
      set text(if is-ack { 10pt } else { 11pt })
      show: block.with(above: 15pt, below: 13.75pt, sticky: true)
      if it.numbering != none and not is-ack {
        numbering("I.", deepest)
        h(7pt, weak: true)
      }
      show: smallcaps
      show: titlecase
      it.body
    } else if it.level == 2 {
      //set par(first-line-indent: 0pt)
      set text(style: "italic")
      show: block.with(spacing: 10pt, sticky: true, above: 1.2em + 0.22em)
      if it.numbering != none {
        emph(text(fill: blueunir)[#numbering("A.", deepest)])
        h(7pt, weak: true)
      }
      emph(text(fill: blueunir)[#it.body])
    } else [
      #if it.level == 3 {
        numbering("a)", deepest)
        [ ]
      }
      _#(it.body):_
    ]
  }

  show heading.where(level: 1): it => {
    text(fill: blueunir)[#it]
    v(-12pt)
    line(length: 100%, stroke: blueunir + 0.5pt)
  }

  show heading.where(level: 2): it => {
    emph(text(fill: blueunir)[#it])
  }

  show regex("Equation"): set text(fill: blueunir)

  let authors = conf.authors.filter(author => author.include)
  let institution-names = authors.map(author => author.institution).dedup()
  let numbered-institution-names = institution-names.enumerate(start: 1)
  let authors-string = authors
    .map(author => {
      let institution-number = numbered-institution-names
        .filter(((_, name)) => name == author.institution)
        .first() // One and only numbered institution
        .first() // Institution number
      [#author.name#h(0.7pt)#super[#institution-number]]
      if author.corresponding [#super[#sym.star]]
    })
    .join(", ")

  counter(page).update(conf.paper.starting-page)

  place(
    top + left,
    scope: "parent",
    float: true,
    dy: 0.6cm,
  )[
    #align(left)[
      #par(spacing: 0.7cm, leading: 1.5em)[
        #text(size: 24pt)[#titlecase(conf.paper.title)]
      ]]

    #text(fill: blueunir, size: 13pt)[#authors-string]

    #text(fill: black, size: 10pt)[
      #(
        numbered-institution-names
          .map(((number, name)) => super[#number] + " " + eval(name, mode: "markup"))
          .join([\ ])
      )
    ]

    #text(fill: blueunir)[#super[#sym.star] Corresponding author:] #(
      authors.filter(author => author.corresponding).at(0).email
    )

    #v(0.3cm)
    #let received-date-string = [#conf.paper.received-date.day() #month-name(
        conf.paper.received-date.month(),
        true,
      ) #conf.paper.received-date.year()]
    #let accepted-date-string = [#conf.paper.accepted-date.day() #month-name(
        conf.paper.accepted-date.month(),
        true,
      ) #conf.paper.accepted-date.year()]
    #let published-date-string = [#conf.paper.published-date.day() #month-name(
        conf.paper.published-date.month(),
        true,
      ) #conf.paper.published-date.year()]
    #underline(offset: 4pt, stroke: blueunir)[#overline(offset: -10pt, stroke: blueunir)[#text(
      font: "Unit OT",
      size: 8pt,
    )[Received #received-date-string | Accepted #accepted-date-string | Published #published-date-string]]]

    #context [
      #let abstract-y = here().position().y
      #place(
        top + left,
        dx: 14.8cm,
        dy: abstract-y - 5cm,
        logo,
      )]
    #v(1.3cm)


    #let keywords-string = (conf.paper.keywords.sorted().join(", ") + ".")

    #grid(
      columns: (3.5fr, 1fr),
      rows: (auto, 60pt),
      gutter: 25pt,
      [#text(size: 15pt, font: "Unit OT", fill: blueunir)[A]#text(
          size: 13pt,
          font: "Unit OT",
          fill: blueunir,
        )[BSTRACT]#v(-.3cm)#line(length: 100%, stroke: blueunir) #par(justify: true, leading: 5.5pt)[#text(
          size: abstract-font-size,
        )[#conf.paper.abstract]]],
      [#text(size: 15pt, font: "Unit OT", fill: blueunir)[K]#text(
          size: 13pt,
          font: "Unit OT",
          fill: blueunir,
        )[EYWORDS]#v(-.3cm)#line(length: 100%, stroke: blueunir) #par(justify: false, leading: 4pt)[#text(
          size: abstract-font-size,
        )[#keywords-string]] #align(left + bottom)[
          #underline(offset: 4pt, stroke: blueunir)[#overline(offset: -10pt, stroke: blueunir)[#text(
            font: "Unit OT",
            size: 7.5pt,
          )[#text(fill: blueunir, "DOI: ") #conf.paper.doi]]]]],
    )
    #v(-1.7cm)
  ]

  let author-bios = (
    authors
      .enumerate()
      .map(author => {
        let author-photo = image(bytes(photos.at(author.at(0))), width: 2cm)
        let author-bio = [#par(
            text(fill: blueunir, font: "Unit OT", size: 8.0pt, author.at(1).name),
          ) #(
            text(size: 8pt, eval(author.at(1).bio, mode: "markup"))
          )]
        wrap-content(author-photo, author-bio)
      })
      .join()
  )

  set par(justify: true, leading: 5pt, first-line-indent: 1em, spacing: .25cm)

  body
  show regex("^\[\d+\]"): set text(fill: blueunir)

  set par(leading: 4pt, spacing: 5.5pt, first-line-indent: 0pt)
  set text(size: 7.5pt, lang: "en")

  bibliography(bib-data, style: "ieee", title: "References")
  v(1cm)
  set par(leading: 4pt, spacing: 9.5pt)
  author-bios
}


#let first-paragraph(conf: none, first-word: "The", body) = {
  let doi-link-text = "https://dx.doi.org/" + conf.paper.doi
  let doi-link = link(doi-link-text, doi-link-text)
  let last-page = context counter(page).final().first()

  let cite-string = [
    #conf.paper.short-author-list. #conf.paper.title. #conf.paper.journal, vol. #conf.paper.volume, no. #conf.paper.number, pp. #conf.paper.starting-page - #last-page, #conf.paper.publication-year, #doi-link]

  let cite-as-section = align(
    left,
    rect(
      fill: silver,
      width: 100%,
      stroke: 0.5pt + blueunir,
    )[#par(leading: .1cm)[#text(size: 8.1pt)[Please, cite this article as: #cite-string]]],
  )

  dropcap(
    height: 2,
    gap: 1pt,
    hanging-indent: 1em,
    overhang: 0pt,
    fill: blueunir,
  )[
    #upper(text(fill: blueunir, weight: "semibold", first-word)) #body
  ]


  figure(
    cite-as-section,
    scope: "parent",
    placement: bottom,
  )
  counter(figure.where(kind: image)).update(0)
}

