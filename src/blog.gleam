import filespy
import gleam/erlang/process
import gleam/http/request.{Request}
import gleam/io
import gleam/string
import mist
import shellout
import wisp
import wisp/wisp_mist

const rebuild_delay = 500

const relative_folder_location = "/pages"

pub fn main() -> Nil {
  let subj = process.new_subject()
  process.send(subj, Nil)

  // subscribe to file changes
  let _res =
    filespy.new()
    |> filespy.add_dir("./src")
    |> filespy.add_dir("./content")
    |> filespy.set_handler(fn(_path, _event) { process.send(subj, Nil) })
    |> filespy.start()

  // start web server
  let assert Ok(dir) = shellout.command("pwd", [], ".", [])
  let dir = string.drop_end(dir, 1) <> relative_folder_location
  let assert Ok(_) =
    wisp_mist.handler(handle_request(_, dir), wisp.random_string(10))
    |> mist.new
    |> mist.port(4200)
    |> mist.start_http

  // rebuild on notify
  use <- run_forever(subj)
  let build =
    shellout.command(
      run: "gleam",
      with: ["run", "-m", "build"],
      in: ".",
      opt: [],
    )
  let message = case build {
    Ok(message) -> message
    Error(#(_, message)) -> message
  }
  io.print(message)
  Nil
}

pub fn handle_request(req: wisp.Request, dir: String) -> wisp.Response {
  use <- wisp.log_request(req)
  use <- wisp.serve_static(req, under: "", from: dir)

  let p = req.path <> ".html"
  let r = Request(..req, path: p)
  use <- wisp.serve_static(r, under: "", from: dir)

  let p = req.path <> "/index.html"
  let r = Request(..req, path: p)
  use <- wisp.serve_static(r, under: "", from: dir)

  wisp.not_found()
}

fn run_forever(subject, function) {
  process.receive_forever(subject)
  process.sleep(rebuild_delay)
  process.flush_messages()
  function()
  run_forever(subject, function)
}
