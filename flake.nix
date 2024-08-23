{
  description = "Nix flake templates.";

  outputs = { self, ... }: { templates = { go = { path = ./go; }; }; };
}
