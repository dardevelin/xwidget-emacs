;;; color.el --- Color manipulation laboratory routines -*- coding: utf-8; -*-

;; Copyright (C) 2010-2011 Free Software Foundation, Inc.

;; Author: Julien Danjou <julien@danjou.info>
;; Keywords: html

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

;; This package provides color manipulation functions.

;;; Code:

(eval-when-compile
  (require 'cl))

;; Emacs < 23.3
(eval-and-compile
  (unless (boundp 'float-pi)
    (defconst float-pi (* 4 (atan 1)) "The value of Pi (3.1415926...).")))

(defun color-rgb->hex  (red green blue)
  "Return hexadecimal notation for RED GREEN BLUE color.
RED GREEN BLUE must be values between 0 and 1 inclusively."
  (format "#%02x%02x%02x"
          (* red 255) (* green 255) (* blue 255)))

(defun color-complement (color)
  "Return the color that is the complement of COLOR."
  (let ((color (color-rgb->normalize color)))
    (list (- 1.0 (car color))
          (- 1.0 (cadr color))
          (- 1.0 (caddr color)))))

(defun color-gradient (start stop step-number)
  "Return a list with STEP-NUMBER colors from START to STOP.
The color list builds a color gradient starting at color START to
color STOP. It does not include the START and STOP color in the
resulting list."
  (loop for i from 1 to step-number
        with red-step = (/ (- (car stop) (car start)) (1+ step-number))
        with green-step = (/ (- (cadr stop) (cadr start)) (1+ step-number))
        with blue-step = (/ (- (caddr stop) (caddr start)) (1+ step-number))
        collect (list
                 (+ (car start) (* i red-step))
                 (+ (cadr start) (* i green-step))
                 (+ (caddr start) (* i blue-step)))))

(defun color-complement-hex (color)
  "Return the color that is the complement of COLOR, in hexadecimal format."
  (apply 'color-rgb->hex (color-complement color)))

(defun color-rgb->hsv (red green blue)
  "Convert RED GREEN BLUE values to HSV representation.
Hue is in radians. Saturation and values are between 0 and 1
inclusively."
   (let* ((r (float red))
	 (g (float green))
	 (b (float blue))
	 (max (max r g b))
	 (min (min r g b)))
     (list
      (/ (* 2 float-pi
            (cond ((and (= r g) (= g b)) 0)
                  ((and (= r max)
                        (>= g b))
                   (* 60 (/ (- g b) (- max min))))
                  ((and (= r max)
                        (< g b))
                   (+ 360 (* 60 (/ (- g b) (- max min)))))
                  ((= max g)
                   (+ 120 (* 60 (/ (- b r) (- max min)))))
                  ((= max b)
                       (+ 240 (* 60 (/ (- r g) (- max min)))))))
         360)
      (if (= max 0)
          0
        (- 1 (/ min max)))
      (/ max 255.0))))

(defun color-rgb->hsl (red green blue)
  "Convert RED GREEN BLUE colors to their HSL representation.
RED, GREEN and BLUE must be between 0 and 1 inclusively."
  (let* ((r red)
         (g green)
         (b blue)
         (max (max r g b))
         (min (min r g b))
         (delta (- max min))
         (l (/ (+ max min) 2.0)))
    (list
     (if (= max min)
         0
       (* 2 float-pi
          (/ (cond ((= max r)
                    (+ (/ (- g b) delta) (if (< g b) 6 0)))
                   ((= max g)
                 (+ (/ (- b r) delta) 2))
                   (t
                    (+ (/ (- r g) delta) 4)))
             6)))
     (if (= max min)
         0
       (if (> l 0.5)
           (/ delta (- 2 (+ max min)))
         (/ delta (+ max min))))
     l)))

(defun color-srgb->xyz (red green blue)
  "Converts RED GREEN BLUE colors from the sRGB color space to CIE XYZ.
RED, BLUE and GREEN must be between 0 and 1 inclusively."
  (let ((r (if (<= red 0.04045)
               (/ red 12.95)
             (expt (/ (+ red 0.055) 1.055) 2.4)))
        (g (if (<= green 0.04045)
               (/ green 12.95)
             (expt (/ (+ green 0.055) 1.055) 2.4)))
        (b (if (<= blue 0.04045)
               (/ blue 12.95)
             (expt (/ (+ blue 0.055) 1.055) 2.4))))
    (list (+ (* 0.4124564 r) (* 0.3575761 g) (* 0.1804375 b))
          (+ (* 0.21266729 r) (* 0.7151522 g) (* 0.0721750 b))
          (+ (* 0.0193339 r) (* 0.1191920 g) (* 0.9503041 b)))))

(defun color-xyz->srgb (X Y Z)
  "Converts CIE X Y Z colors to sRGB color space."
  (let ((r (+ (* 3.2404542 X) (* -1.5371385 Y) (* -0.4985314 Z)))
        (g (+ (* -0.9692660 X) (* 1.8760108 Y) (* 0.0415560 Z)))
        (b (+ (* 0.0556434 X) (* -0.2040259 Y) (* 1.0572252 Z))))
    (list (if (<= r 0.0031308)
              (* 12.92 r)
            (- (* 1.055 (expt r (/ 1 2.4))) 0.055))
          (if (<= g 0.0031308)
              (* 12.92 g)
            (- (* 1.055 (expt g (/ 1 2.4))) 0.055))
          (if (<= b 0.0031308)
              (* 12.92 b)
            (- (* 1.055 (expt b (/ 1 2.4))) 0.055)))))

(defconst color-d65-xyz '(0.950455 1.0 1.088753)
  "D65 white point in CIE XYZ.")

(defconst color-cie-ε (/ 216 24389.0))
(defconst color-cie-κ (/ 24389 27.0))

(defun color-xyz->lab (X Y Z &optional white-point)
  "Converts CIE XYZ to CIE L*a*b*.
WHITE-POINT can be specified as (X Y Z) white point to use. If
none is set, `color-d65-xyz' is used."
  (destructuring-bind (Xr Yr Zr) (or white-point color-d65-xyz)
      (let* ((xr (/ X Xr))
             (yr (/ Y Yr))
             (zr (/ Z Zr))
             (fx (if (> xr color-cie-ε)
                     (expt xr (/ 1 3.0))
                   (/ (+ (* color-cie-κ xr) 16) 116.0)))
             (fy (if (> yr color-cie-ε)
                     (expt yr (/ 1 3.0))
                   (/ (+ (* color-cie-κ yr) 16) 116.0)))
             (fz (if (> zr color-cie-ε)
                     (expt zr (/ 1 3.0))
                   (/ (+ (* color-cie-κ zr) 16) 116.0))))
        (list
         (- (* 116 fy) 16)                  ; L
         (* 500 (- fx fy))                  ; a
         (* 200 (- fy fz))))))              ; b

(defun color-lab->xyz (L a b &optional white-point)
  "Converts CIE L*a*b* to CIE XYZ.
WHITE-POINT can be specified as (X Y Z) white point to use. If
none is set, `color-d65-xyz' is used."
  (destructuring-bind (Xr Yr Zr) (or white-point color-d65-xyz)
      (let* ((fy (/ (+ L 16) 116.0))
             (fz (- fy (/ b 200.0)))
             (fx (+ (/ a 500.0) fy))
             (xr (if (> (expt fx 3.0) color-cie-ε)
                     (expt fx 3.0)
               (/ (- (* fx 116) 16) color-cie-κ)))
             (yr (if (> L (* color-cie-κ color-cie-ε))
                     (expt (/ (+ L 16) 116.0) 3.0)
                   (/ L color-cie-κ)))
             (zr (if (> (expt fz 3) color-cie-ε)
                     (expt fz 3.0)
                   (/ (- (* 116 fz) 16) color-cie-κ))))
        (list (* xr Xr)                 ; X
              (* yr Yr)                 ; Y
              (* zr Zr)))))             ; Z

(defun color-srgb->lab (red green blue)
  "Converts RGB to CIE L*a*b*."
  (apply 'color-xyz->lab (color-srgb->xyz red green blue)))

(defun color-rgb->normalize (color)
  "Normalize a RGB color to values between 0 and 1 inclusively."
  (mapcar (lambda (x) (/ x 65535.0)) (x-color-values color)))

(defun color-lab->srgb (L a b)
  "Converts CIE L*a*b* to RGB."
  (apply 'color-xyz->srgb (color-lab->xyz L a b)))

(defun color-cie-de2000 (color1 color2 &optional kL kC kH)
  "Computes the CIEDE2000 color distance between COLOR1 and COLOR2.
Colors must be in CIE L*a*b* format."
  (destructuring-bind (L₁ a₁ b₁) color1
    (destructuring-bind (L₂ a₂ b₂) color2
      (let* ((kL (or kL 1))
             (kC (or kC 1))
             (kH (or kH 1))
             (C₁ (sqrt (+ (expt a₁ 2.0) (expt b₁ 2.0))))
             (C₂ (sqrt (+ (expt a₂ 2.0) (expt b₂ 2.0))))
             (C̄ (/ (+ C₁ C₂) 2.0))
             (G (* 0.5 (- 1 (sqrt (/ (expt C̄ 7.0) (+ (expt C̄ 7.0) (expt 25 7.0)))))))
             (a′₁ (* (+ 1 G) a₁))
             (a′₂ (* (+ 1 G) a₂))
             (C′₁ (sqrt (+ (expt a′₁ 2.0) (expt b₁ 2.0))))
             (C′₂ (sqrt (+ (expt a′₂ 2.0) (expt b₂ 2.0))))
             (h′₁ (if (and (= b₁ 0) (= a′₁ 0))
                      0
                    (let ((v (atan b₁ a′₁)))
                      (if (< v 0)
                          (+ v (* 2 float-pi))
                        v))))
             (h′₂ (if (and (= b₂ 0) (= a′₂ 0))
                      0
                    (let ((v (atan b₂ a′₂)))
                      (if (< v 0)
                          (+ v (* 2 float-pi))
                        v))))
             (ΔL′ (- L₂ L₁))
             (ΔC′ (- C′₂ C′₁))
             (Δh′ (cond ((= (* C′₁ C′₂) 0)
                         0)
                        ((<= (abs (- h′₂ h′₁)) float-pi)
                         (- h′₂ h′₁))
                        ((> (- h′₂ h′₁) float-pi)
                         (- (- h′₂ h′₁) (* 2 float-pi)))
                        ((< (- h′₂ h′₁) (- float-pi))
                         (+ (- h′₂ h′₁) (* 2 float-pi)))))
             (ΔH′ (* 2 (sqrt (* C′₁ C′₂)) (sin (/ Δh′ 2.0))))
             (L̄′ (/ (+ L₁ L₂) 2.0))
             (C̄′ (/ (+ C′₁ C′₂) 2.0))
             (h̄′ (cond ((= (* C′₁ C′₂) 0)
                        (+ h′₁ h′₂))
                       ((<= (abs (- h′₁ h′₂)) float-pi)
                        (/ (+ h′₁ h′₂) 2.0))
                       ((< (+ h′₁ h′₂) (* 2 float-pi))
                        (/ (+ h′₁ h′₂ (* 2 float-pi)) 2.0))
                       ((>= (+ h′₁ h′₂) (* 2 float-pi))
                        (/ (+ h′₁ h′₂ (* -2 float-pi)) 2.0))))
             (T (+ 1
                   (- (* 0.17 (cos (- h̄′ (degrees-to-radians 30)))))
                   (* 0.24 (cos (* h̄′ 2)))
                   (* 0.32 (cos (+ (* h̄′ 3) (degrees-to-radians 6))))
                   (- (* 0.20 (cos (- (* h̄′ 4) (degrees-to-radians 63)))))))
             (Δθ (* (degrees-to-radians 30) (exp (- (expt (/ (- h̄′ (degrees-to-radians 275)) (degrees-to-radians 25)) 2.0)))))
             (Rc (* 2 (sqrt (/ (expt C̄′ 7.0) (+ (expt C̄′ 7.0) (expt 25.0 7.0))))))
             (Sl (+ 1 (/ (* 0.015 (expt (- L̄′ 50) 2.0)) (sqrt (+ 20 (expt (- L̄′ 50) 2.0))))))
             (Sc (+ 1 (* C̄′ 0.045)))
             (Sh (+ 1 (* 0.015 C̄′ T)))
             (Rt (- (* (sin (* Δθ 2)) Rc))))
        (sqrt (+ (expt (/ ΔL′ (* Sl kL)) 2.0)
                 (expt (/ ΔC′ (* Sc kC)) 2.0)
                 (expt (/ ΔH′ (* Sh kH)) 2.0)
                 (* Rt (/ ΔC′ (* Sc kC)) (/ ΔH′ (* Sh kH)))))))))

(provide 'color)

;;; color.el ends here
