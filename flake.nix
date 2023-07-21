{
    description = "Patrick Materer's Nix flake templates.";

    outputs = { self, ... }: {
        templates = {
            golang = {
                path = ./golang;
                description = "Golang Nix flake template.";
            };
        };
    };
}