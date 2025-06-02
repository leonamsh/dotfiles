;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; ========================
;; CONFIGURAÇÕES BÁSICAS
;; ========================
;; Fontes
(setq doom-font (font-spec :family "Space Mono" :size 18)
      doom-variable-pitch-font (font-spec :family "Space Mono" :size 18)
      doom-theme 'doom-one
      display-line-numbers-type t)

;; Set UTF-8 as the default encoding system
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)
(setq-default buffer-file-coding-system 'utf-8)
(setq-default save-buffer-coding-system 'utf-8) ; Prevents prompt on save

;; Additional environment settings
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)

;; Clipboard
(use-package! simpleclip
  :config (simpleclip-mode 1))

;; ========================
;; CONFIGURAÇÕES LSP/IDE
;; ========================
(after! lsp-mode
  ;; Configurações gerais do LSP
  (setq lsp-enable-on-type-formatting t
        lsp-enable-indentation t
        lsp-headerline-breadcrumb-enable nil) ; Desabilita breadcrumb (opcional)

  ;; Configurações específicas para Go
  (setq lsp-go-use-gofumpt t
        lsp-go-analyses '((fieldalignment . t)
                         (nilness . t)
                         (shadow . t)
                         (unusedparams . t)
                         (unusedwrite . t)
                         (useany . t)
                         (unusedvariable . t))))

;; Hooks para ativação automática do LSP
(dolist (mode '(js-mode typescript-mode web-mode css-mode sql-mode dockerfile-mode))
  (add-hook (intern (concat (symbol-name mode) "-hook")) #'lsp-deferred))

;; Configuração específica para Go
(add-hook! 'go-mode-hook
  (add-hook 'before-save-hook #'lsp-organize-imports nil t))

;; ========================
;; CONFIGURAÇÕES DE LINGUAGEM
;; ========================
;; JavaScript/TypeScript/React
(setq js-indent-level 2
      typescript-indent-level 2)

;; Web Mode (HTML/CSS/JSX)
(use-package! web-mode
  :mode ("\\.html?\\'" "\\.tsx\\'" "\\.jsx\\'" "\\.css\\'")
  :config
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2))

;; Formatação com Prettier via Apheleia
(use-package! apheleia
  :config
  (apheleia-global-mode +1)
  (setf (alist-get 'prettier apheleia-formatters)
        '(npx "prettier" "--print-width=100" "--single-quote" "true" file))
  (dolist (mode '(web-mode css-mode json-mode))
    (add-to-list 'apheleia-mode-alist `(,mode . prettier))))

;; ESlint (se disponível)
(when (executable-find "eslint_d")
  (add-hook! (js-mode typescript-mode) (eslintd-fix-mode)))

;; ========================
;; PACOTES ADICIONAIS
;; ========================
(use-package! move-text
  :config (move-text-default-bindings))

(use-package! all-the-icons
  :if (display-graphic-p))

(use-package! all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

;; Docker
(use-package! dockerfile-mode
  :mode "Dockerfile\\'")

;; SQL
(use-package! sql-indent
  :hook (sql-mode . sqlind-minor-mode))

;; ========================
;; ATALHOS SIMPLIFICADOS
;; ========================
(map! :leader
;;       (:prefix "d"
;;        "d" #'dired
;;        "j" #'dired-jump
;;        "p" #'peep-dired)

;;       (:prefix "f"
;;        "." #'find-file
;;        "r" #'recentf-open-files)

      (:prefix "t"
       "n" #'neotree-toggle
       "t" #'vterm-toggle))
