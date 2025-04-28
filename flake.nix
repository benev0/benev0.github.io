{
  description = "Development environment Gleam";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs,  ...}:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default =
        pkgs.mkShell {
          buildInputs = [
            pkgs.erlang_27
            pkgs.gleam
            pkgs.rebar3
            pkgs.elixir
            pkgs.glas
            pkgs.vscode-extensions.gleam.gleam
            pkgs.inotify-tools
          ];

          shellHook = ''
            echo "Gleam shell ready"
            gleam --version
          '';
        };
    };
}
