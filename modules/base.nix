{ pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # User account
  users.groups.hjiang = {};

  users.users.hjiang = {
    isNormalUser = true;
    description = "Hong Jiang";
    group = "hjiang";
    extraGroups = [ "networkmanager" "wheel" "users" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

  # Common programs
  programs.zsh.enable = true;
  programs.direnv.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Configure fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    fira-code-symbols
  ];

  # Common packages shared across all hosts
  environment.systemPackages = with pkgs; [
    claude-code
    emacs-pgtk
    fzf
    gh
    git
    gnumake
    keychain
    neovim
    nodejs
    opencode
    ripgrep
    starship
    stow
    wechat
    wget
  ];
}
