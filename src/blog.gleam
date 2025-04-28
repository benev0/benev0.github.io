import filespy
import gleam/erlang/process
import gleam/io
import gleam/string
import mist
import shellout
import wisp.{type Request, type Response}
import wisp/wisp_mist

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

  // start web server (todo)
  let assert Ok(dir) = shellout.command("pwd", [], ".", [])
  let dir = string.drop_end(dir, 1) <> "/pages"
  let assert Ok(_) =
    wisp_mist.handler(handle_request(_, dir), "100")
    |> mist.new
    |> mist.port(4200)
    |> mist.start_http

  // rebuild on notify
  use <- run_forever(subj)
  let _ =
    shellout.command(
      run: "gleam",
      with: ["run", "-m", "build"],
      in: ".",
      opt: [],
    )
  io.print("site built\n")
  Nil
}

pub fn handle_request(request: Request, dir: String) -> Response {
  use <- wisp.log_request(request)
  use <- wisp.serve_static(request, under: "", from: dir)
  wisp.ok()
}

fn run_forever(subject, function) {
  process.receive_forever(subject)
  process.sleep(500)
  process.flush_messages()
  function()
  run_forever(subject, function)
}
