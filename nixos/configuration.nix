# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "nvidia" ];
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/55880460-ac50-4715-a9f5-16ec5ee85e5d";
      preLVM = true;
      allowDiscards = true;
    };
  };
  boot.kernelPackages = pkgs.linuxPackages;
  boot.kernelModules = [ "i2c-dev" ];

  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  
  environment.variables = {
    GDK_SCALE = "1";
    GDK_DPI_SCALE = "1";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };
  environment.pathsToLink = [ "/libexec" ];
  
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];
 
  networking.hostName = "h1";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "US/Central";
  time.hardwareClockInLocalTime = false;

  hardware.bluetooth.enable = true; 
  
  
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    desktopManager = {
      xterm.enable = false;
    };
    displayManager = {
      defaultSession = "none+i3";
    };
    dpi = 103;
    inputClassSections = [
      ''
        Identifier "libinput pointer catchall"
        MatchDevicePath "/dev/input/event*"	
        MatchIsPointer "on"
	Option "NaturalScrolling" "true"
        Driver "libinput"
      ''
      ''
        Identifier "libinput touchpad catchall"
        MatchDevicePath "/dev/input/event*"
        MatchIsTouchpad "on"
	Driver "libinput"
	Option "NaturalScrolling" "true"
	Option "Tapping" "on"
      ''
    ];
    layout = "us";
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
    };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        polybar # gives you the default i3 status bar
        i3lock #default i3 screen locker
     ];
    };
  };  

  fonts.fonts = with pkgs; [
#    font-awesome
#    font-awesome_4
#    font-awesome_5
    nerdfonts
#    fira-code
#    fira-code-symbols
#    liberation_ttf
#    mplus-outline-fonts
#    noto-fonts
#    noto-fonts-cjk
#    noto-fonts-emoji
#    proggyfonts
#    siji
  ];

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  #sound.enable = true;
  #hardware.pulseaudio.enable = true;
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true; 
    media-session.config.bluez-monitor.rules = [
    {
      # Matches all cards
      matches = [ { "device.name" = "~bluez_card.*"; } ];
      actions = {
        "update-props" = {
          "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
          # mSBC is not expected to work on all headset + adapter combinations.
          "bluez5.msbc-support" = true;
          # SBC-XQ is not expected to work on all headset + adapter combinations.
          "bluez5.sbc-xq-support" = true;
        };
      };
    }
    {
      matches = [
        # Matches all sources
        { "node.name" = "~bluez_input.*"; }
        # Matches all outputs
        { "node.name" = "~bluez_output.*"; }
      ];
      actions = {
        "node.pause-on-idle" = false;
      };
    }
  ];
  };

  services.fwupd.enable = true;

  services.udev = {
    extraRules = ''
      # HW.1 / Nano
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1b7c|2b7c|3b7c|4b7c", TAG+="uaccess", TAG+="udev-acl"
      # Blue
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0000|0000|0001|0002|0003|0004|0005|0006|0007|0008|0009|000a|000b|000c|000d|000e|000f|0010|0011|0012|0013|0014|0015|0016|0017|0018|0019|001a|001b|001c|001d|001e|001f", TAG+="uaccess", TAG+="udev-acl"
      # Nano S
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0001|1000|1001|1002|1003|1004|1005|1006|1007|1008|1009|100a|100b|100c|100d|100e|100f|1010|1011|1012|1013|1014|1015|1016|1017|1018|1019|101a|101b|101c|101d|101e|101f", TAG+="uaccess", TAG+="udev-acl"
      # Aramis
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0002|2000|2001|2002|2003|2004|2005|2006|2007|2008|2009|200a|200b|200c|200d|200e|200f|2010|2011|2012|2013|2014|2015|2016|2017|2018|2019|201a|201b|201c|201d|201e|201f", TAG+="uaccess", TAG+="udev-acl"
      # HW2
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0003|3000|3001|3002|3003|3004|3005|3006|3007|3008|3009|300a|300b|300c|300d|300e|300f|3010|3011|3012|3013|3014|3015|3016|3017|3018|3019|301a|301b|301c|301d|301e|301f", TAG+="uaccess", TAG+="udev-acl"
      # Nano X
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0004|4000|4001|4002|4003|4004|4005|4006|4007|4008|4009|400a|400b|400c|400d|400e|400f|4010|4011|4012|4013|4014|4015|4016|4017|4018|4019|401a|401b|401c|401d|401e|401f", TAG+="uaccess", TAG+="udev-acl"
      # Ledger Test
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0005|5000|5001|5002|5003|5004|5005|5006|5007|5008|5009|500a|500b|500c|500d|500e|500f|5010|5011|5012|5013|5014|5015|5016|5017|5018|5019|501a|501b|501c|501d|501e|501f", TAG+="uaccess", TAG+="udev-acl"

      # Control Monitor brightness
      KERNEL=="i2c-[0-9]*", GROUP="input", MODE="0660"

      # Set natural scrolling on bluetooth connect
      #SUBSYSTEM=="hid", KERNEL=="mouse[0-9]*", ACTION=="bind", ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/home/victor/.Xauthority", RUN+="xinput set-prop 'pointer:Logitech Wireless Mouse MX Master 3' 'libinput Natural Scrolling Enabled' 1" 
      #KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{address}=="04:33:c2:3e:91:4d" RUN+="/home/victor/bin/test.sh" 
    '';
  };

  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.victor = {
    description = "Victor Trac";
    extraGroups = [ "docker" "input" "networkmanager" "tty" "wheel" "video" ];
    home = "/home/victor";
    isNormalUser = true;
    shell = pkgs.fish;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: rec {
      polybar = pkgs.polybar.override {
        i3Support = true;
      };
    };
  }; 
  environment.systemPackages = with pkgs; [
    alacritty
    discord
    dunst
    feh
    firefox
    kmscon
    pavucontrol
    polybar
    psmisc
    rofi
    tailscale
    tmux
    wget
    zoom-us
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.dconf.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.fish.enable = true;
  programs.nm-applet.enable = true;
  programs.neovim = {
    enable = true;
    viAlias = true;
  };
  #programs.ssh = {
  #  startAgent = true;
  #};

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  nix.gc.automatic = true;
  nix.gc.options = "--delete-generations +12";

  system.autoUpgrade.enable = true;
  system.stateVersion = "21.05"; # Did you read the comment?
}
