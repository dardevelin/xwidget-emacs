;;; fast-lock.el --- Automagic text properties saving for fast font-lock-mode.

;; Copyright (C) 1994 Free Software Foundation, Inc.

;; Author: Simon Marshall <Simon.Marshall@mail.esrin.esa.it>
;; Keywords: faces files
;; Version: 3.05

;;; This file is part of GNU Emacs.

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

;; Purpose:
;;
;; To make visiting a file in `font-lock-mode' faster by restoring its face
;; text properties from automatically saved associated font lock cache files.
;;
;; See also the face-lock package.
;; See also the lazy-lock package.  (But don't use the two at the same time!)

;; Note that:
;;
;; - A cache will be saved when visiting a compressed file using crypt++, but
;;   not be read.  This is a "feature"/"consequence"/"bug" of crypt++.

;; Installation:
;; 
;; Put this file somewhere where Emacs can find it (i.e., in one of the paths
;; in your `load-path'), `byte-compile-file' it, and put in your ~/.emacs:
;;
;; (autoload 'turn-on-fast-lock "fast-lock"
;;   "Unconditionally turn on Fast Lock mode.")
;;
;; (add-hook 'font-lock-mode-hook 'turn-on-fast-lock)
;;
;; Start up a new Emacs and use font-lock as usual (except that you can use the
;; so-called "gaudier" fontification regexps on big files without frustration).
;;
;; When you visit a file (which has `font-lock-mode' enabled) that has a
;; corresponding font lock cache file associated with it, the font lock cache
;; will be loaded from that file instead of being generated by font-lock code.
;;
;; Font lock caches will be saved:
;;  - For all buffers with Fast Lock mode enabled when you exit from Emacs.
;;  - For a buffer with Fast Lock mode enabled when you kill the buffer.
;; To provide control over how such cache files are written automagically, see
;; variable `fast-lock-cache-directories'.  To provide control over which such
;; cache files are written, see variables `fast-lock-save-others' and
;; `fast-lock-save-size'.  Only cache files which were generated using the same
;; `font-lock-keywords' as you are using will be used.
;;
;; As an illustration of the time saving, a 115k file of Emacs C code took 95
;; seconds to fontify using Emacs 19.25 on a Sun SparcStation 2 LX (using
;; `c-font-lock-keywords-2').  The font lock cache file takes around 2 seconds
;; to load (with around 4 seconds to generate and save).  Bite it.  Believe it.
;; (For Lucid Emacs 19.10, the figures on a similar machine, file, and regexps,
;; are 70, around 4, and around 4, seconds, respectively; for Emacs 19.28 the
;; fontification takes around 26 seconds.)

;; Feedback:
;;
;; Please send me bug reports, bug fixes, and extensions, so that I can
;; merge them into the master source.
;;     - Simon Marshall (Simon.Marshall@mail.esrin.esa.it)

(require 'font-lock)

(eval-when-compile
  ;; Shut Emacs' byte-compiler up (cf. stop me getting mail from users).
  (setq byte-compile-warnings '(free-vars callargs redefine)))

;; User variables:

(defvar fast-lock-cache-directories '("." "~/.emacs-flc")
; - `internal', keep each file's font lock cache file in the same file.
; - `external', keep each file's font lock cache file in the same directory.
  "Directories in which font lock cache files are saved and read.
Each item should be either DIR or a cons pair of the form (REGEXP . DIR) where
DIR is a directory name (relative or absolute) and REGEXP is a regexp.

An attempt will be made to save or read font lock cache files using these items
until one succeeds (i.e., until a readable or writable one is found).  If an
item contains REGEXP, DIR is used only if the buffer file name matches REGEXP.
For example:

 (list (cons (concat \"^\" (regexp-quote (expand-file-name \"~\"))) \".\")
       \"~/.emacs-flc\")

would cause a file's current directory to be used if the file is under your
home directory hierarchy, and the absolute directory otherwise.")

(defvar fast-lock-save-size (* 10 1024)
  "If non-nil, the minimum size for buffer files.
Only buffer files at least this size can have associated font lock cache files
saved.  If nil, means size is irrelevant.")

(defvar fast-lock-save-others t
  "If non-nil, save font lock cache files irrespective of file owner.
If nil, means only buffer files owned by you have a font lock cache saved.")

(defvar fast-lock-mode nil)		; for modeline
(defvar fast-lock-cache-timestamp nil)	; for saving/reading
(make-variable-buffer-local 'fast-lock-cache-timestamp)

;; Functions:

(defun fast-lock-mode (&optional arg)
  "Toggle Fast Lock mode.
With arg, turn Fast Lock mode on if and only if arg is positive and the buffer
is associated with a file.

If Fast Lock mode is enabled, and the current buffer does not contain any text
properties, any associated font lock cache is used (by `fast-lock-read-cache')
if the same `font-lock-keywords' were used for the cache as you are using.

Font lock caches will be saved:
 - For all buffers with Fast Lock mode enabled when you exit from Emacs.
 - For a buffer with Fast Lock mode enabled when you kill the buffer.
Saving is done by `fast-lock-save-cache' and `fast-lock-save-caches'.

Various methods of control are provided for the font lock cache.  In general,
see variable `fast-lock-cache-directories' and function `fast-lock-cache-name'.
For saving, see variables `fast-lock-save-others' and `fast-lock-save-size'."
  (interactive "P")
  (set (make-local-variable 'fast-lock-mode)
       (and (buffer-file-name)
	    (if arg (> (prefix-numeric-value arg) 0) (not fast-lock-mode))))
  (if (and fast-lock-mode (not font-lock-fontified))
      (fast-lock-read-cache)))

(defun fast-lock-read-cache ()
  "Read the font lock cache for the current buffer.
Returns t if the font lock cache file is read.

The following criteria must be met for a font lock cache file to be read:
 - Fast Lock mode must be turned on in the buffer.
 - The buffer's `font-lock-keywords' must match the cache's.
 - The buffer file's timestamp must match the cache's.
 - Criteria imposed by `fast-lock-cache-directories'.

See also `fast-lock-save-cache' and `fast-lock-cache-name'."
  (interactive)
  (let ((directories fast-lock-cache-directories) directory
	(modified (buffer-modified-p))
	(fontified font-lock-fontified))
    (set (make-local-variable 'font-lock-fontified) nil)
    ;; Keep trying directories until fontification is turned off.
    (while (and directories (not font-lock-fontified))
      (setq directory (fast-lock-cache-directory (car directories) nil)
	    directories (cdr directories))
      (if directory
	  (condition-case nil
	      (load (fast-lock-cache-name directory) t t t)
	    (error nil) (quit nil))))
    (set-buffer-modified-p modified)
    (or font-lock-fontified (setq font-lock-fontified fontified))))

(defun fast-lock-save-cache (&optional buffer)
  "Save the font lock cache of BUFFER or the current buffer.
Returns t if the font lock cache file is saved.

The following criteria must be met for a font lock cache file to be saved:
 - Fast Lock mode must be turned on in the buffer.
 - The buffer must be at least `fast-lock-save-size' bytes long.
 - The buffer file must be owned by you, or `fast-lock-save-others' must be t.
 - The buffer must contain at least one `face' text property.
 - The buffer file's timestamp must be different than its associated text
   properties file's timestamp.
 - Criteria imposed by `fast-lock-cache-directories'.

See also `fast-lock-save-caches', `fast-lock-read-cache' and `fast-lock-mode'."
  (interactive)
  (let* ((bufile (buffer-file-name buffer))
	 (buatts (and bufile (file-attributes bufile)))
	 (bufile-timestamp (nth 5 buatts))
	 (bufuid (nth 2 buatts)) (saved nil))
    (save-excursion
      (and buffer (set-buffer buffer))
      (if (and fast-lock-mode
	       ;; Only save if the timestamp of the file has changed.
	       (not (equal fast-lock-cache-timestamp bufile-timestamp))
	       ;; User's restrictions?
	       (or fast-lock-save-others (eq (user-uid) bufuid))
	       (<= (or fast-lock-save-size 0) (buffer-size))
	       ;; Only save if there are properties to save.
	       (text-property-not-all (point-min) (point-max) 'face nil))
	  (let ((directories fast-lock-cache-directories) directory)
	    (while (and directories (not saved))
	      (setq directory (fast-lock-cache-directory (car directories) t)
		    directories (cdr directories))
	      (if directory
		  (setq saved (fast-lock-save-cache-data
			       directory bufile-timestamp))))))
      ;; Set the buffer's timestamp if saved.
      (and saved (setq fast-lock-cache-timestamp bufile-timestamp)))
    saved))

(defun fast-lock-save-cache-data (directory timestamp)
  ;; Save the file with the timestamp, if we can, in the given directory, as:
  ;; (fast-lock-cache-data Version=2 TIMESTAMP font-lock-keywords PROPERTIES).
  (let ((buname (buffer-name))
	(tpfile (fast-lock-cache-name directory))
	(saved nil))
    (if (file-writable-p tpfile)
	(let ((tpbuf (generate-new-buffer " *fast-lock*")))
	  (message "Saving %s font lock cache..." buname)
	  (unwind-protect
	      (save-excursion
		(print (list 'fast-lock-cache-data 2
			     (list 'quote timestamp)
			     (list 'quote font-lock-keywords)
			     (list 'quote (fast-lock-get-face-properties)))
		       tpbuf)
		(set-buffer tpbuf)
		(write-region (point-min) (point-max) tpfile nil 'quietly)
		(setq saved t))
	    (kill-buffer tpbuf))
	  (message "Saving %s font lock cache... done." buname)))
    saved))

;; Miscellaneous functions:

(defun turn-on-fast-lock ()
  "Unconditionally turn on Fast Lock mode."
  (fast-lock-mode 1))

(defun fast-lock-save-caches ()
  "Save the font lock caches of all buffers.
Returns list of cache save success of buffers in `buffer-list'.
See `fast-lock-save-cache' for details of save criteria."
  (mapcar 'fast-lock-save-cache (buffer-list)))

(defun fast-lock-cache-directory (directory create)
  "Return usable directory based on DIRECTORY.
Returns nil if the directory does not exist, or, if CREATE non-nil, cannot be
created.  DIRECTORY may be a string or a cons pair of the form (REGEXP . DIR).
See `fast-lock-cache-directories'."
  (let ((dir (cond ((not buffer-file-name)
		    nil)
		   ((stringp directory)
		    directory)
		   (t
		    (let ((bufile (expand-file-name
				   (abbreviate-file-name
				    (file-truename buffer-file-name))))
			  (case-fold-search nil))
		      (if (string-match (car directory) bufile)
			  (cdr directory)))))))
    (cond ((not dir)
	   nil)
	  ((not create)
	   (and (file-accessible-directory-p dir) dir))
	  (t
	   (if (file-accessible-directory-p dir)
	       dir
	     (condition-case nil (make-directory dir t) (error nil))
	     (and (file-accessible-directory-p dir) dir))))))

(defun fast-lock-cache-name (directory)
  "Return full cache path name using caching DIRECTORY.
If DIRECTORY is `.', the path is the buffer file name appended with `.flc'.
Otherwise, the path name is constructed from DIRECTORY and the buffer's true
abbreviated file name, with all `/' characters in the name replaced with `#'
characters, and appended with `.flc'.

See `fast-lock-mode'."
  (if (string-equal directory ".")
      (concat buffer-file-name ".flc")
    (let* ((bufile (expand-file-name
		    (abbreviate-file-name (file-truename buffer-file-name))))
	   (chars-alist
	    (if (eq system-type 'emx)
		'((?/ . (?#)) (?# . (?# ?#)) (?: . (?\;)) (?\; . (?\; ?\;)))
	      '((?/ . (?#)) (?# . (?# ?#)))))
	   (mapchars
	    (function (lambda (c) (or (cdr (assq c chars-alist)) (list c))))))
      (concat
       (file-name-as-directory (expand-file-name directory))
       (mapconcat 'char-to-string (apply 'append (mapcar mapchars bufile)) "")
       ".flc"))))

;; Font lock cache processing functions:

(defun fast-lock-cache-data (version timestamp keywords properties
			     &rest ignored)
  ;; Use the font lock cache PROPERTIES if we're using cache VERSION format 2,
  ;; the current buffer's file timestamp matches the TIMESTAMP, and the current
  ;; buffer's font-lock-keywords are the same as KEYWORDS.
  (let ((buf-timestamp (nth 5 (file-attributes buffer-file-name)))
	(buname (buffer-name)) (inhibit-read-only t) (loaded t))
    (if (or (/= version 2)
	    (not (equal timestamp buf-timestamp))
	    (not (equal keywords font-lock-keywords)))
	(setq loaded nil)
      (message "Loading %s font lock cache..." buname)
      (condition-case nil
	  (fast-lock-set-face-properties properties)
	(error (setq loaded nil)) (quit (setq loaded nil)))
      (message "Loading %s font lock cache... done." buname))
    ;; If we used the text properties, stop fontification and keep timestamp.
    (setq font-lock-fontified loaded
	  fast-lock-cache-timestamp (and loaded timestamp))))

(defun fast-lock-get-face-properties (&optional buffer)
  "Return a list of all `face' text properties in BUFFER.
Each element of the list is of the form (VALUE START1 END1 START2 END2 ...)
where VALUE is a `face' property value and STARTx and ENDx are positions."
  (save-excursion
    (and buffer (set-buffer buffer))
    (save-restriction
      (widen)
      (let ((start (text-property-not-all (point-min) (point-max) 'face nil))
	    (limit (point-max)) end properties value cell)
	(while start
	  (setq end (next-single-property-change start 'face nil limit)
		value (get-text-property start 'face))
	  ;; Make or add to existing list of regions with same `face' property.
	  (if (setq cell (assq value properties))
	      (setcdr cell (cons start (cons end (cdr cell))))
	    (setq properties (cons (list value start end) properties)))
	  (setq start (next-single-property-change end 'face)))
	properties))))

(defun fast-lock-set-face-properties (properties &optional buffer)
  "Set all `face' text properties to PROPERTIES in BUFFER.
Any existing `face' text properties are removed first.  Leaves BUFFER modified.
See `fast-lock-get-face-properties' for the format of PROPERTIES."
  (save-excursion
    (and buffer (set-buffer buffer))
    (save-restriction
      (widen)
      (font-lock-unfontify-region (point-min) (point-max))
      (while properties
	(let ((plist (list 'face (car (car properties))))
	      (regions (cdr (car properties))))
	  ;; Set the `face' property for each start/end region.
	  (while regions
	    (set-text-properties (nth 0 regions) (nth 1 regions) plist buffer)
	    (setq regions (nthcdr 2 regions)))
	  (setq properties (cdr properties)))))))

;; Functions for Lucid:

(or (fboundp 'face-list)
    (defalias 'face-list 'list-faces))

(if (save-match-data (string-match "Lucid" (emacs-version)))
    ;; This is about a bazillion times faster at generating the cache in Lucid.
    (defun fast-lock-get-face-properties (&optional buffer)
      "Return a list of all `face' text properties in BUFFER.
Each element of the list is of the form (VALUE START1 END1 START2 END2 ...)
where VALUE is a `face' property value and STARTx and ENDx are positions."
      (save-excursion
	(and buffer (set-buffer buffer))
	(save-restriction
	  (widen)
	  (let ((properties ()))
	    (map-extents
	     (function (lambda (extent ignore)
	      (let* ((face (extent-face extent))
		     (start (extent-start-position extent))
		     (end (extent-end-position extent))
		     (facedata (assoc face properties)))
		(if facedata
		    ;; Prepend the new start and end points onto the list.
		    (setcdr facedata (cons start (cons end (cdr facedata))))
		  (setq properties (cons (list face start end) properties)))
		;; Return nil to keep `map-extents' going.
		nil))))
	    properties)))))

(if (save-match-data (string-match "Lucid" (emacs-version)))
    ;; This is faster at using the cache in Lucid.
    (defun fast-lock-set-face-properties (properties &optional buffer)
      "Set all `face' text properties to PROPERTIES in BUFFER.
Any existing `face' text properties are removed first.  Leaves BUFFER modified.
See `fast-lock-get-face-properties' for the format of PROPERTIES."
      (save-excursion
	(and buffer (set-buffer buffer))
	(save-restriction
	  (widen)
	  (font-lock-unfontify-region (point-min) (point-max))
	  (while properties
	    (let ((property (car (car properties)))
		  (regions (cdr (car properties))) extent)
	      ;; Set the `face' property for each start/end region.
	      (while regions
		(setq extent (make-extent (nth 0 regions) (nth 1 regions))
		      regions (nthcdr 2 regions))
		(set-extent-face extent property)
		(set-extent-property extent 'text-prop 'face))
	      (setq properties (cdr properties))))))))

(if (and (boundp 'emacs-minor-version) (< emacs-minor-version 12))
    ;; Must be [LX]Emacs; fix the 19.11 (at least) `text-property-not-all' bug.
    (defun text-property-not-all (start end prop value &optional buffer)
      "Check text from START to END to see if PROP is ever not `eq' to VALUE.
If so, return the position of the first character whose PROP is not
`eq' to VALUE.  Otherwise, return nil."
      (let ((maxend start))
	(map-extents
	 (function
	  (lambda (e ignore)
	    ;;### no, actually, this is harder.  We need to collect all props
	    ;; for a given character, and then determine whether no extent
	    ;; contributes the given value.  Doing this without consing lots
	    ;; of lists is the tricky part.
	    (if (not (eq value (extent-property e prop)))
		(max start maxend)
	      (setq maxend (extent-end-position e))
	      nil)))
	 nil start end buffer))))

;; Install ourselves:

(or (assq 'fast-lock-mode minor-mode-alist)
    (setq minor-mode-alist (cons '(fast-lock-mode " Fast") minor-mode-alist)))

(add-hook 'kill-buffer-hook 'fast-lock-save-cache)
(add-hook 'kill-emacs-hook 'fast-lock-save-caches)

;; Provide ourselves:

(provide 'fast-lock)

;;; fast-lock.el ends here

