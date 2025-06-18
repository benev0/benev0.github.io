import blog/posts
import gleam/dict
import gleam/list
import gleam/order
import gleam/result
import lustre/attribute
import lustre/element/html.{a, body, div, head, html, link, p, script, text}
import lustre/ssg/djot
import lustre/vdom/vnode
import tom

const catppuccin_styles_url = "https://cdn.jsdelivr.net/npm/@catppuccin/palette/css/catppuccin.css"

const catppuccin_styles_checksum = "sha512-rostBe3y8SV6rNeApitsio4hw7OxN4yIdzrVdtbad5zUkoYk3+EicAFjt2zHsHC0LvxTuTFdRFWTbwokYPbDMg=="

const mathjax_url = "https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/tex-mml-chtml.min.js"

const mathjax_checksum = "sha512-NeVoktJi40j3sJ3ynBJtnDopGJhgZlWPH98HrsbZKIYPF58A//qjH0thBNZ0qHtEAuAYwcdrLRz7dlagL88xLg=="

fn include_styles_and_scripts(
  page: List(vnode.Element(a)),
  asset_path: String,
  include_math: Bool,
) -> vnode.Element(_) {
  let head_content = [
    link([
      attribute.rel("stylesheet"),
      attribute.href(catppuccin_styles_url),
      attribute.attribute("integrity", catppuccin_styles_checksum),
      attribute.crossorigin("anonymous"),
    ]),
    link([
      attribute.rel("stylesheet"),
      attribute.href(asset_path <> "styles.css"),
    ]),
    script([attribute.src(asset_path <> "startup.js")], ""),
  ]

  let head_content = case include_math {
    True -> [
      script(
        [
          attribute.src(mathjax_url),
          attribute.type_("text/javascript"),
          attribute.attribute("integrity", mathjax_checksum),
          attribute.crossorigin("anonymous"),
        ],
        "",
      ),
      ..head_content
    ]
    False -> head_content
  }

  html([], [
    head([], head_content),
    body([attribute.class("grid-container")], [
      div([attribute.class("grid-cell")], page),
    ]),
  ])
}

pub fn render_md_path(path: String, asset_path: String) -> vnode.Element(_) {
  let assert Ok(posts.FileSource(_, md)) = posts.from_file(path)

  djot.render(md, djot.default_renderer())
  |> include_styles_and_scripts(asset_path, False)
}

pub fn render_md(md: String, asset_path: String) -> vnode.Element(_) {
  let math = {
    use matter <- result.try(djot.metadata(md))
    let toml_result = dict.get(matter, "math")
    case toml_result {
      Ok(tom.Bool(True)) -> Ok(True)
      _ -> Ok(False)
    }
  }

  let math = case math {
    Error(_) -> False
    Ok(math) -> math
  }

  djot.render(md, djot.default_renderer())
  |> include_styles_and_scripts(asset_path, math)
}

pub fn render_matter(
  base: String,
  matter: #(String, String, tom.DateTime),
) -> vnode.Element(_) {
  div([attribute.class("blog-link")], [
    p([], [text(matter.0)]),
    p([], [a([attribute.href(base <> "/" <> matter.1)], [text(matter.1)])]),
  ])
}

fn cmp_datetime(d1: tom.DateTime, d2: tom.DateTime) -> order.Order {
  let year = case d1.date.year - d2.date.year {
    0 -> order.Eq
    diff if diff < 0 -> order.Gt
    _ -> order.Lt
  }

  use <- order.lazy_break_tie(year)

  let month = case d1.date.month - d2.date.month {
    0 -> order.Eq
    diff if diff < 0 -> order.Gt
    _ -> order.Lt
  }

  use <- order.lazy_break_tie(month)

  let day = case d1.date.day - d2.date.day {
    0 -> order.Eq
    diff if diff < 0 -> order.Gt
    _ -> order.Lt
  }

  use <- order.lazy_break_tie(day)

  let hour = case d1.time.hour - d2.time.hour {
    0 -> order.Eq
    diff if diff < 0 -> order.Gt
    _ -> order.Lt
  }

  use <- order.lazy_break_tie(hour)

  let minute = case d1.time.minute - d2.time.minute {
    0 -> order.Eq
    diff if diff < 0 -> order.Gt
    _ -> order.Lt
  }

  use <- order.lazy_break_tie(minute)

  let second = case d1.time.second - d2.time.second {
    0 -> order.Eq
    diff if diff < 0 -> order.Gt
    _ -> order.Lt
  }

  use <- order.lazy_break_tie(second)

  let _millisecond = case d1.time.millisecond - d2.time.millisecond {
    0 -> order.Eq
    diff if diff < 0 -> order.Gt
    _ -> order.Lt
  }
}

pub fn render_links(base: String, sources: List(posts.PostSource)) {
  // matters should be fallible (remove asserts)
  let matters = {
    use post <- list.map(sources)
    use matter <- result.try(djot.metadata(post.data))
    let assert Ok(tom.String(title)) = dict.get(matter, "title")
    let assert Ok(tom.String(url)) = dict.get(matter, "url")
    let assert Ok(tom.DateTime(datetime)) = dict.get(matter, "published")
    Ok(#(title, url, datetime))
  }

  let assert Ok(matters) = result.all(matters)

  let rendered_matters =
    matters
    |> list.sort(fn(t1, t2) { cmp_datetime(t1.2, t2.2) })
    |> list.map(render_matter(base, _))

  [html.h1([], [text("Articles")]), ..rendered_matters]
  |> include_styles_and_scripts("assets/", False)
}
