(require 'icicles)

(defun my-icicle-select-window (win-name &optional window-alist)
  "Calls `icicle-read-choose-window-args' with `current-prefix-arg'
set to \\='- and then selects window via
`icicle-choose-window-by-name'."
  (interactive (let ((current-prefix-arg (cond ((display-graphic-p) '-)
                                               (t nil))))
                 (icicle-read-choose-window-args)))
  (icicle-choose-window-by-name win-name window-alist))

(global-set-key (kbd "<F5>") 'my-icicle-select-window)
