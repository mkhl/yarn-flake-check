{
  description = "A flake with yarn and a check";

  inputs = {
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, utils, nixpkgs }:
    utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShell = pkgs.mkShell {
          packages = [ pkgs.nodejs pkgs.yarn ];
        };

        defaultPackage = self.packages.${system}.foo;

        packages.foo = pkgs.mkYarnPackage {
          src = ./.;
          configurePhase = "ln -s $node_modules node_modules";
          buildPhase = "yarn run foo | tee foo";
          installPhase = "mv foo $out";
          distPhase = "true";
        };

        checks.bar = pkgs.mkYarnPackage {
          src = ./.;
          configurePhase = "ln -s $node_modules node_modules";
          buildPhase = "yarn run bar | tee bar";
          installPhase = "mv bar $out";
          distPhase = "true";
        };
      });
}
