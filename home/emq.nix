{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    rclone
  ];

  # rclone configuration for S3
  # Credentials via environment variables or ~/.aws/credentials
  # Mount manually with: rclone mount emq-s3:<bucket> ~/mnt/s3
  xdg.configFile."rclone/rclone.conf".text = ''
    [emq-e2e-log]
    type = s3
    provider = AWS
    env_auth = true
    region = ap-northeast-1
    location_constraint = ap-northeast-1
    acl = private
  '';
}
