;;; ~/.doom.d/refactor.el -*- lexical-binding: t; -*-

;; Refactor register assignments
;; From: OC3CON = 0x1234;
;; To: __write16(OC3CON, 0x1234);
(defun refactor-reg16-assignment ()
    (interactive)
    (evil-first-non-blank)
    (insert "__write16(")
    (search-forward "=")
    (delete-backward-char 2)
    (insert ",")
    (search-forward ";")
    (backward-char 1)
    (insert ")")
)

;; Refactor individual bit assignments
;; Place cursor on the line to refactor and run this macro
;; It will automatically search for next line to refactor.
;; From: OC3CONbits.OCM = 0b000;
;; To: __write_bit(__bit(OC3CON, OCM), 0b000);
(defun refactor-long-bit-assignment ()
    (interactive)
    (evil-first-non-blank)
    (insert "__write_bit(__bit(")
    (search-forward "bits.")
    (delete-backward-char 5)
    (insert ", ")
    (search-forward "=")
    (delete-backward-char 2)
    (insert "),")
    (search-forward ";")
    (backward-char 1)
    (insert ")")
    (search-forward "bits.")
)

;; This macro sorts an enum
;; Place cursor inside enum and run it
(defun refactor-sort-enum ()
  (interactive)
  (save-excursion
    (search-backward "enum")
    (search-forward "{")
    (next-line)
    (beginning-of-line)
    (let ((start (point)))
      (search-forward "}")
      ;; go up one line and to the end
      (previous-line)
      (end-of-line)
      ;; we need to insert a comma here because we don't know where the line will end up
      (insert ",")
      (let ((end (point)))
        (shell-command-on-region-replace start end "sort | uniq")))))

(defun refactor-enum-element-to-indexed-name ()
  (interactive)
  (save-excursion
    (back-to-indentation)
    (let ((start (point)))
      (search-forward ",")
      (backward-char)
      (let ((end (point)))
        (back-to-indentation)
        (insert (concat "[" (buffer-substring start end) "] = \""))
        (end-of-line)
        (search-backward ",")
        (insert "\"")
        )))
  (next-line))

(defun refactor-bit-def ()
  (interactive)
  (back-to-indentation)
  (search-forward "\"")
  (backward-char)
  (insert "{ .name = ")
  (search-forward "\"")
  (let ((start (point)))
    (search-forward "_")
    (backward-char)
    (let ((end (point)))
      (search-forward ",")
      (backward-char)
      (insert (concat ", .num = 0, .reg = " (buffer-substring start end) "}"))
      (forward-line))))

(defun refactor-find-bit-value (reg_name bit_name)
  (with-temp-buffer
    (insert-file-contents "/opt/microchip/xc16/v1.36/support/PIC24H/inc/p24HJ256GP610A.inc")
    (search-forward (concat reg_name " Bits --"))
    (search-forward (concat bit_name ","))
    (search-forward "0x")
    (backward-char 2)
    (let ((start (point)))
      (end-of-line)
      (buffer-substring start (point)))))

(defun refactor-reg-bit-pair-get-reg ()
  (let ((start (point)))
    (search-forward "_")
    (backward-char 1)
    (buffer-substring start (point))))

(defun refactor-reg-bit-pair-get-bit (end_str)
  (search-forward "_BIT_")
      (let ((start (point)))
        (search-forward end_str)
        (backward-char (length end_str))
        (buffer-substring start (point))))

(defun refactor-bit-find-position ()
  (interactive)
  ; find .reg = <reg> string
  (beginning-of-line)
  (search-forward "[")
  (let ((reg_name (refactor-reg-bit-pair-get-reg))
        (bit_name (refactor-reg-bit-pair-get-bit "]")))
    (let ((bit_num (refactor-find-bit-value reg_name bit_name)))
      (beginning-of-line)
      (search-forward ".num = ")
      (delete-forward-char 6)
      (insert bit_num)
      (next-line))))

(defun refactor-bit-bit-exists ()
  (interactive)

  (back-to-indentation)
  (let ((reg_name (refactor-reg-bit-pair-get-reg))
        (bit_name (refactor-reg-bit-pair-get-bit ",")))
    (refactor-find-bit-value reg_name bit_name)
    (next-line)))
