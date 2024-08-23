{
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs"; };

  outputs = { self, nixpkgs }:
    let
      version = builtins.substring 0 8 self.lastModifiedDate;

      supportedSystems =
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      forAllSupportedSystems = nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor =
        forAllSupportedSystems (system: import nixpkgs { inherit system; });

    in {
      devShells = forAllSupportedSystems (system:
        let
          pkgs = nixpkgsFor.${system};
          buildDeps = with pkgs; [ go_1_22 ];
          devDeps = with pkgs;
            buildDeps ++ [
              golangci-lint

              # vscode dependencies
              # https://github.com/golang/vscode-go/wiki/tools
              # https://mgdm.net/weblog/vscode-nix-go-tools/
              gopls
              go-tools
              gotools
              go-outline
              gocode-gomod
              gopkgs
              godef
              golint
              delve
              gomodifytags
              impl
              gotests
            ];
        in { default = pkgs.mkShell { buildInputs = devDeps; }; });

      packages = forAllSupportedSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          app = pkgs.buildGoModule {
            pname = "app";
            inherit version;
            src = ./.;
            subPackages = [ "cmd/app" ];

            # Use `pkgs.lib.fakeHash` to get the hash.
            vendorHash = null;
          };
        });

      defaultPackage =
        forAllSupportedSystems (system: self.packages.${system}.app);
    };
}
