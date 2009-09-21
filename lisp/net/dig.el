;;; dig.el --- Domain Name System dig interface

;; Copyright (C) 2000, 2001, 2002, 2003, 2004,
;;   2005, 2006, 2007, 2008, 2009 Free Software Foundation, Inc.

;; Author: Simon Josefsson <simon@josefsson.org>
;; Keywords: DNS BIND dig comm

;; This file is part of GNU Emacs.

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

;; This provide an interface for "dig".
;;
;; For interactive use, try M-x dig and type a hostname.  Use `q' to quit
;; dig buffer.
;;
;; For use in elisp programs, call `dig-invoke' and use
;; `dig-extract-rr' to extract resource records.

;;; Release history:

;; 2000-10-28  posted on gnu.emacs.sources

;;; Code:

(eval-when-compile (require 'cl))

(defgroup dig nil
  "Dig configuration."
  :group 'comm)

(defcustom dig-program "dig"
  "Name of dig (domain information groper) binary."
  :type 'file
  :group 'dig)

(defcustom dig-dns-server nil
  "DNS server to query.
If nil, use system defaults."
  :type '(choice (const :tag "System defaults")
		 string)
  :group 'dig)

(defcustom dig-font-lock-keywords
  '(("^;; [A-Z]+ SECTION:" 0 font-lock-keyword-face)
    ("^;;.*" 0 font-lock-comment-face)
    ("^; <<>>.*" 0 font-lock-type-face)
    ("^;.*" 0 font-lock-function-name-face))
  "Default expressions to highlight in dig mode."
  :type 'sexp
  :group 'dig)

(defun dig-invoke (domain &optional
			  query-type query-class query-option
			  dig-option server)
  "Call dig with given arguments and return buffer containing output.
DOMAIN is a string with a DNS domain. QUERY-TYPE is an optional string
with a DNS type. QUERY-CLASS is an optional string with a DNS class.
QUERY-OPTION is an optional string with dig \"query options\".
DIG-OPTIONS is an optional string with parameters for the dig program.
SERVER is an optional string with a domain name server to query.

Dig is an external program found in the BIND name server distribution,
and is a commonly available debugging tool."
  (let (buf cmdline)
    (setq buf (generate-new-buffer "*dig output*"))
    (if dig-option (push dig-option cmdline))
    (if query-option (push query-option cmdline))
    (if query-class (push query-class cmdline))
    (if query-type (push query-type cmdline))
    (push domain cmdline)
    (if server (push (concat "@" server) cmdline)
      (if dig-dns-server (push (concat "@" dig-dns-server) cmdline)))
    (apply 'call-process dig-program nil buf nil cmdline)
    buf))

(defun dig-extract-rr (domain &optional type class)
  "Extract resource records for DOMAIN, TYPE and CLASS from buffer.
Buffer should contain output generated by `dig-invoke'."
  (save-excursion
    (goto-char (point-min))
    (if (re-search-forward
	 (concat domain "\\.?[\t ]+[0-9wWdDhHmMsS]+[\t ]+"
		 (upcase (or class "IN")) "[\t ]+" (upcase (or type "A")))
	 nil t)
	(let (b e)
	  (end-of-line)
	  (setq e (point))
	  (beginning-of-line)
	  (setq b (point))
	  (when (search-forward " (" e t)
	    (search-forward " )"))
	  (end-of-line)
	  (setq e (point))
	  (buffer-substring b e))
      (and (re-search-forward (concat domain "\\.?[\t ]+[0-9wWdDhHmMsS]+[\t ]+"
				      (upcase (or class "IN"))
				      "[\t ]+CNAME[\t ]+\\(.*\\)$") nil t)
	   (dig-extract-rr (match-string 1) type class)))))

(defun dig-rr-get-pkix-cert (rr)
  (let (b e str)
    (string-match "[^\t ]+[\t ]+[0-9wWdDhHmMsS]+[\t ]+IN[\t ]+CERT[\t ]+\\(1\\|PKIX\\)[\t ]+[0-9]+[\t ]+[0-9]+[\t ]+(?" rr)
    (setq b (match-end 0))
    (string-match ")" rr)
    (setq e (match-beginning 0))
    (setq str (substring rr b e))
    (while (string-match "[\t \n\r]" str)
      (setq str (replace-match "" nil nil str)))
    str))

;; XEmacs does it like this.  For Emacs, we have to set the
;; `font-lock-defaults' buffer-local variable.
(put 'dig-mode 'font-lock-defaults '(dig-font-lock-keywords t))

(put 'dig-mode 'mode-class 'special)

(defvar dig-mode-map nil)
(unless dig-mode-map
  (setq dig-mode-map (make-sparse-keymap))
  (suppress-keymap dig-mode-map)

  (define-key dig-mode-map "q" 'dig-exit))

(define-derived-mode dig-mode nil "Dig"
  "Major mode for displaying dig output."
  (buffer-disable-undo)
  (unless (featurep 'xemacs)
    (set (make-local-variable 'font-lock-defaults)
	 '(dig-font-lock-keywords t)))
  (when (featurep 'font-lock)
    ;; FIXME: what is this for??  --Stef
    (font-lock-set-defaults))
  )

(defun dig-exit ()
  "Quit dig output buffer."
  (interactive)
  (kill-buffer (current-buffer)))

;;;###autoload
(defun dig (domain &optional
		   query-type query-class query-option dig-option server)
  "Query addresses of a DOMAIN using dig, by calling `dig-invoke'.
Optional arguments are passed to `dig-invoke'."
  (interactive "sHost: ")
  (switch-to-buffer
   (dig-invoke domain query-type query-class query-option dig-option server))
  (goto-char (point-min))
  (and (search-forward ";; ANSWER SECTION:" nil t)
       (forward-line))
  (dig-mode)
  (setq buffer-read-only t)
  (set-buffer-modified-p nil))

;; named for consistency with query-dns in dns.el
(defun query-dig (domain &optional
			 query-type query-class query-option dig-option server)
  "Query addresses of a DOMAIN using dig.
It works by calling `dig-invoke' and `dig-extract-rr'.  Optional
arguments are passed to `dig-invoke' and `dig-extract-rr'.  Returns
nil for domain/class/type queries that results in no data."
(let ((buffer (dig-invoke domain query-type query-class
			  query-option dig-option server)))
  (when buffer
    (switch-to-buffer buffer)
    (let ((digger (dig-extract-rr domain query-type query-class)))
      (kill-buffer buffer)
      digger))))

(provide 'dig)

;; arch-tag: 1d61726e-9400-4013-9ae7-4035e0c7f7d6
;;; dig.el ends here
