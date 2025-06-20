;;; lang/beancount/autoload/beancount.el -*- lexical-binding: t; -*-

;;
;;; Helpers

;; Lifted from ledger-mode
(defconst +beancount--payee-any-status-regex
  "^[0-9]+[-/][-/.=0-9]+\\(\\s-+\\*\\)?\\(\\s-+(.*?)\\)?\\s-+\\(.+?\\)\\s-*\\(;\\|$\\)")

(defun +beancount--sort-startkey ()
  "Return the actual date so the sort subroutine doesn't sort on the entire first line."
  (buffer-substring-no-properties (point) (+ 10 (point))))

(defun +beancount--navigate-next-xact ()
  "Move point to beginning of next xact."
  ;; make sure we actually move to the next xact, even if we are the beginning
  ;; of one now.
  (if (looking-at +beancount--payee-any-status-regex)
      (forward-line))
  (if (re-search-forward  +beancount--payee-any-status-regex nil t)
      (goto-char (match-beginning 0))
    (goto-char (point-max))))

(defun +beancount--navigate-start-xact-or-directive-p ()
  "Return t if at the beginning of an empty or all-whitespace line."
  (not (looking-at "[ \t]\\|\\(^$\\)")))

(defun +beancount--navigate-next-xact-or-directive ()
  "Move to the beginning of the next xact or directive."
  (interactive)
  (beginning-of-line)
  (if (+beancount--navigate-start-xact-or-directive-p) ; if we are the start of an xact, move forward to the next xact
      (progn
        (forward-line)
        (if (not (+beancount--navigate-start-xact-or-directive-p)) ; we have moved forward and are not at another xact, recurse forward
            (+beancount--navigate-next-xact-or-directive)))
    (while (not (or (eobp)  ; we didn't start off at the beginning of an xact
                    (+beancount--navigate-start-xact-or-directive-p)))
      (forward-line))))

(defun +beancount--navigate-next-xact ()
  "Move point to beginning of next xact."
  ;; make sure we actually move to the next xact, even if we are the
  ;; beginning of one now.
  (if (looking-at +beancount--payee-any-status-regex)
      (forward-line))
  (if (re-search-forward  +beancount--payee-any-status-regex nil t)
      (goto-char (match-beginning 0))
    (goto-char (point-max))))

(defun +beancount--navigate-beginning-of-xact ()
  "Move point to the beginning of the current xact."
  ;; need to start at the beginning of a line in case we are in the first line of an xact already.
  (beginning-of-line)
  (let ((sreg (concat "^[=~[:digit:]]")))
    (unless (looking-at sreg)
      (re-search-backward sreg nil t)
      (beginning-of-line)))
  (point))

(defun +beancount--navigate-end-of-xact ()
  "Move point to end of xact."
  (+beancount--navigate-next-xact-or-directive)
  (re-search-backward ".$")
  (end-of-line)
  (point))


;;
;;; Commands

;;;###autoload
(defun +beancount/sort-buffer (&optional reverse)
  "Sort all transactions in the buffer.
If REVERSE (the prefix arg) is non-nil, sort them in reverse."
  (interactive "P")
  (+beancount/sort-region (point-min) (point-max) reverse))

;;;###autoload
(defun +beancount/sort-region (beg end &optional reverse)
  "Sort the transactions inside BEG and END.
If REVERSE (the prefix arg) is non-nil, sort the transactions in reverst order."
  (interactive
   (list (region-beginning)
         (region-end)
         (and current-prefix-arg t)))
  (let* ((new-beg beg)
         (new-end end)
         (bounds (save-excursion
                   (list (+beancount--navigate-beginning-of-xact)
                         (+beancount--navigate-end-of-xact))))
         (point-delta (- (point) (car bounds)))
         (target-xact (buffer-substring (car bounds) (cadr bounds)))
         (inhibit-modification-hooks t))
    (save-excursion
      (save-restriction
        (goto-char beg)
        ;; make sure beg of region is at the beginning of a line
        (beginning-of-line)
        ;; make sure point is at the beginning of a xact
        (unless (looking-at +beancount--payee-any-status-regex)
          (+beancount--navigate-next-xact))
        (setq new-beg (point))
        (goto-char end)
        (+beancount--navigate-next-xact)
        ;; make sure end of region is at the beginning of next record after the
        ;; region
        (setq new-end (point))
        (narrow-to-region new-beg new-end)
        (goto-char new-beg)
        (let ((inhibit-field-text-motion t))
          (sort-subr
           reverse
           #'+beancount--navigate-next-xact
           #'+beancount--navigate-end-of-xact
           #'+beancount--sort-startkey))))
    (goto-char (point-min))
    (re-search-forward (regexp-quote target-xact))
    (goto-char (+ (match-beginning 0) point-delta))))

(defvar compilation-read-command)
;;;###autoload
(defun +beancount/balance (&optional all-accounts)
  "Display a balance report with bean-report (bean-report bal)."
  (interactive "P")
  (let (compilation-read-command
        current-prefix-arg)
    (beancount--run "bean-query"
                    buffer-file-name
                    (format (concat "SELECT account, sum(position) as balance %s "
                                    "GROUP BY account "
                                    "HAVING not empty(sum(position)) "
                                    "ORDER BY account")
                            (if all-accounts
                                "" (format "WHERE account ~ \"^(Assets|Liabilities)\"" ))))))

(defun +beancount-transaction-at-point ()
  (let ((transaction
         (buffer-substring-no-properties
          (save-excursion
            (beancount-goto-transaction-begin)
            (re-search-forward " " nil t)
            (match-beginning 0))
          (save-excursion
            (beancount-goto-transaction-end)
            (point)))))
    (goto-char (point-max))
    (delete-blank-lines)
    (beancount-insert-date)
    transaction))

;;;###autoload
(defun +beancount/clone-transaction (&optional arg)
  "Clones a transaction from this or included file after transaction at point.

Updates the date to today. If the prefix ARG is given, clones to the bottom of
the current ledger buffer instead."
  (interactive "P")
  (save-restriction
    (widen)
    (when-let*
        ((transaction
          (completing-read
           "Clone transaction: "
           (+beancount-completion-table beancount-transaction-regexp 0 'transactions #'string>)
           nil t)))
      (if-let* ((tr (gethash transaction (alist-get 'transactions +beancount--completion-cache))))
          (cl-destructuring-bind (&key file point) tr
            (if (not arg)
                (when (beancount-inside-transaction-p)
                  (beancount-goto-transaction-end))
              (goto-char (point-max))
              (when (save-excursion
                      (skip-chars-backward " \t" (pos-bol))
                      (not (bolp)))
                (insert "\n")))
            (save-excursion
              (beancount-insert-date)
              (insert
               (with-temp-buffer
                 (insert-file-contents file)
                 (goto-char point)
                 (+beancount-transaction-at-point)))))
        'none))))

;;;###autoload
(defun +beancount/clone-this-transaction (&optional arg)
  "Clones the transaction at point to the bottom of the ledger.

Updates the date to today."
  (interactive "P")
  (if (or arg (not (beancount-inside-transaction-p)))
      (call-interactively #'+beancount/clone-transaction)
    (save-restriction
      (widen)
      (insert (+beancount-transaction-at-point)))))

;;;###autoload
(defun +beancount/occur (account &optional disable?)
  "Hide transactions that don't involve ACCOUNT.

If DISABLE? (universal arg), reveal hidden accounts without prompting."
  (interactive
   (list (unless current-prefix-arg
           ;; REVIEW: Could/should this be generalized to search for arbitrary
           ;;   regexps, if desired?
           (completing-read "Account: " #'beancount-account-completion-table))
         current-prefix-arg))
  (with-silent-modifications
    (save-excursion
      (setq header-line-format nil)
      ;; TODO: Namespace these text-properties, in case of conflicts
      (remove-text-properties (point-min) (point-max) '(invisible nil display nil))
      (unless disable?
        ;; TODO: Prettier header-line display
        (setq header-line-format `("" "Filtering by account: " ,account))
        (let ((start (point-min))
              (placeholder (propertize "[...]\n" 'face 'shadow)))
          (goto-char start)
          (while (re-search-forward (concat "\\_<" (regexp-quote account) "\\_>") nil t)
            (save-excursion
              (seq-let (beg end) (beancount-find-transaction-extents (point))
                ;; TODO: Highlight entry (ala org-occur)
                (if (= beg end)
                    (setq end (save-excursion (goto-char end) (1+ (pos-eol)))))
                (put-text-property start beg 'invisible t)
                (put-text-property start beg 'display placeholder)
                (setq start end))))
          (put-text-property start (point-max) 'invisible t)
          (put-text-property start (point-max) 'display placeholder))))))

;;;###autoload
(defun +beancount/next-transaction (&optional count)
  "Jump to the start of the next COUNT-th transaction."
  (interactive "p")
  (let ((beancount-transaction-regexp
         ;; Don't skip over timestamped directives (like balance or event
         ;; declarations).
         (concat beancount-timestamped-directive-regexp
                 "\\|" beancount-transaction-regexp)))
    (dotimes (_ (or count 1))
      (beancount-goto-next-transaction))))

;;;###autoload
(defun +beancount/previous-transaction (&optional count)
  "Jump to the start of current or previous COUNT-th transaction.

Return non-nil if successful."
  (interactive "p")
  (let ((pos (point)))
    (condition-case e
        (progn
          ;; Ensures "jump to top of current transaction" behavior that is
          ;; common for jump-to-previous commands like this in other Emacs modes
          ;; (like org-mode).
          (or (bolp) (goto-char (pos-eol)))
          (re-search-backward
           (concat beancount-timestamped-directive-regexp
                   "\\|" beancount-transaction-regexp)))
      ('search-failed (goto-char pos) nil))))

;;; beancount.el ends here
