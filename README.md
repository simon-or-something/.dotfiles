# .dotfiles
Where I put my configurations (that I am happy with)

I love configuring things until I have the ultimate rice that I feel effective working with.
However, through that configuring it became evident that I didn't get any work done.
The goal of this repository is to alleviate this pain from you

### Installation
#### WARNING: THIS WILL OVERWRITE YOUR EXISTING CONFIGURATIONS
```bash
cd ~
git clone https://github.com/PersonalStuffSEH/.dotfiles.git --depth=1
mv .dotfiles/{.*,*} .config
```

The plan is to hook flake.nix into it in a way that still allows me to have the existing config, perhaps like:
```nix
{
  description = "This is an example which I amalgamated online and with ChatGPT";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        config = pkgs.writeText "config.conf" ''
          # configurations...
        '';

        download1 = pkgs.fetchurl {
          url = "https://url.tld/path/file.ext";
          sha256 = "sha256-exampleSHA256exampleSHA256exampleSHA2561001=";
        };

        bundle = pkgs.runCommand "install configuration" {} ''
          mkdir -p $out/config
          cp ${config} $out/config/config.conf
          cp ${download1} $out/config/extra1
        '';
      in {
        packages.default = bundle;
      }
    );
}

```

Or I do it the proper way and make a flake.nix file with a nix config.
Although I probably won't, because then people can pick and choose manually.

That's all, get out of here :)
