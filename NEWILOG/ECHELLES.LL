;----------------------------------------------------------------------
(setq #:sys-package:colon '{mes-graduations})

(de :create ()
        (new '{mes-graduations}))

(de :initialize (grad police longueur chaine valeur hor? texte-avant?)
        (:police grad police)
        (:longueur grad longueur)
        (:chaine grad chaine)
        (:valeur grad valeur)
        (:hor? grad hor?)
        (:texte-avant? grad texte-avant?)
        grad)

(de grosse-graduation (chaine valeur hor? texte-avant?)
        (:initialize (:create) :police :long-grosse-grad 
                                chaine valeur hor? texte-avant?))

(de petite-graduation (chaine valeur hor? texte-avant?)
        (:initialize (:create) :police :long-petite-grad 
                                chaine valeur hor? texte-avant?))

(de :hauteur-totale (grad)
    (let ((haut 0))
        (when (:chaine grad)
              (with ((current-font (:police grad)))
                    (setq haut
                         (if (not (:hor? grad))
                             (width-substring (:chaine grad) 
                                       0 (slen (:chaine grad)))
                             (height-substring (:chaine grad) 
                                       0 (slen (:chaine grad))) ))))
        haut))

(de :longueur-totale (grad)
    (let ((long 0))
        (when (:chaine grad)
              (with ((current-font (:police grad)))
                    (setq long
                         (if (:hor? grad)
                             (width-substring (:chaine grad) 
                                       0 (slen (:chaine grad)))
                             (height-substring (:chaine grad) 
                                       0 (slen (:chaine grad))) ))))
        (add (:longueur grad) long)))


(de :display (grad x y region)
        (:display-with-string? grad x y region t))

(de :display-with-string? (grad x y region string?)
    (let* ((x-fin-grad 0)
           (y-fin-grad 0)
           (x-deb-texte 0)
           (y-deb-texte 0)
           (w-texte 0)
           (h-texte 0)
           (y-base-texte 0)
         (chaine (:chaine grad))
         (hor? (:hor? grad))
         (texte-avant? (:texte-avant? grad))
         (long (:longueur grad))
         (police (:police grad))
           )
      (when (and string?
                 chaine
                 (not (eqstring "" chaine)))
            (with ((current-font police))
                  (setq w-texte (width-substring chaine
                                                 0
                                                 (slen chaine)))
                  (setq h-texte (height-substring chaine
                                                  0
                                                  (slen chaine)))
                  (setq y-base-texte (y-base-space))))
      (cond ((and hor? texte-avant?)
             (setq x-fin-grad (sub x long))
             (setq y-fin-grad y)
             (setq x-deb-texte (sub x-fin-grad w-texte))
             (setq y-deb-texte y-fin-grad))
            ((and hor? (not texte-avant?))
             (setq x-fin-grad (add x long))
             (setq y-fin-grad y)
             (setq x-deb-texte x-fin-grad)
             (setq y-deb-texte y-fin-grad))
            ((and (not hor?) texte-avant?)
             (setq x-fin-grad x)
             (setq y-fin-grad (sub y long))
             (setq x-deb-texte (sub x-fin-grad 
                                    (div w-texte 2)))
             (setq y-deb-texte y-fin-grad))
            ((and (not hor?) (not texte-avant?))
             (setq x-fin-grad x)
             (setq y-fin-grad (add y long))
             (setq x-deb-texte (sub x-fin-grad 
                                    (div w-texte 2)))
             (setq y-deb-texte (add y-fin-grad y-base-texte))))
      (draw-line x y x-fin-grad y-fin-grad)
      (when (and string?
                 chaine
                 (not (eqstring "" chaine)))
            (with ((current-font police))
                  (draw-string x-deb-texte
                               y-deb-texte
                               chaine)))
      ))

;------------------------------------------------------------------------
(setq #:sys-package:colon '{echelle})


(de :create ()
        (new '{echelle}))

(de :initialize (echelle hor? texte-avant?)
        (send-super '{echelle} 'initialize echelle () () () () () () ())
        (:graduations echelle ())
        (:hor? echelle hor?)
        (:texte-avant? echelle texte-avant?)
        echelle)

(de :calculer-graduations (ech)
    (let ((graduations ())
          (cur-val ())
          (max-val (if (:hor? ech)
                        (send 'max-x ech)
                        (send 'max-y ech)))
         )
        (setq cur-val (send 'premiere-valeur ech))
        (while (le cur-val max-val)
               (newr graduations
                     (send 'calculer-grad ech cur-val))
               (setq cur-val (send 'prochaine-valeur ech cur-val)) )
        (:graduations ech graduations)
    ))
               
(de :plus-haute-chaine (ech)
        (let ((max 0))
               (mapc (lambda (grad)
                           (setq max (max max
                                       (send 'hauteur-totale grad))))
                       (:graduations ech))
              max))

(de :plus-grande-chaine (ech)
        (let ((max 0))
               (mapc (lambda (grad)
                           (setq max (max max
                                       (send 'longueur-totale grad))))
                       (:graduations ech))
              max))

(de :nbre-de-chaines (ech)
        (let ((nb 0))
               (mapc (lambda (grad)
                           (when (and (send 'chaine grad)
                                      (not (eqstring (send 'chaine grad) "")))
                                 (incr nb)) )
                       (:graduations ech))
              nb))

(de :display (ech dx dy region)
    (let* ((x (send 'x ech))
           (y (send 'y ech))
           (x-base ())
           (y-base ())
           (longueur-max 0)
           (hauteur-max 0)
           (next-valid-pos 0)
           (hor? (:hor? ech))
           (texte-avant? (:texte-avant? ech))
           (string? t)
           )
      (unless (:graduations ech)
              (:calculer-graduations ech))

      ; la largueur (ou la hauteur) de la plus grande chaine a afficher 
      ; (y compris la graduation).

      (setq longueur-max (:plus-grande-chaine ech) ) 
        
      ; la hauteur (ou la largeur) pour savoir quand on doit sauter 
      ; des chaines because of manque de place ..
      ; 
      (setq hauteur-max (:plus-haute-chaine ech) )

      (if hor?
         (setq y-base (if texte-avant?
                          (send 'calcul-de-y ech (send 'min-y ech))
                          (sub (send 'calcul-de-y ech (send 'min-y ech))
                               longueur-max)))
         (setq x-base (if (not texte-avant?)
                          (send 'calcul-de-x ech (send 'min-x ech))
                          (add (send 'calcul-de-x ech (send 'min-x ech))
                               longueur-max))) 
         (setq next-valid-pos 
               (add (send 'calcul-de-y ech (send 'min-y ech))
                    dx)) )
      (mapc (lambda (graduation)
                      (let ((position-x ())
                            (position-y ())
                            (cur-pos ())
                           )
                        (setq position-x 
                                (or x-base
                                    (send 'calcul-de-x
                                          ech (send 'valeur graduation))))
                        (setq position-y 
                                (or y-base
                                    (send 'calcul-de-y
                                          ech (send 'valeur graduation))))
                        (if (:hor? ech)
                            (progn 
                                (setq cur-pos position-x)       
                                (setq string? (ge cur-pos next-valid-pos)))
                            (setq cur-pos position-y)
                            (setq string? (le cur-pos next-valid-pos)) )

                        (send 'display-with-string? graduation
                                (add (add x dx) position-x)
                                (add (add y dy) position-y)
                                ()
                                string?)
                        (when (and string? (send 'chaine graduation))
                            (if (:hor? ech)
                                 (setq next-valid-pos 
                                           (add cur-pos hauteur-max))
                                (setq next-valid-pos 
                                           (sub cur-pos hauteur-max)) ))
                              
                     ))
               (:graduations ech))
    ))
    
;----------------------------------------------------------------------
; sous type numerique ...
(setq #:sys-package:colon '{num-echelle})

(de :create ()
        (new '{num-echelle}))

(de :initialize (ech hor? texte-avant?)
        (send-super '{num-echelle} 'initialize ech hor? texte-avant?)
        ech)

(de :prin (ech)
        (prin "echelle numerique " 
              (send 'hor? ech) " " (send 'texte-avant? ech)))

(de h-num-echelle (texte-dessus?)
        (:initialize (:create) t texte-dessus?))

(de v-num-echelle (texte-gauche?)
        (:initialize (:create) () texte-gauche?))

(de :display (ech dx dy region)
        (unless (and (:petit-pas ech) (:pas ech))
                (:calculer-pas ech)
                (:calculer-petit-pas ech))
        (send-super '{num-echelle} 'display ech dx dy region))


(de :premiere-valeur (ech)
        (if (send 'hor? ech)
            (send 'min-x ech)
            (send 'min-y ech)) )

(de :prochaine-valeur (ech valeur)
           (add (:petit-pas ech)
                (sub valeur (modulo valeur (:petit-pas ech)))))


(de :calculer-grad (ech val)
      (if (eq 0 (modulo val (:pas ech)))
          (grosse-graduation (string val) val 
                    (not (send 'hor? ech)) (send 'texte-avant? ech))
          (petite-graduation () val 
                    (not (send 'hor? ech)) (send 'texte-avant? ech)) ))

(de :calculer-pas (echelle)
   (let* ((pas 0)
          (plage 0)
         )
        (cond ((send 'hor? echelle)
               (setq plage (sub (send 'max-x echelle) (send 'min-x echelle)))
               (setq pas (fix (power 10 (fix (log10 plage)))))
               )
              (t 
               (setq plage (sub (send 'max-y echelle) (send 'min-y echelle)))
               (setq pas (fix (power 10 (fix (log10 plage))))) 
               ))
      (:pas echelle pas)
    ))

(de :calculer-petit-pas (echelle)
       (:petit-pas echelle (div (:pas echelle) 10)))


;----------------------------------------------------------------------
; sous type calendrier ....
;       si duree est superieure a 14 mois => on met les annees
;       si duree est inferieure a 14 mois => on met les tous les 3 mois

(setq #:sys-package:colon '{cal-echelle})

(de :create ()
        (new '{cal-echelle}))

(de :initialize (ech hor? texte-avant?)
        (send-super '{cal-echelle} 'initialize ech hor? texte-avant?)
        (:quatorze? ech ())
        ech)

(de :prin (ech)
        (prin "echelle calendrier " 
              (send 'hor? ech) " " (send 'texte-avant? ech)))

(de h-cal-echelle (texte-dessus?)
        (:initialize (:create) t texte-dessus?))

(de v-cal-echelle (texte-gauche?)
        (:initialize (:create) () texte-gauche?))

(de :premiere-valeur (ech)
     (let ((plage 0)
          )
        (if (send 'hor? ech)
            (progn 
                 (setq plage (sub (send 'max-x ech) (send 'min-x ech))) )
            (setq plage (sub (send 'max-y ech) (send 'min-y ech))) )
        (when (le plage :quatorze-mois)
              (:quatorze? ech t))
        (if (:quatorze? ech)
            ({ma-date}:convert-time 
                  ({ma-date}:debut-de-mois-suivant 
                           ({ma-date}:inverse-convert-time 
                                        (send 'min-x ech))))
            ({ma-date}:convert-time 
                  ({ma-date}:debut-d-annee-suivante 
                           ({ma-date}:inverse-convert-time 
                                        (send 'min-x ech)))) )
        ))
                        
        

(de :prochaine-valeur (ech valeur)
        (if (:quatorze? ech)
            ({ma-date}:convert-time 
                  ({ma-date}:debut-de-mois-suivant 
                           ({ma-date}:inverse-convert-time 
                                        valeur)))
            ({ma-date}:convert-time 
                  ({ma-date}:debut-de-trimestre-suivant
                           ({ma-date}:inverse-convert-time 
                                        valeur))) ))


(de :calculer-grad (ech val)
   (let ((date ({ma-date}:inverse-convert-time val))
        )
      (if (:quatorze? ech)
          (progn
            (if (:mois-a-afficher? ech date)
                (grosse-graduation 
                       ({ma-date}:nom-du-mois date) val 
                       (not (send 'hor? ech)) (send 'texte-avant? ech))
                (petite-graduation () val 
                       (not (send 'hor? ech)) (send 'texte-avant? ech)) ))
          (if (:mois-a-afficher? ech date)
              (grosse-graduation (string (send 'annees date)) val 
                   (not (send 'hor? ech)) (send 'texte-avant? ech))
              (petite-graduation () val 
                   (not (send 'hor? ech)) (send 'texte-avant? ech)) ))
    ))

(de :mois-a-afficher? (ech date)
    (if (:quatorze? ech)
        (memq (send 'mois date) '(0 3 6 9))
        (memq (send 'mois date) '(0)) ))
        
