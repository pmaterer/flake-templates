{
  description = "Nix flake templates.";

  outputs = { self, ... }: {
    templates = { go = { path = ./go; }; };
    nodejs = { path = ./nodejs; };
  };
}
