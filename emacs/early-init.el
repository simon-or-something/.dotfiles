;;; init.el:  -*- lexical-binding: t; -*-
(setenv "LSP_USE_PLISTS" "true")
(setenv "SHELL" "/usr/bin/bash")

(setq gc-cons-threshold most-positive-fixnum ;; no garbage collection at init
      gc-cons-percentage 0.6)                ;; 60% memory fill up -> gc sweep

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

;;          (use-package dashboard
;;            :disabled t
;;            ;;:config
;;            ;;(dashboard-setup-startup-hook)
;;            ;;(setopt dashboard-startup-banner "~/Pictures/emacs-logo.png")
;;            )

;;          (use-package
;;            symbols-outline
;;            :bind ("C-c i" . symbols-outline-show)
;;            :init
;;            (add-hook 'lsp-mode-hook
;;                      (lambda () (setq-local symbols-outline-fetch-fn #'symbols-outline-lsp-fetch)))
;;            :config (symbols-outline-follow-mode)
;;            :custom (symbols-outline-window-position 'right))


;;(use-package eaf
;;  :load-path "~/.config/emacs/emacs-application-framework/"
;;  :custom
;;  ; See https://github.com/emacs-eaf/emacs-application-framework/wiki/Customization
;;  (eaf-browser-continue-where-left-off t)
;;  (eaf-browser-enable-adblocker t)
;;  (browse-url-browser-function 'eaf-open-browser)
;;  :config
;;  (require 'eaf-browser)
;;  (require 'eaf-pdf-viewer)
;;  (require 'eaf-music-player)
;;  (require 'eaf-video-player)
;;  (require 'eaf-js-video-player)
;;  (require 'eaf-image-viewer)
;;  (require 'eaf-rss-reader)
;;  (require 'eaf-terminal)
;;  (require 'eaf-markdown-previewer)
;;  (require 'eaf-org-previewer)
;;  (require 'eaf-camera)
;;  (require 'eaf-git)
;;  (require 'eaf-file-manager)
;;  (require 'eaf-mindmap)
;;  (require 'eaf-mind-elixir)
;;  (require 'eaf-system-monitor)
;;  (require 'eaf-file-browser)
;;  (require 'eaf-file-sender)
;;  (require 'eaf-airshare)
;;  (require 'eaf-jupyter)
;;  (require 'eaf-2048)
;;  (require 'eaf-markmap)
;;  (require 'eaf-map)
;;  (require 'eaf-demo)
;;  (require 'eaf-vue-demo)
;;  (require 'eaf-vue-tailwindcss)
;;  (require 'eaf-pyqterminal)
;;  (require 'eaf-video-editor)
;;  ;;(defalias 'browse-web #'eaf-open-browser)
;;  ;;(eaf-bind-key scroll_up "C-n" eaf-pdf-viewer-keybinding)
;;  ;;(eaf-bind-key scroll_down "C-p" eaf-pdf-viewer-keybinding)
;;  ;;(eaf-bind-key take_photo "p" eaf-camera-keybinding)
;;  ;;(eaf-bind-key nil "M-q" eaf-browser-keybinding) ;; unbind, see more in the Wiki
;;  )

;;(unless package-archive-contents (package-refresh-contents))
;; i dont really need to do any editing here install package if it doesnt exist (ChatGPT)
;; (dolist (pkg package-selected-packages) (unless (package-installed-p pkg) (package-install pkg)))

;; elcord (discord, but heavy) : `(require 'elcord) \\ (elcord-mode)`
;; origami (folding, i use hide-show)
;; restart-emacs (not really needed)
;; embark (cool but this is like a right click menu on things. learn keybinds)
;; marginalia (cool, this adds extra hints for commands being run. learn keybinds)
;; ws-butler (trims whitespace. i use autoformatters)
;; company (completion engine / coc. Quite nice, but i use corfu and stuff)

;;(add-hook 'after-init-hook 'global-company-mode)
;;(use-package company
;;  :config
;;    (global-company-mode 1)
;;    (setq company-idle-delay 0.1)
;;    (setq company-minimum-prefix-length 1)
;;    (setq company-backends '(company-capf company-yasnippet))
;;)

;(dolist (language-source treesit-language-source-alist)
;  (let ((language-name (car language-source)))
;    (unless (treesit-ready-p language-name)
;      (message "Installing Treesitter grammar for %s" language-name)
;      (treesit-install-language-grammar language-name))))
;(setq treesit-font-lock-level 4)
