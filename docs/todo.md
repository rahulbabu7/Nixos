# NixOS Learning Roadmap

---

## Stage 1 — Get Comfortable
> Do these before anything else

- [ ] Read `docs/nix-language.md` fully
- [ ] Read every module in `modules/` and understand each line
- [ ] Read `flake.nix` and understand `mkHost`, `@inputs`, `specialArgs`
- [ ] Read `home-manager/home.nix` and all its modules
- [ ] Add one service yourself — try `services.tailscale.enable = true`
  - Create `modules/tailscale.nix`
  - Add it to `configuration.nix`
  - Run `rebuild` and verify it works

---

## Stage 2 — Get Both Machines Working
> Once Stage 1 is done

- [ ] Generate hardware config for `nixosBtw` (AMD laptop)
  ```bash
  sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
  # copy to ~/nixos/hosts/laptop-amd/hardware-configuration.nix
  ```
- [ ] Test `flakes-hm` branch builds cleanly on `nixos`
  ```bash
  sudo nixos-rebuild switch --flake ~/nixos#nixos
  ```
- [ ] Test `flakes-hm` branch builds on `nixosBtw`
  ```bash
  sudo nixos-rebuild switch --flake ~/nixos#nixosBtw
  ```
- [ ] Merge `flakes-hm` into `main` once both machines are stable

---

## Stage 3 — Go Declarative
> Move configs from ~/Config into Nix, one at a time

- [ ] Write `tmux` config declaratively in `home-manager/modules/terminal/tmux.nix`
  - Remove `tmux` entry from `configs.nix`
- [ ] Write `kitty` config declaratively in `home-manager/modules/terminal/kitty.nix`
  - Remove `kitty` entry from `configs.nix`
- [ ] Write `niri` config declaratively using `programs.niri.settings`
  - Remove `niri` entry from `configs.nix`

---

## Stage 4 — Polish
> When Stage 3 is stable

- [ ] Add theming properly — noctalia templates or catppuccin managed via HM
- [ ] Explore nvf for declarative neovim config
  - Check `~/Config/nvim` — you already have a neovim config to port
- [ ] Clean up `~/Config` — remove stow entries that are now managed by HM

---

## Done
> Move completed items here

- [x] Set up NixOS without flakes and home-manager (main branch)
- [x] Switch from KDE to niri + noctalia
- [x] Set up multi-host config (nixos + nixosBtw)
- [x] Set up flakes + home-manager (flakes-hm branch)
- [x] Replace stow with `mkOutOfStoreSymlink` in home-manager
- [x] Write docs (commands.md, nix-language.md)
