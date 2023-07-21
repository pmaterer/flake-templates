{
  description = "Patrick Materer's Nix flake templates.";

  inputs = { nixpkgs.url = "github:NixOS/nixpkgs"; };

  outputs = { self, nixpkgs }:
    let
      allSupportedSystems =
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      forAllSupportedSystems = f:
        nixpkgs.lib.genAttrs allSupportedSystems
        (system: f { pkgs = import nixpkgs { inherit system; }; });

    in {
      devShells = forAllSupportedSystems ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            go

            # vscode dependencies
            # https://github.com/golang/vscode-go/wiki/tools
            gopls
            delve
            go-outline
            gomodifytags
            impl
            gotests
            go-tools
          ];
        };
      });

      packages = forAllSupportedSystems ({ pkgs }: {
        default = pkgs.buildGoModule {
          name = "name";
          src = ./.;
          vendorSha256 = pkgs.lib.fakeSha256;
        };
      });
    };
}
