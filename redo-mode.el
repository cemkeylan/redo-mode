;;; redo-mode.el --- Simple derived major mode for editing redo files
;;; -*- lexical-binding: t; -*-

;; Copyright (C) 2920  Cem Keylan

;; Author: Cem Keylan <cem@ckyln.com>
;; Keywords: redo
;; Version:  0.1.0

;; This file is not part of GNU Emacs.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this file.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; A major mode for editing .do files for the redo build system.  If flycheck is
;; loaded, it will run `flycheck-add-mode' to add `redo-mode' to 'sh-shellcheck'

;;; Code:
(require 'rx)
(require 'sh-script)

(defvar redo-mode-function-rgx
  (rx (or bol (1+ blank)) "redo" (or "" "-always" "-ifcreate" "-ifchange") word-end)
  "Highlighting regular expression sequence for redo functions.")

(defvar redo-mode-other-word-rgx
  (rx (regex redo-mode-function-rgx)
      (1+ not-wordchar) (group (1+ word) (0+ (or word blank))))
  "Highlighting regular expression sequence for redo targets.")

(defvar redo-mode-font-lock-keywords
      (list `(,redo-mode-function-rgx . font-lock-function-name-face)
            `(,redo-mode-other-word-rgx . (1 font-lock-keyword-face))))

(with-eval-after-load 'flycheck
  (flycheck-add-mode 'sh-shellcheck 'redo-mode))

;;;###autoload
(define-derived-mode redo-mode sh-mode "Redo"
  "A major mode for editing 'redo' build system files."
  (sh-set-shell "sh")
  (font-lock-add-keywords nil redo-mode-font-lock-keywords))

;;;###autoload
(add-to-list 'auto-mode-alist (cons "\\.do\\'" 'redo-mode))

(provide 'redo-mode)
;;; redo-mode.el ends here
