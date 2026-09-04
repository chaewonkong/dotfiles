{ config, ... }:
let
  # 양쪽 머신 모두 repo를 ~/.config/home-manager 에 clone (README/hms alias와 동일한 전제).
  dotfiles = "${config.home.homeDirectory}/.config/home-manager";
in
{
  # LazyVim 기반 설정. nix store가 아닌 repo 디렉토리로 직접 링크 → 쓰기 가능.
  # lazy.nvim이 lazy-lock.json을 갱신하면 그대로 git에 잡힘 (:Lazy update 후 커밋).
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/config/nvim";
}
