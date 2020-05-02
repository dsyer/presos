with import <nixpkgs> { };
pkgs.mkShell {
  name = "test";
  buildInputs = [ ruby.devEnv rubyPackages.jekyll rubyPackages.redcarpet rubyPackages.nokogiri ];
}
