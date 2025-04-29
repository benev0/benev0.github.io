import blog/posts
import gleam/dict
import gleam/io
import gleam/list
import gleam/result
import lustre/attribute
import lustre/element/html.{a, div, p, text}
import lustre/ssg
import lustre/ssg/djot
import tom

pub fn main() {
  let assert Ok(blogs) = posts.crawl_directory("./content/blogs")

  let blog_dict =
    list.map(blogs, fn(file) {
      let assert Ok(tom.String(url)) =
        result.try(
          djot.metadata(file.data) |> result.replace_error(Nil),
          fn(matter) { dict.get(matter, "url") },
        )
      #(url, file.data)
    })
    |> dict.from_list

  let build =
    ssg.new("./pages")
    |> ssg.add_static_route("/", render_md_path("./content/index.md"))
    |> ssg.add_static_route("/blogs", render_links("blogs", blogs))
    |> ssg.add_dynamic_route("/blogs", blog_dict, render_md)
    |> ssg.add_static_dir("./content/")
    |> ssg.build

  case build {
    Ok(_) -> io.println("Build succeeded!")
    Error(e) -> {
      echo e
      io.println("Build failed!")
    }
  }
}

fn render_md_path(path: String) {
  let assert Ok(posts.FileSource(_, md)) = posts.from_file(path)

  djot.render(md, djot.default_renderer())
  |> div([], _)
}

fn render_md(md: String) {
  djot.render(md, djot.default_renderer())
  |> div([], _)
}

fn render_matter(base: String, matter: #(String, String)) {
  div([], [
    p([], [text(matter.0)]),
    p([], [a([attribute.href(base <> "/" <> matter.1)], [text(matter.1)])]),
  ])
}

fn render_links(base: String, sources: List(posts.PostSource)) {
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
