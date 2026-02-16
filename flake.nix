{
  description = "Ghostty Terminal Configuration with Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ghostty }:
    let
      # Supported systems
      systems = [ "aarch64-darwin" "x86_64-darwin" ];
    in
    flake-utils.lib.eachSystem systems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ ghostty.overlay ];
        };
      in
      {
        packages = {
          ghostty = ghostty.defaultPackage.${system};
        };
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            ghostty
          ];
        };
      }
    ) // {
      homeManagerConfigurations = let
        username = "satyam";
        hostname = "Satyams-MacBook-Pro";
        # Determine system from environment or default to aarch64-darwin
        system = if builtins.hasAttr "darwin" builtins.currentSystem
                 then "aarch64-darwin"
                 else "aarch64-darwin";
      in {
        "${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ ghostty.overlay ];
          };
          extraSpecialArgs = { inherit ghostty; };
          modules = [
            ./home/configuration.nix
          ];
        };
      };
    };
}
