;;; mouse.el --- window system-independent mouse support.

;;; Copyright (C) 1988, 1992 Free Software Foundation, Inc.

;; Maintainer: FSF
;; Keywords: hardware

;;; This file is part of GNU Emacs.

;;; GNU Emacs is free software; you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 2, or (at your option)
;;; any later version.

;;; GNU Emacs is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.

;;; You should have received a copy of the GNU General Public License
;;; along with GNU Emacs; see the file COPYING.  If not, write to
;;; the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.


;;; Utility functions.

(defun mouse-movement-p (event)
  (and (consp event)
       (eq (car event) 'mouse-movement)))

(defun event-window (event)	(nth 1 event))
(defun event-point (event)	(nth 2 event))
(defun mouse-coords (event)	(nth 3 event))
(defun mouse-timestamp (event)	(nth 4 event))

;;; Indent track-mouse like progn.
(put 'track-mouse 'lisp-indent-function 0)


(defun mouse-delete-window (click)
  "Delete the window clicked on.
This must be bound to a mouse click."
  (interactive "K")
  (delete-window (event-window click)))

(defun mouse-delete-other-windows (click)
  "Select Emacs window clicked on, then kill all other Emacs windows.
This must be bound to a mouse click."
  (interactive "K")
  (select-window (event-window click))
  (delete-other-windows))

(defun mouse-split-window-vertically (click)
  "Select Emacs window mouse is on, then split it vertically in half.
The window is split at the line clicked on.
This command must be bound to a mouse click."
  (interactive "K")
  (select-window (event-window click))
  (split-window-vertically (1+ (cdr (mouse-coords click)))))

(defun mouse-set-point (click)
  "Move point to the position clicked on with the mouse.
This must be bound to a mouse click."
  (interactive "K")
  (select-window (event-window click))
  (if (numberp (event-point click))
      (goto-char (event-point click))))

(defun mouse-set-mark (click)
  "Set mark at the position clicked on with the mouse.
Display cursor at that position for a second.
This must be bound to a mouse click."
  (interactive "K")
  (let ((point-save (point)))
    (unwind-protect
	(progn (mouse-set-point click)
	       (push-mark nil t)
	       (sit-for 1))
      (goto-char point-save))))

(defun mouse-kill (click)
  "Kill the region between point and the mouse click.
The text is saved in the kill ring, as with \\[kill-region]."
  (interactive "K")
  (let ((click-posn (event-point click)))
    (if (numberp click-posn)
	(kill-region (min (point) click-posn)
		     (max (point) click-posn)))))

(defun mouse-yank-at-click (click arg)
  "Insert the last stretch of killed text at the position clicked on.
Prefix arguments are interpreted as with \\[yank]."
  (interactive "K\nP")
  (mouse-set-point click)
  (yank arg))

(defun mouse-kill-ring-save (click)
  "Copy the region between point and the mouse click in the kill ring.
This does not delete the region; it acts like \\[kill-ring-save]."
  (interactive "K")
  (mouse-set-mark click)
  (call-interactively 'kill-ring-save))

(defun mouse-buffer-menu (event)
  "Pop up a menu of buffers for selection with the mouse."
  (interactive "K")
  (let ((menu
	 (list "Buffer Menu"
	       (cons "Select Buffer"
		     (let ((tail (buffer-list))
			   head)
		       (while tail
			 (let ((elt (car tail)))
			   (if (not (string-match "^ "
						  (buffer-name elt)))
			       (setq head (cons
					   (cons
					    (format
					     "%14s   %s"
					     (buffer-name elt)
					     (or (buffer-file-name elt) ""))
					    elt)
					   head))))
			 (setq tail (cdr tail)))
		       (reverse head))))))
    (switch-to-buffer (or (x-popup-menu event menu) (current-buffer)))))

;; Commands for the scroll bar.

(defun mouse-scroll-down (nlines)
  (interactive "@p")
  (scroll-down nlines))

(defun mouse-scroll-up (nlines)
  (interactive "@p")
  (scroll-up nlines))

(defun mouse-scroll-down-full ()
  (interactive "@")
  (scroll-down nil))

(defun mouse-scroll-up-full ()
  (interactive "@")
  (scroll-up nil))

(defun mouse-scroll-move-cursor (nlines)
  (interactive "@p")
  (move-to-window-line nlines))

(defun mouse-scroll-absolute (event)
  (interactive "@e")
  (let* ((pos (car event))
	 (position (car pos))
	 (length (car (cdr pos))))
    (if (<= length 0) (setq length 1))
    (let* ((scale-factor (max 1 (/ length (/ 8000000 (buffer-size)))))
	   (newpos (* (/ (* (/ (buffer-size) scale-factor)
			    position)
			 length)
		      scale-factor)))
      (goto-char newpos)
      (recenter '(4)))))

(defun mouse-scroll-left (ncolumns)
  (interactive "@p")
  (scroll-left ncolumns))

(defun mouse-scroll-right (ncolumns)
  (interactive "@p")
  (scroll-right ncolumns))

(defun mouse-scroll-left-full ()
  (interactive "@")
  (scroll-left nil))

(defun mouse-scroll-right-full ()
  (interactive "@")
  (scroll-right nil))

(defun mouse-scroll-move-cursor-horizontally (ncolumns)
  (interactive "@p")
  (move-to-column ncolumns))

(defun mouse-scroll-absolute-horizontally (event)
  (interactive "@e")
  (let* ((pos (car event))
	 (position (car pos))
	 (length (car (cdr pos))))
  (set-window-hscroll (selected-window) 33)))

(global-set-key [scroll-bar mouse-1] 'mouse-scroll-up)
(global-set-key [scroll-bar mouse-2] 'mouse-scroll-absolute)
(global-set-key [scroll-bar mouse-3] 'mouse-scroll-down)

(global-set-key [vertical-slider mouse-1] 'mouse-scroll-move-cursor)
(global-set-key [vertical-slider mouse-2] 'mouse-scroll-move-cursor)
(global-set-key [vertical-slider mouse-3] 'mouse-scroll-move-cursor)

(global-set-key [thumbup mouse-1] 'mouse-scroll-up-full)
(global-set-key [thumbup mouse-2] 'mouse-scroll-up-full)
(global-set-key [thumbup mouse-3] 'mouse-scroll-up-full)

(global-set-key [thumbdown mouse-1] 'mouse-scroll-down-full)
(global-set-key [thumbdown mouse-2] 'mouse-scroll-down-full)
(global-set-key [thumbdown mouse-3] 'mouse-scroll-down-full)

(global-set-key [horizontal-scroll-bar mouse-1] 'mouse-scroll-left)
(global-set-key [horizontal-scroll-bar mouse-2]
		'mouse-scroll-absolute-horizontally)
(global-set-key [horizontal-scroll-bar mouse-3] 'mouse-scroll-right)

(global-set-key [horizontal-slider mouse-1]
		'mouse-scroll-move-cursor-horizontally)
(global-set-key [horizontal-slider mouse-2]
		'mouse-scroll-move-cursor-horizontally)
(global-set-key [horizontal-slider mouse-3]
		'mouse-scroll-move-cursor-horizontally)

(global-set-key [thumbleft mouse-1] 'mouse-scroll-left-full)
(global-set-key [thumbleft mouse-2] 'mouse-scroll-left-full)
(global-set-key [thumbleft mouse-3] 'mouse-scroll-left-full)

(global-set-key [thumbright mouse-1] 'mouse-scroll-right-full)
(global-set-key [thumbright mouse-2] 'mouse-scroll-right-full)
(global-set-key [thumbright mouse-3] 'mouse-scroll-right-full)

;;;;
;;;; Here are experimental things being tested.  Mouse events
;;;; are of the form:
;;;;	((x y) window screen-part key-sequence timestamp)
;;
;;;;
;;;; Dynamically track mouse coordinates
;;;;
;;
;;(defun track-mouse (event)
;;  "Track the coordinates, absolute and relative, of the mouse."
;;  (interactive "@e")
;;  (while mouse-grabbed
;;    (let* ((pos (read-mouse-position (selected-screen)))
;;	   (abs-x (car pos))
;;	   (abs-y (cdr pos))
;;	   (relative-coordinate (coordinates-in-window-p
;;				 (list (car pos) (cdr pos))
;;				 (selected-window))))
;;      (if (consp relative-coordinate)
;;	  (message "mouse: [%d %d], (%d %d)" abs-x abs-y
;;		   (car relative-coordinate)
;;		   (car (cdr relative-coordinate)))
;;	(message "mouse: [%d %d]" abs-x abs-y)))))

;;
;; Dynamically put a box around the line indicated by point
;;
;;
;;(require 'backquote)
;;
;;(defun mouse-select-buffer-line (event)
;;  (interactive "@e")
;;  (let ((relative-coordinate
;;	 (coordinates-in-window-p (car event) (selected-window)))
;;	(abs-y (car (cdr (car event)))))
;;    (if (consp relative-coordinate)
;;	(progn
;;	  (save-excursion
;;	    (move-to-window-line (car (cdr relative-coordinate)))
;;	    (x-draw-rectangle
;;	     (selected-screen)
;;	     abs-y 0
;;	     (save-excursion
;;		 (move-to-window-line (car (cdr relative-coordinate)))
;;		 (end-of-line)
;;		 (push-mark nil t)
;;		 (beginning-of-line)
;;		 (- (region-end) (region-beginning))) 1))
;;	  (sit-for 1)
;;	  (x-erase-rectangle (selected-screen))))))
;;
;;(defvar last-line-drawn nil)
;;(defvar begin-delim "[^ \t]")
;;(defvar end-delim   "[^ \t]")
;;
;;(defun mouse-boxing (event)
;;  (interactive "@e")
;;  (save-excursion
;;    (let ((screen (selected-screen)))
;;      (while (= (x-mouse-events) 0)
;;	(let* ((pos (read-mouse-position screen))
;;	       (abs-x (car pos))
;;	       (abs-y (cdr pos))
;;	       (relative-coordinate
;;		(coordinates-in-window-p (` ((, abs-x) (, abs-y)))
;;					 (selected-window)))
;;	       (begin-reg nil)
;;	       (end-reg nil)
;;	       (end-column nil)
;;	       (begin-column nil))
;;	  (if (and (consp relative-coordinate)
;;		   (or (not last-line-drawn)
;;		       (not (= last-line-drawn abs-y))))
;;	      (progn
;;		(move-to-window-line (car (cdr relative-coordinate)))
;;		(if (= (following-char) 10)
;;		    ()
;;		  (progn
;;		    (setq begin-reg (1- (re-search-forward end-delim)))
;;		    (setq begin-column (1- (current-column)))
;;		    (end-of-line)
;;		    (setq end-reg (1+ (re-search-backward begin-delim)))
;;		    (setq end-column (1+ (current-column)))
;;		    (message "%s" (buffer-substring begin-reg end-reg))
;;		    (x-draw-rectangle screen
;;				      (setq last-line-drawn abs-y)
;;				      begin-column
;;				      (- end-column begin-column) 1))))))))))
;;
;;(defun mouse-erase-box ()
;;  (interactive)
;;  (if last-line-drawn
;;      (progn
;;	(x-erase-rectangle (selected-screen))
;;	(setq last-line-drawn nil))))

;;; (defun test-x-rectangle ()
;;;   (use-local-mouse-map (setq rectangle-test-map (make-sparse-keymap)))
;;;   (define-key rectangle-test-map mouse-motion-button-left 'mouse-boxing)
;;;   (define-key rectangle-test-map mouse-button-left-up 'mouse-erase-box))

;;
;; Here is how to do double clicking in lisp.  About to change.
;;

(defvar double-start nil)
(defconst double-click-interval 300
  "Max ticks between clicks")

(defun double-down (event)
  (interactive "@e")
  (if double-start
      (let ((interval (- (nth 4 event) double-start)))
	(if (< interval double-click-interval)
	    (progn
	      (backward-up-list 1)
	      ;;      (message "Interval %d" interval)
	      (sleep-for 1)))
	(setq double-start nil))
    (setq double-start (nth 4 event))))
    
(defun double-up (event)
  (interactive "@e")
  (and double-start
       (> (- (nth 4 event ) double-start) double-click-interval)
       (setq double-start nil)))

;;; (defun x-test-doubleclick ()
;;;   (use-local-mouse-map (setq doubleclick-test-map (make-sparse-keymap)))
;;;   (define-key doubleclick-test-map mouse-button-left 'double-down)
;;;   (define-key doubleclick-test-map mouse-button-left-up 'double-up))

;;
;; This scrolls while button is depressed.  Use preferable in scrollbar.
;;

(defvar scrolled-lines 0)
(defconst scroll-speed 1)

(defun incr-scroll-down (event)
  (interactive "@e")
  (setq scrolled-lines 0)
  (incremental-scroll scroll-speed))

(defun incr-scroll-up (event)
  (interactive "@e")
  (setq scrolled-lines 0)
  (incremental-scroll (- scroll-speed)))

(defun incremental-scroll (n)
  (while (= (x-mouse-events) 0)
    (setq scrolled-lines (1+ (* scroll-speed scrolled-lines)))
    (scroll-down n)
    (sit-for 300 t)))

(defun incr-scroll-stop (event)
  (interactive "@e")
  (message "Scrolled %d lines" scrolled-lines)
  (setq scrolled-lines 0)
  (sleep-for 1))

;;; (defun x-testing-scroll ()
;;;   (let ((scrolling-map (function mouse-vertical-scroll-bar-prefix)))
;;;     (define-key scrolling-map mouse-button-left 'incr-scroll-down)
;;;     (define-key scrolling-map mouse-button-right 'incr-scroll-up)
;;;     (define-key scrolling-map mouse-button-left-up 'incr-scroll-stop)
;;;     (define-key scrolling-map mouse-button-right-up 'incr-scroll-stop)))

;;
;; Some playthings suitable for picture mode?  They need work.
;;

(defun mouse-kill-rectangle (event)
  "Kill the rectangle between point and the mouse cursor."
  (interactive "@e")
  (let ((point-save (point)))
    (save-excursion
      (mouse-set-point event)
      (push-mark nil t)
      (if (> point-save (point))
	  (kill-rectangle (point) point-save)
	(kill-rectangle point-save (point))))))

(defun mouse-open-rectangle (event)
  "Kill the rectangle between point and the mouse cursor."
  (interactive "@e")
  (let ((point-save (point)))
    (save-excursion
      (mouse-set-point event)
      (push-mark nil t)
      (if (> point-save (point))
	  (open-rectangle (point) point-save)
	(open-rectangle point-save (point))))))

;; Must be a better way to do this.

(defun mouse-multiple-insert (n char)
  (while (> n 0)
    (insert char)
    (setq n (1- n))))

;; What this could do is not finalize until button was released.

(defun mouse-move-text (event)
  "Move text from point to cursor position, inserting spaces."
  (interactive "@e")
  (let* ((relative-coordinate
	  (coordinates-in-window-p (car event) (selected-window))))
    (if (consp relative-coordinate)
	(cond ((> (current-column) (car relative-coordinate))
	       (delete-char
		(- (car relative-coordinate) (current-column))))
	      ((< (current-column) (car relative-coordinate))
	       (mouse-multiple-insert
		(- (car relative-coordinate) (current-column)) " "))
	      ((= (current-column) (car relative-coordinate)) (ding))))))


;;; Bindings for mouse commands.

;; This won't be needed once the drag and down events
;; are properly implemented.
(global-set-key   [mouse-1]	'mouse-set-point)

(global-set-key   [down-mouse-1]	'mouse-set-point)
(global-set-key   [drag-mouse-1]	'mouse-set-mark)
(global-set-key   [mouse-2]	'mouse-yank-at-click)
(global-set-key   [mouse-3]	'mouse-kill-ring-save)
(global-set-key   [S-mouse-3]	'mouse-kill)

(global-set-key   [C-mouse-1]	'mouse-buffer-menu)

;; Replaced with dragging mouse-1
;; (global-set-key [S-mouse-1]	'mouse-set-mark)

;; Define the mouse help menu tree.

(defvar help-menu-map '(keymap "Help"))
(global-set-key [C-mouse-2] help-menu-map)

(defvar help-apropos-map '(keymap "Is there a command that..."))
(defvar help-keys-map '(keymap "Key Commands <==> Functions"))
(defvar help-manual-map '(keymap "Manual and tutorial"))
(defvar help-misc-map '(keymap "Odds and ends"))
(defvar help-modes-map '(keymap "Modes"))
(defvar help-admin-map '(keymap "Administrivia"))

(define-key help-menu-map [apropos]
  (cons "@Is there a command that..." help-apropos-map))
(define-key help-menu-map [keys]
  (cons "@Key Commands <==> Functions" help-keys-map))
(define-key help-menu-map [manuals]
  (cons "@Manual and tutorial" help-manual-map))
(define-key help-menu-map [misc]
  (cons "@Odds and ends" help-misc-map))
(define-key help-menu-map [modes]
  (cons "@Modes" help-modes-map))
(define-key help-menu-map [admin]
  (cons "@Administrivia" help-admin-map))

(define-key help-apropos-map "c" '("Command Apropos" . command-apropos))
(define-key help-apropos-map "a" '("Apropos" . apropos))

(define-key help-keys-map "b"
  '("List all keystroke commands" . describe-bindings))
(define-key help-keys-map "c"
  '("Describe key briefly" . describe-key-briefly))
(define-key help-keys-map "k"
  '("Describe key verbose" . describe-key))
(define-key help-keys-map "f"
  '("Describe Lisp function" . describe-function))
(define-key help-keys-map "w"
  '("Where is this command" . where-is))

(define-key help-manual-map "i" '("Info system" . info))
(define-key help-manual-map "t"
  '("Invoke Emacs tutorial" . help-with-tutorial))

(define-key help-misc-map "l" '("Last 100 Keystrokes" . view-lossage))
(define-key help-misc-map "s" '("Describe syntax table" . describe-syntax))

(define-key help-modes-map "m"
  '("Describe current major mode" . describe-mode))
(define-key help-modes-map "b"
  '("List all keystroke commands" . describe-bindings))

(define-key help-admin-map "n"
  '("view Emacs news" . view-emacs-news))
(define-key help-admin-map "l"
  '("View the GNU Emacs license" . describe-copying))
(define-key help-admin-map "d"
  '("Describe distribution" . describe-distribution))
(define-key help-admin-map "w"
  '("Describe (non)warranty" . describe-no-warranty))

(provide 'mouse)

;;; mouse.el ends here
