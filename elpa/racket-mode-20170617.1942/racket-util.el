;;; racket-util.el

;; Copyright (c) 2013-2016 by Greg Hendershott.
;; Portions Copyright (C) 1985-1986, 1999-2013 Free Software Foundation, Inc.

;; Author: Greg Hendershott
;; URL: https://github.com/greghendershott/racket-mode

;; License:
;; This is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version. This is distributed in the hope that it will be
;; useful, but without any warranty; without even the implied warranty
;; of merchantability or fitness for a particular purpose. See the GNU
;; General Public License for more details. See
;; http://www.gnu.org/licenses/ for details.

(require 'racket-custom)

;;; trace

(defvar racket--trace-enable nil)

(defun racket--trace (p &optional s retval)
  (when racket--trace-enable
    (let ((b (get-buffer-create "*Racket Trace*"))
          (deactivate-mark deactivate-mark))
      (save-excursion
        (save-restriction
          (with-current-buffer b
            (insert p ": " (if (stringp s) s (format "%S" s)) "\n"))))))
  retval)

(defun racket--toggle-trace (arg)
  (interactive "P")
  (setq racket--trace-enable (or arg (not racket--trace-enable)))
  (if racket--trace-enable
      (message "Racket trace on")
    (message "Racket trace off"))
  (let ((b (get-buffer-create "*Racket Trace*")))
    (pop-to-buffer b t t)
    (setq truncate-lines t)))

;;; racket--easy-keymap-define

(defun racket--easy-keymap-define (spec)
  "Make a sparse keymap with the bindings in SPEC.

This is simply a way to DRY many calls to `define-key'.

SPEC is
  (list (list key-or-keys fn) ...)

where key-or-keys is either a string given to `kbd', or (for the
case where multiple keys bind to the same command) a list of such
strings."
  (let ((m (make-sparse-keymap)))
    (mapc (lambda (x)
            (let ((keys (if (listp (car x))
                            (car x)
                          (list (car x))))
                  (fn (cadr x)))
              (mapc (lambda (key)
                      (define-key m (kbd key) fn))
                    keys)))
          spec)
    m))

;;; racket--buffer-file-name

(defun racket--buffer-file-name ()
  "Like `buffer-file-name' but always a non-propertized string."
  (and (buffer-file-name)
       (substring-no-properties (buffer-file-name))))

(provide 'racket-util)

;; racket-util.el ends here
