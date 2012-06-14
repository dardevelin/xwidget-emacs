;;; Todos.el --- facilities for making and maintaining Todo lists

;; Copyright (C) 1997, 1999, 2001-2012  Free Software Foundation, Inc.

;; Author: Oliver Seidel <privat@os10000.net>
;;         Stephen Berman <stephen.berman@gmx.net>
;; Maintainer: Stephen Berman <stephen.berman@gmx.net>
;; Created: 2 Aug 1997
;; Keywords: calendar, todo

;; This file is [not yet] part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

(require 'diary-lib)
;; For remove-duplicates in todos-insertion-commands-args.
(eval-when-compile (require 'cl))

;; ---------------------------------------------------------------------------
;;; User options

(defgroup todos nil
  "Create and maintain categorized lists of todo items."
  :link '(emacs-commentary-link "todos")
  :version "24.2"
  :group 'calendar)

(defcustom todos-files-directory (locate-user-emacs-file "todos/")
  "Directory where user's Todos files are saved."
  :type 'directory
  :group 'todos)

(defun todos-files (&optional archives)
  "Default value of `todos-files-function'.
This returns the case-insensitive alphabetically sorted list of
file truenames in `todos-files-directory' with the extension
\".todo\".  With non-nil ARCHIVES return the list of archive file
truenames (those with the extension \".toda\")."
  (let ((files (if (file-exists-p todos-files-directory)
		   (mapcar 'file-truename
		    (directory-files todos-files-directory t
				     (if archives "\.toda$" "\.todo$") t)))))
    (sort files (lambda (s1 s2) (let ((cis1 (upcase s1))
				      (cis2 (upcase s2)))
				  (string< cis1 cis2))))))

(defcustom todos-files-function 'todos-files
  "Function returning the value of the variable `todos-files'.
This function should take an optional argument that, if non-nil,
makes it return the value of the variable `todos-archives'."
  :type 'function
  :group 'todos)

(defun todos-short-file-name (file)
  "Return short form of Todos FILE.
This lacks the extension and directory components."
  (file-name-sans-extension (file-name-nondirectory file)))

(defcustom todos-default-todos-file (car (funcall todos-files-function))
  "Todos file visited by first session invocation of `todos-show'."
  :type `(radio ,@(mapcar (lambda (f) (list 'const f))
			  (mapcar 'todos-short-file-name
				  (funcall todos-files-function))))
  :group 'todos)

;; FIXME: is there a better alternative to this?
(defun todos-reevaluate-default-file-defcustom ()
  "Reevaluate defcustom of `todos-default-todos-file'.
Called after adding or deleting a Todos file."
  (eval (defcustom todos-default-todos-file (car (funcall todos-files-function))
	  "Todos file visited by first session invocation of `todos-show'."
	  :type `(radio ,@(mapcar (lambda (f) (list 'const f))
				  (mapcar 'todos-short-file-name
					  (funcall todos-files-function))))
	  :group 'todos)))

(defcustom todos-show-current-file t
  "Non-nil to make `todos-show' visit the current Todos file.
Otherwise, `todos-show' always visits `todos-default-todos-file'."
  :type 'boolean
  :initialize 'custom-initialize-default
  :set 'todos-set-show-current-file
  :group 'todos)

(defun todos-set-show-current-file (symbol value)
  "The :set function for user option `todos-show-current-file'."
  (custom-set-default symbol value)
  (if value
      (add-hook 'pre-command-hook 'todos-show-current-file nil t)
    (remove-hook 'pre-command-hook 'todos-show-current-file t)))

(defcustom todos-visit-files-commands (list 'find-file 'dired-find-file)
  "List of file finding commands for `todos-display-as-todos-file'.
Invoking these commands to visit a Todos or Todos Archive file
calls `todos-show' or `todos-show-archive', so that the file is
displayed correctly."
  :type '(repeat function)
  :group 'todos)

(defcustom todos-initial-file "Todo"
  "Default file name offered on adding first Todos file."
  :type 'string
  :group 'todos)

(defcustom todos-initial-category "Todo"
  "Default category name offered on initializing a new Todos file."
  :type 'string
  :group 'todos)

(defcustom todos-display-categories-first nil
  "Non-nil to display category list on first visit to a Todos file."
  :type 'boolean
  :group 'todos)

(defcustom todos-prefix ""
  "String prefixed to todo items for visual distinction."
  :type 'string
  :initialize 'custom-initialize-default
  :set 'todos-reset-prefix
  :group 'todos)

(defcustom todos-number-priorities t
  "Non-nil to prefix items with consecutively increasing integers.
These reflect the priorities of the items in each category."
  :type 'boolean
  :initialize 'custom-initialize-default
  :set 'todos-reset-prefix
  :group 'todos)

(defun todos-reset-prefix (symbol value)
  "The :set function for `todos-prefix' and `todos-number-priorities'."
  (let ((oldvalue (symbol-value symbol))
	(files (append todos-files todos-archives)))
    (custom-set-default symbol value)
    (when (not (equal value oldvalue))
      (dolist (f files)
	(with-current-buffer (find-file-noselect f)
	  (save-window-excursion
	    (todos-show)
	    (save-excursion
	      (widen)
	      (goto-char (point-min))
	      (while (not (eobp))
		(remove-overlays (point) (point)); 'before-string prefix)
		(forward-line)))
	    ;; Activate the new setting (save-restriction does not help).
	    (save-excursion (todos-category-select))))))))

(defcustom todos-done-separator-string "_"
  "String for generating `todos-done-separator'.

If the string consists of a single character,
`todos-done-separator' will be the string made by repeating this
character for the width of the window, and the length is
automatically recalculated when the window width changes.  If the
string consists of more (or less) than one character, it will be
the value of `todos-done-separator'."
  :type 'string
  :initialize 'custom-initialize-default
  :set 'todos-reset-done-separator-string
  :group 'todos)

(defun todos-reset-done-separator-string (symbol value)
  "The :set function for `todos-done-separator-string'."
  (let ((oldvalue (symbol-value symbol))
	(files todos-file-buffers)
	(sep todos-done-separator))
    (custom-set-default symbol value)
    (setq todos-done-separator (todos-done-separator))
    ;; Replace any existing separator string overlays.
    (when (not (equal value oldvalue))
      (dolist (f files)
	(with-current-buffer (find-buffer-visiting f)
	  (save-excursion
	    (save-restriction
	      (widen)
	      (goto-char (point-min))
	      (while (re-search-forward (concat "\n\\("
						(regexp-quote todos-category-done)
						"\\)") nil t)
		(setq beg (match-beginning 1))
		(setq end (match-end 0))
		(let* ((ovs (overlays-at beg))
		       old-sep new-sep)
		  (and ovs
		       (setq old-sep (overlay-get (car ovs) 'display))
		       (string= old-sep sep)
		       (delete-overlay (car ovs))
		       (setq new-sep (make-overlay beg end))
		       (overlay-put new-sep 'display
				    todos-done-separator)))))))))))

(defcustom todos-done-string "DONE "
  "Identifying string appended to the front of done todos items."
  :type 'string
  :initialize 'custom-initialize-default
  :set 'todos-reset-done-string
  :group 'todos)

(defun todos-reset-done-string (symbol value)
  "The :set function for user option `todos-done-string'."
  (let ((oldvalue (symbol-value symbol))
	(files (append todos-files todos-archives)))
    (custom-set-default symbol value)
    ;; Need to reset this to get font-locking right.
    (setq todos-done-string-start
	  (concat "^\\[" (regexp-quote todos-done-string)))
    (when (not (equal value oldvalue))
      (dolist (f files)
	(with-current-buffer (find-file-noselect f)
	  (let (buffer-read-only)
	    (widen)
	    (goto-char (point-min))
	    (while (not (eobp))
	      (if (re-search-forward
		   (concat "^" (regexp-quote todos-nondiary-start)
			   "\\(" (regexp-quote oldvalue) "\\)")
		   nil t)
		  (replace-match value t t nil 1)
		(forward-line)))
	    (todos-category-select)))))))

(defcustom todos-comment-string "COMMENT"
  "String inserted before optional comment appended to done item."
  :type 'string
  :initialize 'custom-initialize-default
  :set 'todos-reset-comment-string
  :group 'todos)

(defun todos-reset-comment-string (symbol value)
  "The :set function for user option `todos-comment-string'."
  (let ((oldvalue (symbol-value symbol))
  	(files (append todos-files todos-archives)))
    (custom-set-default symbol value)
    (when (not (equal value oldvalue))
      (dolist (f files)
  	(with-current-buffer (find-file-noselect f)
  	  (let (buffer-read-only)
  	    (save-excursion
	      (widen)
	      (goto-char (point-min))
	      (while (not (eobp))
		(if (re-search-forward
		     (concat
			     "\\[\\(" (regexp-quote oldvalue) "\\): [^]]*\\]")
		     nil t)
		    (replace-match value t t nil 1)
		  (forward-line)))
	      (todos-category-select))))))))

(defcustom todos-show-with-done nil
  "Non-nil to display done items in all categories."
  :type 'boolean
  :group 'todos)

(defun todos-mode-line-control (cat)
  "Return a mode line control for Todos buffers.
Argument CAT is the name of the current Todos category.
This function is the value of the user variable
`todos-mode-line-function'."
  (let ((file (todos-short-file-name todos-current-todos-file)))
    (format "%s category %d: %s" file todos-category-number cat)))

(defcustom todos-mode-line-function 'todos-mode-line-control
  "Function that returns a mode line control for Todos buffers.
The function expects one argument holding the name of the current
Todos category.  The resulting control becomes the local value of
`mode-line-buffer-identification' in each Todos buffer."
  :type 'function
  :group 'todos)

(defcustom todos-skip-archived-categories nil
  "Non-nil to skip categories with only archived items when browsing.

Moving by category todos or archive file (with
\\[todos-forward-category] and \\[todos-backward-category]) skips
categories that contain only archived items.  Other commands
still recognize these categories.  In Todos Categories
mode (reached with \\[todos-display-categories]) these categories
shown in `todos-archived-only' face and clicking them in Todos
Categories mode visits the archived categories."
  :type 'boolean
  :group 'todos)

(defcustom todos-use-only-highlighted-region t
  "Non-nil to enable inserting only highlighted region as new item."
  :type 'boolean
  :group 'todos)

(defcustom todos-include-in-diary nil
  "Non-nil to allow new Todo items to be included in the diary."
  :type 'boolean
  :group 'todos)

(defcustom todos-diary-nonmarking nil
  "Non-nil to insert new Todo diary items as nonmarking by default.
This appends `diary-nonmarking-symbol' to the front of an item on
insertion provided it doesn't begin with `todos-nondiary-marker'."
  :type 'boolean
  :group 'todos)

(defcustom todos-nondiary-marker '("[" "]")
  "List of strings surrounding item date to block diary inclusion.
The first string is inserted before the item date and must be a
non-empty string that does not match a diary date in order to
have its intended effect.  The second string is inserted after
the diary date."
  :type '(list string string)
  :group 'todos
  :initialize 'custom-initialize-default
  :set 'todos-reset-nondiary-marker)

(defun todos-reset-nondiary-marker (symbol value)
  "The :set function for user option `todos-nondiary-marker'."
  (let ((oldvalue (symbol-value symbol))
	(files (append todos-files todos-archives)))
    (custom-set-default symbol value)
    ;; Need to reset these to get font-locking right.
    (setq todos-nondiary-start (nth 0 todos-nondiary-marker)
	  todos-nondiary-end (nth 1 todos-nondiary-marker)
	  todos-date-string-start
	  ;; See comment in defvar of `todos-date-string-start'.
	  (concat "^\\(" (regexp-quote todos-nondiary-start) "\\|"
		  (regexp-quote diary-nonmarking-symbol) "\\)?"))
    (when (not (equal value oldvalue))
      (dolist (f files)
	(with-current-buffer (find-file-noselect f)
	  (let (buffer-read-only)
	    (widen)
	    (goto-char (point-min))
	    (while (not (eobp))
	      (if (re-search-forward
		   (concat "^\\(" todos-done-string-start "[^][]+] \\)?"
			   "\\(?1:" (regexp-quote (car oldvalue))
			   "\\)" todos-date-pattern "\\( "
			   diary-time-regexp "\\)?\\(?2:"
			   (regexp-quote (cadr oldvalue)) "\\)")
		   nil t)
		  (progn
		    (replace-match (nth 0 value) t t nil 1)
		    (replace-match (nth 1 value) t t nil 2))
		(forward-line)))
	    (todos-category-select)))))))

(defcustom todos-always-add-time-string nil
  "Non-nil adds current time to a new item's date header by default.
When the Todos insertion commands have a non-nil \"maybe-notime\"
argument, this reverses the effect of
`todos-always-add-time-string': if t, these commands omit the
current time, if nil, they include it."
  :type 'boolean
  :group 'todos)

(defcustom todos-completion-ignore-case nil
  "Non-nil means case of user input in `todos-read-*' is ignored."
  :type 'boolean
  :group 'todos)

(defcustom todos-highlight-item nil
  "Non-nil means highlight items at point."
  :type 'boolean
  :initialize 'custom-initialize-default
  :set 'todos-reset-highlight-item
  :group 'todos)

(defun todos-reset-highlight-item (symbol value)
  "The :set function for `todos-highlight-item'."
  (let ((oldvalue (symbol-value symbol))
	(files (append todos-files todos-archives)))
    (custom-set-default symbol value)
    (when (not (equal value oldvalue))
      (dolist (f files)
	(let ((buf (find-buffer-visiting f)))
	  (when buf
	    (with-current-buffer buf
	      (require 'hl-line)
	      (if value
		  (hl-line-mode 1)
		(hl-line-mode -1)))))))))

(defcustom todos-wrap-lines t
  "Non-nil to wrap long lines via `todos-line-wrapping-function'."
  :group 'todos
  :type 'boolean)

(defcustom todos-line-wrapping-function 'todos-wrap-and-indent
  "Line wrapping function used with non-nil `todos-wrap-lines'."
  :group 'todos
  :type 'function)

(defun todos-wrap-and-indent ()
  "Use word wrapping on long lines and indent with a wrap prefix.
The amount of indentation is given by user option
`todos-indent-to-here'."
  (set (make-local-variable 'word-wrap) t)
  (set (make-local-variable 'wrap-prefix) (make-string todos-indent-to-here 32))
  (unless (member '(continuation) fringe-indicator-alist)
    (push '(continuation) fringe-indicator-alist)))

;; FIXME: :set function (otherwise change takes effect only after killing and
;; revisiting file)
(defcustom todos-indent-to-here 6
  "Number of spaces `todos-line-wrapping-function' indents to."
  :type '(integer :validate
		  (lambda (widget)
		    (unless (> (widget-value widget) 0)
		      (widget-put widget :error
				  "Invalid value: must be a positive integer")
		      widget)))
  :group 'todos)

(defun todos-indent ()
  "Indent from point to `todos-indent-to-here'."
  (indent-to todos-indent-to-here todos-indent-to-here))

(defcustom todos-todo-mode-date-time-regexp
  (concat "\\(?1:[0-9]\\{4\\}\\)-\\(?2:[0-9]\\{2\\}\\)-"
	  "\\(?3:[0-9]\\{2\\}\\) \\(?4:[0-9]\\{2\\}:[0-9]\\{2\\}\\)")
  "Regexp matching legacy todo-mode.el item date-time strings.
In order for `todos-convert-legacy-files' to correctly convert this
string to the current Todos format, the regexp must contain four
explicitly numbered groups (see `(elisp) Regexp Backslash'),
where group 1 matches a string for the year, group 2 a string for
the month, group 3 a string for the day and group 4 a string for
the time.  The default value converts date-time strings built
using the default value of `todo-time-string-format' from
todo-mode.el."
  :type 'regexp
  :group 'todos)

(defcustom todos-print-function 'ps-print-buffer-with-faces
  "Function called to print buffer content; see `todos-print'."
  :type 'symbol
  :group 'todos)

(defgroup todos-filtered nil
  "User options for Todos Filter Items mode."
  :version "24.2"
  :group 'todos)

(defcustom todos-filtered-items-buffer "Todos filtered items"
  "Initial name of buffer in Todos Filter Items mode."
  :type 'string
  :group 'todos-filtered)

(defcustom todos-top-priorities-buffer "Todos top priorities"
  "Buffer type string for `todos-filtered-buffer-name'."
  :type 'string
  :group 'todos-filtered)

(defcustom todos-diary-items-buffer "Todos diary items"
  "Buffer type string for `todos-filtered-buffer-name'."
  :type 'string
  :group 'todos-filtered)

(defcustom todos-regexp-items-buffer "Todos regexp items"
  "Buffer type string for `todos-filtered-buffer-name'."
  :type 'string
  :group 'todos-filtered)

(defcustom todos-priorities-rules nil
  "List of rules giving how many items `todos-top-priorities' shows.
This variable should be set interactively by
`\\[todos-set-top-priorities-in-file]' or
`\\[todos-set-top-priorities-in-category]'.

Each rule is a list of the form (FILE NUM ALIST), where FILE is a
member of `todos-files', NUM is a number specifying the default
number of top priority items for each category in that file, and
ALIST, when non-nil, consists of conses of a category name in
FILE and a number specifying the default number of top priority
items in that category, which overrides NUM."
  :type 'list
  :group 'todos-filtered)

(defcustom todos-show-priorities 1
  "Default number of top priorities shown by `todos-top-priorities'."
  :type 'integer
  :group 'todos-filtered)

(defcustom todos-filter-files nil
  "List of default files for multifile item filtering."
  :type `(set ,@(mapcar (lambda (f) (list 'const f))
			(mapcar 'todos-short-file-name
				(funcall todos-files-function))))
  :group 'todos-filtered)

;; FIXME: is there a better alternative to this?
(defun todos-reevaluate-filter-files-defcustom ()
  "Reevaluate defcustom of `todos-filter-files'.
Called after adding or deleting a Todos file."
  (eval (defcustom todos-filter-files nil
	  "List of files for multifile item filtering."
	  :type `(set ,@(mapcar (lambda (f) (list 'const f))
				(mapcar 'todos-short-file-name
					(funcall todos-files-function))))
	  :group 'todos)))

(defcustom todos-filter-done-items nil
  "Non-nil to include done items when processing regexp filters.
Done items from corresponding archive files are also included."
  :type 'boolean
  :group 'todos-filtered)

(defgroup todos-categories nil
  "User options for Todos Categories mode."
  :version "24.2"
  :group 'todos)

(defcustom todos-categories-category-label "Category"
  "Category button label in Todos Categories mode."
  :type 'string
  :group 'todos-categories)

(defcustom todos-categories-todo-label "Todo"
  "Todo button label in Todos Categories mode."
  :type 'string
  :group 'todos-categories)

(defcustom todos-categories-diary-label "Diary"
  "Diary button label in Todos Categories mode."
  :type 'string
  :group 'todos-categories)

(defcustom todos-categories-done-label "Done"
  "Done button label in Todos Categories mode."
  :type 'string
  :group 'todos-categories)

(defcustom todos-categories-archived-label "Archived"
  "Archived button label in Todos Categories mode."
  :type 'string
  :group 'todos-categories)

(defcustom todos-categories-totals-label "Totals"
  "String to label total item counts in Todos Categories mode."
  :type 'string
  :group 'todos-categories)

(defcustom todos-categories-number-separator " | "
  "String between number and category in Todos Categories mode.
This separates the number from the category name in the default
categories display according to priority."
  :type 'string
  :group 'todos-categories)

(defcustom todos-categories-align 'center
  "Alignment of category names in Todos Categories mode."
  :type '(radio (const left) (const center) (const right))
  :group 'todos-categories)

;; ---------------------------------------------------------------------------
;;; Faces and font-locking

(defgroup todos-faces nil
  "Faces for the Todos modes."
  :version "24.2"
  :group 'todos)

(defface todos-prefix-string
  ;; '((t :inherit font-lock-constant-face))
  '((((class grayscale) (background light))
     (:foreground "LightGray" :weight bold :underline t))
    (((class grayscale) (background dark))
     (:foreground "Gray50" :weight bold :underline t))
    (((class color) (min-colors 88) (background light)) (:foreground "dark cyan"))
    (((class color) (min-colors 88) (background dark)) (:foreground "Aquamarine"))
    (((class color) (min-colors 16) (background light)) (:foreground "CadetBlue"))
    (((class color) (min-colors 16) (background dark)) (:foreground "Aquamarine"))
    (((class color) (min-colors 8)) (:foreground "magenta"))
    (t (:weight bold :underline t)))
  "Face for Todos prefix string."
  :group 'todos-faces)

(defface todos-mark
  ;; '((t :inherit font-lock-warning-face))
  '((((class color)
      (min-colors 88)
      (background light))
     (:weight bold :foreground "Red1"))
    (((class color)
      (min-colors 88)
      (background dark))
     (:weight bold :foreground "Pink"))
    (((class color)
      (min-colors 16)
      (background light))
     (:weight bold :foreground "Red1"))
    (((class color)
      (min-colors 16)
      (background dark))
     (:weight bold :foreground "Pink"))
    (((class color)
      (min-colors 8))
     (:foreground "red"))
    (t
     (:weight bold :inverse-video t)))
  "Face for marks on Todos items."
  :group 'todos-faces)

(defface todos-button
  ;; '((t :inherit widget-field))
  '((((type tty))
     (:foreground "black" :background "yellow3"))
    (((class grayscale color)
      (background light))
     (:background "gray85"))
    (((class grayscale color)
      (background dark))
     (:background "dim gray"))
    (t
     (:slant italic)))
  "Face for buttons in todos-display-categories."
  :group 'todos-faces)

(defface todos-sorted-column
  '((((class color)
      (background light))
     (:background "grey85"))
    (((class color)
      (background dark))
     ;; FIXME: make foreground dark, else illegible
     (:background "grey10"))
    (t
     (:background "gray")))
  "Face for buttons in todos-display-categories."
  :group 'todos-faces)

(defface todos-archived-only
  ;; '((t (:inherit (shadow))))
  '((((class color)
      (background light))
     (:foreground "grey50"))
    (((class color)
      (background dark))
     (:foreground "grey70"))
    (t
     (:foreground "gray")))
  "Face for archived-only categories in todos-display-categories."
  :group 'todos-faces)

(defface todos-search
  ;; '((t :inherit match))
  '((((class color)
      (min-colors 88)
      (background light))
     (:background "yellow1"))
    (((class color)
      (min-colors 88)
      (background dark))
     (:background "RoyalBlue3"))
    (((class color)
      (min-colors 8)
      (background light))
     (:foreground "black" :background "yellow"))
    (((class color)
      (min-colors 8)
      (background dark))
     (:foreground "white" :background "blue"))
    (((type tty)
      (class mono))
     (:inverse-video t))
    (t
     (:background "gray")))
  "Face for matches found by todos-search."
  :group 'todos-faces)

(defface todos-diary-expired
  ;; '((t :inherit font-lock-warning-face))
  '((((class color)
      (min-colors 16))
     (:weight bold :foreground "DarkOrange"))
    (((class color))
     (:weight bold :foreground "yellow"))
    (t
     (:weight bold)))
  "Face for expired dates of diary items."
  :group 'todos-faces)
(defvar todos-diary-expired-face 'todos-diary-expired)

(defface todos-date
  '((t :inherit diary))
  "Face for the date string of a Todos item."
  :group 'todos-faces)
(defvar todos-date-face 'todos-date)

(defface todos-time
  '((t :inherit diary-time))
  "Face for the time string of a Todos item."
  :group 'todos-faces)
(defvar todos-time-face 'todos-time)

(defface todos-done
  ;; '((t :inherit font-lock-comment-face))
  '((((class grayscale)
      (background light))
     (:slant italic :weight bold :foreground "DimGray"))
    (((class grayscale)
      (background dark))
     (:slant italic :weight bold :foreground "LightGray"))
    (((class color)
      (min-colors 88)
      (background light))
     (:foreground "Firebrick"))
    (((class color)
      (min-colors 88)
      (background dark))
     (:foreground "chocolate1"))
    (((class color)
      (min-colors 16)
      (background light))
     (:foreground "red"))
    (((class color)
      (min-colors 16)
      (background dark))
     (:foreground "red1"))
    (((class color)
      (min-colors 8)
      (background light))
     (:foreground "red"))
    (((class color)
      (min-colors 8)
      (background dark))
     (:foreground "yellow"))
    (t
     (:slant italic :weight bold)))
  "Face for done Todos item header string."
  :group 'todos-faces)
(defvar todos-done-face 'todos-done)

(defface todos-comment
  '((t :inherit todos-done))
  "Face for comments appended to done Todos items."
  :group 'todos-faces)
(defvar todos-comment-face 'todos-comment)

(defface todos-done-sep
  ;; '((t :inherit font-lock-type-face))
  '((((class grayscale)
      (background light))
     (:weight bold :foreground "Gray90"))
    (((class grayscale)
      (background dark))
     (:weight bold :foreground "DimGray"))
    (((class color)
      (min-colors 88)
      (background light))
     (:foreground "ForestGreen"))
    (((class color)
      (min-colors 88)
      (background dark))
     (:foreground "PaleGreen"))
    (((class color)
      (min-colors 16)
      (background light))
     (:foreground "ForestGreen"))
    (((class color)
      (min-colors 16)
      (background dark))
     (:foreground "PaleGreen"))
    (((class color)
      (min-colors 8))
     (:foreground "green"))
    (t
     (:underline t :weight bold)))
  "Face for separator string bewteen done and not done Todos items."
  :group 'todos-faces)
(defvar todos-done-sep-face 'todos-done-sep)

(defun todos-date-string-matcher (lim)
  "Search for Todos date string within LIM for font-locking."
  (re-search-forward
   (concat todos-date-string-start "\\(?1:" todos-date-pattern "\\)") lim t))

(defun todos-time-string-matcher (lim)
  "Search for Todos time string within LIM for font-locking."
  (re-search-forward (concat todos-date-string-start todos-date-pattern
			     " \\(?1:" diary-time-regexp "\\)") lim t))

(defun todos-nondiary-marker-matcher (lim)
  "Search for Todos nondiary markers within LIM for font-locking."
  (re-search-forward (concat "^\\(?1:" (regexp-quote todos-nondiary-start) "\\)"
			     todos-date-pattern "\\(?: " diary-time-regexp
			     "\\)?\\(?2:" (regexp-quote todos-nondiary-end) "\\)")
		     lim t))

(defun todos-diary-nonmarking-matcher (lim)
  "Search for diary nonmarking symbol within LIM for font-locking."
  (re-search-forward (concat "^\\(?1:" (regexp-quote diary-nonmarking-symbol)
			     "\\)" todos-date-pattern) lim t))

(defun todos-diary-expired-matcher (lim)
  "Search for expired diary item date within LIM for font-locking."
  (when (re-search-forward (concat "^\\(?:"
				   (regexp-quote diary-nonmarking-symbol)
				   "\\)?\\(?1:" todos-date-pattern "\\) \\(?2:"
				   diary-time-regexp "\\)?") lim t)
    (let* ((date (match-string-no-properties 1))
    	   (time (match-string-no-properties 2))
	   ;; Function days-between requires a non-empty time string.
    	   (date-time (concat date " " (or time "00:00"))))
      (or (and (not (string-match ".+day\\|\\*" date))
	       (< (days-between date-time (current-time-string)) 0))
	  (todos-diary-expired-matcher lim)))))

(defun todos-done-string-matcher (lim)
  "Search for Todos done header within LIM for font-locking."
  (re-search-forward (concat todos-done-string-start
		      "[^][]+]")
		     lim t))

(defun todos-comment-string-matcher (lim)
  "Search for Todos done comment within LIM for font-locking."
  (re-search-forward (concat "\\[\\(?1:" todos-comment-string "\\):")
		     lim t))

;; (defun todos-category-string-matcher (lim)
;;   "Search for Todos category name within LIM for font-locking.
;; This is for fontifying category names appearing in Todos filter
;; mode."
;;   (if (eq major-mode 'todos-filtered-items-mode)
;;       (re-search-forward
;;        (concat "^\\(?:" todos-date-string-start "\\)?" todos-date-pattern
;;        	       "\\(?: " diary-time-regexp "\\)?\\(?:"
;;        	       (regexp-quote todos-nondiary-end) "\\)? \\(?1:\\[.+\\]\\)")
;;        lim t)))

(defun todos-category-string-matcher-1 (lim)
  "Search for Todos category name within LIM for font-locking.
This is for fontifying category names appearing in Todos filter
mode following done items."
  (if (eq major-mode 'todos-filtered-items-mode)
      (re-search-forward (concat todos-done-string-start todos-date-pattern
				 "\\(?: " diary-time-regexp
				 ;; Use non-greedy operator to prevent
				 ;; capturing possible following non-diary
				 ;; date string.
				 "\\)?] \\(?1:\\[.+?\\]\\)")
			 lim t)))

(defun todos-category-string-matcher-2 (lim)
  "Search for Todos category name within LIM for font-locking.
This is for fontifying category names appearing in Todos filter
mode following todo (not done) items."
  (if (eq major-mode 'todos-filtered-items-mode)
      (re-search-forward (concat todos-date-string-start todos-date-pattern
				 "\\(?: " diary-time-regexp "\\)?\\(?:"
				 (regexp-quote todos-nondiary-end)
				 "\\)? \\(?1:\\[.+\\]\\)")
			 lim t)))

(defvar todos-font-lock-keywords
  (list
   '(todos-nondiary-marker-matcher 1 todos-done-sep-face t)
   '(todos-nondiary-marker-matcher 2 todos-done-sep-face t)
   ;; This is the face used by diary-lib.el.
   '(todos-diary-nonmarking-matcher 1 font-lock-constant-face t)
   '(todos-date-string-matcher 1 todos-date-face t)
   '(todos-time-string-matcher 1 todos-time-face t)
   '(todos-done-string-matcher 0 todos-done-face t)
   '(todos-comment-string-matcher 1 todos-done-face t)
   ;; '(todos-category-string-matcher 1 todos-done-sep-face t)
   '(todos-category-string-matcher-1 1 todos-done-sep-face t t)
   '(todos-category-string-matcher-2 1 todos-done-sep-face t t)
   '(todos-diary-expired-matcher 1 todos-diary-expired-face t)
   '(todos-diary-expired-matcher 2 todos-diary-expired-face t t)
   )
  "Font-locking for Todos modes.")

;; ---------------------------------------------------------------------------
;;; Todos mode local variables and hook functions

(defvar todos-current-todos-file nil
  "Variable holding the name of the currently active Todos file.")

(defun todos-show-current-file ()
  "Visit current instead of default Todos file with `todos-show'.
This function is added to `pre-command-hook' when user option
`todos-show-current-file' is set to non-nil."
  (setq todos-global-current-todos-file todos-current-todos-file))

(defun todos-display-as-todos-file ()
  "Show Todos files correctly when visited from outside of Todos mode."
  (and (member this-command todos-visit-files-commands)
       (= (- (point-max) (point-min)) (buffer-size))
       (member major-mode '(todos-mode todos-archive-mode))
       (todos-category-select)))

(defun todos-add-to-buffer-list ()
  "Add name of just visited Todos file to `todos-file-buffers'.
This function is added to `find-file-hook' in Todos mode."
  (let ((filename (file-truename (buffer-file-name))))
    (when (member filename todos-files)
      (add-to-list 'todos-file-buffers filename))))

(defun todos-update-buffer-list ()
  "Make current Todos mode buffer file car of `todos-file-buffers'.
This function is added to `post-command-hook' in Todos mode."
  (let ((filename (file-truename (buffer-file-name))))
    (unless (eq (car todos-file-buffers) filename)
      (setq todos-file-buffers
	    (cons filename (delete filename todos-file-buffers))))))

(defun todos-reset-global-current-todos-file ()
  "Update the value of `todos-global-current-todos-file'.
This becomes the latest existing Todos file or, if there is none,
the value of `todos-default-todos-file'.
This function is added to `kill-buffer-hook' in Todos mode."
  (let ((filename (file-truename (buffer-file-name))))
    (setq todos-file-buffers (delete filename todos-file-buffers))
    (setq todos-global-current-todos-file (or (car todos-file-buffers)
					      todos-default-todos-file))))

(defvar todos-categories nil
  "Alist of categories in the current Todos file.
The elements are cons cells whose car is a category name and
whose cdr is a vector of the category's item counts.  These are,
in order, the numbers of todo items, of todo items included in
the Diary, of done items and of archived items.")

(defvar todos-categories-with-marks nil
  "Alist of categories and number of marked items they contain.")

(defvar todos-category-number 1
  "Variable holding the number of the current Todos category.
Todos categories are numbered starting from 1.")

(defvar todos-first-visit t
  "Non-nil if first display of this file in the current session.
See `todos-display-categories-first'.")

(defvar todos-show-done-only nil
  "If non-nil display only done items in current category.
Set by the command `todos-show-done-only' and used by
`todos-category-select'.")

;; ---------------------------------------------------------------------------
;;; Global variables and helper functions

(defvar todos-files (funcall todos-files-function)
  "List of truenames of user's Todos files.")

(defvar todos-archives (funcall todos-files-function t)
  "List of truenames of user's Todos archives.")

(defvar todos-file-buffers nil
  "List of file names of live Todos mode buffers.")

(defvar todos-global-current-todos-file nil
  "Variable holding name of current Todos file.
Used by functions called from outside of Todos mode to visit the
current Todos file rather than the default Todos file (i.e. when
users option `todos-show-current-file' is non-nil).")

(defun todos-reevaluate-defcustoms ()
  "Reevaluate defcustoms that provide choice list of Todos files."
  (custom-set-default 'todos-default-todos-file
		      (symbol-value 'todos-default-todos-file))
  (todos-reevaluate-default-file-defcustom)
  (custom-set-default 'todos-filter-files (symbol-value 'todos-filter-files))
  (todos-reevaluate-filter-files-defcustom))

(defvar todos-edit-buffer "*Todos Edit*"
  "Name of current buffer in Todos Edit mode.")

(defvar todos-categories-buffer "*Todos Categories*"
  "Name of buffer in Todos Categories mode.")

(defvar todos-print-buffer "*Todos Print*"
  "Name of buffer containing printable Todos text.")

(defvar todos-date-pattern
  (let ((dayname (diary-name-pattern calendar-day-name-array nil t)))
    (concat "\\(?:" dayname "\\|"
	    (let ((dayname)
		  ;; FIXME: how to choose between abbreviated and unabbreviated
		  ;; month name?
		  (monthname (format "\\(?:%s\\|\\*\\)"
				     (diary-name-pattern
				      calendar-month-name-array
				      calendar-month-abbrev-array t)))
		  (month "\\(?:[0-9]+\\|\\*\\)")
		  (day "\\(?:[0-9]+\\|\\*\\)")
		  (year "-?\\(?:[0-9]+\\|\\*\\)"))
	      (mapconcat 'eval calendar-date-display-form ""))
	    "\\)"))
  "Regular expression matching a Todos date header.")

(defvar todos-nondiary-start (nth 0 todos-nondiary-marker)
  "String inserted before item date to block diary inclusion.")

(defvar todos-nondiary-end (nth 1 todos-nondiary-marker)
  "String inserted after item date matching `todos-nondiary-start'.")

;; By itself this matches anything, because of the `?'; however, it's only
;; used in the context of `todos-date-pattern' (but Emacs Lisp lacks
;; lookahead).
(defvar todos-date-string-start
  (concat "^\\(" (regexp-quote todos-nondiary-start) "\\|"
	  (regexp-quote diary-nonmarking-symbol) "\\)?")
  "Regular expression matching part of item header before the date.")

(defvar todos-done-string-start
  (concat "^\\[" (regexp-quote todos-done-string))
  "Regular expression matching start of done item.")

(defun todos-category-number (cat)
  "Return the number of category CAT in this Todos file.
The buffer-local variable `todos-category-number' holds this
number as its value."
  (let ((categories (mapcar 'car todos-categories)))
    (setq todos-category-number
	  ;; Increment by one, so that the highest priority category in Todos
	  ;; Categories mode is numbered one rather than zero.
	  (1+ (- (length categories)
		 (length (member cat categories)))))))

(defun todos-current-category ()
  "Return the name of the current category."
  (car (nth (1- todos-category-number) todos-categories)))

(defconst todos-category-beg "--==-- "
  "String marking beginning of category (inserted with its name).")

(defconst todos-category-done "==--== DONE "
  "String marking beginning of category's done items.")

(defun todos-done-separator ()
  "Return string used as value of variable `todos-done-separator'."
  (let ((sep todos-done-separator-string))
    (if (= 1 (length sep))
	(make-string (window-width) (string-to-char sep))
      todos-done-separator-string)))

(defvar todos-done-separator (todos-done-separator)
  "String used to visually separate done from not done items.
Displayed as an overlay instead of `todos-category-done' when
done items are shown.  Its value is determined by user option
`todos-done-separator-string'.")

(defun todos-category-select ()
  "Display the current category correctly."
  (let ((name (todos-current-category))
	cat-begin cat-end done-start done-sep-start done-end)
    (widen)
    (goto-char (point-min))
    (re-search-forward
     (concat "^" (regexp-quote (concat todos-category-beg name)) "$") nil t)
    (setq cat-begin (1+ (line-end-position)))
    (setq cat-end (if (re-search-forward
		       (concat "^" (regexp-quote todos-category-beg)) nil t)
		      (match-beginning 0)
		    (point-max)))
    (setq mode-line-buffer-identification
	  (funcall todos-mode-line-function name))
    (narrow-to-region cat-begin cat-end)
    (todos-prefix-overlays)
    (goto-char (point-min))
    (if (re-search-forward (concat "\n\\(" (regexp-quote todos-category-done)
				   "\\)") nil t)
	(progn
	  (setq done-start (match-beginning 0))
	  (setq done-sep-start (match-beginning 1))
	  (setq done-end (match-end 0)))
      (error "Category %s is missing todos-category-done string" name))
    (if todos-show-done-only
	(narrow-to-region (1+ done-end) (point-max))
      (when (and todos-show-with-done
		 (re-search-forward todos-done-string-start nil t))
	;; Now we want to see the done items, so reset displayed end to end of
	;; done items.
	(setq done-start cat-end)
	;; Make display overlay for done items separator string, unless there
	;; already is one.
	(let* ((done-sep todos-done-separator)
	       (ovs (overlays-at done-sep-start))
	       ov-sep)
	  ;; There should never be more than one overlay here, so car suffices.
	  (unless (and ovs (string= (overlay-get (car ovs) 'display) done-sep))
	    (setq ov-sep (make-overlay done-sep-start done-end))
	    (overlay-put ov-sep 'display done-sep))))
      (narrow-to-region (point-min) done-start)
      ;; Loading this from todos-mode, or adding it to the mode hook, causes
      ;; Emacs to hang in todos-item-start, at (looking-at todos-item-start).
      (when todos-highlight-item
	(require 'hl-line)
	(hl-line-mode 1)))))

(defun todos-get-count (type &optional category)
  "Return count of TYPE items in CATEGORY.
If CATEGORY is nil, default to the current category."
  (let* ((cat (or category (todos-current-category)))
	 (counts (cdr (assoc cat todos-categories)))
	 (idx (cond ((eq type 'todo) 0)
		    ((eq type 'diary) 1)
		    ((eq type 'done) 2)
		    ((eq type 'archived) 3))))
    (aref counts idx)))

(defun todos-update-count (type increment &optional category)
  "Change count of TYPE items in CATEGORY by integer INCREMENT.
With nil or omitted CATEGORY, default to the current category."
  (let* ((cat (or category (todos-current-category)))
	 (counts (cdr (assoc cat todos-categories)))
	 (idx (cond ((eq type 'todo) 0)
		    ((eq type 'diary) 1)
		    ((eq type 'done) 2)
		    ((eq type 'archived) 3))))
    (aset counts idx (+ increment (aref counts idx)))))

(defun todos-set-categories ()
  "Set `todos-categories' from the sexp at the top of the file."
  ;; New archive files created by `todos-move-category' are empty, which would
  ;; make the sexp test fail and raise an error, so in this case we skip it.
  (unless (zerop (buffer-size))
    (save-excursion
      (save-restriction
	(widen)
	(goto-char (point-min))
	(setq todos-categories
	      (if (looking-at "\(\(\"")
		  (read (buffer-substring-no-properties
			 (line-beginning-position)
			 (line-end-position)))
		(error "Invalid or missing todos-categories sexp")))))))

(defun todos-update-categories-sexp ()
  "Update the `todos-categories' sexp at the top of the file."
  (let (buffer-read-only)
    (save-excursion
      (save-restriction
	(widen)
	(goto-char (point-min))
	(if (looking-at (concat "^" (regexp-quote todos-category-beg)))
	    (progn (newline) (goto-char (point-min)) ; Make space for sexp.
		   ;; No categories sexp means the first item was just added
		   ;; to this file, so have to initialize Todos file and
		   ;; categories variables in order e.g. to enable categories
		   ;; display.
		   (setq todos-default-todos-file (buffer-file-name))
		   (setq todos-categories (todos-make-categories-list t)))
	  ;; With empty buffer (e.g. with new archive in
	  ;; `todos-move-category') `kill-line' signals end of buffer.
	  (kill-region (line-beginning-position) (line-end-position)))
	(prin1 todos-categories (current-buffer))))))

(defun todos-make-categories-list (&optional force)
  "Return an alist of Todos categories and their item counts.
With non-nil argument FORCE parse the entire file to build the
list; otherwise, get the value by reading the sexp at the top of
the file."
  (setq todos-categories nil)
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-min))
      (let (counts cat archive)
	;; If the file is a todo file and has archived items, identify the
	;; archive, in order to count its items.  But skip this with
	;; `todos-convert-legacy-files', since that converts filed items to
	;; archived items.
	(when buffer-file-name	 ; During conversion there is no file yet.
	  ;; If the file is an archive, it doesn't have an archive.
	  (unless (member (file-truename buffer-file-name)
			  (funcall todos-files-function t))
	    (setq archive (concat (file-name-sans-extension
				   todos-current-todos-file) ".toda"))))
	(while (not (eobp))
	  (cond ((looking-at (concat (regexp-quote todos-category-beg)
				     "\\(.*\\)\n"))
		 (setq cat (match-string-no-properties 1))
		 ;; Counts for each category: [todo diary done archive]
		 (setq counts (make-vector 4 0))
		 (setq todos-categories
		       (append todos-categories (list (cons cat counts))))
		 ;; Add archived item count to the todo file item counts.
		 ;; Make sure to include newly created archives, e.g. due to
		 ;; todos-move-category.
		 (when (member archive (funcall todos-files-function t))
		   (let ((archive-count 0))
		     (with-current-buffer (find-file-noselect archive)
		       (widen)
		       (goto-char (point-min))
		       (when (re-search-forward
			      (concat (regexp-quote todos-category-beg) cat)
			      (point-max) t)
			 (forward-line)
			 (while (not (or (looking-at
					  (concat
					   (regexp-quote todos-category-beg)
					   "\\(.*\\)\n"))
					 (eobp)))
			   (when (looking-at todos-done-string-start)
			     (setq archive-count (1+ archive-count)))
			   (forward-line))))
		     (todos-update-count 'archived archive-count cat))))
		((looking-at todos-done-string-start)
		 (todos-update-count 'done 1 cat))
		((looking-at (concat "^\\("
				     (regexp-quote diary-nonmarking-symbol)
				     "\\)?" todos-date-pattern))
		 (todos-update-count 'diary 1 cat)
		 (todos-update-count 'todo 1 cat))
		((looking-at (concat todos-date-string-start todos-date-pattern))
		 (todos-update-count 'todo 1 cat))
		;; If first line is todos-categories list, use it and end loop
		;; -- unless FORCEd to scan whole file.
		((bobp)
		 (unless force
		   (setq todos-categories (read (buffer-substring-no-properties
						 (line-beginning-position)
						 (line-end-position))))
		   (goto-char (1- (point-max))))))
	  (forward-line)))))
  todos-categories)

(defun todos-check-format ()
  "Signal an error if the current Todos file is ill-formatted.
Otherwise return t.  The error message gives the line number
where the invalid formatting was found."
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-min))
      ;; Check for `todos-categories' sexp as the first line
      (let ((cats (prin1-to-string todos-categories)))
	(unless (looking-at (regexp-quote cats))
	  (error "Invalid or missing todos-categories sexp")))
      (forward-line)
      (let ((legit (concat "\\(^" (regexp-quote todos-category-beg) "\\)"
			   "\\|\\(" todos-date-string-start todos-date-pattern "\\)"
			   "\\|\\(^[ \t]+[^ \t]*\\)"
			   "\\|^$"
			   "\\|\\(^" (regexp-quote todos-category-done) "\\)"
			   "\\|\\(" todos-done-string-start "\\)")))
	(while (not (eobp))
	  (unless (looking-at legit)
	    (error "Illegitimate Todos file format at line %d"
		   (line-number-at-pos (point))))
	  (forward-line)))))
  ;; (message "This Todos file is well-formatted.")
  t)

(defun todos-repair-categories-sexp ()
  "Repair corrupt Todos categories sexp.
This should only be needed as a consequence of careless manual
editing or a bug in todos.el."
  (interactive)
  (let ((todos-categories (todos-make-categories-list t)))
    (todos-update-categories-sexp)))

(defun todos-convert-legacy-date-time ()
  "Return converted date-time string.
Helper function for `todos-convert-legacy-files'."
  (let* ((year (match-string 1))
	 (month (match-string 2))
	 (monthname (calendar-month-name (string-to-number month) t))
	 (day (match-string 3))
	 (time (match-string 4))
	 dayname)
    (replace-match "")
    (insert (mapconcat 'eval calendar-date-display-form "")
	    (when time (concat " " time)))))

(defvar todos-item-start (concat "\\(" todos-date-string-start "\\|"
				 todos-done-string-start "\\)"
				 todos-date-pattern)
  "String identifying start of a Todos item.")

(defun todos-item-start ()
  "Move to start of current Todos item and return its position."
  (unless (or
	   ;; Buffer is empty (invocation possible e.g. via todos-forward-item
	   ;; from todos-filter-items when processing category with no todo
	   ;; items).
	   (eq (point-min) (point-max))
	   ;; Point is on the empty line between todo and done items.
	   (and (looking-at "^$")
		(save-excursion
		  (forward-line)
		  (looking-at (concat "^" (regexp-quote todos-category-done)))))
	   ;; Buffer is widened.
	   (looking-at (regexp-quote todos-category-beg)))
    (goto-char (line-beginning-position))
    (while (not (looking-at todos-item-start))
      (forward-line -1))
    (point)))

(defun todos-item-end ()
  "Move to end of current Todos item and return its position."
  ;; Items cannot end with a blank line.
  (unless (looking-at "^$")
    (let* ((done (todos-done-item-p))
	   (to-lim nil)
	   ;; For todo items, end is before the done items section, for done
	   ;; items, end is before the next category.  If these limits are
	   ;; missing or inaccessible, end it before the end of the buffer.
	   (lim (if (save-excursion
		      (re-search-forward
		       (concat "^" (regexp-quote (if done
						     todos-category-beg
						   todos-category-done)))
		       nil t))
		    (progn (setq to-lim t) (match-beginning 0))
		  (point-max))))
      (when (bolp) (forward-char))	; Find start of next item.
      (goto-char (if (re-search-forward todos-item-start lim t)
		     (match-beginning 0)
		   (if to-lim lim (point-max))))
      ;; For last todo item, skip back over the empty line before the done
      ;; items section, else just back to the end of the previous line.
      (backward-char (when (and to-lim (not done) (eq (point) lim)) 2))
      (point))))

(defun todos-item-string ()
  "Return bare text of current item as a string."
  (let ((opoint (point))
	(start (todos-item-start))
	(end (todos-item-end)))
    (goto-char opoint)
    (and start end (buffer-substring-no-properties start end))))

(defun todos-remove-item ()
  "Internal function called in editing, deleting or moving items."
  (let* ((beg (todos-item-start))
	 (end (progn (todos-item-end) (1+ (point))))
	 (ovs (overlays-in beg beg)))
    ;; There can be both prefix/number and mark overlays.
    (while ovs (delete-overlay (car ovs)) (pop ovs))
    (delete-region beg end)))

(defun todos-diary-item-p ()
  "Return non-nil if item at point has diary entry format."
  (save-excursion
    (todos-item-start)
    (not (looking-at (regexp-quote todos-nondiary-start)))))

(defun todos-done-item-p ()
  "Return non-nil if item at point is a done item."
  (save-excursion
    (todos-item-start)
    (looking-at todos-done-string-start)))

(defvar todos-item-mark (propertize (if (equal todos-prefix "*") "@" "*")
				    'face 'todos-mark)
  "String used to mark items.")

(defun todos-marked-item-p ()
  "If this item begins with `todos-item-mark', return mark overlay."
  (let ((ovs (overlays-in (line-beginning-position) (line-beginning-position)))
	(mark todos-item-mark)
	ov marked)
    (catch 'stop
      (while ovs
	(setq ov (pop ovs))
	(and (equal (overlay-get ov 'before-string) mark)
	     (throw 'stop (setq marked t)))))
    (when marked ov)))

(defun todos-insert-with-overlays (item)
  "Insert ITEM at point and update prefix/priority number overlays."
  (todos-item-start)
  (insert item "\n")
  (todos-backward-item)
  (todos-prefix-overlays))

(defun todos-prefix-overlays ()
  "Put before-string overlay in front of this category's items.
The overlay's value is the string `todos-prefix' or with non-nil
`todos-number-priorities' an integer in the sequence from 1 to
the number of todo or done items in the category indicating the
item's priority.  Todo and done items are numbered independently
of each other."
  (when (or todos-number-priorities
	    (not (string-match "^[[:space:]]*$" todos-prefix)))
    (let ((prefix (propertize (concat todos-prefix " ")
			      'face 'todos-prefix-string))
	  (num 0))
      (save-excursion
	(goto-char (point-min))
	(while (not (eobp))
	  (when (or (todos-date-string-matcher (line-end-position))
		    (todos-done-string-matcher (line-end-position)))
	    (goto-char (match-beginning 0))
	    (when todos-number-priorities
	      (setq num (1+ num))
	      ;; Reset number to 1 for first done item.
	      (when (and (looking-at todos-done-string-start)
			 (looking-back (concat "^"
					       (regexp-quote todos-category-done)
					       "\n")))
		(setq num 1))
	      (setq prefix (propertize (concat (number-to-string num) " ")
				       'face 'todos-prefix-string)))
	    (let ((ovs (overlays-in (point) (point)))
		  marked ov-pref)
	      (if ovs
		  (dolist (ov ovs)
		    (let ((val (overlay-get ov 'before-string)))
		      (if (equal val "*")
			  (setq marked t)
			(setq ov-pref val)))))
	      (unless (equal ov-pref prefix)
		;; Why doesn't this work?
		;; (remove-overlays (point) (point) 'before-string)
		(remove-overlays (point) (point))
		(overlay-put (make-overlay (point) (point))
			     'before-string prefix)
		(and marked (overlay-put (make-overlay (point) (point))
					 'before-string todos-item-mark)))))
	  (forward-line))))))

;; ---------------------------------------------------------------------------
;;; Functions for user input with prompting and completion

(defun todos-read-file-name (prompt &optional archive mustmatch)
  "Choose and return the name of a Todos file, prompting with PROMPT.

Show completions with TAB or SPC; the names are shown in short
form but the absolute truename is returned.  With non-nil ARCHIVE
return the absolute truename of a Todos archive file.  With non-nil
MUSTMATCH the name of an existing file must be chosen;
otherwise, a new file name is allowed."
  (let* ((completion-ignore-case todos-completion-ignore-case)
	 (files (mapcar 'todos-short-file-name
			(if archive todos-archives todos-files)))
	 (file (completing-read prompt files nil mustmatch nil nil
				(unless files
				  ;; Trigger prompt for initial file.
				  ""))))
    (unless (file-exists-p todos-files-directory)
      (make-directory todos-files-directory))
    (unless mustmatch
      (setq file (todos-validate-name file 'file)))
    (setq file (file-truename (concat todos-files-directory file
				      (if archive ".toda" ".todo"))))))

(defun todos-read-category (prompt &optional mustmatch added)
  "Choose and return a category name, prompting with PROMPT.
Show completions with TAB or SPC.  With non-nil MUSTMATCH the
name must be that of an existing category; otherwise, a new
category name is allowed, after checking its validity.  Non-nil
argument ADDED means the caller is todos-add-category, so don't
ask whether to add the category."
  ;; Allow SPC to insert spaces, for adding new category names.
  (let ((map minibuffer-local-completion-map))
    (define-key map " " nil)
    ;; Make a copy of todos-categories in case history-delete-duplicates is
    ;; non-nil, which makes completing-read alter todos-categories.
    (let* ((categories (copy-sequence todos-categories))
	   (history (cons 'todos-categories (1+ todos-category-number)))
	   (completion-ignore-case todos-completion-ignore-case)
	   (cat (completing-read prompt todos-categories nil
				 mustmatch nil history
				 ;; Default for existing categories is the
				 ;; current category.
				 (if todos-categories
				     (todos-current-category)
				   ;; Trigger prompt for initial category.
				   ""))))
      (unless (or mustmatch (assoc cat todos-categories))
	(todos-validate-name cat 'category)
	(unless added
	  (if (y-or-n-p (format (concat "There is no category \"%s\" in "
					"this file; add it? ") cat))
	      (todos-add-category cat)
	    (keyboard-quit))))
      ;; Restore the original value of todos-categories unless a new category
      ;; was added (since todos-add-category changes todos-categories).
      (unless added (setq todos-categories categories))
      cat)))

(defun todos-validate-name (name type)
  "Prompt for new NAME for TYPE until it is valid, then return it.
TYPE can be either a file or a category"
  (let ((categories todos-categories)
	(files (mapcar 'todos-short-file-name todos-files))
	prompt)
    (while
	(and (cond ((string= "" name)
		    (setq prompt
			  (cond ((eq type 'file)
				 (if todos-files
				     "Enter a non-empty file name: "
				   ;; Empty string passed by todos-show to
				   ;; prompt for initial Todos file.
				   (concat "Initial file name ["
					   todos-initial-file "]: ")))
				((eq type 'category)
				 (if todos-categories
				     "Enter a non-empty category name: "
				   ;; Empty string passed by todos-show to
				   ;; prompt for initial category of a new
				   ;; Todos file.
				   (concat "Initial category name ["
					   todos-initial-category "]: "))))))
		   ((string-match "\\`\\s-+\\'" name)
		    (setq prompt
			  "Enter a name that does not contain only white space: "))
		   ((and (eq type 'file) (member name todos-files))
		    (setq prompt "Enter a non-existing file name: "))
		   ((and (eq type 'category) (assoc name todos-categories))
		    (setq prompt "Enter a non-existing category name: ")))
	     (setq name (if (or (and (eq type 'file) todos-files)
				(and (eq type 'category) todos-categories))
			    (completing-read prompt (cond ((eq type 'file)
							   todos-files)
							  ((eq type 'category)
							   todos-categories)))
			  ;; Offer default initial name.
			  (completing-read prompt (if (eq type 'file)
						      todos-files
						    todos-categories)
					   nil nil (if (eq type 'file)
						       todos-initial-file
						     todos-initial-category))))))
    name))

;; Adapted from calendar-read-date and calendar-date-string.
(defun todos-read-date ()
  "Prompt for Gregorian date and return it in the current format.
Also accepts `*' as an unspecified month, day, or year."
  (let* ((year (let (x)
		 (while (if (numberp x) (< x 0) (not (eq x '*)))
		   (setq x (read-from-minibuffer
			    "Year (>0 or RET for this year or * for any year): "
			    nil nil t nil (number-to-string
					   (calendar-extract-year
					    (calendar-current-date))))))
		 x))
         (month-array (vconcat calendar-month-name-array (vector "*")))
	 (abbrevs (vconcat calendar-month-abbrev-array (vector "*")))
         (completion-ignore-case todos-completion-ignore-case)
	 (monthname (completing-read
		     "Month name (RET for current month, * for any month): "
		     (mapcar 'list (append month-array nil))
		     nil t nil nil
		     (calendar-month-name (calendar-extract-month
					   (calendar-current-date)) t)))
         (month (cdr (assoc-string
		      monthname (calendar-make-alist month-array nil nil
						     abbrevs))))
         (last (if (= month 13)
		   31			; FIXME: what about shorter months?
		 (let ((yr (if (eq year '*)
			       1999	; FIXME: no Feb. 29
			     year)))
		   (calendar-last-day-of-month month yr))))
	 (day (let (x)
		(while (if (numberp x) (or (< x 0) (< last x)) (not (eq x '*)))
		  (setq x (read-from-minibuffer
			   (format
			    "Day (1-%d or RET for today or * for any day): "
			    last) nil nil t nil (number-to-string
						 (calendar-extract-day
						  (calendar-current-date))))))
		 x))
	 dayname)			; Needed by calendar-date-display-form.
    (setq year (if (eq year '*) (symbol-name '*) (number-to-string year)))
    (setq day (if (eq day '*) (symbol-name '*) (number-to-string day)))
    ;; FIXME: make abbreviation customizable
    (setq monthname
	  (or (and (= month 13) "*")
	      (calendar-month-name (calendar-extract-month (list month day year))
				   t)))
    (mapconcat 'eval calendar-date-display-form "")))

(defun todos-read-dayname ()
  "Choose name of a day of the week with completion and return it."
  (let ((completion-ignore-case todos-completion-ignore-case))
    (completing-read "Enter a day name: "
		     (append calendar-day-name-array nil)
		     nil t)))
  
(defun todos-read-time ()
  "Prompt for and return a valid clock time as a string.

Valid time strings are those matching `diary-time-regexp'.
Typing `<return>' at the prompt returns the current time, if the
user option `todos-always-add-time-string' is non-nil, otherwise
the empty string (i.e., no time string)."
  (let (valid answer)
    (while (not valid)
      (setq answer (read-string "Enter a clock time: " nil nil
				(when todos-always-add-time-string
				  (substring (current-time-string) 11 16))))
      (when (or (string= "" answer)
		(string-match diary-time-regexp answer))
	(setq valid t)))
    answer))

;; ---------------------------------------------------------------------------
;;; Item filtering

(defvar todos-multiple-filter-files nil
  "List of files selected from `todos-multiple-filter-files' widget.")

(defvar todos-multiple-filter-files-widget nil
  "Variable holding widget created by `todos-multiple-filter-files'.")

(defun todos-multiple-filter-files ()
  "Pop to a buffer with a widget for choosing multiple filter files."
  (require 'widget)
  (eval-when-compile
    (require 'wid-edit))
  (with-current-buffer (get-buffer-create "*Todos Filter Files*")
    (pop-to-buffer (current-buffer))
    (erase-buffer)
    (kill-all-local-variables)
    (widget-insert "Select files for generating the top priorities list.\n\n")
    (setq todos-multiple-filter-files-widget
	  (widget-create
	   `(set ,@(mapcar (lambda (x) (list 'const x))
			   (mapcar 'todos-short-file-name
				   (funcall todos-files-function))))))
    (widget-insert "\n")
    (widget-create 'push-button
		   :notify (lambda (widget &rest ignore)
			     (setq todos-multiple-filter-files 'quit)
			     (quit-window t)
			     (exit-recursive-edit))
		   "Cancel")
    (widget-insert "   ")
    (widget-create 'push-button
		   :notify (lambda (&rest ignore)
			     (setq todos-multiple-filter-files
				   (mapcar (lambda (f)
					     (concat todos-files-directory
						     f ".todo"))
					   (widget-value
					    todos-multiple-filter-files-widget)))
			     (quit-window t)
			     (exit-recursive-edit))
		   "Apply")
    (use-local-map widget-keymap)
    (widget-setup))
  (message "Click \"Apply\" after selecting files.")
  (recursive-edit))

(defun todos-filter-items (filter &optional multifile)
  "Build and display a list of items from different categories.

The items are selected according to the value of FILTER, which
can be `top' for top priority items, `diary' for diary items,
`regexp' for items matching a regular expresion entered by the
user, or a cons cell of one of these symbols and a number set by
the calling command, which overrides `todos-show-priorities'.

With non-nil argument MULTIFILE list top priorities of multiple
Todos files, by default those in `todos-filter-files'."
  (let ((num (if (consp filter) (cdr filter) todos-show-priorities))
	(buf (get-buffer-create todos-filtered-items-buffer))
	(files (list todos-current-todos-file))
	regexp fname bufstr cat beg end done)
    (when multifile
      (setq files (or todos-multiple-filter-files ; Passed from todos-*-multifile.
		      (if (or (consp filter)
			      (null todos-filter-files))
			  (progn (todos-multiple-filter-files)
				 todos-multiple-filter-files)
			todos-filter-files))
	    todos-multiple-filter-files nil))
    (if (eq files 'quit) (keyboard-quit))
    (if (null files)
	(error "No files have been chosen for filtering")
      (with-current-buffer buf
	(erase-buffer)
	(kill-all-local-variables)
	(todos-filtered-items-mode))
      (when (eq filter 'regexp)
	(setq regexp (read-string "Enter a regular expression: ")))
      (save-current-buffer
	(dolist (f files)
	  ;; Before inserting file contents into temp buffer, save a modified
	  ;; buffer visiting it.
	  (let ((bf (find-buffer-visiting f)))
	    (when (buffer-modified-p bf)
	      (with-current-buffer bf (save-buffer))))
	  (setq fname (todos-short-file-name f))
	  (with-temp-buffer
	    (when (and todos-filter-done-items (eq filter 'regexp))
	      ;; If there is a corresponding archive file for the Todos file,
	      ;; insert it first and add identifiers for todos-jump-to-item.
	      (let ((arch (concat (file-name-sans-extension f) ".toda")))
		(when (file-exists-p arch)
		  (insert-file-contents arch)
		  ;; Delete Todos archive file categories sexp.
		  (delete-region (line-beginning-position)
				 (1+ (line-end-position)))
		  (save-excursion
		    (while (not (eobp))
		      (when (re-search-forward
			     (concat (if todos-filter-done-items
					 (concat "\\(?:" todos-done-string-start
						 "\\|" todos-date-string-start
						 "\\)")
				       todos-date-string-start)
				     todos-date-pattern "\\(?: "
				     diary-time-regexp "\\)?"
				     (if todos-filter-done-items
					 "\\]"
				       (regexp-quote todos-nondiary-end)) "?")
			     nil t)
			(insert "(archive) "))
		      (forward-line))))))
	    (insert-file-contents f)
	    ;; Delete Todos file categories sexp.
	    (delete-region (line-beginning-position) (1+ (line-end-position)))
	    (let (fnum)
	      ;; Unless the number of items to show was supplied by prefix
	      ;; argument of caller, the file-wide value from
	      ;; `todos-priorities-rules', if non-nil, overrides
	      ;; `todos-show-priorities'.
	      (unless (consp filter)
		(setq fnum (nth 1 (assoc f todos-priorities-rules))))
	      (while (re-search-forward
		      (concat "^" (regexp-quote todos-category-beg) "\\(.+\\)\n")
		      nil t)
		(setq cat (match-string 1))
		(let (cnum)
		  ;; Unless the number of items to show was supplied by prefix
		  ;; argument of caller, the category-wide value from
		  ;; `todos-priorities-rules', if non-nil, overrides a non-nil
		  ;; file-wide value from `todos-priorities-rules' as well as
		  ;; `todos-show-priorities'.
		  (unless (consp filter)
		    (let ((cats (nth 2 (assoc f todos-priorities-rules))))
		      (setq cnum (or (cdr (assoc cat cats)) fnum))))
		  (delete-region (match-beginning 0) (match-end 0))
		  (setq beg (point))	; First item in the current category.
		  (setq end (if (re-search-forward
				 (concat "^" (regexp-quote todos-category-beg))
				 nil t)
				(match-beginning 0)
			      (point-max)))
		  (goto-char beg)
		  (setq done
			(if (re-search-forward
			     (concat "\n" (regexp-quote todos-category-done))
			     end t)
			    (match-beginning 0)
			  end))
		  (unless (and todos-filter-done-items (eq filter 'regexp))
		    ;; Leave done items.
		    (delete-region done end)
		    (setq end done))
		  (narrow-to-region beg end)	; Process only current category.
		  (goto-char (point-min))
		  ;; Apply the filter.
		  (cond ((eq filter 'diary)
			 (while (not (eobp))
			   (if (looking-at (regexp-quote todos-nondiary-start))
			       (todos-remove-item)
			     (todos-forward-item))))
			((eq filter 'regexp)
			 (while (not (eobp))
			   (if (looking-at todos-item-start)
			       (if (string-match regexp (todos-item-string))
				   (todos-forward-item)
				 (todos-remove-item))
			     ;; Kill lines that aren't part of a todo or done
			     ;; item (empty or todos-category-done).
			     (delete-region (line-beginning-position)
					    (1+ (line-end-position))))
			   ;; If last todo item in file matches regexp and
			   ;; there are no following done items,
			   ;; todos-category-done string is left dangling,
			   ;; because todos-forward-item jumps over it.
			   (if (and (eobp)
				    (looking-back
				     (concat (regexp-quote todos-done-string)
					     "\n")))
			       (delete-region (point) (progn
							(forward-line -2)
							(point))))))
			(t ; Filter top priority items.
			 (setq num (or cnum fnum num))
			 (unless (zerop num)
			   (todos-forward-item num))))
		  (setq beg (point))
		  ;; Delete non-top-priority items.
		  (unless (member filter '(diary regexp))
		    (delete-region beg end))
		  (goto-char (point-min))
		  ;; Add file (if using multiple files) and category tags to
		  ;; item.
		  (while (not (eobp))
		    (when (re-search-forward
			   (concat (if todos-filter-done-items
				       (concat "\\(?:" todos-done-string-start
					       "\\|" todos-date-string-start
					       "\\)")
				     todos-date-string-start)
				   todos-date-pattern "\\(?: " diary-time-regexp
				   "\\)?" (if todos-filter-done-items
					      "\\]"
					    (regexp-quote todos-nondiary-end))
				   "?")
			   nil t)
		      (insert " [")
		      (when (looking-at "(archive) ") (goto-char (match-end 0)))
		      (insert (if multifile (concat fname ":") "") cat "]"))
		    (forward-line))
		  (widen)))
		(setq bufstr (buffer-string))
		(with-current-buffer buf
		  (let (buffer-read-only)
		    (insert bufstr)))))))
      (set-window-buffer (selected-window) (set-buffer buf))
      (todos-prefix-overlays)
      (goto-char (point-min)))))

(defun todos-set-top-priorities (&optional arg)
  "Set number of top priorities shown by `todos-top-priorities'.
With non-nil ARG, set the number only for the current Todos
category; otherwise, set the number for all categories in the
current Todos file.

Calling this function via either of the commands
`todos-set-top-priorities-in-file' or
`todos-set-top-priorities-in-category' is the recommended way to
set the user customizable option `todos-priorities-rules'."
  (let* ((cat (todos-current-category))
	 (file todos-current-todos-file)
	 (rules todos-priorities-rules)
	 (frule (assoc-string file rules))
	 (crule (assoc-string cat (nth 2 frule)))
	 (cur (or (if arg (cdr crule) (nth 1 frule))
		  todos-show-priorities))
	 (prompt (concat "Current number of top priorities in this "
			 (if arg "category" "file") ": %d; "
			 "enter new number: "))
	 (new "-1")
	 nrule)
    (while (or (not (string-match "[0-9]+" new)) ; Don't accept "" or "bla".
	       (< (string-to-number new) 0))
      (let ((cur0 cur))
	(setq new (read-string (format prompt cur0) nil nil cur0)
	      prompt "Enter a non-negative number: "
	      cur0 nil)))
    (setq new (string-to-number new))
    (setq nrule (if arg
		    (append (nth 2 (delete crule frule)) (list (cons cat new)))
		  (append (list file new) (list (nth 2 frule)))))
    (setq rules (cons (if arg
			  (list file cur nrule)
			nrule)
		      (delete frule rules)))
    (customize-save-variable 'todos-priorities-rules rules)))

(defun todos-filtered-buffer-name (buffer-type file-list)
  "Rename Todos filtered buffer using BUFFER-TYPE and FILE-LIST.

The new name is constructed from the string BUFFER-TYPE, which
refers to one of the top priorities, diary or regexp item
filters, and the names of the filtered files in FILE-LIST.  Used
in Todos Filter Items mode."
  (let* ((flist (if (listp file-list) file-list (list file-list)))
	 (multi (> (length flist) 1))
	 (fnames (mapconcat (lambda (f) (todos-short-file-name f))
			   flist ", ")))
    (rename-buffer (format (concat "%s for file" (if multi "s" "")
				   " \"%s\"") buffer-type fnames))))

;; ---------------------------------------------------------------------------
;;; Sorting and display routines for Todos Categories mode.

(defun todos-longest-category-name-length (categories)
  "Return the length of the longest name in list CATEGORIES."
  (let ((longest 0))
    (dolist (c categories longest)
      (setq longest (max longest (length c))))))

(defun todos-padded-string (str)
  "Return string STR padded with spaces.
The placement of the padding is determined by the value of user
option `todos-categories-align'."
  (let* ((categories (mapcar 'car todos-categories))
	 (len (max (todos-longest-category-name-length categories)
		   (length todos-categories-category-label)))
	 (strlen (length str))
	 (strlen-odd (eq (logand strlen 1) 1)) ; oddp from cl.el
	 (padding (max 0 (/ (- len strlen) 2)))
	 (padding-left (cond ((eq todos-categories-align 'left) 0)
			     ((eq todos-categories-align 'center) padding)
			     ((eq todos-categories-align 'right)
			      (if strlen-odd (1+ (* padding 2)) (* padding 2)))))
	 (padding-right (cond ((eq todos-categories-align 'left)
			       (if strlen-odd (1+ (* padding 2)) (* padding 2)))
			      ((eq todos-categories-align 'center)
			       (if strlen-odd (1+ padding) padding))
			      ((eq todos-categories-align 'right) 0))))
    (concat (make-string padding-left 32) str (make-string padding-right 32))))

(defvar todos-descending-counts nil
  "List of keys for category counts sorted in descending order.")

(defun todos-sort (list &optional key)
  "Return a copy of LIST, possibly sorted according to KEY."
  (let* ((l (copy-sequence list))
	 (fn (if (eq key 'alpha)
		   (lambda (x) (upcase x)) ; Alphabetize case insensitively.
		 (lambda (x) (todos-get-count key x))))
	 ;; Keep track of whether the last sort by key was descending or
	 ;; ascending.
	 (descending (member key todos-descending-counts))
	 (cmp (if (eq key 'alpha)
		  'string<
		(if descending '< '>)))
	 (pred (lambda (s1 s2) (let ((t1 (funcall fn (car s1)))
				     (t2 (funcall fn (car s2))))
				 (funcall cmp t1 t2)))))
    (when key
      (setq l (sort l pred))
      ;; Switch between descending and ascending sort order.
      (if descending
	  (setq todos-descending-counts
		(delete key todos-descending-counts))
	(push key todos-descending-counts)))
    l))

(defun todos-display-sorted (type)
  "Keep point on the TYPE count sorting button just clicked."
  (let ((opoint (point)))
    (todos-update-categories-display type)
    (goto-char opoint)))

(defun todos-label-to-key (label)
  "Return symbol for sort key associated with LABEL."
  (let (key)
    (cond ((string= label todos-categories-category-label)
	   (setq key 'alpha))
	  ((string= label todos-categories-todo-label)
	   (setq key 'todo))
	  ((string= label todos-categories-diary-label)
	   (setq key 'diary))
	  ((string= label todos-categories-done-label)
	   (setq key 'done))
	  ((string= label todos-categories-archived-label)
	   (setq key 'archived)))
    key))

(defun todos-insert-sort-button (label)
  "Insert button for displaying categories sorted by item counts.
LABEL determines which type of count is sorted."
  (setq str (if (string= label todos-categories-category-label)
		(todos-padded-string label)
	      label))
  (setq beg (point))
  (setq end (+ beg (length str)))
  (insert-button str 'face nil
		 'action
		 `(lambda (button)
		    (let ((key (todos-label-to-key ,label)))
		      (if (and (member key todos-descending-counts)
			       (eq key 'alpha))
			  (progn
			    ;; If display is alphabetical, switch back to
			    ;; category priority order.
			    (todos-display-sorted nil)
			    (setq todos-descending-counts
				  (delete key todos-descending-counts)))
			(todos-display-sorted key)))))
  (setq ovl (make-overlay beg end))
  (overlay-put ovl 'face 'todos-button))

(defun todos-total-item-counts ()
  "Return a list of total item counts for the current file."
  (mapcar (lambda (i) (apply '+ (mapcar (lambda (l) (aref l i))
					(mapcar 'cdr todos-categories))))
	  (list 0 1 2 3)))

(defvar todos-categories-category-number 0
  "Variable for numbering categories in Todos Categories mode.")

(defun todos-insert-category-line (cat &optional nonum)
  "Insert button with category CAT's name and item counts.
With non-nil argument NONUM show only these; otherwise, insert a
number in front of the button indicating the category's priority.
The number and the category name are separated by the string
which is the value of the user option
`todos-categories-number-separator'."
  (let ((archive (member todos-current-todos-file todos-archives))
	(num todos-categories-category-number)
	(str (todos-padded-string cat))
	(opoint (point)))
    (setq num (1+ num) todos-categories-category-number num)
    (insert-button
     (concat (if nonum
		 (make-string (+ 4 (length todos-categories-number-separator))
			      32)
	       (format " %3d%s" num todos-categories-number-separator))
	     str
	     (mapconcat (lambda (elt)
			  (concat
			   (make-string (1+ (/ (length (car elt)) 2)) 32) ; label
			   (format "%3d" (todos-get-count (cdr elt) cat)) ; count
			   ;; Add an extra space if label length is odd
			   ;; (using def of oddp from cl.el).
			   (if (eq (logand (length (car elt)) 1) 1) " ")))
			(if archive
			    (list (cons todos-categories-done-label 'done))
			  (list (cons todos-categories-todo-label 'todo)
				(cons todos-categories-diary-label 'diary)
				(cons todos-categories-done-label 'done)
				(cons todos-categories-archived-label
				      'archived)))
			  "")
	     " ") ; So highlighting of last column is consistent with the others.
     'face (if (and todos-skip-archived-categories
		    (zerop (todos-get-count 'todo cat))
		    (zerop (todos-get-count 'done cat))
		    (not (zerop (todos-get-count 'archived cat))))
	       'todos-archived-only
	     nil)
     'action `(lambda (button) (let ((buf (current-buffer)))
				 (todos-jump-to-category ,cat)
				 (kill-buffer buf))))
    ;; Highlight the sorted count column.
    (let* ((beg (+ opoint 7 (length str)))
	   end ovl)
      (cond ((eq nonum 'todo)
	     (setq beg (+ beg 1 (/ (length todos-categories-todo-label) 2))))
	    ((eq nonum 'diary)
	     (setq beg (+ beg 1 (length todos-categories-todo-label)
			   2 (/ (length todos-categories-diary-label) 2))))
	    ((eq nonum 'done)
	     (setq beg (+ beg 1 (length todos-categories-todo-label)
			   2 (length todos-categories-diary-label)
			   2 (/ (length todos-categories-done-label) 2))))
	    ((eq nonum 'archived)
	     (setq beg (+ beg 1 (length todos-categories-todo-label)
			   2 (length todos-categories-diary-label)
			   2 (length todos-categories-done-label)
			   2 (/ (length todos-categories-archived-label) 2)))))
      (unless (= beg (+ opoint 7 (length str))) ; Don't highlight categories.
	(setq end (+ beg 4))
	(setq ovl (make-overlay beg end))
	(overlay-put ovl 'face 'todos-sorted-column)))
    (newline)))

(defun todos-display-categories-1 ()
  "Prepare buffer for displaying table of categories and item counts."
  (unless (eq major-mode 'todos-categories-mode)
    (setq todos-global-current-todos-file (or todos-current-todos-file
					      todos-default-todos-file))
    (set-window-buffer (selected-window)
		       (set-buffer (get-buffer-create todos-categories-buffer)))
    (kill-all-local-variables)
    (todos-categories-mode)
    (let ((archive (member todos-current-todos-file todos-archives))
	  buffer-read-only) 
      (erase-buffer)
      ;; FIXME: add usage tips?
      (insert (format (concat "Category counts for Todos "
			      (if archive "archive" "file")
			      " \"%s\".")
		      (todos-short-file-name todos-current-todos-file)))
      (newline 2)
      ;; Make space for the column of category numbers.
      (insert (make-string (+ 4 (length todos-categories-number-separator)) 32))
      ;; Add the category and item count buttons (if this is the list of
      ;; categories in an archive, show only done item counts).
      (todos-insert-sort-button todos-categories-category-label)
      (if archive
	  (progn
	    (insert (make-string 3 32))
	    (todos-insert-sort-button todos-categories-done-label))
	(insert (make-string 3 32))
	(todos-insert-sort-button todos-categories-todo-label)
	(insert (make-string 2 32))
	(todos-insert-sort-button todos-categories-diary-label)
	(insert (make-string 2 32))
	(todos-insert-sort-button todos-categories-done-label)
	(insert (make-string 2 32))
	(todos-insert-sort-button todos-categories-archived-label))
      (newline 2))))

(defun todos-update-categories-display (sortkey)
  ""
  (let* ((cats0 todos-categories)
	 (cats (todos-sort cats0 sortkey))
	 (archive (member todos-current-todos-file todos-archives))
	 (todos-categories-category-number 0)
	 ;; Find start of Category button if we just entered Todos Categories
	 ;; mode.
	 (pt (if (eq (point) (point-max))
		 (save-excursion
		   (forward-line -2)
		   (goto-char (next-single-char-property-change
			       (point) 'face nil (line-end-position))))))
	 (buffer-read-only))
    (forward-line 2)
    (delete-region (point) (point-max))
    ;; Fill in the table with buttonized lines, each showing a category and
    ;; its item counts.
    (mapc (lambda (cat) (todos-insert-category-line cat sortkey))
	  (mapcar 'car cats))
    (newline)
    ;; Add a line showing item count totals.
    (insert (make-string (+ 4 (length todos-categories-number-separator)) 32)
	    (todos-padded-string todos-categories-totals-label)
	    (mapconcat
	     (lambda (elt)
	       (concat
		(make-string (1+ (/ (length (car elt)) 2)) 32)
		(format "%3d" (nth (cdr elt) (todos-total-item-counts)))
		;; Add an extra space if label length is odd (using
		;; definition of oddp from cl.el).
		(if (eq (logand (length (car elt)) 1) 1) " ")))
	     (if archive
		 (list (cons todos-categories-done-label 2))
	       (list (cons todos-categories-todo-label 0)
		     (cons todos-categories-diary-label 1)
		     (cons todos-categories-done-label 2)
		     (cons todos-categories-archived-label 3)))
	     ""))
    ;; Put cursor on Category button initially.
    (if pt (goto-char pt))
    (setq buffer-read-only t)))

;; ---------------------------------------------------------------------------
;;; Routines for generating Todos insertion commands and key bindings

;; Can either of these be included in Emacs?  The originals are GFDL'd.

;; Slightly reformulated from
;; http://rosettacode.org/wiki/Power_set#Common_Lisp.
(defun powerset-recursive (l)
  (cond ((null l)
	 (list nil))
	(t
	 (let ((prev (powerset-recursive (cdr l))))
	   (append (mapcar (lambda (elt) (cons (car l) elt))
			   prev)
		   prev)))))

;; Elisp implementation of http://rosettacode.org/wiki/Power_set#C
(defun powerset-bitwise (l)
  (let ((binnum (lsh 1 (length l)))
	 pset elt)
    (dotimes (i binnum)
      (let ((bits i)
	    (ll l))
	(while (not (zerop bits))
	  (let ((arg (pop ll)))
	    (unless (zerop (logand bits 1))
	      (setq elt (append elt (list arg))))
	    (setq bits (lsh bits -1))))
	(setq pset (append pset (list elt)))
	(setq elt nil)))
    pset))

;; (defalias 'todos-powerset 'powerset-recursive)
(defalias 'todos-powerset 'powerset-bitwise)

;; Return list of lists of non-nil atoms produced from ARGLIST.  The elements
;; of ARGLIST may be atoms or lists.
(defun todos-gen-arglists (arglist)
  (let (arglists)
    (while arglist
      (let ((arg (pop arglist)))
	(cond ((symbolp arg)
	       (setq arglists (if arglists
				  (mapcar (lambda (l) (push arg l)) arglists)
				(list (push arg arglists)))))
	      ((listp arg)
	       (setq arglists
		     (mapcar (lambda (a)
			       (if (= 1 (length arglists))
				   (apply (lambda (l) (push a l)) arglists)
				 (mapcar (lambda (l) (push a l)) arglists)))
			     arg))))))
    (setq arglists (mapcar 'reverse (apply 'append (mapc 'car arglists))))))

(defvar todos-insertion-commands-args-genlist
  '(diary nonmarking (calendar date dayname) time (here region))
  "Generator list for argument lists of Todos insertion commands.")

(defvar todos-insertion-commands-args
  (let ((argslist (todos-gen-arglists todos-insertion-commands-args-genlist))
	res new)
    (setq res (remove-duplicates
	       (apply 'append (mapcar 'todos-powerset argslist)) :test 'equal))
    (dolist (l res)
      (unless (= 5 (length l))
	(let ((v (make-vector 5 nil)) elt)
	  (while l
	    (setq elt (pop l))
	    (cond ((eq elt 'diary)
		   (aset v 0 elt))
		  ((eq elt 'nonmarking)
		   (aset v 1 elt))
		  ((or (eq elt 'calendar)
		       (eq elt 'date)
		       (eq elt 'dayname))
		   (aset v 2 elt))
		  ((eq elt 'time)
		   (aset v 3 elt))
		  ((or (eq elt 'here)
		       (eq elt 'region))
		   (aset v 4 elt))))
	  (setq l (append v nil))))
      (setq new (append new (list l))))
    new)
  "List of all argument lists for Todos insertion commands.")

(defun todos-insertion-command-name (arglist)
  "Generate Todos insertion command name from ARGLIST."
  (replace-regexp-in-string
   "-\\_>" ""
   (replace-regexp-in-string
    "-+" "-"
    (concat "todos-item-insert-"
	    (mapconcat (lambda (e) (if e (symbol-name e))) arglist "-")))))

(defvar todos-insertion-commands-names
  (mapcar (lambda (l)
	   (todos-insertion-command-name l))
	  todos-insertion-commands-args)
  "List of names of Todos insertion commands.")

(defmacro todos-define-insertion-command (&rest args)
  (let ((name (intern (todos-insertion-command-name args)))
	(arg0 (nth 0 args))
	(arg1 (nth 1 args))
	(arg2 (nth 2 args))
	(arg3 (nth 3 args))
	(arg4 (nth 4 args)))
    `(defun ,name (&optional arg)
       "Todos item insertion command generated from ARGS."
       (interactive)
       (todos-insert-item arg ',arg0 ',arg1 ',arg2 ',arg3 ',arg4))))

(defvar todos-insertion-commands
  (mapcar (lambda (c)
	    (eval `(todos-define-insertion-command ,@c)))
	  todos-insertion-commands-args)
  "List of Todos insertion commands.")

(defvar todos-insertion-commands-arg-key-list
  '(("diary" "y" "yy")
    ("nonmarking" "k" "kk")
    ("calendar" "c" "cc")
    ("date" "d" "dd")
    ("dayname" "n" "nn")
    ("time" "t" "tt")
    ("here" "h" "h")
    ("region" "r" "r"))
  "")    

(defun todos-insertion-key-bindings (map)
  ""
  (dolist (c todos-insertion-commands)
    (let* ((key "")
	   (cname (symbol-name c)))
      (mapc (lambda (l)
	      (let ((arg (nth 0 l))
		    (key1 (nth 1 l))
		    (key2 (nth 2 l)))
		(if (string-match (concat (regexp-quote arg) "\\_>") cname)
		    (setq key (concat key key2)))
		(if (string-match (concat (regexp-quote arg) ".+") cname)
		    (setq key (concat key key1)))))
	    todos-insertion-commands-arg-key-list)
      (if (string-match (concat (regexp-quote "todos-item-insert") "\\_>") cname)
	  (setq key (concat key "i")))
      (define-key map key c))))

(defvar todos-insertion-map
  (let ((map (make-keymap)))
    (todos-insertion-key-bindings map)
    map)
  "Keymap for Todos mode insertion commands.")

;; ---------------------------------------------------------------------------
;;; Key maps and menus

(defvar todos-key-bindings
  `(
    ;;               display
    ("Cd"	     . todos-display-categories) ;FIXME: Cs todos-show-categories?
    ;(""	     . todos-display-categories-alphabetically)
    ("H"	     . todos-highlight-item)
    ("N"	     . todos-hide-show-item-numbering)
    ("D"	     . todos-hide-show-date-time)
    ("*"	     . todos-mark-unmark-item)
    ("C*"	     . todos-mark-category)
    ("Cu"	     . todos-unmark-category)
    ("PP"	     . todos-print)
    ("PF"	     . todos-print-to-file)
    ("v"	     . todos-hide-show-done-items)
    ("V"	     . todos-show-done-only)
    ("As"	     . todos-show-archive)
    ("Ac"	     . todos-choose-archive)
    ("Y"	     . todos-diary-items)
    ("Fe"	     . todos-edit-multiline)
    ("Fh"	     . todos-highlight-item)
    ("Fn"	     . todos-hide-show-item-numbering)
    ("Fd"	     . todos-hide-show-date-time)
    ("Ftt"	     . todos-top-priorities)
    ("Ftm"	     . todos-top-priorities-multifile)
    ("Fts"	     . todos-set-top-priorities-in-file)
    ("Cts"	     . todos-set-top-priorities-in-category)
    ("Fyy"	     . todos-diary-items)
    ("Fym"	     . todos-diary-items-multifile)
    ("Fxx"	     . todos-regexp-items)
    ("Fxm"	     . todos-regexp-items-multifile)
    ;;               navigation		        
    ("f"	     . todos-forward-category)
    ("b"	     . todos-backward-category)
    ("j"	     . todos-jump-to-category)
    ("J"	     . todos-jump-to-category-other-file)
    ("n"	     . todos-forward-item)
    ("p"	     . todos-backward-item)
    ("S"	     . todos-search)
    ("X"	     . todos-clear-matches)
    ;;               editing			        
    ("Fa"	     . todos-add-file)
    ("Ca"	     . todos-add-category)
    ("Cr"	     . todos-rename-category)
    ("Cg"	     . todos-merge-category)
    ;;(""	     . todos-merge-categories)
    ("Cm"	     . todos-move-category)
    ("Ck"	     . todos-delete-category)
    ("d"	     . todos-item-done)
    ("ee"	     . todos-edit-item)
    ("em"	     . todos-edit-multiline-item)
    ("eh"	     . todos-edit-item-header)
    ("edd"	     . todos-edit-item-date)
    ("edc"	     . todos-edit-item-date-from-calendar)
    ("edt"	     . todos-edit-item-date-is-today)
    ("et"	     . todos-edit-item-time)
    ("eyy"	     . todos-edit-item-diary-inclusion)
    ;; (""	     . todos-edit-category-diary-inclusion)
    ("eyn"	     . todos-edit-item-diary-nonmarking)
    ;;(""	     . todos-edit-category-diary-nonmarking)
    ("ec"	     . todos-done-item-add-edit-or-delete-comment)
    ("i"	     . ,todos-insertion-map)
    ("k"	     . todos-delete-item) ;FIXME: not single letter?
    ("m"	     . todos-move-item)
    ("M"	     . todos-move-item-to-file)
    ("r"	     . todos-raise-item-priority)
    ("l"	     . todos-lower-item-priority)
    ("#"	     . todos-set-item-priority)
    ("u"	     . todos-item-undo)
    ("Ad"	     . todos-archive-done-item)  ;FIXME: ad
    ("AD"	     . todos-archive-category-done-items) ;FIXME: aD or C-u ad ?
    ("s"	     . todos-save)
    ("q"	     . todos-quit)
    ([remap newline] . newline-and-indent)
   )
  "Alist pairing keys defined in Todos modes and their bindings.")

(defvar todos-mode-map
  (let ((map (make-keymap)))
    ;; Don't suppress digit keys, so they can supply prefix arguments.
    (suppress-keymap map)
    (dolist (ck todos-key-bindings)
      (define-key map (car ck) (cdr ck)))
    map)
  "Todos mode keymap.")

;; FIXME
(easy-menu-define
  todos-menu todos-mode-map "Todos Menu"
  '("Todos"
    ("Navigation"
     ["Next Item"            todos-forward-item t]
     ["Previous Item"        todos-backward-item t]
     "---"
     ["Next Category"        todos-forward-category t]
     ["Previous Category"    todos-backward-category t]
     ["Jump to Category"     todos-jump-to-category t]
     ["Jump to Category in Other File" todos-jump-to-category-other-file t]
     "---"
     ["Search Todos File"    todos-search t]
     ["Clear Highlighting on Search Matches" todos-category-done t])
    ("Display"
     ["List Current Categories" todos-display-categories t]
     ;; ["List Categories Alphabetically" todos-display-categories-alphabetically t]
     ["Turn Item Highlighting on/off" todos-highlight-item t]
     ["Turn Item Numbering on/off" todos-hide-show-item-numbering t]
     ["Turn Item Time Stamp on/off" todos-hide-show-date-time t]
     ["View/Hide Done Items" todos-hide-show-done-items t]
     "---"
     ["View Diary Items" todos-diary-items t]
     ["View Top Priority Items" todos-top-priorities t]
     ["View Multifile Top Priority Items" todos-top-priorities-multifile t]
     "---"
     ["Print Category"     todos-print t])
    ("Editing"
     ["Insert New Item"      todos-insert-item t]
     ["Insert Item Here"     todos-insert-item-here t]
     ("More Insertion Commands")
     ["Edit Item"            todos-edit-item t]
     ["Edit Multiline Item"  todos-edit-multiline t]
     ["Edit Item Header"     todos-edit-item-header t]
     ["Edit Item Date"       todos-edit-item-date t]
     ["Edit Item Time"       todos-edit-item-time t]
     "---"
     ["Lower Item Priority"  todos-lower-item-priority t]
     ["Raise Item Priority"  todos-raise-item-priority t]
     ["Set Item Priority" todos-set-item-priority t]
     ["Move (Recategorize) Item" todos-move-item t]
     ["Delete Item"          todos-delete-item t]
     ["Undo Done Item" todos-item-undo t]
     ["Mark/Unmark Item for Diary" todos-toggle-item-diary-inclusion t]
     ["Mark/Unmark Items for Diary" todos-edit-item-diary-inclusion t]
     ["Mark & Hide Done Item" todos-item-done t]
     ["Archive Done Items" todos-archive-category-done-items t]
     "---"
     ["Add New Todos File" todos-add-file t]
     ["Add New Category" todos-add-category t]
     ["Delete Current Category" todos-delete-category t]
     ["Rename Current Category" todos-rename-category t]
     "---"
     ["Save Todos File"      todos-save t]
     )
    "---"
    ["Quit"                 todos-quit t]
    ))

(defvar todos-archive-mode-map
  (let ((map (make-sparse-keymap)))
    (suppress-keymap map t)
    ;; navigation commands
    (define-key map "f" 'todos-forward-category)
    (define-key map "b" 'todos-backward-category)
    (define-key map "j" 'todos-jump-to-category)
    (define-key map "n" 'todos-forward-item)
    (define-key map "p" 'todos-backward-item)
    ;; display commands
    (define-key map "C" 'todos-display-categories)
    (define-key map "H" 'todos-highlight-item)
    (define-key map "N" 'todos-hide-show-item-numbering)
    ;; (define-key map "" 'todos-hide-show-date-time)
    (define-key map "P" 'todos-print)
    (define-key map "q" 'todos-quit)
    (define-key map "s" 'todos-save)
    (define-key map "S" 'todos-search)
    (define-key map "t" 'todos-show)
    (define-key map "u" 'todos-unarchive-items)
    (define-key map "U" 'todos-unarchive-category)
    map)
  "Todos Archive mode keymap.")

(defvar todos-edit-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\C-x\C-q" 'todos-edit-quit)
    (define-key map [remap newline] 'newline-and-indent)
    map)
  "Todos Edit mode keymap.")

(defvar todos-categories-mode-map
  (let ((map (make-sparse-keymap)))
    (suppress-keymap map t)
    (define-key map "c" 'todos-display-categories-alphabetically-or-by-priority)
    (define-key map "t" 'todos-display-categories-sorted-by-todo)
    (define-key map "y" 'todos-display-categories-sorted-by-diary)
    (define-key map "d" 'todos-display-categories-sorted-by-done)
    (define-key map "a" 'todos-display-categories-sorted-by-archived)
    (define-key map "l" 'todos-lower-category-priority)
    (define-key map "+" 'todos-lower-category-priority)
    (define-key map "r" 'todos-raise-category-priority)
    (define-key map "-" 'todos-raise-category-priority)
    (define-key map "n" 'forward-button)
    (define-key map "p" 'backward-button)
    (define-key map [tab] 'forward-button)
    (define-key map [backtab] 'backward-button)
    (define-key map "q" 'todos-quit)
    ;; (define-key map "A" 'todos-add-category)
    ;; (define-key map "D" 'todos-delete-category)
    ;; (define-key map "R" 'todos-rename-category)
    map)
  "Todos Categories mode keymap.")

(defvar todos-filtered-items-mode-map
  (let ((map (make-keymap)))
    (suppress-keymap map t)
    ;; navigation commands
    (define-key map "j" 'todos-jump-to-item)
    (define-key map [remap newline] 'todos-jump-to-item)
    (define-key map "n" 'todos-forward-item)
    (define-key map "p" 'todos-backward-item)
    (define-key map "H" 'todos-highlight-item)
    (define-key map "N" 'todos-hide-show-item-numbering)
    (define-key map "D" 'todos-hide-show-date-time)
    (define-key map "P" 'todos-print)
    (define-key map "q" 'todos-quit)
    (define-key map "s" 'todos-save)
    ;; editing commands
    (define-key map "l" 'todos-lower-item-priority)
    (define-key map "r" 'todos-raise-item-priority)
    (define-key map "#" 'todos-set-item-top-priority)
    map)
  "Todos Top Priorities mode keymap.")

;; ---------------------------------------------------------------------------
;;; Mode definitions

(defun todos-modes-set-1 ()
  ""
  (set (make-local-variable 'font-lock-defaults) '(todos-font-lock-keywords t))
  (set (make-local-variable 'indent-line-function) 'todos-indent)
  (when todos-wrap-lines (funcall todos-line-wrapping-function)))

(defun todos-modes-set-2 ()
  ""
  (add-to-invisibility-spec 'todos)
  (setq buffer-read-only t)
  (set (make-local-variable 'hl-line-range-function)
       (lambda() (when (todos-item-end)
		   (cons (todos-item-start) (todos-item-end))))))

(defun todos-modes-set-3 ()
  (set (make-local-variable 'todos-categories) (todos-set-categories))
  (set (make-local-variable 'todos-category-number) 1)
  (set (make-local-variable 'todos-first-visit) t)
  (add-hook 'find-file-hook 'todos-display-as-todos-file nil t))

(put 'todos-mode 'mode-class 'special)

;; FIXME: Autoloading isn't needed if files are identified by auto-mode-alist
;; ;; As calendar reads included Todos file before todos-mode is loaded.
;; ;;;###autoload
(define-derived-mode todos-mode special-mode "Todos" ()
  "Major mode for displaying, navigating and editing Todo lists.

\\{todos-mode-map}"
  (easy-menu-add todos-menu)
  (todos-modes-set-1)
  (todos-modes-set-2)
  (todos-modes-set-3)
  ;; Initialize todos-current-todos-file.
  (when (member (file-truename (buffer-file-name))
		(funcall todos-files-function))
    (set (make-local-variable 'todos-current-todos-file)
  	 (file-truename (buffer-file-name))))
  (set (make-local-variable 'todos-first-visit) t)
  (set (make-local-variable 'todos-show-done-only) nil)
  (set (make-local-variable 'todos-categories-with-marks) nil)
  (add-hook 'find-file-hook 'todos-add-to-buffer-list nil t)
  (add-hook 'post-command-hook 'todos-update-buffer-list nil t)
  (when todos-show-current-file
    (add-hook 'pre-command-hook 'todos-show-current-file nil t))
  (add-hook 'window-configuration-change-hook
	    ;; FIXME
	    (lambda ()
	      (let ((sep todos-done-separator))
		(setq todos-done-separator (todos-done-separator))
		(save-excursion
		  (save-restriction
		    (widen)
		    (goto-char (point-min))
		    (while (re-search-forward
			    (concat "\n\\(" (regexp-quote todos-category-done)
				    "\\)") nil t)
		      (setq beg (match-beginning 1))
		      (setq end (match-end 0))
		      (let* ((ovs (overlays-at beg))
			     old-sep new-sep)
			(and ovs
			     (setq old-sep (overlay-get (car ovs) 'display))
			     (string= old-sep sep)
			     (delete-overlay (car ovs))
			     (setq new-sep (make-overlay beg end))
			     (overlay-put new-sep 'display
					  todos-done-separator)))))))) nil t)
  (add-hook 'kill-buffer-hook 'todos-reset-global-current-todos-file nil t))

;; FIXME: need this?
(defun todos-unload-hook ()
  ""
  (remove-hook 'pre-command-hook 'todos-show-current-file t)
  (remove-hook 'post-command-hook 'todos-update-buffer-list t)
  (remove-hook 'find-file-hook 'todos-display-as-todos-file t)
  (remove-hook 'find-file-hook 'todos-add-to-buffer-list t)
  (remove-hook 'window-configuration-change-hook
	       ;; FIXME
	       (lambda () (setq todos-done-separator (todos-done-separator))) t)
  (remove-hook 'kill-buffer-hook 'todos-reset-global-current-todos-file t))

(put 'todos-archive-mode 'mode-class 'special)

;; If todos-mode is parent, all todos-mode key bindings appear to be
;; available in todos-archive-mode (e.g. shown by C-h m).
(define-derived-mode todos-archive-mode special-mode "Todos-Arch" ()
  "Major mode for archived Todos categories.

\\{todos-archive-mode-map}"
  (todos-modes-set-1)
  (todos-modes-set-2)
  (todos-modes-set-3)
  (set (make-local-variable 'todos-current-todos-file)
       (file-truename (buffer-file-name)))
  (set (make-local-variable 'todos-show-done-only) t))

(defun todos-mode-external-set ()
  ""
  (set (make-local-variable 'todos-current-todos-file)
       todos-global-current-todos-file)
  (let ((cats (with-current-buffer
		  (find-buffer-visiting todos-current-todos-file)
		todos-categories)))
    (set (make-local-variable 'todos-categories) cats)))

(define-derived-mode todos-edit-mode text-mode "Todos-Ed" ()
  "Major mode for editing multiline Todo items.

\\{todos-edit-mode-map}"
  (todos-modes-set-1)
  (todos-mode-external-set))

(put 'todos-categories-mode 'mode-class 'special)

(define-derived-mode todos-categories-mode special-mode "Todos-Cats" ()
  "Major mode for displaying and editing Todos categories.

\\{todos-categories-mode-map}"
  (todos-mode-external-set))

(put 'todos-filter-mode 'mode-class 'special)

(define-derived-mode todos-filtered-items-mode special-mode "Todos-Fltr" ()
  "Mode for displaying and reprioritizing top priority Todos.

\\{todos-filtered-items-mode-map}"
  (todos-modes-set-1)
  (todos-modes-set-2))

;; ---------------------------------------------------------------------------
;;; Todos Commands

;; ---------------------------------------------------------------------------
;;; Entering and Exiting

;;;###autoload
(defun todos-show (&optional solicit-file)
  "Visit the current Todos file and display one of its categories.
With non-nil prefix argument SOLICIT-FILE prompt for which todo
file to visit.

Without a prefix argument, the first invocation of this command
in a session visits `todos-default-todos-file' (creating it if it
does not yet exist); subsequent invocations from outside of Todos
mode revisit this file or, if the user option
`todos-show-current-file' is non-nil, whichever Todos file
\(either a todo or an archive file) was visited last.

The category displayed on initial invocation is the first member
of `todos-categories' for the current Todos file, on subsequent
invocations whichever category was displayed last.  If
`todos-display-categories-first' is non-nil, then the first
invocation of `todos-show' displays a clickable listing of the
categories in the current Todos file.

In Todos mode just the category's unfinished todo items are shown
by default.  The done items are hidden, but typing
`\\[todos-hide-show-done-items]' displays them below the todo
items.  With non-nil user option `todos-show-with-done' both todo
and done items are always shown on visiting a category.

If this command is invoked in Todos Archive mode, it visits the
corresponding Todos file, displaying the corresponding category."
  (interactive "P")
  (let* ((cat)
	 (file (cond (solicit-file
		      (if (funcall todos-files-function)
			  (todos-read-file-name "Choose a Todos file to visit: "
						nil t)
			(error "There are no Todos files")))
		     ((and (eq major-mode 'todos-archive-mode)
			   ;; Called noninteractively via todos-quit from
			   ;; Todos Categories mode to return to archive file.
			   (called-interactively-p 'any))
		      (setq cat (todos-current-category))
		      (concat (file-name-sans-extension todos-current-todos-file)
			      ".todo"))
		     (t
		      (or todos-current-todos-file
			  (and todos-show-current-file
			       todos-global-current-todos-file)
			  todos-default-todos-file
			  (todos-add-file))))))
    (if (and todos-first-visit todos-display-categories-first)
	(todos-display-categories)
      (set-window-buffer (selected-window)
			 (set-buffer (find-file-noselect file)))
      ;; If called from archive file, show corresponding category in Todos
      ;; file, if it exists.
      (when (assoc cat todos-categories)
	(setq todos-category-number (todos-category-number cat)))
      ;; If no Todos file exists, initialize one.
      (when (zerop (buffer-size))
	;; Call with empty category name to get initial prompt.
	(setq todos-category-number (todos-add-category "")))
      (save-excursion (todos-category-select)))
    (setq todos-first-visit nil)))

(defun todos-display-categories ()
  "Display a table of the current file's categories and item counts.

In the initial display the categories are numbered, indicating
their current order for navigating by \\[todos-forward-category]
and \\[todos-backward-category].  You can persistantly change the
order of the category at point by typing
\\[todos-raise-category-priority] or
\\[todos-lower-category-priority].

The labels above the category names and item counts are buttons,
and clicking these changes the display: sorted by category name
or by the respective item counts (alternately descending or
ascending).  In these displays the categories are not numbered
and \\[todos-raise-category-priority] and
\\[todos-lower-category-priority] are
disabled.  (Programmatically, the sorting is triggered by passing
a non-nil SORTKEY argument.)

In addition, the lines with the category names and item counts
are buttonized, and pressing one of these button jumps to the
category in Todos mode (or Todos Archive mode, for categories
containing only archived items, provided user option
`todos-skip-archived-categories' is non-nil.  These categories
are shown in `todos-archived-only' face."
  (interactive)
  (todos-display-categories-1)
  (let (sortkey)
    (todos-update-categories-display sortkey)))

(defun todos-display-categories-alphabetically-or-by-priority ()
  ""
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (forward-line 2)
    (if (member 'alpha todos-descending-counts)
	(progn
	  (todos-update-categories-display nil)
	  (setq todos-descending-counts
		(delete 'alpha todos-descending-counts)))
      (todos-update-categories-display 'alpha))))

(defun todos-display-categories-sorted-by-todo ()
  ""
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (forward-line 2)
    (todos-update-categories-display 'todo)))

(defun todos-display-categories-sorted-by-diary ()
  ""
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (forward-line 2)
    (todos-update-categories-display 'diary)))

(defun todos-display-categories-sorted-by-done ()
  ""
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (forward-line 2)
    (todos-update-categories-display 'done)))

(defun todos-display-categories-sorted-by-archived ()
  ""
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (forward-line 2)
    (todos-update-categories-display 'archived)))

(defun todos-show-archive (&optional ask)
  "Visit the archive of the current Todos category, if it exists.
If the category has no archived items, prompt to visit the
archive anyway.  If there is no archive for this file or with
non-nil argument ASK, prompt to visit another archive.

The buffer showing the archive is in Todos Archive mode.  The
first visit in a session displays the first category in the
archive, subsequent visits return to the last category
displayed."
  (interactive)
  (let* ((cat (todos-current-category))
	 (count (todos-get-count 'archived cat))
	 (archive (concat (file-name-sans-extension todos-current-todos-file)
			  ".toda"))
	 place)
    (setq place (cond (ask 'other-archive)
		      ((file-exists-p archive) 'this-archive)
		      (t (when (y-or-n-p (concat "This file has no archive; "
						 "visit another archive? "))
			   'other-archive))))
    (when (eq place 'other-archive)
      (setq archive (todos-read-file-name "Choose a Todos archive: " t t)))
    (when (and (eq place 'this-archive) (zerop count))
      (setq place (when (y-or-n-p
			  (concat "This category has no archived items;"
				  " visit archive anyway? "))
		     'other-cat)))
    (when place
      (set-window-buffer (selected-window)
			 (set-buffer (find-file-noselect archive)))
      (if (member place '(other-archive other-cat))
	  (setq todos-category-number 1)
	(todos-category-number cat))
      (todos-category-select))))

(defun todos-choose-archive ()
  "Choose an archive and visit it."
  (interactive)
  (todos-show-archive t))

;; FIXME: need this?
(defun todos-save ()
  "Save the current Todos file."
  (interactive)
  (save-buffer))

(defun todos-quit ()
  "Exit the current Todos-related buffer.
Depending on the specific mode, this either kills the buffer or
buries it and restores state as needed."
  (interactive)
  (cond ((eq major-mode 'todos-categories-mode)
	 (kill-buffer)
	 (setq todos-descending-counts nil)
	 (todos-show))
	((eq major-mode 'todos-filtered-items-mode)
	 (kill-buffer)
	 (todos-show))
	((member major-mode (list 'todos-mode 'todos-archive-mode))
	 ;; Have to write previously nonexistant archives to file.
	 (unless (file-exists-p (buffer-file-name)) (todos-save))
	 ;; FIXME: make this customizable?
	 (todos-save)
	 (bury-buffer))))

(defun todos-print (&optional to-file)
  "Produce a printable version of the current Todos buffer.
This converts overlays and soft line wrapping and, depending on
the value of `todos-print-function', includes faces.  With
non-nil argument TO-FILE write the printable version to a file;
otherwise, send it to the default printer."
  (interactive)
  (let ((buf todos-print-buffer)
	(header (cond
		 ((eq major-mode 'todos-mode)
		  (concat "Todos File: "
			  (todos-short-file-name todos-current-todos-file)
			  "\nCategory: " (todos-current-category)))
		 ((eq major-mode 'todos-filtered-items-mode)
		  "Todos Top Priorities")))
	(prefix (propertize (concat todos-prefix " ")
			    'face 'todos-prefix-string))
	(num 0)
	(fill-prefix (make-string todos-indent-to-here 32))
	(content (buffer-string))
	file)
    (with-current-buffer (get-buffer-create buf)
      (insert content)
      (goto-char (point-min))
      (while (not (eobp))
	(let ((beg (point))
	      (end (save-excursion (todos-item-end))))
	  (when todos-number-priorities
	    (setq num (1+ num))
	    (setq prefix (propertize (concat (number-to-string num) " ")
				     'face 'todos-prefix-string)))
	  (insert prefix)
	  (fill-region beg end))
	;; Calling todos-forward-item infloops at todos-item-start due to
	;; non-overlay prefix, so search for item start instead.
	(if (re-search-forward todos-item-start nil t)
	    (beginning-of-line)
	  (goto-char (point-max))))
      (if (re-search-backward (concat "^" (regexp-quote todos-category-done))
			      nil t)
	  (replace-match todos-done-separator))
      (goto-char (point-min))
      (insert header)
      (newline 2)
      (if to-file
	  (let ((file (read-file-name "Print to file: ")))
	    (funcall todos-print-function file))
	(funcall todos-print-function)))
    (kill-buffer buf)))

(defun todos-print-to-file ()
  "Save printable version of this Todos buffer to a file."
  (interactive)
  (todos-print t))

(defun todos-convert-legacy-files ()
  "Convert legacy Todo files to the current Todos format.
The files `todo-file-do' and `todo-file-done' are converted and
saved (the latter as a Todos Archive file) with a new name in
`todos-files-directory'.  See also the documentation string of
`todos-todo-mode-date-time-regexp' for further details."
  (interactive)
  (if (fboundp 'todo-mode)
      (require 'todo-mode)
    (error "Void function `todo-mode'"))
  ;; Convert `todo-file-do'.
  (if (file-exists-p todo-file-do)
      (let ((default "todo-do-conv")
	    file archive-sexp)
	(with-temp-buffer
	  (insert-file-contents todo-file-do)
	  (let ((end (search-forward ")" (line-end-position) t))
		(beg (search-backward "(" (line-beginning-position) t)))
	    (setq todo-categories
		  (read (buffer-substring-no-properties beg end))))
	  (todo-mode)
	  (delete-region (line-beginning-position) (1+ (line-end-position)))
	  (while (not (eobp))
	    (cond
	     ((looking-at (regexp-quote (concat todo-prefix todo-category-beg)))
	      (replace-match todos-category-beg))
	     ((looking-at (regexp-quote todo-category-end))
	      (replace-match ""))
	     ((looking-at (regexp-quote (concat todo-prefix " "
						todo-category-sep)))
	      (replace-match todos-category-done))
	     ((looking-at (concat (regexp-quote todo-prefix) " "
				  todos-todo-mode-date-time-regexp " "
				  (regexp-quote todo-initials) ":"))
	      (todos-convert-legacy-date-time)))
	    (forward-line))
	  (setq file (concat todos-files-directory
			     (read-string
			      (format "Save file as (default \"%s\"): " default)
			      nil nil default)
			     ".todo"))
	  (write-region (point-min) (point-max) file nil 'nomessage nil t))
	(with-temp-buffer
	  (insert-file-contents file)
	  (let ((todos-categories (todos-make-categories-list t)))
	    (todos-update-categories-sexp))
	  (write-region (point-min) (point-max) file nil 'nomessage))
	;; Convert `todo-file-done'.
	(when (file-exists-p todo-file-done)
	  (with-temp-buffer
	    (insert-file-contents todo-file-done)
	    (let ((beg (make-marker))
		  (end (make-marker))
		  cat cats comment item)
	      (while (not (eobp))
		(when (looking-at todos-todo-mode-date-time-regexp)
		  (set-marker beg (point))
		  (todos-convert-legacy-date-time)
		  (set-marker end (point))
		  (goto-char beg)
		  (insert "[" todos-done-string)
		  (goto-char end)
		  (insert "]")
		  (forward-char)
		  (when (looking-at todos-todo-mode-date-time-regexp)
		    (todos-convert-legacy-date-time))
		  (when (looking-at (concat " " (regexp-quote todo-initials) ":"))
		    (replace-match "")))
		(if (re-search-forward
		     (concat "^" todos-todo-mode-date-time-regexp) nil t)
		    (goto-char (match-beginning 0))
		  (goto-char (point-max)))
		(backward-char)
		(when (looking-back "\\[\\([^][]+\\)\\]")
		  (setq cat (match-string 1))
		  (goto-char (match-beginning 0))
		  (replace-match ""))
		;; If the item ends with a non-comment parenthesis not
		;; followed by a period, we lose (but we inherit that problem
		;; from todo-mode.el).
		(when (looking-back "(\\(.*\\)) ")
		  (setq comment (match-string 1))
		  (replace-match "")
		  (insert "[" todos-comment-string ": " comment "]"))
		(set-marker end (point))
		(if (member cat cats)
		    ;; If item is already in its category, leave it there.
		    (unless (save-excursion
			      (re-search-backward
			       (concat "^" (regexp-quote todos-category-beg)
				       "\\(.*\\)$") nil t)
			      (string= (match-string 1) cat))
		      ;; Else move it to its category.
		      (setq item (buffer-substring-no-properties beg end))
		      (delete-region beg (1+ end))
		      (set-marker beg (point))
		      (re-search-backward
		       (concat "^" (regexp-quote (concat todos-category-beg cat)))
		       nil t)
		      (forward-line)
		      (if (re-search-forward
			   (concat "^" (regexp-quote todos-category-beg)
				   "\\(.*\\)$") nil t)
			  (progn (goto-char (match-beginning 0))
				 (newline)
				 (forward-line -1))
			(goto-char (point-max)))
		      (insert item "\n")
		      (goto-char beg))
		  (push cat cats)
		  (goto-char beg)
		  (insert todos-category-beg cat "\n\n" todos-category-done "\n"))
		(forward-line))
	      (set-marker beg nil)
	      (set-marker end nil))
	    (setq file (concat (file-name-sans-extension file) ".toda"))
	    (write-region (point-min) (point-max) file nil 'nomessage nil t))
	  (with-temp-buffer
	    (insert-file-contents file)
	    (let ((todos-categories (todos-make-categories-list t)))
	      (todos-update-categories-sexp))
	    (write-region (point-min) (point-max) file nil 'nomessage)
	    (setq archive-sexp (read (buffer-substring-no-properties
				      (line-beginning-position)
				      (line-end-position)))))
	  (setq file (concat (file-name-sans-extension file) ".todo"))
	  ;; Update categories sexp of converted Todos file again, adding
	  ;; counts of archived items.
	  (with-temp-buffer
	    (insert-file-contents file)
	    (let ((sexp (read (buffer-substring-no-properties
			       (line-beginning-position)
			       (line-end-position)))))
	      (dolist (cat sexp)
		(let ((archive-cat (assoc (car cat) archive-sexp)))
		  (if archive-cat
		      (aset (cdr cat) 3 (aref (cdr archive-cat) 2)))))
	      (delete-region (line-beginning-position) (line-end-position))
	      (prin1 sexp (current-buffer)))
	    (write-region (point-min) (point-max) file nil 'nomessage)))
	  (todos-reevaluate-defcustoms)
	(message "Format conversion done."))
    (error "No legacy Todo file exists")))

;; ---------------------------------------------------------------------------
;;; Navigation Commands

(defun todos-forward-category (&optional back)
  "Visit the numerically next category in this Todos file.
If the current category is the highest numbered, visit the first
category.  With non-nil argument BACK, visit the numerically
previous category (the highest numbered one, if the current
category is the first)."
  (interactive)
  (setq todos-category-number
        (1+ (mod (- todos-category-number (if back 2 0))
		 (length todos-categories))))
  (when todos-skip-archived-categories
    (while (and (zerop (todos-get-count 'todo))
		(zerop (todos-get-count 'done))
		(not (zerop (todos-get-count 'archive))))
      (setq todos-category-number
	    (apply (if back '1- '1+) (list todos-category-number)))))
  (todos-category-select)
  (goto-char (point-min)))

(defun todos-backward-category ()
  "Visit the numerically previous category in this Todos file.
If the current category is the highest numbered, visit the first
category."
  (interactive)
  (todos-forward-category t))

(defun todos-jump-to-category (&optional cat other-file)
  "Jump to a category in this or another Todos file.

Programmatically, optional argument CAT provides the category
name.  When nil (as in interactive calls), prompt for the
category, with TAB completion on existing categories.  If a
non-existing category name is entered, ask whether to add a new
category with this name; if affirmed, add it, then jump to that
category.  With non-nil argument OTHER-FILE, prompt for a Todos
file, otherwise jump within the current Todos file."
  (interactive)
  (let ((file (or (and other-file
		       (todos-read-file-name "Choose a Todos file: " nil t))
		  ;; Jump to archived-only Categories from Todos Categories
		  ;; mode.
		  (and cat
		       todos-skip-archived-categories
		       (zerop (todos-get-count 'todo cat))
		       (zerop (todos-get-count 'done cat))
		       (not (zerop (todos-get-count 'archived cat)))
		       (concat (file-name-sans-extension
				todos-current-todos-file) ".toda"))
		  todos-current-todos-file
		  ;; If invoked from outside of Todos mode before
		  ;; todos-show...
		  todos-default-todos-file)))
    (with-current-buffer (find-file-noselect file)
      (and other-file (setq todos-current-todos-file file))
      (let ((category (or (and (assoc cat todos-categories) cat)
			  (todos-read-category "Jump to category: "))))
	;; Clean up after selecting category in Todos Categories mode.
	(if (string= (buffer-name) todos-categories-buffer)
	    (kill-buffer))
	(if (or cat other-file)
	    (set-window-buffer (selected-window)
			       (set-buffer (find-buffer-visiting file))))
	(unless todos-global-current-todos-file
	  (setq todos-global-current-todos-file todos-current-todos-file))
	(todos-category-number category) ; (1+ (length t-c)) if new category.
	;; (if (> todos-category-number (length todos-categories))
	;;     (setq todos-category-number (todos-add-category category)))
	(todos-category-select)
	(goto-char (point-min))))))

(defun todos-jump-to-category-other-file ()
  "Jump to a category in another Todos file.
The category is chosen by prompt, with TAB completion."
  (interactive)
  (todos-jump-to-category nil t))

(defun todos-jump-to-item ()
  "Jump to the file and category of the filtered item at point."
  (interactive)
  (let ((str (todos-item-string))
	(buf (current-buffer))
	cat file archive beg)
    (string-match (concat (if todos-filter-done-items
			      (concat "\\(?:" todos-done-string-start "\\|"
				      todos-date-string-start "\\)")
			    todos-date-string-start)
			  todos-date-pattern "\\(?: " diary-time-regexp "\\)?"
			  (if todos-filter-done-items
			      "\\]"
			    (regexp-quote todos-nondiary-end)) "?"
			  "\\(?4: \\[\\(?3:(archive) \\)?\\(?2:.*:\\)?"
			  "\\(?1:.*\\)\\]\\).*$") str)
    (setq cat (match-string 1 str))
    (setq file (match-string 2 str))
    (setq archive (string= (match-string 3 str) "(archive) "))
    (setq str (replace-match "" nil nil str 4))
    (setq file (if file
		   (concat todos-files-directory (substring file 0 -1)
			   (if archive ".toda" ".todo"))
		 (if archive
		     (concat (file-name-sans-extension
			      todos-global-current-todos-file) ".toda")
		   todos-global-current-todos-file)))
    (find-file-noselect file)
    (with-current-buffer (find-buffer-visiting file)
      (widen)
      (goto-char (point-min))
      (re-search-forward
       (concat "^" (regexp-quote (concat todos-category-beg cat))) nil t)
      (search-forward str)
      (setq beg (match-beginning 0)))
    (kill-buffer buf)
    (set-window-buffer (selected-window) (set-buffer (find-buffer-visiting file)))
    (setq todos-current-todos-file file)
    (setq todos-category-number (todos-category-number cat))
    (let ((todos-show-with-done (if todos-filter-done-items t
				  todos-show-with-done)))
      (todos-category-select))
    (goto-char beg)))

;; FIXME ? disallow prefix arg value < 1 (re-search-* allows these)
(defun todos-forward-item (&optional count)
  "Move point down to start of item with next lower priority.
With numerical prefix COUNT, move point COUNT items downward,"
  (interactive "P")
  (let* ((not-done (not (or (todos-done-item-p) (looking-at "^$"))))
	 (start (line-end-position)))
    (goto-char start)
    (if (re-search-forward todos-item-start nil t (or count 1))
	(goto-char (match-beginning 0))
      (goto-char (point-max)))
    ;; If points advances by one from a todo to a done item, go back to the
    ;; space above todos-done-separator, since that is a legitimate place to
    ;; insert an item.  But skip this space if count > 1, since that should
    ;; only stop on an item (FIXME: or not?)
    (when (and not-done (todos-done-item-p))
      (if (or (not count) (= count 1))
    	  (re-search-backward "^$" start t)))))
    ;; FIXME: The preceding sexp is insufficient when buffer is not narrowed,
    ;; since there could be no done items in this category, so the search puts
    ;; us on first todo item of next category.  Does this ever happen?  If so:
    ;; (let ((opoint) (point))
    ;;   (forward-line -1)
    ;;   (when (or (not count) (= count 1))
    ;; 	(cond ((looking-at (concat "^" (regexp-quote todos-category-beg)))
    ;; 	       (forward-line -2))
    ;; 	      ((looking-at (concat "^" (regexp-quote todos-category-done)))
    ;; 	       (forward-line -1))
    ;; 	      (t
    ;; 	       (goto-char opoint)))))))

(defun todos-backward-item (&optional count)
  "Move point up to start of item with next higher priority.
With numerical prefix COUNT, move point COUNT items upward,"
  (interactive "P")
  (let* ((done (todos-done-item-p)))
    ;; FIXME ? this moves to bob if on the first item (but so does previous-line)
    (todos-item-start)
    (unless (bobp)
      (re-search-backward todos-item-start nil t (or count 1)))
    ;; Unless this is a regexp filtered items buffer (which can contain
    ;; intermixed todo and done items), if points advances by one from a done
    ;; to a todo item, go back to the space above todos-done-separator, since
    ;; that is a legitimate place to insert an item.  But skip this space if
    ;; count > 1, since that should only stop on an item (FIXME: or not?)
    (when (and done (not (todos-done-item-p)) (or (not count) (= count 1))
	       (not (equal (buffer-name) todos-regexp-items-buffer)))
      (re-search-forward (concat "^" (regexp-quote todos-category-done)) nil t)
      (forward-line -1))))

;; FIXME: (i) Extend search to other Todos files. (ii) Allow navigating among
;; hits. (But these are available in another form with
;; todos-regexp-items-multifile.)
(defun todos-search ()
  "Search for a regular expression in this Todos file.
The search runs through the whole file and encompasses all and
only todo and done items; it excludes category names.  Multiple
matches are shown sequentially, highlighted in `todos-search'
face."
  (interactive)
  (let ((regex (read-from-minibuffer "Enter a search string (regexp): "))
	(opoint (point))
	matches match cat in-done ov mlen msg)
    (widen)
    (goto-char (point-min))
    (while (not (eobp))
      (setq match (re-search-forward regex nil t))
      (goto-char (line-beginning-position))
      (unless (or (equal (point) 1)
		  (looking-at (concat "^" (regexp-quote todos-category-beg))))
	(if match (push match matches)))
      (forward-line))
    (setq matches (reverse matches))
    (if matches
	(catch 'stop
	  (while matches
	    (setq match (pop matches))
	    (goto-char match)
	    (todos-item-start)
	    (when (looking-at todos-done-string-start)
	      (setq in-done t))
	    (re-search-backward (concat "^" (regexp-quote todos-category-beg)
					"\\(.*\\)\n") nil t)
	    (setq cat (match-string-no-properties 1))
	    (todos-category-number cat)
	    (todos-category-select)
	    (if in-done
		(unless todos-show-with-done (todos-hide-show-done-items)))
	    (goto-char match)
	    (setq ov (make-overlay (- (point) (length regex)) (point)))
	    (overlay-put ov 'face 'todos-search)
	    (when matches
	      (setq mlen (length matches))
	      (if (y-or-n-p
		   (if (> mlen 1)
		       (format "There are %d more matches; go to next match? "
			       mlen)
		     "There is one more match; go to it? "))
		  (widen)
		(throw 'stop (setq msg (if (> mlen 1)
					   (format "There are %d more matches."
						   mlen)
					 "There is one more match."))))))
	  (setq msg "There are no more matches."))
      (todos-category-select)
      (goto-char opoint)
      (message "No match for \"%s\"" regex))
    (when msg
      (if (y-or-n-p (concat msg "\nUnhighlight matches? "))
	  (todos-clear-matches)
	(message "You can unhighlight the matches later by typing %s"
		 (key-description (car (where-is-internal
					'todos-clear-matches))))))))

(defun todos-clear-matches ()
  "Remove highlighting on matches found by todos-search."
  (interactive)
  (remove-overlays 1 (1+ (buffer-size)) 'face 'todos-search))

;; ---------------------------------------------------------------------------
;;; Display Commands

(defun todos-hide-show-item-numbering ()
  ""
  (interactive)
  (todos-reset-prefix 'todos-number-priorities (not todos-number-priorities)))

(defun todos-hide-show-done-items ()
  "Show hidden or hide visible done items in current category."
  (interactive)
  (if (zerop (todos-get-count 'done (todos-current-category)))
      (message "There are no done items in this category.")
    (save-excursion
      (goto-char (point-min))
      (let ((todos-show-with-done (not (re-search-forward
					todos-done-string-start nil t))))
	(todos-category-select)))))

(defun todos-show-done-only ()
  "Switch between displaying only done or only todo items."
  (interactive)
  (setq todos-show-done-only (not todos-show-done-only))
  (todos-category-select))

(defun todos-highlight-item ()
  "Toggle highlighting the todo item the cursor is on."
  (interactive)
  (require 'hl-line)
  (if hl-line-mode
      (hl-line-mode -1)
    (hl-line-mode 1)))

(defun todos-hide-show-date-time () ;(&optional all)
  "Hide or show date-time header of todo items.";; in current category.
;; With non-nil prefix argument ALL do this in the whole file."
  (interactive "P")
  (save-excursion
    (save-restriction
      (goto-char (point-min))
      (let ((ovs (overlays-in (point) (1+ (point))))
	    ov hidden)
	(while ovs
	  (setq ov (pop ovs))
	  (if (equal (overlay-get ov 'display) "")
	      (setq ovs nil hidden t)))
	;; (when all
	(widen)
	(goto-char (point-min));)
	(if hidden
	    (remove-overlays (point-min) (point-max) 'display "")
	  (while (not (eobp))
	    (when (re-search-forward
		   (concat todos-date-string-start todos-date-pattern
			   "\\( " diary-time-regexp "\\)?"
			   (regexp-quote todos-nondiary-end) "? ")
		   nil t)
	      (unless (save-match-data (todos-done-item-p))
		(setq ov (make-overlay (match-beginning 0) (match-end 0) nil t))
		(overlay-put ov 'display "")))
	    (todos-forward-item)))))))

(defun todos-mark-unmark-item (&optional n all)
  "Mark item at point if unmarked, or unmark it if marked.

With a positive numerical prefix argument N, change the
markedness of the next N items.  With non-nil argument ALL, mark
all visible items in the category (depending on visibility, all
todo and done items, or just todo or just done items).

The mark is the character \"*\" inserted in front of the item's
priority number or the `todos-prefix' string; if `todos-prefix'
is \"*\", then the mark is \"@\"."
  (interactive "p")
  (if all (goto-char (point-min)))
  (unless (> n 0) (setq n 1))
  (let ((i 0))
    (while (or (and all (not (eobp)))
	       (< i n))
      (let* ((cat (todos-current-category))
	     (ov (todos-marked-item-p))
	     (marked (assoc cat todos-categories-with-marks)))
	(if (and ov (not all))
	    (progn
	      (delete-overlay ov)
	      (if (= (cdr marked) 1)	; Deleted last mark in this category.
		  (setq todos-categories-with-marks
			(assq-delete-all cat todos-categories-with-marks))
		(setcdr marked (1- (cdr marked)))))
	  (when (todos-item-start)
	    (unless (and all (todos-marked-item-p))
	      (setq ov (make-overlay (point) (point)))
	      (overlay-put ov 'before-string todos-item-mark)
	      (if marked
		  (setcdr marked (1+ (cdr marked)))
		(push (cons cat 1) todos-categories-with-marks))))))
      (todos-forward-item)
      (setq i (1+ i)))))

(defun todos-mark-category ()
  "Put the \"*\" mark on all items in this category.
\(If `todos-prefix' is \"*\", then the mark is \"@\".)"
  (interactive)
  (todos-mark-unmark-item 0 t))

(defun todos-unmark-category ()
  "Remove the \"*\" mark from all items in this category.
\(If `todos-prefix' is \"*\", then the mark is \"@\".)"
  (interactive)
  (remove-overlays (point-min) (point-max) 'before-string todos-item-mark)
  (setq todos-categories-with-marks
	(delq (assoc (todos-current-category) todos-categories-with-marks)
	      todos-categories-with-marks)))

;; ---------------------------------------------------------------------------
;;; Item filtering commands

(defun todos-set-top-priorities-in-file ()
  "Set number of top priorities for this file.
See `todos-set-top-priorities' for more details."
  (interactive)
  (todos-set-top-priorities))

(defun todos-set-top-priorities-in-category ()
  "Set number of top priorities for this category.
See `todos-set-top-priorities' for more details."
  (interactive)
  (todos-set-top-priorities t))

(defun todos-top-priorities (&optional num)
  "List top priorities of each category in `todos-filter-files'.
Number of entries for each category is given by NUM, which
defaults to `todos-show-priorities'."
  (interactive "P")
  (let ((arg (if num (cons 'top num) 'top))
	(buf todos-top-priorities-buffer)
	(file todos-current-todos-file))
    (todos-filter-items arg)
    (todos-filtered-buffer-name buf file)))

(defun todos-top-priorities-multifile (&optional arg)
  "List top priorities of each category in `todos-filter-files'.

If the prefix argument ARG is a number, this is the maximum
number of top priorities to list in each category.  If the prefix
argument is `C-u', prompt for which files to filter and use
`todos-show-priorities' as the number of top priorities to list
in each category.  If the prefix argument is `C-uC-u', prompt
both for which files to filter and for how many top priorities to
list in each category."
  (interactive "P")
  (let* ((buf todos-top-priorities-buffer)
	 files
	 (pref (if (numberp arg)
		   (cons 'top arg)
		 (setq files (if (or (consp arg)
				     (null todos-filter-files))
				 (progn (todos-multiple-filter-files)
					todos-multiple-filter-files)
			       todos-filter-files))
		 (if (equal arg '(16))
		     (cons 'top (read-number
				 "Enter number of top priorities to show: "
				 todos-show-priorities))
		   'top))))
    (todos-filter-items pref t)
    (todos-filtered-buffer-name buf files)))

(defun todos-diary-items ()
  "Display todo items for diary inclusion in this Todos file."
  (interactive)
  (let ((buf todos-diary-items-buffer)
	(file todos-current-todos-file))
    (todos-filter-items 'diary)
    (todos-filtered-buffer-name buf file)))

(defun todos-diary-items-multifile (&optional arg)
  "Display todo items for diary inclusion in one or more Todos file.
The files are those listed in `todos-filter-files'."
  (interactive "P")
  (let ((buf todos-diary-items-buffer)
	(files (if (or arg (null todos-filter-files))
		   (progn (todos-multiple-filter-files)
			  todos-multiple-filter-files)
		 todos-filter-files)))
    (todos-filter-items 'diary t)
    (todos-filtered-buffer-name buf files)))

(defun todos-regexp-items ()
  "Display todo items matching a user-entered regular expression.
The items are those in the current Todos file."
  (interactive)
  (let ((buf todos-regexp-items-buffer)
	(file todos-current-todos-file))
    (todos-filter-items 'regexp)
    (todos-filtered-buffer-name buf file)))

(defun todos-regexp-items-multifile (&optional arg)
  "Display todo items matching a user-entered regular expression.
The items are those in the files listed in `todos-filter-files'."
  (interactive "P")
  (let ((buf todos-regexp-items-buffer)
	(files (if (or arg (null todos-filter-files))
		   (progn (todos-multiple-filter-files)
			  todos-multiple-filter-files)
		 todos-filter-files)))
    (todos-filter-items 'regexp t)
    (todos-filtered-buffer-name buf files)))

;;; Editing Commands

(defun todos-add-file ()
  "Name and add a new Todos file.
Interactively, prompt for a category and display it.
Noninteractively, return the name of the new file."
  (interactive)
  (let ((prompt (concat "Enter name of new Todos file "
			"(TAB or SPC to see current names): "))
	file)
    (setq file (todos-read-file-name prompt))
    (with-current-buffer (get-buffer-create file)
      (erase-buffer)
      (write-region (point-min) (point-max) file nil 'nomessage nil t)
      (kill-buffer file))
    (todos-reevaluate-defcustoms)
    (if (called-interactively-p)
	(progn
	  (set-window-buffer (selected-window)
			     (set-buffer (find-file-noselect file)))
	  (setq todos-current-todos-file file)
	  (todos-show))
      file)))

;; ---------------------------------------------------------------------------
;;; Category editing commands

(defun todos-add-category (&optional cat)
  "Add a new category to the current Todos file.
Called interactively, prompts for category name, then visits the
category in Todos mode.  Non-interactively, argument CAT provides
the category name and the return value is the category number."
  (interactive)
  (let* ((buffer-read-only)
	 (num (1+ (length todos-categories)))
	 (counts (make-vector 4 0)))	; [todo diary done archived]
    (unless cat
      (setq cat (todos-read-category "Enter new category name: " nil t)))
    (setq todos-categories (append todos-categories (list (cons cat counts))))
    (widen)
    (goto-char (point-max))
    (save-excursion			; Save point for todos-category-select.
      (insert todos-category-beg cat "\n\n" todos-category-done "\n"))
    (todos-update-categories-sexp)
    ;; If invoked by user, display the newly added category, if called
    ;; programmatically return the category number to the caller.
    (if (called-interactively-p 'any)
	(progn
	  (setq todos-category-number num)
	  (todos-category-select))
      num)))

(defun todos-rename-category ()
  "Rename current Todos category.
If this file has an archive containing this category, rename the
category there as well."
  (interactive)
  (let* ((cat (todos-current-category))
	 (new (read-from-minibuffer (format "Rename category \"%s\" to: " cat))))
    (setq new (todos-validate-name new 'category))
    (let* ((ofile todos-current-todos-file)
	   (archive (concat (file-name-sans-extension ofile) ".toda"))
	   (buffers (append (list ofile)
			    (unless (zerop (todos-get-count 'archived cat))
			      (list archive)))))
      (dolist (buf buffers)
	(with-current-buffer (find-file-noselect buf)
	  (let (buffer-read-only)
	    (setq todos-categories (todos-set-categories))
	    (save-excursion
	      (save-restriction
		(setcar (assoc cat todos-categories) new)
		(widen)
		(goto-char (point-min))
		(todos-update-categories-sexp)
		(re-search-forward (concat (regexp-quote todos-category-beg)
					   "\\(" (regexp-quote cat) "\\)\n")
				   nil t)
		(replace-match new t t nil 1)))))))
    (force-mode-line-update))
  (save-excursion (todos-category-select)))

(defun todos-delete-category (&optional arg)
  "Delete current Todos category provided it is empty.
With ARG non-nil delete the category unconditionally,
i.e. including all existing todo and done items."
  (interactive "P")
  (let* ((file todos-current-todos-file)
	 (cat (todos-current-category))
	 (todo (todos-get-count 'todo cat))
	 (done (todos-get-count 'done cat))
	 (archived (todos-get-count 'archived cat)))
    (if (and (not arg)
	     (or (> todo 0) (> done 0)))
	(message "%s" (substitute-command-keys
		       (concat "To delete a non-empty category, "
			       "type C-u \\[todos-delete-category].")))
      (when (cond ((= (length todos-categories) 1)
		   (y-or-n-p (concat "This is the only category in this file; "
				     "deleting it will also delete the file.\n"
				     "Do you want to proceed? ")))
		  ((> archived 0)
		   (y-or-n-p (concat "This category has archived items; "
				     "the archived category will remain\n"
				     "after deleting the todo category.  "
				     "Do you still want to delete it\n"
				     "(see 'todos-skip-archived-categories' "
				     "for another option)? ")))
		  (t
		   (y-or-n-p (concat "Permanently remove category \"" cat
				     "\"" (and arg " and all its entries")
				     "? "))))
	(widen)
	(let ((buffer-read-only)
	      (beg (re-search-backward
		    (concat "^" (regexp-quote (concat todos-category-beg cat))
			    "\n") nil t))
	      (end (if (re-search-forward
			(concat "\n\\(" (regexp-quote todos-category-beg)
				".*\n\\)") nil t)
		       (match-beginning 1)
		     (point-max))))
	  (remove-overlays beg end)
	  (delete-region beg end)
	  (if (= (length todos-categories) 1)
	      ;; If deleted category was the only one, delete the file.
	      (progn
		(todos-reevaluate-defcustoms)
		;; Skip confirming killing the archive buffer if it has been
		;; modified and not saved.
		(set-buffer-modified-p nil)
		(delete-file file)
		(kill-buffer)
		(message "Deleted Todos file %s." file))
	    (setq todos-categories (delete (assoc cat todos-categories)
					       todos-categories))
	    (todos-update-categories-sexp)
	    (setq todos-category-number
		  (1+ (mod todos-category-number (length todos-categories))))
	    (todos-category-select)
	    (goto-char (point-min))
	    (message "Deleted category %s." cat)))))))

(defun todos-move-category ()
  "Move current category to a different Todos file.
If current category has archived items, also move those to the
archive of the file moved to, creating it if it does not exist."
  (interactive)
  (when (or (> (length todos-categories) 1)
	    (y-or-n-p (concat "This is the only category in this file; "
			      "moving it will also delete the file.\n"
			      "Do you want to proceed? ")))
    (let* ((ofile todos-current-todos-file)
	   (cat (todos-current-category))
	   (nfile (todos-read-file-name "Choose a Todos file: " nil t))
	   (archive (concat (file-name-sans-extension ofile) ".toda"))
	   (buffers (append (list ofile)
			    (unless (zerop (todos-get-count 'archived cat))
			      (list archive))))
	   new)
      (dolist (buf buffers)
	(with-current-buffer (find-file-noselect buf)
	  (widen)
	  (goto-char (point-max))
	  (let* ((beg (re-search-backward
		       (concat "^"
			       (regexp-quote (concat todos-category-beg cat)))
		       nil t))
		 (end (if (re-search-forward
			   (concat "^" (regexp-quote todos-category-beg))
			   nil t 2)
			  (match-beginning 0)
			(point-max)))
		 (content (buffer-substring-no-properties beg end))
		 (counts (cdr (assoc cat todos-categories)))
		 buffer-read-only)
	    ;; Move the category to the new file.  Also update or create
	    ;; archive file if necessary.
	    (with-current-buffer
		(find-file-noselect
		 ;; Regenerate todos-archives in case there
		 ;; is a newly created archive.
		 (if (member buf (funcall todos-files-function t))
		     (concat (file-name-sans-extension nfile) ".toda")
		   nfile))
	      (let* ((nfile-short (todos-short-file-name nfile))
		     (prompt (concat
			      (format "Todos file \"%s\" already has "
				      nfile-short)
			      (format "the category \"%s\";\n" cat)
			      "enter a new category name: "))
		     buffer-read-only)
		(widen)
		(goto-char (point-max))
		(insert content)
		;; If the file moved to has a category with the same
		;; name, rename the moved category.
		(when (assoc cat todos-categories)
		  (unless (member (file-truename (buffer-file-name))
				  (funcall todos-files-function t))
		    (setq new (read-from-minibuffer prompt))
		    (setq new (todos-validate-name new 'category))))
		;; Replace old with new name in Todos and archive files.
		(when new
		  (goto-char (point-max))
		  (re-search-backward
		   (concat "^" (regexp-quote todos-category-beg)
			   "\\(" (regexp-quote cat) "\\)") nil t)
		  (replace-match new nil nil nil 1)))
	      (setq todos-categories
		    (append todos-categories (list (cons new counts))))
	      (todos-update-categories-sexp)
	      ;; If archive was just created, save it to avoid "File <xyz> no
	      ;; longer exists!" message on invoking
	      ;; `todos-view-archived-items'.  FIXME: maybe better to save
	      ;; unconditionally?
	      (unless (file-exists-p (buffer-file-name))
		(save-buffer))
	      (todos-category-number (or new cat))
	      (todos-category-select))
	    ;; Delete the category from the old file, and if that was the
	    ;; last category, delete the file.  Also handle archive file
	    ;; if necessary.
	    (remove-overlays beg end)
	    (delete-region beg end)
	    (goto-char (point-min))
	    ;; Put point after todos-categories sexp.
	    (forward-line)
	    (if (eobp)		; Aside from sexp, file is empty.
		(progn
		  ;; Skip confirming killing the archive buffer.
		  (set-buffer-modified-p nil)
		  (delete-file todos-current-todos-file)
		  (kill-buffer)
		  (when (member todos-current-todos-file todos-files)
		    (todos-reevaluate-defcustoms)))
	      (setq todos-categories (delete (assoc cat todos-categories)
						 todos-categories))
	      (todos-update-categories-sexp)
	      (todos-category-select)))))
      (set-window-buffer (selected-window)
			 (set-buffer (find-file-noselect nfile)))
      (todos-category-number (or new cat))
      (todos-category-select))))

(defun todos-merge-category ()
  "Merge current category into another category in this file.
The current category's todo and done items are appended to the
chosen category's todo and done items, respectively, which
becomes the current category, and the category moved from is
deleted."
  (interactive)
  (let ((buffer-read-only nil)
	(cat (todos-current-category))
	(goal (todos-read-category "Category to merge to: " t)))
    (widen)
    ;; FIXME: check if cat has archived items and merge those too
    (let* ((cbeg (progn
		   (re-search-backward
		    (concat "^" (regexp-quote todos-category-beg)) nil t)
		   (point)))
	   (tbeg (progn (forward-line) (point)))
	   (dbeg (progn
		   (re-search-forward
		    (concat "^" (regexp-quote todos-category-done)) nil t)
		   (forward-line) (point)))
	   (tend (progn (forward-line -2) (point)))
	   (cend (progn
		   (if (re-search-forward
			(concat "^" (regexp-quote todos-category-beg)) nil t)
		       (match-beginning 0)
		     (point-max))))
	   (todo (buffer-substring-no-properties tbeg tend))
	   (done (buffer-substring-no-properties dbeg cend))
	   here)
      (goto-char (point-min))
      (re-search-forward
       (concat "^" (regexp-quote (concat todos-category-beg goal))) nil t)
      (re-search-forward
       (concat "^" (regexp-quote todos-category-done)) nil t)
      (forward-line -1)
      (setq here (point))
      (insert todo)
      (goto-char (if (re-search-forward
		      (concat "^" (regexp-quote todos-category-beg)) nil t)
		     (match-beginning 0)
		   (point-max)))
      (insert done)
      (remove-overlays cbeg cend)
      (delete-region cbeg cend)
      (todos-update-count 'todo (todos-get-count 'todo cat) goal)
      (todos-update-count 'done (todos-get-count 'done cat) goal)
      (setq todos-categories (delete (assoc cat todos-categories)
					 todos-categories))
      (todos-update-categories-sexp)
      (todos-category-number goal)
      (todos-category-select)
      ;; Put point at the start of the merged todo items.
      ;; FIXME: what if there are no merged todo items but only done items?
      (goto-char here))))
      
;; FIXME
(defun todos-merge-categories ()
  ""
  (interactive)
  (let* ((cats (mapcar 'car todos-categories))
	 (goal (todos-read-category "Category to merge to: " t))
	 (prompt (format "Merge to %s (type C-g to finish)? " goal))
	 (source (let ((inhibit-quit t) l)
		  (while (not (eq last-input-event 7))
		    (dolist (c cats)
		      (when (y-or-n-p prompt)
			(push c l)
			(setq cats (delete c cats))))))))
    (widen)
  ))

(defun todos-raise-category-priority (&optional lower)
  "Raise priority of category point is on in Todos Categories buffer.
With non-nil argument LOWER, lower the category's priority."
  (interactive)
  (save-excursion
    (forward-line 0)
    (skip-chars-forward " ")
    (setq todos-categories-category-number (number-at-point)))
  (when (if lower
	    (< todos-categories-category-number (length todos-categories))
	  (> todos-categories-category-number 1))
    (let* ((col (current-column))
	   ;; The line we're raising to, or lowering from...
	   (beg (progn (forward-line (if lower 0 -1)) (point)))
	   ;; ...and its number.
	   (num1 (progn (skip-chars-forward " ") (1- (number-at-point))))
	   ;; The number of the line we're exchanging with.
	   (num2 (1+ num1))
	   ;; The start of the line below the one we're exchanging with.
	   (end (progn (forward-line 2) (point)))
	   (catvec (vconcat todos-categories))
	   ;; Category names and item counts of the two lines being exchanged.
	   (cat1-list (aref catvec num1))
	   (cat2-list (aref catvec num2))
	   (cat1 (car cat1-list))
	   (cat2 (car cat2-list))
	   buffer-read-only newcats)
      (delete-region beg end)
      (setq num1 (1+ num1))
      (setq num2 (1- num2))
      ;; Exchange the lines and rebuttonize them.
      (setq todos-categories-category-number num2)
      (todos-insert-category-line cat2)
      (setq todos-categories-category-number num1)
      (todos-insert-category-line cat1)
      ;; Update todos-categories alist.
      (aset catvec num2 (cons cat2 (cdr cat2-list)))
      (aset catvec num1 (cons cat1 (cdr cat1-list)))
      (setq todos-categories (append catvec nil))
      (setq newcats todos-categories)
      (with-current-buffer (find-buffer-visiting todos-current-todos-file)
	(setq todos-categories newcats)
	(todos-update-categories-sexp))
      (forward-line (if lower -1 -2))
      (forward-char col))))

(defun todos-lower-category-priority ()
  "Lower priority of category point is on in Todos Categories buffer."
  (interactive)
  (todos-raise-category-priority t))

(defun todos-set-category-priority ()
  ""
  (interactive)
  ;; FIXME
  )

;; ---------------------------------------------------------------------------
;;; Item editing commands

;; FIXME: make insertion options customizable per category?
;;;###autoload
(defun todos-insert-item (&optional arg diary nonmarking date-type time
				    region-or-here)
  "Add a new Todo item to a category.
\(See the note at the end of this document string about key
bindings and convenience commands derived from this command.)

With no (or nil) prefix argument ARG, add the item to the current
category; with one prefix argument (C-u), prompt for a category
from the current Todos file; with two prefix arguments (C-u C-u),
first prompt for a Todos file, then a category in that file.  If
a non-existing category is entered, ask whether to add it to the
Todos file; if answered affirmatively, add the category and
insert the item there.

When argument DIARY is non-nil, this overrides the intent of the
user option `todos-include-in-diary' for this item: if
`todos-include-in-diary' is nil, include the item in the Fancy
Diary display, and if it is non-nil, exclude the item from the
Fancy Diary display.  When DIARY is nil, `todos-include-in-diary'
has its intended effect.

When the item is included in the Fancy Diary display and the
argument NONMARKING is non-nil, this overrides the intent of the
user option `todos-diary-nonmarking' for this item: if
`todos-diary-nonmarking' is nil, append `diary-nonmarking-symbol'
to the item, and if it is non-nil, omit `diary-nonmarking-symbol'.

The argument DATE-TYPE determines the content of the item's
mandatory date header string and how it is added:
- If DATE-TYPE is the symbol `calendar', the Calendar pops up and
  when the user puts the cursor on a date and hits RET, that
  date, in the format set by `calendar-date-display-form',
  becomes the date in the header.
- If DATE-TYPE is the symbol `date', the header contains the date
  in the format set by `calendar-date-display-form', with year,
  month and day individually prompted for (month with tab
  completion).
- If DATE-TYPE is the symbol `dayname' the header contains a
  weekday name instead of a date, prompted for with tab
  completion.
- If DATE-TYPE has any other value (including nil or none) the
  header contains the current date (in the format set by
  `calendar-date-display-form').

With non-nil argument TIME prompt for a time string, which must
match `diary-time-regexp'.  Typing `<return>' at the prompt
returns the current time, if the user option
`todos-always-add-time-string' is non-nil, otherwise the empty
string (i.e., no time string).  If TIME is absent or nil, add or
omit the current time string according as
`todos-always-add-time-string' is non-nil or nil, respectively.

The argument REGION-OR-HERE determines the source and location of
the new item:
- If the REGION-OR-HERE is the symbol `here', prompt for the text
  of the new item and insert it directly above the todo item at
  point (hence lowering the priority of the remaining items), or
  if point is on the empty line below the last todo item, insert
  the new item there.  An error is signalled if
  `todos-insert-item' is invoked with `here' outside of the
  current category.
- If REGION-OR-HERE is the symbol `region', use the region of the
  current buffer as the text of the new item, depending on the
  value of user option `todos-use-only-highlighted-region': if
  this is non-nil, then use the region only when it is
  highlighted; otherwise, use the region regardless of
  highlighting.  An error is signalled if there is no region in
  the current buffer.  Prompt for the item's priority in the
  category (an integer between 1 and one more than the number of
  items in the category), and insert the item accordingly.
- If REGION-OR-HERE has any other value (in particular, nil or
  none), prompt for the text and the item's priority, and insert
  the item accordingly.

To facilitate using these arguments when inserting a new todo
item, convenience commands have been defined for all admissible
combinations together with mnenomic key bindings based on on the
name of the arguments and their order in the command's argument
list: diar_y_ - nonmar_k_ing - _c_alendar or _d_ate or day_n_ame
- _t_ime - _r_egion or _h_ere.  These key combinations are
appended to the basic insertion key (i) and keys that allow a
following key must be doubled when used finally.  For example,
`iyh' will insert a new item with today's date, marked according
to the DIARY argument described above, and with priority
according to the HERE argument; while `iyy' does the same except
the priority is not given by HERE but by prompting."
;;   An alternative interface for customizing key
;; binding is also provided with the function
;; `todos-insertion-bindings'."		;FIXME
  (interactive "P")
  (let ((region (eq region-or-here 'region))
	(here (eq region-or-here 'here)))
    (when region
      (let (use-empty-active-region)
	(unless (and todos-use-only-highlighted-region (use-region-p))
	  (error "There is no active region"))))
    (let* ((buf (current-buffer))
	   (new-item (if region
			 ;; FIXME: or keep properties?
			 (buffer-substring-no-properties
			  (region-beginning) (region-end))
		       (read-from-minibuffer "Todo item: ")))
	   (date-string (cond
			 ((eq date-type 'date)
			  (todos-read-date))
			 ((eq date-type 'dayname)
			  (todos-read-dayname))
			 ((eq date-type 'calendar)
			  (setq todos-date-from-calendar t)
			  (todos-set-date-from-calendar))
			 (t (calendar-date-string (calendar-current-date) t t))))
	   (time-string (or (and time (todos-read-time))
			    (and todos-always-add-time-string
				 (substring (current-time-string) 11 16)))))
      (setq todos-date-from-calendar nil)
      (cond ((equal arg '(16))		; FIXME: cf. set-mark-command
	     (todos-jump-to-category nil t)
	     (set-window-buffer
	      (selected-window)
	      (set-buffer (find-buffer-visiting todos-global-current-todos-file))))
	    ((equal arg '(4))		; FIXME: just arg?
	     (todos-jump-to-category)
	     (set-window-buffer
	      (selected-window)
	      (set-buffer (find-buffer-visiting todos-global-current-todos-file))))
	    (t
	     (when (not (derived-mode-p 'todos-mode)) (todos-show))))
      (let (buffer-read-only)
	(setq new-item
	      ;; Add date, time and diary marking as required.
	      (concat (if (not (and diary (not todos-include-in-diary)))
			  todos-nondiary-start
			(when (and nonmarking (not todos-diary-nonmarking))
			  diary-nonmarking-symbol))
		      date-string (when (and time-string ; Can be empty string.
					     (not (zerop (length time-string))))
				    (concat " " time-string))
		      (when (not (and diary (not todos-include-in-diary)))
			todos-nondiary-end)
		      " " new-item))
	;; Indent newlines inserted by C-q C-j if nonspace char follows.
	(setq new-item (replace-regexp-in-string
			"\\(\n\\)[^[:blank:]]"
			(concat "\n" (make-string todos-indent-to-here 32))
			new-item nil nil 1))
	(if here
	    (cond ((not (eq major-mode 'todos-mode))
		   (error "Cannot insert a todo item here outside of Todos mode"))
		  ((not (eq buf (current-buffer)))
		   (error "Cannot insert an item here after changing buffer"))
		  ((or (todos-done-item-p)
		       ;; Point on last blank line.
		       (save-excursion (forward-line -1) (todos-done-item-p)))
		   (error "Cannot insert a new item in the done item section"))
		  (t
		   (todos-insert-with-overlays new-item)))
	  (todos-set-item-priority new-item (todos-current-category) t))
	(todos-update-count 'todo 1)
	(if (or diary todos-include-in-diary) (todos-update-count 'diary 1))
	(todos-update-categories-sexp)))))

(defvar todos-date-from-calendar nil
  "Helper variable for setting item date from the Emacs Calendar.")

(defun todos-set-date-from-calendar ()
  "Return string of date chosen from Calendar."
  (when todos-date-from-calendar
    (let (calendar-view-diary-initially-flag)
      (calendar))
    ;; *Calendar* is now current buffer.
    (local-set-key (kbd "RET") 'exit-recursive-edit)
    (message "Put cursor on a date and type <return> to set it.")
    ;; FIXME: is there a better way than recursive-edit?  Use unwind-protect?
    ;; Check recursive-depth?
    (recursive-edit)
    (setq todos-date-from-calendar
	  (calendar-date-string (calendar-cursor-to-date t) t t))
    (calendar-exit)
    todos-date-from-calendar))

(defun todos-delete-item ()
  "Delete at least one item in this category.

If there are marked items, delete all of these; otherwise, delete
the item at point."
  (interactive)
  (let* ((cat (todos-current-category))
	 (marked (assoc cat todos-categories-with-marks))
	 (item (unless marked (todos-item-string)))
	 (ov (make-overlay (save-excursion (todos-item-start))
			   (save-excursion (todos-item-end))))
	 ;; FIXME: make confirmation an option?
	 (answer (if marked
		     (y-or-n-p "Permanently delete all marked items? ")
		   (when item
		     (overlay-put ov 'face 'todos-search)
		     (y-or-n-p (concat "Permanently delete this item? ")))))
	 (opoint (point))
	 buffer-read-only)
    (when answer
      (and marked (goto-char (point-min)))
      (catch 'done
	(while (not (eobp))
	  (if (or (and marked (todos-marked-item-p)) item)
	      (progn
		(if (todos-done-item-p)
		    (todos-update-count 'done -1)
		  (todos-update-count 'todo -1 cat)
		  (and (todos-diary-item-p) (todos-update-count 'diary -1)))
		(delete-overlay ov)
		(todos-remove-item)
		;; Don't leave point below last item.
		(and item (bolp) (eolp) (< (point-min) (point-max))
		     (todos-backward-item))
		(when item 
		  (throw 'done (setq item nil))))
	    (todos-forward-item))))
      (when marked
	(remove-overlays (point-min) (point-max) 'before-string todos-item-mark)
	(setq todos-categories-with-marks
	      (assq-delete-all cat todos-categories-with-marks))
	(goto-char opoint))
      (todos-update-categories-sexp)
      (todos-prefix-overlays))
    (if ov (delete-overlay ov))))

(defun todos-edit-item ()
  "Edit the Todo item at point.
If the item consists of only one logical line, edit it in the
minibuffer; otherwise, edit it in Todos Edit mode."
  (interactive)
  (when (todos-item-string)
    (let* ((buffer-read-only)
	   (start (todos-item-start))
	   (item-beg (progn
		       (re-search-forward
			(concat todos-date-string-start todos-date-pattern
				"\\( " diary-time-regexp "\\)?"
				(regexp-quote todos-nondiary-end) "?")
			(line-end-position) t)
		       (1+ (- (point) start))))
	   (item (todos-item-string))
	   (multiline (> (length (split-string item "\n")) 1))
	   (opoint (point)))
      (if multiline
	  (todos-edit-multiline t)
	(let ((new (read-string "Edit: " (cons item item-beg))))
	  (while (not (string-match
		       (concat todos-date-string-start todos-date-pattern) new))
	    (setq new (read-from-minibuffer
		       "Item must start with a date: " new)))
	  ;; Indent newlines inserted by C-q C-j if nonspace char follows.
	  (setq new (replace-regexp-in-string
		     "\\(\n\\)[^[:blank:]]"
		     (concat "\n" (make-string todos-indent-to-here 32)) new
		     nil nil 1))
	  ;; If user moved point during editing, make sure it moves back.
	  (goto-char opoint)
	  (todos-remove-item)
	  (todos-insert-with-overlays new)
	  (move-to-column item-beg))))))

(defun todos-edit-multiline-item ()
  "Edit current Todo item in Todos Edit mode.
Use of newlines invokes `todos-indent' to insure compliance with
the format of Diary entries."
  (interactive)
  (todos-edit-multiline t))

(defun todos-edit-multiline (&optional item)
  ""
  (interactive)
  ;; FIXME: should there be only one live Todos Edit buffer?
  ;; (let ((buffer-name todos-edit-buffer))
  (let ((buffer-name (generate-new-buffer-name todos-edit-buffer)))
    (set-window-buffer
     (selected-window)
     (set-buffer (make-indirect-buffer
		  (file-name-nondirectory todos-current-todos-file)
		  buffer-name)))
    (if item
	(narrow-to-region (todos-item-start) (todos-item-end))
      (widen))
    (todos-edit-mode)
    (message "%s" (substitute-command-keys
		   (concat "Type \\[todos-edit-quit] to check file format "
			   "validity and return to Todos mode.\n")))))

(defun todos-edit-quit ()
  "Return from Todos Edit mode to Todos mode.

If the whole file was in Todos Edit mode, check before returning
whether the file is still a valid Todos file and if so, also
recalculate the Todos categories sexp, in case changes were made
in the number or names of categories."
  (interactive)
  ;; FIXME: should do only if file was actually changed -- but how to tell?
  (when (eq (buffer-size) (- (point-max) (point-min)))
    (when (todos-check-format) (todos-repair-categories-sexp)))
  (kill-buffer)
  ;; In case next buffer is not the one holding todos-current-todos-file.
  (todos-show))

(defun todos-edit-item-header (&optional what)
  "Edit date/time header of at least one item.

Interactively, ask whether to edit year, month and day or day of
the week, as well as time.  If there are marked items, apply the
changes to all of these; otherwise, edit just the item at point.  

Non-interactively, argument WHAT specifies whether to set the
date from the Calendar or to today, or whether to edit only the
date or day, or only the time."
  (interactive)
  (let* ((cat (todos-current-category))
	 (marked (assoc cat todos-categories-with-marks))
	 (first t)			; Match only first of marked items.
	 (todos-date-from-calendar t)
	 ndate ntime nheader)
    (save-excursion
      (or (and marked (goto-char (point-min))) (todos-item-start))
      (catch 'stop
	(while (not (eobp))
	  (and marked
	       (while (not (todos-marked-item-p))
		 (todos-forward-item)
		 (and (eobp) (throw 'stop nil))))
	  (re-search-forward (concat todos-date-string-start "\\(?1:"
				     todos-date-pattern
				     "\\)\\(?2: " diary-time-regexp "\\)?")
			     (line-end-position) t)
	  (let* ((odate (match-string-no-properties 1))
		 (otime (match-string-no-properties 2))
		 (buffer-read-only))
	    (cond ((eq what 'today)
		   (progn
		     (setq ndate (calendar-date-string
				  (calendar-current-date) t t))
		     (replace-match ndate nil nil nil 1)))
		  ((eq what 'calendar)
		   (setq ndate (save-match-data (todos-set-date-from-calendar)))
		   (replace-match ndate nil nil nil 1))
		  (t
		   (unless (eq what 'timeonly)
		     (when first
		       (setq ndate (if (save-match-data
					 (string-match "[0-9]+" odate))
				       (if (y-or-n-p "Change date? ")
					   (todos-read-date)
					 (todos-read-dayname))
				     (if (y-or-n-p "Change day? ")
					 (todos-read-dayname)
				       (todos-read-date)))))
		     (replace-match ndate nil nil nil 1))
		   (unless (eq what 'dateonly)
		     (when first
		       (setq ntime (save-match-data (todos-read-time)))
		       (when (< 0 (length ntime))
			 (setq ntime (concat " " ntime))))
		     (if otime
			 (replace-match ntime nil nil nil 2)
		       (goto-char (match-end 1))
		       (insert ntime)))))
	    (setq todos-date-from-calendar nil)
	    (setq first nil))
	  (if marked
	      (todos-forward-item)
	    (goto-char (point-max))))))))

(defun todos-edit-item-date ()
  "Prompt for and apply changes to current item's date."
  (interactive)
  (todos-edit-item-header 'dateonly))

(defun todos-edit-item-date-from-calendar ()
  "Prompt for changes to current item's date and apply from Calendar."
  (interactive)
  (todos-edit-item-header 'calendar))

(defun todos-edit-item-date-is-today ()
  "Set item date to today's date."
  (interactive)
  (todos-edit-item-header 'today))
 
(defun todos-edit-item-time ()
  "Prompt For and apply changes to current item's time."
  (interactive)
  (todos-edit-item-header 'timeonly))

(defun todos-edit-item-diary-inclusion ()
  "Change diary status of one or more todo items in this category.
That is, insert `todos-nondiary-marker' if the candidate items
lack this marking; otherwise, remove it.

If there are marked todo items, change the diary status of all
and only these, otherwise change the diary status of the item at
point."
  (interactive)
  (let ((buffer-read-only)
	(marked (assoc (todos-current-category)
		       todos-categories-with-marks)))
    (catch 'stop
      (save-excursion
	(when marked (goto-char (point-min)))
	(while (not (eobp))
	  (if (todos-done-item-p)
	      (throw 'stop (message "Done items cannot be edited"))
	    (unless (and marked (not (todos-marked-item-p)))
	      (let* ((beg (todos-item-start))
		     (lim (save-excursion (todos-item-end)))
		     (end (save-excursion
			    (or (todos-time-string-matcher lim)
				(todos-date-string-matcher lim)))))
		(if (looking-at (regexp-quote todos-nondiary-start))
		    (progn
		      (replace-match "")
		      (search-forward todos-nondiary-end (1+ end) t)
		      (replace-match "")
		      (todos-update-count 'diary 1))
		  (when end
		    (insert todos-nondiary-start)
		    (goto-char (1+ end))
		    (insert todos-nondiary-end)
		    (todos-update-count 'diary -1)))))
	    (unless marked (throw 'stop nil))
	    (todos-forward-item)))))
    (todos-update-categories-sexp)))

(defun todos-edit-category-diary-inclusion (arg)
  "Make all items in this category diary items.
With prefix ARG, make all items in this category non-diary
items."
  (interactive "P")
  (save-excursion
    (goto-char (point-min))
    (let ((todo-count (todos-get-count 'todo))
	  (diary-count (todos-get-count 'diary))
	  (buffer-read-only))
      (catch 'stop
	(while (not (eobp))
	  (if (todos-done-item-p)	; We've gone too far.
	      (throw 'stop nil)
	    (let* ((beg (todos-item-start))
		   (lim (save-excursion (todos-item-end)))
		   (end (save-excursion
			  (or (todos-time-string-matcher lim)
			      (todos-date-string-matcher lim)))))
	      (if arg
		  (unless (looking-at (regexp-quote todos-nondiary-start))
		    (insert todos-nondiary-start)
		    (goto-char (1+ end))
		    (insert todos-nondiary-end))
		(when (looking-at (regexp-quote todos-nondiary-start))
		  (replace-match "")
		  (search-forward todos-nondiary-end (1+ end) t)
		  (replace-match "")))))
	  (todos-forward-item))
	(unless (if arg (zerop diary-count) (= diary-count todo-count))
	  (todos-update-count 'diary (if arg
				      (- diary-count)
				    (- todo-count diary-count))))
	(todos-update-categories-sexp)))))

(defun todos-edit-item-diary-nonmarking ()
  "Change non-marking of one or more diary items in this category.
That is, insert `diary-nonmarking-symbol' if the candidate items
lack this marking; otherwise, remove it.

If there are marked todo items, change the non-marking status of
all and only these, otherwise change the non-marking status of
the item at point."
  (interactive)
  (let ((buffer-read-only)
	(marked (assoc (todos-current-category)
		       todos-categories-with-marks)))
    (catch 'stop
      (save-excursion
	(when marked (goto-char (point-min)))
	(while (not (eobp))
	  (if (todos-done-item-p)
	      (throw 'stop (message "Done items cannot be edited"))
	    (unless (and marked (not (todos-marked-item-p)))
	      (todos-item-start)
	      (unless (looking-at (regexp-quote todos-nondiary-start))
		(if (looking-at (regexp-quote diary-nonmarking-symbol))
		    (replace-match "")
		  (insert diary-nonmarking-symbol))))
	    (unless marked (throw 'stop nil))
	    (todos-forward-item)))))))

(defun todos-edit-category-diary-nonmarking (arg)
  "Add `diary-nonmarking-symbol' to all diary items in this category.
With prefix ARG, remove `diary-nonmarking-symbol' from all diary
items in this category."
  (interactive "P")
  (save-excursion
    (goto-char (point-min))
    (let (buffer-read-only)
      (catch 'stop
      (while (not (eobp))
	(if (todos-done-item-p)		; We've gone too far.
	    (throw 'stop nil)
	  (unless (looking-at (regexp-quote todos-nondiary-start))
	    (if arg
		(when (looking-at (regexp-quote diary-nonmarking-symbol))
		  (replace-match ""))
	      (unless (looking-at (regexp-quote diary-nonmarking-symbol))
		(insert diary-nonmarking-symbol))))
	(todos-forward-item)))))))

(defun todos-raise-item-priority (&optional lower)
  "Raise priority of current item by moving it up by one item.
With non-nil argument LOWER lower item's priority."
  (interactive)
  (unless (or (todos-done-item-p)	; Can't reprioritize done items.
	      ;; Can't raise or lower todo item when it's the only one.
	      (< (todos-get-count 'todo) 2)
	      ;; Point is between todo and done items.
	      (looking-at "^$")
	      ;; Can't lower final todo item.
	      (and lower
		   (save-excursion
		     (todos-forward-item)
		     (looking-at "^$")))
	      ;; Can't reprioritize filtered items other than Top Priorities.
	      (and (eq major-mode 'todos-filtered-items-mode)
		   (not (string-match (regexp-quote todos-top-priorities-buffer)
				      (buffer-name)))))
    (let ((item (todos-item-string))
	  (marked (todos-marked-item-p))
	  buffer-read-only)
      ;; In Top Priorities buffer, an item's priority can be changed
      ;; wrt items in another category, but not wrt items in the same
      ;; category.
      (when (eq major-mode 'todos-filtered-items-mode)
	(let* ((regexp (concat todos-date-string-start todos-date-pattern
			       "\\( " diary-time-regexp "\\)?"
			       (regexp-quote todos-nondiary-end)
			       "?\\(?1: \\[\\(.+:\\)?.+\\]\\)"))
	       (cat1 (save-excursion
		       (re-search-forward regexp nil t)
		       (match-string 1)))
	       (cat2 (save-excursion
		       (if lower
			   (todos-forward-item)
			 (todos-backward-item))
		       (re-search-forward regexp nil t)
		       (match-string 1))))
	  (if (string= cat1 cat2)
	      (error
	       (concat "Cannot reprioritize items in the same "
		       "category in this mode, only in Todos mode")))))
      (todos-remove-item)
      (if lower (todos-forward-item) (todos-backward-item))
      (todos-insert-with-overlays item)
      ;; If item was marked, retore the mark.
      (and marked (overlay-put (make-overlay (point) (point))
			       'before-string todos-item-mark)))))

(defun todos-lower-item-priority ()
  "Lower priority of current item by moving it down by one item."
  (interactive)
  (todos-raise-item-priority t))

;; FIXME: incorporate todos-(raise|lower)-item-priority ?
(defun todos-set-item-priority (item cat &optional new)
  "Set todo ITEM's priority in category CAT, moving item as needed.
Interactively, the item and the category are the current ones,
and the priority is a number between 1 and the number of items in
the category.  Non-interactively with argument NEW, the lowest
priority is one more than the number of items in CAT."
  (interactive (list (todos-item-string) (todos-current-category)))
  (unless (called-interactively-p t)
    (todos-category-number cat)
    (todos-category-select))
  (let* ((todo (todos-get-count 'todo cat))
	 (maxnum (if new (1+ todo) todo))
	 (buffer-read-only)
	 priority candidate prompt)
    (unless (zerop todo)
      (while (not priority)
	(setq candidate
	      (string-to-number (read-from-minibuffer
				 (concat prompt
					 (format "Set item priority (1-%d): "
						 maxnum)))))
	(setq prompt
	      (when (or (< candidate 1) (> candidate maxnum))
		(format "Priority must be an integer between 1 and %d.\n"
			maxnum)))
	(unless prompt (setq priority candidate)))
      ;; Interactively, just relocate the item within its category.
      (when (called-interactively-p) (todos-remove-item))
      (goto-char (point-min))
      (unless (= priority 1) (todos-forward-item (1- priority))))
    (todos-insert-with-overlays item)))

(defun todos-set-item-top-priority ()
  "Set this item's priority in the Top Priorities display.
Reprioritizing items that belong to the same category is not
allowed; this is reserved for Todos mode."
  (interactive)
  (when (string-match (regexp-quote todos-top-priorities-buffer) (buffer-name))
    (let* ((count 0)
	   (item (todos-item-string))
	   (end (todos-item-end))
	   (beg (todos-item-start))
	   (regexp (concat todos-date-string-start todos-date-pattern
			   "\\(?: " diary-time-regexp "\\)?"
			   (regexp-quote todos-nondiary-end)
			   "?\\(?1: \\[\\(?:.+:\\)?.+\\]\\)"))
	   (cat (when (looking-at regexp) (match-string 1)))
	   buffer-read-only current priority candidate prompt new)
      (save-excursion
	(goto-char (point-min))
	(while (not (eobp))
	  (setq count (1+ count))
	  (when (string= item (todos-item-string))
	    (setq current count))
	  (todos-forward-item)))
      (unless (zerop count)
	(while (not priority)
	  (setq candidate
		(string-to-number (read-from-minibuffer
				   (concat prompt
					   (format "Set item priority (1-%d): "
						   count)))))
	  (setq prompt
		(when (or (< candidate 1) (> candidate count))
		  (format "Priority must be an integer between 1 and %d.\n"
			  count)))
	  (unless prompt (setq priority candidate)))
	(goto-char (point-min))
	(unless (= priority 1) (todos-forward-item (1- priority)))
	(setq new (point-marker))
	(if (or (and (< priority current)
		     (todos-item-end)
		     (save-excursion (search-forward cat beg t)))
		(and (> priority current)
		     (save-excursion (search-backward cat end t))))
	    (progn
	      (set-marker new nil)
	      (goto-char beg)
	      (error (concat "Cannot reprioritize items in the same category "
			     "in this mode, only in Todos mode")))
	  (goto-char beg)
	  (todos-remove-item)
	  (goto-char new)
	  (todos-insert-with-overlays item)
	  (set-marker new nil))))))

(defun todos-move-item (&optional file)
  "Move at least one todo item to another category.

If there are marked items, move all of these; otherwise, move
the item at point.

With non-nil argument FILE, first prompt for another Todos file and
then a category in that file to move the item or items to.

If the chosen category is not one of the existing categories,
then it is created and the item(s) become(s) the first
entry/entries in that category."
  (interactive)
  (unless (or (todos-done-item-p)
	      ;; Point is between todo and done items.
	      (looking-at "^$"))
    (let* ((buffer-read-only)
	   (file1 todos-current-todos-file)
	   (cat1 (todos-current-category))
	   (marked (assoc cat1 todos-categories-with-marks))
	   (num todos-category-number)
	   (item (todos-item-string))
	   (diary-item (todos-diary-item-p))
	   (omark (save-excursion (todos-item-start) (point-marker)))
	   (file2 (if file
		      (todos-read-file-name "Choose a Todos file: " nil t)
		    file1))
	   (count 0)
	   (count-diary 0)
	   cat2 nmark)
      (set-buffer (find-file-noselect file2))
      (setq cat2 (let* ((pl (if (and marked (> (cdr marked) 1)) "s" ""))
			(name (todos-read-category
			       (concat "Move item" pl " to category: ")))
			(prompt (concat "Choose a different category than "
					"the current one\n(type `"
					(key-description
					 (car (where-is-internal
					       'todos-set-item-priority)))
					"' to reprioritize item "
					"within the same category): ")))
		   (while (equal name cat1)
		     (setq name (todos-read-category prompt)))
		   name))
      (set-buffer (find-buffer-visiting file1))
      (if marked
	  (progn
	   (setq item nil)
	   (goto-char (point-min))
	   (while (not (eobp))
	     (when (todos-marked-item-p)
	       (setq item (concat item (todos-item-string) "\n"))
	       (setq count (1+ count))
	       (when (todos-diary-item-p)
		 (setq count-diary (1+ count-diary))))
	     (todos-forward-item))
	   ;; Chop off last newline.
	   (setq item (substring item 0 -1)))
	(setq count 1)
	(when (todos-diary-item-p) (setq count-diary 1)))
      (set-window-buffer (selected-window)
			 (set-buffer (find-file-noselect file2)))
      (unless (assoc cat2 todos-categories) (todos-add-category cat2))
      (todos-set-item-priority item cat2 t)
      (setq nmark (point-marker))
      (todos-update-count 'todo count)
      (todos-update-count 'diary count-diary)
      (todos-update-categories-sexp)
      (with-current-buffer (find-buffer-visiting file1)
	(save-excursion
	  (save-restriction
	    (widen)
	    (goto-char omark)
	    (if marked
		(let (beg end)
		  (setq item nil)
		  (re-search-backward
		   (concat "^" (regexp-quote todos-category-beg)) nil t)
		  (forward-line)
		  (setq beg (point))
		  (re-search-forward
		   (concat "^" (regexp-quote todos-category-done)) nil t)
		  (setq end (match-beginning 0))
		  (goto-char beg)
		  (while (< (point) end)
		    (if (todos-marked-item-p)
			(todos-remove-item)
		      (todos-forward-item))))
	      (todos-remove-item))))
	(todos-update-count 'todo (- count) cat1)
	(todos-update-count 'diary (- count-diary) cat1)
	(todos-update-categories-sexp))
      (set-window-buffer (selected-window)
			 (set-buffer (find-file-noselect file2)))
      (setq todos-category-number (todos-category-number cat2))
      (todos-category-select)
      (goto-char nmark))))

(defun todos-move-item-to-file ()
  "Move the current todo item to a category in another Todos file."
  (interactive)
  (todos-move-item t))

(defun todos-move-item-to-diary ()
  "Move one or more items in current category to the diary file.

If there are marked items, move all of these; otherwise, move
the item at point."
  (interactive)
  ;; FIXME
  )

;; FIXME: make adding date customizable, and make this and time customization
;; overridable via double prefix arg ??
(defun todos-item-done (&optional arg)
  "Tag at least one item in this category as done and hide it.

With prefix argument ARG prompt for a comment and append it to
the done item; this is only possible if there are no marked
items.  If there are marked items, tag all of these with
`todos-done-string' plus the current date and, if
`todos-always-add-time-string' is non-nil, the current time;
otherwise, just tag the item at point.  Items tagged as done are
relocated to the category's (by default hidden) done section."
  (interactive "P")
  (let* ((cat (todos-current-category))
	 (marked (assoc cat todos-categories-with-marks)))
    (unless (or (todos-done-item-p) 
		(and (looking-at "^$") (not marked)))
      (let* ((date-string (calendar-date-string (calendar-current-date) t t))
	     (time-string (if todos-always-add-time-string
			      (concat " " (substring (current-time-string) 11 16))
			    ""))
	     (done-prefix (concat "[" todos-done-string date-string time-string
				  "] "))
	     (comment (and arg (not marked) (read-string "Enter a comment: ")))
	     (item-count 0)
	     (diary-count 0)
	     item done-item
	     (buffer-read-only))
	(and marked (goto-char (point-min)))
	(catch 'done
	  (while (not (eobp))
	    (if (or (not marked) (and marked (todos-marked-item-p)))
		(progn
		  (setq item (todos-item-string))
		  (setq done-item (cond (marked
					 (concat done-item done-prefix item "\n"))
					(comment
					 (concat done-prefix item " ["
						 todos-comment-string
						 ": " comment "]"))
					(t
					 (concat done-prefix item))))
		  (setq item-count (1+ item-count))
		  (when (todos-diary-item-p)
		    (setq diary-count (1+ diary-count)))
		  (todos-remove-item)
		  (unless marked (throw 'done nil)))
	      (todos-forward-item))))
	(when marked
	  ;; Chop off last newline of done item string.
	  (setq done-item (substring done-item 0 -1))
	  (remove-overlays (point-min) (point-max) 'before-string todos-item-mark)
	  (setq todos-categories-with-marks
		(assq-delete-all cat todos-categories-with-marks)))
	(save-excursion
	  (widen)
	  (re-search-forward
	   (concat "^" (regexp-quote todos-category-done)) nil t)
	  (forward-char)
	  (insert done-item "\n"))
	(todos-update-count 'todo (- item-count))
	(todos-update-count 'done item-count)
	(todos-update-count 'diary (- diary-count))
	(todos-update-categories-sexp)
	(save-excursion (todos-category-select))))))

(defun todos-done-item-add-edit-or-delete-comment (&optional arg)
  "Add a comment to this done item or edit an existing comment.
With prefix ARG delete an existing comment."
  (interactive "P")
  (when (todos-done-item-p)
    (let ((item (todos-item-string))
	  (end (save-excursion (todos-item-end)))
	  comment buffer-read-only)
      (save-excursion
	(todos-item-start)
	(if (re-search-forward (concat " \\["
				       (regexp-quote todos-comment-string)
				       ": \\([^]]+\\)\\]") end t)
	    (if arg
		(when (y-or-n-p "Delete comment? ")
		  (delete-region (match-beginning 0) (match-end 0)))
	      (setq comment (read-string "Edit comment: "
					 (cons (match-string 1) 1)))
	      (replace-match comment nil nil nil 1))
	  (setq comment (read-string "Enter a comment: "))
	  (todos-item-end)
	  (insert " [" todos-comment-string ": " comment "]"))))))

;; FIXME: also with marked items
;; FIXME: delete comment from restored item or just leave it up to user?
(defun todos-item-undo ()
  "Restore this done item to the todo section of this category.
If done item has a comment, ask whether to omit the comment from
the restored item."
  (interactive)
  (when (todos-done-item-p)
    (let* ((buffer-read-only)
	   (done-item (todos-item-string))
	   (opoint (point))
	   (orig-mrk (progn (todos-item-start) (point-marker)))
	   ;; Find the end of the date string added upon tagging item as done.
	   (start (search-forward "] "))
	   (end (save-excursion (todos-item-end)))
	   item undone)
      (todos-item-start)
      (when (and (re-search-forward (concat " \\["
					    (regexp-quote todos-comment-string)
					    ": \\([^]]+\\)\\]") end t)
		 (y-or-n-p "Omit comment from restored item? "))
	(delete-region (match-beginning 0) (match-end 0)))
      (setq item (buffer-substring start end))
      (todos-remove-item)
      ;; If user cancels before setting new priority, then leave the done item
      ;; unchanged.
      (unwind-protect
	  (progn
	    (todos-set-item-priority item (todos-current-category) t)
	    (setq undone t)
	    (todos-update-count 'todo 1)
	    (todos-update-count 'done -1)
	    (and (todos-diary-item-p) (todos-update-count 'diary 1))
	    (todos-update-categories-sexp))
	(unless undone
	  (widen)
	  (goto-char orig-mrk)
	  (todos-insert-with-overlays done-item)
	  (let ((todos-show-with-done t))
	    (todos-category-select)
	    (goto-char opoint)))
	(set-marker orig-mrk nil)))))

(defun todos-archive-done-item (&optional all)
  "Archive at least one done item in this category.

If there are marked done items (and no marked todo items),
archive all of these; otherwise, with non-nil argument ALL,
archive all done items in this category; otherwise, archive the
done item at point.

If the archive of this file does not exist, it is created.  If
this category does not exist in the archive, it is created."
  (interactive)
  (when (eq major-mode 'todos-mode)
    (if (and all (zerop (todos-get-count 'done)))
	(message "No done items in this category")
      (catch 'end
	(let* ((cat (todos-current-category))
	       (tbuf (current-buffer))
	       (marked (assoc cat todos-categories-with-marks))
	       (afile (concat (file-name-sans-extension
			       todos-current-todos-file) ".toda"))
	       (archive (if (file-exists-p afile)
			    (find-file-noselect afile t)
			  (get-buffer-create afile)))
	       (item (and (todos-done-item-p) (concat (todos-item-string) "\n")))
	       (count 0)
	       marked-items beg end all-done
	       buffer-read-only)
	  (cond
	   (marked
	    (save-excursion
	      (goto-char (point-min))
	      (while (not (eobp))
		(when (todos-marked-item-p)
		  (if (not (todos-done-item-p))
		      (throw 'end (message "Only done items can be archived"))
		    (setq marked-items
			  (concat marked-items (todos-item-string) "\n"))
		    (setq count (1+ count))))
		(todos-forward-item))))
	   (all
	    (if (y-or-n-p "Archive all done items in this category? ")
		(save-excursion
		  (save-restriction
		    (goto-char (point-min))
		    (widen)
		    (setq beg (progn
				(re-search-forward todos-done-string-start nil t)
				(match-beginning 0))
			  end (if (re-search-forward
				   (concat "^" (regexp-quote todos-category-beg))
				   nil t)
				  (match-beginning 0)
				(point-max))
			  all-done (buffer-substring beg end)
			  count (todos-get-count 'done))))
	      (throw 'end nil))))
	  (when (or marked all item)
	    (with-current-buffer archive
	      (unless buffer-file-name (erase-buffer))
	      (let (buffer-read-only)
		(widen)
		(goto-char (point-min))
		(if (and (re-search-forward (concat "^"
						    (regexp-quote
						     (concat todos-category-beg
							     cat)))
					    nil t)
			 (re-search-forward (regexp-quote todos-category-done)
					    nil t))
		    ;; Start of done items section in existing category.
		    (forward-char)
		  (todos-add-category cat)
		  ;; Start of done items section in new category.
		  (goto-char (point-max)))
		(insert (cond (marked marked-items)
			      (all all-done)
			      (item)))
		(todos-update-count 'done (if (or marked all) count 1) cat)
		(todos-update-categories-sexp)
		;; If archive is new, save to file now (using write-region in
		;; order not to get prompted for file to save to), to let
		;; auto-mode-alist take effect below.
		(unless buffer-file-name
		  (write-region nil nil afile)
		  (kill-buffer))))
	    (with-current-buffer tbuf
	      (cond ((or marked item)
		     (and marked (goto-char (point-min)))
		     (catch 'done
		       (while (not (eobp))
			 (if (or (and marked (todos-marked-item-p)) item)
			     (progn
			       (todos-remove-item)
			       (todos-update-count 'done -1)
			       (todos-update-count 'archived 1)
			       ;; Don't leave point below last item.
			       (and item (bolp) (eolp) (< (point-min) (point-max))
				    (todos-backward-item))
			       (when item 
				 (throw 'done (setq item nil))))
			   (todos-forward-item)))))
		    (all
		     (remove-overlays beg end)
		     (delete-region beg end)
		     (todos-update-count 'done (- count))
		     (todos-update-count 'archived count)))
	      (when marked
		(remove-overlays (point-min) (point-max)
				 'before-string todos-item-mark)
		(setq todos-categories-with-marks
		      (assq-delete-all cat todos-categories-with-marks)))
	      (todos-update-categories-sexp)
	      (todos-prefix-overlays)))
	  (find-file afile)
	  (todos-category-number cat)
	  (todos-category-select)
	  (split-window-below)
	  (set-window-buffer (selected-window) tbuf))))))

(defun todos-archive-category-done-items ()
  "Move all done items in this category to its archive."
  (interactive)
  (todos-archive-done-item t))

(defun todos-unarchive-items (&optional all)
  "Unarchive at least one item in this archive category.

If there are marked items, unarchive all of these; otherwise,
with non-nil argument ALL, unarchive all items in this category;
otherwise, unarchive the item at point.

Unarchived items are restored as done items to the corresponding
category in the Todos file, inserted at the end of done section.
If all items in the archive category were restored, the category
is deleted from the archive.  If this was the only category in the
archive, the archive file is deleted."
  (interactive)
  (when (eq major-mode 'todos-archive-mode)
    (catch 'end
      (let* ((cat (todos-current-category))
	     (tbuf (find-file-noselect
		    (concat (file-name-sans-extension todos-current-todos-file)
			    ".todo") t))
	     (marked (assoc cat todos-categories-with-marks))
	     (item (concat (todos-item-string) "\n"))
	     (all-items (when all (buffer-substring (point-min) (point-max))))
	     (all-count (when all (todos-get-count 'done)))
	     marked-items marked-count
	     buffer-read-only)
	(when marked
	  (save-excursion
	    (goto-char (point-min))
	    (while (not (eobp))
	      (when (todos-marked-item-p)
		(concat marked-items (todos-item-string) "\n")
		(setq marked-count (1+ marked-count)))
	      (todos-forward-item))))
	;; Restore items to end of category's done section and update counts.
	(with-current-buffer tbuf
	  (let (buffer-read-only)
	    (widen)
	    (goto-char (point-min))
	    (re-search-forward (concat "^" (regexp-quote
					    (concat todos-category-beg cat)))
			       nil t)
	    ;; Go to end of category's done section.
	    (if (re-search-forward (concat "^" (regexp-quote todos-category-beg))
				   nil t)
		(goto-char (match-beginning 0))
	      (goto-char (point-max)))
	    (cond (marked
		   (insert marked-items)
		   (todos-update-count 'done marked-count cat)
		   (todos-update-count 'archived (- marked-count) cat))
		  (all
		   (insert all-items)
		   (todos-update-count 'done all-count cat)
		   (todos-update-count 'archived (- all-count) cat))
		  (t
		   (insert item)
		   (todos-update-count 'done 1 cat)
		   (todos-update-count 'archived -1 cat)))
	    (todos-update-categories-sexp)))
	;; Delete restored items from archive.
	(cond ((or marked item)
	       (and marked (goto-char (point-min)))
	       (catch 'done
		 (while (not (eobp))
		   (if (or (and marked (todos-marked-item-p)) item)
		       (progn
			 (todos-remove-item)
			 ;; Don't leave point below last item.
			 (and item (bolp) (eolp) (< (point-min) (point-max))
			      (todos-backward-item))
			 (when item 
			   (throw 'done (setq item nil))))
		     (todos-forward-item))))
	       (todos-update-count 'done (if marked (- marked-count) -1) cat))
	      (all
	       (remove-overlays (point-min) (point-max))
	       (delete-region (point-min) (point-max))))
	;; If that was the last category in the archive, delete the whole file.
	(if (= (length todos-categories) 1)
	    (progn
	      (delete-file todos-current-todos-file)
	      ;; Don't bother confirming killing the archive buffer.
	      (set-buffer-modified-p nil)
	      (kill-buffer))
	  ;; Otherwise, if the archive category is now empty, delete it.
	  (when (eq (point-min) (point-max))
	    (widen)
	    (let ((beg (re-search-backward
			(concat "^" (regexp-quote todos-category-beg) cat)
			nil t))
		  (end (if (re-search-forward
			    (concat "^" (regexp-quote todos-category-beg))
			    nil t 2)
			   (match-beginning 0)
			 (point-max))))
	      (remove-overlays beg end)
	      (delete-region beg end)
	      (setq todos-categories (delete (assoc cat todos-categories)
					     todos-categories))
	      (todos-update-categories-sexp))))
	;; Visit category in Todos file and show restored done items.
	(let ((tfile (buffer-file-name tbuf))
	      (todos-show-with-done t))
	  (set-window-buffer (selected-window)
			     (set-buffer (find-file-noselect tfile)))
	  (todos-category-number cat)
	  (todos-show)
	  (message "Items unarchived."))))))

(defun todos-unarchive-category ()
  "Unarchive all items in this category.  See `todos-unarchive-items'."
  (interactive)
  (todos-unarchive-items t))

(provide 'todos)

;;; todos.el ends here

;; ---------------------------------------------------------------------------

;; FIXME: remove when part of Emacs
(add-to-list 'auto-mode-alist '("\\.todo\\'" . todos-mode))
(add-to-list 'auto-mode-alist '("\\.toda\\'" . todos-archive-mode))

;;; Addition to calendar.el
;; FIXME: autoload when key-binding is defined in calendar.el
(defun todos-insert-item-from-calendar ()
  ""
  (interactive)
  ;; FIXME: todos-current-todos-file is nil here, better to solicit Todos
  ;; file? todos-global-current-todos-file is nil if no Todos file has been
  ;; visited
  (pop-to-buffer (file-name-nondirectory todos-global-current-todos-file))
  (todos-show)
  ;; FIXME: this now calls todos-set-date-from-calendar
  (todos-insert-item t 'calendar))

;; FIXME: calendar is loaded before todos
;; (add-hook 'calendar-load-hook
	  ;; (lambda ()
(define-key calendar-mode-map "it" 'todos-insert-item-from-calendar);))

;; ---------------------------------------------------------------------------
;;; necessitated adaptations to diary-lib.el

;; (defun diary-goto-entry (button)
;;   "Jump to the diary entry for the BUTTON at point."
;;   (let* ((locator (button-get button 'locator))
;;          (marker (car locator))
;;          markbuf file opoint)
;;     ;; If marker pointing to diary location is valid, use that.
;;     (if (and marker (setq markbuf (marker-buffer marker)))
;;         (progn
;;           (pop-to-buffer markbuf)
;;           (goto-char (marker-position marker)))
;;       ;; Marker is invalid (eg buffer has been killed, as is the case with
;;       ;; included diary files).
;;       (or (and (setq file (cadr locator))
;;                (file-exists-p file)
;;                (find-file-other-window file)
;;                (progn
;;                  (when (eq major-mode (default-value 'major-mode)) (diary-mode))
;; 		 (when (eq major-mode 'todos-mode) (widen))
;;                  (goto-char (point-min))
;;                  (when (re-search-forward (format "%s.*\\(%s\\)"
;; 						  (regexp-quote (nth 2 locator))
;; 						  (regexp-quote (nth 3 locator)))
;; 					  nil t)
;; 		   (goto-char (match-beginning 1))
;; 		   (when (eq major-mode 'todos-mode)
;; 		     (setq opoint (point))
;; 		     (re-search-backward (concat "^"
;; 						 (regexp-quote todos-category-beg)
;; 						 "\\(.*\\)\n")
;; 					 nil t)
;; 		     (todos-category-number (match-string 1))
;; 		     (todos-category-select)
;; 		     (goto-char opoint)))))
;;           (message "Unable to locate this diary entry")))))
