;;; ~/.doom.d/gtts.el -*- lexical-binding: t; -*-


(defun gtts-speak-se (txt)
  "Speak supplied text in swedish"
  (interactive "sText: ")
  (start-process-shell-command "sound" nil (format "echo %s | gtts-cli -l sv -f - | mpg123 -" (shell-quote-argument txt))))

(defun gtts-speak-en (txt)
  "Speak supplied text in english"
  (interactive "sText: ")
  (start-process-shell-command "sound" nil (format "echo %s | gtts-cli -l en -f - | mpg123 -" (shell-quote-argument txt))))

(defun gtts-speak-paragraph-se ()
  "Speak current paragraph"
  (interactive)
  (funcall 'gtts-speak-se (thing-at-point 'paragraph))
)

(defun gtts-speak-paragraph-en ()
  "Speak current paragraph"
  (interactive)
  (funcall 'gtts-speak-en (thing-at-point 'paragraph))
)

(defun gtts-speak-line-se ()
  "Speak current sentence in swedish"
  (interactive)
  (funcall 'gtts-speak-se (thing-at-point 'line t))
)

(defun gtts-speak-line-en ()
  "Speak current sentence in english"
  (interactive)
  (funcall 'gtts-speak-en (thing-at-point 'line t))
)
