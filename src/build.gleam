import gleam/io
import lustre/element.{text}
import lustre/element/html.{p}

import lustre/ssg

pub fn main() {
  let build =
    ssg.new("./priv")
    |> ssg.add_static_route("/", view())
    |> ssg.build

  case build {
    Ok(_) -> io.println("Build succeeded!")
    Error(e) -> {
      echo e
      io.println("Build failed!")
    }
  }
}

fn view() {
  p([], [text("hello")])
}
