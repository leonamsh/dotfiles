;; -*- no-byte-compile: t; -*-
;;; editor/fold/packages.el

(package! hideshow :built-in t)

(package! vimish-fold :pin "a6501cbfe3db791f9ca17fd986c7202a87f3adb8")
(when (modulep! :editor evil)
  (package! evil-vimish-fold :pin "b6e0e6b91b8cd047e80debef1a536d9d49eef31a"))
(when (modulep! :tools tree-sitter)
  (package! ts-fold :pin "6eed69cf2b97dce9c6ad329710ed42f0ad674f76"
    :recipe (:host github :repo "emacs-tree-sitter/ts-fold")))
