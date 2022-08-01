;;; ~/.doom.d/unit-test.el -*- lexical-binding: t; -*-

(defun gtest-extract-tests-as-org ()
  (interactive)
  (let ((pt (point))
        (file "/tmp/test.org"))
    (evil-goto-first-line)
    (write-region "* Firmware tests\n" nil file)
    (while (re-search-forward "TEST_F(\\([^,]+\\)[[:blank:],]*\\([^)]+\\)" nil t)
      (progn
        (previous-line)
        (let ((testname (match-string 1))
              (subtestname (match-string 2))
              (comment (thing-at-point 'line)))
          (if (string-match "^//.*" comment)
              (progn
                (write-region
                  (concat testname "::" subtestname "\n") nil file 'append)
                (write-region (concat (substring comment 3)) nil file 'append))))
        (next-line 2)))
    (goto-char pt)))
