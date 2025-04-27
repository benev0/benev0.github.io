import gleeunit
import gleeunit/should

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  1
  |> should.equal(1)
}
// todo test all created functions under both fail and success conditions
