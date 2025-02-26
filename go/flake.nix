{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        pname = "app";
        version = builtins.substring 0 8 sefl.lastModifiedDate;
      in {
        packages.default = pkgs.buildGoModule {
          inherit pname version;
          src = ./.;
          subPackages = [ "cmd/app" ];

          # Use `pkgs.lib.fakeHash` to get the hash.
          vendorHash = null;
        };
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            go_1_22

            gopls
            gotools
            go-tools

            golangci-lint
          ];
        };

      });
}
