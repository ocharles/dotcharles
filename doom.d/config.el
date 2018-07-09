;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

(set-frame-font "Iosevka 16" t t)

(def-package! dhall-mode)
(def-package! direnv)

(direnv-mode)

(setq ivy-extra-directories nil)

(add-hook 'before-save-hook #'delete-trailing-whitespace)
