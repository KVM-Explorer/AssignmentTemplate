#import "template.typ": *
#show: template.with(
  title: [Full Title],
  short_title: "Short Title",
  description: [
  ],
  date: datetime(year: 2024, month: 07, day: 15),
  authors: (
    (
      name: "xxx",
    ),
  ),
  affiliations: (
    (id: "1", name: "University"),
  ),
  bibliography_file: "ref.bib",
  paper_size: "a4",
  cols: 1,
  text_font: "XCharter",
  code_font: "Cascadia Mono",
  accent: black, 
)


= Basic

#lorem(50)

- Blod *Blod*
- italics _Text_
- block `block`


= code block
#lorem(100) #ref(<code_block>)

#figure(
```cpp
std::cout << "Hello World" << std::endl;
```,
caption: "code_block"
)<code_block>

= table

#lorem(10) #ref(<table_demo>)

#figure(
  table(
    columns: 3,
    table.header("T1","T2","T3"),
    "1","2","3"

  ),
  caption: "table demo"
)<table_demo>

#lorem(10) #ref(<Kolb2005smallpt>)



