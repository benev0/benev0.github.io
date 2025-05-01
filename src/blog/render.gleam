import blog/posts
import gleam/dict
import gleam/list
import gleam/regexp
import gleam/result
import gleam/string
import jot
import lustre/attribute
import lustre/element
import lustre/element/html.{a, div, p, text}
import lustre/ssg/djot
import tom

// render code stolen from lustre ssg; modified to include base url

fn linkify(text: String) -> String {
  let assert Ok(re) = regexp.from_string(" +")

  text
  |> regexp.split(re, _)
  |> string.join("-")
}

fn check_internal(url: String) -> Bool {
  let assert Ok(re) = regexp.from_string("^(?!([a-z][a-z0-9+.-]*:)?//).+")

  regexp.check(re, url)
}

fn replace_internal_raw(content: String, base_url: String) -> String {
  let assert Ok(source) =
    regexp.from_string("\\s(src|url|href)\\s*=\\s*\"\\/[\\w-\\/]+\"")
  let assert Ok(internal) = regexp.from_string("\"\\/[\\w-\\/]+\"")
  use match <- regexp.match_map(source, content)
  use match <- regexp.match_map(internal, match.content)

  "\"" <> base_url <> { match.content |> string.drop_start(1) }
}

fn renderer(base_url: String) {
  let rend = djot.default_renderer()
  djot.Renderer(
    ..rend,
    link: fn(destination, references, content) {
      case destination {
        jot.Reference(ref) ->
          case dict.get(references, ref) {
            Ok(url) -> html.a([attribute.href(url)], content)
            Error(_) ->
              html.a(
                [
                  attribute.href("#" <> linkify(ref)),
                  attribute.id(linkify("back-to-" <> ref)),
                ],
                content,
              )
          }
        jot.Url(url) ->
          html.a(
            [
              attribute.attribute(
                "href",
                case check_internal(url) {
                  True -> base_url
                  False -> ""
                }
                  <> url,
              ),
            ],
            content,
          )
      }
    },
    raw_html: fn(content) {
      element.unsafe_raw_html(
        "",
        "div",
        [],
        replace_internal_raw(content, base_url),
      )
    },
  )
}

pub fn render_md_path(path: String, baseurl: String) {
  let assert Ok(posts.FileSource(_, md)) = posts.from_file(path)
  djot.render(md, renderer(baseurl))
  |> div([], _)
}

pub fn render_md(md: String, site_path: String) {
  djot.render(md, renderer(site_path))
  |> div([], _)
}

pub fn render_matter(base: String, matter: #(String, String)) {
  div([], [
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

  div([], list.map(matters, render_matter(base, _)))
}
