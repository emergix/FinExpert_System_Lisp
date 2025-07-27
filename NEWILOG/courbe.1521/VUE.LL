;-----------------------------------------------------------------------------
(setq #:sys-package:colon '{vue-sur-voyeur})


(de :create ()
        (new '{vue-sur-voyeur}))

(de :initialize (vue-sur-voyeur titre type x y w h x0 y0 w0 h0 presentateur)
    (let* ((w-titre 0)
           (h-titre 0)
           (voyeur ())
          )
        (when titre
              (setq w-titre (width-substring titre 0 (slen titre)))
              (setq h-titre (height-substring titre 0 (slen titre))) )

        (setq voyeur (funcall type 1 (add 1 h-titre)
                              (sub w 2) (sub h (add h-titre 2))
                              x0 y0 
                              (sub w0 2) (sub h0 (add h-titre 2))
                              presentateur))

        (:titre vue-sur-voyeur titre)
        (:voyeur vue-sur-voyeur voyeur)
        (if (null titre)
             (send 'image vue-sur-voyeur
                    (%view (box 0 0 w h) voyeur)) 
         (setq titre (%centeredview titre (rectangle 0 0 w-titre h-titre)))
         (send 'image vue-sur-voyeur
               (%view (box 0 0 w h)
                      (translation (sub (div w 2) (div w-titre 2)) 1 titre)
                      voyeur)) )

        (send 'x vue-sur-voyeur x)
        (send 'y vue-sur-voyeur y)
        (send 'fit-to-contents vue-sur-voyeur)
        vue-sur-voyeur))

(de vue-sur-voyeur (titre x y w h x0 y0 w0 h0 presentateur)
     (:initialize (:create) titre 'voyeur x y w h x0 y0 w0 h0 presentateur) )

(de vue-sur-h-voyeur (titre x y w h x0 y0 w0 h0 presentateur)
     (:initialize (:create) titre 'h-voyeur x y w h x0 y0 w0 h0 presentateur) )

(de vue-sur-v-voyeur (titre x y w h x0 y0 w0 h0 presentateur)
     (:initialize (:create) titre 'v-voyeur x y w h x0 y0 w0 h0 presentateur) )

(de vue-sur-f-voyeur (titre x y w h x0 y0 w0 h0 presentateur)
     (:initialize (:create) titre 'f-voyeur x y w h x0 y0 w0 h0 presentateur))


