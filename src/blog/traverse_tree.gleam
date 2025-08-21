import gleam/dict
import gleam/list
import gleam/option
import lustre/ssg
import simplifile

pub fn add_tree(
  config: ssg.Config(a, b, c),
  path: String,
  base_url_path: String,
  file_action: fn(ssg.Config(a, b, c), String, String) ->
    #(ssg.Config(a, b, c), option.Option(d)),
  dir_action: fn(ssg.Config(a, b, c), dict.Dict(String, d), String, String) ->
    #(ssg.Config(a, b, c), option.Option(d)),
) -> #(ssg.Config(a, b, c), option.Option(d)) {
  case simplifile.is_file(path), simplifile.is_directory(path) {
    // file
    Ok(True), _ -> file_action(config, path, base_url_path)
    // directory
    _, Ok(True) -> {
      case simplifile.read_directory(path) {
        Ok(files) -> {
          let sub_tree =
            files
            |> list.fold(#(config, dict.new()), fn(acc, p) {
              let config_data =
                add_tree(
                  acc.0,
                  path <> "/" <> p,
                  base_url_path <> "/" <> p,
                  file_action,
                  dir_action,
                )

              let new_dict = case config_data.1 {
                option.Some(data) -> dict.insert(acc.1, p, data)
                option.None -> acc.1
              }

              #(config_data.0, new_dict)
            })

          dir_action(sub_tree.0, sub_tree.1, path, base_url_path)
        }
        Error(_) -> #(config, option.None)
      }
    }
    // what?
    _, _ -> #(config, option.None)
  }
}
