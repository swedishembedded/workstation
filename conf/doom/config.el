; ~ /.doom.d / config.el - *-lexical - binding : t; - * -;
; Place your private configuration here

(load "~/.doom.d/folding.el")
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

(global-visual-line-mode t)
(add-hook 'text-mode-hook 'turn-on-auto-fill)

; disable flycheck globally
(flycheck-mode nil)

(fset 'b
   (kmacro-lambda-form [?^ ?l ?l ?i ?\C-? ?* ?  escape ?$ ?a ?  ?* ?/ escape] 0 "%d"))

(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

(set-face-attribute 'default nil :font "Terminus-8")

;; Disable flycheck for rst because sphinx-build deletes files
(setq flycheck-global-modes '(not rst-mode))

(setq user-mail-address "mkschreder.uk@gmail.com"
      user-full-name "Martin Schröder")

(setq gnus-select-method
      '(nnimap "gmail"
	       (nnimap-address "imap.googlemail.com")  ; it could also be imap.googlemail.com if that's your server.
	       (nnimap-server-port "imaps")
	       (nnimap-stream ssl)))

(after! evil
        ;; Folding http://www.emacswiki.org/emacs/FoldingMode
        ;; to enable call M-x folding-mode
        (if (load "folding" 'nomessage 'noerror)
                (folding-mode-add-find-file-hook))
        ;; (folding-add-to-marks-list 'python-mode "#{{{" "#}}}" nil t) ;example
        ;;(folding-add-to-marks-list 'ruby-mode "#{{{" "#}}}" nil t) ;example

        (define-key evil-normal-state-map "za" 'folding-toggle-show-hide)
        (define-key evil-normal-state-map "zR" 'folding-whole-buffer)
        (define-key evil-normal-state-map "zM" 'folding-open-buffer)
        (define-key evil-normal-state-map "zr" 'folding-hide-current-subtree)
        (define-key evil-normal-state-map "zm" 'folding-show-current-subtree)
        (define-key evil-normal-state-map "zo" 'folding-show-current-entry)
        (define-key evil-normal-state-map "zc" 'folding-hide-current-entry)
        (define-key evil-normal-state-map "zj" 'folding-next-visible-heading)
        (define-key evil-normal-state-map "zk" 'folding-previous-visible-heading)
        (folding-add-to-marks-list 'c-mode "/* <!-- " "/* --> " nil t)
        ;; (define-key evil-normal-state-map "zf" 'folding-fold-region)
        (define-key evil-normal-state-map "zf" 'folding-fold-region)

        ;(defun bss/folding-not-in-org ()
        ;"selective folding toggle by tab: skip org-mode"
        ;(interactive)
        ;(if (equal major-mode 'org-mode)
        ;        (org-cycle)
        ;        (folding-toggle-show-hide)
        ;        ))
        ;(define-key evil-normal-state-map (kbd "<tab>") 'bss/folding-not-in-org)

        ;(add-hook 'python-mode-hook (lambda () (folding-mode)))
        ;(add-hook 'prog-mode-hook (lambda () (folding-mode)))


  (evil-define-motion evil-next-error-motion (count)
 	"Go to next compilation error"
	(next-error))
  (evil-define-motion evil-prev-error-motion (count)
 	"Go to previous compilation error"
	(previous-error))
  ; disable the shit pish fuck mouse annoying fucking click to enter visual mode
  (define-key prog-mode-map [double-down-mouse-1] 'evil-jump-to-tag)
  (define-key evil-motion-state-map [down-mouse-1] nil)
  (define-key prog-mode-map [mouse-8] 'xref-pop-marker-stack)

  (define-key evil-motion-state-map "]e" 'evil-next-error-motion)
  (define-key evil-motion-state-map "[e" 'evil-prev-error-motion))

  (evil-define-key 'normal c-mode-map (kbd [tab]) #'hs-toggle-hiding)

  (evil-define-key 'normal doc-view-mode-map (kbd "k") 'doc-view-scroll-down-or-previous-page)
  (evil-define-key 'normal doc-view-mode-map (kbd "j") 'doc-view-scroll-up-or-next-page)

  (define-key evil-normal-state-map "zO" 'hs-show-all)
  (define-key evil-normal-state-map "zC" 'hs-hide-all)
  (define-key evil-normal-state-map "zc" 'hs-hide-block)
  (define-key evil-normal-state-map "zo" 'hs-show-block)
  (define-key evil-normal-state-map [escape] nil)

(define-key Buffer-menu-mode-map "k" 'evil-previous-line)
(define-key Buffer-menu-mode-map "j" 'evil-next-line)
(defun great-escape ()
  "Run `doom-escape-hook'."
  (interactive))

(global-set-key [escape] #'great-escape)

; custom settings for c mode
(defun c-mode-ms ()
    ; code folding
    (hs-minor-mode)
    (hs-hide-initial-comment-block)
	(turn-off-smartparens-mode)
    ; multiline commenting for C mode comment-region
    (setq comment-style 'multi-line))
(add-hook 'prog-mode-hook 'c-mode-ms)


(evil-define-key 'normal emacs-lisp-mode-map (kbd "C-c") 'eval-buffer)

;(defun org-replace-link-by-link-description ()
;    "Replace an org link by its description or if empty its address"
;  (interactive)
;  (if (org-in-regexp org-bracket-link-regexp 1)
;      (let ((remove (list (match-beginning 0) (match-end 0)))
;        (description (if (match-end 3)
;                 (org-match-string-no-properties 3)
;                 (org-match-string-no-properties 1))))
;    (apply 'delete-region remove)
;    (insert description))))

(after! neotree
  ; this prevents changing of directory
  (setq neo-autorefresh nil)
  (require 'neotree)
        (define-prefix-command 'neo-key-map)
        (define-key neo-key-map "a" 'neotree-create-node)
        (define-key neo-key-map "m" 'neotree-rename-node)
        (define-key neo-key-map "d" 'neotree-delete-node)
        (define-key neo-key-map "c" 'neotree-copy-node)
        (define-key neo-key-map "g" 'neotree-dir)

        (evil-define-key 'normal neotree-mode-map (kbd "o") 'neotree-enter)
        (evil-define-key 'normal neotree-mode-map (kbd "m") neo-key-map)
        (evil-define-key 'normal neotree-mode-map (kbd "r") 'neotree-refresh)
        (evil-define-key 'normal neotree-mode-map (kbd "n") 'evil-ex-search-next)
        (evil-define-key 'normal neotree-mode-map (kbd "p") 'evil-ex-search-previous)
        (evil-define-key 'normal neotree-mode-map (kbd "O") 'neotree-enter-vertical-split)
        (evil-define-key 'normal neotree-mode-map [escape] 'great-escape)

        (setq neo-window-width 45)
        (setq neo-window-fixed-size nil)
)

(after! buffer-move
  	(global-set-key (kbd "<C-S-up>")     'buf-move-up)
	(global-set-key (kbd "<C-S-down>")   'buf-move-down)
	(global-set-key (kbd "<C-S-left>")   'buf-move-left)
	(global-set-key (kbd "<C-S-right>")  'buf-move-right)
	)

(after! org
  ; make sure that we can link to fuzzy headings
;  (setq org-link-search-must-match-exact-headline nil)
  (setq org-log-done 'note)
  (setq org-duration-format (quote h:mm))
;  (setq org-agenda-custom-commands
;		'(("c" . "My Custom Agendas")
;        ("cu" "Unscheduled TODO"
;         ((todo ""
;                ((org-agenda-overriding-header "\nUnscheduled TODO")
;                 (org-agenda-skip-function '(org-agenda-skip-entry-if 'timestamp)))))
;         nil
;         nil))
;    )
)

;(after! org-dashboard
;  (defun my/org-dashboard-filter (entry)
;	(and (> (plist-get entry :progress-percent) 0)
;		 (< (plist-get entry :progress-percent) 100)
;		 (not (member "archive" (plist-get entry :tags)))))
;
;  (setq org-dashboard-filter 'my/org-dashboard-filter)
;  (setq org-dashboard-files org-agenda-files)
;)

(after! speedbar
  ;; unbind default 'g' binding in speedbar
  (define-key speedbar-mode-map (kbd "o") 'speedbar-edit-line)
  (define-key speedbar-mode-map (kbd "u") 'speedbar-up-directory)
  (define-key speedbar-mode-map (kbd "o") 'speedbar-edit-line)
  (define-key speedbar-mode-map (kbd "r") 'speedbar-refresh)
  (define-key speedbar-mode-map (kbd "j") 'speedbar-next)
  (define-key speedbar-mode-map (kbd "k") 'speedbar-prev)
  (define-key speedbar-mode-map (kbd "n") 'evil-ex-search-next)
  (define-key speedbar-mode-map (kbd "p") 'evil-ex-search-previous)
  (define-key speedbar-mode-map (kbd "C-b") 'sr-speedbar-toggle)
  (define-key speedbar-mode-map (kbd "b")
	(lambda ()
	  (interactive)
	  (speedbar-change-initial-expansion-list "buffers")
	  )
  )
  (define-key speedbar-buffers-key-map (kbd "o") 'speedbar-edit-line)
  (define-key speedbar-buffers-key-map (kbd "j") 'speedbar-next)
  (define-key speedbar-buffers-key-map (kbd "k") 'speedbar-prev)
  (define-key speedbar-buffers-key-map (kbd "r") 'speedbar-refresh)
  (define-key speedbar-buffers-key-map (kbd "n") 'evil-ex-search-next)
  (define-key speedbar-buffers-key-map (kbd "p") 'evil-ex-search-previous)
)

(after! smartparens
	(smartparens-global-mode nil)
	(turn-off-smartparens-mode)
)

; indent with tabs
(setq-default c-basic-offset 2
                  tab-width 2)
(setq-default indent-tabs-mode t)
(setq-default tab-width 2)
(setq indent-line-function 'indent-relative)

; Disable auto completion
(setq company-idle-delay nil)

(add-hook 'c-mode-common-hook '(lambda () (c-toggle-hungry-state 1)))
;(add-hook 'c-mode-common-hook '(lambda () (c-set-style "Linux")))

(smart-tabs-insinuate 'c)
;(smart-tabs-insinuate 'python)

; This is bound to kill line by default so it's totally fine
(global-set-key (kbd "C-k") #'kill-buffer)

; this is to emulate vims ability to pipe buffer selection through a shell command and replace the selection with the output
(defun shell-command-on-region-replace (start end command)
  "Run shell-command-on-region interactivly replacing the region in place"
  (interactive (let (string) 
         (unless (mark)
           (error "The mark is not set now, so there is no region"))
         ;; Do this before calling region-beginning
         ;; and region-end, in case subprocess output
         ;; relocates them while we are in the minibuffer.
         ;; call-interactively recognizes region-beginning and
         ;; region-end specially, leaving them in the history.
         (setq string (read-from-minibuffer "Shell command on region: "
                            nil nil nil
                            'shell-command-history))
         (list (region-beginning) (region-end)
               string)))
  (shell-command-on-region start end command t t)
)

(defun how-many-region (begin end regexp &optional interactive)
  "Print number of non-trivial matches for REGEXP in region.                    
   Non-interactive arguments are Begin End Regexp"
  (interactive "r\nsHow many matches for (regexp): \np")
  (let ((count 0) opoint)
    (save-excursion
      (setq end (or end (point-max)))
      (goto-char (or begin (point)))
      (while (and (< (setq opoint (point)) end)
                  (re-search-forward regexp end t))
        (if (= opoint (point))
            (forward-char 1)
          (setq count (1+ count))))
      (if interactive (message "%d occurrences" count))
      count)))

(defun infer-indentation-style ()
  ;; if our source file uses tabs, we use tabs, if spaces spaces, and if        
  ;; neither, we use the current indent-tabs-mode                               
  (let ((space-count (how-many-region (point-min) (point-max) "^  "))
        (tab-count (how-many-region (point-min) (point-max) "^\t")))
    (if (> space-count tab-count) (setq indent-tabs-mode nil))
    (if (> tab-count space-count) (setq indent-tabs-mode t))))

(add-hook 'python-mode-hook
    (lambda ()
        (setq indent-tabs-mode nil)
        (infer-indentation-style)))

(after! evil
	(evil-global-set-key 'normal (kbd "C-n") 'neotree-toggle)
	(evil-global-set-key 'normal (kbd "C-b")
		(lambda ()
		  (interactive)
		  (sr-speedbar-toggle)
		  (sr-speedbar-select-window)
		  )
	)
	(global-set-key (kbd "<backtab>") 'complete-tag)
	(evil-global-set-key 'normal (kbd "<C-S-up>")     'buf-move-up)
	(evil-global-set-key 'normal (kbd "<C-S-down>")   'buf-move-down)
	(evil-global-set-key 'normal (kbd "<C-S-left>")   'buf-move-left)
	(evil-global-set-key 'normal (kbd "<C-S-right>")  'buf-move-right)
	(defalias #'forward-evil-word #'forward-evil-symbol) ; this will ensure that vim ciw works as expected and treats _ as part of symbol in C mode
	; START TABS CONFIG
	;; Create a variable for our preferred tab width
	(setq custom-tab-width 2)

	;; Two callable functions for enabling/disabling tabs in Emacs
	(defun disable-tabs ()
                (setq indent-tabs-mode nil))
	(defun enable-tabs  ()
                (local-set-key (kbd "TAB") 'tab-to-tab-stop)
	(setq indent-tabs-mode t)
  ;;(hs-hide-initial-comment-block)
	(setq tab-width custom-tab-width))

        (load "~/.doom.d/xcscope.el")
        (load "~/.doom.d/gtts.el")
        (load "~/.doom.d/top-comment.el")
        (load "~/.doom.d/checkpatch-mode.el")
        (load "~/.doom.d/markup-faces.el")
        (load "~/.doom.d/adoc-mode.el")
        (load "~/.doom.d/yaml-mode.el")
        (load "~/.doom.d/robot-mode.el")

		(cscope-setup)

        (add-to-list 'auto-mode-alist '("\\.adoc\\'" . adoc-mode))

        ;; Hooks to Enable Tabs
        (add-hook 'prog-mode-hook 'enable-tabs)
        (add-hook 'adoc-mode-hook 'enable-tabs)

        ;; Hooks to Disable Tabs
        (add-hook 'lisp-mode-hook 'disable-tabs)
        (add-hook 'rust-mode-hook 'disable-tabs)

        (add-hook 'emacs-lisp-mode-hook 'disable-tabs)

    ;; Language-Specific Tweaks
    (setq-default python-indent-offset custom-tab-width) ;; Python
    (setq-default js-indent-level custom-tab-width)      ;; Javascript

    ;; Making electric-indent behave sanely
    (setq-default electric-indent-inhibit nil)

    ;; Make the backspace properly erase the tab instead of
    ;; removing 1 space at a time.
    (setq backward-delete-char-untabify-method 'hungry)

    ;; (OPTIONAL) Shift width for evil-mode users
    ;; For the vim-like motions of ">>" and "<<".
    (setq-default evil-shift-width custom-tab-width)

    ;; WARNING: This will change your life
    ;; (OPTIONAL) Visualize tabs as a pipe character - "|"
    ;; This will also show trailing characters as they are useful to spot.
    (setq whitespace-style '(face tabs tab-mark trailing))
    (custom-set-faces
        '(whitespace-tab ((t (:foreground "#636363")))))
    (setq whitespace-display-mappings
        '((tab-mark 9 [124 9] [92 9]))) ; 124 is the ascii ID for '\|'
    (global-whitespace-mode) ; Enable whitespace mode everywhere
    ; END TABS CONFIG
)

; Add a command :k for killing current buffer
(after! evil-ex
  (evil-ex-define-cmd "k[ill]" 'kill-this-buffer)
  (evil-ex-define-cmd "r[ecompile]" 'recompile)
  (evil-ex-define-cmd "b[uffers]" 'list-buffers)
  (evil-ex-define-cmd "m[ake]" 'compile)
)

; Solve the issue of emacs refusing to insert tabs in C mode
; This also fixes the problem of indenting visual blocks using <>
(defun insert-real-tab-char ()
  "Insert a tab char. (ASCII 9, \t)"
  (interactive)
  (insert "\t"))

(global-set-key (kbd "TAB") 'indent-for-tab-command)

(setq electric-pair-preserve-balance nil)

(global-set-key (kbd "C-u") 'universal-argument)
