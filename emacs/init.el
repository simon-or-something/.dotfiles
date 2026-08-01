;;; init.el:  -*- lexical-binding: t; -*-
;; TODO:
;; treesitter context
;; disable warnings for lsps that dont exist

                                        ; functions
(progn
  (defun custom/reloadinit ()
    "reloads the init file"
    (interactive)
    (load-file user-init-file))
  (defun custom/other-window-backward (&optional n)
    "Select the previous window."
    (interactive "p")
    (other-window (- n)))
  (defmacro timeload (name &rest body)
    (declare (indent 5)) ;; this makes it flush with 5 indents
    `(let ((start-time (current-time)))
       ,@body
       (message "%s took %.06f seconds"
                ,name
                (float-time (time-subtract (current-time) start-time))))
    )
  )

                                        ; basic settings
(timeload "basic settings"
    ;; cursor
    (blink-cursor-mode -1)
    (show-paren-mode 1)
    (setopt show-paren-delay 0)
    ;; font
    (add-to-list 'default-frame-alist '(font . "Fira Code Retina-12"))
  (set-face-attribute 'default nil :font "Fira Code Retina-12")
  (global-font-lock-mode t)
  ;; bars
  (menu-bar-mode -1) ;; i like it, if i ever forget a command
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (tooltip-mode -1)
  ;; bottom bar
  (column-number-mode 1)
  (size-indication-mode 1)
  (when (and (fboundp 'battery)
             (battery))
    (display-battery-mode 1))
  (display-time-mode 1)
  (setopt display-time-format "%H:%M - %d, %m %Y")
  ;; side bar
  (setopt display-line-numbers-type 'relative)
  ;; indentation
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 4)
  (setq-default standard-indent 4)
  (setq-default fill-column 80) ;; this is for word mode
  (setq-default lexical-binding t)
  ;; load
  (setopt inhibit-startup-screen t)
  (setopt initial-scratch-message nil)
  (setopt vc-follow-symlinks t)
  (setopt use-short-answers t) ;; please answer yes or no
  (setopt sentence-end-double-space nil)
  ;; compilation (faster loads)
  (make-directory (locate-user-emacs-file "backups/") t)
  (make-directory (locate-user-emacs-file "auto-save/") t)
  (setopt backup-directory-alist `(("." . ,(locate-user-emacs-file "backups/"))))
  (setopt auto-save-file-name-transforms `((".*" ,(locate-user-emacs-file "auto-save/") t)))
  ;;(native-compile-async (locate-user-emacs-file locate-user-emacs-file "elpa") t)
  (setopt package-native-compile t)
  ;; format
  (set-language-environment "UTF-8")
  (prefer-coding-system 'utf-8)
  ;; modes
  (setq major-mode-remap-alist
        '((c-mode . c-ts-mode)
          (c++-mode . c++-ts-mode)
          (typescript-mode . typescript-ts-mode)
          )
        )
  )

                                        ; packages
(setopt package-archives
        '(("gnu" . "https://elpa.gnu.org/packages/")
          ("nongnu" . "https://elpa.nongnu.org/nongnu/")
          ("melpa" . "https://melpa.org/packages/")
          ("melpa-stable" . "https://stable.melpa.org/packages/")
          ("gnu-devel" . "https://elpa.gnu.org/devel/")
          ))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("51fa6edfd6c8a4defc2681e4c438caf24908854c12ea12a1fbfd4d055a9647a3" default))
 '(highlight-indent-guides-auto-enabled nil)
 '(package-selected-packages
   '(anki-mode avy-embark-collect cape consult corfu crdt dap-mode dash-functional
               dictionary diff-hl docker dockerfile-mode editorconfig
               elisp-autofmt elixir-ts-mode embark embark-consult embrace
               flycheck graphviz-dot-mode gruvbox-theme heex-ts-mode
               highlight-indent-guides hl-todo idlwave iedit kdl-mode
               less-css-mode ligature lsp-java lsp-mode lsp-pyright lsp-ui
               lua-mode magit marginalia matlab-mode move-text multiple-cursors
               nerd-icons-corfu orderless org org-mind-map org-preview-html
               org-roam org-transclusion pdf-tools preview-auto projectile
               python-docstring racket-mode rainbow-delimiters rainbow-mode
               rc-mode ripgrep smartparens string-inflection symbols-outline
               track-changes transient verilog-mode vertico vterm wallpaper
               which-key window-tool-bar yaml-mode yasnippet yasnippet-snippets))
 '(safe-local-variable-directories
   '("/home/simon-or-something/Documents/Org/uni/compsci/coto/notes/")))
;; org-mode: https://abode.karthinks.com/org-latex-preview/ -> https://code.tecosaur.net/tec/org-mode
;; from https://abode.karthinks.com/org-latex-preview/

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'use-package)
(require 'seq)
(require 'project)
(setopt use-package-always-ensure t)

;; vertico (evil) consult embark magit projectile cape lsp-ui dap-mode lsp-dart lsp-flutter editorconfig corfu
;; yasnippets diff-hl hl-todo vertico-directory projectile vterm rainbow-delimiters multiple-cursors iedit smartparens
;; string-inflection embrace docker ligature rainbow-mode
;; marginalia? savehist? recentf?

;;(when nil
                                        ; motion
(timeload "motion"
    ;; for clean reinstalls turn this on, let emacs do its thing, then turn this off
    ;;(when nil
    ;;(use-package evil :bind ("C-c v" . evil-mode)) ;; breaks my heart to disable this but i dont need it
    (use-package avy
      :bind
      ("C-ä c" . avy-goto-char)
      ("C-ä w" . avy-goto-word-1)
      ("C-ä l" . avy-goto-line)
      )
    (use-package embrace :bind ("C-c e" . embrace-commander))
    (use-package multiple-cursors
      :bind
      ("C-<down>" . mc/mark-next-lines)
      ("C-<up>" . mc/mark-previous-lines)
      ("M-n" . mc/mark-next-lines)
      ("M-p" . mc/mark-previous-lines)
      )
    (use-package expand-region
      :bind
      ("M-+" . er/expand-region)
      ("M--" . er/contract-region)
      )

  (use-package move-text :config (move-text-default-bindings))
  (use-package string-inflection
    :commands
    (string-inflection-toggle
     string-inflection-all-cycle
     string-inflection-upcase
     string-inflection-cycle
     string-inflection-camelcase
     string-inflection-camel-case
     string-inflection-lower-camelcase
     string-inflection-underscore
     string-inflection-kebab-case)
    )
  (use-package smartparens
    :disabled t
    ;;:hook
    ;;(prog-mode . smartparens-mode)
    ;;(markdown-mode . smartparens-mode)
    :config
    ;;(require 'smartparens-config)
    )
  )

                                        ; style
(timeload "style"
    (use-package gruvbox-theme :config (load-theme 'gruvbox-dark-soft :noconfirm))
    (use-package ligature
      :hook ((prog-mode org-mode) . ligature-mode)
      :config
      (ligature-set-ligatures '(prog-mode org-mode)
                              '(("=" (rx (+ (or ">" "<" "|" "/" "~" ":" "!" "="))))
                                (";" (rx (+ ";")))
                                ("&" (rx (+ "&")))
                                ("!" (rx (+ (or "=" "!" "\." ":" "~"))))
                                ("?" (rx (or ":" "=" "\." (+ "?"))))
                                ("%" (rx (+ "%")))
                                ("|" (rx (+ (or ">" "<" "|" "/" ":" "!" "}" "\]"
                                                "-" "=" ))))
                                ("\\" (rx (or "/" (+ "\\"))))
                                ("+" (rx (or ">" (+ "+"))))
                                (":" (rx (or ">" "<" "=" "//" ":=" (+ ":"))))
                                ("/" (rx (+ (or ">"  "<" "|" "/" "\\" "\*" ":" "!"
                                                "="))))
                                ("\." (rx (or "=" "-" "\?" "\.=" "\.<" (+ "\."))))
                                ("-" (rx (+ (or ">" "<" "|" "~" "-"))))
                                ("*" (rx (or ">" "/" ")" (+ "*"))))
                                ("w" (rx (+ "w")))
                                ("<" (rx (+ (or "\+" "\*" "\$" "<" ">" ":" "~"  "!"
                                                "-"  "/" "|" "="))))
                                (">" (rx (+ (or ">" "<" "|" "/" ":" "=" "-"))))
                                ("#" (rx (or ":" "=" "!" "(" "\?" "\[" "{" "_(" "_"
                                             (+ "#"))))
                                ("~" (rx (or ">" "=" "-" "@" "~>" (+ "~"))))
                                ("_" (rx (+ (or "_" "|"))))
                                ("0" (rx (and "x" (+ (in "A-F" "a-f" "0-9")))))
                                "Fl"  "Tl"  "fi"  "fj"  "fl"  "ft"
                                "{|"  "[|"  "]#"  "(*"  "}#"  "$>"  "^="))
      )
    ;; enable vertico. vertical minibuffer completion
    (use-package vertico
      :custom
      ;; (vertico-scroll-margin 0) ;; different scroll margin
      (vertico-count 5) ;; show more candidates
      ;; (vertico-resize t) ;; grow and shrink the vertico minibuffer
      (vertico-cycle t) ;; enable cycling for `vertico-next/previous'
      :config
      (vertico-mode)
      )
    (use-package orderless
      :custom
      (completion-styles '(orderless basic))
      (completion-category-overrides '((file (styles basic partial-completion))))
      (completion-pcm-leading-wildcard t)
      ) ;; Emacs 31: partial-completion behaves like substring

  (use-package magit)
  (use-package diff-hl
    :after magit
    :hook
    ((prog-mode text-mode) . diff-hl-mode)
    (dired-mode . diff-hl-dired-mode)
    (magit-post-refresh . diff-hl-magit-post-refresh)
    )
  (use-package editorconfig :config (editorconfig-mode 1))
  (use-package whitespace
    :hook
    ((prog-mode text-mode) . whitespace-mode)
    :custom
    ;;(whitespace-style '(face tabs spaces trailing space-before-tab newline indentation empty space-after-tab space-mark tab-mark))
    (whitespace-style '(face tabs trailing space-before-tab indentation empty space-after-tab tab-mark))
    )
  )

                                        ; highlighting
(timeload "highlighting"
    ;; https://emacs.stackexchange.com/questions/85489/solve-version-mismatch-with-tree-sitter-in-emacs-30-1-and-later-without-recom
    ;; small script which does the things in the stackexchange as one line:
    ;; STR=$(git blame src/parser.c | grep define.*LANGUAGE_VERSION) && echo $STR && git describe --abbrev=0 $(echo $STR | sed 's_\(\w* \).*_\1_g')
    (setopt treesit-language-source-alist
            '((python     "https://github.com/tree-sitter/tree-sitter-python" "v0.20.4")
              (c          "https://github.com/tree-sitter/tree-sitter-c" "v0.20.8")
              (cpp        "https://github.com/tree-sitter/tree-sitter-cpp" "v0.20.5")
              (java       "https://github.com/tree-sitter/tree-sitter-java")
              (bash       "https://github.com/tree-sitter/tree-sitter-bash" "v0.20.5")
              (yaml       "https://github.com/ikatyang/tree-sitter-yaml")
              (dockerfile "https://github.com/camdencheek/tree-sitter-dockerfile")
              (typst      "https://github.com/uben0/tree-sitter-typst")
              (json       "https://github.com/tree-sitter/tree-sitter-json.git")
              (typescript "https://github.com/tree-sitter/tree-sitter-typescript")
              )
            )

    (use-package rainbow-mode :hook (prog-mode . rainbow-mode)) ;; colours
    (use-package rainbow-delimiters :hook (prog-mode . rainbow-delimiters-mode)) ;; brackets
    (use-package highlight-indent-guides
      :hook
      (prog-mode . highlight-indent-guides-mode)
      ;;:config
      ;;(set-face-foreground 'highlight-indent-guides-character-face "#b57614")
      :custom
      (highlight-indent-guides-method 'character) ;; 'character, 'column, 'bitmap, 'fill
      )
  (use-package hl-todo
    :custom
    (hl-todo-keyword-faces '(("TODO" . "#9d0006")
                             ("FIXME" . "#cc241d")
                             ("DEBUG" . "#d3869b")
                             ("GOTCHA" . "#d65d0e")
                             ("STUB" . "#076678")
                             ("MARK" . "#d79921")
                             ))
    :config
    (global-hl-todo-mode)
    )
  (use-package hideshow
    :hook
    (prog-mode-hook . hs-minor-mode)
    :bind
    ("C-c @ h" . hs-hide-block)
    ("C-c @ s" . hs-show-block)
    ;;("C-c @ t" . hs-toggle-hiding)
    ("C-c s" . hs-toggle-hiding)
    )
  )

                                        ; lsp setup and completion
(timeload "lsp setup and completion"
    (use-package lsp-mode
      :hook
      ((c-ts-mode c++-ts-mode java-mode haskell-mode python-mode python-ts-mode typescript-ts-mode) . lsp-deferred)
      :commands
      (lsp lsp-deferred)
      :custom
      (lsp-keymap-prefix "C-c l")
      (lsp-log-io nil) ;; enable logging for debugging
      (lsp-enable-snippet t) ;; optional keymap prefix
      (lsp-completion-provider :none)
      )
    (use-package lsp-ui ;; ide feeling
      :after lsp-mode
      :hook (lsp-mode . lsp-ui-mode)
      :custom
      (lsp-ui-sideline-enable t)
      (lsp-ui-sideline-show-hover t)
      (lsp-ui-sideline-show-diagnostics t)
      (lsp-ui-sideline-show-code-actions t)
      (lsp-ui-sideline-update-mode 'line)
      (lsp-ui-sideline-delay 0.5)
      (lsp-ui-sideline-diagnostic-max-lines 3)
      (lsp-ui-doc-enable t)
      (lsp-ui-doc-show-with-cursor nil)
      (lsp-ui-doc-show-with-mouse t)
      (lsp-ui-doc-border (face-foreground 'default))
      ;;(set-face-attribute 'lsp-ui-doc-background nil :background "#282828")
      :config
      (set-face-attribute 'markdown-hr-face nil :height 0.1)
      )
    (use-package dap-mode
      ;;:after lsp-mode
      :commands (dap-mode dap-debug dap-debug-last dap-breakpoint-toggle)
      :config
      (dap-auto-configure-mode)
      (require 'dap-gdb-lldb)
      )

    (use-package corfu ;; frontend, snippet engine
      :config (global-corfu-mode)
      :custom
      (corfu-auto t)
      (corfu-auto-prefix 1)
      (corfu-auto-delay 0.0)
      (corfu-quit-no-match t)
      (corfu-preview-current nil)
      (corfu-preselect-first t)
      (corfu-cycle t)
      )
  (use-package cape ;; corfu extension: completion at point ext
    :bind
    ("C-c p" . cape-prefix-map) ;; Alternative key: M-<tab>, M-p, M-+
    :init ;; order is this strange so i can shuffle them around
    (dolist (fn '(
                  cape-elisp-block
                  cape-dabbrev
                  cape-history
                  cape-file
                  cape-keyword
                  ))
      (add-hook 'completion-at-point-functions fn)) ;; its prepend apparently, append is (add-hook 'completion-at-point-functions fn t)
    ;;(completion-at-point-functions . (cape-dabbrev cape-file cape-elisp-block cape-history))
    )
  ;; for individual languages do:
  ;;(add-hook 'python-mode-hook
  ;;          (lambda ()
  ;;            (setq-local completion-at-point-functions
  ;;                        (list #'lsp-completion-at-point
  ;;                              #'cape-file))))

  (use-package yasnippet ;; template engine ( `for (${1}; ${2}; ${3}) { ${4} } `)
    :hook ((prog-mode text-mode org-mode) . yas-minor-mode)
    ;;:init
    ;;(yas-global-mode 1)
    ;;:config
    ;;(yas-reload-all)
    )
  (use-package yasnippet-snippets :after yasnippet)

  (use-package nerd-icons-corfu
    :after corfu
    :config
    (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter)
    )

  (use-package flyspell
    :hook
    ((text-mode org-mode)  . flyspell-mode)
    (prog-mode . flyspell-prog-mode)
    )
  )

                                        ; languages and lsps
(timeload "languages and lsps"
    (use-package lsp-java :after lsp-mode)
    (use-package lsp-pyright :after lsp-mode)
    (use-package lsp-haskell :after lsp-mode)
    (use-package projectile
      :disabled t
      :custom
      (projectile-mode nil)
      (projectile-completion-system 'default)
      (projectile-sort-order 'recentf)
      )
    (use-package tex
      :ensure auctex
      :defer t
      )
  (use-package preview-auto
    :after tex
    :hook (LaTeX-mode . preview-auto-setup)
    )
  (use-package flycheck :defer t)
  (use-package graphviz-dot-mode :hook (graphviz-dot-mode . flycheck-mode))
  )

(timeload "org, org mode, etc"
    (use-package org
      ;;:load-path "~/.config/emacs/elpa/org-mode/lisp/"
      :config
      (org-babel-do-load-languages
       'org-babel-load-languages
       '((dot . t)))
      :custom
      (org-directory "~/.config/emacs/org")
      ;;(org-agenda-files (directory-files-recursively org-directory "^[[:alnum:]][^/]*\\.org$"))
      (org-agenda-files (list (expand-file-name "uni.org" org-directory)
                              (expand-file-name "done.org" org-directory)
                              (expand-file-name "todos.org" org-directory)))
      (org-src-fontify-natively t)
      (org-src-tab-acts-natively t)
      ;;(org-edit-src-content-indentation 0)
      )
    (use-package org-roam
      :after org
      :init
      (setq org-roam-directory "~/.config/emacs/") ;; (file-truename (locate-user-emacs-file "org/"))
      (setq org-roam-db-location (expand-file-name "org-roam.db" org-roam-directory))
      )
    (use-package ox-typst
      :after org)
    )

                                        ; styling and applications
(timeload "styling and applications / ipc"
    (use-package saveplace :config (save-place-mode 1))
    (use-package savehist :config (savehist-mode 1))
    (use-package recentf
      :custom
      (recentf-max-saved-items 50)
      :config
      (recentf-mode 1)
      )
    (use-package vterm
      :bind
      ("C-c M-t" . vterm)
      ;;("C-ü" . term-char-mode)
      ("C-ü" . vterm-copy-mode)
      :custom
      (vterm-max-scrollback 1000)
      :init
      (setq vterm-shell (cond
                         ((string-equal system-name "debiauan.lan")   "/bin/bash")
                         ((string-equal system-name "genone")   "/bin/bash")
                         ((string-equal system-name "debiauan") "/bin/zsh")
                         (t "/bin/sh")))
      ;;(setopt vterm-keymap-exceptions nil)
      ;; or '("C-c" "C-x" "C-u" "C-g" "C-y" "M-x") instead
      )
  (use-package pdf-tools
    :magic ("%PDF" . pdf-view-mode)
    :mode ("\\.pdf\\'" . pdf-view-mode)
    :config (pdf-tools-install :no-query)
    )
  )

(declare-function tab-line-switch-to-next-tab "tab-line")
(declare-function tab-line-switch-to-prev-tab "tab-line")
                                        ; keybinds
(timeload "keybinds"
    (keymap-global-set "C-c r" #'custom/reloadinit)

    (keymap-global-set "C-+" #'text-scale-increase)
    (keymap-global-set "C--" #'text-scale-decrease)

    ;;(keymap-global-set "C-ö" #'ignore)

    (keymap-global-set "C-x O" #'custom/other-window-backward)

  (with-eval-after-load 'project
    (keymap-set project-prefix-map "c" #'compile))
  (with-eval-after-load 'pdf-view
    (define-key pdf-view-mode-map (kbd "G g") #'image-bob)
    (define-key pdf-view-mode-map (kbd "G G")   #'image-eob))

                                        ; tab mappings
  (defvar-keymap custom/tab-mappings
    :doc "tab related commands"
    "s" #'global-tab-line-mode
    "c" (lambda ()
          (interactive)
          (let ((buf (generate-new-buffer "untitled")))
            (switch-to-buffer buf)))
    "n" (lambda ()
          (interactive)
          (when (bound-and-true-p tab-line-mode)
            (tab-line-switch-to-next-tab)))
    "p" (lambda ()
          (interactive)
          (when (bound-and-true-p tab-line-mode)
            (tab-line-switch-to-prev-tab)))
    )
  (keymap-global-set "C-c t" custom/tab-mappings)

  (defvar-keymap custom/vterm-mappings
    :doc "vterm keys, emulates tmux and stuff"
    "c" (lambda ()
          (interactive)
          (let ((default-directory
                 (or (when-let* ((project (project-current)))
                       (project-root project))
                     default-directory)))
            (vterm (generate-new-buffer-name "*vterm*"))))
    )
  (keymap-global-set "C-(" custom/vterm-mappings)

                                        ; yank mappings
  (defvar-keymap custom/yank-mappings
    :doc "yank related mappings"
    "j" #'duplicate-line
    "k" (lambda () ((duplicate-line) (previous-line)))
    )
  (keymap-global-set "C-c y" custom/yank-mappings)

  (setopt tab-line-tabs-function
          (lambda ()
            ;;(delete-dups ;;(buffer-list) ;; buffers are already single
            (seq-filter
             (lambda (buf)
               (let ((name (buffer-name buf)))
                 (not (string-prefix-p "*" name))))
             (buffer-list)))) ;;)
  )

(timeload "hooks"
    (dolist (hook '(prog-mode-hook conf-mode-hook))
      (add-hook hook #'display-line-numbers-mode))
    (add-hook 'emacs-startup-hook
              (lambda ()
                (setopt gc-cons-threshold (* 64 1024 1024)
                        gc-cons-percentage 0.1)))
    )
;;)

(timeload "last"
    ;;(provide 'init)
    )
