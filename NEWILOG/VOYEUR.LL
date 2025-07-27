
(setq #:sys-package:colon '{voyeur})

;
; creation

(de :create ()
        (new '{voyeur}))

(de :initialize (voyeur x y w h x0 y0 w0 h0
                        scroll-h? scroll-v?
                        zoom-h? zoom-w? image)
        (let* ((scrollee ())
               (scrollwindow ())
              )
           (send 'x voyeur x)
           (send 'y voyeur y)
           (send 'w voyeur w)
           (send 'h voyeur h)
           (:scroll-h? voyeur scroll-h?)
           (:scroll-v? voyeur scroll-v?)
           (:zoom-w? voyeur zoom-w?)
           (:zoom-h? voyeur zoom-h?)
           (:min-zoom voyeur :min-zoom-par-defaut)
           (:max-zoom voyeur :max-zoom-par-defaut)
           (setq scrollee 
                (application '#:image:rectangle:application x0 y0 w0 h0 image))
           (setq scrollwindow 
                (application '#:image:rectangle:application 0 0 w h 
                                  (view scrollee)))
           (send 'scrollee voyeur scrollee)
           (send 'scrollwindow voyeur scrollwindow)
           (send 'image voyeur scrollwindow)
           voyeur))

;
; x y w h concernent le voyeur
; x0 y0 w0 h0 concernent le presentateur scrolle'

(de voyeur (x y w h x0 y0 w0 h0 presentateur)
    (send 'grow presentateur w0 h0)
    (:initialize (:create) x y w h x0 y0 w0 h0 t t t t presentateur) )

(de v-voyeur (x y w h x0 y0 w0 h0 presentateur)
    (send 'grow presentateur w0 h0)
    (:initialize (:create) x y w h x0 y0 w0 h0 () t t () presentateur) )

(de h-voyeur (x y w h x0 y0 w0 h0 presentateur)
    (send 'grow presentateur w0 h0)
    (:initialize (:create) x y w h x0 y0 w0 h0 t () () t presentateur) )

(de f-voyeur (x y w h x0 y0 w0 h0 presentateur)
    (send 'grow presentateur w0 h0)
    (:initialize (:create) x y w h x0 y0 w0 h0 () () () () presentateur) )

;
; le scrolling :
; on fait scroller le voyeur de DX DY

(de :scroll (voyeur dx dy redisplay?)
   (let* ((image-scrollee (send 'scrollee voyeur))
          (cur-x (send 'x image-scrollee))
          (cur-y (send 'y image-scrollee))
         )
      (setq cur-x 
            (min 0 (max (add dx cur-x)
                        (sub (send 'width voyeur) 
                             (send 'width image-scrollee)))))
      (setq cur-y 
            (min 0 (max (add dy cur-y)
                        (sub (send 'height voyeur) 
                             (send 'height image-scrollee)))))
      (cond ((and (:scroll-v? voyeur)
                  (:scroll-h? voyeur))
             (:scroll-it voyeur (- cur-x) (- cur-y) redisplay?))
            ((:scroll-v? voyeur)
             (:verticalscroll-it voyeur (- cur-y) redisplay?))
            ((:scroll-h? voyeur)
             (:horizontalscroll-it voyeur (- cur-x) redisplay?))
            (t ()))
   ))
;
; on le redefinit pour ne pas avoir de redisplay si on veut...

(de :scroll-it (voyeur x y redisplay?)
     (if redisplay?
        (send-super '{voyeur} 'scroll-it voyeur x y)
        (send 'translate (send 'scrollee voyeur) (sub 0 x) (sub 0 y)) ))

(de :horizontalscroll-it (voyeur x redisplay?)
        (:scroll-it voyeur      
                    x (sub 0 (send 'y (send 'scrollee voyeur)))
                    redisplay?))

(de :verticalscroll-it (voyeur y redisplay?)
        (:scroll-it voyeur 
                    (sub 0 (send 'x (send 'scrollee voyeur))) y
                    redisplay?))

;
; le grow 
; pour pallier un bug du scroller
; (il ne reinitialise lors d'un diminuement de taille que w la premiere
; fois ..

(de :grow (voyeur w h)
    (send-super '{voyeur} 'grow voyeur w h)
    (send 'reinitialise voyeur))

;
; le zoom:
; on zoome en agrandissant ou en reduisant l'application scrollee.
; les facteurs de zoom donne's de'crivent le rapport entre la taille
; du voyeur et celle de l'application scrollee. 
; Ce sont des entiers compris entre MIN-ZOOM et MAX-ZOOM

(de :zoom (voyeur zoom-w zoom-h)
     (let* ((image-scrollee (send 'scrollee voyeur))
            (voyeur-width (send 'width voyeur))
            (voyeur-height (send 'height voyeur))
            (old-image-width (send 'width image-scrollee))
            (old-image-height (send 'height image-scrollee))
            (new-image-width ())
            (new-image-height ())
           )
        (when (:zoom-valide? voyeur zoom-w)
              (when (le zoom-w (:min-zoom voyeur))
                    (setq zoom-w (:min-zoom voyeur)))
              (when (ge zoom-w (:max-zoom voyeur))
                    (setq zoom-w (:max-zoom voyeur))) 
              (setq new-image-width (fix (* zoom-w voyeur-width))) )
        (when (:zoom-valide? voyeur zoom-h)
              (when (le zoom-h (:min-zoom voyeur))
                    (setq zoom-h (:min-zoom voyeur)))
              (when (ge zoom-h (:max-zoom voyeur))
                    (setq zoom-h (:max-zoom voyeur)))
              (setq new-image-height (fix (* zoom-h voyeur-height))) )

        (cond ((and (:zoom-w? voyeur)
                    (:zoom-h? voyeur))
               (send 'grow image-scrollee new-image-width new-image-height)
               (send 'scroll voyeur 
                        (fix (/ (- old-image-width new-image-width) 2))
                        (fix (/ (- old-image-height new-image-height) 2))
                        ())
               (full-redisplay voyeur)
              )
              ((:zoom-w? voyeur)
               (send 'grow image-scrollee new-image-width old-image-height)
               (send 'scroll voyeur 
                        (fix (/ (- old-image-width new-image-width) 2))
                        0 ())
               (full-redisplay voyeur)
              )
              ((:zoom-h? voyeur)
               (send 'grow image-scrollee old-image-width new-image-height)
               (send 'scroll voyeur 
                        0
                        (fix (/ (- old-image-height new-image-height) 2))
                        ())
               (full-redisplay voyeur)
               )
              (t ()))
        ))

(de :zoom-valide? (voyeur zoom)
        (fixp zoom))

(de :current-zoom-w (voyeur)
        (div (send 'width (send 'scrollee voyeur))
           (send 'width voyeur)))

(de :current-zoom-h (voyeur)
        (div (send 'height (send 'scrollee voyeur))
           (send 'height voyeur)))


