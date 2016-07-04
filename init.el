;;; package --- Summary
;;; Commentary:
;;; Code:

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("0a8c866cb3cbcab422c631efc07b4787b857b68d399f77a76d3886e6cb821643" default))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Performance Optimization
(setq gc-cons-threshold 20000000)
(setq vc-handled-backends (delq 'Git vc-handled-backends))


;; Mode Management
(setq auto-mode-alist
      (cons '("\\.rb$" . enh-ruby-mode) auto-mode-alist))

(windmove-default-keybindings)

;; Package Management

(require 'tramp)

(require 'package) ;; You might already have this line
(add-to-list 'package-archives
	     '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line


;; Environment set up
;;(let ((path (shell-command-to-string ". ~/.bash_profile; echo -n $PATH")))
;;  (setenv "PATH" path)
;;  (setq exec-path
;;	(append
;;	(split-string-and-unquote path ":")
;;	exec-path)))

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))


;; Themes

(add-to-list 'custom-theme-load-path "~/.emacs.d/elpa/atom-one-dark-theme-0.4.0/")
(load-theme 'atom-one-dark t)

;;(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(set-frame-font "Hack-14")
(remove-hook 'enh-ruby-mode-hook 'erm-define-faces)



;; My Packages

;; Electric Pair Mode
(electric-pair-mode 1)


;; SML mode line
(setq sml/theme 'powerline)
;;(powerline-nano-theme)
(setq powerline-arrow-shape 'curve)
(setq powerline-default-separator-dir '(right . left))
(sml/setup)


;; Line Numbering
(require 'linum)
(add-hook 'ruby-mode-hook
	  (lambda ()
	    (linum-mode 1)))

(add-hook 'prog-mode-hook
	  (lambda ()
	    (linum-mode 1)))
(add-hook 'emacs-lisp-mode-hook
	  (lambda ()
	    (linum-mode 1)))

(unless window-system
  (add-hook 'linum-before-numbering-hook
	    (lambda ()
	      (setq-local linum-format-fmt
			  (let ((w (length (number-to-string
					    (count-lines (point-min) (point-max))))))
			    (concat "%" (number-to-string w) "d"))))))

(defun linum-format-func (line)
  (concat
   (propertize (format linum-format-fmt line) 'face 'linum)
   (propertize " " 'face 'mode-line)))

(unless window-system
  (setq linum-format 'linum-format-func))
(set-face-attribute 'linum nil :background "#252629" :foreground "#606570")


(set-face-attribute 'fringe nil :background "#252629" :foreground "#252629")
(fringe-mode '(10 . 0))


(add-to-list 'load-path "~/.emacs.d/elpa/hlinum-mode/")
(require 'hlinum)
(hlinum-activate)
(set-face-attribute 'linum-highlight-face nil :foreground "#DDDDDD" :background "#343942")

(add-to-list 'load-path "~/.emacs.d/elpa/highlight-current-line/")
(require 'highlight-current-line)
;;(highlight-curent-line-face "#454750")
(set-face-attribute 'highlight-current-line-face nil :background "#303540")
(add-hook 'ruby-mode-hook 'highlight-current-line-minor-mode)
(add-hook 'enh-ruby-mode-hook 'highlight-current-line-minor-mode)
(add-hook 'emacs-lisp-mode-hook 'highlight-current-line-minor-mode)


;; Robe mode
(autoload 'inf-ruby-minor-mode "inf-ruby" "Run an inferior Ruby process" t)
(add-hook 'ruby-mode-hook 'inf-ruby-minor-mode)
(add-hook 'enh-ruby-mode-hook 'inf-ruby-minor-mode)
(add-hook 'compilation-filter-hook 'inf-ruby-auto-enter)

(add-hook 'ruby-mode-hook 'robe-mode)
(add-hook 'enh-ruby-mode-hook 'robe-mode)
(eval-after-load 'auto-complete
  '(add-to-list 'ac-modes 'inf-ruby-mode))
(add-hook 'inf-ruby-mode-hook 'ac-inf-ruby-enable)
(add-hook 'robe-mode-hook 'ac-robe-setup)


;; Ruby Electric
;;(eval-after-load "ruby-mode"
;;  '(add-hook 'ruby-mode-hook 'ruby-electric-mode))
;;(eval-after-load "enh-ruby-mode"
;;  '(add-hook 'enh-ruby-mode-hook 'ruby-electric-mode))


;; IDO mode
(require 'ido-vertical-mode)
(require 'flx-ido)
(ido-mode 1)
(ido-vertical-mode 1)
(ido-everywhere t)
(setq ido-vertical-define-keys 'C-n-C-p-up-down-left-right)
(flx-ido-mode 1)
(setq ido-enable-flex-matching t)
(setq ido-faces nil)


;; Projectile
;;(projectile-global-mode)
(add-hook 'ruby-mode-hook 'projectile-mode)
(add-hook 'enh-ruby-mode-hook 'projectile-mode)
(add-hook 'web-mode-hook 'projectile-mode)
(add-hook 'projectile-mode-hook 'projectile-rails-on)
;;(setq projectile-rails-add-keywords nil)


;; dirty fix for having AC everywhere
(define-globalized-minor-mode real-global-auto-complete-mode
  auto-complete-mode (lambda ()
                       (if (not (minibufferp (current-buffer)))
                         (auto-complete-mode 1))
                       ))
(real-global-auto-complete-mode t)


;; web-mode stuff
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;;(setq web-mode-engines-alist
;;      '("erb" . "\\.erb\\'"))

(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  )

(setq web-mode-extra-auto-pairs
      '(("erb" . (("beg" "end")))
	))
(setq web-mode-enable-auto-pairing t)

(add-hook 'web-mode-hook 'my-web-mode-hook)

;; Emmet mode
(add-to-list 'load-path "~/.emacs.d/my_packages/emmet-mode/")
(require 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode)
(add-hook 'web-mode-hook 'emmet-mode)
(add-hook 'css-mode-hook  'emmet-mode)
(setq emmet-move-cursor-between-quotes t)


;; Yasnippet
(add-to-list 'load-path "~/.emacs.d/my_packages/yasnippet/")
(require 'yasnippet)
(setq yas-snippet-dirs
      '("~/.emacs.d/snippets"
        "~/.emacs.d/my_packages/yasnippet/snippets"))
(yas-reload-all)
(add-hook 'web-mode-hook #'yas-minor-mode)
(add-hook 'enh-ruby-mode-hook #'yas-minor-mode)
(add-hook 'javascript-mode-hook #'yas-minor-mode)


;;Org mode
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)


;; EWW lnum
(eval-after-load "eww"
  '(progn (define-key eww-mode-map "f" 'eww-lnum-follow)
	  (define-key eww-mode-map "F" 'eww-lnum-universal)))


;; Flycheck
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)


;; Diff-hl
(require 'diff-hl)
(add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)


;; Comments toggle
(defun comment-or-uncomment-region-or-line ()
    "Comments or uncomments the region or the current line if there's no active region."
    (interactive)
    (let (beg end)
        (if (region-active-p)
            (setq beg (region-beginning) end (region-end))
            (setq beg (line-beginning-position) end (line-end-position)))
        (comment-or-uncomment-region beg end)))


;; key bindings

(when (eq system-type 'darwin) ;; mac specific settings
  (setq mac-option-modifier 'meta)
  (setq mac-command-modifier 'control)
  (setq mac-right-command-modifier 'control)
  (setq mac-right-option-modifier 'meta)
  )

;;; For Ruby Robe
(global-set-key (kbd "C-c C-r") 'ruby-send-region)
(global-set-key (kbd "C-c C-l") 'ruby-load-file)

(global-set-key (kbd "C-x g") 'magit-status)

(global-set-key (kbd "C-3") 'comment-or-uncomment-region-or-line)

(provide 'init)
;;; init.el ends here
