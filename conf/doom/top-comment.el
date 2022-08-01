;;; ~/.doom.d/top-comment.el -*- lexical-binding: t; -*-

(defun ms-insert-top-comment ()
  (interactive)
  (save-excursion
    (evil-goto-first-line)
    (if (string= (string-trim (thing-at-point 'line t)) "/** :ms-top-comment")
        (progn
          (kill-region (point) (ms-top-comment-find " **/"))
          (kill-whole-line)))
    ; remove top comment if present
    (if (string= (string-trim (thing-at-point 'line t)) "/*")
        (progn
          (kill-region (point) (search-forward "*/"))))
    (insert "/** :ms-top-comment")
    (newline)
    (let ((dir (locate-dominating-file (buffer-file-name) "TOP_COMMENT"))
            (buffer (current-buffer))
            (start (point)))
        (newline)
        (insert " **/")
        (newline)
        (previous-line 2)
        (insert-file-contents (concat dir "TOP_COMMENT"))
        (search-forward " **/")
        (previous-line)
        ; remove newline which always appears at the end of file
        (if (string-match (string-trim (thing-at-point 'line t)) "")
          (progn
            (kill-whole-line)
            (previous-line)))
        (string-insert-rectangle start (point) " * ")
        ; remove any empty lines after the closing line
        (next-line 2)
        (while (string= "" (string-trim (thing-at-point 'line t))) (kill-whole-line))
        (ms-fixup-top-comment))))

(defun ms-top-comment-find (what)
  (evil-goto-first-line)
  (search-forward what)
  (point))

(defun ms-fixup-top-comment ()
  (interactive)
  (evil-goto-first-line)
  (if (string= (thing-at-point 'line t) "/** :ms-top-comment")
      (next-line)
      (let ((start (point))
            (dir (locate-dominating-file (buffer-file-name) "TOP_COMMENT"))
            (ver (string-trim (shell-command-to-string "git tag --points-at HEAD")))
            (user (string-trim (shell-command-to-string "git config user.name")))
            (end (ms-top-comment-find " **/")))
        (ignore-errors (progn
                (goto-char start)
                (search-forward "[FILE]")
                (search-backward "[FILE]")
                (kill-line)
                (insert (replace-regexp-in-string dir "" (buffer-file-name)))))
        (ignore-errors (progn
                (goto-char start)
                (search-forward "[DATE]")
                (search-backward "[DATE]")
                (kill-line)
                (insert (format-time-string "%Y-%m-%d"))))
        (progn (goto-char start) (search-forward "[AUTHOR]") (search-backward "[AUTHOR]") (kill-line))
        (insert user)
        (progn (goto-char start) (search-forward "[COPY_YEAR]") (search-backward "[COPY_YEAR]") (kill-sexp))
        (insert (format-time-string "%Y"))
        (progn (goto-char start) (re-search-forward "[VERSION]") (search-forward "[VERSION]") (kill-line))
        (if (string= ver "")
          (insert "Not tagged")
          (insert ver))

        ())))
