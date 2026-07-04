{ pkgs, ... }:

{
  home.packages = with pkgs; [ 
    unstable.zed-editor
    unstable.claude-code
  ];
}
