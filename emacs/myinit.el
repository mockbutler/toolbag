(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)

(setq custom-file "~/.emacs.d/customize.el")
(load custom-file 'noerror)

;; https://emacs-lsp.github.io/lsp-mode/tutorials/CPP-guide/
;; https://github.com/emacs-helm/helm

(setq package-selected-packages '(company
				  dap-mode
				  diminish
				  elpy
				  exec-path-from-shell
				  flycheck
				  git-gutter
				  git-gutter-fringe
				  helm-lsp
				  helm-xref
				  racket-mode
				  lsp-mode
				  lsp-treemacs
				  magit
				  projectile
				  which-key
				  yasnippet))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))


(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))


(setq mac-option-modifier 'super)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(delete-selection-mode 1)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq require-final-newline t)

(require 'diminish)

(require 'helm)
(require 'helm-autoloads)
(require 'helm-xref)
(helm-mode 1)
(define-key global-map [remap find-file] #'helm-find-files)
(define-key global-map [remap execute-extended-command] #'helm-M-x)
(define-key global-map [remap switch-to-buffer] #'helm-mini)
(define-key global-map [remap bookmark-jump] #'helm-filtered-bookmarks)

(which-key-mode)
(diminish 'which-key-mode)

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (require 'dap-cpptools)
  (yas-global-mode 1))
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)

(require 'company)
(setq company-minimum-prefix-length 3
      company-idle-delay 0.2)

(setq projectile-project-search-path '("~/src"))

(setq yas-snippet-dirs
      '("~/.emacs.d/mysnippets" "~/toolbag/emacs/mysnippets"))


(elpy-enable)
(setq elpy-rpc-python-command "python3")
(setq python-shell-interpreter "python3")
(setq python-shell-completion-native-disabled-interpreters '("python3"))


;;
;; Can't be bothered with themes.
;;
(set-face-attribute 'font-lock-function-name-face nil :foreground nil :weight 'bold)
(set-face-attribute 'font-lock-keyword-face nil :foreground "blue")
(set-face-attribute 'font-lock-string-face nil :foreground "dark red")
(set-face-attribute 'font-lock-type-face nil :foreground nil)
(set-face-attribute 'font-lock-variable-name-face nil :foreground nil)
(set-face-attribute 'font-lock-variable-use-face nil :foreground nil)
(set-face-attribute 'font-lock-comment-face nil :foreground "dark green"
		    :slant 'italic)
(set-face-attribute 'font-lock-doc-face nil :inherit 'font-lock-comment-face)


;;
;; Git gutter.
;;
(require 'git-gutter)
(require 'git-gutter-fringe)
(global-git-gutter-mode t)
(diminish 'git-gutter-mode)
(setq git-gutter:update-interval 0.2)
(define-fringe-bitmap 'git-gutter-fr:added [248] nil nil '(center repeated))
(set-face-attribute 'git-gutter-fr:added nil :foreground "medium sea green")
(define-fringe-bitmap 'git-gutter-fr:modified [248] nil nil '(center repeated))
(set-face-attribute 'git-gutter-fr:modified nil :foreground "deep sky blue")
(define-fringe-bitmap 'git-gutter-fr:deleted [1 3 7 15 31 63] nil nil 'bottom)
(set-face-attribute 'git-gutter-fr:deleted nil :foreground "orange red")


(require 'paren)
(show-paren-mode 1)
(setq show-paren-delay 0.125)
(set-face-attribute 'show-paren-match nil
		    :foreground nil :background "gold" :weight 'extra-bold)


(require 'racket-mode)
(add-hook 'racket-mode-hook
          (lambda ()
            (define-key racket-mode-map (kbd "<f5>") 'racket-run)))
(add-hook 'racket-repl-mode-hook
          (lambda ()
            (define-key racket-repl-mode-map (kbd "<f5>") 'racket-run)))
(setq tab-always-indent 'complete)