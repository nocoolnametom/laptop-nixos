{ config, lib, pkgs, ... }:

{
  programs.ssh.compression = true;

  # The default private key to use
  # This is a file reference so the key doesn't end up in the store
  programs.ssh.extraConfig = ''
    IdentityFile ${toString ../../../myKeys/private/id_rsa}
  '';

  # Work hosts use the work private key
  programs.ssh.matchBlocks.ZG02911.identityFile =
    toString ../../../myKeys/private/work_rsa;
  programs.ssh.matchBlocks.zg02911vmu.identityFile =
    toString ../../../myKeys/private/work_rsa;

  # Github and Gitlab need to use the "git" user
  programs.ssh.matchBlocks.github.hostname = "github.com";
  programs.ssh.matchBlocks.github.user = "git";
  programs.ssh.matchBlocks.gitlab.hostname = "gitlab.com";
  programs.ssh.matchBlocks.gitlab.user = "git";

  # Cloud Machines - Can ONLY be accessed via private keys
  programs.ssh.matchBlocks.elrond.hostname = "45.33.53.132";
  programs.ssh.matchBlocks.elrond.user = "root";
  programs.ssh.matchBlocks.elrond.port = 2222;
  programs.ssh.matchBlocks.linode.hostname = "45.33.53.132";
  programs.ssh.matchBlocks.linode.user = "root";
  programs.ssh.matchBlocks.linode.port = 2222;
  programs.ssh.matchBlocks."exmormon.social".port = 2222;
}
