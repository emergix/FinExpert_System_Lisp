(setq #:sys-package:colon '{beau-cadre})

(de :create ()
        (new '{beau-cadre}))

(de :initialize (beau-cadre x y w h relief)
        (:relief? beau-cadre relief)
        (:pattern-fond beau-cadre :default-fond)
        (:pattern-soleil beau-cadre :default-soleil)
        (:pattern-ombre beau-cadre :default-ombre)
        (:epaisseur-w beau-cadre :default-width)        
        (:epaisseur-h beau-cadre :default-height)
        (send 'x beau-cadre x)
        (send 'y beau-cadre y)
        (send 'w beau-cadre (max w (mul 2 (:epaisseur-w beau-cadre))))
        (send 'h beau-cadre (max h (mul 2 (:epaisseur-h beau-cadre))))
        beau-cadre)

(de beau-cadre (x y w h relief?)
        (:initialize (:create) x y w h relief?) )

(de :prepare-vectors (beau-cadre x y w h)
        (:compute-vector :v-internal-x
                         :v-internal-y
                         (add x (:epaisseur-w beau-cadre))
                         (add y (:epaisseur-h beau-cadre))
                         (sub w (mul 2 (:epaisseur-w beau-cadre)))
                         (sub h (mul 2 (:epaisseur-h beau-cadre))) )
        (:compute-vector :v-external-x
                         :v-external-y
                         x y w h)
        (:set-v-ombre beau-cadre)
        (:set-v-soleil beau-cadre)
      ))

(de :compute-vector (v-x v-y x y w h)
     (let* ((largeur-coin 3)   ; impair c'est plus mieux !
            (demi-largeur (div largeur-coin 2))
           )
        ;
        ; les 8 premiers decrivent les contours
        ; les 4 derniers sont des points necessaires pour les
        ; zones d'ombres ..
          (vset v-x 0 x)
          (vset v-y 0 (add y largeur-coin))
          (vset v-x 1 (add x largeur-coin))
          (vset v-y 1 y)
          (vset v-x 2 (add x (sub w largeur-coin)))
          (vset v-y 2 y)
          (vset v-x 3 (add x w))
          (vset v-y 3 (add y largeur-coin))
          (vset v-x 4 (add x w))
          (vset v-y 4 (add y (sub h largeur-coin)))
          (vset v-x 5 (add x (sub w largeur-coin)))
          (vset v-y 5 (add y h))
          (vset v-x 6 (add x largeur-coin))
          (vset v-y 6 (add y h))
          (vset v-x 7 x)
          (vset v-y 7 (add y (sub h largeur-coin)))
          (vset v-x 8 x)
          (vset v-y 8 (add y largeur-coin))
        ;
          (vset v-x 9  (add (vref v-x 0) demi-largeur))
          (vset v-y 9  (add (vref v-y 1) demi-largeur))
          (vset v-x 10 (add (vref v-x 2) demi-largeur))
          (vset v-y 10 (add (vref v-y 1) demi-largeur))
          (vset v-x 11 (add (vref v-x 5) demi-largeur))
          (vset v-y 11 (add (vref v-y 4) demi-largeur))
          (vset v-x 12 (add (vref v-x 7) demi-largeur))
          (vset v-y 12 (add (vref v-y 7) demi-largeur))
     ))

(de :set-v-ombre (beau-cadre)
    (let ((v-x :v-ombre-x)
          (v-y :v-ombre-y)
          (v-in-x :v-internal-x)
          (v-in-y :v-internal-y)
          (v-ex-x :v-external-x)
          (v-ex-y :v-external-y)
         )
       (vset v-x 0 (vref v-in-x 10))
       (vset v-y 0 (vref v-in-y 10))
       (vset v-x 1 (vref v-ex-x 10))
       (vset v-y 1 (vref v-ex-y 10))
       (vset v-x 2 (vref v-ex-x 3))
       (vset v-y 2 (vref v-ex-y 3))
       (vset v-x 3 (vref v-ex-x 4))
       (vset v-y 3 (vref v-ex-y 4))
       (vset v-x 4 (vref v-ex-x 5))
       (vset v-y 4 (vref v-ex-y 5))
       (vset v-x 5 (vref v-ex-x 6))
       (vset v-y 5 (vref v-ex-y 6))
       (vset v-x 6 (vref v-ex-x 12))
       (vset v-y 6 (vref v-ex-y 12))
       (vset v-x 7 (vref v-in-x 12))
       (vset v-y 7 (vref v-in-y 12))
       (vset v-x 8 (vref v-in-x 6))
       (vset v-y 8 (vref v-in-y 6))
       (vset v-x 9 (vref v-in-x 5))
       (vset v-y 9 (vref v-in-y 5))
       (vset v-x 10 (vref v-in-x 4))
       (vset v-y 10 (vref v-in-y 4))
       (vset v-x 11 (vref v-in-x 3))
       (vset v-y 11 (vref v-in-y 3))
       (vset v-x 12 (vref v-in-x 10))
       (vset v-y 12 (vref v-in-y 10))
    ))

(de :set-v-soleil (beau-cadre)
    (let ((v-x :v-soleil-x)
          (v-y :v-soleil-y)
          (v-in-x :v-internal-x)
          (v-in-y :v-internal-y)
          (v-ex-x :v-external-x)
          (v-ex-y :v-external-y)
         )
       (vset v-x 0 (vref v-in-x 10))
       (vset v-y 0 (vref v-in-y 10))
       (vset v-x 1 (vref v-ex-x 10))
       (vset v-y 1 (vref v-ex-y 10))
       (vset v-x 2 (vref v-ex-x 2))
       (vset v-y 2 (vref v-ex-y 2))
       (vset v-x 3 (vref v-ex-x 1))
       (vset v-y 3 (vref v-ex-y 1))
       (vset v-x 4 (vref v-ex-x 8))
       (vset v-y 4 (vref v-ex-y 8))
       (vset v-x 5 (vref v-ex-x 7))
       (vset v-y 5 (vref v-ex-y 7))
       (vset v-x 6 (vref v-ex-x 12))
       (vset v-y 6 (vref v-ex-y 12))
       (vset v-x 7 (vref v-in-x 12))
       (vset v-y 7 (vref v-in-y 12))
       (vset v-x 8 (vref v-in-x 7))
       (vset v-y 8 (vref v-in-y 7))
       (vset v-x 9 (vref v-in-x 0))
       (vset v-y 9 (vref v-in-y 0))
       (vset v-x 10 (vref v-in-x 1))
       (vset v-y 10 (vref v-in-y 1))
       (vset v-x 11 (vref v-in-x 2))
       (vset v-y 11 (vref v-in-y 2))
       (vset v-x 12 (vref v-in-x 10))
       (vset v-y 12 (vref v-in-y 10))
    ))

(de :display (beau-cadre dx dy region)
        (let ((x (add dx (send 'x beau-cadre)))
              (y (add dy (send 'y beau-cadre)))
              (pattern-ombre (:pattern-ombre beau-cadre))
              (pattern-soleil (:pattern-soleil beau-cadre))
             )
          (when (not (:relief? beau-cadre))
                (setq pattern-ombre (:pattern-soleil beau-cadre))
                (setq pattern-soleil (:pattern-ombre beau-cadre)) )

          (:prepare-vectors beau-cadre 
                        x y (send 'w beau-cadre) (send 'h beau-cadre))
        ;
        ; le fond
          (with ((current-pattern (:pattern-fond beau-cadre)))
                (fill-area 9 
                        :v-internal-x
                        :v-internal-y))
        ;
        ; l'ombre
          (with ((current-pattern pattern-ombre))
                (fill-area 13
                        :v-ombre-x
                        :v-ombre-y))
        ;
        ; le soleil ..
          (with ((current-pattern pattern-soleil))
                (fill-area 13
                        :v-soleil-x
                        :v-soleil-y))
           (draw-polyline 9 
                        :v-internal-x
                        :v-internal-y)
           (draw-polyline 9
                        :v-external-x
                        :v-external-y)
           (draw-line (vref :v-internal-x 9)
                      (vref :v-internal-y 9)
                      (vref :v-external-x 9)
                      (vref :v-external-y 9))
           (draw-line (vref :v-internal-x 11)
                      (vref :v-internal-y 11)
                      (vref :v-external-x 11)
                      (vref :v-external-y 11))
        ))

(de :invert-display (beau-cadre dx dy region)
        (:relief? beau-cadre (not (:relief? beau-cadre))) 
        (send 'display beau-cadre dx dy region))

(de :grow (beau-cadre w h)
        (setq w (max w (mul 2 (:epaisseur-w beau-cadre))))
        (setq h (max h (mul 2 (:epaisseur-h beau-cadre))))
        (send-super '{beau-cadre} 'grow beau-cadre w h))


;;; specifique  MASAI


(defabbrev code code)

(de {beau-cadre}:code (image)
    `(beau-cadre ,@({code}:xywh image)
                 ,(:relief? image)))





