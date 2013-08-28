;;; package.el --- Simple package system for Emacs  -*- lexical-binding:t -*-

;; Copyright (C) 2007-2013 Free Software Foundation, Inc.

;; Author: Tom Tromey <tromey@redhat.com>
;;         Daniel Hackney <dan@haxney.org>
;; Created: 10 Mar 2007
;; Version: 1.0.1
;; Keywords: tools
;; Package-Requires: ((tabulated-list "1.0"))

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

;;; Change Log:

;;  2 Apr 2007 - now using ChangeLog file
;; 15 Mar 2007 - updated documentation
;; 14 Mar 2007 - Changed how obsolete packages are handled
;; 13 Mar 2007 - Wrote package-install-from-buffer
;; 12 Mar 2007 - Wrote package-menu mode

;;; Commentary:

;; The idea behind package.el is to be able to download packages and
;; install them.  Packages are versioned and have versioned
;; dependencies.  Furthermore, this supports built-in packages which
;; may or may not be newer than user-specified packages.  This makes
;; it possible to upgrade Emacs and automatically disable packages
;; which have moved from external to core.  (Note though that we don't
;; currently register any of these, so this feature does not actually
;; work.)

;; A package is described by its name and version.  The distribution
;; format is either  a tar file or a single .el file.

;; A tar file should be named "NAME-VERSION.tar".  The tar file must
;; unpack into a directory named after the package and version:
;; "NAME-VERSION".  It must contain a file named "PACKAGE-pkg.el"
;; which consists of a call to define-package.  It may also contain a
;; "dir" file and the info files it references.

;; A .el file is named "NAME-VERSION.el" in the remote archive, but is
;; installed as simply "NAME.el" in a directory named "NAME-VERSION".

;; The downloader downloads all dependent packages.  By default,
;; packages come from the official GNU sources, but others may be
;; added by customizing the `package-archives' alist.  Packages get
;; byte-compiled at install time.

;; At activation time we will set up the load-path and the info path,
;; and we will load the package's autoloads.  If a package's
;; dependencies are not available, we will not activate that package.

;; Conceptually a package has multiple state transitions:
;;
;; * Download.  Fetching the package from ELPA.
;; * Install.  Untar the package, or write the .el file, into
;;   ~/.emacs.d/elpa/ directory.
;; * Byte compile.  Currently this phase is done during install,
;;   but we may change this.
;; * Activate.  Evaluate the autoloads for the package to make it
;;   available to the user.
;; * Load.  Actually load the package and run some code from it.

;; Other external functions you may want to use:
;;
;; M-x list-packages
;;    Enters a mode similar to buffer-menu which lets you manage
;;    packages.  You can choose packages for install (mark with "i",
;;    then "x" to execute) or deletion (not implemented yet), and you
;;    can see what packages are available.  This will automatically
;;    fetch the latest list of packages from ELPA.
;;
;; M-x package-install-from-buffer
;;    Install a package consisting of a single .el file that appears
;;    in the current buffer.  This only works for packages which
;;    define a Version header properly; package.el also supports the
;;    extension headers Package-Version (in case Version is an RCS id
;;    or similar), and Package-Requires (if the package requires other
;;    packages).
;;
;; M-x package-install-file
;;    Install a package from the indicated file.  The package can be
;;    either a tar file or a .el file.  A tar file must contain an
;;    appropriately-named "-pkg.el" file; a .el file must be properly
;;    formatted as with package-install-from-buffer.

;;; Thanks:
;;; (sorted by sort-lines):

;; Jim Blandy <jimb@red-bean.com>
;; Karl Fogel <kfogel@red-bean.com>
;; Kevin Ryde <user42@zip.com.au>
;; Lawrence Mitchell
;; Michael Olson <mwolson@member.fsf.org>
;; Sebastian Tennant <sebyte@smolny.plus.com>
;; Stefan Monnier <monnier@iro.umontreal.ca>
;; Vinicius Jose Latorre <viniciusjl@ig.com.br>
;; Phil Hagelberg <phil@hagelb.org>

;;; ToDo:

;; - a trust mechanism, since compiling a package can run arbitrary code.
;;   For example, download package signatures and check that they match.
;; - putting info dirs at the start of the info path means
;;   users see a weird ordering of categories.  OTOH we want to
;;   override later entries.  maybe emacs needs to enforce
;;   the standard layout?
;; - put bytecode in a separate directory tree
;; - perhaps give users a way to recompile their bytecode
;;   or do it automatically when emacs changes
;; - give users a way to know whether a package is installed ok
;; - give users a way to view a package's documentation when it
;;   only appears in the .el
;; - use/extend checkdoc so people can tell if their package will work
;; - "installed" instead of a blank in the status column
;; - tramp needs its files to be compiled in a certain order.
;;   how to handle this?  fix tramp?
;; - on emacs 21 we don't kill the -autoloads.el buffer.  what about 22?
;; - maybe we need separate .elc directories for various emacs versions
;;   and also emacs-vs-xemacs.  That way conditional compilation can
;;   work.  But would this break anything?
;; - should store the package's keywords in archive-contents, then
;;   let the users filter the package-menu by keyword.  See
;;   finder-by-keyword.  (We could also let people view the
;;   Commentary, but it isn't clear how useful this is.)
;; - William Xu suggests being able to open a package file without
;;   installing it
;; - Interface with desktop.el so that restarting after an install
;;   works properly
;; - Use hierarchical layout.  PKG/etc PKG/lisp PKG/info
;;   ... except maybe lisp?
;; - It may be nice to have a macro that expands to the package's
;;   private data dir, aka ".../etc".  Or, maybe data-directory
;;   needs to be a list (though this would be less nice)
;;   a few packages want this, eg sokoban
;; - package menu needs:
;;     ability to know which packages are built-in & thus not deletable
;;     it can sometimes print odd results, like 0.3 available but 0.4 active
;;        why is that?
;; - Allow multiple versions on the server...?
;;   [ why bother? ]
;; - Don't install a package which will invalidate dependencies overall
;; - Allow something like (or (>= emacs 21.0) (>= xemacs 21.5))
;;   [ currently thinking, why bother.. KISS ]
;; - Allow optional package dependencies
;;   then if we require 'bbdb', bbdb-specific lisp in lisp/bbdb
;;   and just don't compile to add to load path ...?
;; - Our treatment of the info path is somewhat bogus

;;; Code:

(eval-when-compile (require 'cl-lib))

(require 'tabulated-list)

(defgroup package nil
  "Manager for Emacs Lisp packages."
  :group 'applications
  :version "24.1")

;;;###autoload
(defcustom package-enable-at-startup t
  "Whether to activate installed packages when Emacs starts.
If non-nil, packages are activated after reading the init file
and before `after-init-hook'.  Activation is not done if
`user-init-file' is nil (e.g. Emacs was started with \"-q\").

Even if the value is nil, you can type \\[package-initialize] to
activate the package system at any time."
  :type 'boolean
  :group 'package
  :version "24.1")

(defcustom package-load-list '(all)
  "List of packages for `package-initialize' to load.
Each element in this list should be a list (NAME VERSION), or the
symbol `all'.  The symbol `all' says to load the latest installed
versions of all packages not specified by other elements.

For an element (NAME VERSION), NAME is a package name (a symbol).
VERSION should be t, a string, or nil.
If VERSION is t, the most recent version is activated.
If VERSION is a string, only that version is ever loaded.
 Any other version, even if newer, is silently ignored.
 Hence, the package is \"held\" at that version.
If VERSION is nil, the package is not loaded (it is \"disabled\")."
  :type '(repeat symbol)
  :risky t
  :group 'package
  :version "24.1")

(defvar Info-directory-list)
(declare-function info-initialize "info" ())
(declare-function url-http-parse-response "url-http" ())
(declare-function lm-header "lisp-mnt" (header))
(declare-function lm-commentary "lisp-mnt" (&optional file))
(defvar url-http-end-of-headers)

(defcustom package-archives '(("gnu" . "http://elpa.gnu.org/packages/"))
  "An alist of archives from which to fetch.
The default value points to the GNU Emacs package repository.

Each element has the form (ID . LOCATION).
 ID is an archive name, as a string.
 LOCATION specifies the base location for the archive.
  If it starts with \"http:\", it is treated as a HTTP URL;
  otherwise it should be an absolute directory name.
  (Other types of URL are currently not supported.)

Only add locations that you trust, since fetching and installing
a package can run arbitrary code."
  :type '(alist :key-type (string :tag "Archive name")
                :value-type (string :tag "URL or directory name"))
  :risky t
  :group 'package
  :version "24.1")

(defcustom package-pinned-packages nil
  "An alist of packages that are pinned to a specific archive

Each element has the form (SYM . ID).
 SYM is a package, as a symbol.
 ID is an archive name. This should correspond to an
 entry in `package-archives'.

If the archive of name ID does not contain the package SYM, no
other location will be considered, which will make the
package unavailable."
  :type '(alist :key-type (symbol :tag "Package")
                :value-type (string :tag "Archive name"))
  :risky t
  :group 'package
  :version "24.4")

(defconst package-archive-version 1
  "Version number of the package archive understood by this file.
Lower version numbers than this will probably be understood as well.")

;; We don't prime the cache since it tends to get out of date.
(defvar package-archive-contents nil
  "Cache of the contents of the Emacs Lisp Package Archive.
This is an alist mapping package names (symbols) to
non-empty lists of `package-desc' structures.")
(put 'package-archive-contents 'risky-local-variable t)

(defcustom package-user-dir (locate-user-emacs-file "elpa")
  "Directory containing the user's Emacs Lisp packages.
The directory name should be absolute.
Apart from this directory, Emacs also looks for system-wide
packages in `package-directory-list'."
  :type 'directory
  :risky t
  :group 'package
  :version "24.1")

(defcustom package-directory-list
  ;; Defaults are subdirs named "elpa" in the site-lisp dirs.
  (let (result)
    (dolist (f load-path)
      (and (stringp f)
	   (equal (file-name-nondirectory f) "site-lisp")
	   (push (expand-file-name "elpa" f) result)))
    (nreverse result))
  "List of additional directories containing Emacs Lisp packages.
Each directory name should be absolute.

These directories contain packages intended for system-wide; in
contrast, `package-user-dir' contains packages for personal use."
  :type '(repeat directory)
  :risky t
  :group 'package
  :version "24.1")

(defvar package--default-summary "No description available.")

(cl-defstruct (package-desc
               ;; Rename the default constructor from `make-package-desc'.
               (:constructor package-desc-create)
               ;; Has the same interface as the old `define-package',
               ;; which is still used in the "foo-pkg.el" files. Extra
               ;; options can be supported by adding additional keys.
               (:constructor
                package-desc-from-define
                (name-string version-string &optional summary requirements
                 &key kind archive &allow-other-keys
                 &aux
                 (name (intern name-string))
                 (version (version-to-list version-string))
                 (reqs (mapcar #'(lambda (elt)
                                   (list (car elt)
                                         (version-to-list (cadr elt))))
                               (if (eq 'quote (car requirements))
                                   (nth 1 requirements)
                                 requirements))))))
  "Structure containing information about an individual package.
Slots:

`name'	Name of the package, as a symbol.

`version' Version of the package, as a version list.

`summary' Short description of the package, typically taken from
	the first line of the file.

`reqs'	Requirements of the package. A list of (PACKAGE
	VERSION-LIST) naming the dependent package and the minimum
	required version.

`kind'	The distribution format of the package. Currently, it is
	either `single' or `tar'.

`archive' The name of the archive (as a string) whence this
	package came.

`dir'	The directory where the package is installed (if installed),
	`builtin' if it is built-in, or nil otherwise."
  name
  version
  (summary package--default-summary)
  reqs
  kind
  archive
  dir)

;; Pseudo fields.
(defun package-desc-full-name (pkg-desc)
  (format "%s-%s"
          (package-desc-name pkg-desc)
          (package-version-join (package-desc-version pkg-desc))))

(defun package-desc-suffix (pkg-desc)
  (pcase (package-desc-kind pkg-desc)
    (`single ".el")
    (`tar ".tar")
    (kind (error "Unknown package kind: %s" kind))))

;; Package descriptor format used in finder-inf.el and package--builtins.
(cl-defstruct (package--bi-desc
               (:constructor package-make-builtin (version summary))
               (:type vector))
  version
  reqs
  summary)

(defvar package--builtins nil
  "Alist of built-in packages.
The actual value is initialized by loading the library
`finder-inf'; this is not done until it is needed, e.g. by the
function `package-built-in-p'.

Each element has the form (PKG . PACKAGE-BI-DESC), where PKG is a package
name (a symbol) and DESC is a `package--bi-desc' structure.")
(put 'package--builtins 'risky-local-variable t)

(defvar package-alist nil
  "Alist of all packages available for activation.
Each element has the form (PKG . DESCS), where PKG is a package
name (a symbol) and DESCS is a non-empty list of `package-desc' structure,
sorted by decreasing versions.

This variable is set automatically by `package-load-descriptor',
called via `package-initialize'.  To change which packages are
loaded and/or activated, customize `package-load-list'.")
(put 'package-alist 'risky-local-variable t)

(defvar package-activated-list nil
  ;; FIXME: This should implicitly include all builtin packages.
  "List of the names of currently activated packages.")
(put 'package-activated-list 'risky-local-variable t)

(defun package-version-join (vlist)
  "Return the version string corresponding to the list VLIST.
This is, approximately, the inverse of `version-to-list'.
\(Actually, it returns only one of the possible inverses, since
`version-to-list' is a many-to-one operation.)"
  (if (null vlist)
      ""
    (let ((str-list (list "." (int-to-string (car vlist)))))
      (dolist (num (cdr vlist))
	(cond
	 ((>= num 0)
	  (push (int-to-string num) str-list)
	  (push "." str-list))
	 ((< num -3)
	  (error "Invalid version list `%s'" vlist))
	 (t
	  ;; pre, or beta, or alpha
	  (cond ((equal "." (car str-list))
		 (pop str-list))
		((not (string-match "[0-9]+" (car str-list)))
		 (error "Invalid version list `%s'" vlist)))
	  (push (cond ((= num -1) "pre")
		      ((= num -2) "beta")
		      ((= num -3) "alpha"))
		str-list))))
      (if (equal "." (car str-list))
	  (pop str-list))
      (apply 'concat (nreverse str-list)))))

(defun package-load-descriptor (pkg-dir)
  "Load the description file in directory PKG-DIR."
  (let ((pkg-file (expand-file-name (package--description-file pkg-dir)
                                    pkg-dir)))
    (when (file-exists-p pkg-file)
      (with-temp-buffer
        (insert-file-contents pkg-file)
        (goto-char (point-min))
        (let ((pkg-desc (package-process-define-package
                         (read (current-buffer)) pkg-file)))
          (setf (package-desc-dir pkg-desc) pkg-dir)
          pkg-desc)))))

(defun package-load-all-descriptors ()
  "Load descriptors for installed Emacs Lisp packages.
This looks for package subdirectories in `package-user-dir' and
`package-directory-list'.  The variable `package-load-list'
controls which package subdirectories may be loaded.

In each valid package subdirectory, this function loads the
description file containing a call to `define-package', which
updates `package-alist'."
  (dolist (dir (cons package-user-dir package-directory-list))
    (when (file-directory-p dir)
      (dolist (subdir (directory-files dir))
        (let ((pkg-dir (expand-file-name subdir dir)))
          (when (file-directory-p pkg-dir)
            (package-load-descriptor pkg-dir)))))))

(defun package-disabled-p (pkg-name version)
  "Return whether PKG-NAME at VERSION can be activated.
The decision is made according to `package-load-list'.
Return nil if the package can be activated.
Return t if the package is completely disabled.
Return the max version (as a string) if the package is held at a lower version."
  (let ((force (assq pkg-name package-load-list)))
    (cond ((null force) (not (memq 'all package-load-list)))
          ((null (setq force (cadr force))) t) ; disabled
          ((eq force t) nil)
          ((stringp force)              ; held
           (unless (version-list-= version (version-to-list force))
             force))
          (t (error "Invalid element in `package-load-list'")))))

(defun package-activate-1 (pkg-desc)
  (let* ((name (package-desc-name pkg-desc))
	 (pkg-dir (package-desc-dir pkg-desc))
         (pkg-dir-dir (file-name-as-directory pkg-dir)))
    (unless pkg-dir
      (error "Internal error: unable to find directory for `%s'"
	     (package-desc-full-name pkg-desc)))
    ;; Add to load path, add autoloads, and activate the package.
    (let ((old-lp load-path))
      (load (expand-file-name (format "%s-autoloads" name) pkg-dir) nil t)
      (when (and (eq old-lp load-path)
                 (not (or (member pkg-dir load-path)
                          (member pkg-dir-dir load-path))))
        ;; Old packages don't add themselves to the `load-path', so we have to
        ;; do it ourselves.
        (push pkg-dir load-path)))
    ;; Add info node.
    (when (file-exists-p (expand-file-name "dir" pkg-dir))
      ;; FIXME: not the friendliest, but simple.
      (require 'info)
      (info-initialize)
      (push pkg-dir Info-directory-list))
    (push name package-activated-list)
    ;; Don't return nil.
    t))

(defun package-built-in-p (package &optional min-version)
  "Return true if PACKAGE is built-in to Emacs.
Optional arg MIN-VERSION, if non-nil, should be a version list
specifying the minimum acceptable version."
  (let ((bi (assq package package--builtin-versions)))
    (cond
     (bi (version-list-<= min-version (cdr bi)))
     (min-version nil)
     (t
      (require 'finder-inf nil t) ; For `package--builtins'.
      (assq package package--builtins)))))

(defun package--from-builtin (bi-desc)
  (package-desc-create :name (pop bi-desc)
                       :version (package--bi-desc-version bi-desc)
                       :summary (package--bi-desc-summary bi-desc)
                       :dir 'builtin))

;; This function goes ahead and activates a newer version of a package
;; if an older one was already activated.  This is not ideal; we'd at
;; least need to check to see if the package has actually been loaded,
;; and not merely activated.
(defun package-activate (package &optional force)
  "Activate package PACKAGE.
If FORCE is true, (re-)activate it if it's already activated."
  (let ((pkg-descs (cdr (assq package package-alist))))
    ;; Check if PACKAGE is available in `package-alist'.
    (while
        (when pkg-descs
          (let ((available-version (package-desc-version (car pkg-descs))))
            (or (package-disabled-p package available-version)
                ;; Prefer a builtin package.
                (package-built-in-p package available-version))))
      (setq pkg-descs (cdr pkg-descs)))
    (cond
     ;; If no such package is found, maybe it's built-in.
     ((null pkg-descs)
      (package-built-in-p package))
     ;; If the package is already activated, just return t.
     ((and (memq package package-activated-list) (not force))
      t)
     ;; Otherwise, proceed with activation.
     (t
      (let* ((pkg-vec (car pkg-descs))
             (fail (catch 'dep-failure
                     ;; Activate its dependencies recursively.
                     (dolist (req (package-desc-reqs pkg-vec))
                       (unless (package-activate (car req) (cadr req))
                         (throw 'dep-failure req))))))
	(if fail
	    (warn "Unable to activate package `%s'.
Required package `%s-%s' is unavailable"
		  package (car fail) (package-version-join (cadr fail)))
	  ;; If all goes well, activate the package itself.
	  (package-activate-1 pkg-vec)))))))

(defun define-package (_name-string _version-string
                                    &optional _docstring _requirements
                                    &rest _extra-properties)
  "Define a new package.
NAME-STRING is the name of the package, as a string.
VERSION-STRING is the version of the package, as a string.
DOCSTRING is a short description of the package, a string.
REQUIREMENTS is a list of dependencies on other packages.
 Each requirement is of the form (OTHER-PACKAGE OTHER-VERSION),
 where OTHER-VERSION is a string.

EXTRA-PROPERTIES is currently unused."
  ;; FIXME: Placeholder!  Should we keep it?
  (error "Don't call me!"))

(defun package-process-define-package (exp origin)
  (unless (eq (car-safe exp) 'define-package)
    (error "Can't find define-package in %s" origin))
  (let* ((new-pkg-desc (apply #'package-desc-from-define (cdr exp)))
         (name (package-desc-name new-pkg-desc))
         (version (package-desc-version new-pkg-desc))
         (old-pkgs (assq name package-alist)))
    (if (null old-pkgs)
        ;; If there's no old package, just add this to `package-alist'.
        (push (list name new-pkg-desc) package-alist)
      ;; If there is, insert the new package at the right place in the list.
      (while
          (if (and (cdr old-pkgs)
                   (version-list-< version
                                   (package-desc-version (cadr old-pkgs))))
              (setq old-pkgs (cdr old-pkgs))
            (push new-pkg-desc (cdr old-pkgs))
            nil)))
    new-pkg-desc))

;; From Emacs 22, but changed so it adds to load-path.
(defun package-autoload-ensure-default-file (file)
  "Make sure that the autoload file FILE exists and if not create it."
  (unless (file-exists-p file)
    (write-region
     (concat ";;; " (file-name-nondirectory file)
	     " --- automatically extracted autoloads\n"
	     ";;\n"
	     ";;; Code:\n"
             "(add-to-list 'load-path (or (file-name-directory #$) (car load-path)))\n"
	     "\n;; Local Variables:\n"
	     ";; version-control: never\n"
	     ";; no-byte-compile: t\n"
	     ";; no-update-autoloads: t\n"
	     ";; End:\n"
	     ";;; " (file-name-nondirectory file)
	     " ends here\n")
     nil file))
  file)

(defvar generated-autoload-file)
(defvar version-control)

(defun package-generate-autoloads (name pkg-dir)
  (require 'autoload)         ;Load before we let-bind generated-autoload-file!
  (let* ((auto-name (format "%s-autoloads.el" name))
	 ;;(ignore-name (concat name "-pkg.el"))
	 (generated-autoload-file (expand-file-name auto-name pkg-dir))
	 (version-control 'never))
    (package-autoload-ensure-default-file generated-autoload-file)
    (update-directory-autoloads pkg-dir)
    (let ((buf (find-buffer-visiting generated-autoload-file)))
      (when buf (kill-buffer buf)))
    auto-name))

(defvar tar-parse-info)
(declare-function tar-untar-buffer "tar-mode" ())
(declare-function tar-header-name "tar-mode" (tar-header) t)
(declare-function tar-header-link-type "tar-mode" (tar-header) t)

(defun package-untar-buffer (dir)
  "Untar the current buffer.
This uses `tar-untar-buffer' from Tar mode.  All files should
untar into a directory named DIR; otherwise, signal an error."
  (require 'tar-mode)
  (tar-mode)
  ;; Make sure everything extracts into DIR.
  (let ((regexp (concat "\\`" (regexp-quote (expand-file-name dir)) "/"))
	(case-fold-search (memq system-type '(windows-nt ms-dos cygwin))))
    (dolist (tar-data tar-parse-info)
      (let ((name (expand-file-name (tar-header-name tar-data))))
	(or (string-match regexp name)
	    ;; Tarballs created by some utilities don't list
	    ;; directories with a trailing slash (Bug#13136).
	    (and (string-equal dir name)
		 (eq (tar-header-link-type tar-data) 5))
	    (error "Package does not untar cleanly into directory %s/" dir)))))
  (tar-untar-buffer))

(defun package-generate-description-file (pkg-desc pkg-dir)
  "Create the foo-pkg.el file for single-file packages."
  (let* ((name (package-desc-name pkg-desc))
         (pkg-file (expand-file-name (package--description-file pkg-dir)
                                     pkg-dir)))
    (let ((print-level nil)
          (print-quoted t)
          (print-length nil))
      (write-region
       (concat
        (prin1-to-string
         (list 'define-package
               (symbol-name name)
               (package-version-join (package-desc-version pkg-desc))
               (package-desc-summary pkg-desc)
               (let ((requires (package-desc-reqs pkg-desc)))
                 (list 'quote
                       ;; Turn version lists into string form.
                       (mapcar
                        (lambda (elt)
                          (list (car elt)
                                (package-version-join (cadr elt))))
                        requires)))))
        "\n")
       nil
       pkg-file))))

(defun package-unpack (pkg-desc)
  "Install the contents of the current buffer as a package."
  (let* ((name (package-desc-name pkg-desc))
         (dirname (package-desc-full-name pkg-desc))
	 (pkg-dir (expand-file-name dirname package-user-dir)))
    (pcase (package-desc-kind pkg-desc)
      (`tar
       (make-directory package-user-dir t)
       ;; FIXME: should we delete PKG-DIR if it exists?
       (let* ((default-directory (file-name-as-directory package-user-dir)))
         (package-untar-buffer dirname)))
      (`single
       (let ((el-file (expand-file-name (format "%s.el" name) pkg-dir)))
         (make-directory pkg-dir t)
         (package--write-file-no-coding el-file)))
      (kind (error "Unknown package kind: %S" kind)))
    (package--make-autoloads-and-stuff pkg-desc pkg-dir)
    ;; Update package-alist.
    (let ((new-desc (package-load-descriptor pkg-dir)))
      ;; FIXME: Check that `new-desc' matches `desc'!
      ;; FIXME: Compilation should be done as a separate, optional, step.
      ;; E.g. for multi-package installs, we should first install all packages
      ;; and then compile them.
      (package--compile new-desc))
    ;; Try to activate it.
    (package-activate name 'force)
    pkg-dir))

(defun package--make-autoloads-and-stuff (pkg-desc pkg-dir)
  "Generate autoloads, description file, etc.. for PKG-DESC installed at PKG-DIR."
  (package-generate-autoloads (package-desc-name pkg-desc) pkg-dir)
  (let ((desc-file (package--description-file pkg-dir)))
    (unless (file-exists-p desc-file)
      (package-generate-description-file pkg-desc pkg-dir)))
  ;; FIXME: Create foo.info and dir file from foo.texi?
  )

(defun package--compile (pkg-desc)
  "Byte-compile installed package PKG-DESC."
  (package-activate-1 pkg-desc)
  (byte-recompile-directory (package-desc-dir pkg-desc) 0 t))

(defun package--write-file-no-coding (file-name)
  (let ((buffer-file-coding-system 'no-conversion))
    (write-region (point-min) (point-max) file-name)))

(defmacro package--with-work-buffer (location file &rest body)
  "Run BODY in a buffer containing the contents of FILE at LOCATION.
LOCATION is the base location of a package archive, and should be
one of the URLs (or file names) specified in `package-archives'.
FILE is the name of a file relative to that base location.

This macro retrieves FILE from LOCATION into a temporary buffer,
and evaluates BODY while that buffer is current.  This work
buffer is killed afterwards.  Return the last value in BODY."
  (declare (indent 2) (debug t))
  `(let* ((http (string-match "\\`https?:" ,location))
	  (buffer
	   (if http
	       (url-retrieve-synchronously (concat ,location ,file))
	     (generate-new-buffer "*package work buffer*"))))
     (prog1
	 (with-current-buffer buffer
	   (if http
	       (progn (package-handle-response)
		      (re-search-forward "^$" nil 'move)
		      (forward-char)
		      (delete-region (point-min) (point)))
	     (unless (file-name-absolute-p ,location)
	       (error "Archive location %s is not an absolute file name"
		      ,location))
	     (insert-file-contents (expand-file-name ,file ,location)))
	   ,@body)
       (kill-buffer buffer))))

(defun package-handle-response ()
  "Handle the response from a `url-retrieve-synchronously' call.
Parse the HTTP response and throw if an error occurred.
The url package seems to require extra processing for this.
This should be called in a `save-excursion', in the download buffer.
It will move point to somewhere in the headers."
  ;; We assume HTTP here.
  (require 'url-http)
  (let ((response (url-http-parse-response)))
    (when (or (< response 200) (>= response 300))
      (error "Error during download request:%s"
	     (buffer-substring-no-properties (point) (line-end-position))))))

(defun package-install-from-archive (pkg-desc)
  "Download and install a tar package."
  (let ((location (package-archive-base pkg-desc))
	(file (concat (package-desc-full-name pkg-desc)
                      (package-desc-suffix pkg-desc))))
    (package--with-work-buffer location file
      (package-unpack pkg-desc))))

(defvar package--initialized nil)

(defun package-installed-p (package &optional min-version)
  "Return true if PACKAGE, of MIN-VERSION or newer, is installed.
MIN-VERSION should be a version list."
  (unless package--initialized (error "package.el is not yet initialized!"))
    (or
     (let ((pkg-descs (cdr (assq package package-alist))))
       (and pkg-descs
            (version-list-<= min-version
                             (package-desc-version (car pkg-descs)))))
     ;; Also check built-in packages.
     (package-built-in-p package min-version)))

(defun package-compute-transaction (packages requirements)
  "Return a list of packages to be installed, including PACKAGES.
PACKAGES should be a list of `package-desc'.

REQUIREMENTS should be a list of additional requirements; each
element in this list should have the form (PACKAGE VERSION-LIST),
where PACKAGE is a package name and VERSION-LIST is the required
version of that package.

This function recursively computes the requirements of the
packages in REQUIREMENTS, and returns a list of all the packages
that must be installed.  Packages that are already installed are
not included in this list."
  ;; FIXME: We really should use backtracking to explore the whole
  ;; search space (e.g. if foo require bar-1.3, and bar-1.4 requires toto-1.1
  ;; whereas bar-1.3 requires toto-1.0 and the user has put a hold on toto-1.0:
  ;; the current code might fail to see that it could install foo by using the
  ;; older bar-1.3).
  (dolist (elt requirements)
    (let* ((next-pkg (car elt))
	   (next-version (cadr elt))
           (already ()))
      (dolist (pkg packages)
        (if (eq next-pkg (package-desc-name pkg))
            (setq already pkg)))
      (cond
       (already
        (if (version-list-< next-version (package-desc-version already))
            ;; Move to front, so it gets installed early enough (bug#14082).
            (setq packages (cons already (delq already packages)))
          (error "Need package `%s-%s', but only %s is available"
                 next-pkg (package-version-join next-version)
                 (package-version-join (package-desc-version already)))))

       ((package-installed-p next-pkg next-version) nil)

       (t
	;; A package is required, but not installed.  It might also be
	;; blocked via `package-load-list'.
	(let ((pkg-descs (cdr (assq next-pkg package-archive-contents)))
              (found nil)
              (problem nil))
          (while (and pkg-descs (not found))
            (let* ((pkg-desc (pop pkg-descs))
                   (version (package-desc-version pkg-desc))
                   (disabled (package-disabled-p next-pkg version)))
              (cond
               ((version-list-< version next-version)
                (error
                 "Need package `%s-%s', but only %s is available"
                 next-pkg (package-version-join next-version)
                 (package-version-join version)))
               (disabled
                (unless problem
                  (setq problem
                        (if (stringp disabled)
                            (format "Package `%s' held at version %s, \
but version %s required"
                                    next-pkg disabled
                                    (package-version-join next-version))
                          (format "Required package '%s' is disabled"
                                  next-pkg)))))
               (t (setq found pkg-desc)))))
	  (unless found
            (if problem
                (error problem)
              (error "Package `%s-%s' is unavailable"
                     next-pkg (package-version-join next-version))))
	  (setq packages
		(package-compute-transaction (cons found packages)
					     (package-desc-reqs found))))))))
  packages)

(defun package-read-from-string (str)
  "Read a Lisp expression from STR.
Signal an error if the entire string was not used."
  (let* ((read-data (read-from-string str))
	 (more-left
	  (condition-case nil
	      ;; The call to `ignore' suppresses a compiler warning.
	      (progn (ignore (read-from-string
			      (substring str (cdr read-data))))
		     t)
	    (end-of-file nil))))
    (if more-left
        (error "Can't read whole string")
      (car read-data))))

(defun package--read-archive-file (file)
  "Re-read archive file FILE, if it exists.
Will return the data from the file, or nil if the file does not exist.
Will throw an error if the archive version is too new."
  (let ((filename (expand-file-name file package-user-dir)))
    (when (file-exists-p filename)
      (with-temp-buffer
	(insert-file-contents-literally filename)
	(let ((contents (read (current-buffer))))
	  (if (> (car contents) package-archive-version)
	      (error "Package archive version %d is higher than %d"
		     (car contents) package-archive-version))
	  (cdr contents))))))

(defun package-read-all-archive-contents ()
  "Re-read `archive-contents', if it exists.
If successful, set `package-archive-contents'."
  (setq package-archive-contents nil)
  (dolist (archive package-archives)
    (package-read-archive-contents (car archive))))

(defun package-read-archive-contents (archive)
  "Re-read archive contents for ARCHIVE.
If successful, set the variable `package-archive-contents'.
If the archive version is too new, signal an error."
  ;; Version 1 of 'archive-contents' is identical to our internal
  ;; representation.
  (let* ((contents-file (format "archives/%s/archive-contents" archive))
	 (contents (package--read-archive-file contents-file)))
    (when contents
      (dolist (package contents)
	(package--add-to-archive-contents package archive)))))

;; Package descriptor objects used inside the "archive-contents" file.
;; Changing this defstruct implies changing the format of the
;; "archive-contents" files.
(cl-defstruct (package--ac-desc
               (:constructor package-make-ac-desc (version reqs summary kind))
               (:copier nil)
               (:type vector))
  version reqs summary kind)

(defun package--add-to-archive-contents (package archive)
  "Add the PACKAGE from the given ARCHIVE if necessary.
PACKAGE should have the form (NAME . PACKAGE--AC-DESC).
Also, add the originating archive to the `package-desc' structure."
  (let* ((name (car package))
         (version (package--ac-desc-version (cdr package)))
         (pkg-desc
          (package-desc-create
           :name name
           :version version
           :reqs (package--ac-desc-reqs (cdr package))
           :summary (package--ac-desc-summary (cdr package))
           :kind (package--ac-desc-kind (cdr package))
           :archive archive))
         (existing-packages (assq name package-archive-contents))
         (pinned-to-archive (assoc name package-pinned-packages)))
    (cond
     ;; Skip entirely if pinned to another archive or already installed.
     ((or (and pinned-to-archive
               (not (equal (cdr pinned-to-archive) archive)))
          (let ((bi (assq name package--builtin-versions)))
            (and bi (version-list-= version (cdr bi))))
          (let ((ins (cdr (assq name package-alist))))
            (and ins (version-list-= version
                                     (package-desc-version (car ins))))))
      nil)
     ((not existing-packages)
      (push (list name pkg-desc) package-archive-contents))
     (t
      (while
          (if (and (cdr existing-packages)
                   (version-list-<
                    version (package-desc-version (cadr existing-packages))))
              (setq existing-packages (cdr existing-packages))
            (push pkg-desc (cdr existing-packages))
            nil))))))

(defun package-download-transaction (packages)
  "Download and install all the packages in PACKAGES.
PACKAGES should be a list of package-desc.
This function assumes that all package requirements in
PACKAGES are satisfied, i.e. that PACKAGES is computed
using `package-compute-transaction'."
  (mapc #'package-install-from-archive packages))

;;;###autoload
(defun package-install (pkg)
  "Install the package PKG.
PKG can be a package-desc or the package name of one the available packages
in an archive in `package-archives'.  Interactively, prompt for its name."
  (interactive
   (progn
     ;; Initialize the package system to get the list of package
     ;; symbols for completion.
     (unless package--initialized
       (package-initialize t))
     (unless package-archive-contents
       (package-refresh-contents))
     (list (intern (completing-read
                    "Install package: "
                    (mapcar (lambda (elt) (symbol-name (car elt)))
                            package-archive-contents)
                    nil t)))))
  (package-download-transaction
   (if (package-desc-p pkg)
       (package-compute-transaction (list pkg)
                                    (package-desc-reqs pkg))
     (package-compute-transaction ()
                                  (list (list pkg))))))

(defun package-strip-rcs-id (str)
  "Strip RCS version ID from the version string STR.
If the result looks like a dotted numeric version, return it.
Otherwise return nil."
  (when str
    (when (string-match "\\`[ \t]*[$]Revision:[ \t]+" str)
      (setq str (substring str (match-end 0))))
    (condition-case nil
	(if (version-to-list str)
	    str)
      (error nil))))

(defun package-buffer-info ()
  "Return a `package-desc' describing the package in the current buffer.

If the buffer does not contain a conforming package, signal an
error.  If there is a package, narrow the buffer to the file's
boundaries."
  (goto-char (point-min))
  (unless (re-search-forward "^;;; \\([^ ]*\\)\\.el ---[ \t]*\\(.*?\\)[ \t]*\\(-\\*-.*-\\*-[ \t]*\\)?$" nil t)
    (error "Package lacks a file header"))
  (let ((file-name (match-string-no-properties 1))
	(desc      (match-string-no-properties 2))
	(start     (line-beginning-position)))
    (unless (search-forward (concat ";;; " file-name ".el ends here"))
      (error "Package lacks a terminating comment"))
    ;; Try to include a trailing newline.
    (forward-line)
    (narrow-to-region start (point))
    (require 'lisp-mnt)
    ;; Use some headers we've invented to drive the process.
    (let* ((requires-str (lm-header "package-requires"))
	   ;; Prefer Package-Version; if defined, the package author
	   ;; probably wants us to use it.  Otherwise try Version.
	   (pkg-version
	    (or (package-strip-rcs-id (lm-header "package-version"))
		(package-strip-rcs-id (lm-header "version")))))
      (unless pkg-version
	(error
	 "Package lacks a \"Version\" or \"Package-Version\" header"))
      (package-desc-from-define
       file-name pkg-version desc
       (if requires-str (package-read-from-string requires-str))
       :kind 'single))))

(declare-function tar-get-file-descriptor "tar-mode" (file))
(declare-function tar--extract "tar-mode" (descriptor))

(defun package-tar-file-info ()
  "Find package information for a tar file.
The return result is a `package-desc'."
  (cl-assert (derived-mode-p 'tar-mode))
  (let* ((dir-name (file-name-directory
                    (tar-header-name (car tar-parse-info))))
         (desc-file (package--description-file dir-name))
         (tar-desc (tar-get-file-descriptor (concat dir-name desc-file))))
    (unless tar-desc
      (error "No package descriptor file found"))
    (with-current-buffer (tar--extract tar-desc)
      (goto-char (point-min))
      (unwind-protect
          (let* ((pkg-def-parsed (read (current-buffer)))
                 (pkg-desc
                  (if (not (eq (car pkg-def-parsed) 'define-package))
                      (error "Can't find define-package in %s"
                             (tar-header-name tar-desc))
                    (apply #'package-desc-from-define
                           (append (cdr pkg-def-parsed))))))
            (setf (package-desc-kind pkg-desc) 'tar)
            pkg-desc)
        (kill-buffer (current-buffer))))))


;;;###autoload
(defun package-install-from-buffer ()
  "Install a package from the current buffer.
The current buffer is assumed to be a single .el or .tar file that follows the
packaging guidelines; see info node `(elisp)Packaging'.
Downloads and installs required packages as needed."
  (interactive)
  (let ((pkg-desc (if (derived-mode-p 'tar-mode)
                      (package-tar-file-info)
                    (package-buffer-info))))
    ;; Download and install the dependencies.
    (let* ((requires (package-desc-reqs pkg-desc))
           (transaction (package-compute-transaction nil requires)))
      (package-download-transaction transaction))
    ;; Install the package itself.
    (package-unpack pkg-desc)
    pkg-desc))

;;;###autoload
(defun package-install-file (file)
  "Install a package from a file.
The file can either be a tar file or an Emacs Lisp file."
  (interactive "fPackage file name: ")
  (with-temp-buffer
    (insert-file-contents-literally file)
    (when (string-match "\\.tar\\'" file) (tar-mode))
    (package-install-from-buffer)))

(defun package-delete (pkg-desc)
  (let ((dir (package-desc-dir pkg-desc)))
    (if (not (string-prefix-p (file-name-as-directory
                               (expand-file-name package-user-dir))
                              (expand-file-name dir)))
        ;; Don't delete "system" packages.
	(error "Package `%s' is a system package, not deleting"
               (package-desc-full-name pkg-desc))
      (delete-directory dir t t)
      ;; Update package-alist.
      (let* ((name (package-desc-name pkg-desc)))
        (delete pkg-desc (assq name package-alist)))
      (message "Package `%s' deleted." (package-desc-full-name pkg-desc)))))

(defun package-archive-base (desc)
  "Return the archive containing the package NAME."
  (cdr (assoc (package-desc-archive desc) package-archives)))

(defun package--download-one-archive (archive file)
  "Retrieve an archive file FILE from ARCHIVE, and cache it.
ARCHIVE should be a cons cell of the form (NAME . LOCATION),
similar to an entry in `package-alist'.  Save the cached copy to
\"archives/NAME/archive-contents\" in `package-user-dir'."
  (let* ((dir (expand-file-name (format "archives/%s" (car archive))
                                package-user-dir)))
    (package--with-work-buffer (cdr archive) file
      ;; Read the retrieved buffer to make sure it is valid (e.g. it
      ;; may fetch a URL redirect page).
      (when (listp (read buffer))
	(make-directory dir t)
	(setq buffer-file-name (expand-file-name file dir))
	(let ((version-control 'never))
	  (save-buffer))))))

;;;###autoload
(defun package-refresh-contents ()
  "Download the ELPA archive description if needed.
This informs Emacs about the latest versions of all packages, and
makes them available for download."
  (interactive)
  ;; FIXME: Do it asynchronously.
  (unless (file-exists-p package-user-dir)
    (make-directory package-user-dir t))
  (dolist (archive package-archives)
    (condition-case-unless-debug nil
	(package--download-one-archive archive "archive-contents")
      (error (message "Failed to download `%s' archive."
		      (car archive)))))
  (package-read-all-archive-contents))

;;;###autoload
(defun package-initialize (&optional no-activate)
  "Load Emacs Lisp packages, and activate them.
The variable `package-load-list' controls which packages to load.
If optional arg NO-ACTIVATE is non-nil, don't activate packages."
  (interactive)
  (setq package-alist nil)
  (package-load-all-descriptors)
  (package-read-all-archive-contents)
  (unless no-activate
    (dolist (elt package-alist)
      (package-activate (car elt))))
  (setq package--initialized t))


;;;; Package description buffer.

;;;###autoload
(defun describe-package (package)
  "Display the full documentation of PACKAGE (a symbol)."
  (interactive
   (let* ((guess (function-called-at-point)))
     (require 'finder-inf nil t)
     ;; Load the package list if necessary (but don't activate them).
     (unless package--initialized
       (package-initialize t))
     (let ((packages (append (mapcar 'car package-alist)
                             (mapcar 'car package-archive-contents)
                             (mapcar 'car package--builtins))))
       (unless (memq guess packages)
         (setq guess nil))
       (setq packages (mapcar 'symbol-name packages))
       (let ((val
              (completing-read (if guess
                                   (format "Describe package (default %s): "
                                           guess)
                                 "Describe package: ")
                               packages nil t nil nil guess)))
         (list (intern val))))))
  (if (not (or (package-desc-p package) (and package (symbolp package))))
      (message "No package specified")
    (help-setup-xref (list #'describe-package package)
		     (called-interactively-p 'interactive))
    (with-help-window (help-buffer)
      (with-current-buffer standard-output
	(describe-package-1 package)))))

(defun describe-package-1 (pkg)
  (require 'lisp-mnt)
  (let* ((desc (or
                (if (package-desc-p pkg) pkg)
                (cadr (assq pkg package-alist))
                (let ((built-in (assq pkg package--builtins)))
                  (if built-in
                      (package--from-builtin built-in)
                    (cadr (assq pkg package-archive-contents))))))
         (name (if desc (package-desc-name desc) pkg))
         (pkg-dir (if desc (package-desc-dir desc)))
         (reqs (if desc (package-desc-reqs desc)))
         (version (if desc (package-desc-version desc)))
         (archive (if desc (package-desc-archive desc)))
         (built-in (eq pkg-dir 'builtin))
         (installable (and archive (not built-in)))
         (status (if desc (package-desc-status desc) "orphan")))
    (prin1 name)
    (princ " is ")
    (princ (if (memq (aref status 0) '(?a ?e ?i ?o ?u)) "an " "a "))
    (princ status)
    (princ " package.\n\n")

    (insert "     " (propertize "Status" 'font-lock-face 'bold) ": ")
    (cond (built-in
	   (insert (propertize (capitalize status)
                               'font-lock-face 'font-lock-builtin-face)
                   "."))
	  (pkg-dir
	   (insert (propertize (capitalize status) ;FIXME: Why comment-face?
			       'font-lock-face 'font-lock-comment-face))
	   (insert " in `")
	   ;; Todo: Add button for uninstalling.
	   (help-insert-xref-button (abbreviate-file-name
                                     (file-name-as-directory pkg-dir))
				    'help-package-def pkg-dir)
	   (if (and (package-built-in-p name)
                    (not (package-built-in-p name version)))
	       (insert "',\n             shadowing a "
		       (propertize "built-in package"
				   'font-lock-face 'font-lock-builtin-face)
		       ".")
	     (insert "'.")))
	  (installable
           (insert (capitalize status))
	   (insert " from " (format "%s" archive))
	   (insert " -- ")
	   (let ((button-text (if (display-graphic-p) "Install" "[Install]"))
		 (button-face (if (display-graphic-p)
				  '(:box (:line-width 2 :color "dark grey")
					 :background "light grey"
					 :foreground "black")
				'link)))
	     (insert-text-button button-text 'face button-face 'follow-link t
				 'package-desc desc
				 'action 'package-install-button-action)))
	  (t (insert (capitalize status) ".")))
    (insert "\n")
    (and version
	 (insert "    "
		 (propertize "Version" 'font-lock-face 'bold) ": "
                 (package-version-join version) "\n"))

    (setq reqs (if desc (package-desc-reqs desc)))
    (when reqs
      (insert "   " (propertize "Requires" 'font-lock-face 'bold) ": ")
      (let ((first t)
	    name vers text)
	(dolist (req reqs)
	  (setq name (car req)
		vers (cadr req)
		text (format "%s-%s" (symbol-name name)
			     (package-version-join vers)))
	  (cond (first (setq first nil))
		((>= (+ 2 (current-column) (length text))
		     (window-width))
		 (insert ",\n               "))
		(t (insert ", ")))
	  (help-insert-xref-button text 'help-package name))
	(insert "\n")))
    (insert "    " (propertize "Summary" 'font-lock-face 'bold)
	    ": " (if desc (package-desc-summary desc)) "\n")

    (let* ((all-pkgs (append (cdr (assq name package-alist))
                             (cdr (assq name package-archive-contents))
                             (let ((bi (assq name package--builtins)))
                               (if bi (list (package--from-builtin bi))))))
           (other-pkgs (delete desc all-pkgs)))
      (when other-pkgs
        (insert "    " (propertize "Other versions" 'font-lock-face 'bold) ": "
                (mapconcat
                 (lambda (opkg)
                   (let* ((ov (package-desc-version opkg))
                          (dir (package-desc-dir opkg))
                          (from (or (package-desc-archive opkg)
                                    (if (stringp dir) "installed" dir))))
                     (if (not ov) (format "%s" from)
                       (format "%s (%s)"
                               (make-text-button (package-version-join ov) nil
                                                 'face 'link
                                                 'follow-link t
                                                 'action
                                                 (lambda (_button)
                                                   (describe-package opkg)))
                               from))))
                 other-pkgs ", ")
                ".\n")))

    (insert "\n")

    (if built-in
	;; For built-in packages, insert the commentary.
	(let ((fn (locate-file (format "%s.el" name) load-path
			       load-file-rep-suffixes))
	      (opoint (point)))
	  (insert (or (lm-commentary fn) ""))
	  (save-excursion
	    (goto-char opoint)
	    (when (re-search-forward "^;;; Commentary:\n" nil t)
	      (replace-match ""))
	    (while (re-search-forward "^\\(;+ ?\\)" nil t)
	      (replace-match ""))))
      (let ((readme (expand-file-name (format "%s-readme.txt" name)
				      package-user-dir))
	    readme-string)
	;; For elpa packages, try downloading the commentary.  If that
	;; fails, try an existing readme file in `package-user-dir'.
	(cond ((condition-case nil
		   (package--with-work-buffer
                       (package-archive-base desc)
                       (format "%s-readme.txt" name)
		     (setq buffer-file-name
			   (expand-file-name readme package-user-dir))
		     (let ((version-control 'never))
		       (save-buffer))
		     (setq readme-string (buffer-string))
		     t)
		 (error nil))
	       (insert readme-string))
	      ((file-readable-p readme)
	       (insert-file-contents readme)
	       (goto-char (point-max))))))))

(defun package-install-button-action (button)
  (let ((pkg-desc (button-get button 'package-desc)))
    (when (y-or-n-p (format "Install package `%s'? "
                            (package-desc-full-name pkg-desc)))
      (package-install pkg-desc)
      (revert-buffer nil t)
      (goto-char (point-min)))))


;;;; Package menu mode.

(defvar package-menu-mode-map
  (let ((map (make-sparse-keymap))
	(menu-map (make-sparse-keymap "Package")))
    (set-keymap-parent map tabulated-list-mode-map)
    (define-key map "\C-m" 'package-menu-describe-package)
    (define-key map "u" 'package-menu-mark-unmark)
    (define-key map "\177" 'package-menu-backup-unmark)
    (define-key map "d" 'package-menu-mark-delete)
    (define-key map "i" 'package-menu-mark-install)
    (define-key map "U" 'package-menu-mark-upgrades)
    (define-key map "r" 'package-menu-refresh)
    (define-key map "~" 'package-menu-mark-obsolete-for-deletion)
    (define-key map "x" 'package-menu-execute)
    (define-key map "h" 'package-menu-quick-help)
    (define-key map "?" 'package-menu-describe-package)
    (define-key map [menu-bar package-menu] (cons "Package" menu-map))
    (define-key menu-map [mq]
      '(menu-item "Quit" quit-window
		  :help "Quit package selection"))
    (define-key menu-map [s1] '("--"))
    (define-key menu-map [mn]
      '(menu-item "Next" next-line
		  :help "Next Line"))
    (define-key menu-map [mp]
      '(menu-item "Previous" previous-line
		  :help "Previous Line"))
    (define-key menu-map [s2] '("--"))
    (define-key menu-map [mu]
      '(menu-item "Unmark" package-menu-mark-unmark
		  :help "Clear any marks on a package and move to the next line"))
    (define-key menu-map [munm]
      '(menu-item "Unmark Backwards" package-menu-backup-unmark
		  :help "Back up one line and clear any marks on that package"))
    (define-key menu-map [md]
      '(menu-item "Mark for Deletion" package-menu-mark-delete
		  :help "Mark a package for deletion and move to the next line"))
    (define-key menu-map [mi]
      '(menu-item "Mark for Install" package-menu-mark-install
		  :help "Mark a package for installation and move to the next line"))
    (define-key menu-map [mupgrades]
      '(menu-item "Mark Upgradable Packages" package-menu-mark-upgrades
		  :help "Mark packages that have a newer version for upgrading"))
    (define-key menu-map [s3] '("--"))
    (define-key menu-map [mg]
      '(menu-item "Update Package List" revert-buffer
		  :help "Update the list of packages"))
    (define-key menu-map [mr]
      '(menu-item "Refresh Package List" package-menu-refresh
		  :help "Download the ELPA archive"))
    (define-key menu-map [s4] '("--"))
    (define-key menu-map [mt]
      '(menu-item "Mark Obsolete Packages" package-menu-mark-obsolete-for-deletion
		  :help "Mark all obsolete packages for deletion"))
    (define-key menu-map [mx]
      '(menu-item "Execute Actions" package-menu-execute
		  :help "Perform all the marked actions"))
    (define-key menu-map [s5] '("--"))
    (define-key menu-map [mh]
      '(menu-item "Help" package-menu-quick-help
		  :help "Show short key binding help for package-menu-mode"))
    (define-key menu-map [mc]
      '(menu-item "View Commentary" package-menu-view-commentary
		  :help "Display information about this package"))
    map)
  "Local keymap for `package-menu-mode' buffers.")

(defvar package-menu--new-package-list nil
  "List of newly-available packages since `list-packages' was last called.")

(define-derived-mode package-menu-mode tabulated-list-mode "Package Menu"
  "Major mode for browsing a list of packages.
Letters do not insert themselves; instead, they are commands.
\\<package-menu-mode-map>
\\{package-menu-mode-map}"
  (setq tabulated-list-format [("Package" 18 package-menu--name-predicate)
			       ("Version" 12 nil)
			       ("Status"  10 package-menu--status-predicate)
			       ("Description" 0 nil)])
  (setq tabulated-list-padding 2)
  (setq tabulated-list-sort-key (cons "Status" nil))
  (add-hook 'tabulated-list-revert-hook 'package-menu--refresh nil t)
  (tabulated-list-init-header))

(defmacro package--push (pkg-desc status listname)
  "Convenience macro for `package-menu--generate'.
If the alist stored in the symbol LISTNAME lacks an entry for a
package PKG-DESC, add one.  The alist is keyed with PKG-DESC."
  `(unless (assoc ,pkg-desc ,listname)
     ;; FIXME: Should we move status into pkg-desc?
     (push (cons ,pkg-desc ,status) ,listname)))

(defvar package-list-unversioned nil
  "If non-nil include packages that don't have a version in `list-package'.")

(defun package-desc-status (pkg-desc)
  (let* ((name (package-desc-name pkg-desc))
         (dir (package-desc-dir pkg-desc))
         (lle (assq name package-load-list))
         (held (cadr lle))
         (version (package-desc-version pkg-desc)))
    (cond
     ((eq dir 'builtin) "built-in")
     ((and lle (null held)) "disabled")
     ((stringp held)
      (let ((hv (if (stringp held) (version-to-list held))))
        (cond
         ((version-list-= version hv) "held")
         ((version-list-< version hv) "obsolete")
         (t "disabled"))))
     ((package-built-in-p name version) "obsolete")
     (dir                               ;One of the installed packages.
      (cond
       ((not (file-exists-p (package-desc-dir pkg-desc))) "deleted")
       ((eq pkg-desc (cadr (assq name package-alist))) "installed")
       (t "obsolete")))
     (t
      (let* ((ins (cadr (assq name package-alist)))
             (ins-v (if ins (package-desc-version ins))))
        (cond
         ((or (null ins) (version-list-< ins-v version))
          (if (memq name package-menu--new-package-list)
              "new" "available"))
         ((version-list-< version ins-v) "obsolete")
         ((version-list-= version ins-v) "installed")))))))

(defun package-menu--refresh (&optional packages)
  "Re-populate the `tabulated-list-entries'.
PACKAGES should be nil or t, which means to display all known packages."
  ;; Construct list of (PKG-DESC . STATUS).
  (unless packages (setq packages t))
  (let (info-list name)
    ;; Installed packages:
    (dolist (elt package-alist)
      (setq name (car elt))
      (when (or (eq packages t) (memq name packages))
        (dolist (pkg (cdr elt))
          (package--push pkg (package-desc-status pkg) info-list))))

    ;; Built-in packages:
    (dolist (elt package--builtins)
      (setq name (car elt))
      (when (and (not (eq name 'emacs)) ; Hide the `emacs' package.
                 (or package-list-unversioned
                     (package--bi-desc-version (cdr elt)))
		 (or (eq packages t) (memq name packages)))
    	(package--push (package--from-builtin elt) "built-in" info-list)))

    ;; Available and disabled packages:
    (dolist (elt package-archive-contents)
      (setq name (car elt))
      (when (or (eq packages t) (memq name packages))
        (dolist (pkg (cdr elt))
          ;; Hide obsolete packages.
          (unless (package-installed-p (package-desc-name pkg)
                                       (package-desc-version pkg))
            (package--push pkg (package-desc-status pkg) info-list)))))

    ;; Print the result.
    (setq tabulated-list-entries
          (mapcar #'package-menu--print-info info-list))))

(defun package-menu--generate (remember-pos packages)
  "Populate the Package Menu.
 If REMEMBER-POS is non-nil, keep point on the same entry.
PACKAGES should be t, which means to display all known packages,
or a list of package names (symbols) to display."
  (package-menu--refresh packages)
  (tabulated-list-print remember-pos))

(defun package-menu--print-info (pkg)
  "Return a package entry suitable for `tabulated-list-entries'.
PKG has the form (PKG-DESC . STATUS).
Return (PKG-DESC [NAME VERSION STATUS DOC])."
  (let* ((pkg-desc (car pkg))
	 (status  (cdr pkg))
	 (face (pcase status
		(`"built-in"  'font-lock-builtin-face)
		(`"available" 'default)
		(`"new"       'bold)
		(`"held"      'font-lock-constant-face)
		(`"disabled"  'font-lock-warning-face)
		(`"installed" 'font-lock-comment-face)
		(_            'font-lock-warning-face)))) ; obsolete.
    (list pkg-desc
	  (vector (list (symbol-name (package-desc-name pkg-desc))
			'face 'link
			'follow-link t
			'package-desc pkg-desc
			'action 'package-menu-describe-package)
		  (propertize (package-version-join
                               (package-desc-version pkg-desc))
			      'font-lock-face face)
		  (propertize status 'font-lock-face face)
		  (propertize (package-desc-summary pkg-desc)
                              'font-lock-face face)))))

(defun package-menu-refresh ()
  "Download the Emacs Lisp package archive.
This fetches the contents of each archive specified in
`package-archives', and then refreshes the package menu."
  (interactive)
  (unless (derived-mode-p 'package-menu-mode)
    (error "The current buffer is not a Package Menu"))
  (package-refresh-contents)
  (package-menu--generate t t))

(defun package-menu-describe-package (&optional button)
  "Describe the current package.
If optional arg BUTTON is non-nil, describe its associated package."
  (interactive)
  (let ((pkg-desc (if button (button-get button 'package-desc)
		    (tabulated-list-get-id))))
    (if pkg-desc
	(describe-package pkg-desc)
      (error "No package here"))))

;; fixme numeric argument
(defun package-menu-mark-delete (&optional _num)
  "Mark a package for deletion and move to the next line."
  (interactive "p")
  (if (member (package-menu-get-status) '("installed" "obsolete"))
      (tabulated-list-put-tag "D" t)
    (forward-line)))

(defun package-menu-mark-install (&optional _num)
  "Mark a package for installation and move to the next line."
  (interactive "p")
  (if (member (package-menu-get-status) '("available" "new"))
      (tabulated-list-put-tag "I" t)
    (forward-line)))

(defun package-menu-mark-unmark (&optional _num)
  "Clear any marks on a package and move to the next line."
  (interactive "p")
  (tabulated-list-put-tag " " t))

(defun package-menu-backup-unmark ()
  "Back up one line and clear any marks on that package."
  (interactive)
  (forward-line -1)
  (tabulated-list-put-tag " "))

(defun package-menu-mark-obsolete-for-deletion ()
  "Mark all obsolete packages for deletion."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (not (eobp))
      (if (equal (package-menu-get-status) "obsolete")
	  (tabulated-list-put-tag "D" t)
	(forward-line 1)))))

(defun package-menu-quick-help ()
  "Show short key binding help for package-menu-mode."
  (interactive)
  (message "n-ext, i-nstall, d-elete, u-nmark, x-ecute, r-efresh, h-elp"))

(define-obsolete-function-alias
  'package-menu-view-commentary 'package-menu-describe-package "24.1")

(defun package-menu-get-status ()
  (let* ((id (tabulated-list-get-id))
	 (entry (and id (assq id tabulated-list-entries))))
    (if entry
	(aref (cadr entry) 2)
      "")))

(defun package-menu--find-upgrades ()
  (let (installed available upgrades)
    ;; Build list of installed/available packages in this buffer.
    (dolist (entry tabulated-list-entries)
      ;; ENTRY is (PKG-DESC [NAME VERSION STATUS DOC])
      (let ((pkg-desc (car entry))
	    (status (aref (cadr entry) 2)))
	(cond ((equal status "installed")
	       (push pkg-desc installed))
	      ((member status '("available" "new"))
	       (push (cons (package-desc-name pkg-desc) pkg-desc)
                     available)))))
    ;; Loop through list of installed packages, finding upgrades.
    (dolist (pkg-desc installed)
      (let ((avail-pkg (assq (package-desc-name pkg-desc) available)))
	(and avail-pkg
	     (version-list-< (package-desc-version pkg-desc)
                             (package-desc-version (cdr avail-pkg)))
	     (push avail-pkg upgrades))))
    upgrades))

(defun package-menu-mark-upgrades ()
  "Mark all upgradable packages in the Package Menu.
For each installed package with a newer version available, place
an (I)nstall flag on the available version and a (D)elete flag on
the installed version.  A subsequent \\[package-menu-execute]
call will upgrade the package."
  (interactive)
  (unless (derived-mode-p 'package-menu-mode)
    (error "The current buffer is not a Package Menu"))
  (let ((upgrades (package-menu--find-upgrades)))
    (if (null upgrades)
	(message "No packages to upgrade.")
      (widen)
      (save-excursion
	(goto-char (point-min))
	(while (not (eobp))
	  (let* ((pkg-desc (tabulated-list-get-id))
		 (upgrade (cdr (assq (package-desc-name pkg-desc) upgrades))))
	    (cond ((null upgrade)
		   (forward-line 1))
		  ((equal pkg-desc upgrade)
		   (package-menu-mark-install))
		  (t
		   (package-menu-mark-delete))))))
      (message "%d package%s marked for upgrading."
	       (length upgrades)
	       (if (= (length upgrades) 1) "" "s")))))

(defun package-menu-execute (&optional noquery)
  "Perform marked Package Menu actions.
Packages marked for installation are downloaded and installed;
packages marked for deletion are removed.
Optional argument NOQUERY non-nil means do not ask the user to confirm."
  (interactive)
  (unless (derived-mode-p 'package-menu-mode)
    (error "The current buffer is not in Package Menu mode"))
  (let (install-list delete-list cmd pkg-desc)
    (save-excursion
      (goto-char (point-min))
      (while (not (eobp))
	(setq cmd (char-after))
	(unless (eq cmd ?\s)
	  ;; This is the key PKG-DESC.
	  (setq pkg-desc (tabulated-list-get-id))
	  (cond ((eq cmd ?D)
		 (push pkg-desc delete-list))
		((eq cmd ?I)
		 (push pkg-desc install-list))))
	(forward-line)))
    (when install-list
      (if (or
           noquery
           (yes-or-no-p
            (if (= (length install-list) 1)
                (format "Install package `%s'? "
                        (package-desc-full-name (car install-list)))
              (format "Install these %d packages (%s)? "
                      (length install-list)
                      (mapconcat #'package-desc-full-name
                                 install-list ", ")))))
	  (mapc 'package-install install-list)))
    ;; Delete packages, prompting if necessary.
    (when delete-list
      (if (or
           noquery
           (yes-or-no-p
	   (if (= (length delete-list) 1)
	       (format "Delete package `%s'? "
                       (package-desc-full-name (car delete-list)))
	     (format "Delete these %d packages (%s)? "
		     (length delete-list)
		     (mapconcat #'package-desc-full-name
				delete-list ", ")))))
	  (dolist (elt delete-list)
	    (condition-case-unless-debug err
		(package-delete elt)
	      (error (message (cadr err)))))
	(error "Aborted")))
    (if (or delete-list install-list)
	(package-menu--generate t t)
      (message "No operations specified."))))

(defun package-menu--version-predicate (A B)
  (let ((vA (or (aref (cadr A) 1)  '(0)))
	(vB (or (aref (cadr B) 1) '(0))))
    (if (version-list-= vA vB)
	(package-menu--name-predicate A B)
      (version-list-< vA vB))))

(defun package-menu--status-predicate (A B)
  (let ((sA (aref (cadr A) 2))
	(sB (aref (cadr B) 2)))
    (cond ((string= sA sB)
	   (package-menu--name-predicate A B))
	  ((string= sA "new") t)
	  ((string= sB "new") nil)
	  ((string= sA "available") t)
	  ((string= sB "available") nil)
	  ((string= sA "installed") t)
	  ((string= sB "installed") nil)
	  ((string= sA "held") t)
	  ((string= sB "held") nil)
	  ((string= sA "built-in") t)
	  ((string= sB "built-in") nil)
	  ((string= sA "obsolete") t)
	  ((string= sB "obsolete") nil)
	  (t (string< sA sB)))))

(defun package-menu--description-predicate (A B)
  (let ((dA (aref (cadr A) 3))
	(dB (aref (cadr B) 3)))
    (if (string= dA dB)
	(package-menu--name-predicate A B)
      (string< dA dB))))

(defun package-menu--name-predicate (A B)
  (string< (symbol-name (package-desc-name (car A)))
	   (symbol-name (package-desc-name (car B)))))

;;;###autoload
(defun list-packages (&optional no-fetch)
  "Display a list of packages.
This first fetches the updated list of packages before
displaying, unless a prefix argument NO-FETCH is specified.
The list is displayed in a buffer named `*Packages*'."
  (interactive "P")
  (require 'finder-inf nil t)
  ;; Initialize the package system if necessary.
  (unless package--initialized
    (package-initialize t))
  (let (old-archives new-packages)
    (unless no-fetch
      ;; Read the locally-cached archive-contents.
      (package-read-all-archive-contents)
      (setq old-archives package-archive-contents)
      ;; Fetch the remote list of packages.
      (package-refresh-contents)
      ;; Find which packages are new.
      (dolist (elt package-archive-contents)
	(unless (assq (car elt) old-archives)
	  (push (car elt) new-packages))))

    ;; Generate the Package Menu.
    (let ((buf (get-buffer-create "*Packages*")))
      (with-current-buffer buf
	(package-menu-mode)
	(set (make-local-variable 'package-menu--new-package-list)
	     new-packages)
	(package-menu--generate nil t))
      ;; The package menu buffer has keybindings.  If the user types
      ;; `M-x list-packages', that suggests it should become current.
      (switch-to-buffer buf))

    (let ((upgrades (package-menu--find-upgrades)))
      (if upgrades
	  (message "%d package%s can be upgraded; type `%s' to mark %s for upgrading."
		   (length upgrades)
		   (if (= (length upgrades) 1) "" "s")
		   (substitute-command-keys "\\[package-menu-mark-upgrades]")
		   (if (= (length upgrades) 1) "it" "them"))))))

;;;###autoload
(defalias 'package-list-packages 'list-packages)

;; Used in finder.el
(defun package-show-package-list (packages)
  "Display PACKAGES in a *Packages* buffer.
This is similar to `list-packages', but it does not fetch the
updated list of packages, and it only displays packages with
names in PACKAGES (which should be a list of symbols)."
  (require 'finder-inf nil t)
  (let ((buf (get-buffer-create "*Packages*")))
    (with-current-buffer buf
      (package-menu-mode)
      (package-menu--generate nil packages))
    (switch-to-buffer buf)))

(defun package-list-packages-no-fetch ()
  "Display a list of packages.
Does not fetch the updated list of packages before displaying.
The list is displayed in a buffer named `*Packages*'."
  (interactive)
  (list-packages t))

(provide 'package)

;;; package.el ends here
