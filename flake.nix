{
  description = "AmbiguousTechnologies NixOS robot";
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/nixos/nixpkgs/0.2411.*";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
  };
  outputs =
    { self
    , nixpkgs
    , home-manager
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      nameValuePair = name: value: { inherit name value; };
      genAttrs = names: f: builtins.listToAttrs (map (n: nameValuePair n (f n)) names);
      allSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: genAttrs allSystems (system: f {
        inherit system;
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      # NixOS configuration
      # - nix build .#nixosConfigurations.robot.config.system.build.toplevel
      nixosConfigurations = {
        robot = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs outputs;};
          modules = [./nixos/configuration.nix];
        };
      };
    };
}
