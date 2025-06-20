;; -*- lexical-binding: t; no-byte-compile: t; -*-
;;; lang/org/doctor.el

(when (modulep! +gnuplot)
  (unless (executable-find "gnuplot")
    (warn! "Couldn't find gnuplot. org-plot/gnuplot will not work")))

(when (modulep! +roam)
  (warn! "You are using org-roam-v1. This version is unmaintained Doom support for it will eventually be removed.\
Migrate your notes to org-roam-v2 and switch to the +roam2 flag (see the module readme).")
  (unless (executable-find "sqlite3")
    (warn! "Couldn't find the sqlite3 executable. org-roam will not work.")))
(when (or (modulep! +roam)
          (modulep! +roam2))
  (unless (executable-find "dot")
    (warn! "Couldn't find the dot executable (from graphviz). org-roam will not be able to generate graph visualizations.")))

(when (modulep! +dragndrop)
  (when (featurep :system 'macos)
    (unless (executable-find "pngpaste")
      (warn! "Couldn't find the pngpaste executable. org-download-clipboard will not work.")))
  (when (featurep :system 'linux)
    (unless (or (executable-find "maim") (executable-find "scrot") (executable-find "gnome-screenshot"))
      (warn! "Couldn't find the maim, scrot or gnome-screenshot executable. org-download-clipboard will not work."))
    (if (string= "wayland" (getenv "XDG_SESSION_TYPE"))
        (unless (executable-find "wl-paste")
          (warn! "Couldn't find the wl-paste executable (from wl-clipboard). org-download-clipboard will not work."))
      (unless (executable-find "xclip")
        (warn! "Couldn't find the xclip executable. org-download-clipboard will not work."))))
  (when (featurep :system 'windows)
    (unless (executable-find "convert")
      (warn! "Couldn't find the convert program (from ImageMagick). org-download-clipboard will not work."))))
