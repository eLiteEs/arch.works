# Makefile - Setup Hyprland environment
# Uso: make install        (instala todo)
#       make configs        (solo copia las configs)
#       make deps           (solo instala dependencias)
#       make help           (muestra esta ayuda)

DOTFILES_DIR := config 
CONFIG_DIR   := ~/.config

# ─── Paquetes pacman ───────────────────────────────────────────────────────────
PACMAN_PKGS := \
	hyprland \
	hyprpaper \
	waybar \
	alacritty \
	rofi-wayland \
	dunst \
	swaylock \
	wireplumber \
	pipewire \
	pipewire-pulse \
	pavucontrol \
	helvum \
	dmenu \
	xdg-desktop-portal-hyprland \
	xdg-desktop-portal \
	polkit-gnome \
	qt5-wayland \
	qt6-wayland \
	noto-fonts \
	ttf-font-awesome \
	ttf-nerd-fonts-symbols

# ─── Paquetes AUR ─────────────────────────────────────────────────────────────
AUR_PKGS := \
	hyprswitch \
	numix-circle-icon-theme-git

# ─── Targets ──────────────────────────────────────────────────────────────────

.PHONY: all install deps aur configs help

all: install

help:
	@echo ""
	@echo "  make install   → instala dependencias (pacman + AUR) y copia configs"
	@echo "  make deps      → solo instala paquetes pacman"
	@echo "  make aur       → solo instala paquetes AUR (requiere yay o paru)"
	@echo "  make configs   → solo copia las configs a ~/.config"
	@echo "  make yay       → compila yay" 
	@echo ""

install: deps aur configs
	@echo ""
	@echo "✓ Instalación completada. Reinicia Hyprland o haz login de nuevo."

# ─── Dependencias pacman ──────────────────────────────────────────────────────
deps:
	@echo "→ Instalando paquetes pacman..."
	sudo pacman -Syu --needed --noconfirm $(PACMAN_PKGS)

# ─── Instalar yay ────────────────────────────────────────────────────────────
yay:
	@if command -v yay > /dev/null 2>&1; then \
		echo "✓ yay ya está instalado."; \
	else \
		echo "→ Instalando yay..."; \
		sudo pacman -S --needed --noconfirm git base-devel; \
		git clone https://aur.archlinux.org/yay.git /tmp/yay; \
		cd /tmp/yay && makepkg -si --noconfirm; \
		rm -rf /tmp/yay; \
		echo "✓ yay instalado."; \
	fi

# ─── Dependencias AUR ────────────────────────────────────────────────────────
aur: yay
	@echo "→ Instalando paquetes AUR..."
	@if command -v yay > /dev/null 2>&1; then \
		yay -S --needed --noconfirm $(AUR_PKGS); \
	elif command -v paru > /dev/null 2>&1; then \
		paru -S --needed --noconfirm $(AUR_PKGS); \
	else \
		echo "⚠ No se encontró yay ni paru. Instala uno primero:"; \
		echo "  https://github.com/Jguer/yay  o  https://github.com/morganamilo/paru"; \
		exit 1; \
	fi

# ─── Configs ─────────────────────────────────────────────────────────────────
configs:
	@echo "→ Creando directorios en ~/.config..."
	mkdir -p $(CONFIG_DIR)/hypr
	mkdir -p $(CONFIG_DIR)/waybar
	mkdir -p $(CONFIG_DIR)/dunst
	mkdir -p $(CONFIG_DIR)/alacritty
	mkdir -p $(CONFIG_DIR)/rofi

	@echo "→ Copiando configs..."

	# Hyprland
	cp -v $(DOTFILES_DIR)/hypr/hyprland.conf    $(CONFIG_DIR)/hypr/hyprland.conf
	cp -v $(DOTFILES_DIR)/hypr/hyprpaper.conf   $(CONFIG_DIR)/hypr/hyprpaper.conf 2>/dev/null || true

	# Waybar
	cp -v $(DOTFILES_DIR)/waybar/config         $(CONFIG_DIR)/waybar/config
	cp -v $(DOTFILES_DIR)/waybar/style.css      $(CONFIG_DIR)/waybar/style.css 2>/dev/null || true

	# Dunst
	cp -v $(DOTFILES_DIR)/dunst/dunstrc         $(CONFIG_DIR)/dunst/dunstrc 2>/dev/null || true

	# Alacritty
	cp -v $(DOTFILES_DIR)/alacritty/alacritty.toml $(CONFIG_DIR)/alacritty/alacritty.toml 2>/dev/null || true

	# Rofi
	cp -rv $(DOTFILES_DIR)/rofi/                $(HOME)/rofi 2>/dev/null || true

	@echo "✓ Configs copiadas."
