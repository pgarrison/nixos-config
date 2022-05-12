self:
let
  enableWayland = drv: bin: drv.overrideAttrs (
    old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ self.makeWrapper ];
      postFixup = (old.postFixup or "") + ''
        wrapProgram $out/bin/${bin} \
          --add-flags "--enable-features=UseOzonePlatform" \
          --add-flags "--ozone-platform=wayland" \
          --add-flags "--log debug" \
          --add-flags "--log debug"
      '';
      # The --log debug flags are just an ugly workaround for https://github.com/microsoft/vscode/issues/146349
    }
  );
in
super:
  {
    #signal-desktop = enableWayland super.signal-desktop "signal-desktop";
    #slack = enableWayland super.slack "slack";
    #discord = enableWayland super.discord "discord";
    #vscode = enableWayland super.vscode "code";
    vscodium = enableWayland super.vscodium "codium";
    chromium = (
      super.chromium.override {
        commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
      }
    );
  }
