(require 'ox)
(require 'cl-lib)
(require 'ov)

(defun org-outline-numbering-overlay ()
  "Put numbered overlays on the headings."
  (interactive)
  (cl-loop for (p lv) in
           (let* ((info (org-combine-plists
                         (org-export--get-export-attributes)
                         (org-export--get-buffer-attributes)
                         (org-export-get-environment)
                         '(:section-numbers t)))
                  (tree (org-element-parse-buffer))
                  numberlist)
             (org-export--prune-tree tree info)
             (setq numberlist
                   (org-export--collect-headline-numbering tree info))
             (cl-loop for hl in numberlist
                      collect (cons
                               (org-element-property :begin (car hl))
                               (list (cdr hl)))))
           do
           (let ((ov (make-overlay p (+ (length lv) p))))
             (overlay-put ov 'display (concat (mapconcat 'number-to-string lv ".") ". "))
             (overlay-put ov 'numbered-heading t)
             (overlay-put ov 'face 'default))))
