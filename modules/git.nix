{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    git-lfs
  ];

  # SSH agent for git
  programs.ssh.startAgent = true;
}
