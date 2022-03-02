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
        yarn = pkgs.callPackage nnbp { };
      in
      {
        devShell = pkgs.mkShell {
          packages = [ pkgs.nodejs pkgs.yarn ];
        };

        defaultPackage = self.packages.${system}.foo;

        packages.foo = yarn.buildYarnPackage {
          src = ./.;
          yarnBuildMore = "yarn run foo | tee foo";
          yarnPackPhase = "true";
          installPhase = "mv foo $out";
        };

        checks.bar = yarn.buildYarnPackage {
          src = ./.;
          yarnBuildMore = "yarn run bar | tee bar";
          yarnPackPhase = "true";
          installPhase = "mv bar $out";
        };
      });
}
