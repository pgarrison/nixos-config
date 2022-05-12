self:
let
  enableWayland = drv: bin: drv.overrideAttrs (
    old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ self.makeWrapper ];
      postFixup = (old.postFixup or "") + ''
        wrapProgram $out/bin/${bin} \
          --add-flags "--enable-features=UseOzonePlatform" \
          --add-flags "--ozone-platform=wayland"
      '';
    }
  );
in
super:
  {
    signal-desktop = enableWayland super.signal-desktop "signal-desktop";
    #slack = enableWayland super.slack "slack";
    #discord = enableWayland super.discord "discord";
    #vscode = enableWayland super.vscode "code";
    #vscodium = enableWayland super.vscodium "vscodium";
    chromium = enableWayland super.chromium "chromium";
    /*
    google-chrome-beta = (
      super.google-chrome-beta.override {
        commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
      }
    );
    */
  }
