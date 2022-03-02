{
  description = "A flake with yarn and a check";

  inputs = {
    utils.url = "github:numtide/flake-utils";
    nnbp.url = "github:serokell/nix-npm-buildpackage";
  };

  outputs = { self, utils, nnbp, nixpkgs }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        bp = pkgs.callPackage nnbp { };
      in
      {
        devShell = pkgs.mkShell {
          packages = [ pkgs.nodejs-16_x ];
        };

        defaultPackage = self.packages.${system}.foo;

        packages.foo = bp.buildNpmPackage {
          src = ./.;
          npmBuild = "npm run foo | tee foo";
          installPhase = "mv foo $out";
        };

        checks.bar = bp.buildNpmPackage {
          src = ./.;
          npmBuild = "npm run bar | tee bar";
          installPhase = "mv bar $out";
        };
      });
}
