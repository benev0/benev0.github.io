import blog/posts
import gleam/dict
import gleam/list
import gleam/result
import lustre/attribute.{attribute}
import lustre/element/html.{a, body, div, head, html, link, p, text}
import lustre/ssg/djot
import tom

pub fn render_md_path(path: String) {
  let assert Ok(posts.FileSource(_, md)) = posts.from_file(path)

  djot.render(md, djot.default_renderer())
  |> div([], _)
}

pub fn render_md(md: String) {
  djot.render(md, djot.default_renderer())
  |> div([], _)
}

pub fn render_matter(base: String, matter: #(String, String)) {
  div([attribute.class("blog")], [
    p([], [text(matter.0)]),
    p([], [a([attribute.href(base <> "/" <> matter.1)], [text(matter.1)])]),
  ])
}

pub fn render_links(base: String, sources: List(posts.PostSource)) {
  let matters = {
    use post <- list.map(sources)
    use matter <- result.try(djot.metadata(post.data))
    let assert Ok(tom.String(title)) = dict.get(matter, "title")
    let assert Ok(tom.String(url)) = dict.get(matter, "url")
    Ok(#(title, url))
  }

  let assert Ok(matters) = result.all(matters)

  // <link rel="stylesheet" href="mystyle.css">
  html([], [
    head([], [
      link([
        attribute("rel", "stylesheet"),
        attribute(
          "href",
          "https://cdn.jsdelivr.net/npm/@catppuccin/palette/css/catppuccin.css",
        ),
      ]),
      link([
        attribute("rel", "stylesheet"),
        attribute("href", "assets/styles.css"),
      ]),
    ]),
    body([], [div([], list.map(matters, render_matter(base, _)))]),
  ])
}
