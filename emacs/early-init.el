;;; early-init.el:  -*- lexical-binding: t; -*-
(setenv "LSP_USE_PLISTS" "true")
(setenv "SHELL" "/usr/bin/bash")

(setq gc-cons-threshold most-positive-fixnum ;; no garbage collection at init
      gc-cons-percentage 0.6)                ;; 60% current heap size -> sweep

;; skip regexp matching against file name handlers for every load/require
;; a list of (REGEXP . HANDLER_CB), and this, on load, searches everything in load-path
;; which it _should_ usually at least, but because it is loaded from a single file,
;; it doesnt need to do this on init while "the engine is off"
;; "dont go through the regex path and just load the specific pre-computed file"
(defvar custom--file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist
        (seq-filter (lambda (h) (eq (cdr h) 'jka-compr-handler))
                    file-name-handler-alist))

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 64 1024 1024)
                  gc-cons-percentage 0.1
                  file-name-handler-alist
                  (delete-dups (append file-name-handler-alist
                                       custom--file-name-handler-alist)))))

;; ./init.el: this is the #bars one
(menu-bar-mode -1)
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1)) ;; only exists in GUI mode hence check
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1)) ;; ditto fritto

(push '(font . "Fira Code Retina-12") default-frame-alist)
(setq frame-inhibit-implied-resize t
      frame-resize-pixelwise t)

(setq package-quickstart t)
