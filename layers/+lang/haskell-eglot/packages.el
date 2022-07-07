;;; packages.el --- Haskell Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2022 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.


(setq haskell-eglot-packages
      '(
	eglot
	haskell-mode
        ))


(defun haskell-eglot-mode/init-eglot ()
  (use-package eglot
  :hook ((go-mode . eglot-ensure)
         (haskell-mode . eglot-ensure)
         (rust-mode . eglot-ensure))
  :bind (:map eglot-mode-map
              ("C-c a r" . #'eglot-rename)
              ("C-<down-mouse-1>" . #'xref-find-definitions)
              ("C-S-<down-mouse-1>" . #'xref-find-references)
              ("C-c C-c" . #'eglot-code-actions))
  :custom
  (eglot-autoshutdown t)
  )
  )

(defun haskell-eglot-mode/init-haskell-mode ()
 (use-package haskell-mode

  :config
  (defcustom haskell-formatter 'ormolu
    "The Haskell formatter to use. One of: 'ormolu, 'stylish, nil. Set it per-project in .dir-locals."
    :safe 'symbolp)

  (defun haskell-smart-format ()
    "Format a buffer based on the value of 'haskell-formatter'."
    (interactive)
    (cl-ecase haskell-formatter
      ('ormolu (ormolu-format-buffer))
      ('stylish (haskell-mode-stylish-buffer))
      (nil nil)
      ))

  (defun haskell-switch-formatters ()
    "Switch from ormolu to stylish-haskell, or vice versa."
    (interactive)
    (setq haskell-formatter
          (cl-ecase haskell-formatter
            ('ormolu 'stylish)
            ('stylish 'ormolu)
            (nil nil))))

  :bind (:map haskell-mode-map
         ("C-c a c" . haskell-cabal-visit-file)
         ("C-c a i" . haskell-navigate-imports)
         ("C-c m"   . haskell-compile)
         ("C-c a I" . haskell-navigate-imports-return)
         :map haskell-cabal-mode-map
         ("C-c m"   . haskell-compile)))
  )


