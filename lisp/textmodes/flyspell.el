;;; flyspell.el --- On-the-fly spell checker

;; Copyright (C) 1998 Free Software Foundation, Inc.

;; Author: Manuel Serrano <Manuel.Serrano@unice.fr>
;; version 1.2h
;; new version may be found at:
;;   
;;       http://kaolin.unice.fr/~serrano

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
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; commentary:
;;
;; Flyspell is a minor Emacs mode performing on-the-fly spelling
;; checking.  It requires `font-lock' and `ispell'.  It has been
;; tested on gnu-emacs 19.29, 19.34 and Xemacs 19.15.
;;                                                                  
;; To install it, copy the flyspell.el file in your Emacs path and
;; add to your .emacs file:
;; `(autoload 'flyspell-mode "flyspell" "On-the-fly Ispell." t)'
;;                                                                  
;; To enter the flyspell minor mode, Meta-x flyspell-mode.
;;                                                                  
;; Note: consider setting the variable ispell-parser to 'tex to
;; avoid TeX command checking (use `(setq ispell-parser 'tex)')
;; _before_ entering flyspell.
;;                                                                  
;; Some user variables control the behavior of flyspell.  They are
;; those defined under the `User variables' comment.
;; 
;; Note: as suggested by Yaron M.  Minsky, if you use flyspell when
;; sending mails, you should add the following:
;;    (add-hook 'mail-send-hook 'flyspell-mode-off)
;; -------------------------------------------------------------
;; Release 1.2h:
;;    - Fix a bug on mouse-2 (yank-at-click) for gnu-emacs.
;; Release 1.2g:
;;    - Support for flyspell-generic-check-word-p (has suggested
;;      by Eric M.  Ludlam).
;;    - Compliance to emacs-lisp comments.
;; Release 1.2f:
;;    - Improved TeX handling.
;;    - Improved word fetch implementation.
;;    - flyspell-sort-corrections was not used inside
;;      flyspell-auto-correct-word.  The consequence was that auto
;;      corrections where not sorted even if the variable was set
;;      to non-nil.
;;    - Support for flyspell-multi-language-p variable.  Setting
;;      this variable to nil will prevent flyspell to spawn a new
;;      Ispell process per buffer.
;; Release 1.2e:
;;    - Fix two popup bugs on Xemacs.  If no replacement words are
;;      proposed only the save option is available.  Corrected words
;;      were not inserted at the correct position in the buffer.
;;    - Addition of flyspell-region and flyspell-buffer.
;; Release 1.2d:
;;    - Make-face-... expressions are now enclosed in
;;      condition-case expressions.
;;    - Fix bugs when flyspell-auto-correct-binding is set to nil
;;      (thanks to Eli Tziperman).
;; Release 1.2c:
;;    - Fix the overlay keymap problem for Emacs (it was correctly
;;      working with Xemacs).
;;    - Thanks to Didier Remy, flyspell now uses a cache in order
;;      to improve efficiency and make uses of a pre-command-hook
;;      in order to check a word when living it.
;;    - Remaned flyspell-ignore-command into
;;      flyspell-delay-command.
;;    - Add the flyspell-issue-welcome (as suggested by Joshua
;;      Guttman).
;;    - Ispell process are now killed when the buffer they are
;;      running in is deleted (thanks to Jeff Miller and Roland
;;      Rosenfled).
;;    - When used on a B&W terminal flyspell used boldness instead
;;      of color for incorrect words.
;; Release 1.2:
;;    - Breaks (space or newline) inside incorrect words are now
;;      better handled.
;;    - Flyspell sorts the proposed replacement words (thanks to
;;      Carsten Dominik).  See new variable
;;      `flyspell-sort-corrections'.
;;    - The mouse binding to correct mispelled word is now mouse-2
;;      on an highlighted region.  This enhancement (as well as a
;;      lot of code cleaning) has been acheived by Carsten Dominik.
;;    - flyspell-mode arg is now optional.
;;    - flyspell bindings are better displayed.
;;    - flyspell nows is able to handle concurent and different
;;      dictionaries (that each buffer running flyspell uses its
;;      own (buffer local) Ispell process).
;;    - default value for flyspell-highlight-property has been
;;      turned to t.
;;    - flyspell popup menus now support session and buffer
;;      dictionaries.
;;    - corrected words are now correctly unhighlighted (no
;;      highlighted characters left).
;;    Note: I think emacs-19.34 has a bug on the overlay event
;;      handling.  When an overlay (or a text property) has uses a
;;      local-map, if this map does not include a key binding,
;;      instead of looking at the enclosing local-map emacs-19.34
;;      uses the global-map.  I have not tested this with emacs-20.
;;      I have checked with Xemacs that does contain this error.
;; Release 1.1:
;;    - Add an automatic replacement for incorrect word.
;; Release 1.0:
;;    - Add popup menu for fast correction.
;; Release 0.9:
;;    - Add an Ispell bug workaround.  Now, in french mode, word
;;      starting by the '-' character does not, any longer, make
;;      Ispell to fall in infinite loops.
;; Release 0.8:
;;    - Better Xemacs support
;; Release 0.7:
;;    - Rather than hard-coding the ignored commend I now uses a
;;      property field to check if a command is ignored.  The
;;      advantage is that user may now add its own ignored
;;      commands.
;; Release 0.6:
;;    - Fix flyspell mode name (in modeline bar) bug.
;;    - Fix the bug on flyspell quitting.  Overlays are now really
;;      removed.
;; Release 0.5:
;;    - Persistent hilightings.
;;    - Refresh of the modeline on flyspell ending
;;    - Do not hilight text with properties (e.g.  font lock text)

;;; Code:
(require 'font-lock)
(require 'ispell)

;*---------------------------------------------------------------------*/
;*    defcustom stuff. This ensure that we have the correct custom     */
;*    library.                                                         */
;*---------------------------------------------------------------------*/
(eval-and-compile
  (condition-case () (require 'custom) (error nil))
  (if (and (featurep 'custom) (fboundp 'custom-declare-variable))
      ;; We have got what we need
      (if (not (string-match "XEmacs" emacs-version))
          ;; suppress warnings
          (progn
            ;; This is part of bytecomp.el in 19.35:
            (put 'custom-declare-variable 'byte-hunk-handler
                 'byte-compile-file-form-custom-declare-variable)
            (defun byte-compile-file-form-custom-declare-variable (form)
	      (if (memq 'free-vars byte-compile-warnings)
		  (setq byte-compile-bound-variables
			(cons (nth 1 (nth 1 form))
			      byte-compile-bound-variables)))
	      form)))
    ;; We have the old custom-library, hack around it!
    (defmacro defgroup (&rest args) nil)
    (defmacro defcustom (var value doc &rest args)
      (` (defvar (, var) (, value) (, doc))))))

(defgroup flyspell nil
  "Spellchecking on the fly."
  :tag "FlySpell"
  :prefix "flyspell-"
  :group 'processes)

;*---------------------------------------------------------------------*/
;*    User variables ...                                               */
;*---------------------------------------------------------------------*/
(defcustom flyspell-highlight-flag t
  "*Non-nil means use highlight, nil means use mini-buffer messages."
  :group 'flyspell
  :type 'boolean)

(defcustom flyspell-doublon-as-error-flag t
  "*Non-nil means consider doublon as misspelling."
  :group 'flyspell
  :type 'boolean)

(defcustom flyspell-sort-corrections t
  "*Non-nil means, sort the corrections alphabetically before popping them."
  :group 'flyspell
  :type 'boolean)

(defcustom flyspell-incorrect-color "OrangeRed"
  "*The color used for highlighting incorrect words."
  :group 'flyspell
  :type 'string)

(defcustom flyspell-duplicate-color "Gold3"
  "*The color used for highlighting incorrect words but appearing at least twice."
  :group 'flyspell
  :type 'string)

(defcustom flyspell-underline-p t
  "*Non-nil means, incorrect words are underlined."
  :group 'flyspell
  :type 'boolean)

(defcustom flyspell-auto-correct-binding
  "\M-\t"
  "*Non-nil means that its value (a binding) will bound to the flyspell
auto-correct."
  :group 'flyspell
  :type '(choice (const nil string)))

(defcustom flyspell-command-hook t
  "*Non-nil means that `post-command-hook' is used to check
already typed words."
  :group 'flyspell
  :type 'boolean)

(defcustom flyspell-duplicate-distance -1
  "*The distance from duplication.
-1 means no limit.
0 means no window."
  :group 'flyspell
  :type 'number)

(defcustom flyspell-delay 3
  "*The number of second before checking words on post-command-hook if
the current command is a delay command."
  :group 'flyspell
  :type 'number)

(defcustom flyspell-persistent-highlight t
  "*T means that hilighted words are not removed until the word are corrected."
  :group 'flyspell
  :type 'boolean)

(defcustom flyspell-highlight-properties t
  "*T means highlight incorrect words even if a property exists for this word."
  :group 'flyspell
  :type 'boolean)

(defcustom flyspell-default-delayed-commands
  '(self-insert-command
    delete-backward-char
    delete-char)
  "The list of always delayed command (that is flyspell is not activated
after any of these commands."
  :group 'flyspell
  :type '(repeat (symbol)))

(defcustom flyspell-delayed-commands
  nil
  "*If non nil, this variable must hold a list a symbol. Each symbol is
the name of an delayed command (that is a command that does not activate
flyspell checking."
  :group 'flyspell
  :type '(repeat (symbol)))

(defcustom flyspell-issue-welcome-flag t
  "*Non-nil means that flyspell issues a welcome message when started."
  :group 'flyspell
  :type 'boolean)

(defcustom flyspell-consider-dash-as-word-delimiter-flag nil
  "*Non-nil means that the `-' char is considered as a word delimiter."
  :group 'flyspell
  :type 'boolean)

(defcustom flyspell-incorrect-hook nil
  "*Non-nil means a list of hooks to be executed when incorrect
words are encountered. Each hook is a function of two arguments that are
location of the beginning and the end of the incorrect region."
  :group 'flyspell)

(defcustom flyspell-multi-language-p t
  "*Non-nil means that flyspell could be use with several buffers checking
several languages. Non-nil means that a new ispell process will be spawned
per buffer. If nil, only one unique ispell process will be running."
  :group 'flyspell
  :type 'boolean)

;*---------------------------------------------------------------------*/
;*    Mode specific options                                            */
;*    -------------------------------------------------------------    */
;*    Mode specific options enable users to disable flyspell on        */
;*    certain word depending of the emacs mode. For instance, when     */
;*    using flyspell with mail-mode add the following expression       */
;*    in your .emacs file:                                             */
;*       (add-hook 'mail-mode                                          */
;*    	     '(lambda () (setq flyspell-generic-check-word-p           */
;*    			       'mail-mode-flyspell-verify)))           */
;*---------------------------------------------------------------------*/
(defvar flyspell-generic-check-word-p nil
  "Function providing per-mode customization over which words are flyspelled.
Returns t to continue checking, nil otherwise.")
(make-variable-buffer-local 'flyspell-generic-check-word-p)

(defun mail-mode-flyspell-verify ()
  "Return t if we want flyspell to check the word under point."
  (save-excursion
    (not (or (re-search-forward mail-header-separator nil t)
	     (re-search-backward message-signature-separator nil t)
	     (progn
	       (beginning-of-line)
	       (looking-at "[>}|]"))))))

(defun texinfo-mode-flyspell-verify ()
  "Return t if we want flyspell to check the word under point."
  (save-excursion
    (forward-word -1)
    (not (looking-at "@"))))

;*---------------------------------------------------------------------*/
;*    Overlay compatibility                                            */
;*---------------------------------------------------------------------*/
(autoload 'make-overlay        "overlay" "" t)
(autoload 'move-overlay        "overlay" "" t)
(autoload 'overlayp            "overlay" "" t)
(autoload 'overlay-properties  "overlay" "" t)
(autoload 'overlays-in         "overlay" "" t)
(autoload 'delete-overlay      "overlay" "" t)
(autoload 'overlays-at         "overlay" "" t)
(autoload 'overlay-put         "overlay" "" t)
(autoload 'overlay-get         "overlay" "" t)

(defun flyspell-font-lock-make-face (l)
  "Because emacs and xemacs does not behave the same I uses my owe
font-lock-make-face function. This function is similar to the gnu-emacs
font-lock-make-face function."
  (let ((fname (car l))
	(color (car (cdr l)))
	(italic (car (cdr (cdr l))))
	(bold (car (cdr (cdr (cdr l)))))
	(underline (car (cdr (cdr (cdr (cdr l)))))))
    (let ((face (copy-face 'default fname)))
      (if color
	  (set-face-foreground face color))
      (if (and italic bold)
	  (condition-case nil
	      (make-face-bold-italic face)
	    (error nil))
	(progn
	  (if italic
	      (condition-case nil
		  (make-face-italic face)
		(error nil)))
	  (if bold
	      (condition-case nil
		  (make-face-bold face)
		(error nil)))))
      (if underline
	  (condition-case nil
	      (set-face-underline-p face t)
	    (error nil)))
      (if (not (x-display-color-p))
	  (condition-case nil
	      (make-face-bold face)
	    (error nil)))
      face)))

;*---------------------------------------------------------------------*/
;*    Which emacs are we currently running                             */
;*---------------------------------------------------------------------*/
(defvar flyspell-emacs
  (cond
   ((string-match "XEmacs" emacs-version)
    'xemacs)
   (t
    'emacs))
  "The Emacs we are currently running.")

;*---------------------------------------------------------------------*/
;*    cl compatibility                                                 */
;*---------------------------------------------------------------------*/
(defmacro push (x place)
  "(push X PLACE): insert X at the head of the list stored in PLACE.
Analogous to (setf PLACE (cons X PLACE)), though more careful about
evaluating each argument only once and in the right order.  PLACE has
to be a symbol."
  (list 'setq place (list 'cons x place)))

;*---------------------------------------------------------------------*/
;*    The minor mode declaration.                                      */
;*---------------------------------------------------------------------*/
(defvar flyspell-mode nil)
(make-variable-buffer-local 'flyspell-mode)

(defvar flyspell-mode-map (make-sparse-keymap))
(defvar flyspell-mouse-map (make-sparse-keymap))

(or (assoc 'flyspell-mode minor-mode-alist)
    (push '(flyspell-mode " Fly") minor-mode-alist))

(or (assoc 'flyspell-mode minor-mode-map-alist)
    (push (cons 'flyspell-mode flyspell-mode-map) minor-mode-map-alist))

(if flyspell-auto-correct-binding
    (define-key flyspell-mode-map flyspell-auto-correct-binding
      (function flyspell-auto-correct-word)))
;; mouse bindings
(if (eq flyspell-emacs 'xemacs)
    (define-key flyspell-mouse-map [(button2)]
      (function flyspell-correct-word/mouse-keymap))
  (define-key flyspell-mode-map [(mouse-2)]
    (function flyspell-correct-word/local-keymap)))

;; the name of the overlay property that defines the keymap
(defvar flyspell-overlay-keymap-property-name
  (if (string-match "19.*XEmacs" emacs-version)
      'keymap
    'local-map))
  
;*---------------------------------------------------------------------*/
;*    Highlighting                                                     */
;*---------------------------------------------------------------------*/
(flyspell-font-lock-make-face (list 'flyspell-incorrect-face
				    flyspell-incorrect-color
				    nil
				    t
				    flyspell-underline-p))
(flyspell-font-lock-make-face (list 'flyspell-duplicate-face
				    flyspell-duplicate-color
				    nil
				    t
				    flyspell-underline-p))

(defvar flyspell-overlay nil)

;*---------------------------------------------------------------------*/
;*    flyspell-mode ...                                                */
;*---------------------------------------------------------------------*/
;;;###autoload
(defun flyspell-mode (&optional arg)
  "Minor mode performing on-the-fly spelling checking.
Ispell is automatically spawned on background for each entered words.
The default flyspells behavior is to highlight incorrect words.
With prefix ARG, turn Flyspell minor mode on iff ARG is positive.
  
Bindings:
\\[ispell-word]: correct words (using Ispell).
\\[flyspell-auto-correct-word]: automatically correct word.
\\[flyspell-correct-word] (or mouse-2): popup correct words.

Hooks:
flyspell-mode-hook is runner after flyspell is entered.

Remark:
`flyspell-mode' uses `ispell-mode'.  Thus all Ispell options are
valid.  For instance, a personal dictionary can be used by
invoking `ispell-change-dictionary'.

Consider using the `ispell-parser' to check your text.  For instance
consider adding:
(add-hook 'tex-mode-hook (function (lambda () (setq ispell-parser 'tex))))
in your .emacs file.

flyspell-region checks all words inside a region.

flyspell-buffer checks the whole buffer."
  (interactive "P")
  ;; we set the mode on or off
  (setq flyspell-mode (not (or (and (null arg) flyspell-mode)
			       (<= (prefix-numeric-value arg) 0))))
  (if flyspell-mode
      (flyspell-mode-on)
    (flyspell-mode-off))
  ;; we force the modeline re-printing
  (set-buffer-modified-p (buffer-modified-p)))

;*---------------------------------------------------------------------*/
;*    flyspell-mode-on ...                                             */
;*---------------------------------------------------------------------*/
(defun flyspell-mode-on ()
  "Turn flyspell mode on.  Do not use, use `flyspell-mode' instead."
  (message "flyspell on: %S" (current-buffer))
  (setq ispell-highlight-face 'flyspell-incorrect-face)
  ;; ispell initialization
  (if flyspell-multi-language-p
      (progn
	(make-variable-buffer-local 'ispell-dictionary)
	(make-variable-buffer-local 'ispell-process)
	(make-variable-buffer-local 'ispell-filter)
	(make-variable-buffer-local 'ispell-filter-continue)
	(make-variable-buffer-local 'ispell-process-directory)
	(make-variable-buffer-local 'ispell-parser)))
  ;; we initialize delayed commands symbol
  (flyspell-delay-commands)
  ;; we bound flyspell action to post-command hook
  (if flyspell-command-hook
      (progn
	(make-local-hook 'post-command-hook)
	(add-hook 'post-command-hook
		  (function flyspell-post-command-hook)
		  t
		  t)))
  ;; we bound flyspell action to pre-command hook
  (if flyspell-command-hook
      (progn
	(make-local-hook 'pre-command-hook)
	(add-hook 'pre-command-hook
		  (function flyspell-pre-command-hook)
		  t
		  t)))
  ;; the welcome message
  (if flyspell-issue-welcome-flag
      (message
       (if flyspell-auto-correct-binding
	   (format "Welcome to flyspell. Use %S or mouse-2 to correct words."
		   (key-description flyspell-auto-correct-binding))
	 "Welcome to flyspell. Use mouse-2 to correct words.")))
  ;; we have to kill the flyspell process when the buffer is deleted.
  ;; (thanks to Jeff Miller and Roland Rosenfeld who sent me this
  ;; improvement).
  (add-hook 'kill-buffer-hook
	    '(lambda ()
	       (if flyspell-mode
		   (flyspell-mode-off))))
  ;; we end with the flyspell hooks
  (run-hooks 'flyspell-mode-hook))

;*---------------------------------------------------------------------*/
;*    flyspell-delay-commands ...                                      */
;*---------------------------------------------------------------------*/
(defun flyspell-delay-commands ()
  "Install the delayed command."
  (mapcar 'flyspell-delay-command flyspell-default-delayed-commands)
  (mapcar 'flyspell-delay-command flyspell-delayed-commands))

;*---------------------------------------------------------------------*/
;*    flyspell-delay-command ...                                       */
;*---------------------------------------------------------------------*/
(defun flyspell-delay-command (command)
  "Set COMMAND to be delayed.
When flyspell `post-command-hook' is invoked because a delayed command
as been used the current word is not immediatly checked.
It will be checked only after flyspell-delay second."
  (interactive "Scommand: ")
  (put command 'flyspell-delayed t))

;*---------------------------------------------------------------------*/
;*    flyspell-ignore-commands ...                                     */
;*---------------------------------------------------------------------*/
(defun flyspell-ignore-commands ()
  "This is an obsolete function, use flyspell-delays command instead."
  (flyspell-delay-commands))

;*---------------------------------------------------------------------*/
;*    flyspell-ignore-command ...                                      */
;*---------------------------------------------------------------------*/
(defun flyspell-ignore-command (command)
  "This is an obsolete function, use flyspell-delay command instead.
COMMAND is the name of the command to be delayed."
  (flyspell-delay-command command))

(make-obsolete 'flyspell-ignore-commands 'flyspell-delay-commands)
(make-obsolete 'flyspell-ignore-command 'flyspell-delay-command)

;*---------------------------------------------------------------------*/
;*    flyspell-word-cache ...                                          */
;*---------------------------------------------------------------------*/
(defvar flyspell-word-cache-start  nil)
(defvar flyspell-word-cache-end    nil)
(defvar flyspell-word-cache-word   nil)
(make-variable-buffer-local 'flyspell-word-cache-start)
(make-variable-buffer-local 'flyspell-word-cache-end)
(make-variable-buffer-local 'flyspell-word-cache-word)

;*---------------------------------------------------------------------*/
;*    The flyspell pre-hook, store the current position. In the        */
;*    post command hook, we will check, if the word at this position   */
;*    has to be spell checked.                                         */
;*---------------------------------------------------------------------*/
(defvar flyspell-pre-buffer nil)
(defvar flyspell-pre-point  nil)

;*---------------------------------------------------------------------*/
;*    flyspell-pre-command-hook ...                                    */
;*---------------------------------------------------------------------*/
(defun flyspell-pre-command-hook ()
  "This function is internally used by Flyspell to get a cursor location
before a user command."
  (interactive)
  (setq flyspell-pre-buffer (current-buffer))
  (setq flyspell-pre-point  (point)))

;*---------------------------------------------------------------------*/
;*    flyspell-mode-off ...                                            */
;*---------------------------------------------------------------------*/
(defun flyspell-mode-off ()
  "Turn flyspell mode off.  Do not use.  Use `flyspell-mode' instead."
  ;; the bye-bye message
  (message "Quiting Flyspell...%S" (current-buffer))
  ;; we stop the running ispell
  (ispell-kill-ispell t)
  ;; we remove the hooks
  (if flyspell-command-hook
      (progn
	(remove-hook 'post-command-hook
		     (function flyspell-post-command-hook)
		     t)
	(remove-hook 'pre-command-hook
		     (function flyspell-pre-command-hook)
		     t)))
  ;; we remove all the flyspell hilightings
  (flyspell-delete-all-overlays)
  ;; we have to erase pre cache variables
  (setq flyspell-pre-buffer nil)
  (setq flyspell-pre-point  nil)
  ;; we mark the mode as killed
  (setq flyspell-mode nil))

;*---------------------------------------------------------------------*/
;*    flyspell-check-word-p ...                                        */
;*---------------------------------------------------------------------*/
(defun flyspell-check-word-p ()
  "This function returns t when the word at `point' has to be
checked. The answer depends of several criteria. Mostly we
check word delimiters."
  (cond
   ((<= (- (point-max) 1) (point-min))
    ;; the buffer is not filled enough
    nil)
   ((not (and (symbolp this-command) (get this-command 'flyspell-delayed)))
    ;; the current command is not delayed, that
    ;; is that we must check the word now
    t)
   ((and (> (point) (point-min))
	 (save-excursion
	   (backward-char 1)
	   (and (looking-at (flyspell-get-not-casechars))
		(or flyspell-consider-dash-as-word-delimiter-flag
		    (not (looking-at "\\-"))))))
    ;; yes because we have reached or typed a word delimiter
    t)
   ((not (integerp flyspell-delay))
    ;; yes because the user had settup a non delay configuration
    t)
   (t
    (if (fboundp 'about-xemacs)
	(sit-for flyspell-delay nil)
      (sit-for flyspell-delay 0 nil)))))

;*---------------------------------------------------------------------*/
;*    flyspell-check-pre-word-p ...                                    */
;*---------------------------------------------------------------------*/
(defun flyspell-check-pre-word-p ()
  "When to we have to check the word that was at point before
the current command?"
  (cond
   ((or (not (numberp flyspell-pre-point))
	(not (bufferp flyspell-pre-buffer))
	(not (buffer-live-p flyspell-pre-buffer)))
    nil)
   ((or (= flyspell-pre-point (- (point) 1))
	(= flyspell-pre-point (point))
	(= flyspell-pre-point (+ (point) 1)))
    nil)
   ((not (eq (current-buffer) flyspell-pre-buffer))
    t)
   ((not (and (numberp flyspell-word-cache-start)
	      (numberp flyspell-word-cache-end)))
    t)
   (t
    (or (< flyspell-pre-point flyspell-word-cache-start)
	(> flyspell-pre-point flyspell-word-cache-end)))))
  
;*---------------------------------------------------------------------*/
;*    flyspell-post-command-hook ...                                   */
;*---------------------------------------------------------------------*/
(defun flyspell-post-command-hook ()
  "The `post-command-hook' used by flyspell to check a word in-the-fly."
  (interactive)
  (if (flyspell-check-word-p)
      (flyspell-word))
  (if (flyspell-check-pre-word-p)
      (save-excursion
	(set-buffer flyspell-pre-buffer)
	(save-excursion
	  (goto-char flyspell-pre-point)
	  (flyspell-word)))))

;*---------------------------------------------------------------------*/
;*    flyspell-word ...                                                */
;*---------------------------------------------------------------------*/
(defun flyspell-word (&optional following)
  "Spell check a word."
  (interactive (list current-prefix-arg))
  (if (interactive-p)
      (setq following ispell-following-word))
  (save-excursion
    (ispell-accept-buffer-local-defs)	; use the correct dictionary
    (let ((cursor-location (point))	; retain cursor location
	  (word (flyspell-get-word following))
	  start end poss)
      (if (or (eq word nil)
 	      (and (fboundp flyspell-generic-check-word-p)
 		   (not (funcall flyspell-generic-check-word-p))))
	  t
	(progn
	  ;; destructure return word info list.
	  (setq start (car (cdr word))
		end (car (cdr (cdr word)))
		word (car word))
	  ;; before checking in the directory, we check for doublons.
	  (cond
	   ((and flyspell-doublon-as-error-flag
		 (save-excursion
		   (goto-char start)
		   (word-search-backward word
					 (- start
					    (+ 1 (- end start)))
					 t)))
	    ;; yes, this is a doublon
	    (flyspell-highlight-incorrect-region start end))
	   ((and (eq flyspell-word-cache-start start)
		 (eq flyspell-word-cache-end end)
		 (string-equal flyspell-word-cache-word word))
	    ;; this word had been already checked, we skip
	    nil)
	   ((and (eq ispell-parser 'tex)
		 (flyspell-tex-command-p word))
	    ;; this is a correct word (because a tex command)
	    (flyspell-unhighlight-at start)
	    (if (> end start)
		(flyspell-unhighlight-at (- end 1)))
	    t)
	   (t
	    ;; we setup the cache
	    (setq flyspell-word-cache-start start)
	    (setq flyspell-word-cache-end end)
	    (setq flyspell-word-cache-word word)
	    ;; now check spelling of word.
	    (process-send-string ispell-process "%\n")
	    ;; put in verbose mode
	    (process-send-string ispell-process
				 (concat "^" word "\n"))
	    ;; wait until ispell has processed word
	    (while (progn
		     (accept-process-output ispell-process)
		     (not (string= "" (car ispell-filter)))))
	    ;; (process-send-string ispell-process "!\n")
	    ;; back to terse mode.
	    (setq ispell-filter (cdr ispell-filter))
	    (if (listp ispell-filter)
		(setq poss (ispell-parse-output (car ispell-filter))))
	    (cond ((eq poss t)
		   ;; correct
		   (flyspell-unhighlight-at start)
		   (if (> end start)
		       (flyspell-unhighlight-at (- end 1)))
		   t)
		  ((and (stringp poss) flyspell-highlight-flag)
		   ;; correct
		   (flyspell-unhighlight-at start)
		   (if (> end start)
		       (flyspell-unhighlight-at (- end 1)))
		   t)
		  ((null poss)
		   (flyspell-unhighlight-at start)
		   (if (> end start)
		       (flyspell-unhighlight-at (- end 1)))
		   (message "Error in ispell process"))
		  ((or (and (< flyspell-duplicate-distance 0)
			    (or (save-excursion
				  (goto-char start)
				  (word-search-backward word
							(point-min)
							t))
				(save-excursion
				  (goto-char end)
				  (word-search-forward word
						       (point-max)
						       t))))
		       (and (> flyspell-duplicate-distance 0)
			    (or (save-excursion
				  (goto-char start)
				  (word-search-backward
				   word
				   (- start
				      flyspell-duplicate-distance)
				   t))
				(save-excursion
				  (goto-char end)
				  (word-search-forward
				   word
				   (+ end
				      flyspell-duplicate-distance)
				   t)))))
		   (if flyspell-highlight-flag
		       (flyspell-highlight-duplicate-region start end)
		     (message (format "misspelling duplicate `%s'"
				      word))))
		  (t
		   ;; incorrect highlight the location
		   (if flyspell-highlight-flag
		       (flyspell-highlight-incorrect-region start end)
		     (message (format "mispelling `%s'" word)))))
	    (goto-char cursor-location) ; return to original location
	    (if ispell-quit (setq ispell-quit nil)))))))))

;*---------------------------------------------------------------------*/
;*    flyspell-tex-command-p ...                                       */
;*---------------------------------------------------------------------*/
(defun flyspell-tex-command-p (word)
  "Is a word a TeX command?"
  (eq (aref word 0) ?\\))

;*---------------------------------------------------------------------*/
;*    flyspell-casechars-cache ...                                     */
;*---------------------------------------------------------------------*/
(defvar flyspell-casechars-cache nil)
(defvar flyspell-ispell-casechars-cache nil)
(make-variable-buffer-local 'flyspell-casechars-cache)
(make-variable-buffer-local 'flyspell-ispell-casechars-cache)

;*---------------------------------------------------------------------*/
;*    flyspell-get-casechars ...                                       */
;*---------------------------------------------------------------------*/
(defun flyspell-get-casechars ()
  "This function builds a string that is the regexp of word chars.
In order
to avoid one useless string construction, this function changes the last
char of the ispell-casechars string."
  (let ((ispell-casechars (ispell-get-casechars)))
    (cond
     ((eq ispell-casechars flyspell-ispell-casechars-cache)
      flyspell-casechars-cache)
     ((not (eq ispell-parser 'tex))
      (setq flyspell-ispell-casechars-cache ispell-casechars)
      (setq flyspell-casechars-cache
	    (concat (substring ispell-casechars
			       0
			       (- (length ispell-casechars) 1))
		    "{}]"))
      flyspell-casechars-cache)
     (t
      (setq flyspell-ispell-casechars-cache ispell-casechars)
      (setq flyspell-casechars-cache ispell-casechars)
      flyspell-casechars-cache))))
	
;*---------------------------------------------------------------------*/
;*    flyspell-get-not-casechars-cache ...                             */
;*---------------------------------------------------------------------*/
(defvar flyspell-not-casechars-cache nil)
(defvar flyspell-ispell-not-casechars-cache nil)
(make-variable-buffer-local 'flyspell-not-casechars-cache)
(make-variable-buffer-local 'flyspell-ispell-not-casechars-cache)

;*---------------------------------------------------------------------*/
;*    flyspell-get-not-casechars ...                                   */
;*---------------------------------------------------------------------*/
(defun flyspell-get-not-casechars ()
  "This function builds a string that is the regexp of non-word chars."
  (let ((ispell-not-casechars (ispell-get-not-casechars)))
    (cond
     ((eq ispell-not-casechars flyspell-ispell-not-casechars-cache)
      flyspell-not-casechars-cache)
     ((not (eq ispell-parser 'tex))
      (setq flyspell-ispell-not-casechars-cache ispell-not-casechars)
      (setq flyspell-not-casechars-cache
	    (concat (substring ispell-not-casechars
			       0
			       (- (length ispell-not-casechars) 1))
		    "{}]"))
      flyspell-not-casechars-cache)
     (t
      (setq flyspell-ispell-not-casechars-cache ispell-not-casechars)
      (setq flyspell-not-casechars-cache ispell-not-casechars)
      flyspell-not-casechars-cache))))

;*---------------------------------------------------------------------*/
;*    flyspell-get-word ...                                            */
;*---------------------------------------------------------------------*/
(defun flyspell-get-word (following)
  "Return the word for spell-checking according to Ispell syntax.
If optional argument FOLLOWING is non-nil or if `ispell-following-word'
is non-nil when called interactively, then the following word
\(rather than preceding\) is checked when the cursor is not over a word.
Optional second argument contains otherchars that can be included in word
many times.

Word syntax described by `ispell-dictionary-alist' (which see)."
  (let* ((flyspell-casechars (flyspell-get-casechars))
	 (flyspell-not-casechars (flyspell-get-not-casechars))
	 (ispell-otherchars (ispell-get-otherchars))
	 (ispell-many-otherchars-p (ispell-get-many-otherchars-p))
	 (word-regexp (concat flyspell-casechars
			      "+\\("
			      ispell-otherchars
			      "?"
			      flyspell-casechars
			      "+\\)"
			      (if ispell-many-otherchars-p
				  "*" "?")))
	 (tex-prelude "[\\\\{]")
	 (tex-regexp  (if (eq ispell-parser 'tex)
			  (concat tex-prelude "?" word-regexp "}?")
			word-regexp))
		      
	 did-it-once
	 start end word)
    ;; find the word
    (if (not (or (looking-at flyspell-casechars)
		 (and (eq ispell-parser 'tex)
		      (looking-at tex-prelude))))
	(if following
	    (re-search-forward flyspell-casechars (point-max) t)
	  (re-search-backward flyspell-casechars (point-min) t)))
    ;; move to front of word
    (re-search-backward flyspell-not-casechars (point-min) 'start)
    (let ((pos nil))
      (while (and (looking-at ispell-otherchars)
		  (not (bobp))
		  (or (not did-it-once)
		      ispell-many-otherchars-p)
		  (not (eq pos (point))))
	(setq pos (point))
	(setq did-it-once t)
	(backward-char 1)
	(if (looking-at flyspell-casechars)
	    (re-search-backward flyspell-not-casechars (point-min) 'move)
	  (backward-char -1))))
    ;; Now mark the word and save to string.
    (if (eq (re-search-forward tex-regexp (point-max) t) nil)
	nil
      (progn
	(setq start (match-beginning 0)
	      end (point)
	      word (buffer-substring start end))
	(list word start end)))))

;*---------------------------------------------------------------------*/
;*    flyspell-region ...                                              */
;*---------------------------------------------------------------------*/
(defun flyspell-region (beg end)
  "Flyspell text between BEG and END."
  (interactive "r")
  (save-excursion
    (goto-char beg)
    (while (< (point) end)
      (message "Spell Checking...%d%%" (* 100 (/ (float (point)) (- end beg))))
      (flyspell-word)
      (let ((cur (point)))
	(forward-word 1)
	(if (and (< (point) end) (> (point) (+ cur 1)))
	    (backward-char 1))))
    (backward-char 1)
    (message "Spell Checking...done")
    (flyspell-word)))

;*---------------------------------------------------------------------*/
;*    flyspell-buffer ...                                              */
;*---------------------------------------------------------------------*/
(defun flyspell-buffer ()
  "Flyspell whole buffer."
  (interactive)
  (flyspell-region (point-min) (point-max)))

;*---------------------------------------------------------------------*/
;*    flyspell-overlay-p ...                                           */
;*---------------------------------------------------------------------*/
(defun flyspell-overlay-p (o)
  "A predicate that return true iff O is an overlay used by flyspell."
  (and (overlayp o) (overlay-get o 'flyspell-overlay)))

;*---------------------------------------------------------------------*/
;*    flyspell-delete-all-overlays ...                                 */
;*    -------------------------------------------------------------    */
;*    Remove all the overlays introduced by flyspell.                  */
;*---------------------------------------------------------------------*/
(defun flyspell-delete-all-overlays ()
  "Delete all the overlays used by flyspell."
  (let ((l (overlays-in (point-min) (point-max))))
    (while (consp l)
      (progn
	(if (flyspell-overlay-p (car l))
	    (delete-overlay (car l)))
	(setq l (cdr l))))))

;*---------------------------------------------------------------------*/
;*    flyspell-unhighlight-at ...                                      */
;*---------------------------------------------------------------------*/
(defun flyspell-unhighlight-at (pos)
  "Remove the flyspell overlay that are located at POS."
  (if flyspell-persistent-highlight
      (let ((overlays (overlays-at pos)))
	(while (consp overlays)
	  (if (flyspell-overlay-p (car overlays))
	      (delete-overlay (car overlays)))
	  (setq overlays (cdr overlays))))
    (delete-overlay flyspell-overlay)))

;*---------------------------------------------------------------------*/
;*    flyspell-properties-at-p ...                                     */
;*    -------------------------------------------------------------    */
;*    Is there an highlight properties at position pos?                */
;*---------------------------------------------------------------------*/
(defun flyspell-properties-at-p (beg)
  "Return the text property at position BEG."
  (let ((prop (text-properties-at beg))
	(keep t))
    (while (and keep (consp prop))
      (if (and (eq (car prop) 'local-map) (consp (cdr prop)))
	  (setq prop (cdr (cdr prop)))
	(setq keep nil)))
    (consp prop)))

;*---------------------------------------------------------------------*/
;*    make-flyspell-overlay ...                                        */
;*---------------------------------------------------------------------*/
(defun make-flyspell-overlay (beg end face mouse-face)
  "Allocate a new flyspell overlay that will be used to hilight
an incorrect word."
  (let ((flyspell-overlay (make-overlay beg end)))
    (overlay-put flyspell-overlay 'face face)
    (overlay-put flyspell-overlay 'mouse-face mouse-face)
    (overlay-put flyspell-overlay 'flyspell-overlay t)
    (if (eq flyspell-emacs 'xemacs)
	(overlay-put flyspell-overlay
		     flyspell-overlay-keymap-property-name
		     flyspell-mouse-map))))
    
;*---------------------------------------------------------------------*/
;*    flyspell-highlight-incorrect-region ...                          */
;*---------------------------------------------------------------------*/
(defun flyspell-highlight-incorrect-region (beg end)
  "The setup of an overlay on a region (starting at BEG and ending at END)
that corresponds to an incorrect word."
  (run-hook-with-args 'flyspell-incorrect-hook beg end)
  (if (or (not (flyspell-properties-at-p beg)) flyspell-highlight-properties)
      (progn
	;; we cleanup current overlay at the same position
	(if (and (not flyspell-persistent-highlight)
		 (overlayp flyspell-overlay))
	    (delete-overlay flyspell-overlay)
	  (let ((overlays (overlays-at beg)))
	    (while (consp overlays)
	      (if (flyspell-overlay-p (car overlays))
		  (delete-overlay (car overlays)))
	      (setq overlays (cdr overlays)))))
	;; now we can use a new overlay
	(setq flyspell-overlay
	      (make-flyspell-overlay beg end
				     'flyspell-incorrect-face 'highlight)))))

;*---------------------------------------------------------------------*/
;*    flyspell-highlight-duplicate-region ...                          */
;*---------------------------------------------------------------------*/
(defun flyspell-highlight-duplicate-region (beg end)
  "The setup of an overlay on a region (starting at BEG and ending at END)
that corresponds to an duplicated word."
  (if (or (not (flyspell-properties-at-p beg)) flyspell-highlight-properties)
      (progn
	;; we cleanup current overlay at the same position
	(if (and (not flyspell-persistent-highlight)
		 (overlayp flyspell-overlay))
	    (delete-overlay flyspell-overlay)
	  (let ((overlays (overlays-at beg)))
	    (while (consp overlays)
	      (if (flyspell-overlay-p (car overlays))
		  (delete-overlay (car overlays)))
	      (setq overlays (cdr overlays)))))
	;; now we can use a new overlay
	(setq flyspell-overlay
	      (make-flyspell-overlay beg end
				     'flyspell-duplicate-face 'highlight)))))

;*---------------------------------------------------------------------*/
;*    flyspell-auto-correct-cache ...                                  */
;*---------------------------------------------------------------------*/
(defvar flyspell-auto-correct-pos nil)
(defvar flyspell-auto-correct-region nil)
(defvar flyspell-auto-correct-ring nil)

;*---------------------------------------------------------------------*/
;*    flyspell-auto-correct-word ...                                   */
;*---------------------------------------------------------------------*/
(defun flyspell-auto-correct-word (pos)
  "Auto correct the word at position POS."
  (interactive "d")
  ;; use the correct dictionary
  (ispell-accept-buffer-local-defs)
  (if (eq flyspell-auto-correct-pos pos)
      ;; we have already been using the function at the same location
      (progn
	(save-excursion
	  (let ((start (car flyspell-auto-correct-region))
		(len   (cdr flyspell-auto-correct-region)))
	    (delete-region start (+ start len))
	    (setq flyspell-auto-correct-ring (cdr flyspell-auto-correct-ring))
	    (let* ((word (car flyspell-auto-correct-ring))
		   (len  (length word)))
	      (rplacd flyspell-auto-correct-region len)
	      (goto-char start)
	      (insert word))))
	(setq flyspell-auto-correct-pos (point)))
    ;; retain cursor location
    (let ((cursor-location pos)
	  (word (flyspell-get-word nil))
	  start end poss)
      ;; destructure return word info list.
      (setq start (car (cdr word))
	    end (car (cdr (cdr word)))
	    word (car word))
      ;; now check spelling of word.
      (process-send-string ispell-process "%\n") ;put in verbose mode
      (process-send-string ispell-process (concat "^" word "\n"))
      ;; wait until ispell has processed word
      (while (progn
	       (accept-process-output ispell-process)
	       (not (string= "" (car ispell-filter)))))
      (setq ispell-filter (cdr ispell-filter))
      (if (listp ispell-filter)
	  (setq poss (ispell-parse-output (car ispell-filter))))
      (cond ((or (eq poss t) (stringp poss))
	     ;; don't correct word
	     t)
	    ((null poss)
	     ;; ispell error
	     (error "Ispell: error in Ispell process"))
	    (t
	     ;; the word is incorrect, we have to propose a replacement
	     (let ((replacements (if flyspell-sort-corrections
				     (sort (car (cdr (cdr poss))) 'string<)
				   (car (cdr (cdr poss))))))
	       (if (consp replacements)
		   (progn
		     (let ((replace (car replacements)))
		       (setq word replace)
		       (setq cursor-location (+ (- (length word) (- end start))
						cursor-location))
		       (if (not (equal word (car poss)))
			   (progn
			     ;; the save the current replacements
			     (setq flyspell-auto-correct-pos cursor-location)
			     (setq flyspell-auto-correct-region
				   (cons start (length word)))
			     (let ((l replacements))
			       (while (consp (cdr l))
				 (setq l (cdr l)))
			       (rplacd l (cons (car poss) replacements)))
			     (setq flyspell-auto-correct-ring
				   (cdr replacements))
			     (delete-region start end)
			     (insert word)))))))))
      ;; return to original location
      (goto-char cursor-location)
      (ispell-pdict-save t))))

;*---------------------------------------------------------------------*/
;*    flyspell-correct-word ...                                        */
;*---------------------------------------------------------------------*/
(defun flyspell-correct-word (event)
  "Check spelling of word under or before the cursor.
If the word is not found in dictionary, display possible corrections
in a popup menu allowing you to choose one.

Word syntax described by `ispell-dictionary-alist' (which see).

This will check or reload the dictionary.  Use \\[ispell-change-dictionary]
or \\[ispell-region] to update the Ispell process."
  (interactive "e")
  (if (eq flyspell-emacs 'xemacs)
      (flyspell-correct-word/mouse-keymap event)
      (flyspell-correct-word/local-keymap event)))
    
;*---------------------------------------------------------------------*/
;*    flyspell-correct-word/local-keymap ...                           */
;*---------------------------------------------------------------------*/
(defun flyspell-correct-word/local-keymap (event)
  "emacs 19.xx seems to be buggous. Overlay keymap does not seems
to work correctly with local map. That is, if a key is not
defined for the overlay keymap, the current local map, is not
checked. The binding is resolved with the global map. The
consequence is that we can not use overlay map with flyspell."
  (interactive "e")
  (save-window-excursion
    (let ((save (point)))
      (mouse-set-point event)
      ;; we look for a flyspell overlay here
      (let ((overlays (overlays-at (point)))
	    (overlay  nil))
	(while (consp overlays)
	  (if (flyspell-overlay-p (car overlays))
	      (progn
		(setq overlay (car overlays))
		(setq overlays nil))
	    (setq overlays (cdr overlays))))
	;; we return to the correct location
	(goto-char save)
	;; we check to see if button2 has been used overlay a
	;; flyspell overlay
	(if overlay
	    ;; yes, so we use the flyspell function
	    (flyspell-correct-word/mouse-keymap event)
	  ;; no so we have to use the non flyspell binding
	  (let ((flyspell-mode nil))
	    (if (key-binding (this-command-keys))
		(command-execute (key-binding (this-command-keys))))))))))
  
;*---------------------------------------------------------------------*/
;*    flyspell-correct-word ...                                        */
;*---------------------------------------------------------------------*/
(defun flyspell-correct-word/mouse-keymap (event)
  "Popup a menu to present possible correction. The word checked is the
word at the mouse position."
  (interactive "e")
  ;; use the correct dictionary
  (ispell-accept-buffer-local-defs)
  ;; retain cursor location (I don't know why but save-excursion here fails).
  (let ((save (point)))
    (mouse-set-point event)
    (let ((cursor-location (point))
	  (word (flyspell-get-word nil))
	  start end poss replace)
      ;; destructure return word info list.
      (setq start (car (cdr word))
	    end (car (cdr (cdr word)))
	    word (car word))
      ;; now check spelling of word.
      (process-send-string ispell-process "%\n") ;put in verbose mode
      (process-send-string ispell-process (concat "^" word "\n"))
      ;; wait until ispell has processed word
      (while (progn
	       (accept-process-output ispell-process)
	       (not (string= "" (car ispell-filter)))))
      (setq ispell-filter (cdr ispell-filter))
      (if (listp ispell-filter)
	  (setq poss (ispell-parse-output (car ispell-filter))))
      (cond ((or (eq poss t) (stringp poss))
	     ;; don't correct word
	     t)
	    ((null poss)
	     ;; ispell error
	     (error "Ispell: error in Ispell process"))
	    ((string-match "GNU" (emacs-version))
	     ;; the word is incorrect, we have to propose a replacement
	     (setq replace (flyspell-gnuemacs-popup event poss word))
	     (cond ((eq replace 'ignore)
		    nil)
		   ((eq replace 'save)
		    (process-send-string ispell-process (concat "*" word "\n"))
		    (flyspell-unhighlight-at cursor-location)
		    (setq ispell-pdict-modified-p '(t)))
		   ((or (eq replace 'buffer) (eq replace 'session))
		    (process-send-string ispell-process (concat "@" word "\n"))
		    (if (null ispell-pdict-modified-p)
			(setq ispell-pdict-modified-p
			      (list ispell-pdict-modified-p)))
		    (flyspell-unhighlight-at cursor-location)
		    (if (eq replace 'buffer)
			(ispell-add-per-file-word-list word)))
		   (replace
		    (setq word (if (atom replace) replace (car replace))
			  cursor-location (+ (- (length word) (- end start))
					     cursor-location))
		    (if (not (equal word (car poss)))
			(progn
			  (delete-region start end)
			  (insert word))))))
	    ((string-match "XEmacs" (emacs-version))
	     (flyspell-xemacs-popup
	      event poss word cursor-location start end)))
      (ispell-pdict-save t))
    (if (< save (point-max))
	(goto-char save)
      (goto-char (point-max)))))

;*---------------------------------------------------------------------*/
;*    flyspell-xemacs-correct ...                                      */
;*---------------------------------------------------------------------*/
(defun flyspell-xemacs-correct (replace poss word cursor-location start end)
  "The xemacs popup menu callback."
  (cond ((eq replace 'ignore)
	 nil)
	((eq replace 'save)
	 (process-send-string ispell-process (concat "*" word "\n"))
	 (flyspell-unhighlight-at cursor-location)
	 (setq ispell-pdict-modified-p '(t)))
	((or (eq replace 'buffer) (eq replace 'session))
	 (process-send-string ispell-process (concat "@" word "\n"))
	 (flyspell-unhighlight-at cursor-location)
	 (if (null ispell-pdict-modified-p)
	     (setq ispell-pdict-modified-p
		   (list ispell-pdict-modified-p)))
	 (if (eq replace 'buffer)
	     (ispell-add-per-file-word-list word)))
	(replace
	 (setq word (if (atom replace) replace (car replace))
	       cursor-location (+ (- (length word) (- end start))
				  cursor-location))
	 (if (not (equal word (car poss)))
	     (save-excursion
	       (delete-region start end)
	       (goto-char start)
	       (insert word))))))

;*---------------------------------------------------------------------*/
;*    flyspell-gnuemacs-popup                                          */
;*---------------------------------------------------------------------*/
(defun flyspell-gnuemacs-popup (event poss word)
  "The gnu-emacs popup menu."
  (if (not event)
      (let* ((mouse-pos  (mouse-position))
	     (mouse-pos  (if (nth 1 mouse-pos)
			     mouse-pos
			   (set-mouse-position (car mouse-pos)
					       (/ (frame-width) 2) 2)
			   (unfocus-frame)
			   (mouse-position))))
	(setq event (list (list (car (cdr mouse-pos))
				(1+ (cdr (cdr mouse-pos))))
			  (car mouse-pos)))))
  (let* ((corrects   (if flyspell-sort-corrections
			 (sort (car (cdr (cdr poss))) 'string<)
		       (car (cdr (cdr poss)))))
	 (cor-menu   (if (consp corrects)
			 (mapcar (lambda (correct)
				   (list correct correct))
				 corrects)
		       '()))
	 (affix      (car (cdr (cdr (cdr poss)))))
	 (base-menu  (let ((save (if (consp affix)
				     (list
				      (list (concat "Save affix: " (car affix))
					    'save)
				      '("Accept (session)" accept)
				      '("Accept (buffer)" buffer))
				   '(("Save word" save)
				     ("Accept (session)" session)
				     ("Accept (buffer)" buffer)))))
		       (if (consp cor-menu)
			   (append cor-menu (cons "" save))
			 save)))
	 (menu       (cons "flyspell correction menu" base-menu)))
    (car (x-popup-menu event
		       (list (format "%s [%s]" word (or ispell-local-dictionary
							ispell-dictionary))
			     menu)))))

;*---------------------------------------------------------------------*/
;*    flyspell-xemacs-popup                                            */
;*---------------------------------------------------------------------*/
(defun flyspell-xemacs-popup (event poss word cursor-location start end)
  "The xemacs popup menu."
  (let* ((corrects   (if flyspell-sort-corrections
			 (sort (car (cdr (cdr poss))) 'string<)
		       (car (cdr (cdr poss)))))
	 (cor-menu   (if (consp corrects)
			 (mapcar (lambda (correct)
				   (vector correct
					   (list 'flyspell-xemacs-correct
						 correct
						 (list 'quote poss)
						 word
						 cursor-location
						 start
						 end)
					   t))
				 corrects)
		       '()))
	 (affix      (car (cdr (cdr (cdr poss)))))
	 (menu       (let ((save (if (consp affix)
				     (vector
				      (concat "Save affix: " (car affix))
				      (list 'flyspell-xemacs-correct
					    ''save
					    (list 'quote poss)
					    word
					    cursor-location
					    start
					    end)
				      t)
				   (vector
				    "Save word"
				    (list 'flyspell-xemacs-correct
					  ''save
					  (list 'quote poss)
					  word
					  cursor-location
					  start
					  end)
				    t)))
			   (session (vector "Accept (session)"
					    (list 'flyspell-xemacs-correct
						  ''session
						  (list 'quote poss)
						  word
						  cursor-location
						  start
						  end)
					    t))
			   (buffer  (vector "Accept (buffer)"
					    (list 'flyspell-xemacs-correct
						  ''buffer
						  (list 'quote poss)
						  word
						  cursor-location
						  start
						  end)
					    t)))
		       (if (consp cor-menu)
			   (append cor-menu (list "-" save session buffer))
			 (list save session buffer)))))
    (popup-menu (cons (format "%s [%s]" word (or ispell-local-dictionary
						 ispell-dictionary))
		      menu))))

(provide 'flyspell)

;;; flyspell.el ends here
