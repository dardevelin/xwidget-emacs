;;; zlib-tests.el --- Test suite for zlib.

;; Copyright (C) 2013 Free Software Foundation, Inc.

;; Author: Lars Ingebrigtsen <larsi@gnus.org>

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

;;; Code:

(require 'ert)

(ert-deftest zlib--decompress ()
  "Test decompressing a gzipped file."
  (when (and (fboundp 'zlib-available-p)
	     (zlib-available-p))
    (should (string=
	     (with-temp-buffer
	       (set-buffer-multibyte nil)
	       (insert-file-contents-literally "data/decompress/foo-gzipped")
	       (zlib-decompress-region (point-min) (point-max))
	       (buffer-string))
	     "foo\n"))))

(provide 'zlib-tests)

;;; zlib-tests.el ends here.
