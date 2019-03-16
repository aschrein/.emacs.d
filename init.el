(require 'package)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(minimap-mode nil)
 '(package-selected-packages
   (quote
    (neotree dap-mode nyan-mode helm minimap ivy lsp-ui company-lsp use-package cquery lsp-mode ## buffer-move atom-one-dark-theme atom-dark-theme exwm))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)


;; A list of packages installed on my machine
;; Updating it is a manual process 
(setq package-reqs '(neotree dap-mode tree-mode bui nyan-mode helm popup helm-core async minimap ivy atom-dark-theme atom-one-dark-theme buffer-move company-lsp company cquery exwm lsp-ui lsp-mode ht f dash-functional dash markdown-mode s spinner use-package bind-key xelb))
(unless package-archive-contents (package-refresh-contents))
(dolist (package package-reqs)
  (unless (package-installed-p package)
	  (package-install package))
  )
;;
;;

(require 'exwm)
(require 'exwm-config)
(require 'buffer-move)
(exwm-config-default)
;(require 'atom-one-dark-theme)
(load-theme 'atom-one-dark t)
(use-package lsp-mode)
(use-package lsp-ui
  :init (add-hook 'lsp-mode-hook 'lsp-ui-mode)
  )
(use-package company-lsp
  :ensure t
  :config
  (push 'company-lsp company-backends))
(setq cquery-executable "/home/aschrein/dev/cquery/build/release/bin/cquery")
(with-eval-after-load 'projectile
  (setq projectile-project-root-files-top-down-recurring
        (append '("compile_commands.json"
                  ".cquery")
                projectile-project-root-files-top-down-recurring)))
(defun cquery//enable ()
  (condition-case nil
      (lsp)
    (user-error nil)))

(use-package cquery
	     :commands lsp
	     :init (add-hook 'c-mode-hook #'cquery//enable)
             (add-hook 'c++-mode-hook #'cquery//enable))

;(add-hook 'exwm-manage-finish-hook
;  (lambda () (call-interactively #'exwm-input-release-keyboard)
;     (exwm-layout-hide-mode-line)))

(defun second (list) (car (cdr list)))

(defun aschrein/exwm-char-mode ()
  (interactive)
  (setq exwm-input-line-mode-passthrough nil)
  (call-interactively #'exwm-input-release-keyboard)
  (force-mode-line-update))

(defun aschrein/exwm-line-mode ()
  (interactive)
  (setq exwm-input-line-mode-passthrough nil)
  (call-interactively #'exwm-input-grab-keyboard)
  (force-mode-line-update))

(defun aschrein/exwm-nomode ()
  (interactive)
  (setq exwm-input-line-mode-passthrough t)
  (call-interactively #'exwm-input-grab-keyboard)
  (force-mode-line-update))

(exwm-input-set-key (kbd "s-1") 'aschrein/exwm-char-mode)
(exwm-input-set-key (kbd "s-2") 'aschrein/exwm-line-mode)
(exwm-input-set-key (kbd "s-3") 'aschrein/exwm-nomode)

(global-set-key (kbd "s-k") #'windmove-down)
(global-set-key (kbd "s-i") #'windmove-up)
(global-set-key (kbd "s-j") #'windmove-left)
(global-set-key (kbd "s-l") #'windmove-right)

(exwm-input-set-key (kbd "s-f") #'exwm-layout-toggle-fullscreen)
(exwm-input-set-key (kbd "s-l") #'windmove-right)
(exwm-input-set-key (kbd "s-j") #'windmove-left)
(exwm-input-set-key (kbd "s-i") #'windmove-up)
(exwm-input-set-key (kbd "s-k") #'windmove-down)

(set-face-attribute 'default nil
                    :family "Source Code Pro"
                    :height 110
                    :weight 'normal
                    :width 'normal)


(show-paren-mode 1)
(ido-mode 1)
(setq ido-separator "\n")
(exwm-input-set-key (kbd "s-<right>") #'buf-move-right)
(exwm-input-set-key (kbd "s-<left>") #'buf-move-left)
(exwm-input-set-key (kbd "s-<up>") #'buf-move-up)
(exwm-input-set-key (kbd "s-<down>") #'buf-move-down)
(exwm-input-set-key (kbd "s-b") #'helm-buffers-list)
					;(split-window-below)
;(split-window-right)
;(global-set-key (kbd "H-o") #'other-window)
(defun exec-current-file ()
  "run a command on the current file"
  (interactive)
  (save-buffer)
  (shell-command 
   (format "sbcl --script %s" 
	   (shell-quote-argument (buffer-file-name))
	   )
   )
  )
(global-set-key (kbd "s-e") 'exec-current-file)
