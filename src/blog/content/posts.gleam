import gleam/list
import gleam/result
import simplifile

// add last modified
pub type PostSource {
  FileSource(path: String, data: String)
}

pub fn from_file(path: String) -> Result(PostSource, _) {
  use data <- result.map(simplifile.read(path))
  FileSource(path:, data:)
}

pub fn from_directory(path: String) -> Result(List(PostSource), _) {
  use entries <- result.map(simplifile.read_directory(path))
  use acc, ent <- list.fold(entries, [])
  case from_file(path <> ent) {
    Ok(file) -> [file, ..acc]
    _ -> acc
  }
}

pub fn crawl_directory(path: String) {
  use entries <- result.map(simplifile.get_files(path))
  use acc, ent <- list.fold(entries, [])
  case from_file(ent) {
    Ok(file) -> [file, ..acc]
    _ -> acc
  }
}
