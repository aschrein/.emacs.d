(require 'package)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (atom-one-dark-theme atom-dark-theme exwm))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(require 'exwm)
(require 'exwm-config)
(exwm-config-default)
;(require 'atom-one-dark-theme)
(load-theme 'atom-one-dark t)


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

(exwm-input-set-key (kbd "s-f") #'exwm-layout-toggle-fullscreen)
