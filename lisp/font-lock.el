;; Electric Font Lock Mode
;; Copyright (C) 1992, 1993, 1994, 1995 Free Software Foundation, Inc.

;; Author: jwz, then rms, then sm <simon@gnu.ai.mit.edu>
;; Maintainer: FSF
;; Keywords: languages, faces

;; This file is part of GNU Emacs.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:

;; Font Lock mode is a minor mode that causes your comments to be displayed in
;; one face, strings in another, reserved words in another, and so on.
;;
;; Comments will be displayed in `font-lock-comment-face'.
;; Strings will be displayed in `font-lock-string-face'.
;; Regexps are used to display selected patterns in other faces.
;;
;; To make the text you type be fontified, use M-x font-lock-mode RET.
;; When this minor mode is on, the faces of the current line are updated with
;; every insertion or deletion.
;;
;; To turn Font Lock mode on automatically, add this to your .emacs file:
;;
;;  (add-hook 'emacs-lisp-mode-hook 'turn-on-font-lock)
;;
;; Fontification for a particular mode may be available in a number of levels
;; of decoration.  The higher the level, the more decoration, but the more time
;; it takes to fontify.  See the variable `font-lock-maximum-decoration', and
;; also the variable `font-lock-maximum-size'.

;; If you add patterns for a new mode, say foo.el's `foo-mode', say in which
;; you don't want syntactic fontification to occur, you can make Font Lock mode
;; use your regexps when turning on Font Lock by adding to `foo-mode-hook':
;;
;;  (add-hook 'foo-mode-hook
;;   '(lambda () (make-local-variable 'font-lock-defaults)
;;               (setq font-lock-defaults '(foo-font-lock-keywords t))))
;;
;; Nasty regexps of the form "bar\\(\\|lo\\)\\|f\\(oo\\|u\\(\\|bar\\)\\)\\|lo"
;; are made thusly: (make-regexp '("foo" "fu" "fubar" "bar" "barlo" "lo")) for
;; efficiency.  See /pub/gnu/emacs/elisp-archive/functions/make-regexp.el.Z on
;; archive.cis.ohio-state.edu for this and other functions.

;; What is fontification for?  You might say, "It's to make my code look nice."
;; I think it should be for adding information in the form of cues.  These cues
;; should provide you with enough information to both (a) distinguish between
;; different items, and (b) identify the item meanings, without having to read
;; the items and think about it.  Therefore, fontification allows you to think
;; less about, say, the structure of code, and more about, say, why the code
;; doesn't work.  Or maybe it allows you to think less and drift off to sleep.
;;
;; So, here are my opinions/advice/guidelines:
;; 
;; - Use the same face for the same conceptual object, across all modes.
;;   i.e., (b) above, all modes that have items that can be thought of as, say,
;;   keywords, should be highlighted with the same face, etc.
;; - Keep the faces distinct from each other as far as possible.
;;   i.e., (a) above.
;; - Make the face attributes fit the concept as far as possible.
;;   i.e., function names might be a bold colour such as blue, comments might
;;   be a bright colour such as red, character strings might be brown, because,
;;   err, strings are brown (that was not the reason, please believe me).
;; - Don't use a non-nil OVERRIDE unless you have a good reason.
;;   Only use OVERRIDE for special things that are easy to define, such as the
;;   way `...' quotes are treated in strings and comments in Emacs Lisp mode.
;;   Don't use it to, say, highlight keywords in commented out code or strings.
;; - Err, that's it.

;; User variables.

(defvar font-lock-verbose t
  "*If non-nil, means show status messages when fontifying.")

;;;###autoload
(defvar font-lock-maximum-decoration nil
  "*If non-nil, the maximum decoration level for fontifying.
If nil, use the default decoration (typically the minimum available).
If t, use the maximum decoration available.
If a number, use that level of decoration (or if not available the maximum).
If a list, each element should be a cons pair of the form (MAJOR-MODE . LEVEL),
where MAJOR-MODE is a symbol or t (meaning the default).  For example:
 ((c++-mode . 2) (c-mode . t) (t . 1))
means use level 2 decoration for buffers in `c++-mode', the maximum decoration
available for buffers in `c-mode', and level 1 decoration otherwise.")

;;;###autoload
(defvar font-lock-maximum-size (* 250 1024)
  "*If non-nil, the maximum size for buffers for fontifying.
Only buffers less than this can be fontified when Font Lock mode is turned on.
If nil, means size is irrelevant.
If a list, each element should be a cons pair of the form (MAJOR-MODE . SIZE),
where MAJOR-MODE is a symbol or t (meaning the default).  For example:
 ((c++-mode . 256000) (c-mode . 256000) (rmail-mode . 1048576))
means that the maximum size is 250K for buffers in `c++-mode' or `c-mode', one
megabyte for buffers in `rmail-mode', and size is irrelevant otherwise.")

;; Fontification variables:

(defvar font-lock-comment-face		'font-lock-comment-face
  "Face to use for comments.")

(defvar font-lock-string-face		'font-lock-string-face
  "Face to use for strings.")

(defvar font-lock-keyword-face		'font-lock-keyword-face
  "Face to use for keywords.")

(defvar font-lock-function-name-face	'font-lock-function-name-face
  "Face to use for function names.")

(defvar font-lock-variable-name-face	'font-lock-variable-name-face
  "Face to use for variable names.")

(defvar font-lock-type-face		'font-lock-type-face
  "Face to use for type names.")

(defvar font-lock-reference-face	'font-lock-reference-face
  "Face to use for reference names.")

(defvar font-lock-keywords nil
  "*A list of the keywords to highlight.
Each element should be of the form:

 MATCHER
 (MATCHER . MATCH)
 (MATCHER . FACENAME)
 (MATCHER . HIGHLIGHT)
 (MATCHER HIGHLIGHT ...)

where HIGHLIGHT should be either MATCH-HIGHLIGHT or MATCH-ANCHORED.

For highlighting single items, typically only MATCH-HIGHLIGHT is required.
However, if an item or (typically) items is to be hightlighted following the
instance of another item (the anchor) then MATCH-ANCHORED may be required.

MATCH-HIGHLIGHT should be of the form:

 (MATCH FACENAME OVERRIDE LAXMATCH)

Where MATCHER can be either the regexp to search for, or the function name to
call to make the search (called with one argument, the limit of the search).
MATCH is the subexpression of MATCHER to be highlighted.  FACENAME is an
expression whose value is the face name to use.  FACENAME's default attributes
may be defined in `font-lock-face-attributes'.

OVERRIDE and LAXMATCH are flags.  If OVERRIDE is t, existing fontification may
be overwritten.  If `keep', only parts not already fontified are highlighted.
If `prepend' or `append', existing fontification is merged with the new, in
which the new or existing fontification, respectively, takes precedence.
If LAXMATCH is non-nil, no error is signalled if there is no MATCH in MATCHER.

For example, an element of the form highlights (if not already highlighted):

 \"foo\"			Occurrences of \"foo\" in `font-lock-keyword-face'.
 (\"fu\\\\(bar\\\\)\" . 1)	Substring \"bar\" within all occurrences of \"fubar\" in
			the value of `font-lock-keyword-face'.
 (\"fubar\" . fubar-face)	Occurrences of \"fubar\" in the value of `fubar-face'.
 (\"foo\\\\|bar\" 0 foo-bar-face t)
			Occurrences of either \"foo\" or \"bar\" in the value
			of `foo-bar-face', even if already highlighted.

MATCH-ANCHORED should be of the form:

 (MATCHER PRE-MATCH-FORM POST-MATCH-FORM MATCH-HIGHLIGHT ...)

Where MATCHER is as for MATCH-HIGHLIGHT.  PRE-MATCH-FORM and POST-MATCH-FORM
are evaluated before the first, and after the last, instance MATCH-ANCHORED's
MATCHER is used.  Therefore they can be used to initialise before, and cleanup
after, MATCHER is used.  Typically, PRE-MATCH-FORM is used to move to some
position relative to the original MATCHER, before starting with
MATCH-ANCHORED's MATCHER.  POST-MATCH-FORM might be used to move, before
resuming with MATCH-ANCHORED's parent's MATCHER.

For example, an element of the form highlights (if not already highlighted):

 (\"anchor\" (0 anchor-face) (\".*\\\\(item\\\\)\" nil nil (1 item-face)))

 Occurrences of \"anchor\" in the value of `anchor-face', and subsequent
 occurrences of \"item\" on the same line (by virtue of the `.*' regexp) in the
 value of `item-face'.  (Here PRE-MATCH-FORM and POST-MATCH-FORM are nil.
 Therefore \"item\" is initially searched for starting from the end of the match
 of \"anchor\", and searching for subsequent instance of \"anchor\" resumes from
 where searching for \"item\" concluded.)

Note that the MATCH-ANCHORED feature is experimental; in the future, we may
replace it with other ways of providing this functionality.

These regular expressions should not match text which spans lines.  While
\\[font-lock-fontify-buffer] handles multi-line patterns correctly, updating
when you edit the buffer does not, since it considers text one line at a time.

Be very careful composing regexps for this list;
the wrong pattern can dramatically slow things down!")
(make-variable-buffer-local 'font-lock-keywords)

(defvar font-lock-defaults nil
  "If set by a major mode, should be the defaults for Font Lock mode.
The value should be like the `cdr' of an item in `font-lock-defaults-alist'.")

(defvar font-lock-defaults-alist
  (let (;; For C and Lisp modes we use `beginning-of-defun', rather than nil,
	;; for SYNTAX-BEGIN.  Thus the calculation of the cache is usually
	;; faster but not infallible, so we risk mis-fontification.  --sm.
	(c-mode-defaults
	 '((c-font-lock-keywords c-font-lock-keywords-1
	    c-font-lock-keywords-2 c-font-lock-keywords-3)
	   nil nil ((?_ . "w")) beginning-of-defun))
	(c++-mode-defaults
	 '((c++-font-lock-keywords c++-font-lock-keywords-1 
	    c++-font-lock-keywords-2 c++-font-lock-keywords-3)
	   nil nil ((?_ . "w") (?~ . "w")) beginning-of-defun))
	(lisp-mode-defaults
	 '((lisp-font-lock-keywords
	    lisp-font-lock-keywords-1 lisp-font-lock-keywords-2)
	   nil nil
	   ((?: . "w") (?- . "w") (?* . "w") (?+ . "w") (?. . "w") (?< . "w")
	    (?> . "w") (?= . "w") (?! . "w") (?? . "w") (?$ . "w") (?% . "w")
	    (?_ . "w") (?& . "w") (?~ . "w") (?^ . "w") (?/ . "w"))
	   beginning-of-defun))
	(scheme-mode-defaults
	 '(scheme-font-lock-keywords nil t
	   ((?: . "w") (?- . "w") (?* . "w") (?+ . "w") (?. . "w") (?< . "w")
	    (?> . "w") (?= . "w") (?! . "w") (?? . "w") (?$ . "w") (?% . "w")
	    (?_ . "w") (?& . "w") (?~ . "w") (?^ . "w") (?/ . "w"))
	   beginning-of-defun))
	;; For TeX modes we could use `backward-paragraph' for the same reason.
	(tex-mode-defaults '(tex-font-lock-keywords nil nil ((?$ . "\""))))
	)
    (list
     (cons 'bibtex-mode			tex-mode-defaults)
     (cons 'c++-c-mode			c-mode-defaults)
     (cons 'c++-mode			c++-mode-defaults)
     (cons 'c-mode			c-mode-defaults)
     (cons 'elec-c-mode			c-mode-defaults)
     (cons 'emacs-lisp-mode		lisp-mode-defaults)
     (cons 'inferior-scheme-mode	scheme-mode-defaults)
     (cons 'latex-mode			tex-mode-defaults)
     (cons 'lisp-mode			lisp-mode-defaults)
     (cons 'lisp-interaction-mode	lisp-mode-defaults)
     (cons 'plain-tex-mode		tex-mode-defaults)
     (cons 'scheme-mode			scheme-mode-defaults)
     (cons 'scheme-interaction-mode	scheme-mode-defaults)
     (cons 'slitex-mode			tex-mode-defaults)
     (cons 'tex-mode			tex-mode-defaults)))
  "Alist of default major mode and Font Lock defaults.
Each item should be a list of the form:

 (MAJOR-MODE . (KEYWORDS KEYWORDS-ONLY CASE-FOLD SYNTAX-ALIST SYNTAX-BEGIN))

where MAJOR-MODE is a symbol.  KEYWORDS may be a symbol (a variable or function
whose value is the keywords to use for fontification) or a list of symbols.
If KEYWORDS-ONLY is non-nil, syntactic fontification (strings and comments) is
not performed.  If CASE-FOLD is non-nil, the case of the keywords is ignored
when fontifying.  If SYNTAX-ALIST is non-nil, it should be a list of cons pairs
of the form (CHAR . STRING) used to set the local Font Lock syntax table, for
keyword and syntactic fontification (see `modify-syntax-entry').

If SYNTAX-BEGIN is non-nil, it should be a function with no args used to move
backwards outside any enclosing syntactic block, for syntactic fontification.
Typical values are `beginning-of-line' (i.e., the start of the line is known to
be outside a syntactic block), or `beginning-of-defun' for programming modes or
`backward-paragraph' for textual modes (i.e., the mode-dependent function is
known to move outside a syntactic block).  If nil, the beginning of the buffer
is used as a position outside of a syntactic block, in the worst case.

These item elements are used by Font Lock mode to set the variables
`font-lock-keywords', `font-lock-keywords-only',
`font-lock-keywords-case-fold-search', `font-lock-syntax-table' and
`font-lock-beginning-of-syntax-function', respectively.")

(defvar font-lock-keywords-only nil
  "*Non-nil means Font Lock should not fontify comments or strings.
This is normally set via `font-lock-defaults'.")

(defvar font-lock-keywords-case-fold-search nil
  "*Non-nil means the patterns in `font-lock-keywords' are case-insensitive.
This is normally set via `font-lock-defaults'.")

(defvar font-lock-syntax-table nil
  "Non-nil means use this syntax table for fontifying.
If this is nil, the major mode's syntax table is used.
This is normally set via `font-lock-defaults'.")

;; If this is nil, we only use the beginning of the buffer if we can't use
;; `font-lock-cache-position' and `font-lock-cache-state'.
(defvar font-lock-beginning-of-syntax-function nil
  "*Non-nil means use this function to move back outside of a syntactic block.
If this is nil, the beginning of the buffer is used (in the worst case).
This is normally set via `font-lock-defaults'.")

;; These record the parse state at a particular position, always the start of a
;; line.  Used to make `font-lock-fontify-syntactically-region' faster.
(defvar font-lock-cache-position nil)
(defvar font-lock-cache-state nil)
(make-variable-buffer-local 'font-lock-cache-position)
(make-variable-buffer-local 'font-lock-cache-state)

(defvar font-lock-mode nil)		; For the modeline.
(defvar font-lock-fontified nil)	; Whether we have fontified the buffer.
(put 'font-lock-fontified 'permanent-local t)

;;;###autoload
(defvar font-lock-mode-hook nil
  "Function or functions to run on entry to Font Lock mode.")

;; User functions.

;;;###autoload
(defun font-lock-mode (&optional arg)
  "Toggle Font Lock mode.
With arg, turn Font Lock mode on if and only if arg is positive.

When Font Lock mode is enabled, text is fontified as you type it:

 - Comments are displayed in `font-lock-comment-face';
 - Strings are displayed in `font-lock-string-face';
 - Certain other expressions are displayed in other faces according to the
   value of the variable `font-lock-keywords'.

You can enable Font Lock mode in any major mode automatically by turning on in
the major mode's hook.  For example, put in your ~/.emacs:

 (add-hook 'c-mode-hook 'turn-on-font-lock)

Or for any visited file with the following in your ~/.emacs:

 (add-hook 'find-file-hooks 'turn-on-font-lock)

The default Font Lock mode faces and their attributes are defined in the
variable `font-lock-face-attributes', and Font Lock mode default settings in
the variable `font-lock-defaults-alist'.  You can set your own default settings
for some mode, by setting a buffer local value for `font-lock-defaults', via
its mode hook.

Where modes support different levels of fontification, you can use the variable
`font-lock-maximum-decoration' to specify which level you generally prefer.
When you turn Font Lock mode on/off the buffer is fontified/defontified, though
fontification occurs only if the buffer is less than `font-lock-maximum-size'.
To fontify a buffer without turning on Font Lock mode, and regardless of buffer
size, you can use \\[font-lock-fontify-buffer]."
  (interactive "P")
  (let ((on-p (if arg (> (prefix-numeric-value arg) 0) (not font-lock-mode)))
	(maximum-size (if (not (consp font-lock-maximum-size))
			  font-lock-maximum-size
			(cdr (or (assq major-mode font-lock-maximum-size)
				 (assq t font-lock-maximum-size))))))
    (if (equal (buffer-name) " *Compiler Input*") ; hack for bytecomp...
	(setq on-p nil))
    (if (not on-p)
	(remove-hook 'after-change-functions 'font-lock-after-change-function)
      (make-local-variable 'after-change-functions)
      (add-hook 'after-change-functions 'font-lock-after-change-function))
    (set (make-local-variable 'font-lock-mode) on-p)
    (cond (on-p
	   (font-lock-set-defaults)
	   (make-local-variable 'before-revert-hook)
	   (make-local-variable 'after-revert-hook)
	   ;; If buffer is reverted, must clean up the state.
	   (add-hook 'before-revert-hook 'font-lock-revert-setup)
	   (add-hook 'after-revert-hook 'font-lock-revert-cleanup)
	   (run-hooks 'font-lock-mode-hook)
	   (cond (font-lock-fontified
		  nil)
		 ((or (null maximum-size) (<= (buffer-size) maximum-size))
		  (font-lock-fontify-buffer))
		 (font-lock-verbose
		  (message "Fontifying %s... buffer too big." (buffer-name)))))
	  (font-lock-fontified
	   (setq font-lock-fontified nil)
	   (remove-hook 'before-revert-hook 'font-lock-revert-setup)
	   (remove-hook 'after-revert-hook 'font-lock-revert-cleanup)
	   (font-lock-unfontify-region (point-min) (point-max))
	   (font-lock-thing-lock-cleanup))
	  (t
	   (remove-hook 'before-revert-hook 'font-lock-revert-setup)
	   (remove-hook 'after-revert-hook 'font-lock-revert-cleanup)
	   (font-lock-thing-lock-cleanup)))
    (force-mode-line-update)))

;;;###autoload
(defun turn-on-font-lock ()
  "Unconditionally turn on Font Lock mode."
  (font-lock-mode 1))

;;;###autoload
(defun font-lock-fontify-buffer ()
  "Fontify the current buffer the way `font-lock-mode' would."
  (interactive)
  (let ((verbose (and (or font-lock-verbose (interactive-p))
		      (not (zerop (buffer-size)))))
	(modified (buffer-modified-p)))
    (set (make-local-variable 'font-lock-fontified) nil)
    (if verbose (message "Fontifying %s..." (buffer-name)))
    ;; Turn it on to run hooks and get the right `font-lock-keywords' etc.
    (or font-lock-mode (font-lock-set-defaults))
    (condition-case nil
	(save-excursion
	  (font-lock-fontify-region (point-min) (point-max) verbose)
	  (setq font-lock-fontified t))
      ;; We don't restore the old fontification, so it's best to unfontify.
      (quit (font-lock-unfontify-region (point-min) (point-max))))
    (if verbose (message "Fontifying %s... %s." (buffer-name)
			 (if font-lock-fontified "done" "aborted")))
    (and (buffer-modified-p)
	 (not modified)
	 (set-buffer-modified-p nil))
    (font-lock-after-fontify-buffer)))

;; Fontification functions.

;; We use this wrapper.  However, `font-lock-fontify-region' used to be the
;; name used for `font-lock-fontify-syntactically-region', so a change isn't
;; back-compatible.  But you shouldn't be calling these directly, should you?
(defun font-lock-fontify-region (beg end &optional loudly)
  (if font-lock-keywords-only
      (font-lock-unfontify-region beg end)
    (font-lock-fontify-syntactically-region beg end loudly))
  (font-lock-fontify-keywords-region beg end loudly))

;; The following must be rethought, since keywords can override fontification.
;      ;; Now scan for keywords, but not if we are inside a comment now.
;      (or (and (not font-lock-keywords-only)
;	       (let ((state (parse-partial-sexp beg end nil nil 
;						font-lock-cache-state)))
;		 (or (nth 4 state) (nth 7 state))))
;	  (font-lock-fontify-keywords-region beg end))

(defun font-lock-unfontify-region (beg end)
  (let ((modified (buffer-modified-p))
	(buffer-undo-list t) (inhibit-read-only t)
	buffer-file-name buffer-file-truename)
    (remove-text-properties beg end '(face nil))
    (and (buffer-modified-p)
	 (not modified)
	 (set-buffer-modified-p nil))))

;; Called when any modification is made to buffer text.
(defun font-lock-after-change-function (beg end old-len)
  (save-excursion
    (save-match-data
      ;; Rescan between start of line from `beg' and start of line after `end'.
      (font-lock-fontify-region
       (progn (goto-char beg) (beginning-of-line) (point))
       (progn (goto-char end) (forward-line 1) (point))))))

;; Syntactic fontification functions.

(defun font-lock-fontify-syntactically-region (start end &optional loudly)
  "Put proper face on each string and comment between START and END.
START should be at the beginning of a line."
  (let ((inhibit-read-only t) (buffer-undo-list t)
	(modified (buffer-modified-p))
	(old-syntax (syntax-table))
	(synstart (if comment-start-skip
		      (concat "\\s\"\\|" comment-start-skip)
		    "\\s\""))
	(comstart (if comment-start-skip
		      (concat "\\s<\\|" comment-start-skip)
		    "\\s<"))
	buffer-file-name buffer-file-truename
	state prev prevstate)
    (if loudly (message "Fontifying %s... (syntactically...)" (buffer-name)))
    (unwind-protect
      (save-restriction
	(widen)
	(goto-char start)
	;;
	;; Use the fontification syntax table, if any.
	(if font-lock-syntax-table (set-syntax-table font-lock-syntax-table))
	;;
	;; Find the state at the `beginning-of-line' before `start'.
	(if (eq start font-lock-cache-position)
	    ;; Use the cache for the state of `start'.
	    (setq state font-lock-cache-state)
	  ;; Find the state of `start'.
	  (if (null font-lock-beginning-of-syntax-function)
	      ;; Use the state at the previous cache position, if any, or
	      ;; otherwise calculate from `point-min'.
	      (if (or (null font-lock-cache-position)
		      (< start font-lock-cache-position))
		  (setq state (parse-partial-sexp (point-min) start))
		(setq state (parse-partial-sexp
			     font-lock-cache-position start
			     nil nil font-lock-cache-state)))
	    ;; Call the function to move outside any syntactic block.
	    (funcall font-lock-beginning-of-syntax-function)
	    (setq state (parse-partial-sexp (point) start)))
	  ;; Cache the state and position of `start'.
	  (setq font-lock-cache-state state
		font-lock-cache-position start))
	;;
	;; If the region starts inside a string, show the extent of it.
	(if (nth 3 state)
	    (let ((beg (point)))
	      (while (and (re-search-forward "\\s\"" end 'move)
			  (nth 3 (parse-partial-sexp beg (point)
						     nil nil state))))
	      (put-text-property beg (point) 'face font-lock-string-face)
	      (setq state (parse-partial-sexp beg (point) nil nil state))))
	;;
	;; Likewise for a comment.
	(if (or (nth 4 state) (nth 7 state))
	    (let ((beg (point)))
	      (save-restriction
		(narrow-to-region (point-min) end)
		(condition-case nil
		    (progn
		      (re-search-backward comstart (point-min) 'move)
		      (forward-comment 1)
		      ;; forward-comment skips all whitespace,
		      ;; so go back to the real end of the comment.
		      (skip-chars-backward " \t"))
		  (error (goto-char end))))
	      (put-text-property beg (point) 'face font-lock-comment-face)
	      (setq state (parse-partial-sexp beg (point) nil nil state))))
	;;
	;; Find each interesting place between here and `end'.
	(while (and (< (point) end)
		    (setq prev (point) prevstate state)
		    (re-search-forward synstart end t)
		    (progn
		      ;; Clear out the fonts of what we skip over.
		      (remove-text-properties prev (point) '(face nil))
		      ;; Verify the state at that place
		      ;; so we don't get fooled by \" or \;.
		      (setq state (parse-partial-sexp prev (point)
						      nil nil state))))
	  (let ((here (point)))
	    (if (or (nth 4 state) (nth 7 state))
		;;
		;; We found a real comment start.
		(let ((beg (match-beginning 0)))
		  (goto-char beg)
		  (save-restriction
		    (narrow-to-region (point-min) end)
		    (condition-case nil
			(progn
			  (forward-comment 1)
			  ;; forward-comment skips all whitespace,
			  ;; so go back to the real end of the comment.
			  (skip-chars-backward " \t"))
		      (error (goto-char end))))
		  (put-text-property beg (point) 'face
				     font-lock-comment-face)
		  (setq state (parse-partial-sexp here (point) nil nil state)))
	      (if (nth 3 state)
		  ;;
		  ;; We found a real string start.
		  (let ((beg (match-beginning 0)))
		    (while (and (re-search-forward "\\s\"" end 'move)
				(nth 3 (parse-partial-sexp here (point)
							   nil nil state))))
		    (put-text-property beg (point) 'face font-lock-string-face)
		    (setq state (parse-partial-sexp here (point)
						    nil nil state))))))
	  ;;
	  ;; Make sure `prev' is non-nil after the loop
	  ;; only if it was set on the very last iteration.
	  (setq prev nil)))
      ;;
      ;; Clean up.
      (set-syntax-table old-syntax)
      (if prev (remove-text-properties prev end '(face nil)))
      (and (buffer-modified-p)
	   (not modified)
	   (set-buffer-modified-p nil)))))

;;; Additional text property functions.

;; The following three text property functions are not generally available (and
;; it's not certain that they should be) so they are inlined for speed.
;; The case for `fillin-text-property' is simple; it may or not be generally
;; useful.  (Since it is used here, it is useful in at least one place.;-)
;; However, the case for `append-text-property' and `prepend-text-property' is
;; more complicated.  Should they remove duplicate property values or not?  If
;; so, should the first or last duplicate item remain?  Or the one that was
;; added?  In our implementation, the first duplicate remains.

(defsubst font-lock-fillin-text-property (start end prop value &optional object)
  "Fill in one property of the text from START to END.
Arguments PROP and VALUE specify the property and value to put where none are
already in place.  Therefore existing property values are not overwritten.
Optional argument OBJECT is the string or buffer containing the text."
  (let ((start (text-property-any start end prop nil object)) next)
    (while start
      (setq next (next-single-property-change start prop object end))
      (put-text-property start next prop value object)
      (setq start (text-property-any next end prop nil object)))))

;; This function (from simon's unique.el) is rewritten and inlined for speed.
;(defun unique (list function)
;  "Uniquify LIST, deleting elements using FUNCTION.
;Return the list with subsequent duplicate items removed by side effects.
;FUNCTION is called with an element of LIST and a list of elements from LIST,
;and should return the list of elements with occurrences of the element removed,
;i.e., a function such as `delete' or `delq'.
;This function will work even if LIST is unsorted.  See also `uniq'."
;  (let ((list list))
;    (while list
;      (setq list (setcdr list (funcall function (car list) (cdr list))))))
;  list)

(defsubst font-lock-unique (list)
  "Uniquify LIST, deleting elements using `delq'.
Return the list with subsequent duplicate items removed by side effects."
  (let ((list list))
    (while list
      (setq list (setcdr list (delq (car list) (cdr list))))))
  list)

;; A generalisation of `facemenu-add-face' for any property, but without the
;; removal of inactive faces via `facemenu-discard-redundant-faces' and special
;; treatment of `default'.  Uses `unique' to remove duplicate property values.
(defsubst font-lock-prepend-text-property (start end prop value &optional object)
  "Prepend to one property of the text from START to END.
Arguments PROP and VALUE specify the property and value to prepend to the value
already in place.  The resulting property values are always lists, and unique.
Optional argument OBJECT is the string or buffer containing the text."
  (let ((val (if (listp value) value (list value))) next prev)
    (while (/= start end)
      (setq next (next-single-property-change start prop object end)
	    prev (get-text-property start prop object))
      (put-text-property
       start next prop
       (font-lock-unique (append val (if (listp prev) prev (list prev))))
       object)
      (setq start next))))

(defsubst font-lock-append-text-property (start end prop value &optional object)
  "Append to one property of the text from START to END.
Arguments PROP and VALUE specify the property and value to append to the value
already in place.  The resulting property values are always lists, and unique.
Optional argument OBJECT is the string or buffer containing the text."
  (let ((val (if (listp value) value (list value))) next prev)
    (while (/= start end)
      (setq next (next-single-property-change start prop object end)
	    prev (get-text-property start prop object))
      (put-text-property
       start next prop
       (font-lock-unique (append (if (listp prev) prev (list prev)) val))
       object)
      (setq start next))))

;;; Regexp fontification functions.

(defsubst font-lock-apply-highlight (highlight)
  "Apply HIGHLIGHT following a match.
HIGHLIGHT should be of the form MATCH-HIGHLIGHT, see `font-lock-keywords'."
  (let* ((match (nth 0 highlight))
	 (start (match-beginning match)) (end (match-end match))
	 (override (nth 2 highlight)))
    (cond ((not start)
	   ;; No match but we might not signal an error.
	   (or (nth 3 highlight)
	       (error "No match %d in highlight %S" match highlight)))
	  ((not override)
	   ;; Cannot override existing fontification.
	   (or (text-property-not-all start end 'face nil)
	       (put-text-property start end 'face (eval (nth 1 highlight)))))
	  ((eq override t)
	   ;; Override existing fontification.
	   (put-text-property start end 'face (eval (nth 1 highlight))))
	  ((eq override 'keep)
	   ;; Keep existing fontification.
	   (font-lock-fillin-text-property start end 'face
					   (eval (nth 1 highlight))))
	  ((eq override 'prepend)
	   ;; Prepend to existing fontification.
	   (font-lock-prepend-text-property start end 'face
					    (eval (nth 1 highlight))))
	  ((eq override 'append)
	   ;; Append to existing fontification.
	   (font-lock-append-text-property start end 'face
					   (eval (nth 1 highlight)))))))

(defsubst font-lock-fontify-anchored-keywords (keywords limit)
  "Fontify according to KEYWORDS until LIMIT.
KEYWORDS should be of the form MATCH-ANCHORED, see `font-lock-keywords'."
  (let ((matcher (nth 0 keywords)) (lowdarks (nthcdr 3 keywords)) highlights)
    (eval (nth 1 keywords))
    (save-match-data
      (while (if (stringp matcher)
		 (re-search-forward matcher limit t)
	       (funcall matcher limit))
	(setq highlights lowdarks)
	(while highlights
	  (font-lock-apply-highlight (car highlights))
	  (setq highlights (cdr highlights)))))
    (eval (nth 2 keywords))))

(defun font-lock-fontify-keywords-region (start end &optional loudly)
  "Fontify according to `font-lock-keywords' between START and END.
START should be at the beginning of a line."
  (let ((case-fold-search font-lock-keywords-case-fold-search)
	(keywords (cdr (if (eq (car-safe font-lock-keywords) t)
			   font-lock-keywords
			 (font-lock-compile-keywords))))
	(inhibit-read-only t) (buffer-undo-list t)
	(modified (buffer-modified-p))
	(old-syntax (syntax-table))
	(bufname (buffer-name)) (count 0)
	buffer-file-name buffer-file-truename)
    (unwind-protect
	(let (keyword matcher highlights)
	  ;;
	  ;; Use the fontification syntax table, if any.
	  (if font-lock-syntax-table (set-syntax-table font-lock-syntax-table))
	  ;;
	  ;; Fontify each item in `font-lock-keywords' from `start' to `end'.
	  (while keywords
	    (if loudly (message "Fontifying %s... (regexps..%s)" bufname
				(make-string (setq count (1+ count)) ?.)))
	    ;;
	    ;; Find an occurrence of `matcher' from `start' to `end'.
	    (setq keyword (car keywords) matcher (car keyword))
	    (goto-char start)
	    (while (if (stringp matcher)
                       (re-search-forward matcher end t)
                     (funcall matcher end))
	      ;; Apply each highlight to this instance of `matcher', which may
	      ;; be specific highlights or more keywords anchored to `matcher'.
	      (setq highlights (cdr keyword))
	      (while highlights
		(if (numberp (car (car highlights)))
		    (font-lock-apply-highlight (car highlights))
		  (font-lock-fontify-anchored-keywords (car highlights) end))
		(setq highlights (cdr highlights))))
	    (setq keywords (cdr keywords))))
      ;;
      ;; Clean up.
      (set-syntax-table old-syntax)
      (and (buffer-modified-p)
	   (not modified)
	   (set-buffer-modified-p nil)))))

;; Various functions.

;; Turn off other related packages if they're on.  I prefer a hook. --sm.
;; These explicit calls are easier to understand
;; because people know what they will do.
;; A hook is a mystery because it might do anything whatever. --rms.
(defun font-lock-thing-lock-cleanup ()
  (cond ((and (boundp 'fast-lock-mode) fast-lock-mode)
	 (fast-lock-mode -1))
	((and (boundp 'lazy-lock-mode) lazy-lock-mode)
	 (lazy-lock-mode -1))))

;; Do something special for these packages after fontifying.  I prefer a hook.
(defun font-lock-after-fontify-buffer ()
  (cond ((and (boundp 'fast-lock-mode) fast-lock-mode)
	 (fast-lock-after-fontify-buffer))
	((and (boundp 'lazy-lock-mode) lazy-lock-mode)
	 (lazy-lock-after-fontify-buffer))))

;; If the buffer is about to be reverted, it won't be fontified afterward.
(defun font-lock-revert-setup ()
  (setq font-lock-fontified nil))

;; If the buffer has just been reverted, normally that turns off
;; Font Lock mode.  So turn the mode back on if necessary.
(defalias 'font-lock-revert-cleanup 'turn-on-font-lock)

(defun font-lock-compile-keywords (&optional keywords)
  ;; Compile `font-lock-keywords' into the form (t KEYWORD ...) where KEYWORD
  ;; is the (MATCHER HIGHLIGHT ...) shown in the variable's doc string.
  (let ((keywords (or keywords font-lock-keywords)))
    (setq font-lock-keywords 
     (if (eq (car-safe keywords) t)
	 keywords
       (cons t
	(mapcar
	 (function (lambda (item)
	    (cond ((nlistp item)
		   (list item '(0 font-lock-keyword-face)))
		  ((numberp (cdr item))
		   (list (car item) (list (cdr item) 'font-lock-keyword-face)))
		  ((symbolp (cdr item))
		   (list (car item) (list 0 (cdr item))))
		  ((nlistp (nth 1 item))
		   (list (car item) (cdr item)))
		  (t
		   item))))
	 keywords))))))

(defun font-lock-choose-keywords (keywords level)
  ;; Return LEVELth element of KEYWORDS.  A LEVEL of nil is equal to a
  ;; LEVEL of 0, a LEVEL of t is equal to (1- (length KEYWORDS)).
  (let ((level (if (not (consp level))
		   level
		 (cdr (or (assq major-mode level) (assq t level))))))
    (cond ((symbolp keywords)
	   keywords)
	  ((numberp level)
	   (or (nth level keywords) (car (reverse keywords))))
	  ((eq level t)
	   (car (reverse keywords)))
	  (t
	   (car keywords)))))

(defun font-lock-set-defaults ()
  "Set fontification defaults appropriately for this mode.
Sets `font-lock-keywords', `font-lock-keywords-only', `font-lock-syntax-table',
`font-lock-beginning-of-syntax-function' and
`font-lock-keywords-case-fold-search' using `font-lock-defaults' (or, if nil,
using `font-lock-defaults-alist') and `font-lock-maximum-decoration'."
  ;; Set face defaults.
  (font-lock-make-faces)
  ;; Set fontification defaults.
  (or font-lock-keywords
      (let* ((defaults (or font-lock-defaults
			   (cdr (assq major-mode font-lock-defaults-alist))))
	     (keywords (font-lock-choose-keywords
			(nth 0 defaults) font-lock-maximum-decoration)))
	;; Keywords?
	(setq font-lock-keywords (if (fboundp keywords)
				     (funcall keywords)
				   (eval keywords)))
	;; Syntactic?
	(if (nth 1 defaults)
	    (set (make-local-variable 'font-lock-keywords-only) t))
	;; Case fold?
	(if (nth 2 defaults)
	    (set (make-local-variable 'font-lock-keywords-case-fold-search) t))
	;; Syntax table?
	(if (nth 3 defaults)
	    (let ((slist (nth 3 defaults)))
	      (set (make-local-variable 'font-lock-syntax-table)
		   (copy-syntax-table (syntax-table)))
	      (while slist
		(modify-syntax-entry (car (car slist)) (cdr (car slist))
				     font-lock-syntax-table)
		(setq slist (cdr slist)))))
	;; Syntax function?
	(if (nth 4 defaults)
	    (set (make-local-variable 'font-lock-beginning-of-syntax-function)
		 (nth 4 defaults))))))

;; Colour etc. support.

(defvar font-lock-display-type nil
  "A symbol indicating the display Emacs is running under.
The symbol should be one of `color', `grayscale' or `mono'.
If Emacs guesses this display attribute wrongly, either set this variable in
your `~/.emacs' or set the resource `Emacs.displayType' in your `~/.Xdefaults'.
See also `font-lock-background-mode' and `font-lock-face-attributes'.")

(defvar font-lock-background-mode nil
  "A symbol indicating the Emacs background brightness.
The symbol should be one of `light' or `dark'.
If Emacs guesses this frame attribute wrongly, either set this variable in
your `~/.emacs' or set the resource `Emacs.backgroundMode' in your
`~/.Xdefaults'.
See also `font-lock-display-type' and `font-lock-face-attributes'.")

(defvar font-lock-face-attributes nil
  "A list of default attributes to use for face attributes.
Each element of the list should be of the form

 (FACE FOREGROUND BACKGROUND BOLD-P ITALIC-P UNDERLINE-P)

where FACE should be one of the face symbols `font-lock-comment-face',
`font-lock-string-face', `font-lock-keyword-face', `font-lock-type-face',
`font-lock-function-name-face', `font-lock-variable-name-face', and
`font-lock-reference-face'.  A form for each of these face symbols should be
provided in the list, but other face symbols and attributes may be given and
used in highlighting.  See `font-lock-keywords'.

Subsequent element items should be the attributes for the corresponding
Font Lock mode faces.  Attributes FOREGROUND and BACKGROUND should be strings
\(default if nil), while BOLD-P, ITALIC-P, and UNDERLINE-P should specify the
corresponding face attributes (yes if non-nil).

Emacs uses default attributes based on display type and background brightness.
See variables `font-lock-display-type' and `font-lock-background-mode'.

Resources can be used to over-ride these face attributes.  For example, the
resource `Emacs.font-lock-comment-face.attributeUnderline' can be used to
specify the UNDERLINE-P attribute for face `font-lock-comment-face'.")

(defun font-lock-make-faces (&optional override)
  "Make faces from `font-lock-face-attributes'.
A default list is used if this is nil.
If optional OVERRIDE is non-nil, faces that already exist are reset.
See `font-lock-make-face' and `list-faces-display'."
  ;; We don't need to `setq' any of these variables, but the user can see what
  ;; is being used if we do.
  (if (null font-lock-display-type)
      (setq font-lock-display-type
	    (let ((display-resource (x-get-resource ".displayType"
						    "DisplayType")))
	      (cond (display-resource (intern (downcase display-resource)))
		    ((x-display-color-p) 'color)
		    ((x-display-grayscale-p) 'grayscale)
		    (t 'mono)))))
  (if (null font-lock-background-mode)
      (setq font-lock-background-mode
	    (let ((bg-resource (x-get-resource ".backgroundMode"
					       "BackgroundMode"))
		  (params (frame-parameters)))
	      (cond (bg-resource (intern (downcase bg-resource)))
		    ((< (apply '+ (x-color-values
				   (cdr (assq 'background-color params))))
			(/ (apply '+ (x-color-values "white")) 3))
		     'dark)
		    (t 'light)))))
  (if (null font-lock-face-attributes)
      (setq font-lock-face-attributes
	    (let ((light-bg (eq font-lock-background-mode 'light)))
	      (cond ((memq font-lock-display-type '(mono monochrome))
		     ;; Emacs 19.25's font-lock defaults:
		     ;;'((font-lock-comment-face nil nil nil t nil)
		     ;;  (font-lock-string-face nil nil nil nil t)
		     ;;  (font-lock-keyword-face nil nil t nil nil)
		     ;;  (font-lock-function-name-face nil nil t t nil)
		     ;;  (font-lock-type-face nil nil nil t nil))
		     (list '(font-lock-comment-face nil nil t t nil)
			   '(font-lock-string-face nil nil nil t nil)
			   '(font-lock-keyword-face nil nil t nil nil)
			   (list
			    'font-lock-function-name-face
			    (cdr (assq 'background-color (frame-parameters)))
			    (cdr (assq 'foreground-color (frame-parameters)))
			    t nil nil)
			   '(font-lock-variable-name-face nil nil t t nil)
			   '(font-lock-type-face nil nil t nil t)
			   '(font-lock-reference-face nil nil t nil t)))
		    ((memq font-lock-display-type '(grayscale greyscale
						    grayshade greyshade))
		     (list
		      (list 'font-lock-comment-face
			    nil (if light-bg "Gray80" "DimGray") t t nil)
		      (list 'font-lock-string-face
			    nil (if light-bg "Gray50" "LightGray") nil t nil)
		      (list 'font-lock-keyword-face
			    nil (if light-bg "Gray90" "DimGray") t nil nil)
		      (list 'font-lock-function-name-face
			    (cdr (assq 'background-color (frame-parameters)))
			    (cdr (assq 'foreground-color (frame-parameters)))
			    t nil nil)
		      (list 'font-lock-variable-name-face
			    nil (if light-bg "Gray90" "DimGray") t t nil)
		      (list 'font-lock-type-face
			    nil (if light-bg "Gray80" "DimGray") t nil t)
		      (list 'font-lock-reference-face
			    nil (if light-bg "LightGray" "Gray50") t nil t)))
		    (light-bg		; light colour background
		     '((font-lock-comment-face "Firebrick")
		       (font-lock-string-face "RosyBrown")
		       (font-lock-keyword-face "Purple")
		       (font-lock-function-name-face "Blue")
		       (font-lock-variable-name-face "DarkGoldenrod")
		       (font-lock-type-face "DarkOliveGreen")
		       (font-lock-reference-face "CadetBlue")))
		    (t			; dark colour background
		     '((font-lock-comment-face "OrangeRed")
		       (font-lock-string-face "LightSalmon")
		       (font-lock-keyword-face "LightSteelBlue")
		       (font-lock-function-name-face "LightSkyBlue")
		       (font-lock-variable-name-face "LightGoldenrod")
		       (font-lock-type-face "PaleGreen")
		       (font-lock-reference-face "Aquamarine")))))))
  ;; Now make the faces if we have to.
  (mapcar (function
	   (lambda (face-attributes)
	     (let ((face (nth 0 face-attributes)))
	       (cond (override
		      ;; We can stomp all over it anyway.  Get outta my face!
		      (font-lock-make-face face-attributes))
		     ((and (boundp face) (facep (symbol-value face)))
		      ;; The variable exists and is already bound to a face.
		      nil)
		     ((facep face)
		      ;; We already have a face so we bind the variable to it.
		      (set face face))
		     (t
		      ;; No variable or no face.
		      (font-lock-make-face face-attributes))))))
	  font-lock-face-attributes))

(defun font-lock-make-face (face-attributes)
  "Make a face from FACE-ATTRIBUTES.
FACE-ATTRIBUTES should be like an element `font-lock-face-attributes', so that
the face name is the first item in the list.  A variable with the same name as
the face is also set; its value is the face name."
  (let* ((face (nth 0 face-attributes))
	 (face-name (symbol-name face))
	 (set-p (function (lambda (face-name resource)
		 (x-get-resource (concat face-name ".attribute" resource)
				 (concat "Face.Attribute" resource)))))
	 (on-p (function (lambda (face-name resource)
		(let ((set (funcall set-p face-name resource)))
		  (and set (member (downcase set) '("on" "true"))))))))
    (make-face face)
    ;; Set attributes not set from X resources (and therefore `make-face').
    (or (funcall set-p face-name "Foreground")
	(condition-case nil
	    (set-face-foreground face (nth 1 face-attributes))
	  (error nil)))
    (or (funcall set-p face-name "Background")
	(condition-case nil
	    (set-face-background face (nth 2 face-attributes))
	  (error nil)))
    (if (funcall set-p face-name "Bold")
	(and (funcall on-p face-name "Bold") (make-face-bold face nil t))
      (and (nth 3 face-attributes) (make-face-bold face nil t)))
    (if (funcall set-p face-name "Italic")
	(and (funcall on-p face-name "Italic") (make-face-italic face nil t))
      (and (nth 4 face-attributes) (make-face-italic face nil t)))
    (or (funcall set-p face-name "Underline")
	(set-face-underline-p face (nth 5 face-attributes)))
    (set face face)))

;;; Various regexp information shared by several modes.
;;; Information specific to a single mode should go in its load library.

(defconst lisp-font-lock-keywords-1
  (list
   ;; Anything not a variable or type declaration is fontified as a function.
   ;; It would be cleaner to allow preceding whitespace, but it would also be
   ;; about five times slower.
   (list (concat "^(\\(def\\("
		 ;; Variable declarations.
		 "\\(const\\(\\|ant\\)\\|ine-key\\(\\|-after\\)\\|var\\)\\|"
		 ;; Structure declarations.
		 "\\(class\\|struct\\|type\\)\\|"
		 ;; Everything else is a function declaration.
		 "\\([^ \t\n\(\)]+\\)"
		 "\\)\\)\\>"
		 ;; Any whitespace and declared object.
		 "[ \t'\(]*"
		 "\\([^ \t\n\)]+\\)?")
	 '(1 font-lock-keyword-face)
	 '(8 (cond ((match-beginning 3) font-lock-variable-name-face)
		   ((match-beginning 6) font-lock-type-face)
		   (t font-lock-function-name-face))
	     nil t))
   )
 "Subdued level highlighting Lisp modes.")

(defconst lisp-font-lock-keywords-2
  (append lisp-font-lock-keywords-1
   (list
    ;;
    ;; Control structures.  ELisp and CLisp combined.
;      (make-regexp
;       '("cond" "if" "while" "let\\*?" "prog[nv12*]?" "catch" "throw"
;	 "save-restriction" "save-excursion" "save-window-excursion"
;	 "save-selected-window" "save-match-data" "unwind-protect"
;	 "condition-case" "track-mouse"
;	 "eval-after-load" "eval-and-compile" "eval-when-compile"
;	 "when" "unless" "do" "flet" "labels" "return" "return-from"))
    (cons
     (concat
      "(\\("
      "\\(c\\(atch\\|ond\\(\\|ition-case\\)\\)\\|do\\|"
      "eval-\\(a\\(fter-load\\|nd-compile\\)\\|when-compile\\)\\|flet\\|"
      "if\\|l\\(abels\\|et\\*?\\)\\|prog[nv12*]?\\|return\\(\\|-from\\)\\|"
      "save-\\(excursion\\|match-data\\|restriction\\|selected-window\\|"
      "window-excursion\\)\\|t\\(hrow\\|rack-mouse\\)\\|"
      "un\\(less\\|wind-protect\\)\\|wh\\(en\\|ile\\)\\)"
      "\\)\\>") 1)
    ;;
    ;; Words inside \\[] tend to be for `substitute-command-keys'.
    '("\\\\\\\\\\[\\(\\sw+\\)]" 1 font-lock-reference-face prepend)
    ;;
    ;; Words inside `' tend to be symbol names.
    '("`\\(\\sw\\sw+\\)'" 1 font-lock-reference-face prepend)
    ;;
    ;; CLisp `:' keywords as references.
    '("\\<:\\sw+\\>" 0 font-lock-reference-face prepend)
    ;;
    ;; ELisp and CLisp `&' keywords as types.
    '("\\<\\&\\(optional\\|rest\\|whole\\)\\>" . font-lock-type-face)
    ))
  "Gaudy level highlighting for Lisp modes.")

(defvar lisp-font-lock-keywords lisp-font-lock-keywords-1
  "Default expressions to highlight in Lisp modes.")


(defvar scheme-font-lock-keywords
  (eval-when-compile
    (list
     ;;
     ;; Declarations.  Hannes Haug <hannes.haug@student.uni-tuebingen.de> says
     ;; this works for SOS, STklos, SCOOPS, Meroon and Tiny CLOS.
     (list (concat "(\\(define\\("
		   ;; Function names.
		   "\\(\\|-\\(generic\\(\\|-procedure\\)\\|method\\)\\)\\|"
		   ;; Macro names, as variable names.  A bit dubious, this.
		   "\\(-syntax\\)\\|"
		   ;; Class names.
		   "\\(-class\\)"
		   "\\)\\)\\>"
		   ;; Any whitespace and declared object.
		   "[ \t]*(?"
		   "\\(\\sw+\\)?")
	   '(1 font-lock-keyword-face)
	   '(8 (cond ((match-beginning 3) font-lock-function-name-face)
		     ((match-beginning 6) font-lock-variable-name-face)
		     (t font-lock-type-face))
	       nil t))
     ;;
     ;; Control structures.
;(make-regexp '("begin" "call-with-current-continuation" "call/cc"
;	       "call-with-input-file" "call-with-output-file" "case" "cond"
;	       "do" "else" "for-each" "if" "lambda"
;	       "let\\*?" "let-syntax" "letrec" "letrec-syntax"
;	       ;; Hannes Haug <hannes.haug@student.uni-tuebingen.de> wants:
;	       "and" "or" "delay"
;	       ;; Stefan Monnier <stefan.monnier@epfl.ch> says don't bother:
;	       ;;"quasiquote" "quote" "unquote" "unquote-splicing"
;	       "map" "syntax" "syntax-rules"))
     (cons
      (concat "(\\("
	      "and\\|begin\\|c\\(a\\(ll\\(-with-\\(current-continuation\\|"
	      "input-file\\|output-file\\)\\|/cc\\)\\|se\\)\\|ond\\)\\|"
	      "d\\(elay\\|o\\)\\|else\\|for-each\\|if\\|"
	      "l\\(ambda\\|et\\(-syntax\\|\\*?\\|rec\\(\\|-syntax\\)\\)\\)\\|"
	      "map\\|or\\|syntax\\(\\|-rules\\)"
	      "\\)\\>") 1)
     ;;
     ;; David Fox <fox@graphics.cs.nyu.edu> for SOS/STklos class specifiers.
     '("\\<<\\sw+>\\>" . font-lock-type-face)
     ;;
     ;; Scheme `:' keywords as references.
     '("\\<:\\sw+\\>" . font-lock-reference-face)
     ))
"Default expressions to highlight in Scheme modes.")


(defconst c-font-lock-keywords-1 nil
  "Subdued level highlighting for C modes.")

(defconst c-font-lock-keywords-2 nil
  "Medium level highlighting for C modes.")

(defconst c-font-lock-keywords-3 nil
  "Gaudy level highlighting for C modes.")

(defconst c++-font-lock-keywords-1 nil
  "Subdued level highlighting for C++ modes.")

(defconst c++-font-lock-keywords-2 nil
  "Medium level highlighting for C++ modes.")

(defconst c++-font-lock-keywords-3 nil
  "Gaudy level highlighting for C++ modes.")

(defun font-lock-match-c++-style-declaration-item-and-skip-to-next (limit)
  ;; Match, and move over, any declaration/definition item after point.
  ;; The expect syntax of an item is "word" or "word::word", possibly ending
  ;; with optional whitespace and a "(".  Everything following the item (but
  ;; belonging to it) is expected to by skip-able by `forward-sexp', and items
  ;; are expected to be separated with a "," or ";".
  (if (looking-at "[ \t*&]*\\(\\sw+\\)\\(::\\(\\sw+\\)\\)?[ \t]*\\((\\)?")
      (save-match-data
	(condition-case nil
	    (save-restriction
	      ;; Restrict ourselves to the end of the line.
	      (end-of-line)
	      (narrow-to-region (point-min) (min limit (point)))
	      (goto-char (match-end 1))
	      ;; Move over any item value, etc., to the next item.
	      (while (not (looking-at "[ \t]*\\([,;]\\|$\\)"))
		(goto-char (or (scan-sexps (point) 1) (point-max))))
	      (goto-char (match-end 0)))
	  (error t)))))

(let ((c-keywords
;      ("break" "continue" "do" "else" "for" "if" "return" "switch" "while")
       "break\\|continue\\|do\\|else\\|for\\|if\\|return\\|switch\\|while")
      (c-type-types
;      ("auto" "extern" "register" "static" "typedef" "struct" "union" "enum"
;	"signed" "unsigned" "short" "long" "int" "char" "float" "double"
;	"void" "volatile" "const")
       (concat "auto\\|c\\(har\\|onst\\)\\|double\\|e\\(num\\|xtern\\)\\|"
	       "float\\|int\\|long\\|register\\|"
	       "s\\(hort\\|igned\\|t\\(atic\\|ruct\\)\\)\\|typedef\\|"
	       "un\\(ion\\|signed\\)\\|vo\\(id\\|latile\\)"))	; 6 ()s deep.
      (c++-keywords
;      ("break" "continue" "do" "else" "for" "if" "return" "switch" "while"
;	"asm" "catch" "delete" "new" "operator" "sizeof" "this" "throw" "try"
;       "protected" "private" "public")
       (concat "asm\\|break\\|c\\(atch\\|ontinue\\)\\|d\\(elete\\|o\\)\\|"
	       "else\\|for\\|if\\|new\\|"
	       "p\\(r\\(ivate\\|otected\\)\\|ublic\\)\\|return\\|"
	       "s\\(izeof\\|witch\\)\\|t\\(h\\(is\\|row\\)\\|ry\\)\\|while"))
      (c++-type-types
;      ("auto" "extern" "register" "static" "typedef" "struct" "union" "enum"
;	"signed" "unsigned" "short" "long" "int" "char" "float" "double"
;	"void" "volatile" "const" "class" "inline" "friend" "bool"
;	"virtual" "complex" "template")
       (concat "auto\\|bool\\|c\\(har\\|lass\\|o\\(mplex\\|nst\\)\\)\\|"
	       "double\\|e\\(num\\|xtern\\)\\|f\\(loat\\|riend\\)\\|"
	       "in\\(line\\|t\\)\\|long\\|register\\|"
	       "s\\(hort\\|igned\\|t\\(atic\\|ruct\\)\\)\\|"
	       "t\\(emplate\\|ypedef\\)\\|un\\(ion\\|signed\\)\\|"
	       "v\\(irtual\\|o\\(id\\|latile\\)\\)"))		; 11 ()s deep.
      )
 (setq c-font-lock-keywords-1
  (list
   ;;
   ;; These are all anchored at the beginning of line for speed.
   ;;
   ;; Fontify function name definitions (GNU style; without type on line).
   (list (concat "^\\(\\sw+\\)[ \t]*(") 1 'font-lock-function-name-face)
   ;;
   ;; Fontify filenames in #include <...> preprocessor directives as strings.
   '("^#[ \t]*include[ \t]+\\(<[^>\"\n]+>\\)" 1 font-lock-string-face)
   ;;
   ;; Fontify function macro names.
   '("^#[ \t]*define[ \t]+\\(\\(\\sw+\\)(\\)" 2 font-lock-function-name-face)
   ;;
   ;; Fontify symbol names in #if ... defined preprocessor directives.
   '("^#[ \t]*if\\>"
     ("\\<\\(defined\\)\\>[ \t]*(?\\(\\sw+\\)?" nil nil
      (1 font-lock-reference-face) (2 font-lock-variable-name-face nil t)))
   ;;
   ;; Fontify otherwise as symbol names, and the preprocessor directive names.
   '("^\\(#[ \t]*[a-z]+\\)\\>[ \t]*\\(\\sw+\\)?"
     (1 font-lock-reference-face) (2 font-lock-variable-name-face nil t))
   ))

 (setq c-font-lock-keywords-2
  (append c-font-lock-keywords-1
   (list
    ;;
    ;; Simple regexps for speed.
    ;;
    ;; Fontify all type specifiers.
    (cons (concat "\\<\\(" c-type-types "\\)\\>") 'font-lock-type-face)
    ;;
    ;; Fontify all builtin keywords (except case, default and goto; see below).
    (cons (concat "\\<\\(" c-keywords "\\)\\>") 'font-lock-keyword-face)
    ;;
    ;; Fontify case/goto keywords and targets, and case default/goto tags.
    '("\\<\\(case\\|goto\\)\\>[ \t]*\\([^ \t\n:;]+\\)?"
      (1 font-lock-keyword-face) (2 font-lock-reference-face nil t))
    '("^[ \t]*\\(\\sw+\\)[ \t]*:" 1 font-lock-reference-face)
    )))

 (setq c-font-lock-keywords-3
  (append c-font-lock-keywords-2
   ;;
   ;; More complicated regexps for more complete highlighting for types.
   ;; We still have to fontify type specifiers individually, as C is so hairy.
   (list
    ;;
    ;; Fontify all storage classes and type specifiers, plus their items.
    (list (concat "\\<\\(" c-type-types "\\)\\>"
		  "\\([ \t*&]+\\sw+\\>\\)*")
	  ;; Fontify each declaration item.
	  '(font-lock-match-c++-style-declaration-item-and-skip-to-next
	    ;; Start with point after all type specifiers.
	    (goto-char (or (match-beginning 8) (match-end 1)))
	    ;; Finish with point after first type specifier.
	    (goto-char (match-end 1))
	    ;; Fontify as a variable or function name.
	    (1 (if (match-beginning 4)
		   font-lock-function-name-face
		 font-lock-variable-name-face))))
    ;;
    ;; Fontify structures, or typedef names, plus their items.
    '("\\(}\\)[ \t*]*\\sw"
      (font-lock-match-c++-style-declaration-item-and-skip-to-next
       (goto-char (match-end 1)) nil
       (1 (if (match-beginning 4)
	      font-lock-function-name-face
	    font-lock-variable-name-face))))
    ;;
    ;; Fontify anything at beginning of line as a declaration or definition.
    '("^\\(\\sw+\\)\\>\\([ \t*]+\\sw+\\>\\)*"
      (1 font-lock-type-face)
      (font-lock-match-c++-style-declaration-item-and-skip-to-next
       (goto-char (or (match-beginning 2) (match-end 1))) nil
       (1 (if (match-beginning 4)
	      font-lock-function-name-face
	    font-lock-variable-name-face))))
    )))

 (setq c++-font-lock-keywords-1
  (append
   ;;
   ;; The list `c-font-lock-keywords-1' less that for function names.
   (cdr c-font-lock-keywords-1)
   ;;
   ;; Fontify function name definitions, possibly incorporating class name.
   (list
    '("^\\(\\sw+\\)\\(::\\(\\sw+\\)\\)?[ \t]*("
      (1 (if (match-beginning 2)
	     font-lock-type-face
	   font-lock-function-name-face))
      (3 (if (match-beginning 2) font-lock-function-name-face) nil t))
    )))

 (setq c++-font-lock-keywords-2
  (append c++-font-lock-keywords-1
   (list
    ;;
    ;; The list `c-font-lock-keywords-2' for C++ plus operator overloading.
    (cons (concat "\\<\\(" c++-type-types "\\)\\>") 'font-lock-type-face)
    ;;
    ;; Fontify operator function name overloading.
    '("\\<\\(operator\\)\\>[ \t]*\\([][)(><!=+-][][)(><!=+-]?\\)?"
      (1 font-lock-keyword-face) (2 font-lock-function-name-face nil t))
    ;;
    ;; Fontify case/goto keywords and targets, and case default/goto tags.
    '("\\<\\(case\\|goto\\)\\>[ \t]*\\([^ \t\n:;]+\\)?"
      (1 font-lock-keyword-face) (2 font-lock-reference-face nil t))
    '("^[ \t]*\\(\\sw+\\)[ \t]*:[^:]" 1 font-lock-reference-face)
    ;;
    ;; Fontify other builtin keywords.
    (cons (concat "\\<\\(" c++-keywords "\\)\\>") 'font-lock-keyword-face)
    )))

 (setq c++-font-lock-keywords-3
  (append c++-font-lock-keywords-2
   ;;
   ;; More complicated regexps for more complete highlighting for types.
   (list
    ;;
    ;; Fontify all storage classes and type specifiers, plus their items.
    (list (concat "\\<\\(" c++-type-types "\\)\\>"
		  "\\([ \t*&]+\\sw+\\>\\)*")
	  ;; Fontify each declaration item.
	  '(font-lock-match-c++-style-declaration-item-and-skip-to-next
	    ;; Start with point after all type specifiers.
	    (goto-char (or (match-beginning 13) (match-end 1)))
	    ;; Finish with point after first type specifier.
	    (goto-char (match-end 1))
	    ;; Fontify as a variable or function name.
	    (1 (cond ((match-beginning 2) font-lock-type-face)
		     ((match-beginning 4) font-lock-function-name-face)
		     (t font-lock-variable-name-face)))
	    (3 (if (match-beginning 4)
		   font-lock-function-name-face
		 font-lock-variable-name-face) nil t)))
    ;;
    ;; Fontify structures, or typedef names, plus their items.
    '("\\(}\\)[ \t*]*\\sw"
      (font-lock-match-c++-style-declaration-item-and-skip-to-next
       (goto-char (match-end 1)) nil
       (1 (if (match-beginning 4)
	      font-lock-function-name-face
	    font-lock-variable-name-face))))
    ;;
    ;; Fontify anything at beginning of line as a declaration or definition.
    '("^\\(\\sw+\\)\\>\\([ \t*]+\\sw+\\>\\)*"
      (1 font-lock-type-face)
      (font-lock-match-c++-style-declaration-item-and-skip-to-next
       (goto-char (or (match-beginning 2) (match-end 1))) nil
       (1 (cond ((match-beginning 2) font-lock-type-face)
		((match-beginning 4) font-lock-function-name-face)
		(t font-lock-variable-name-face)))
       (3 (if (match-beginning 4)
	      font-lock-function-name-face
	    font-lock-variable-name-face) nil t)))
    )))
 )

(defvar c-font-lock-keywords c-font-lock-keywords-1
  "Default expressions to highlight in C mode.")

(defvar c++-font-lock-keywords c++-font-lock-keywords-1
  "Default expressions to highlight in C++ mode.")


(defvar tex-font-lock-keywords
;  ;; Regexps updated with help from Ulrik Dickow <dickow@nbi.dk>.
;  '(("\\\\\\(begin\\|end\\|newcommand\\){\\([a-zA-Z0-9\\*]+\\)}"
;     2 font-lock-function-name-face)
;    ("\\\\\\(cite\\|label\\|pageref\\|ref\\){\\([^} \t\n]+\\)}"
;     2 font-lock-reference-face)
;    ;; It seems a bit dubious to use `bold' and `italic' faces since we might
;    ;; not be able to display those fonts.
;    ("{\\\\bf\\([^}]+\\)}" 1 'bold keep)
;    ("{\\\\\\(em\\|it\\|sl\\)\\([^}]+\\)}" 2 'italic keep)
;    ("\\\\\\([a-zA-Z@]+\\|.\\)" . font-lock-keyword-face)
;    ("^[ \t\n]*\\\\def[\\\\@]\\(\\w+\\)" 1 font-lock-function-name-face keep))
  ;; Rewritten and extended for LaTeX2e by Ulrik Dickow <dickow@nbi.dk>.
  '(("\\\\\\(begin\\|end\\|newcommand\\){\\([a-zA-Z0-9\\*]+\\)}"
     2 font-lock-function-name-face)
    ("\\\\\\(cite\\|label\\|pageref\\|ref\\){\\([^} \t\n]+\\)}"
     2 font-lock-reference-face)
    ("^[ \t]*\\\\def\\\\\\(\\(\\w\\|@\\)+\\)" 1 font-lock-function-name-face)
    "\\\\\\([a-zA-Z@]+\\|.\\)"
    ;; It seems a bit dubious to use `bold' and `italic' faces since we might
    ;; not be able to display those fonts.
    ;; LaTeX2e: \emph{This is emphasized}.
    ("\\\\emph{\\([^}]+\\)}" 1 'italic keep)
    ;; LaTeX2e: \textbf{This is bold}, \textit{...}, \textsl{...}
    ("\\\\text\\(\\(bf\\)\\|it\\|sl\\){\\([^}]+\\)}"
     3 (if (match-beginning 2) 'bold 'italic) keep)
    ;; Old-style bf/em/it/sl. Stop at `\\' and un-escaped `&', for good tables.
    ("\\\\\\(\\(bf\\)\\|em\\|it\\|sl\\)\\>\\(\\([^}&\\]\\|\\\\[^\\]\\)+\\)"
     3 (if (match-beginning 2) 'bold 'italic) keep))
  "Default expressions to highlight in TeX modes.")

;; Install ourselves:

(or (assq 'font-lock-mode minor-mode-alist)
    (setq minor-mode-alist (cons '(font-lock-mode " Font") minor-mode-alist)))

;; Provide ourselves:

(provide 'font-lock)

;;; font-lock.el ends here
