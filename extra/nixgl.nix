{ inputs, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  isX86 = system == "x86_64-linux";
  nixglNixpkgs = inputs.nixgl.inputs.nixpkgs.legacyPackages.${system};

  nvidiaVersionFile =
    pkgs.runCommand "nvidia-version-fixed"
      {
        time = builtins.currentTime;
        preferLocalBuild = true;
        allowSubstitutes = false;
      }
      ''
        sed -E 's/Open Kernel Module for x86_64/Kernel Module/' \
          /proc/driver/nvidia/version > $out 2>/dev/null || touch $out
      '';

  nixglBuilt = import "${inputs.nixgl}/default.nix" {
    pkgs = nixglNixpkgs;
    inherit nvidiaVersionFile;
    enable32bits = isX86;
  };

  hasNvidia = nixglBuilt.auto.nixGLDefault != nixglBuilt.nixGLIntel;

  named =
    pkg:
    pkg.overrideAttrs (old: {
      meta = (old.meta or { }) // {
        mainProgram = "nixGL";
      };
    });

  nixglDefaultNamed = named nixglBuilt.auto.nixGLDefault;

  nixVulkanSafe = named (
    if hasNvidia then
      nixglBuilt.nixGLCommon nixglBuilt.auto.nixVulkanNvidia
    else
      nixglBuilt.nixGLCommon nixglBuilt.nixVulkanIntel
  );
in
{
  targets.genericLinux.nixGL = {
    packages = nixglBuilt // {
      nixGLNvidia = nixglDefaultNamed;
      nixGLMesa = nixglDefaultNamed;
      nixVulkanNvidia = nixVulkanSafe;
    };
    defaultWrapper = "nvidia";
    installScripts = [ "nvidia" ];
    vulkan.enable = true;
  };
}
