(defconst haskell-eglot-packages
  '(
    eglot
    haskell-mode
    vertico
    consult
    marginalia
    orderless
    ctrlf
    prescient
    )
  "The list of Lisp packages required by the eglot layer.
Each entry is either:
1. A symbol, which is interpreted as a package to be installed, or
2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.
    The following keys are accepted:
    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil
    - :location: Specify a custom installation location.
      The following values are legal:
      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.
      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'
      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")

(defun haskell-eglot/init-eglot ()
  (use-package eglot
  :hook ((go-mode . eglot-ensure)
         (haskell-mode . eglot-ensure)
         (rust-mode . eglot-ensure))
  :bind (:map eglot-mode-map
              ("C-c a r" . #'eglot-rename)
              ("C-<down-mouse-1>" . #'xref-find-definitions)
              ("C-c a e" . #'xref-find-references)
              ("C-c C-c" . #'eglot-code-actions))
  :custom
  (eglot-autoshutdown t)
  )
  )

(defun haskell-eglot/init-haskell-mode ()
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




(defun haskell-eglot/init-vertico ()
	(use-package vertico
	  :config
	  (vertico-mode)
	  (vertico-mouse-mode)
	  :custom
	  (vertico-count 22)
	  :bind (:map vertico-map
		      ("C-'"       . #'vertico-quick-exit)
		      ;; Have to rebind this because C-m is translated to RET.
		      ("<return>"  . #'exit-minibuffer)
		      ("C-m"       . #'vertico-insert)
		      ("C-c SPC"   . #'vertico-quick-exit)
		      ("DEL"       . #'vertico-directory-delete-char)))
)

(defun haskell-eglot/init-consult ()
  (use-package consult
  :config
  (defun pt/yank-pop ()
    "As pt/yank, but calling consult-yank-pop."
    (interactive)
    (let ((point-before (point)))
      (consult-yank-pop)
      (indent-region point-before (point))))

  :bind (("C-c i"   . #'consult-imenu)
         ("C-c b"   . #'consult-buffer)
         ("C-x b"   . #'consult-buffer)
         ("C-c r"   . #'consult-recent-file)
         ("C-c y"   . #'pt/yank-pop)
         ("C-c R"   . #'consult-bookmark)
         ("C-c `"   . #'consult-flymake)
         ("C-c h"   . #'consult-ripgrep)
         ("C-x C-f" . #'find-file)
         ("C-h a"   . #'consult-apropos)
         )
  :custom
  (completion-in-region-function #'consult-completion-in-region)
  (xref-show-xrefs-function #'consult-xref)
  (xref-show-definitions-function #'consult-xref)
  (consult-project-root-function #'deadgrep--project-root) ;; ensure ripgrep works
  ))

(defun haskell-eglot/init-marginalia ()
  (use-package marginalia
  :config (marginalia-mode)))

(defun haskell-eglot/init-orderless ()
  (use-package orderless
  :custom (completion-styles '(orderless))))

(defun haskell-eglot/init-ctrlf ()
  (use-package ctrlf
  :config (ctrlf-mode)))

(defun haskell-eglot/init-prescient ()
 (use-package prescient
  :config (prescient-persist-mode)))
