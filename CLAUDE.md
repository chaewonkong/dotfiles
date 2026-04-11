# Home Manager Configuration

M2 MacBook Air에서 Fedora Asahi Remix (aarch64-linux) + Hyprland 환경의 dotfiles를 Nix home-manager로 관리하는 저장소.

## 구조

- `flake.nix` — Flake 입력(nixpkgs unstable, home-manager, claude-code-nix) 및 homeConfiguration 정의
- `flake.lock` — 의존성 잠금 파일
- `home.nix` — 모든 설정이 들어있는 단일 home-manager 모듈 (패키지, 프로그램, Hyprland 설정 등)

## 스택

- **OS**: Fedora Asahi Remix (aarch64-linux)
- **WM**: Hyprland (Wayland)
- **Shell**: zsh (completion, autosuggestion, syntax-highlighting 활성화)
- **Terminal**: kitty (시스템 패키지, home-manager 밖에서 관리)
- **IME**: fcitx5 (한글 입력)
- **Font**: JetBrains Mono Nerd Font, Noto CJK

## 적용 방법

```bash
home-manager switch --flake ~/.config/home-manager
```

## 작업 시 주의사항

- `home.stateVersion`은 변경하지 말 것 (현재 `"24.11"`)
- 시스템은 `aarch64-linux` — 패키지 호환성 확인 필요
- Hyprland 설정은 `home.nix` 안의 `xdg.configFile."hypr/hyprland.conf"` 인라인 텍스트로 관리
- hypridle 설정도 동일하게 `xdg.configFile."hypr/hypridle.conf"`로 관리
- 한글 입력 관련 환경변수(`GTK_IM_MODULE`, `QT_IM_MODULE`, `XMODIFIERS`)는 `home.sessionVariables`와 `systemd.user.sessionVariables` 양쪽에 설정
- nixpkgs는 `unstable` 채널 사용
