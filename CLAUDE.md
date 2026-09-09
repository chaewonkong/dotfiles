# Home Manager Configuration

macOS / Ubuntu Desktop 2개 머신의 dotfiles를 Nix home-manager 하나로 관리하는 저장소. 유저는 두 머신 모두 `leon`.

## 구조

- `flake.nix` — Flake 입력(nixpkgs unstable, home-manager, claude-code-nix, catppuccin) 및 `mkHome` 헬퍼로 `homeConfigurations.{mac,ubuntu}` 정의
- `flake.lock` — 의존성 잠금 파일
- `home.nix` — 공통 모듈 import. `home.homeDirectory`만 `pkgs.stdenv.hostPlatform.isDarwin` 여부로 분기, 그 외 플랫폼 분기는 `pkgs.stdenv.hostPlatform.isLinux`로 필요한 곳에서만
- `modules/`
  - `packages.nix` — 크로스플랫폼 CLI/개발 도구. `obsidian`은 Linux(Ubuntu)에서만 nixpkgs로 설치 (macOS는 `brew.nix`의 cask로 설치)
  - `shell.nix` — zsh, zoxide, podman policy.json (크로스플랫폼)
  - `brew.nix` — Homebrew를 Nix로 관리. `formulae`/`casks` 목록으로 Brewfile을 생성해 `home.activation`에서 `brew bundle` 실행. **casks는 macOS 전용**(Homebrew Cask 자체가 Linux를 지원하지 않음), formulae는 두 플랫폼 공통
  - `git.nix`, `apps.nix` — 크로스플랫폼

## 스택

- **Shell**: zsh (completion, autosuggestion, syntax-highlighting 활성화)
- **Font**: JetBrains Mono Nerd Font, Noto CJK
- **패키지 관리**: 기본은 nixpkgs, nixpkgs가 잘 안 되는 것(주로 GUI 앱)은 Homebrew — apt/dnf 등 OS 패키지 매니저는 쓰지 않음

## 적용 방법

```bash
# brew 사전 설치 필요: https://brew.sh (macOS/Ubuntu 공통)
# repo는 양쪽 머신 모두 ~/.config/home-manager 에 clone (nvim 모듈의 out-of-store symlink 경로 전제)
home-manager switch --flake ~/.config/home-manager#mac     # macOS
home-manager switch --flake ~/.config/home-manager#ubuntu  # Ubuntu
# 이후로는 alias `hms` (플랫폼 자동 감지)
```

### Ubuntu 초기 세팅 시 수동 작업

home-manager 범위 밖(시스템 레벨)이라 직접 해야 하는 것:

- **로그인 셸 변경** — Ubuntu 기본 셸은 bash. zsh 설정이 bash에 읽히면 `(Ie)__zoxide_hook` 문법 에러가 남
  ```bash
  command -v zsh | sudo tee -a /etc/shells
  chsh -s "$(command -v zsh)"   # 반영은 GNOME 세션 로그아웃/재로그인 후
  ```
- **시스템 데몬/드라이버는 apt** — `openssh-server`, NVIDIA 드라이버(`ubuntu-drivers install`) 등. "apt 안 씀" 원칙은 home-manager가 관리하는 유저 도구에 한함
- **Ghostty terminfo**는 `modules/shell.nix`가 `~/.terminfo`에 자동 배치 (Linux만). 수동으로 `tic` 했었다면 switch 전에 `rm ~/.terminfo/x/xterm-ghostty`

## 작업 시 주의사항

- `home.stateVersion`은 변경하지 말 것 (현재 `"24.11"`)
- 새 패키지 추가 시 두 시스템(aarch64-darwin, x86_64-linux) 호환성 확인 필요
- GUI 앱은 원칙적으로 `modules/brew.nix`의 `casks`(macOS)에, Linux에서 nixpkgs로 대체 가능하면 `packages.nix`에 `lib.optionals pkgs.stdenv.hostPlatform.isLinux [...]`로 추가
- Homebrew formula/cask를 추가해도 `brew`가 로컬에 설치되어 있지 않으면 activation이 조용히 스킵됨 (에러로 막지 않음) — `modules/brew.nix` 참고
- 한글 입력은 이 저장소가 관리하지 않음 — Ubuntu는 GNOME 기본 IBus(`ibus-hangul` 등)로, macOS는 시스템 입력기로 각자 설정
- nixpkgs는 `unstable` 채널 사용
