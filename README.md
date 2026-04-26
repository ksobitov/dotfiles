# Dotfiles

Shaxsiy terminal muhiti — bitta buyruq bilan yangi tizimga o'rnatiladi.

## Tarkib

| Fayl | Yo'l | Tavsif |
|------|------|--------|
| `zsh/.zshrc` | `~/.zshrc` | Zsh konfiguratsiyasi, Oh My Zsh, pluginlar |
| `tmux/.tmux.conf` | `~/.tmux.conf` | Tmux konfiguratsiyasi, keybindinglar, pluginlar |
| `tmux/scripts/_tmux_duplicate_pane` | `~/.local/bin/_tmux_duplicate_pane` | Prefix+U: pane'ni dublikat qilish skripti |
| `kitty/kitty.conf` | `~/.config/kitty/kitty.conf` | Kitty terminal konfiguratsiyasi |
| `vim/.vimrc` | `~/.vimrc` | Vim konfiguratsiyasi |
| `systemd/xbanish.service` | `~/.config/systemd/user/xbanish.service` | xbanish systemd user service |

---

## O'rnatish

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
bash install.sh
```

Script avtomatik ravishda quyidagilarni bajaradi:

1. **Tizim paketlari** — `zsh`, `tmux`, `kitty`, `xclip`, `xbanish`, `fzf` o'rnatiladi
2. **Oh My Zsh** — o'rnatiladi (agar yo'q bo'lsa)
3. **Zsh pluginlari** — to'rtta custom plugin klonlanadi
4. **fzf shell integratsiyasi** — `~/.fzf.zsh` sozlanadi
5. **TPM** — Tmux Plugin Manager o'rnatiladi
6. **JetBrainsMono Nerd Font** — `getnf` orqali yuklanadi
7. **Symlink'lar** — barcha config fayllar symlink orqali ulanadi
8. **xbanish service** — systemd user service sifatida yoqiladi
9. **Tmux pluginlari** — TPM orqali avtomatik o'rnatiladi
10. **Default shell** — `zsh` ga o'zgartiriladi

---

## Qo'llab-quvvatlanadigan tizimlar

| Distro | Paket menejeri |
|--------|----------------|
| Ubuntu, Debian, Mint | `apt` |
| Arch, Manjaro | `pacman` |
| Fedora, RHEL | `dnf` |

---

## Zsh konfiguratsiyasi

**Fayl:** [zsh/.zshrc](zsh/.zshrc)

### Pluginlar

| Plugin | Vazifasi |
|--------|----------|
| `git` | Git alias va funksiyalari |
| `z` | Tez-tez boriladigan papkalarga tez o'tish (`z dirname`) |
| `kubectl` | Kubernetes CLI autocompletion |
| `helm` | Helm CLI autocompletion |
| `docker` | Docker CLI autocompletion |
| `zsh-vi-mode` | Vi/Vim uslubida buyruq tahriri |
| `zsh-syntax-highlighting` | Buyruqlarni rangda ko'rsatish |
| `command-not-found` | Topilmagan buyruq uchun taklif |
| `colored-man-pages` | Man sahifalarini rangli ko'rsatish |
| `fzf-zsh-plugin` | Fuzzy finder integratsiyasi |
| `zsh-autopair` | Qavslar va qo'shtirnoqlarni avtomatik yopish |

### Muhim keybindinglar

| Tugma | Amal |
|-------|------|
| `Ctrl+R` | Tarixdan fuzzy qidirish (fzf bilan) |
| `Esc` | Normal rejimga o'tish (vi-mode) |
| `v` (normal rejimda) | Buyruqni tahrirlash (vi-mode) |

### History sozlamalari

- Boshida bo'sh joy bilan boshlanган buyruqlar saqlanmaydi
- `ls`, `ll`, `cd`, `pwd`, `exit`, `clear`, `history` saqlanmaydi
- Ortiqcha bo'sh joylar olib tashlanadi

---

## Tmux konfiguratsiyasi

**Fayl:** [tmux/.tmux.conf](tmux/.tmux.conf)

### Pluginlar

| Plugin | Vazifasi |
|--------|----------|
| `tpm` | Tmux Plugin Manager |
| `tmux-resurrect` | Tmux sessiyalarini saqlash/tiklash |

> Tmux ichida pluginlarni o'rnatish: **`Prefix + I`** (katta I)

### Keybindinglar

| Tugma | Amal |
|-------|------|
| `Prefix + \|` | Pane'ni vertikal bo'lish |
| `Prefix + -` | Pane'ni gorizontal bo'lish |
| `Prefix + h/j/k/l` | Pane'lar orasida harakatlanish (vi-style) |
| `Prefix + u` | Joriy pane'ni dublikat qilish (yangi split) |
| `Prefix + g` | Pane'larni sinxronlashtirish on/off |
| `Prefix + r` | Konfiguratsiyani qayta yuklash |
| `Alt + ←/→/↑/↓` | Pane'lar orasida tez o'tish |
| `Shift + ←/→` | Oynalar orasida o'tish |

### Copy mode (vi-style)

| Tugma | Amal |
|-------|------|
| `Prefix + [` | Copy mode'ga kirish |
| `v` | Tanlashni boshlash |
| `y` | Nusxa olish |
| `r` | To'rtburchak tanlash |
| `Ctrl+V` | Clipboard'dan yapıştırish |
| Sichqoncha drag | Nusxa olish va clipboard'ga saqlash |

### Status bar

```
YYYY-MM-DD | HH:MM:SS | Mem: X.XG/X.XG
```
Har soniyada yangilanadi.

---

## Kitty konfiguratsiyasi

**Fayl:** [kitty/kitty.conf](kitty/kitty.conf)

### Asosiy sozlamalar

| Sozlama | Qiymati | Tavsif |
|---------|---------|--------|
| Font | JetBrainsMono Nerd Font Mono | Nerd Font belgilari bilan |
| Font o'lchami | 15.0 pt | |
| Cursor shakli | Block | Miltillamaydi |
| Fon shaffoflik | 1.0 (100%) | Shaffof emas |
| Oyna chegarasi | 0 | Chegara yo'q |
| Oyna paneli | 2 pt | Ichki bo'sh joy |
| Dekoratsiya | Yashirin | Title bar ko'rsatilmaydi |
| Bell | O'chirilgan | Tovushli signal yo'q |

### Keybindinglar

| Tugma | Amal |
|-------|------|
| `F11` | Toʻliq ekranga o'tish/chiqish |
| `Ctrl+L` | Terminal va scrollback'ni tozalash |

### Alternativ fontlar (izohda)

- Victor Mono Bold
- Hack Nerd Font
- FiraCode Nerd Font Mono
- Cascadia Code

---

## Vim konfiguratsiyasi

**Fayl:** [vim/.vimrc](vim/.vimrc)

| Sozlama | Tavsif |
|---------|--------|
| `relativenumber` + `number` | Gibrid raqamlar (joriy: absolut, qolganlar: nisbiy) |
| `tabstop/shiftwidth/softtabstop = 2` | 2 bo'shliq, tab o'rniga space |
| `smartcase` + `ignorecase` | Kichik harfda — katta/kichik farq qilmaydi; katta harf bo'lsa — farq qiladi |
| `clipboard=unnamedplus` | Tizim clipboard bilan integratsiya (xclip kerak) |
| `mouse=a` | Sichqoncha ko'magi to'liq yoqilgan |
| `list` + `listchars` | Tab, trailing space va boshqa ko'rinmas belgilarni ko'rsatadi |
| `wildmenu` | Tab completion'ni menyu ko'rinishida ko'rsatadi |

---

## xbanish systemd user service

**Fayl:** [systemd/xbanish.service](systemd/xbanish.service)

xbanish va `xset r rate` buyruqlari login bo'lganda **systemd user service** sifatida avtomatik ishga tushadi. `.xprofile` dan farqli o'laroq, service `Restart=on-failure` bilan ishonchli ishlaydi.

### Qo'lda o'rnatish

```bash
# 1. Eski system serviceni o'chiring (agar mavjud bo'lsa)
sudo systemctl stop xbanish.service
sudo systemctl disable xbanish.service
sudo rm /etc/systemd/system/xbanish.service

# 2. User service yarating (yoki symlink orqali ulanadi)
mkdir -p ~/.config/systemd/user/
# install.sh symlink ni avtomatik yaratadi:
# ~/.config/systemd/user/xbanish.service -> dotfiles/systemd/xbanish.service

# 3. Yoqing va ishga tushiring
systemctl --user daemon-reload
systemctl --user enable xbanish.service
systemctl --user start xbanish.service
systemctl --user status xbanish.service --no-pager
```

### Foydali buyruqlar

| Buyruq | Tavsif |
|--------|--------|
| `systemctl --user status xbanish.service` | Holat ko'rish |
| `systemctl --user restart xbanish.service` | Qayta ishga tushirish |
| `systemctl --user stop xbanish.service` | To'xtatish |
| `journalctl --user -u xbanish.service` | Loglarni ko'rish |

---

## Font: getnf

JetBrainsMono Nerd Font o'rnatish uchun [getnf](https://github.com/getnf/getnf) ishlatiladi.

```bash
# Qo'lda o'rnatish
curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash
getnf -i JetBrainsMono
```

---

## Struktura

```
dotfiles/
├── install.sh                    ← Asosiy o'rnatish skripti
├── README.md                     ← Shu hujjat
├── systemd/
│   └── xbanish.service           ← xbanish user service (systemd)
├── zsh/
│   └── .zshrc                    ← Zsh konfiguratsiyasi
├── tmux/
│   ├── .tmux.conf                ← Tmux konfiguratsiyasi
│   └── scripts/
│       └── _tmux_duplicate_pane  ← Prefix+U skripti
├── kitty/
│   └── kitty.conf                ← Kitty terminal konfiguratsiyasi
└── vim/
    └── .vimrc                    ← Vim konfiguratsiyasi
```

---

## Yangilash

Config faylini o'zgartirganingizdan so'ng symlink tufayli o'zgarishlar darhol kuchga kiradi. Faqat tmux uchun qayta yuklash kerak:

```bash
# Tmux ichida
Prefix + r

# Yoki terminaldan
tmux source ~/.tmux.conf
```

## Zsh'ni qayta yuklash

```bash
source ~/.zshrc
# yoki
exec zsh
```
