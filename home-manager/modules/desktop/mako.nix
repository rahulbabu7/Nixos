{ config, pkgs, ... }:

{
  services.mako = {
    enable = true;

    # Updated format - all options go inside 'settings'
    settings = {
      default-timeout = 5000;        # was: defaultTimeout
      group-by = "app-name";         # was: groupBy
      max-visible = 5;               # was: maxVisible
      anchor = "top-right";          # was: anchor
      border-radius = 10;            # was: borderRadius
      border-size = 2;               # was: borderSize
      padding = "12";                # was: padding
      margin = "12";                 # was: margin
    };
  };
}
