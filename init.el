(require 'package)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;;'(minimap-mode nil)
 '(nyan-mode t)
 '(package-selected-packages
   (quote
    (bison-mode fancy-battery treemacs lsp-java hydra clang-format neotree dap-mode nyan-mode helm minimap ivy lsp-ui company-lsp use-package cquery lsp-mode ## buffer-move atom-one-dark-theme atom-dark-theme exwm))))
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


(defun clang-format-current-file ()
  (interactive)
  (save-buffer)
  (shell-command 
   (format "~/dev/llvm/build/install/bin/clang-format -i %s" 
	   (shell-quote-argument (buffer-file-name))
	   )
   )
  )
(define-key global-map (kbd "M-f") 'clang-format-current-file)
;; Auto-reload buffers
(global-auto-revert-mode t)


(defun neotree-project-dir-toggle ()
  "Open NeoTree using the project root, using find-file-in-project,
or the current buffer directory."
  (interactive)
  (let ((project-dir
         (ignore-errors
           ;;; Pick one: projectile or find-file-in-project
           ; (projectile-project-root)
           (ffip-project-root)
           ))
        (file-name (buffer-file-name))
        (neo-smart-open t))
    (if (and (fboundp 'neo-global--window-exists-p)
             (neo-global--window-exists-p))
        (neotree-hide)
      (progn
        (neotree-show)
        (if project-dir
            (neotree-dir project-dir))
        (if file-name
            (neotree-find file-name))))))

(define-key global-map (kbd "M-t") 'neotree-project-dir-toggle)

(define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
(define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)


(defun duplicate-line()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank)
  )


(define-minor-mode my-mode
  "A minor mode so that my key settings override annoying major modes."
  :init-value t
  :lighter "my-mode"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "C-d") 'duplicate-line)
            map))

(define-globalized-minor-mode global-my-mode my-mode my-mode)
(add-hook 'text-mode-hook 'my-mode)

;(add-to-list 'emulation-mode-map-alists `((my-mode . ,my-mode-map)))
	     
;(global-set-key (kbd "C-d") 'duplicate-line)
;(define-key global-map (kbd "C-d") 'duplicate-line)
