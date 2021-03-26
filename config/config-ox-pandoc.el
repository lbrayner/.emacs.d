(setq org-pandoc-options '((standalone . t)
                           (variable "margin-top:15"
                                     "margin-bottom:15"
                                     "margin-left:15"
                                     "margin-right:15")
                           (pdf-engine . "wkhtmltopdf")))

(defvar org-pandoc-temporary-css-file nil
  "Temporary css file to be deleted.")

(defun org-pandoc-inline-css (exporter)
  "Insert custom inline css (pandoc)"
  (when (eq exporter 'pandoc)
    (let* ((dir (ignore-errors (file-name-directory (buffer-file-name))))
           (filename (concat (file-name-base (buffer-file-name)) ".css"))
           (path (concat dir filename))
           (default (or (null dir) (null (file-exists-p path))))
           (default-file (expand-file-name ".emacs.d/org-style.css" (home-directory)))
           (final (if default "~/.emacs.d/org-style.css" path)))
      (if (file-exists-p final)
          (setf (alist-get 'include-before-body org-pandoc-options)
                (let ((temp-file (make-temp-name "pandoc-css.")))
                  (setq org-pandoc-temporary-css-file temp-file)
                  (with-temp-file temp-file
                    (insert (concat "<style type=\"text/css\">\n"
                                    "<!--/*--><![CDATA[/*><!--*/\n"))
                    (save-excursion (insert (concat "/*]]>*/-->\n"
                                                    "</style>\n")))
                    (insert-file-contents final))
                  temp-file))
        (setq org-pandoc-options (assq-delete-all 'include-before-body org-pandoc-options))))))

(defun org-pandoc-delete-temporary-css-file ()
  "Deletes the temporary css file."
  (if org-pandoc-temporary-css-file
      (delete-file org-pandoc-temporary-css-file))
  (setq org-pandoc-temporary-css-file nil))

(add-hook 'org-export-before-processing-hook #'org-pandoc-inline-css)
(add-hook 'org-pandoc-after-processing-html5-pdf-hook
          #'org-pandoc-delete-temporary-css-file)
(add-hook 'org-pandoc-after-processing-html5-hook
          #'org-pandoc-delete-temporary-css-file)

;; custom vars

(defvar-local file-local-time-locale nil
  "Overrides system-time-locale.")

(defun file-local-time-locale-safep (value)
  (stringp value))

(put 'file-local-time-locale 'safe-local-variable
     #'file-local-time-locale-safep)

;; filters timestamps through org-timestamp-translate

(defun org-pandoc-timestamp-transcoder (timestamp _contents info)
  (org-timestamp-translate timestamp))

;; interprets the title of a headline before sending it to the
;; underlying transcoder
(defun org-pandoc-headline-transcoder (headline contents info)
  (let* ((text (org-export-data
                (org-element-property :title headline) info))
         (alt-headline (org-element-put-property
                        headline :title text)))
    (org-org-headline alt-headline contents info)))

(with-eval-after-load 'ox-pandoc
  ;; https://lists.gnu.org/archive/html/emacs-devel/2018-03/msg00557.html
  (eval
   '(progn
      (setf (alist-get 'timestamp
                       ;; org-export-backend is a struct
                       ;; and transcoders, a slot
                       (org-export-backend-transcoders (org-export-get-backend
                                                        'pandoc)))
            'org-pandoc-timestamp-transcoder)
      (setf (alist-get 'headline
                       (org-export-backend-transcoders (org-export-get-backend
                                                        'pandoc)))
            'org-pandoc-headline-transcoder))))

;; customizing the export menu
;; for each menu key in org-pandoc-menu-keys, replace the current
;; action with a "my-" prefixed function
(with-eval-after-load 'ox-pandoc
  (let ((org-pandoc-menu-keys '(?$ ?4 ?% ?5)))
    (cl-labels ((customize-menu-entries
                 (as)
                 (unless (null as)
                   (let* ((a (car as))
                          (description-action (alist-get a org-pandoc-menu-entry))
                          (description (car description-action))
                          (action (car (cdr description-action))))
                     (setf
                      (alist-get a org-pandoc-menu-entry)
                      (list description
                            (intern-soft
                             (concat "my-" (symbol-name action)))))
                     (customize-menu-entries (cdr as))))))
      (customize-menu-entries org-pandoc-menu-keys))))
