;;; mail-utils.el --- utility functions used both by rmail and rnews

;; Copyright (C) 1985 Free Software Foundation, Inc.

;; Maintainer: FSF
;; Keywords: mail, news

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
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; Utility functions for mail and netnews handling.  These handle fine
;; points of header parsing.

;;; Code:

;;; We require lisp-mode to make sure that lisp-mode-syntax-table has
;;; been initialized.
(require 'lisp-mode)
		     
;;;###autoload
(defcustom mail-use-rfc822 nil "\
*If non-nil, use a full, hairy RFC822 parser on mail addresses.
Otherwise, (the default) use a smaller, somewhat faster, and
often correct parser."
  :type 'boolean
  :group 'mail)

;; Returns t if file FILE is an Rmail file.
;;;###autoload
(defun mail-file-babyl-p (file)
  (let ((buf (generate-new-buffer " *rmail-file-p*")))
    (unwind-protect
	(save-excursion
	  (set-buffer buf)
	  (insert-file-contents file nil 0 100)
	  (looking-at "BABYL OPTIONS:"))
      (kill-buffer buf))))

(defun mail-string-delete (string start end)
  "Returns a string containing all of STRING except the part
from START (inclusive) to END (exclusive)."
  (if (null end) (substring string 0 start)
    (concat (substring string 0 start)
	    (substring string end nil))))

;;;###autoload
(defun mail-quote-printable (string &optional wrapper)
  "Convert a string to the \"quoted printable\" Q encoding.
If the optional argument WRAPPER is non-nil,
we add the wrapper characters =?ISO-8859-1?Q?....?=."
  (let ((i 0) (result ""))
    (save-match-data
      (while (string-match "[?=\"\200-\377]" string i)
	(setq result
	      (concat result (substring string i (match-beginning 0))
		      (upcase (format "=%02x"
				      (aref string (match-beginning 0))))))
	(setq i (match-end 0)))
      (if wrapper
	  (concat "=?ISO-8859-1?Q?"
		  result (substring string i)
		  "?=")
	(concat result (substring string i))))))

(defun mail-unquote-printable-hexdigit (char)
  (if (>= char ?A)
      (+ (- char ?A) 10)
    (- char ?0)))

;;;###autoload
(defun mail-unquote-printable (string &optional wrapper)
  "Undo the \"quoted printable\" encoding.
If the optional argument WRAPPER is non-nil,
we expect to find and remove the wrapper characters =?ISO-8859-1?Q?....?=."
  (save-match-data
    (and wrapper
	 (string-match "\\`=\\?ISO-8859-1\\?Q\\?\\([^?]*\\)\\?" string)
	 (setq string (match-string 1 string)))
    (let ((i 0) strings)
      (while (string-match "=\\(..\\|\n\\)" string i)
	(setq strings (cons (substring string i (match-beginning 0)) strings))
	(unless (= (aref string (match-beginning 1)) ?\n)
	  (setq strings
		(cons (make-string 1
				   (+ (* 16 (mail-unquote-printable-hexdigit
					     (aref string (match-beginning 1))))
				      (mail-unquote-printable-hexdigit
				       (aref string (1+ (match-beginning 1))))))
		      strings)))
	(setq i (match-end 0)))
      (apply 'concat (nreverse (cons (substring string i) strings))))))

;;;###autoload
(defun mail-unquote-printable-region (beg end &optional wrapper)
  "Undo the \"quoted printable\" encoding in buffer from BEG to END.
If the optional argument WRAPPER is non-nil,
we expect to find and remove the wrapper characters =?ISO-8859-1?Q?....?=."
  (interactive "r\nP")
  (save-match-data
    (save-excursion
      (save-restriction
	(narrow-to-region beg end)
	(goto-char (point-min))
	(when (and wrapper
		   (looking-at "\\`=\\?ISO-8859-1\\?Q\\?\\([^?]*\\)\\?"))
	  (delete-region (match-end 1) end)
	  (delete-region (point) (match-beginning 1)))
	(while (re-search-forward "=\\(..\\|\n\\)" nil t)
	  (goto-char (match-end 0))
	  (replace-match
	   (if (= (char-after (match-beginning 1)) ?\n)
	       ""
	     (make-string 1
			  (+ (* 16 (mail-unquote-printable-hexdigit
				    (char-after (match-beginning 1))))
			     (mail-unquote-printable-hexdigit
			      (char-after (1+ (match-beginning 1)))))))
	   t t))))))

(defun mail-strip-quoted-names (address)
  "Delete comments and quoted strings in an address list ADDRESS.
Also delete leading/trailing whitespace and replace FOO <BAR> with just BAR.
Return a modified address list."
  (if (null address)
      nil
    (if mail-use-rfc822
	(progn (require 'rfc822)
	       (mapconcat 'identity (rfc822-addresses address) ", "))
      (let (pos)

       ;; Detect nested comments.
       (if (string-match "[ \t]*(\\([^)\\]\\|\\\\.\\|\\\\\n\\)*(" address)
	   ;; Strip nested comments.
	   (with-current-buffer (get-buffer-create " *temp*")
	     (erase-buffer)
	     (insert address)
	     (set-syntax-table lisp-mode-syntax-table)
	     (goto-char 1)
	     (while (search-forward "(" nil t)
	       (forward-char -1)
	       (skip-chars-backward " \t")
	       (delete-region (point)
			      (save-excursion
				(condition-case ()
				    (forward-sexp 1)
				  (error (goto-char (point-max))))
				  (point))))
	     (setq address (buffer-string))
	     (erase-buffer))
	 ;; Strip non-nested comments an easier way.
	 (while (setq pos (string-match 
			    ;; This doesn't hack rfc822 nested comments
			    ;;  `(xyzzy (foo) whinge)' properly.  Big deal.
			    "[ \t]*(\\([^)\\]\\|\\\\.\\|\\\\\n\\)*)"
			    address))
	   (setq address (replace-match "" nil nil address 0))))

       ;; strip surrounding whitespace
       (string-match "\\`[ \t\n]*" address)
       (setq address (substring address
				(match-end 0)
				(string-match "[ \t\n]*\\'" address
					      (match-end 0))))

       ;; strip `quoted' names (This is supposed to hack `"Foo Bar" <bar@host>')
       (setq pos 0)
       (while (setq pos (string-match
                          "\\([ \t]?\\)\\([ \t]*\"\\([^\"\\]\\|\\\\.\\|\\\\\n\\)*\"[ \t\n]*\\)"
			  address pos))
	 ;; If the next thing is "@", we have "foo bar"@host.  Leave it.
	 (if (and (> (length address) (match-end 0))
		  (= (aref address (match-end 0)) ?@))
	     (setq pos (match-end 0))
	   ;; Otherwise discard the "..." part.
	   (setq address (replace-match "" nil nil address 2))))
       ;; If this address contains <...>, replace it with just
       ;; the part between the <...>.
       (while (setq pos (string-match "\\(,\\s-*\\|\\`\\)\\([^,]*<\\([^>,:]*\\)>[^,]*\\)\\(\\s-*,\\|\\'\\)"
				      address))
	 (setq address (replace-match (match-string 3 address)
				      nil nil address 2)))
       address))))

; rmail-dont-reply-to-names is defined in loaddefs
(defun rmail-dont-reply-to (userids)
  "Returns string of mail addresses USERIDS sans any recipients
that start with matches for `rmail-dont-reply-to-names'.
Usenet paths ending in an element that matches are removed also."
  (if (null rmail-dont-reply-to-names)
      (setq rmail-dont-reply-to-names
	    (concat (if rmail-default-dont-reply-to-names
			(concat rmail-default-dont-reply-to-names "\\|")
		        "")
		    (concat (regexp-quote (user-login-name))
			    "\\>"))))
  (let ((match (concat "\\(^\\|,\\)[ \t\n]*"
		       ;; Can anyone figure out what this is for?
		       ;; Is it an obsolete remnant of another way of
		       ;; handling Foo Bar <foo@machine>?
		       "\\([^,\n]*[!<]\\|\\)"
		       "\\("
			     rmail-dont-reply-to-names
		       "\\|"
		             ;; Include the human name that precedes <foo@bar>.
			     "\\([^\,.<\"]\\|\"[^\"]*\"\\)*"
			     "<\\(" rmail-dont-reply-to-names "\\)"
		       "\\)[^,]*"))
	(case-fold-search t)
	pos epos)
    (while (setq pos (string-match match userids pos))
      ;; If there's a match, it starts at the beginning of the string,
      ;; or with `,'.  We must delete from that position to the
      ;; end of the user-id which starts at match-beginning 2.
      (let (inside-quotes quote-pos last-quote-pos)
	(save-match-data
	  (while (and (setq quote-pos (string-match "\"" userids quote-pos))
		      (< quote-pos pos))
	    (setq last-quote-pos quote-pos)
	    (setq quote-pos (1+ quote-pos))
	    (setq inside-quotes (not inside-quotes))))
	(if inside-quotes
	    (if (string-match "\"" userids pos)
		(setq pos (string-match "\"" userids pos))
	      ;; If the open-quote has no close-quote,
	      ;; delete the open-quote to get something well-defined.
	      ;; This case is not valid, but it can happen if things
	      ;; are weird elsewhere.
	      (setq userids (replace-match "" nil nil userids))
	      (setq userids (concat (substring userids 0 last-quote-pos)
				    (substring userids (1+ last-quote-pos))))
	      (setq pos (1- pos)))
	  (setq userids (replace-match "" nil nil userids)))))
    ;; get rid of any trailing commas
    (if (setq pos (string-match "[ ,\t\n]*\\'" userids))
	(setq userids (substring userids 0 pos)))
    ;; remove leading spaces. they bother me.
    (if (string-match "\\(\\s \\|,\\)*" userids)
	(substring userids (match-end 0))
      userids)))


;;;###autoload
(defun mail-fetch-field (field-name &optional last all list)
  "Return the value of the header field whose type is FIELD-NAME.
The buffer is expected to be narrowed to just the header of the message.
If second arg LAST is non-nil, use the last field of type FIELD-NAME.
If third arg ALL is non-nil, concatenate all such fields with commas between.
If 4th arg LIST is non-nil, return a list of all such fields."
  (save-excursion
    (goto-char (point-min))
    (let ((case-fold-search t)
	  (name (concat "^" (regexp-quote field-name) "[ \t]*:[ \t]*")))
      (if (or all list)
	  (let ((value (if all "")))
	    (while (re-search-forward name nil t)
	      (let ((opoint (point)))
		(while (progn (forward-line 1)
			      (looking-at "[ \t]")))
		;; Back up over newline, then trailing spaces or tabs
		(forward-char -1)
		(skip-chars-backward " \t" opoint)
		(if list
		    (setq value (cons (buffer-substring-no-properties
				       opoint (point))
				      value))
		  (setq value (concat value
				      (if (string= value "") "" ", ")
				      (buffer-substring-no-properties
				       opoint (point)))))))
	    (if list
		value
	      (and (not (string= value "")) value)))
	(if (re-search-forward name nil t)
	    (progn
	      (if last (while (re-search-forward name nil t)))
	      (let ((opoint (point)))
		(while (progn (forward-line 1)
			      (looking-at "[ \t]")))
		;; Back up over newline, then trailing spaces or tabs
		(forward-char -1)
		(skip-chars-backward " \t" opoint)
		(buffer-substring-no-properties opoint (point)))))))))

;; Parse a list of tokens separated by commas.
;; It runs from point to the end of the visible part of the buffer.
;; Whitespace before or after tokens is ignored,
;; but whitespace within tokens is kept.
(defun mail-parse-comma-list ()
  (let (accumulated
	beg)
    (skip-chars-forward " \t\n")
    (while (not (eobp))
      (setq beg (point))
      (skip-chars-forward "^,")
      (skip-chars-backward " \t\n")
      (setq accumulated
	    (cons (buffer-substring-no-properties beg (point))
		  accumulated))
      (skip-chars-forward "^,")
      (skip-chars-forward ", \t\n"))
    accumulated))

(defun mail-comma-list-regexp (labels)
  (let (pos)
    (setq pos (or (string-match "[^ \t]" labels) 0))
    ;; Remove leading and trailing whitespace.
    (setq labels (substring labels pos (string-match "[ \t]*$" labels pos)))
    ;; Change each comma to \|, and flush surrounding whitespace.
    (while (setq pos (string-match "[ \t]*,[ \t]*" labels))
      (setq labels
	    (concat (substring labels 0 pos)
		    "\\|"
		    (substring labels (match-end 0))))))
  labels)

(defun mail-rfc822-time-zone (time)
  (let* ((sec (or (car (current-time-zone time)) 0))
	 (absmin (/ (abs sec) 60)))
    (format "%c%02d%02d" (if (< sec 0) ?- ?+) (/ absmin 60) (% absmin 60))))

(defun mail-rfc822-date ()
  (let* ((time (current-time))
	 (s (current-time-string time)))
    (string-match "[^ ]+ +\\([^ ]+\\) +\\([^ ]+\\) \\([^ ]+\\) \\([^ ]+\\)" s)
    (concat (substring s (match-beginning 2) (match-end 2)) " "
	    (substring s (match-beginning 1) (match-end 1)) " "
	    (substring s (match-beginning 4) (match-end 4)) " "
	    (substring s (match-beginning 3) (match-end 3)) " "
	    (mail-rfc822-time-zone time))))

(provide 'mail-utils)

;;; mail-utils.el ends here
