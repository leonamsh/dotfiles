;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-font (font-spec :family "Terminess Nerd Font Mono" :size 19)
      doom-variable-pitch-font (font-spec :family "Terminess Nerd Font Mono" :size 19))

(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; (setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; source: https://nayak.io/posts/golang-development-doom-emacs/
;; golang formatting set up
;; use gofumpt
;;
;; (after! org
;;   Configurações de inicialização
;;   (setq org-startup-folded 'content
;;         org-startup-indented t
;;         org-startup-with-inline-images t
;;         org-hide-emphasis-markers t))

;; Atalho personalizado para recarregar
;; (map! :leader :prefix "h" :desc "Reload Org" "r o" #'org-mode-restart)
;;
(after! lsp-mode
  (setq  lsp-go-use-gofumpt t)
  )

;; gotta make emacs realod init.el every start. idk how to do it thou D:
;; (load! "~/.config/doom/init.el")
;; automatically organize imports
(add-hook 'go-mode-hook #'lsp-deferred)
;; Make sure you don't have other goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; enable all analyzers; not done by default
(after! lsp-mode
  (setq  lsp-go-analyses '((fieldalignment . t)
                           (nilness . t)
                           (shadow . t)
                           (unusedparams . t)
                           (unusedwrite . t)
                           (useany . t)
                           (unusedvariable . t)))
  )
;; use system clipboard
;; (require 'pbcopy)
;; (turn-on-pbcopy)
;;Forçar UTF-8 em todo o fluxo de codificação.
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8-unix)
(prefer-coding-system 'utf-8-unix)
(setq locale-coding-system 'utf-8-unix)
(set-terminal-coding-system 'utf-8-unix)
(set-keyboard-coding-system 'utf-8-unix)
(set-selection-coding-system 'utf-8-unix)
(setq-default buffer-file-coding-system 'utf-8-unix)
(setq buffer-file-coding-system 'utf-8-unix)
;;
(require 'simpleclip)
(simpleclip-mode 1)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; Keybindings com map!
;;
(map! :leader
      :desc "Counsel M-x" "SPC" #'counsel-M-x
      :desc "Find file" "." #'find-file
      :desc "Perspective" "=" #'perspective-map
      :desc "Comment lines" "TAB TAB" #'comment-line
      :desc "Universal argument" "u" #'universal-argument)

;; Dired bindings
(map! :leader
      :prefix "d"
      :desc "Open maisPraTi folder" "A" (lambda () (interactive) (neotree-dir "~/Documentos/git/maisPraTi/"))
      :desc "Open dired" "d" #'dired
      :desc "Open doom folder" "D" (lambda () (interactive) (neotree-dir "~/.config/doom/"))
      :desc "Open dired" "f" #'+neotree/find-this-file
      :desc "Dired jump" "j" #'dired-jump
      :desc "Open neotree" "n" #'neotree-dir
      :desc "Peep-dired" "p" #'peep-dired
      :desc "Open teste producao" "P" (lambda () (interactive) (dired "i:/Teste_Producao/")))

;; File bindings
(map! :leader
      :prefix "f"
      :desc "Open alacritty config" "a" (lambda () (interactive) (find-file "~/.config/alacritty/alacritty.toml"))
      :desc "Open emacs config" "c" (lambda () (interactive) (find-file "~/.config/doom/config.el"))
      :desc "Open user-emacs-directory" "e" (lambda () (interactive) (dired "~/.config/doom/custom.el"))
      :desc "Search current file" "g" #'counsel-grep-or-swiper
      :desc "Open hyprland config" "h" (lambda () (interactive) (find-file "~/.config/hypr/hyprland.conf"))
      :desc "Open init.el" "i" (lambda () (interactive) (find-file "~/.config/doom/init.el"))
      :desc "Jump to file" "j" #'counsel-file-jump
      :desc "Open kitty config" "k" (lambda () (interactive) (find-file "~/.config/kitty/kitty.conf"))
      :desc "Open qtile config" "q" (lambda () (interactive) (find-file "~/.config/qtile/config.py"))
      :desc "Open hyprland config" "t" (lambda () (interactive) (neotree-dir "~/Documentos/git/")))

;; Org bindings
(map! :leader
      :prefix "m"
      :desc "move line up" "u" #'move-line-up
      :desc "move line down" "U" #'move-line-down
      :desc "duplicate line" "D" #'duplicate-dwim)

;; Projectile bindings
(map! :leader
      :desc "Projectile" "p" #'projectile-command-map)

;; Toggle bindings
(map! :leader
      :prefix "t"
      :desc "Toggle neotree" "n" #'neotree-toggle
      :desc "open projects" "N" #'treemacs-projectile
      :desc "Toggle vterm" "t" #'vterm-toggle
      :desc "Package install" "p" #'package-install)


(use-package move-text
  :ensure t
  :config
  (move-text-default-bindings))

(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

(use-package all-the-icons-dired
  :hook (dired-mode . (lambda () (all-the-icons-dired-mode t))))

;; Configuração unificada para JS
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;; Hooks para funcionalidades extras (modos menores/detalhes)
(add-hook 'js2-mode-hook
          (lambda ()
            (js2-highlight-vars-mode)
            (js2hl-mode)
            (flycheck-mode)
            (prettier-js-mode)))

;; Configurações diretas (sem conflitos)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

(use-package apheleia
  ;; :ensure t
  ;; :straight (apheleia :host github :repo "raxod502/apheleia")
  :config
  (setf (alist-get 'prettier apheleia-formatters)
        '(npx "prettier"
          "--trailing-comma"  "es5"
          "--bracket-spacing" "true"
          "--single-quote"    "true"
          "--semi"            "false"
          "--print-width"     "100"
          file))
  (add-to-list 'apheleia-mode-alist '(rjsx-mode . prettier))
  (apheleia-global-mode t))
