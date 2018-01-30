(evil-mode t)
(global-evil-leader-mode)
(setq evil-want-Y-yank-to-eol nil)
(setq evil-search-module 'evil-search)

        ; evil-surround
(global-evil-surround-mode 1)

            ; custom bindings
(define-key evil-motion-state-map "ç" 'evil-ex)
(define-key evil-visual-state-map "ç" 'evil-ex)
(define-key evil-motion-state-map "¬" 'evil-first-non-blank)
(define-key evil-motion-state-map (kbd "<f6>") 'evil-write)
(define-key evil-motion-state-map (kbd "<f5>") 'list-buffers)
(define-key evil-insert-state-map "\C-u" '(lambda () (interactive) (kill-line 0)))
(define-key evil-insert-state-map (kbd "<f6>") '(lambda () (interactive)
                                                  (evil-normal-state) (save-buffer)))
(define-key evil-motion-state-map "\C-h" 'evil-window-left)
(define-key evil-motion-state-map "\C-j" 'evil-window-down)
(define-key evil-motion-state-map "\C-k" 'evil-window-up)
(define-key evil-motion-state-map "\C-l" 'evil-window-right)

;; Bailey Ling
(setq evil-emacs-state-cursor '("red" box))
(setq evil-motion-state-cursor '("orange" box))
(setq evil-normal-state-cursor '("green" box))
(setq evil-visual-state-cursor '("orange" box))
(setq evil-insert-state-cursor '("red" bar))
(setq evil-replace-state-cursor '("red" bar))
(setq evil-operator-state-cursor '("red" hollow))
