# Nix Language Guide

Nix is the language behind all your `.nix` files. It's purely functional —
no loops, no mutation. Everything is an expression that evaluates to a value.

---

## 1. Strings

```nix
# Basic string
"nixos"

# String interpolation — embed a variable with ${ }
let name = "rahul";
in "hello ${name}"
# → "hello rahul"

# Real example from your home.nix:
homeDirectory = "/home/rahul";
desktop = "${config.home.homeDirectory}/Desktop";
# → "/home/rahul/Desktop"

# Real example from your flake.nix — hostName interpolated into a path:
./hosts/${hostName}
# → ./hosts/laptop  or  ./hosts/laptop-amd

# Multiline string — indentation is stripped automatically
''
  sudo nixos-rebuild switch
  --flake ~/nixos#nixos
''
```

---

## 2. Numbers & Booleans

```nix
# Numbers
42
3.14

# Booleans
true
false

# Real examples from your config:
boot.loader.efi.canTouchEfiVariables = true;
hardware.graphics.enable32Bit = true;
services.pipewire.pulse.enable = true;
home-manager.useGlobalPkgs = true;
home-manager.backupFileExtension = "hm-back";
```

---

## 3. Lists

Items separated by spaces, not commas:

```nix
# Basic list
[ "git" "btop" "kitty" ]

# Real example from your users.nix:
extraGroups = [ "wheel" "power" "video" "audio" "networkmanager" ];

# Real example from your configuration.nix:
nix.settings.experimental-features = [ "nix-command" "flakes" ];

# Real example from your desktop.nix:
xdg.portal.extraPortals = with pkgs; [
  xdg-desktop-portal-gtk
];

# List of attribute sets — common in NixOS configs:
spawn-at-startup = [
  { command = [ "noctalia-shell" ]; }
];
```

---

## 4. Attribute Sets

The most important type — like a dictionary. Key-value pairs wrapped in `{ }`:

```nix
# Basic attribute set
{
  name = "rahul";
  city = "India";
}

# Nested — real example from your audio.nix:
services.pipewire = {
  enable = true;
  pulse.enable = true;
  wireplumber.enable = true;
};

# Shorthand dot notation (same as above):
services.pipewire.enable = true;
services.pipewire.pulse.enable = true;
services.pipewire.wireplumber.enable = true;

# Real example from your bluetooth.nix:
hardware.bluetooth.settings = {
  General = {
    Enable = "Source,Sink,Media,Socket";
  };
};
```

---

## 5. Let Expressions

Define local variables, use them after `in`:

```nix
let
  name = "rahul";
  home = "/home/${name}";
in
  "config lives at ${home}/nixos"
# → "config lives at /home/rahul/nixos"
```

Real example from your `configs.nix`:

```nix
let
  home = config.home.homeDirectory;        # "/home/rahul"
  link = path: config.lib.file.mkOutOfStoreSymlink "${home}/Config/${path}";
in
{
  xdg.configFile = {
    "kitty".source = link "kitty/.config/kitty";
    "niri".source  = link "niri/.config/niri";
  };
}
```

Real example from your `flake.nix` — extracting shared config into variables:

```nix
let
  overlay = ({ pkgs, ... }: { nixpkgs.overlays = [ ... ]; });
  sharedHM = { home-manager.useGlobalPkgs = true; ... };

  mkHost = { hostName, hmUser }: nixpkgs.lib.nixosSystem {
    modules = [ overlay ./hosts/${hostName} ./configuration.nix sharedHM ];
  };
in {
  nixosConfigurations = {
    nixos    = mkHost { hostName = "laptop";     hmUser = "rahul"; };
    nixosBtw = mkHost { hostName = "laptop-amd"; hmUser = "rahul"; };
  };
}
```

---

## 6. With Expressions

Avoid repeating a prefix — opens an attribute set into scope:

```nix
# Without with — repetitive:
[ pkgs.git pkgs.btop pkgs.kitty pkgs.tmux ]

# With with — cleaner:
with pkgs; [ git btop kitty tmux ]
```

Real example from your `home.nix`:

```nix
home.packages = with pkgs; [
  fastfetch
  btop
  nano
  stow
  lazygit
  python313
  nodejs_24
];
```

---

## 7. Functions

Nix functions take exactly one argument:

```nix
# Basic function: takes x, returns x + 1
x: x + 1

# Call it:
(x: x + 1) 5   # → 6
```

Functions with attribute set argument — how EVERY module is written:

```nix
# Your boot.nix:
{ config, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
```

Leave out args you don't need — real example from your `networking.nix`:

```nix
{ ... }:
{
  networking.networkmanager.enable = true;
  # hostName is NOT here — each host sets its own in hosts/*/default.nix
}
```

The `mkHost` function from your `flake.nix` — a function that takes an attribute set and returns a NixOS system:

```nix
mkHost = { hostName, hmUser }: nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { inherit inputs; };
  modules = [
    overlay
    ./hosts/${hostName}    # ← hostName used here via interpolation
    ./configuration.nix
  ];
};

# Calling it:
nixos    = mkHost { hostName = "laptop";     hmUser = "rahul"; };
nixosBtw = mkHost { hostName = "laptop-amd"; hmUser = "rahul"; };
```

The overlay — a function that takes `(final, prev)` and returns new packages:

```nix
(final: prev: {
  unstable = import inputs.nixpkgs-unstable {
    system = prev.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
})
```

---

## 8. `@` Pattern

Capture all arguments into one variable while still destructuring:

```nix
# Without @ — can't pass all inputs at once
outputs = { nixpkgs, home-manager, ... }:

# With @ — capture everything as `inputs` AND destructure
outputs = { nixpkgs, home-manager, ... }@inputs:
#                                      ^^^^^^^
# Now you can use both `nixpkgs` and `inputs` in the body
# inputs.nixpkgs == nixpkgs

# Real use — passing all inputs to modules:
specialArgs = { inherit inputs; };
```

---

## 9. Inherit

Shorthand to avoid writing `key = key`:

```nix
let inputs = { nixpkgs = ...; home-manager = ...; };
in {
  # Without inherit:
  specialArgs = { inputs = inputs; };

  # With inherit (same thing):
  specialArgs = { inherit inputs; };
}
```

Real example from your `flake.nix`:

```nix
# Passes inputs + hostName into every HM module
home-manager.extraSpecialArgs = { inherit inputs hostName; };
```

Now any HM module can use them:

```nix
# home-manager/modules/something.nix
{ inputs, hostName, pkgs, ... }:
{
  # use inputs.noctalia or hostName here
}
```

---

## 10. Import

Pull in another `.nix` file:

```nix
# Import a file (it gets evaluated)
import ./modules/boot.nix

# Real example — how hosts import shared config:
# hosts/laptop/default.nix:
imports = [
  ./hardware-configuration.nix
  ../../modules/nvidia.nix   # ← only the nvidia laptop imports this
];
```

Real example from your `flake.nix`:

```nix
home-manager.users.rahul = import ./home-manager/home.nix;
# loads home.nix and passes it to home-manager
```

---

## 11. If Expressions

`if` always returns a value:

```nix
if true then "yes" else "no"   # → "yes"

# Conditionally include a package:
environment.systemPackages = with pkgs; [
  git
] ++ (if config.services.pipewire.enable then [ pavucontrol ] else []);
```

---

## 12. Builtins

Built-in functions available everywhere:

```nix
# Convert nix value to JSON — used in your zed.nix:
builtins.toJSON {
  buffer_font_size = 16;
  vim_mode = false;
}
# → '{"buffer_font_size":16,"vim_mode":false}'

# Read a file as a string
builtins.readFile ./somefile.txt

# Check type of a value
builtins.typeOf "hello"        # → "string"
builtins.typeOf [ 1 2 3 ]      # → "list"
builtins.typeOf { a = 1; }     # → "set"
builtins.typeOf true           # → "bool"
```

---

## 13. Lib Functions

`lib` is a collection of helpers NixOS provides:

```nix
# Force a value — overrides anything another module sets
# Real example from your nvidia.nix:
hardware.nvidia.prime.sync.enable = lib.mkForce false;

# Set a default — other modules can still override
# Real example from your hardware-configuration.nix:
hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

# Add items to a list only if a condition is true
lib.optionals config.services.bluetooth.enable [ pkgs.bluez ]

# Check if something is in a list
lib.elem "wheel" [ "wheel" "audio" "video" ]   # → true
```

---

## 14. The Module System

NixOS collects ALL modules and deep-merges them into one final config:

```nix
# modules/audio.nix returns:
{ services.pipewire.enable = true; }

# modules/bluetooth.nix returns:
{ hardware.bluetooth.enable = true; }

# NixOS merges → final config:
{
  services.pipewire.enable = true;
  hardware.bluetooth.enable = true;
}
```

Lists are concatenated, not overwritten. Real example from your config:

```nix
# modules/git.nix:
environment.systemPackages = [ pkgs.git pkgs.git-lfs ];

# hosts/laptop/default.nix imports nvidia.nix which adds:
services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];

# configuration.nix adds:
networking.firewall.enable = true;

# All merged into one system — nothing gets lost
```

---

## 15. NixOS Module vs Home Manager Module

They look identical but configure different things:

```nix
# NixOS module — system level (in modules/)
{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.git ];  # available to ALL users + root
  services.openssh.enable = true;             # system-wide service
}

# Home Manager module — user level (in home-manager/modules/)
{ pkgs, ... }:
{
  home.packages = [ pkgs.git ];    # available to rahul only
  programs.git.enable = true;      # configures git for rahul
}
```

---

## 16. specialArgs and extraSpecialArgs

How to pass custom values into modules — real example from your `flake.nix`:

```nix
nixpkgs.lib.nixosSystem {
  specialArgs = { inherit inputs; };   # → available in ALL NixOS modules

  modules = [
    home-manager.nixosModules.home-manager
    {
      home-manager.extraSpecialArgs = { inherit inputs hostName; };  # → available in ALL HM modules
    }
  ];
};
```

Using them in a module:

```nix
# Any NixOS module:
{ inputs, pkgs, ... }:
{
  environment.systemPackages = [
    inputs.some-flake.packages.${pkgs.system}.default
  ];
}

# Any HM module:
{ inputs, hostName, pkgs, ... }:
{
  # conditionally install something only on the nvidia laptop
  home.packages = lib.optionals (hostName == "laptop") [ pkgs.nvtopPackages.amd ];
}
```

---

## 17. Writing a Module from Scratch

Adding Syncthing as a real-world example:

```nix
# modules/syncthing.nix
{ config, ... }:
{
  services.syncthing = {
    enable = true;
    user = "rahul";
    dataDir = "/home/rahul/Sync";
    configDir = "/home/rahul/.config/syncthing";
  };

  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
}
```

Add to `configuration.nix`:

```nix
imports = [
  ./modules/boot.nix
  ./modules/syncthing.nix  # ← add here
];
```

---

## 18. Writing a Home Manager Module from Scratch

Adding `bat` (better `cat`):

```nix
# home-manager/modules/shell/bat.nix
{ pkgs, ... }:
{
  programs.bat = {
    enable = true;
    config = {
      theme = "Nord";
      italic-text = "always";
    };
  };
}
```

Add to `home-manager/home.nix`:

```nix
imports = [
  ./modules/shell/bash.nix
  ./modules/shell/bat.nix  # ← add here
];
```

HM writes `~/.config/bat/config` automatically.

---

## Quick Reference

| Concept | Syntax | Your config example |
|---------|--------|---------------------|
| String | `"value"` | `"nixos"` |
| Interpolation | `"${var}"` | `"${config.home.homeDirectory}/Desktop"` |
| Boolean | `true` / `false` | `services.pipewire.enable = true` |
| List | `[ a b c ]` | `[ "wheel" "audio" "networkmanager" ]` |
| Attribute set | `{ key = val; }` | `{ enable = true; pulse.enable = true; }` |
| Let binding | `let x = 1; in x` | `let home = config.home.homeDirectory; in ...` |
| With | `with pkgs; [ git ]` | `with pkgs; [ fastfetch btop lazygit ]` |
| Function | `arg: body` | `{ hostName, hmUser }: nixpkgs.lib.nixosSystem { }` |
| @ pattern | `{ a, ... }@all` | `{ nixpkgs, ... }@inputs` |
| Import | `import ./file.nix` | `import ./home-manager/home.nix` |
| Inherit | `{ inherit x; }` | `specialArgs = { inherit inputs; }` |
| Force override | `lib.mkForce val` | `lib.mkForce false` |
| Default value | `lib.mkDefault val` | `lib.mkDefault config.hardware.enableRedistributableFirmware` |
| JSON output | `builtins.toJSON { }` | `builtins.toJSON { buffer_font_size = 16; }` |
| Conditional list | `lib.optionals cond [ ]` | `lib.optionals (hostName == "laptop") [ pkgs.nvtop ]` |
