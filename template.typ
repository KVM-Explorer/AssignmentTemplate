// Imports =============================================================

#import "@preview/whalogen:0.1.0": ce
#import "@preview/codelst:1.0.0": sourcecode, codelst
#import "@preview/showybox:2.0.1": showybox
#import "@preview/ctheorems:1.0.0": *

// Template ============================================================

#let template(
  // The title of the lecture notes
  title: "Lecture Notes Title",

  // The short_title is shown in the running header
  short_title: none, // string

  // description: [A template for lecture notes]
  description: none,

  // The date of the lecture notes; is optional. Example
  // datetime(year: 2020, month: 02, day: 02)
  date: none,

  // An array of authors
  authors: (
      // name: ""
  ),

  // This is the affiliations list
  affiliations: (
    // (id: "1", name: "Organization 1"),
    // (id: "2", name: "Organization 2"),
  ),


  // The path to a bibliography file if you want to cite some external works.
  bibliography_file: none,
  // Citation style
  bibstyle: "apa",

  // The article's paper size. Also affects the margins.
  paper_size: "a4",

  // The number of columns to be used in the page
  cols: 1,

  // The text and code font. Must be a valid font name.
  text_font: "Linux Libertine",
  code_font: "DejaVu Sans Mono",

  // The color of the lecture notes' accent color. Must be a valid HEX color.
  //accent: blue,
  accent: "#DC143C",

  // The lecture notes' content.
  body

// ============================================================


) = {

  // Necessary for ctheorems package
  show: thmrules

  // Logos
  let orcidSvg = ```<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 24 24"> <path fill="#AECD54" d="M21.8,12c0,5.4-4.4,9.8-9.8,9.8S2.2,17.4,2.2,12S6.6,2.2,12,2.2S21.8,6.6,21.8,12z M8.2,5.8c-0.4,0-0.8,0.3-0.8,0.8s0.3,0.8,0.8,0.8S9,7,9,6.6S8.7,5.8,8.2,5.8z M10.5,15.4h1.2v-6c0,0-0.5,0,1.8,0s3.3,1.4,3.3,3s-1.5,3-3.3,3s-1.9,0-1.9,0H10.5v1.1H9V8.3H7.7v8.2h2.9c0,0-0.3,0,3,0s4.5-2.2,4.5-4.1s-1.2-4.1-4.3-4.1s-3.2,0-3.2,0L10.5,15.4z"/></svg>```.text

  let accent_color = {
    if type(accent) == "string" {
      rgb(accent)
    } else if type(accent) == "color" {
      accent
    } else {
      rgb("#FFFFFF")  // if we forgor to mention color in main.typ
    }
  }

  // Construct string title from title content
  let str_title = ""

  if type(title) == content and title.has("children") {
    for element in title.children {
      if element.has("text") {
        str_title = str_title + element.text + " " 
      }
    }
  } else if type(title) == "string" {
    str_title = title
  }
    
  str_title = str_title.trim(" ")

  // Set document metadatra
  set document(title: str_title, author: authors.map(author => author.name))

  // 配置首行缩进实现
  
  set par(first-line-indent: 2em)

  let fake-par = style(styles => {
    let b = par[#box()]
    let t = measure(b + b, styles);

    b
    v(-t.height)
  })

  show heading: it => {
    it
    fake-par
}

  // Set the text and code font
  set text(font: text_font, size: 10pt)
  // show raw: it => block(
  //   fill: rgb("#d7d7d7"),
  //   inset: 8pt,
  //   radius: 5pt,
  //   text(font: code_font,fill: rgb("#000000"), it)
  // )
  show raw.where(block: true): it => {
  block[
    #h(1fr)
    #box(
      width: 100%-0.5em,
      radius: 0.3em,
      stroke: luma(50%),
      inset: 1em,
      fill: luma(98%)
    )[
      #show raw.line: l => {
        box(
          width:measure([#it.lines.last().count]).width,
           align(right, 
           text(font: code_font,fill: luma(50%))[#l.number]))
        h(0.5em)
        l.body
      }
      #it
    ]
  ]
}
  

  // Make links blue and underlined. Disable for author list.
  show link: it => {
    let author_names = ()
    for author in authors {
      author_names.push(author.name)
    }

    if it.body.has("text") and it.body.text in author_names {
      it
    } else {
      underline(stroke: (dash: "densely-dotted"), text(fill: blue, it)) 
    }
  }
  

  // Configure the page.
  set page(
    paper: paper_size,
    columns: cols,
    numbering: "1 / 1",
    number-align: center,
    // The margins depend on the paper size.
    margin: if cols > 1 {
      (x: 36pt, y: 72pt)
    } else {
      auto
    },
    

    // Dat header line thingy
    header: locate(loc => {
      let elems = query(
        selector(heading.where(level: 1)).before(loc),
        loc,
      )
      let head_title = text(fill: accent_color)[
        #if short_title != none { short_title } else { str_title }
      ]
      if elems == () {
        align(right, "")
      } else {
        let current_heading = elems.last()
        // if current_heading.numbering != none {
        //   emph(counter(heading.where(level: 1)).display("1. ") +
        //   current_heading.body) + h(1fr) + head_title
        // } else {
        h(1fr) + head_title
        
        v(-7pt)
        line(length: 100%, stroke: (thickness: 1pt, paint: accent_color, dash: "solid"))
      }
    })
  )

  // Configure equation numbering and spacing.
  set math.equation(numbering: "[1.1]")
  show math.equation: eq => {
    set block(spacing: 0.65em)
    eq
  }

  // Configure lists.
  set enum(indent: 0pt, body-indent: 6pt)
  set list(indent: 0pt, body-indent: 6pt)

  // TODO: Configure headings
  set heading(numbering: "1.1.1.1.1.")
  show heading: it => {
    it
    v(12pt, weak: true)
  }

  // Configure code blocks.
  show raw.where(
    block: false,
  ): it => box(fill: luma(240), inset: (x: 2pt), outset: (y: 3pt), radius: 1pt)[#it]
  // show raw.where(
  //   block: true,
  // ): it => block(
  //     breakable: false,
  //     width: 100%,
  //     fill: luma(240),
  //     radius: 4pt,
  //     inset: (x: 1.5em, y: 1em)
  //   )[#it]
  show: codelst(reversed: true)

  // Configure figures
  // set figure(placement: auto)
  show figure.where(
    kind: table
  ): set figure.caption(position: top)
  show figure.where(
    kind: raw
  ): it => {
    set block(width: 100%)
    it
  }
  
  // Display the paper's title and description.
  align(center, [
    #set text(18pt, weight: "bold")
    #underline[#title]
    ])
  
  // if description != none {
  //   align(center, box(width: 90%)[
  //     #set text(size: 12pt, style: "italic")
  //     #description
  //   ])
  // }

  

  // Authors and affiliations
  align(center)[
    #if authors.len() > 0 {
      box(inset: (y: 0pt), {
        authors.map(author => {
          text(11pt, weight: "semibold")[
            #if "link" in author {
              [#link(author.link)[#author.name]]
            } else { author.name }]
        }).join(", ", last: {
          if authors.len() > 2 {
            ", and"
          } else {
            " and"
          }
        })
      })
    }
    #v(12pt, weak: true)
    #if affiliations.len() > 0 {
      box(inset: (bottom: 0pt), {
        affiliations.map(affiliation => {
          text(8pt)[
            //#super(affiliation.id)
            #h(1pt)#affiliation.name
          ]
        }).join(", ")
      })
    }
  ]



  
  //v(6pt, weak: true)

  // Display the lecture notes' last updated date.
  if date != none {
  align(center, table(
    columns: (auto, auto),
    stroke: none,
    gutter: 0pt,
    align: (right, left),
    [#text(size: 11pt, "Submitted on:")],
    [#text(
      size: 11pt,
      fill: accent_color,
      weight: "semibold",
      date.display("[month repr:long] [day padding:zero], [year repr:full]")
    )
    ],
  ))
  } else {
    align(center,
    text(size: 11pt)[Last updated:#h(5pt)] + text(
      size: 11pt,
      fill: accent_color,
      weight: "semibold",
      datetime.today().display(
        "[month repr:long] [day padding:zero], [year repr:full]"
      )
    )
    )
  }

  
  // Display Table of contents. (I don't need)
  // pagebreak()
  // show outline.entry: it => {
  //   text(fill: accent_color)[#it]
  // }
  // outline(indent: auto)

  // Space after titles and dates and shids
  v(40pt, weak: true)

  // Set paragraph to be justified and set linebreaks
  set par(justify: true, linebreaks: "optimized", leading: 0.8em)

  // Display the lecture notes' content.
  body

  v(24pt, weak: true)

  // Display bibliography.
  if bibliography_file != none {
    show bibliography: set text(8pt)
    bibliography(bibliography_file, title: text(10pt)[References], style: bibstyle)
  }
}




// Functions ===========================================================

// Configure blockquotes.
#let blockquote(cite: none, body) = [
  #set text(size: 0.97em)
  #pad(left: 1.5em)[
    #block(
    breakable: true,
    width: 100%,
    fill: gray.lighten(90%),
    radius: (left: 0pt, right: 5pt),
    stroke: (left: 5pt + gray, rest: 1pt + silver),
    inset: 1em
    )[#body]
  ]
]

// It's like blockquote but invisible block
#let indent-block(cite: none, body) = [
  #set text(size: 1em)
  #par()[
    #block(
    breakable: true,
    width: 100%,
    inset: (left:2.6em),
    )[#body]
  ]
]


// Configure horizontal ruler
#let horizontalrule = [#v(0.5em) #line(start: (20%,0%), end: (80%,0%)) #v(0.5em)]

// Configure alternative horizontal ruler
#let sectionline = align(center)[#v(0.5em) * \* #sym.space.quad \* #sym.space.quad \* * #v(0.5em)]


// Attempt to add \boxed{} command from LaTeX
#let dboxed(con) = box(stroke: 0.5pt + black, outset: (x: 2pt), inset: (y: 8pt), baseline: 11pt, $display(#con)$)
#let iboxed(con) = box(stroke: 0.5pt + black, outset: (x: 2pt), inset: (y: 3pt), baseline: 2pt, $#con$)






// ==== Nice boxes using showybox and ctheorems packages ====
//
// | Environment | Accent Color         |
// |-------------|----------------------|
// | Definition  | olive                |
// | Lemma       | eastern              |
// | Note        | blue                 |
// | Theorem     | navy                 |  
// | Proposition | maroon               |

#let boxnumbering = "1.1.1.1.1.1"
#let boxcounting = "heading"

#let definition = thmenv(
  "definition",
  "Definition",
  boxcounting,
  none,
  (name, number, body, ..args) => {
    showybox(
      title: [#name #h(1fr) Definition #number],
      frame: (
        border-color: olive,
        title-color:  olive.lighten(30%),
        body-color:   olive.lighten(95%),
        footer-color: olive.lighten(80%),
      ),
      ..args.named(),
      body
    )
  }
).with(numbering: boxnumbering)

#let lemma = thmenv(
  "lemma",
  "Lemma",
  boxcounting,
  none,
  (name, number, body, ..args) => {
    showybox(
      title: [#name #h(1fr) Lemma #number],
      frame: (
        border-color: eastern,
        title-color:  eastern.lighten(30%),
        body-color:   eastern.lighten(95%),
        footer-color: eastern.lighten(80%),
      ),
      ..args.named(),
      body
    )
  }
).with(numbering: boxnumbering)

#let note = thmenv(
  "note",
  "Note",
  boxcounting,
  none,
  (name, number, body, ..args) => {
    showybox(
      title: [#name #h(1fr) Note #number],
      frame: (
        border-color: blue.lighten(30%),
        title-color:  blue.lighten(50%),
        body-color:   blue.lighten(95%),
        footer-color: blue.lighten(80%),
      ),
      ..args.named(),
      body
    )
  }
).with(numbering: boxnumbering)

#let theorem = thmenv(
  "theorem",
  "Theorem",
  boxcounting,
  none,
  (name, number, body, ..args) => {
    showybox(
      title: [#name #h(1fr) Theorem #number],
      frame: (
        border-color: navy,
        title-color:  navy.lighten(30%),
        body-color:   navy.lighten(95%),
        footer-color: navy.lighten(80%),
      ),
      ..args.named(),
      body
    )
  }
).with(numbering: boxnumbering)

#let proposition = thmenv(
  "proposition",
  "Proposition",
  boxcounting,
  none,
  (name, number, body, ..args) => {
    showybox(
      title: [#name #h(1fr) Proposition #number],
      frame: (
        border-color: maroon,
        title-color:  maroon.lighten(30%),
        body-color:   maroon.lighten(95%),
        footer-color: maroon.lighten(80%),
      ),
      ..args.named(),
      body
    )
  }
).with(numbering: boxnumbering)