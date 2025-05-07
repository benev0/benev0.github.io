import blog/posts
import gleam/dict
import gleam/list
import gleam/result
import lustre/attribute.{attribute}
import lustre/element/html.{a, body, div, head, html, link, p, script, text}
import lustre/ssg/djot
import lustre/vdom/vnode
import tom

fn include_styles_and_scripts(page: List(vnode.Element(a))) -> vnode.Element(_) {
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
      script([attribute.src("assets/startup.js")], ""),
    ]),
    body([attribute.class("gridContainerDesktop")], [
      div([attribute.class("gridCell")], page),
    ]),
  ])
}

pub fn render_md_path(path: String) -> vnode.Element(_) {
  let assert Ok(posts.FileSource(_, md)) = posts.from_file(path)

  djot.render(md, djot.default_renderer())
  |> include_styles_and_scripts
}

pub fn render_md(md: String) -> vnode.Element(_) {
  djot.render(md, djot.default_renderer())
  |> include_styles_and_scripts
}

pub fn render_matter(
  base: String,
  matter: #(String, String),
) -> vnode.Element(_) {
  div([attribute.class("blog-link")], [
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

  let rendered_matters =
    matters
    |> list.map(render_matter(base, _))

  [html.h1([], [text("Blogs")]), ..rendered_matters]
  |> include_styles_and_scripts
}
