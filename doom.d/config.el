;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

(set-frame-font "Iosevka 12" t t)

(def-package! dhall-mode)
(def-package! direnv)

(direnv-mode)

(setq ivy-extra-directories nil)

(add-hook 'before-save-hook #'delete-trailing-whitespace)

(map! :n "C-h" #'evil-window-left
      :n "C-j" #'evil-window-down
      :n "C-k" #'evil-window-up
      :n "C-l" #'evil-window-right
      :n "M-s" #'save-buffer)
