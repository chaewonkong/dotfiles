{...}:
{
  # LazyVim 기반 설정. recursive = true로 파일 단위 링크 (디렉토리 통째 링크 X)
  # 플러그인 버전 변경은 config/nvim/lazy-lock.json을 직접 수정 후 switch
  xdg.configFile."nvim" = {
    source = ../config/nvim;
    recursive = true;
  };
}
