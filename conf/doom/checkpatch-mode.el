;;; checkpatch-mode.el --- Support for checkpatch
;;
;; Copyright (C) 2014-21 Alex Bennée

;; Author: Alex Bennée <alex.bennee@linaro.org>
;; Maintainer: Alex Bennée <alex.bennee@linaro.org>
;; Version: 0.1
;; Homepage: http://github.com/stsquad/checkpatch-mode
;; Package-Requires: ((emacs "24.3"))


;; This file is not part of GNU Emacs.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;
;;; Commentary:
;;
;; This provides a simple compile-mode derived mode for checkpatch output.
;;
;;; Code:

;; Require prerequisites

(require 'compile) ; for compilation-mode
(require 'rx) ; for regex

;; Variables

;; Match checkpatch.pl output
(defvar checkpatch-mode-regex
  '(checkpatch
    "\\(WARNING\\|ERROR\\).*\n#.*FILE: \\([^:]+\\):\\([^:digit:]+\\).*\n.*"
    2 ; file
    3 ; line
    )
  "A regular expressions for `compilation-error-regexp-alist-alist'")

(defvar checkpatch-mode-magit-rebase-match-re
  (rx (: bol
         (one-or-more letter) ; rebase action
         " "
         (group (>= 7 hex))            ; commitish
         " "
         (one-or-more nonl))) ; summary
  "Regexp to match summary lines in rebase summary.")

(defvar checkpatch-script-path
  nil
  "Path to the default checkpatch script.")
(make-variable-buffer-local 'checkpatch-script-path)
(put 'checkpatch-script-path 'permanent-local t)

(defvar checkpatch-result
  nil
  "Result of last checkpatch call.")
(make-variable-buffer-local 'checkpatch-result)
(put 'checkpatch-result 'permanent-local t)


;; Helpers

(defun checkpatch-mode-update-error-regexp ()
  "Make sure the error regexp is upto date."
  (add-to-list
   'compilation-error-regexp-alist-alist checkpatch-mode-regex)
  (add-to-list 'compilation-error-regexp-alist 'checkpatch))

(defun checkpatch-mode-done(&optional arg)
  "Bury or destroy the checkpatch buffer.
By default buffers for failed checkpatch runs (non-zero results) are
  only buried although this can be forced with the prefix."
  (interactive "p")
  (when (eq major-mode 'checkpatch-mode)
    (if (or (eq checkpatch-result 0) arg)
        (kill-buffer)
      (bury-buffer))))

;;; Mode magic
(defvar checkpatch-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "q") 'checkpatch-mode-done)
    (define-key map (kbd "C-c C-c") 'checkpatch-mode-done)
    map)
  "Keymap for major mode `checkpatch-mode'.")

;; Helper
(defun checkpatch--prepare-buffer (buffer)
  "Switch to and prepare buffer for running."
  (switch-to-buffer buffer)
  (goto-char (point-min))
  (erase-buffer))

;; Launch functions
(defun checkpatch-run (script file &optional file-is-patch)
  "Run the checkpatch `SCRIPT' against `FILE'."
  (interactive)
  (let ((proc-name "checkpatch")
        (buff-name (format "*checkpatch-%s*" (file-name-base file))))
    (checkpatch--prepare-buffer buff-name)
    (setq checkpatch-result
          (if file-is-patch
              (call-process script nil t t file)
            (call-process script nil t t "-f" file)))
    (checkpatch-mode)))

(defun checkpatch-run-against-commit (script commit &optional result-only)
  "Run the checkpatch `SCRIPT' against `COMMIT'.

Returns the result of running checkpatch. If `RESULT-ONLY' is true
then don't keep the buffer results of the run."
  (let ((proc-name "checkpatch")
        (buff-name (format "checkpatch-%s" commit)))
    (unless result-only
      (checkpatch--prepare-buffer buff-name))
    (setq checkpatch-result
          (call-process-shell-command
           (format "git show --patch-with-stat %s | %s -" commit script)
           nil (if result-only nil buff-name) t))
    (unless result-only
      (checkpatch-mode))
    checkpatch-result))

(defun checkpatch-find-script ()
  "Find checkpatch script or return nil if we can't find it."
  (cond
   ;; Is checkpatch-script-path already set and correct?
   ((and checkpatch-script-path
         (file-exists-p checkpatch-script-path))
    checkpatch-script-path)
   ;; Can we find it in relation to current buffer-file-name?
   ((and buffer-file-name
         (locate-dominating-file
          (buffer-file-name) "scripts/checkpatch.pl"))
    (concat (locate-dominating-file
             (buffer-file-name) "scripts/checkpatch.pl")
            "scripts/checkpatch.pl"))
   ;; What about w.r.t default-directory
   ((and default-directory
         (locate-dominating-file
          default-directory "scripts/checkpatch.pl"))
    (concat (locate-dominating-file
             default-directory "scripts/checkpatch.pl")
            "scripts/checkpatch.pl"))
   (t nil)))

(defun checkpatch-find-script-or-prompt ()
  "Find checkpatch script or prompt the user if not found."
  (interactive)
  (let ((script (checkpatch-find-script)))
    (unless script
      (setq script
            (ido-read-file-name
              "Checkpatch Script: " default-directory)))
    (setq checkpatch-script-path script)))

(defun checkpatch-run-against-patch-file (patch-file)
  "Run checkpatch against `PATCH-FILE'."
  (interactive)
  (let ((script (checkpatch-find-script-or-prompt)))
    (checkpatch-run script patch-file t)))

(defun checkpatch-run-against-file (&optional file)
  "Run checkpatch against `FILE'.
If `FILE' is not set assume it is the file of the current buffer."
  (interactive)
  (let ((script (checkpatch-find-script-or-prompt)))
    (if (not file)
        (setq file (buffer-file-name)))
    (checkpatch-run script file)))

;; Run from inside magit
(defun checkpatch-run-from-magit ()
  "Run a checkpatch script against current magit commit."
  (interactive)
  (let ((commit (magit-commit-at-point)))
    (when (and commit
               (checkpatch-find-script-or-prompt))
      (checkpatch-run-against-commit checkpatch-script-path commit))))

(defun checkpatch-mark-failed-rebase-commits-for-editing ()
  "Set any commits in the re-base buffer to edit if checkpatch fails."
  (interactive)
  (when (checkpatch-find-script-or-prompt)
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward
              checkpatch-mode-magit-rebase-match-re
              (point-max) t)
        (let ((commit (match-string-no-properties 1)))
          (when (not (eq 0 (checkpatch-run-against-commit
                            checkpatch-script-path commit t)))
            (git-rebase-edit)))))))


(defun checkpatch-magit-hook ()
  "Hook checkpatch commands into magit.

This is intended to be run from various magit-mode hooks and will add
a keybinding to the local magit to call checkpatch if the script is
found."
  (when (and (checkpatch-find-script)
             (derived-mode-p 'magit-log-mode))
    (local-set-key (kbd "C") 'checkpatch-run-from-magit)))

(eval-after-load 'magit
  (add-hook 'magit-log-mode-hook 'checkpatch-magit-hook))


;; Define the mode
;;###autoload
(define-derived-mode checkpatch-mode compilation-mode "CHKPTCH"
  "A simple mode for the results of checkpatch scripts .

\{checkpatch-mode-map}"
  :lighter " CHKPTCH"
  (checkpatch-mode-update-error-regexp)
  (message "in derived mode"))

(provide 'checkpatch-mode)
;;; checkpatch-mode.el ends here
