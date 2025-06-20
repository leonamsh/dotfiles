;;; lang/java/autoload/java.el -*- lexical-binding: t; -*-

;; yasnippet defuns
;;;###autoload
(defun +java-android-mode-is-layout-file ()
  (and android-mode
       (eq major-mode 'nxml-mode)
       (string-equal (file-name-base (directory-file-name default-directory)) "layout")))

;;;###autoload
(defun +java-android-mode-in-tags (&rest tags)
  (cl-find (android-mode-tag-name) tags))

;;;###autoload
(defun +java-android-mode-tag-name ()
  (save-excursion
    (let (beg end)
      (nxml-backward-up-element)
      (evil-forward-word-begin)
      (setq beg (point))
      (evil-forward-WORD-end)
      (setq end (1+ (point)))
      (buffer-substring-no-properties beg end))))

;;;###autoload
(defun +java-android-mode-maybe-h ()
  "Enable `android-mode' if this looks like an android project.

It determines this by the existence of AndroidManifest.xml or
src/main/AndroidManifest.xml."
  (when (project-file-exists-p! (or "AndroidManifest.xml"
                                    "src/main/AndroidManifest.xml"))
    (android-mode +1)))

;;;###autoload
(defun +java-current-package ()
  "Converts the current file's path into a namespace.

For example: ~/some/project/src/net/lissner/game/MyClass.java
Is converted to: net.lissner.game

It does this by ignoring everything before the nearest package root (see
`+java-project-package-roots' to control what this function considers a package
root)."
  (cond ((doom-special-buffer-p (current-buffer))
         "{PackageName}")
        ((and (not (eq major-mode 'java-mode))
              (not (eq major-mode 'java-ts-mode))
              (user-error "Not in java-mode or java-ts-mode")))
        ((when-let (project-root (doom-project-root))
           (let* ((project-root (file-truename project-root))
                  (file-path
                   (file-name-sans-extension
                    (file-truename (or buffer-file-name
                                       default-directory))))
                  (src-root
                   (cl-loop for root in +java-project-package-roots
                            if (and (stringp root)
                                    (locate-dominating-file file-path root))
                            return (file-name-directory (file-relative-name file-path (expand-file-name root it)))
                            if (and (integerp root)
                                    (> root 0)
                                    (let* ((parts (split-string (file-relative-name file-path project-root) "/"))
                                           (fixed-parts (reverse (nbutlast (reverse parts) root))))
                                      (when fixed-parts
                                        (string-join fixed-parts "/"))))
                            return it)))
             (when src-root
               (string-remove-suffix "." (replace-regexp-in-string "/" "." src-root))))))
        ((user-error "Can't deduce package name"))))

;;;###autoload
(defun +java-current-class ()
  "Get the class name for the current file."
  (cond ((doom-special-buffer-p (current-buffer))
         "{ClassName}")
        ((and (not (eq major-mode 'java-mode))
              (not (eq major-mode 'java-ts-mode))
              (user-error "Not in java-mode or java-ts-mode")))
        (buffer-file-name
         (file-name-sans-extension (file-name-base (buffer-file-name))))
        ((user-error "Can't deduce the class name"))))

;;;###autoload
(defun +java/open-groovy-repl ()
  "Open a Groovy REPL."
  (interactive)
  (call-interactively #'run-groovy)
  (get-buffer groovy-buffer))
