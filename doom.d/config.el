;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

(set-frame-font "Iosevka Light 16" t t)
(setq +pretty-code-iosevka-ligatures-enabled-by-default t)
(set-pretty-symbols! 'haskell-mode :iosevka t)

(def-package! dhall-mode)
