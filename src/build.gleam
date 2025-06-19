import blog/posts
import blog/render
import gleam/dict
import gleam/io
import gleam/list
import gleam/result
import lustre/ssg
import lustre/ssg/djot
import simplifile
import tom

pub fn main() {
  // build
  use _ <- result.try(build())

  // post build
  post_build()
}

pub type ConstructError {
  BuildError(ssg.BuildError)
  FileError(simplifile.FileError)
}

fn build() -> Result(_, _) {
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
    |> ssg.add_static_route(
      "/",
      render.render_md_path("./content/index.md", "assets/"),
    )
    |> ssg.add_static_route("/articles", render.render_links("articles", blogs))
    |> ssg.add_dynamic_route("/articles", blog_dict, render.render_md(
      _,
      "../assets/",
    ))
    |> ssg.build

  case build {
    Ok(_) -> io.println("Build succeeded!")
    Error(e) -> {
      echo e
      io.println("Build failed!")
    }
  }

  build |> result.map_error(BuildError)
}

fn post_build() -> Result(_, _) {
  let post_build =
    simplifile.copy_directory("./content/assets", "./pages/assets")

  case post_build {
    Ok(_) -> io.println("Post Build succeeded!")
    Error(e) -> {
      echo e
      io.println("Build failed!")
    }
  }

  post_build |> result.map_error(FileError)
}
