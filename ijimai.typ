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

/// Remove indentation for a specific paragraph. This is useful when using
/// "where" paragraph right after an equation that must not be indented.
#let no-indent(body) = {
  set par(first-line-indent: 0pt)
  body
}

/// The template function.
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

  /// Used for table figure caption.
  /// See https://github.com/pammacdotnet/IJIMAI/pull/13 for details.
  let remove-trailing-period(element) = {
    assert(type(element) == content)
    let sequence = [].func()
    let space = [ ].func()
    let styled = text(red)[].func()
    if element.func() == text {
      if element.text.last() != "." { element } else {
        text(element.text.slice(0, -1))
      }
    } else if element.func() in (space, linebreak, parbreak) {
    } else if element.func() == sequence {
      let (..rest, last) = element.children
      (..rest, remove-trailing-period(last)).join()
    } else if element.func() == styled {
      styled(styles: element.styles, remove-trailing-period(element.child))
    } else if element.func() == emph {
      emph(remove-trailing-period(element.body))
    } else if element.func() == strong {
      strong(remove-trailing-period(element.body))
    } else if element.func() == ref {
      element
    } else if element.func() == raw {
      let fields = element.fields()
      let text = fields.remove("text")
      raw(..fields, text.replace(regex("\\.$"), ""))
    } else {
      panic(repr(element.func()) + " was not handled properly")
    }
  }

  /// Used to normalize figure captions. If there is an invisible space of
  /// different kinds at the end of the caption, it will remove all of them,
  /// until there are none left.
  /// See https://github.com/pammacdotnet/IJIMAI/pull/13 for details.
  let remove-trailing-spaces(element) = {
    if element == none { return element }
    assert(type(element) == content)
    let sequence = [].func()
    let space = [ ].func()
    let styled = text(red)[].func()
    let new = if element.func() == text {
      if element.text.last() != " " { element } else {
        text(element.text.slice(0, -1))
      }
    } else if element.func() == raw {
      if element.text.last() != " " { element } else {
        let fields = element.fields()
        let text = fields.remove("text")
        raw(..fields, text.slice(0, -1))
      }
    } else if element.func() in (space, linebreak, parbreak) {
    } else if element.func() == sequence {
      let (..rest, last) = element.children
      (..rest, remove-trailing-spaces(last)).join()
    } else if element.func() == styled {
      styled(styles: element.styles, remove-trailing-spaces(element.child))
    } else if element.func() == emph {
      emph(remove-trailing-spaces(element.body))
    } else if element.func() == strong {
      strong(remove-trailing-spaces(element.body))
    } else if element.func() in (ref, raw) {
      element
    } else {
      panic(repr(element.func()) + " was not handled properly")
    }
    if new != element { remove-trailing-spaces(new) } else { new }
  }

  show figure.caption.where(kind: table): it => {
    show: smallcaps
    let text = get.text(it)
    // text == none when caption == [].
    // Don't remove period for empty caption.
    // Don't remove period if it doesn't exist.
    if text == none or text.trim().len() == 0 or text.trim().last() != "." {
      it
    } else {
      show: block
      it.supplement
      if it.supplement != none { sym.space.nobreak }
      context it.counter.display(it.numbering)
      it.separator
      remove-trailing-period(remove-trailing-spaces(it.body))
    }
  }

  show figure.caption.where(kind: image): it => {
    let text = get.text(it)
    // text == none when caption == [].
    // Don't add period for empty caption (spaces pre-trimmed).
    // Don't add period if it already exists (spaces pre-trimmed).
    if text == none or text.trim().len() == 0 or text.trim().last() == "." {
      return it
    }
    show: block
    it.supplement
    if it.supplement != none { sym.space.nobreak }
    context it.counter.display(it.numbering)
    it.separator
    remove-trailing-spaces(it.body)
    "."
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

  let used-sections = state("_ijimai-used-sections", ())
  let credit-section-name = "CRediT Authorship Contribution Statement"
  let introduction-section-name = "Introduction"
  let required-sections = (
    (introduction-section-name): (),
    (credit-section-name): (),
    "Data Statement": (),
    "Declaration of Conflicts of Interest": (),
    "Acknowledgment": (
      [Acknowledgments],
      [Acknowledgement],
      [Acknowledgements],
    ),
  )
    .pairs()
    .map(((k, v)) => (k, (text(k),) + v))
    .to-dict()
  show heading: it => {
    let levels = counter(heading).get()
    let deepest = if levels != () {
      levels.last()
    } else {
      1
    }

    set text(10pt, weight: "regular")
    if it.level == 1 {
      let is-special = (
        lower(get.text(it.body))
          in required-sections.values().flatten().map(x => lower(x.text))
      )
      if is-special {
        used-sections.update(x => x + (it.body,))
        // This is a special section that must be styled like a normal section.
        if lower(it.body.text) == lower(introduction-section-name) {
          is-special = false
        }
      }
      // Special formatting for special section.
      show regex("^(?i)" + credit-section-name + "$"): credit-section-name

      set align(center)
      set text(if is-special { 10pt } else { 11pt })
      show: block.with(above: 15pt, below: 13.75pt, sticky: true)
      if it.numbering != none and not is-special {
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

  set par(
    first-line-indent: (amount: 1em, all: true),
    justify: true,
    leading: 5pt,
    spacing: 0.25cm,
  )

  let cite-string = context {
    let doi-link-text = "https://dx.doi.org/" + conf.paper.doi
    let doi-link = link(doi-link-text)
    let last-page = counter(page).final().first()
    [#conf.paper.short-author-list. #conf.paper.title. #conf.paper.journal, vol. #conf.paper.volume, no. #conf.paper.number, pp. #conf.paper.starting-page - #last-page, #conf.paper.publication-year, #doi-link]
  }

  let cite-as-section = {
    set align(left)
    set par(leading: 1mm)
    set text(size: 8.1pt)
    show: rect.with(width: 100%, fill: silver, stroke: 0.5pt + blueunir)
    [Please, cite this article as: #cite-string]
  }

  figure(
    scope: "parent",
    placement: bottom,
    kind: "_ijimai-citing-notice",
    supplement: none,
    cite-as-section,
  )

  // ANSI/NISO Z39.104-2022
  // Contributor roles
  let roles = (
    conceptualization: [Conceptualization],
    data-curation: [Data curation],
    formal-analysis: [Formal analysis],
    funding-acquisition: [Funding acquisition],
    investigation: [Investigation],
    methodology: [Methodology],
    project-administration: [Project administration],
    resources: [Resources],
    software: [Software],
    supervision: [Supervision],
    validation: [Validation],
    visualization: [Visualization],
    writing-original-draft: [Writing -- original draft],
    writing-review-editing: [Writing -- review & editing],
  )
  let author-roles = authors
    .map(author => {
      let message = "Missing \"credit\" key for " + author.name
      assert("credit" in author, message: message)
      let credit = author.credit
      let message = "\"credit\" key must be a list of roles"
      assert(type(credit) == array, message: message)
      let message = role => (
        "Invalid CRediT role: "
          + role
          + " (" + author.name + ").\nValid roles:"
          + roles.keys().map(x => "\n- " + x).join()
      )
      for role in credit {
        assert(role in roles.keys(), message: message(role))
      }
      ((author.name): credit.sorted().map(role => roles.at(role)))
    })
    .join()
  state("_ijimai-author-roles").update(author-roles)

  body

  // Make sure the required sections are:
  // - all included
  // - have correct order
  // - have no duplicates
  context {
    assert(
      used-sections.get().len() == required-sections.len(),
      message: if used-sections.get().len() < required-sections.len() {
        let not-used = (:)
        for (section, values) in required-sections {
          let exists = false
          for value in values {
            if lower(value.text) in used-sections.get().map(get.text).map(lower) {
              exists = true
              break
            }
          }
          if not exists { not-used.insert(section, values) }
        }
        let message = "Next required sections are missing:\n"
        message += not-used.pairs().map(((key, value)) => "- " + key).join("\n")
        message += "\nPlease, use document structure from the official IJIMAI Typst template."
        message
      } else if used-sections.get().len() > required-sections.len() {
        let dict = (:)
        for section in used-sections.get() {
          let key
          for (required-section, aliases) in required-sections {
            if lower(get.text(section)) in aliases.map(x => lower(x.text)) {
              key = required-section // Preserve preferred in-source casing.
              break
            }
          }
          assert(key != none)
          let value = dict.at(key, default: ())
          dict.insert(key, value + (section,))
        }
        for (key, instances) in dict {
          if instances.len() == 1 {
            _ = dict.remove(key)
          }
        }
        let message = "Found duplicate sections:\n"
        message += dict
          .pairs()
          .map(((section, instances)) => {
            "- " + section + ": " + instances.map(x => x.text).join(", ")
          })
          .join("\n")
        message += "\nPlease, remove the duplicates."
        message
      } else { "" },
    )

    for (used, required) in array.zip(
      used-sections.get(),
      required-sections.pairs(),
    ) {
      let (section, aliases) = required
      let message = (
        "Section "
          + repr(section)
          + " is included in the wrong order. The correct order:\n"
      )
      message += required-sections
        .pairs()
        .map(((key, value)) => "- " + key)
        .join("\n")
      message += "\nPlease, use document structure from the official IJIMAI Typst template."
      assert(
        lower(get.text(used)) in aliases.map(x => lower(x.text)),
        message: message,
      )
    }
  }

  // Make sure the `first-paragraph` function is used exactly once.
  context {
    let used = counter("_ijimai-first-paragraph-usage").final().first()
    assert(
      used == 1,
      message: "The \"first-paragraph\" function must be used exactly once, "
        + "but was used "
        + str(used)
        + " times.",
    )
  }

  show regex("^\[\d+\]"): set text(fill: blueunir)

  set par(leading: 4pt, spacing: 5.5pt, first-line-indent: 0pt)
  set text(size: 7.5pt)

  bibliography(bib-data, style: "ieee", title: "References")
  v(1cm)
  set par(leading: 4pt, spacing: 9.5pt)
  author-bios
}


#let first-paragraph(first-word, body) = {
  dropcap(
    height: 2,
    gap: 1pt,
    hanging-indent: 1em,
    overhang: 0pt,
    fill: blueunir,
    [#upper(text(fill: blueunir, weight: "semibold", first-word)) #body],
  )
  counter("_ijimai-first-paragraph-usage").step()
}

/// Function that automatically generates the whole body for the CRediT section.
#let format-credit-section() = context {
  let author-roles = state("_ijimai-author-roles").get()
  assert(author-roles != none, message: "The template was not applied")
  author-roles
    .pairs()
    .map(((author, roles)) => [#eval(author, mode: "markup"): #roles.join[, ]])
    .join[; ]
  "."
}
