;;; simula.el --- SIMULA 87 code editing commands for Emacs

;; Copyright (C) 1992 Free Software Foundation, Inc.

;; Author: Hans Henrik Eriksen <hhe@ifi.uio.no>
;; Maintainer: simula-mode@ifi.uio.no
;; Version: 0.99
;; Adapted-By: ESR
;; Keywords: languages

;; This file is part of GNU Emacs.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 1, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:

;; A major mode for editing the Simula language.  It knows about Simula
;; syntax and standard indentation commands.  It also provides convenient
;; abbrevs for Simula keywords.
;;
;; Hans Henrik Eriksen (the author) may be reached at:
;;         Institutt for informatikk,
;;         Universitetet i Oslo

;;; Code:

(provide 'simula-mode)

(defconst simula-tab-always-indent nil
  "*Non-nil means TAB in SIMULA mode should always reindent the current line,
regardless of where in the line point is when the TAB command is used.")

(defconst simula-indent-level 3
  "*Indentation of SIMULA statements with respect to containing block.")

(defconst simula-substatement-offset 3
  "*Extra indentation after DO, THEN, ELSE, WHEN and OTHERWISE.")

(defconst simula-continued-statement-offset 3
  "*Extra indentation for lines not starting a statement or substatement.
If value is a list, each line in a multipleline continued statement
will have the car of the list extra indentation with respect to
the previous line of the statement.")

(defconst simula-label-offset -4711
  "*Offset of SIMULA label lines relative to usual indentation")

(defconst simula-if-indent '(0 . 0)
  "*Extra indentation of THEN and ELSE with respect to the starting IF.
Value is a cons cell, the car is extra THEN indentation and the cdr
extra ELSE indentation. IF after ELSE is indented as the starting IF.")

(defconst simula-inspect-indent '(0 . 0)
  "*Extra indentation of WHEN and OTHERWISE with respect to the
corresponding INSPECT. Value is a cons cell, the car is
extra WHEN indentation and the cdr extra OTHERWISE indentation.")

(defconst simula-electric-indent nil
  "*If this variable is non-nil, the simula-indent-line function
will check the previous line to see if it has to be reindented.")

(defconst simula-abbrev-keyword 'upcase
  "*Determine how SIMULA keywords will be expanded. Value is one of
the symbols upcase, downcase, capitalize, (as in) abbrev-table or
nil if they should not be changed.")

(defconst simula-abbrev-stdproc 'abbrev-table
  "*Determine how standard SIMULA procedure and class names will be
expanded. Value is one of the symbols upcase, downcase, capitalize,
(as in) abbrev-table or nil if they should not be changed.")

(defvar simula-abbrev-file nil
  "*File with abbrev definitions that are merged together with
the standard abbrev definitions.  Please note that the standard
definitions are required for simula-mode to function correctly.")

(defvar simula-mode-syntax-table nil
  "Syntax table in simula-mode buffers.")

(if simula-mode-syntax-table
    ()
  (setq simula-mode-syntax-table  (standard-syntax-table))
  (modify-syntax-entry ?!  "<"    simula-mode-syntax-table)
  (modify-syntax-entry ?$  "."    simula-mode-syntax-table)
  (modify-syntax-entry ?%  "."    simula-mode-syntax-table)
  (modify-syntax-entry ?'  "\""   simula-mode-syntax-table)
  (modify-syntax-entry ?\( "()"   simula-mode-syntax-table)
  (modify-syntax-entry ?\) ")("   simula-mode-syntax-table)
  (modify-syntax-entry ?\; ">"    simula-mode-syntax-table)
  (modify-syntax-entry ?\[ "."    simula-mode-syntax-table)
  (modify-syntax-entry ?\\ "."    simula-mode-syntax-table)
  (modify-syntax-entry ?\] "."    simula-mode-syntax-table)
  (modify-syntax-entry ?_  "w"    simula-mode-syntax-table)
  (modify-syntax-entry ?\| "."    simula-mode-syntax-table)
  (modify-syntax-entry ?\{ "."    simula-mode-syntax-table)
  (modify-syntax-entry ?\} "."    simula-mode-syntax-table))

(defvar simula-mode-map ()
  "Keymap used in simula mode.")

(if simula-mode-map
    ()
  (setq simula-mode-map (make-sparse-keymap))
  (define-key simula-mode-map "\C-c\C-u"   'simula-backward-up-level)
  (define-key simula-mode-map "\C-c\C-p"   'simula-previous-statement)
  (define-key simula-mode-map "\C-c\C-d"   'simula-forward-down-level)
  (define-key simula-mode-map "\C-c\C-n"   'simula-next-statement)
  ;(define-key simula-mode-map "\C-c\C-g"   'simula-goto-definition)
  ;(define-key simula-mode-map "\C-c\C-h"   'simula-standard-help)
  (define-key simula-mode-map "\177"       'backward-delete-char-untabify)
  (define-key simula-mode-map ":"          'simula-electric-label)
  (define-key simula-mode-map "\t"         'simula-indent-command))

(defvar simula-mode-abbrev-table nil
  "Abbrev table in simula-mode buffers")


(defun simula-mode ()
  "Major mode for editing SIMULA code.
\\{simula-mode-map}
Variables controlling indentation style:
 simula-tab-always-indent
    Non-nil means TAB in SIMULA mode should always reindent the current line,
    regardless of where in the line point is when the TAB command is used.
 simula-indent-level
    Indentation of SIMULA statements with respect to containing block.
 simula-substatement-offset
    Extra indentation after DO, THEN, ELSE, WHEN and OTHERWISE.
 simula-continued-statement-offset 3
    Extra indentation for lines not starting a statement or substatement,
    e.g. a nested FOR-loop. If value is a list, each line in a multipple-
    line continued statement will have the car of the list extra indentation
    with respect to the previous line of the statement.
 simula-label-offset -4711
    Offset of SIMULA label lines relative to usual indentation
 simula-if-indent '(0 . 0)
    Extra indentation of THEN and ELSE with respect to the starting IF.
    Value is a cons cell, the car is extra THEN indentation and the cdr
    extra ELSE indentation. IF after ELSE is indented as the starting IF.
 simula-inspect-indent '(0 . 0)
    Extra indentation of WHEN and OTHERWISE with respect to the
    corresponding INSPECT. Value is a cons cell, the car is
    extra WHEN indentation and the cdr extra OTHERWISE indentation.
 simula-electric-indent nil
    If this variable  non-nil value, simula-indent-line
    will check the previous line to see if it has to be reindented.
 simula-abbrev-keyword 'upcase
    Determine how SIMULA keywords will be expanded. Value is one of
    the symbols upcase, downcase, capitalize, (as in) abbrev-table or
    nil if they should not be changed.
 simula-abbrev-stdproc 'abbrev-table
    Determine how standard SIMULA procedure and class names will be
    expanded. Value is one of the symbols upcase, downcase, capitalize,
    (as in) abbrev-table or nil if they should not be changed.

Turning on SIMULA mode calls the value of the variable simula-mode-hook
with no arguments, if that value is non-nil

Warning: simula-mode-hook should not read in an abbrev file without calling
the function simula-install-standard-abbrevs afterwards, preferably not
at all."
  (interactive)
  (kill-all-local-variables)
  (use-local-map simula-mode-map)
  (setq major-mode 'simula-mode)
  (setq mode-name "SIMULA")
  (make-local-variable 'comment-column)
  (setq comment-column 40)
  (make-local-variable 'end-comment-column)
  (setq end-comment-column 75)
  (set-syntax-table simula-mode-syntax-table)
  (make-local-variable 'paragraph-start)
  (setq paragraph-start "^[ \t]*$\\|\\f")
  (make-local-variable 'paragraph-separate)
  (setq paragraph-separate paragraph-start)
  (make-local-variable 'indent-line-function)
  (setq indent-line-function 'simula-indent-line)
  (make-local-variable 'require-final-newline)
  (setq require-final-newline t)
  (make-local-variable 'comment-start)
  (setq comment-start "! ")
  (make-local-variable 'comment-end)
  (setq comment-end " ;")
  (make-local-variable 'comment-start-skip)
  (setq comment-start-skip "!+ *")
  (make-local-variable 'parse-sexp-ignore-comments)
  (setq parse-sexp-ignore-comments nil)
  (make-local-variable 'comment-multi-line)
  (setq comment-multi-line t)
  (if simula-mode-abbrev-table
      ()
    (if simula-abbrev-file
	(read-abbrev-file simula-abbrev-file)
      (define-abbrev-table 'simula-mode-abbrev-table ()))
    (let (abbrevs-changed)
      (simula-install-standard-abbrevs)))
  (setq local-abbrev-table simula-mode-abbrev-table)
  (abbrev-mode 1)
  (run-hooks 'simula-mode-hook))



(defun simula-indent-line ()
  "Indent this line as SIMULA code.  If simula-electric-indent
is non-nil, indent previous line if necessary."
  (let ((origin (- (point-max) (point)))
	(indent (simula-calculate-indent))
	(case-fold-search t))
    (unwind-protect
	(progn
	  ;;
	  ;; manually expand abbrev on last line, if any
	  ;;
	  (end-of-line 0)
	  (expand-abbrev)
	  ;; now maybe we should reindent that line
	  (if simula-electric-indent
	      (progn
		(beginning-of-line)
		(skip-chars-forward " \t\f")
		(if (and
		     (looking-at
		      "\\(end\\|if\\|then\\|else\\|when\\|otherwise\\)\\>")
		     (not (simula-context)))
		    ;; yes - reindent
		    (let ((post-indent (simula-calculate-indent)))
		      (if (eq (current-indentation) post-indent)
			  ()
			(delete-horizontal-space)
			(indent-to post-indent)))))))
      (goto-char (- (point-max) origin))
      (if (eq (current-indentation) indent)
	  (back-to-indentation)
	(delete-horizontal-space)
	(indent-to indent)))))


(defun simula-indent-command (&optional whole-exp)
  "Indent current line as SIMULA code, or insert TAB character.
If simula-tab-always-indent is non-nil, always indent current line.
Otherwise, indent only if point is before any non-whitespace
character on the line.

A numeric argument, regardless of its value, means indent rigidly
all the lines of the SIMULA statement after point so that this line
becomes properly indented.
The relative indentation among the lines of the statement are preserved."
  (interactive "P")
  (let ((case-fold-search t))
    (if (or whole-exp simula-tab-always-indent
	    (save-excursion
	      (skip-chars-backward " \t\f")
	      (bolp)))
	;; reindent current line
	(let ((indent (save-excursion
			(beginning-of-line)
			(simula-calculate-indent)))
	      (current (current-indentation))
	      (origin (- (point-max) (point)))
	      (bol (save-excursion
		     (skip-chars-backward " \t\f")
		     (bolp)))
	      beg end)
	  (unwind-protect
	      (if (eq current indent)
		  (if (save-excursion
			(skip-chars-backward " \t\f")
			(bolp))
		      (back-to-indentation))
		(beginning-of-line)
		(delete-horizontal-space)
		(indent-to indent))
	    (if (not bol)
		(goto-char (- (point-max) origin))))
	  (setq origin (point))
	  (if whole-exp
	      (save-excursion
		(beginning-of-line 2)
		(setq beg (point))
		(goto-char origin)
		(simula-next-statement 1)
		(setq end (point))
		(if (and (> end beg) (not (eq indent current)))
		    (indent-code-rigidly beg end (- indent current) "%")))))
      (insert-tab))))


(defun simula-context ()
  "Returns value according to position of point inside SIMULA text:
    0    point inside COMMENT
    1    point on SIMULA-compiler directive line
    2    point inside END comment
    3    point inside string
    4    point inside character constant
  nil    otherwise."
  ;; first, find out if this is a compiler directive line
  (if (save-excursion
	(beginning-of-line)
	(eq (following-char) ?%))
      ;; YES - return 1
      1
    (save-excursion
      ;; The current line is NOT a compiler directive line.
      ;; Now, the strategy is to search backward to find a semicolon
      ;; that is NOT inside a string. The point after semicolon MUST be
      ;; outside a comment, since semicolons are comment-ending and
      ;; comments are non-recursive. We take advantage of the fact
      ;; that strings MUST end on the same line as they started, so
      ;; that we can easily decide whether we are inside a string or not.
      (let (return-value (origin (point)))
	(skip-chars-backward "^;" (point-min))
	;; found semicolon or beginning of buffer
	(let (loopvalue (saved-point origin))
	  (while (and (not (bobp))
		      (if (progn
			    (beginning-of-line)
			    ;; compiler directive line? If so, cont searching..
			    (eq (following-char) ?%))
			  t
			(while (< (point) saved-point)
			  (skip-chars-forward "^;\"'")
			  (forward-char 1)
			  (cond
			   ((eq (preceding-char) ?\;)
			    (setq saved-point (point)))
			   ((eq (preceding-char) ?\")
			    (skip-chars-forward "^\";")
			    (if (eq (following-char) ?\;)
				(setq saved-point (point) loopvalue t)
			      (forward-char 1)))
			   (t
			    (if (eq (following-char) ?')
				(forward-char 1))
			    (skip-chars-forward "^';")
			    (if (eq (following-char) ?\;)
				(setq saved-point (point) loopvalue t)
			      (forward-char 1)))))
			loopvalue))
	    (backward-char 1)
	    (skip-chars-backward "^;")
	    (setq saved-point (point) loopvalue nil)))
	;; Now we are CERTAIN that we are outside comments and strings.
	;; The job now is to search forward again towards the origin
	;; skipping directives, comments and strings correctly,
	;; so that we know what context we are in when we find the origin.
	(while (and
		(< (point) origin)
		(re-search-forward
		 "\\<end\\>\\|!\\|\"\\|'\\|^%\\|\\<comment\\>" origin 'move))
	  (cond
	   ((memq (preceding-char) '(?d ?D))
	    (setq return-value 2)
	    (while (and (memq (preceding-char) '(?d ?D)) (not return-value))
	      (while (and (re-search-forward
			   ";\\|\\<end\\>\\|\\<else\\>\\|\\<otherwise\\>\\|\\<when\\>\\|^%"
			   origin 'move)
			  (eq (preceding-char) ?%))
		(beginning-of-line 2)))
	    (if (looking-at "[ \t\n\f]*\\(;\\|\\<end\\>\\|\\<else\\>\\|\\<otherwise\\>\\|\\<when\\>\\)")
		(setq return-value nil)))
	   ((memq (preceding-char) '(?! ?t ?T))
	    ; skip comment
	    (setq return-value 0)
	    (skip-chars-forward "^%;" origin)
	    (while (and return-value (< (point) origin))
	      (if (eq (following-char) ?\;)
		  (setq return-value nil)
		(if (bolp)
		    (beginning-of-line 2)	; skip directive inside comment
		  (forward-char 1))		; or single '%'
		(skip-chars-forward "^%;" origin))))
	   ((eq (preceding-char) ?\")
	    (if (not (search-forward "\"" origin 'move))
		(setq return-value 3)))
	   ((eq (preceding-char) ?\')
	    (if (or (eq (point) origin) (eobp))
		(setq return-value 4)
	      (forward-char 1)
	      (if (not (search-forward "'" origin 'move))
		  (setq return-value 4))))
	   ;; compiler directive line - skip
	   (t (beginning-of-line 2))))
	return-value)
      )))


(defun simula-electric-label ()
  "If this is a label that starts the line, reindent the line"
  (interactive)
  (expand-abbrev)
  (insert ?:)
  (let ((origin (- (point-max) (point)))
	(case-fold-search t)
	;; don't mix a label with an assignment operator := :-
	;; therefore look at next typed character...
	(next-char (setq unread-command-events (list (read-event))))
	(com-char last-command-char))
    (unwind-protect
	;; Problem: find out if character just read is a command char
	;; that would insert something after ':' making it a label.
	;; At least \n, \r (and maybe \t) falls into this category.
	;; This is a real crock, it depends on traditional keymap
	;; bindings, that is, printing characters doing self-insert,
	;; and no other command sequence inserting '-' or '='.
	;; simula-electric-label can be easily fooled...
	(if (and (not (memq next-char '(?= ?-)))
		 (or (memq next-char '(?\n ?\r))
		     (and (eq next-char ?\t)
			  simula-tab-always-indent)
		     (not (memq (following-char) '(?= ?-))))
		 (not (simula-context))
		 ;; label?
		 (progn
		   (backward-char 1)
		   (skip-chars-backward " \t\f")
		   (skip-chars-backward "a-zA-Z0-9_")
		   (if (looking-at "virtual\\>")
		       nil
		     (skip-chars-backward " \t\f")
		     (bolp))))
	    (let ((amount (simula-calculate-indent)))
	      (delete-horizontal-space)
	      (indent-to amount)))
      (goto-char (- (point-max) origin)))))
	

(defun simula-backward-up-level (count)
  "Move backward up COUNT block levels.
If COUNT is negative, move forward up block level instead"
  (interactive "p")
  (let ((origin (point))
	(case-fold-search t))
    (condition-case ()
	(if (> count 0)
	    (while (> count 0)
	      (re-search-backward "\\<begin\\>\\|\\<end\\>")
	      (if (not (simula-context))
		  (setq count (if (memq (following-char) '(?b ?B))
				  (1- count)
				(1+ count)))))
	  (while (< count 0)
	    (re-search-forward "\\<begin\\>\\|\\<end\\>")
	    (backward-word 1)
	    (if (not (simula-context))
		(setq count (if (memq (following-char) '(?e ?E))
				(1+ count)
			      (1- count))))
	    (backward-word -1)))
      ;; If block level not found, jump back to origin and signal an error
      (error (progn
	       (goto-char origin)
	       (error "No higher block level")))
      (quit (progn
	      (goto-char origin)
	      (signal 'quit nil))))))


(defun simula-forward-down-level (count)
  "Move forward down COUNT block levels.
If COUNT is negative, move backward down block level instead"
  (interactive "p")
  ;; When we search for a deeper block level, we must never
  ;; get out of the block where we started -> count >= start-count
  (let ((start-count count)
	(origin (point))
	(case-fold-search t))
    (condition-case ()
	(if (< count 0)
	    (while (< count 0)
	      (re-search-backward "\\<begin\\>\\|\\<end\\>")
	      (if (not (simula-context))
		  (setq count (if (memq (following-char) '(?e ?E))
				  (1+ count)
				(1- count))))
	      (if (< count start-count) (signal 'error nil)))
	  (while (> count 0)
	    (re-search-forward "\\<begin\\>\\|\\<end\\>")
	    (backward-word 1)
	    (if (not (simula-context))
		(setq count (if (memq (following-char) '(?b ?B))
				(1- count)
			      (1+ count))))
	    (backward-word -1)
	    ;; deeper level has to be found within starting block
	    (if (> count start-count) (signal 'error nil))))
      ;; If block level not found, jump back to origin and signal an error
      (error (progn
	       (goto-char origin)
	       (error "No containing block level")))
      (quit (progn
	      (goto-char origin)
	      (signal 'quit nil))))))

     
(defun simula-previous-statement (count)
  "Move backward COUNT statements.
If COUNT is negative, move forward instead (simula-next-statement)"
  (interactive "p")
  (if (< count 0)
      (simula-next-statement (- count))
    (let (status
	  (case-fold-search t)
	  (origin (point)))
      (condition-case ()
	  (progn
	    (simula-skip-comment-backward)
	    (if (memq (preceding-char) '(?n ?N))
		(progn
		  (backward-word 1)
		  (if (not (looking-at "\\<begin\\>"))
		      (backward-word -1)))
	      (if (eq (preceding-char) ?\;)
		  (backward-char 1)))
	    (while (and (natnump (setq count (1- count)))
			(setq status (simula-search-backward
				      ";\\|\\<begin\\>" nil 'move))))
	    (if status
		(progn
		  (if (eq (following-char) ?\;)
		      (forward-char 1)
		    (backward-word -1))))
	    (simula-skip-comment-forward))
	(error (progn (goto-char origin)
		      (error "Incomplete statement (too many ENDs)")))
	(quit (progn (goto-char origin) (signal 'quit nil)))))))


(defun simula-next-statement (count)
  "Move backward COUNT statements.
If COUNT is negative, move forward instead (simula-next-statement)"
  (interactive "p")
  (if (< count 0)
      (simula-previous-statement (- count))
    (let (status
	  (case-fold-search t)
	  (origin (point)))
      (condition-case ()
	  (progn
	    (simula-skip-comment-forward)
	    (if (looking-at "\\<end\\>") (forward-word 1))
	    (while (and (natnump (setq count (1- count)))
			(setq status (simula-search-forward
				      ";\\|\\<end\\>" (point-max) 'move))))
	    (if (and status (/= (preceding-char) ?\;))
		(progn
		  (backward-word 1)
		  (simula-skip-comment-backward))))
	(error (progn (goto-char origin)
		      (error "Incomplete statement (too few ENDs)")))
 	(quit (progn (goto-char origin) (signal 'quit nil)))))))


(defun simula-skip-comment-backward ()
  "Search towards bob to find first char that is outside a comment"
  (interactive)
  (catch 'simula-out
    (let (context)
      (while t
	(skip-chars-backward " \t\n\f")
	(if (eq (preceding-char) ?\;)
	    (save-excursion
	      (backward-char 1)
	      (setq context (simula-context)))
	  (setq context (simula-context)))
	(cond
	 ((memq context '(nil 3 4))
	  ;; check to see if we found a label
	  (if (and (eq (preceding-char) ?:)
		   (not (memq (following-char) '(?- ?=)))
		   (save-excursion
		     (skip-chars-backward ": \t\fa-zA-Z0-9_")
		     (not (looking-at "virtual\\>"))))
	      (skip-chars-backward ": \t\fa-zA-Z0-9_")
	    (throw 'simula-out nil)))
	 ((eq context 0)
	  ;; since we are inside a comment, it must start somewhere!
	  (while (and (re-search-backward "!\\|\\<comment\\>")
		      (memq (simula-context) '(0 1)))))
	 ((eq context 1)
	  (end-of-line 0)
	  (if (bobp)
	      (throw 'simula-out nil)))
	 ((eq context 2)
	  ;; an END-comment must belong to an END
	  (re-search-backward "\\<end\\>")
	  (forward-word 1)
	  (throw 'simula-out nil))
	 ;; should be impossible to get here..
	 )))))


(defun simula-skip-comment-forward ()
  "Search towards eob to find first char that is outside a comment"
  ;; this function assumes we start with point .outside a comment
  (interactive)
  (catch 'simula-out
    (while t
      (skip-chars-forward " \t\n\f")
      (cond
       ((looking-at "!\\|\\<comment\\>")
	(search-forward ";" nil 'move))
       ((and (bolp) (eq (following-char) ?%))
	(beginning-of-line 2))
       ((and (looking-at "[a-z0-9_]*[ \t\f]*:[^-=]")
	     (not (looking-at "virtual\\>")))
	(skip-chars-forward "a-zA-Z0-9_ \t\f:"))
       (t
	(throw 'simula-out t))))))


(defun simula-forward-up-level ()
  (let ((continue-loop t)
	(origin (point))
	(case-fold-search t)
	return-value
	temp)
    (while continue-loop
      (if (re-search-backward "\\<begin\\>\\|\\<end\\>" (point-min) 'move)
	  (setq temp (simula-context)
	      return-value (and (memq (preceding-char) '(?d ?D))
				(memq temp '(nil 2)))
	      continue-loop (and (not return-value)
				 (simula-forward-up-level)))
	(setq continue-loop nil)))
    (if return-value
	t
      (goto-char origin)
      nil)))


(defun simula-calculate-indent ()
  (save-excursion
    (let ((where (simula-context))
	  (origin (point))
	  (indent 0)
	  continued
	  start-line
	  temp
	  found-end
	  prev-cont)
      (cond
       ((eq where 0)
	;;
	;; Comment.
	;; If comment started on previous non-blank line, indent to the
	;; column where the comment started, else indent as that line.
	;;
	(skip-chars-backward " \t\n\f")
	(while (and (not (bolp)) (eq (simula-context) 0))
	  (re-search-backward "^\\|!\\|\\<comment\\>"))
	(skip-chars-forward " \t\n\f")
	(prog1
	    (current-column)
	  (goto-char origin)))
       ;;
       ;; Detect missing string delimiters
       ;;
       ((eq where 3)
	(error "Inside string"))
       ((eq where 4)
	(error "Inside character constant"))
       ;;
       ;; check to see if inside ()'s
       ;;
       ((setq temp (simula-inside-parens))
	temp)
       ;;
       ;; Calculate non-comment indentation
       (t
	;; first, find out if this line starts with something that needs
	;; special indentation (END/IF/THEN/ELSE/WHEN/OTHERWISE or label)
	;;
	(skip-chars-forward " \t\f")
	(cond
	 ;;
	 ;; END
	 ;;
	 ((looking-at "end\\>")
	  (setq indent (- simula-indent-level)
		found-end t))
	 ;;
	 ;; IF/THEN/ELSE
	 ;;
	 ((looking-at "if\\>\\|then\\>\\|else\\>")
	  ;; search for the *starting* IF
	  (cond
	   ((memq (following-char) '(?T ?t))
	    (setq indent (car simula-if-indent)))
	   ((memq (following-char) '(?E ?e))
	    (setq indent (cdr simula-if-indent)))
	   (t
	    (forward-word 1)
	    (setq indent 0)))
	  (simula-find-if))
	 ;;
	 ;; WHEN/OTHERWISE
	 ;;
	 ((looking-at "when\\>\\|otherwise\\>")
	  ;; search for corresponding INSPECT
	  (if (memq (following-char) '(?W ?w))
	      (setq indent (car simula-inspect-indent))
	    (setq indent (cdr simula-inspect-indent)))
	  (simula-find-inspect))
	 ;;
	 ;; label:
	 ;;
	 ((and (not (looking-at "virtual\\>"))
	       (looking-at "[a-z0-9_]*[ \t\f]*:[^-=]"))
	  (setq indent simula-label-offset)))
	;; find line with non-comment text
	(simula-skip-comment-backward)
	(if (and found-end
		 (not (eq (preceding-char) ?\;))
		 (if (memq (preceding-char) '(?N ?n))
		     (save-excursion
		       (backward-word 1)
		       (not (looking-at "begin\\>")))
		   t))
	    (progn
	      (simula-previous-statement 1)
	      (simula-skip-comment-backward)))
	(setq start-line
	      (save-excursion (beginning-of-line) (point))
	      ;; - perhaps this is a continued statement
	      continued
	      (save-excursion
		(and (not (bobp))
		     ;; (not found-end)
		     (if (eq (char-syntax (preceding-char)) ?w)
			 (progn
			   (backward-word 1)
			   (not (looking-at
				 "begin\\|then\\|else\\|when\\|otherwise\\|do"
				 )))
		       (not (memq (preceding-char) '(?: ?\;)))))))
	;;
	;; MAIN calculation loop - count BEGIN/DO etc.
	;;
	(while (not (bolp))
	  (if (re-search-backward
	       ";\\|\\<\\(begin\\|end\\|if\\|else\\|then\\|when\\|otherwise\\|do\\)\\>"
	       start-line 'move)
	      (if (simula-context)
		  ();; found something in a comment/string - ignore
		(setq temp (following-char))
		(cond
		 ((eq temp ?\;)
		  (simula-previous-statement 1))
		 ((looking-at "begin\\>")
		  (setq indent (+ indent simula-indent-level)))
		 ((looking-at "end\\>")
		  (forward-word 1)
		  (simula-previous-statement 1))
		 ((looking-at "do\\>")
		  (setq indent (+ indent simula-substatement-offset))
		  (simula-find-do-match))
		 ((looking-at "\\(if\\|then\\|else\\)\\>")
		  (if (memq temp '(?I ?i))
		      (forward-word 1)
		    (setq indent (+ indent
				    simula-substatement-offset
				    (if (memq temp '(?T ?t))
					(car simula-if-indent)
				      (cdr simula-if-indent)))))
		  (simula-find-if))
		 ((looking-at "\\<when\\>\\|\\<otherwise\\>")
		  (setq indent (+ indent
				  simula-substatement-offset
				  (if (memq temp '(?W ?w))
				      (car simula-if-indent)
				    (cdr simula-if-indent))))
		  (simula-find-inspect)))
		;; found the start of a [sub]statement
		;; add indentation for continued statement
		(if continued
		    (setq indent
			  (+ indent
			     (if (listp simula-continued-statement-offset)
				 (car simula-continued-statement-offset)
			       simula-continued-statement-offset))))
		(setq start-line
		      (save-excursion (beginning-of-line) (point))
		      continued nil))
	    ;; search failed .. point is at beginning of line
	    ;; determine if we should continue searching
	    ;; (at or before comment or label)
	    ;; temp = t means finished
	    (setq temp
		  (and (not (simula-context))			
		       (save-excursion
			 (skip-chars-forward " \t\f")
			 (or (looking-at "virtual")
			     (not
			      (looking-at
			       "!\\|comment\\>\\|[a-z0-9_]*[ \t\f]*:[^-=]")))))
		  prev-cont continued)
	    ;; if we are finished, find current line's indentation
	    (if temp
		(setq indent (+ indent (current-indentation))))
	    ;; find next line with non-comment SIMULA text
	    ;; maybe indent extra if statement continues
	    (simula-skip-comment-backward)
	    (setq continued
		  (and (not (bobp))
		       (if (eq (char-syntax (preceding-char)) ?w)
			   (save-excursion
			     (backward-word 1)
			     (not (looking-at
				   "begin\\|then\\|else\\|when\\|otherwise\\|do")))
			 (not (memq (preceding-char) '(?: ?\;))))))
	    ;; if we the state of the continued-variable
	    ;; changed, add indentation for continued statement
	    (if (or (and prev-cont (not continued))
		    (and continued
			 (listp simula-continued-statement-offset)))
		(setq indent
		      (+ indent
			 (if (listp simula-continued-statement-offset)
			     (car simula-continued-statement-offset)
			   simula-continued-statement-offset))))
	    ;; while ends if point is at beginning of line at loop test
	    (if (not temp)
		(setq start-line (save-excursion (beginning-of-line) (point)))
	      (beginning-of-line))))
        ;;
	;; return indentation
	;;
	indent)))))


(defun simula-find-if ()
  "Find starting IF of a IF-THEN[-ELSE[-IF-THEN...]] statement"
  (catch 'simula-out
    (while t
      (if (and (simula-search-backward "\\<if\\>\\|;\\|\\<begin\\>"nil t)
	       (memq (following-char) '(?I ?i)))
	  (save-excursion
	    ;;
	    ;; find out if this IF was really the start of the IF statement
	    ;;
	    (simula-skip-comment-backward)
	    (if (and (eq (char-syntax (preceding-char)) ?w)
		     (progn
		       (backward-word 1)
		       (looking-at "else\\>")))
		()
	      (throw 'simula-out t)))
	(if (not (looking-at "\\<if\\>"))
	    (error "Missing IF or misplaced BEGIN or ';' (can't find IF)")
	  ;;
	  ;; we were at the starting IF in the first place..
	  ;;
	  (throw 'simula-out t))))))


(defun simula-find-inspect ()
  "Find INSPECT matching WHEN or OTHERWISE"
  (catch 'simula-out
    (let ((level 0))
      ;;
      ;; INSPECTs can be nested, have to find the corresponding one
      ;;
      (while t
	(if (and (simula-search-backward "\\<inspect\\>\\|\\<otherwise\\>\\|;"
					  nil t)
		 (/= (following-char) ?\;))
	    (if (memq (following-char) '(?O ?o))
		(setq level (1+ level))
	      (if (zerop level)
		  (throw 'simula-out t)
		(setq level (1- level))))
	  (error "Missing INSPECT or misplaced ';' (can't find INSPECT)"))))))


(defun simula-find-do-match ()
  "Find keyword matching DO: FOR, WHILE, INSPECT or WHEN"
  (while (and (re-search-backward
	       "\\<\\(do\\|for\\|while\\|inspect\\|when\\|end\\|begin\\)\\>\\|;"
	       nil 'move)
	      (simula-context)))
  (if (and (looking-at "\\<\\(for\\|while\\|inspect\\|when\\)\\>")
	   (not (simula-context)))
      () ;; found match
    (error "No matching FOR, WHILE or INSPECT for DO, or misplaced ';'")))


(defun simula-inside-parens ()
  "Return position after '(' on line if inside parentheses, nil otherwise."
  (save-excursion
    (let ((parlevel 0))
      (catch 'simula-out
	(while t
	  (if (re-search-backward "(\\|)\\|;" nil t)
	      (if (eq (simula-context) nil)
		  ;; found something - check it out
		  (cond
		   ((eq (following-char) ?\;)
		    (if (zerop parlevel)
			(throw 'simula-out nil)
		      (error "Parenthesis mismatch or misplaced ';'")))
		   ((eq (following-char) ?\()
		    (if (zerop parlevel)
			(throw 'simula-out (1+ (current-column)))
		      (setq parlevel (1- parlevel))))
		   (t (setq parlevel (1+ parlevel))))
		);; nothing - inside comment or string
	    ;; search failed
	    (throw 'simula-out nil)))))))


(defun simula-goto-definition ()
  "Goto point of definition of variable, procedure or class."
  (interactive))


(defun simula-expand-stdproc ()
  (if (or (not simula-abbrev-stdproc) (simula-context))
      (unexpand-abbrev)
    (cond
     ((eq simula-abbrev-stdproc 'upcase) (upcase-word -1))
     ((eq simula-abbrev-stdproc 'downcase) (downcase-word -1))
     ((eq simula-abbrev-stdproc 'capitalize) (capitalize-word -1)))))


(defun simula-expand-keyword ()
  (if (or (not simula-abbrev-keyword) (simula-context))
      (unexpand-abbrev)
    (cond
     ((eq simula-abbrev-keyword 'upcase) (upcase-word -1))
     ((eq simula-abbrev-keyword 'downcase) (downcase-word -1))
     ((eq simula-abbrev-keyword 'capitalize) (capitalize-word -1)))))


(defun simula-electric-keyword ()
  "Expand SIMULA keyword. If it starts the line, reindent."
  ;; redisplay
  (let ((show-char (eq this-command 'self-insert-command)))
    ;; If the abbrev expansion results in reindentation, the user may have
    ;; to wait some time before the character he typed is displayed
    ;; (the char causing the expansion is inserted AFTER the hook function
    ;; is called). This is annoying in case of normal characters.
    ;; However, if the user pressed a key bound to newline, it is better
    ;; to have the line inserted after the begin-end match.
    (if show-char
	(progn
	  (insert-char last-command-char 1)
	  (sit-for 0)
	  (backward-char 1)))
    (if (let ((where (simula-context))
	      (case-fold-search t))
	  (if where
	      (if (and (eq where 2) (eq (char-syntax (preceding-char)) ?w))
		  (save-excursion
		    (backward-word 1)
		    (not (looking-at "end\\>"))))))
	(unexpand-abbrev)
      (cond
       ((not simula-abbrev-keyword) (unexpand-abbrev))
       ((eq simula-abbrev-keyword 'upcase) (upcase-word -1))
       ((eq simula-abbrev-keyword 'downcase) (downcase-word -1))
       ((eq simula-abbrev-keyword 'capitalize) (capitalize-word -1)))
      (let ((pos (- (point-max) (point)))
	    (case-fold-search t)
	    null)
	(condition-case null
	    (progn
	      ;; check if the expanded word is on the beginning of the line.
	      (if (and (eq (char-syntax (preceding-char)) ?w)
		       (progn
			 (backward-word 1)
			 (if (looking-at "end\\>")
			     (save-excursion
			       (simula-backward-up-level 1)
			       (if (pos-visible-in-window-p)
				   (sit-for 1)
				 (message
				  (concat "Matches "
					  (buffer-substring
					   (point)
					   (+ (point) (window-width))))))))
			 (skip-chars-backward " \t\f")
			 (bolp)))
		  (let ((indent (simula-calculate-indent)))
		    (if (eq indent (current-indentation))
			()
		      (delete-horizontal-space)
		      (indent-to indent)))
		(skip-chars-forward " \t\f"))
	      ;; check for END - blow whistles and ring bells

	      (goto-char (- (point-max) pos))
	      (if show-char
		  (delete-char 1)))
	  (quit (goto-char (- (point-max) pos))))))))


(defun simula-search-backward (string &optional limit move)
  (setq string (concat string "\\|\\<end\\>"))
  (let (level)
    (catch 'simula-out
      (while (re-search-backward string limit move)
	(if (simula-context)
	    ()
	  (if (looking-at "\\<end\\>")
              (progn
                (setq level 0)
                (while (natnump level)
                  (re-search-backward "\\<begin\\>\\|\\<end\\>")
                  (if (simula-context)
                      ()
                    (setq level (if (memq (following-char) '(?b ?B))
                                    (1- level)
                                  (1+ level))))))
            (throw 'simula-out t)))))))


(defun simula-search-forward (string &optional limit move)
  (setq string (concat string "\\|\\<begin\\>"))
  (let (level)
    (catch 'exit
      (while (re-search-forward string limit move)
	(goto-char (match-beginning 0))
	(if (simula-context)
	    (goto-char (1- (match-end 0)))
	  (if (looking-at "\\<begin\\>")
	      (progn
		(goto-char (1- (match-end 0)))
		(setq level 0)
		(while (natnump level)
		  (re-search-forward "\\<begin\\>\\|\\<end\\>")
		  (backward-word 1)
		  (if (not (simula-context))
		      (setq level (if (memq (following-char) '(?e ?E))
				      (1- level)
				    (1+ level))))
		  (backward-word -1)))
	    (goto-char (1- (match-end 0)))
	    (throw 'exit t)))))))

  
(defun simula-install-standard-abbrevs ()
  "Define Simula keywords, standard procedures and classes in
local abbrev table."
  ;; procedure and class names are as of the SIMULA 87 standard.
  (interactive)
  (mapcar (function (lambda (args)
		      (apply 'define-abbrev simula-mode-abbrev-table args)))
	  '(("abs" "Abs" simula-expand-stdproc)
	    ("accum" "Accum" simula-expand-stdproc)
	    ("activate" "ACTIVATE" simula-expand-keyword)
	    ("addepsilon" "AddEpsilon" simula-expand-stdproc)
	    ("after" "AFTER" simula-expand-keyword)
	    ("and" "AND" simula-expand-keyword)
	    ("arccos" "ArcCos" simula-expand-stdproc)
	    ("arcsin" "ArcSin" simula-expand-stdproc)
	    ("arctan" "ArcTan" simula-expand-stdproc)
	    ("arctan2" "ArcTan2" simula-expand-stdproc)
	    ("array" "ARRAY" simula-expand-keyword)
	    ("at" "AT" simula-expand-keyword)
	    ("before" "BEFORE" simula-expand-keyword)
	    ("begin" "BEGIN" simula-expand-keyword)
	    ("blanks" "Blanks" simula-expand-stdproc)
	    ("boolean" "BOOLEAN" simula-expand-keyword)
	    ("breakoutimage" "BreakOutImage" simula-expand-stdproc)
	    ("bytefile" "ByteFile" simula-expand-stdproc)
	    ("call" "Call" simula-expand-stdproc)
	    ("cancel" "Cancel" simula-expand-stdproc)
	    ("cardinal" "Cardinal" simula-expand-stdproc)
	    ("char" "Char" simula-expand-stdproc)
	    ("character" "CHARACTER" simula-expand-keyword)
	    ("checkpoint" "CheckPoint" simula-expand-stdproc)
	    ("class" "CLASS" simula-expand-keyword)
	    ("clear" "Clear" simula-expand-stdproc)
	    ("clocktime" "ClockTime" simula-expand-stdproc)
	    ("close" "Close" simula-expand-stdproc)
	    ("comment" "COMMENT" simula-expand-keyword)
	    ("constant" "Constant" simula-expand-stdproc)
	    ("copy" "Copy" simula-expand-stdproc)
	    ("cos" "Cos" simula-expand-stdproc)
	    ("cosh" "CosH" simula-expand-stdproc)
	    ("cotan" "CoTan" simula-expand-stdproc)
	    ("cputime" "CpuTime" simula-expand-stdproc)
	    ("current" "Current" simula-expand-stdproc)
	    ("datetime" "DateTime" simula-expand-stdproc)
	    ("decimalmark" "DecimalMark" simula-expand-stdproc)
	    ("delay" "DELAY" simula-expand-keyword)
	    ("deleteimage" "DeleteImage" simula-expand-stdproc)
	    ("detach" "Detach" simula-expand-stdproc)
	    ("digit" "Digit" simula-expand-stdproc)
	    ("directbytefile" "DirectByteFile" simula-expand-stdproc)
	    ("directfile" "DirectFile" simula-expand-stdproc)
	    ("discrete" "Discrete" simula-expand-stdproc)
	    ("do" "DO" simula-expand-keyword)
	    ("downcase" "Downcase" simula-expand-stdproc)
	    ("draw" "Draw" simula-expand-stdproc)
	    ("eject" "Eject" simula-expand-stdproc)
	    ("else" "ELSE" simula-electric-keyword)
	    ("empty" "Empty" simula-expand-stdproc)
	    ("end" "END" simula-electric-keyword)
	    ("endfile" "Endfile" simula-expand-stdproc)
	    ("entier" "Entier" simula-expand-stdproc)
	    ("eq" "EQ" simula-expand-keyword)
	    ("eqv" "EQV" simula-expand-keyword)
	    ("erlang" "Erlang" simula-expand-stdproc)
	    ("error" "Error" simula-expand-stdproc)
	    ("evtime" "EvTime" simula-expand-stdproc)
	    ("exp" "Exp" simula-expand-stdproc)
	    ("external" "EXTERNAL" simula-expand-keyword)
	    ("false" "FALSE" simula-expand-keyword)
	    ("field" "Field" simula-expand-stdproc)
	    ("file" "File" simula-expand-stdproc)
	    ("first" "First" simula-expand-stdproc)
	    ("follow" "Follow" simula-expand-stdproc)
	    ("for" "FOR" simula-expand-keyword)
	    ("ge" "GE" simula-expand-keyword)
	    ("getchar" "GetChar" simula-expand-stdproc)
	    ("getfrac" "GetFrac" simula-expand-stdproc)
	    ("getint" "GetInt" simula-expand-stdproc)
	    ("getreal" "GetReal" simula-expand-stdproc)
	    ("go" "GO" simula-expand-keyword)
	    ("goto" "GOTO" simula-expand-keyword)
	    ("gt" "GT" simula-expand-keyword)
	    ("head" "Head" simula-expand-stdproc)
	    ("hidden" "HIDDEN" simula-expand-keyword)
	    ("histd" "HistD" simula-expand-stdproc)
	    ("histo" "Histo" simula-expand-stdproc)
	    ("hold" "Hold" simula-expand-stdproc)
	    ("idle" "Idle" simula-expand-stdproc)
	    ("if" "IF" simula-expand-keyword)
	    ("image" "Image" simula-expand-stdproc)
	    ("imagefile" "ImageFile" simula-expand-stdproc)
	    ("imp" "IMP" simula-expand-keyword)
	    ("in" "IN" simula-expand-keyword)
	    ("inbyte" "InByte" simula-expand-stdproc)
	    ("inbytefile" "InByteFile" simula-expand-stdproc)
	    ("inchar" "InChar" simula-expand-stdproc)
	    ("infile" "InFile" simula-expand-stdproc)
	    ("infrac" "InFrac" simula-expand-stdproc)
	    ("inimage" "InImage" simula-expand-stdproc)
	    ("inint" "InInt" simula-expand-stdproc)
	    ("inner" "INNER" simula-expand-keyword)
	    ("inreal" "InReal" simula-expand-stdproc)
	    ("inrecord" "InRecord" simula-expand-stdproc)
	    ("inspect" "INSPECT" simula-expand-keyword)
	    ("integer" "INTEGER" simula-expand-keyword)
	    ("intext" "InText" simula-expand-stdproc)
	    ("into" "Into" simula-expand-stdproc)
	    ("is" "IS" simula-expand-keyword)
	    ("isochar" "ISOChar" simula-expand-stdproc)
	    ("isopen" "IsOpen" simula-expand-stdproc)
	    ("isorank" "ISORank" simula-expand-stdproc)
	    ("label" "LABEL" simula-expand-keyword)
	    ("last" "Last" simula-expand-stdproc)
	    ("lastitem" "LastItem" simula-expand-stdproc)
	    ("lastloc" "LastLoc" simula-expand-stdproc)
	    ("le" "LE" simula-expand-keyword)
	    ("length" "Length" simula-expand-stdproc)
	    ("letter" "Letter" simula-expand-stdproc)
	    ("line" "Line" simula-expand-stdproc)
	    ("linear" "Linear" simula-expand-stdproc)
	    ("linesperpage" "LinesPerPage" simula-expand-stdproc)
	    ("link" "Link" simula-expand-stdproc)
	    ("linkage" "Linkage" simula-expand-stdproc)
	    ("ln" "Ln" simula-expand-stdproc)
	    ("locate" "Locate" simula-expand-stdproc)
	    ("location" "Location" simula-expand-stdproc)
	    ("lock" "Lock" simula-expand-stdproc)
	    ("locked" "Locked" simula-expand-stdproc)
	    ("log10" "Log10" simula-expand-stdproc)
	    ("long" "LONG" simula-expand-keyword)
	    ("lowcase" "LowCase" simula-expand-stdproc)
	    ("lowerbound" "LowerBound" simula-expand-stdproc)
	    ("lowten" "LowTen" simula-expand-stdproc)
	    ("lt" "LT" simula-expand-keyword)
	    ("main" "Main" simula-expand-stdproc)
	    ("max" "Max" simula-expand-stdproc)
	    ("maxint" "MaxInt" simula-expand-stdproc)
	    ("maxlongreal" "MaxLongReal" simula-expand-stdproc)
	    ("maxloc" "MaxLoc" simula-expand-stdproc)
	    ("maxrank" "MaxRank" simula-expand-stdproc)
	    ("maxreal" "MaxReal" simula-expand-stdproc)
	    ("min" "Min" simula-expand-stdproc)
	    ("minint" "MinInt" simula-expand-stdproc)
	    ("minlongreal" "MinLongReal" simula-expand-stdproc)
	    ("minrank" "MinRank" simula-expand-stdproc)
	    ("minreal" "MinReal" simula-expand-stdproc)
	    ("mod" "Mod" simula-expand-stdproc)
	    ("more" "More" simula-expand-stdproc)
	    ("name" "NAME" simula-expand-keyword)
	    ("ne" "NE" simula-expand-keyword)
	    ("negexp" "NegExp" simula-expand-stdproc)
	    ("new" "NEW" simula-expand-keyword)
	    ("nextev" "NextEv" simula-expand-stdproc)
	    ("none" "NONE" simula-expand-keyword)
	    ("normal" "Normal" simula-expand-stdproc)
	    ("not" "NOT" simula-expand-keyword)
	    ("notext" "NOTEXT" simula-expand-keyword)
	    ("open" "Open" simula-expand-stdproc)
	    ("or" "OR" simula-expand-keyword)
	    ("otherwise" "OTHERWISE" simula-electric-keyword)
	    ("out" "Out" simula-expand-stdproc)
	    ("outbyte" "OutByte" simula-expand-stdproc)
	    ("outbytefile" "OutByteFile" simula-expand-stdproc)
	    ("outchar" "OutChar" simula-expand-stdproc)
	    ("outfile" "OutFile" simula-expand-stdproc)
	    ("outfix" "OutFix" simula-expand-stdproc)
	    ("outfrac" "OutFrac" simula-expand-stdproc)
	    ("outimage" "OutImage" simula-expand-stdproc)
	    ("outint" "OutInt" simula-expand-stdproc)
	    ("outreal" "OutReal" simula-expand-stdproc)
	    ("outrecord" "OutRecord" simula-expand-stdproc)
	    ("outtext" "OutText" simula-expand-stdproc)
	    ("page" "Page" simula-expand-stdproc)
	    ("passivate" "Passivate" simula-expand-stdproc)
	    ("poisson" "Poisson" simula-expand-stdproc)
	    ("pos" "Pos" simula-expand-stdproc)
	    ("precede" "Precede" simula-expand-stdproc)
	    ("pred" "Pred" simula-expand-stdproc)
	    ("prev" "Prev" simula-expand-stdproc)
	    ("printfile" "PrintFile" simula-expand-stdproc)
	    ("prior" "PRIOR" simula-expand-keyword)
	    ("procedure" "PROCEDURE" simula-expand-keyword)
	    ("process" "Process" simula-expand-stdproc)
	    ("protected" "PROTECTED" simula-expand-keyword)
	    ("putchar" "PutChar" simula-expand-stdproc)
	    ("putfix" "PutFix" simula-expand-stdproc)
	    ("putfrac" "PutFrac" simula-expand-stdproc)
	    ("putint" "PutInt" simula-expand-stdproc)
	    ("putreal" "PutReal" simula-expand-stdproc)
	    ("qua" "QUA" simula-expand-keyword)
	    ("randint" "RandInt" simula-expand-stdproc)
	    ("rank" "Rank" simula-expand-stdproc)
	    ("reactivate" "REACTIVATE" simula-expand-keyword)
	    ("real" "REAL" simula-expand-keyword)
	    ("ref" "REF" simula-expand-keyword)
	    ("resume" "Resume" simula-expand-stdproc)
	    ("setaccess" "SetAccess" simula-expand-stdproc)
	    ("setpos" "SetPos" simula-expand-stdproc)
	    ("short" "SHORT" simula-expand-keyword)
	    ("sign" "Sign" simula-expand-stdproc)
	    ("simset" "SimSet" simula-expand-stdproc)
	    ("simulaid" "SimulaId" simula-expand-stdproc)
	    ("simulation" "Simulation" simula-expand-stdproc)
	    ("sin" "Sin" simula-expand-stdproc)
	    ("sinh" "SinH" simula-expand-stdproc)
	    ("sourceline" "SourceLine" simula-expand-stdproc)
	    ("spacing" "Spacing" simula-expand-stdproc)
	    ("sqrt" "Sqrt" simula-expand-stdproc)
	    ("start" "Start" simula-expand-stdproc)
	    ("step" "STEP" simula-expand-keyword)
	    ("strip" "Strip" simula-expand-stdproc)
	    ("sub" "Sub" simula-expand-stdproc)
	    ("subepsilon" "SubEpsilon" simula-expand-stdproc)
	    ("suc" "Suc" simula-expand-stdproc)
	    ("switch" "SWITCH" simula-expand-keyword)
	    ("sysin" "SysIn" simula-expand-stdproc)
	    ("sysout" "SysOut" simula-expand-stdproc)
	    ("tan" "Tan" simula-expand-stdproc)
	    ("tanh" "TanH" simula-expand-stdproc)
	    ("terminate_program" "Terminate_Program" simula-expand-stdproc)
	    ("terminated" "Terminated" simula-expand-stdproc)
	    ("text" "TEXT" simula-expand-keyword)
	    ("then" "THEN" simula-electric-keyword)
	    ("this" "THIS" simula-expand-keyword)
	    ("time" "Time" simula-expand-stdproc)
	    ("to" "TO" simula-expand-keyword)
	    ("true" "TRUE" simula-expand-keyword)
	    ("uniform" "Uniform" simula-expand-stdproc)
	    ("unlock" "Unlock" simula-expand-stdproc)
	    ("until" "UNTIL" simula-expand-keyword)
	    ("upcase" "Upcase" simula-expand-stdproc)
	    ("upperbound" "UpperBound" simula-expand-stdproc)
	    ("value" "VALUE" simula-expand-keyword)
	    ("virtual" "VIRTUAL" simula-expand-keyword)
	    ("wait" "Wait" simula-expand-stdproc)
	    ("when" "WHEN" simula-electric-keyword)
	    ("while" "WHILE" simula-expand-keyword))))

;;; simula.el ends here
