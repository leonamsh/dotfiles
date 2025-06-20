;;; tools/docker/config.el -*- lexical-binding: t; -*-

(after! dockerfile-mode
  (set-docsets! 'dockerfile-mode "Docker")
  (set-formatter! 'dockfmt '("dockfmt" "fmt" filepath) :modes '(dockerfile-mode))

  (when (modulep! +lsp)
    (add-hook 'dockerfile-mode-local-vars-hook #'lsp! 'append)))
