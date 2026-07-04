{
  boot.loader.limine.extraEntries = ''
    /Windows
        protocol: chainload
        path: boot(42eda0bc-8a2e-4d04-b6bc-d3c07c0fd373):///EFI/Microsoft/Boot/bootmgfw.efi
  '';
}
