.PHONY: update
update:
	@nix flake update

.PHONY: fmt
fmt:
	@nix run nixpkgs#nixfmt-classic .

.PHONY: lint
lint:
	@nix run nixpkgs#statix check .