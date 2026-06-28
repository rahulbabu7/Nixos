# NixOS Commands Reference

---

## With Flakes + Home Manager (flakes-hm branch)

### Rebuild & Apply

```bash
# Apply config changes — your main command
# $(hostname) automatically uses your machine's hostname (nixos or nixosBtw)
sudo nixos-rebuild switch --flake ~/nixos#$(hostname)

# Apply but reverts on reboot — safe for testing changes
sudo nixos-rebuild test --flake ~/nixos#$(hostname)

# Just build, don't switch — check for errors without applying
sudo nixos-rebuild build --flake ~/nixos#$(hostname)

# Update all flake inputs (nixpkgs, home-manager) then rebuild
cd ~/nixos && nix flake update && sudo nixos-rebuild switch --flake ~/nixos#$(hostname)
```

### Your Aliases (active after first rebuild)

Defined in `home-manager/modules/shell/bash.nix`:

```bash
rebuild       # sudo nixos-rebuild switch --flake ~/nixos#$(hostname)
test-rebuild  # sudo nixos-rebuild test --flake ~/nixos#$(hostname)
update        # cd ~/nixos && nix flake update && rebuild
clean         # sudo nix-collect-garbage -d && nix-collect-garbage -d
optimize      # nix-store --optimize
conf          # cd ~/nixos
```

`$(hostname)` expands automatically — on `nixos` it becomes `#nixos`, on `nixosBtw` it becomes `#nixosBtw`.

### Flake Management

```bash
# See what versions all inputs are pinned to
nix flake metadata ~/nixos

# Update all inputs to latest commits
nix flake update

# Update only nixpkgs, leave home-manager pinned
nix flake update nixpkgs

# See what packages changed between your last two builds
nix store diff-closures /run/booted-system /run/current-system
```

### Generations (rollback points)

Every rebuild creates a generation — a snapshot you can go back to.

```bash
# List all generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Roll back to the previous generation
sudo nixos-rebuild switch --rollback

# Roll back to a specific generation number
sudo nix-env --switch-generation 42 --profile /nix/var/nix/profiles/system

# Boot into an older generation without switching permanently
# → select it from the ly/systemd-boot menu on startup
```

### Garbage Collection

Your `garbage.nix` runs this weekly automatically, but you can do it manually:

```bash
# Delete generations older than 15 days (what garbage.nix does automatically)
sudo nix-collect-garbage --delete-older-than 15d

# Delete ALL old generations — keeps only current
sudo nix-collect-garbage -d   # system generations
nix-collect-garbage -d        # user profile generations

# Deduplicate identical files in store (saves space, no data loss)
nix-store --optimize

# See how big your nix store is
du -sh /nix/store
```

### Searching Packages

```bash
# Search on the command line
nix search nixpkgs zed-editor
nix search nixpkgs noctalia-shell

# Try a package without installing it
nix shell nixpkgs#btop
nix shell nixpkgs#helix

# Check what version is in nixpkgs
nix eval nixpkgs#zed-editor.version
nix eval nixpkgs#noctalia-shell.version
```

---

## Without Flakes + Home Manager (main branch)

### Rebuild & Apply

```bash
# Apply config — reads nixos-config from nix.nixPath in configuration.nix
sudo nixos-rebuild switch

# Apply but reverts on reboot
sudo nixos-rebuild test

# Roll back
sudo nixos-rebuild switch --rollback
```

### Your Aliases (active after rebuild)

Defined in `modules/shell.nix`:

```bash
rebuild       # sudo nixos-rebuild switch
test-rebuild  # sudo nixos-rebuild test
update        # sudo nix-channel --update && sudo nixos-rebuild switch
clean         # sudo nix-collect-garbage -d && nix-collect-garbage -d
optimize      # nix-store --optimize
```

### Channel Management

Channels are the non-flake way to get nixpkgs — equivalent to `nix flake update`:

```bash
# See what channels you have
sudo nix-channel --list

# Update all channels to latest
sudo nix-channel --update

# Add the stable channel
sudo nix-channel --add https://nixos.org/channels/nixos-25.11 nixos

# Add unstable channel (needed for pkgs.unstable.* overlay)
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixpkgs-unstable
```

### Generations & Garbage Collection

Same commands as flakes — these work regardless of mode:

```bash
sudo nix-collect-garbage --delete-older-than 15d
sudo nix-collect-garbage -d
nix-store --optimize
```

---

## Universal Commands (work in both modes)

```bash
# Open a temporary shell with a package (gone when you exit)
nix-shell -p python313
nix-shell -p nodejs_24 git

# See the full dependency tree of a package
nix-store --query --tree $(which niri)
```

---

## Config Structure

```
~/nixos/
  flake.nix              # entry point — inputs, mkHost helper, nixosConfigurations
  flake.lock             # pinned exact git commits for all inputs — never edit manually
  configuration.nix      # shared base — imported by ALL hosts

  hosts/                 # one folder per machine
    laptop/              # AMD + NVIDIA (hostname: nixos)
      default.nix        # imports nvidia.nix, sets hostName + hostPlatform
      hardware-configuration.nix
    laptop-amd/          # AMD only (hostname: nixosBtw)
      default.nix        # sets hostName + hostPlatform, no nvidia
      hardware-configuration.nix  # generate with nixos-generate-config on that machine

  modules/               # shared system modules — used by all hosts
    boot.nix             # systemd-boot, linuxPackages_latest
    networking.nix       # NetworkManager (hostname set per-host)
    locale.nix           # Asia/Kolkata, en_US.UTF-8
    audio.nix            # PipeWire + WirePlumber
    bluetooth.nix        # Bluetooth, A2DP audio fix
    desktop.nix          # niri, ly display manager, XDG portals, upower
    flatpak.nix          # Flatpak service
    garbage.nix          # weekly auto GC, auto-optimise-store
    git.nix              # git + git-lfs, SSH agent
    users.nix            # user rahul, groups, allowUnfree = true
    fonts.nix            # JetBrains Mono, Fira Code, Noto, Lilex, Font Awesome
    nvidia.nix           # AMD+NVIDIA PRIME sync — imported only by hosts/laptop/

  home-manager/          # user environment — shared across all hosts
    home.nix             # packages, sessionVariables, xdg dirs
    modules/
      shell/
        bash.nix         # aliases, prompt with git branch, bash functions
        git.nix          # git config, delta pager, lazygit
      editors/
        zed.nix          # zed-editor package
      terminal/
        kitty.nix        # kitty package
        tmux.nix         # tmux package
      configs.nix        # symlinks ~/Config/* → ~/.config/* (replaces stow)

  docs/
    commands.md          # this file
    nix-language.md      # nix language guide

  ~/Config/              # your dotfiles — edit here, changes apply instantly
    kitty/               # → ~/.config/kitty
    niri/                # → ~/.config/niri
    noctalia/            # → ~/.config/noctalia
    zed/                 # → ~/.config/zed
    helix/               # → ~/.config/helix
    tmux/                # → ~/.config/tmux/tmux.conf
    fuzzel/              # → ~/.config/fuzzel
    mako/                # → ~/.config/mako
```

---

## Multi-Host: Adding a New Machine

**1. Generate hardware config on the new machine:**
```bash
sudo nixos-generate-config --show-hardware-config > /tmp/hardware-configuration.nix
# copy that file to ~/nixos/hosts/new-machine/hardware-configuration.nix
```

**2. Create `hosts/new-machine/default.nix`:**
```nix
{ ... }:
{
  imports = [ ./hardware-configuration.nix ];
  networking.hostName = "new-machine";
  nixpkgs.hostPlatform = "x86_64-linux";
}
```

**3. Add it to `flake.nix`:**
```nix
nixosConfigurations = {
  nixos      = mkHost { hostName = "laptop";      hmUser = "rahul"; };
  nixosBtw   = mkHost { hostName = "laptop-amd";  hmUser = "rahul"; };
  new-machine = mkHost { hostName = "new-machine"; hmUser = "rahul"; };
};
```

**4. Rebuild on that machine:**
```bash
sudo nixos-rebuild switch --flake ~/nixos#new-machine
```

---

## Writing Your Own Module

Every module is the same pattern. Real example from your config:

```nix
# modules/audio.nix
{ pkgs, ... }:

{
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
}
```

New module example — adding Tailscale:

```nix
# modules/tailscale.nix
{ ... }:

{
  services.tailscale.enable = true;
  networking.firewall.allowedUDPPorts = [ 41641 ];
}
```

Add to `configuration.nix`:

```nix
imports = [
  ./modules/boot.nix
  ./modules/tailscale.nix  # ← add here
  # ...
];
```

Run `rebuild` — done.

---

## Adding a Flake-Only Package

For packages not in nixpkgs (e.g. if noctalia wasn't in nixpkgs):

**1. Add input to `flake.nix`:**
```nix
inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

  noctalia = {
    url = "github:noctalia-dev/noctalia/legacy-v4";
    inputs.nixpkgs.follows = "nixpkgs";  # reuse your nixpkgs, don't download a second copy
  };
};
```

**2. Use the package in any module (works because of `specialArgs = { inherit inputs; }`):**
```nix
{ inputs, pkgs, ... }:
{
  environment.systemPackages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
```
