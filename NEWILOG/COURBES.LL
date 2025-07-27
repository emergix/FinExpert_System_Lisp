;--------------------------------------------------
(setq #:sys-package:colon '{objet-graph})

(de :create ()
        (new '{objet-graph}))

(de :initialize (objet ech-x ech-y h-total min-x min-y max-x max-y)
        (#:image:rectangle:x objet 0)
        (#:image:rectangle:y objet 0)
        (#:image:rectangle:w objet 0)
        (#:image:rectangle:h objet 0)
        (:reinitialize objet ech-x ech-y h-total min-x min-y max-x max-y))
               
(de :reinitialize (objet ech-x ech-y h-total min-x min-y max-x max-y)
        (when ech-x
              (:ech-x objet ech-x))
        (when ech-y
              (:ech-y objet ech-y))
        (when h-total
              (:h-total objet h-total))
        (when min-x
              (:min-x objet min-x))
        (when min-y
              (:min-y objet min-y))
        (when max-x
              (:max-x objet max-x))
        (when max-y
              (:max-y objet max-y))
        objet)
        
(de :calcul-de-x (objet x)
        (fix (* (:ech-x objet)
                (- x (:min-x objet)))))

(de :calcul-de-y (objet y)
        (sub (:h-total objet)
             (fix (* (:ech-y objet)
                  (- y (:min-y objet))))))

;
; par defaut : rien 

(de :show (object)
        ())

(de :hide (object)
        ())

;--------------------------------------------------------------------------
(setq #:sys-package:colon '{courbe})

(de :create ()
        (new '{courbe}))

(de :initialize (courbe liste-de-points)
        (send-super '{courbe} 'initialize courbe () () () () () () ())
        (:liste-de-points courbe liste-de-points)
        (:mon-min-x courbe 
                (min-x liste-de-points 0 (sub1 (get-length liste-de-points))))
        (:mon-min-y courbe 
                (min-y liste-de-points 0 (sub1 (get-length liste-de-points))))
        (:mon-max-x courbe 
                (max-x liste-de-points 0 (sub1 (get-length liste-de-points))))
        (:mon-max-y courbe 
                (max-y liste-de-points 0 (sub1 (get-length liste-de-points))))
        courbe)

(de courbe (liste-de-points)
        (:initialize (:create) liste-de-points))

(de :width (courbe)
        (fix (* (send 'ech-x courbe)
                (sub (:mon-max-x courbe) (:mon-min-x courbe)))))

(de :height (courbe)
        (fix (* (send 'ech-y courbe)
                (sub (:mon-max-y courbe) (:mon-min-y courbe)))))

(de :display (courbe dx dy region)
   (let* ((liste-de-points (:liste-de-points courbe))
          (nb (get-length liste-de-points))
          (cur-i 0)
          (old-point ())
         )
        (setq dx (add dx (send 'x courbe)))
        (setq dy (add dy (send 'y courbe)))
        (unless (eq 0 nb)
                (setq old-point (vref liste-de-points cur-i))
                (while (not (eq cur-i (sub nb 2)))
                       (draw-line 
                           (add dx (send 'calcul-de-x courbe 
                                      ({point}:get-x old-point)))
                           (add dy (send 'calcul-de-y courbe 
                                      ({point}:get-y old-point)))
                           (add dx (send 'calcul-de-x courbe 
                                      ({point}:get-x 
                                             (vref liste-de-points 
                                                   (add1 cur-i)))))
                           (add dy (send 'calcul-de-y courbe 
                                      ({point}:get-y 
                                             (vref liste-de-points
                                                   (add1 cur-i))))) )
                       (incr cur-i)
                       (setq old-point (vref liste-de-points cur-i)) ))))


            

;----------------------------------------------------------------------

(setq #:sys-package:colon '{histogramme})

(de :create ()
        (new '{histogramme}))

(de :initialize (histo liste-de-points pattern)
        (send-super '{histogramme} 'initialize histo () () () () () () ())
        (:liste-de-points histo liste-de-points)
        (:pattern histo pattern)
        histo)

(de h-histogramme (liste-de-points)
    (let* ((histo (:initialize (:create) liste-de-points 1))
          )
        (:hor? histo t)
        histo))

(de v-histogramme (liste-de-points)
    (let* ((histo (:initialize (:create) liste-de-points 1))
          )
        (:hor? histo ())
        histo))

(de :display (histo dx dy region)
    (let* ((liste-de-points (:liste-de-points histo))
           (nb (get-length liste-de-points))
           (cur-i 0)
          )
        (if (:hor? histo)
            (while (le cur-i (sub1 nb))
                   (:display-fine-h-bar histo 
                                dx dy (vref liste-de-points cur-i))
                   (incr cur-i))
            (while (le cur-i (sub1 nb))
                   (:display-fine-v-bar histo 
                                dx dy (vref liste-de-points cur-i))
                   (incr cur-i)) )
    ))

(de :display-fine-h-bar (histo dx dy point)
        (setq dx (add dx (send 'x histo)))
        (setq dy (add dy (send 'y histo)))
        (with ((current-pattern (:pattern histo)))
              (remplir-rectangle
                        (add dx (send 'calcul-de-x histo 
                                              ({point}:get-x point)))
                        (add dy (add1 (send 'calcul-de-y histo 
                                              ({point}:get-y point))))
                        (add dx (send 'calcul-de-x histo 
                                              0))
                        (add dy (sub1 (send 'calcul-de-y histo 
                                              ({point}:get-y point)))) )
        ))

(de :display-fine-v-bar (histo dx dy point)
        (setq dx (add dx (send 'x histo)))
        (setq dy (add dy (send 'y histo)))
        (with ((current-pattern (:pattern histo)))
              (remplir-rectangle
                        (add dx (add1 (send 'calcul-de-x histo 
                                             ({point}:get-x point))))
                        (add dy (send 'calcul-de-y histo 
                                             ({point}:get-y point)))
                        (add dx (sub1 (send 'calcul-de-x histo 
                                             ({point}:get-x point))))
                        (add dy (send 'calcul-de-y histo 
                                             0)) )
        ))

;----------------------------------------------------------------------
(setq #:sys-package:colon '{gros-histogramme})
 
(de :create ()
        (new '{gros-histogramme}))

(de :initialize (histo liste-de-points pattern)
        (send-super '{gros-histogramme} 'initialize
                                 histo liste-de-points pattern))

(de gros-h-histogramme (liste-de-points)
    (let* ((histo (:initialize (:create) liste-de-points 1))
          )
        (send 'hor? histo t)
        histo))

(de gros-v-histogramme (liste-de-points)
    (let* ((histo (:initialize (:create) liste-de-points 1))
          )
        (send 'hor? histo ())
        histo))

(de :display (histo dx dy region)
    (let* ((liste-de-points (send 'liste-de-points histo))
           (nb (get-length liste-de-points))
           (next-point ())
           (prev-point ())
           (cur-i 0)
          )
        (if (send 'hor? histo)
            (while (le cur-i (sub1 nb))
                   (if (eq cur-i (sub1 nb))
                       (setq next-point (vref liste-de-points cur-i))
                      (setq next-point (vref liste-de-points (add1 cur-i))) )
                   (if (eq cur-i 0)
                       (setq prev-point (vref liste-de-points cur-i))
                      (setq prev-point (vref liste-de-points (sub1 cur-i))) )
                   (:display-grosse-h-bar histo 
                                dx dy 
                                prev-point
                                (vref liste-de-points cur-i)
                                next-point)
                   (incr cur-i))
            (while (le cur-i (sub1 nb))
                   (if (eq cur-i (sub1 nb))
                       (setq next-point (vref liste-de-points cur-i))
                      (setq next-point (vref liste-de-points (add1 cur-i))) )
                   (if (eq cur-i 0)
                       (setq prev-point (vref liste-de-points cur-i))
                      (setq prev-point (vref liste-de-points (sub1 cur-i))) )
                   (:display-grosse-v-bar histo 
                                dx dy 
                                prev-point
                                (vref liste-de-points cur-i)
                                next-point)
                   (incr cur-i)) )
    ))
        

(de :display-grosse-h-bar (histo dx dy prev-point point next-point)
        (setq dx (add dx (send 'x histo)))
        (setq dy (add dy (send 'y histo)))
        (with ((current-pattern (send 'pattern histo)))
             (let* ((yp (send 'calcul-de-y histo ({point}:get-y prev-point)))
                    (x (send 'calcul-de-x histo ({point}:get-x point)))
                    (y (send 'calcul-de-y histo ({point}:get-y point)))
                    (yn (send 'calcul-de-y histo ({point}:get-y next-point)))
                    (decal-n (abs (sub y yn)))
                    (decal-p (abs (sub y yp)))
                   )
              (remplir-rectangle
                        (add dx x)
                        (add dy (sub y (div decal-n 2)))
                        (add dx (send 'calcul-de-x histo 
                                        0))
                        (add dy (add y (div decal-p 2))) )
        )))

(de :display-grosse-v-bar (histo dx dy prev-point point next-point)
        (setq dx (add dx (send 'x histo)))
        (setq dy (add dy (send 'y histo)))
        (with ((current-pattern (send 'pattern histo)))
             (let* ((xp (send 'calcul-de-x histo ({point}:get-x prev-point)))
                    (x (send 'calcul-de-x histo ({point}:get-x point)))
                    (y (send 'calcul-de-y histo ({point}:get-y point)))
                    (xn (send 'calcul-de-x histo ({point}:get-x next-point)))
                    (decal-n (abs (sub x xn)))
                    (decal-p (abs (sub x xp)))
                   )
              (remplir-rectangle
                        (add dx (add x (div decal-n 2)))
                        (add dy y)
                        (add dx (sub x (div decal-p 2)))
                        (add dy (send 'calcul-de-y histo 
                                        0)))
        )))

        
                   
(de remplir-rectangle (x y x2 y2)
        (fill-rectangle (min x x2)
                        (min y y2)
                        (abs (sub x x2))
                        (abs (sub y y2)) ))     
;----------------------------------------------------------------------
(setq #:sys-package:colon '{valeur})

(de :create ()
        (new '{valeur}))

(de :initialize (valeur l-h l-b l-ouv l-ferm l-vol)
        (send-super '{valeur} 'initialize valeur () () () () () () ())
        (:courbe-ouverture valeur l-ouv)
        (:courbe-fermeture valeur l-ferm)
        (:courbe-plus-h valeur l-h)
        (:courbe-plus-b valeur l-b)
        (:courbe-volume valeur l-vol)
        (:mon-min-x valeur 
                (min-x (:courbe-ouverture valeur)
                       0 (sub1 (get-length (:courbe-ouverture valeur)))))
        (:mon-min-y valeur
                (min-y (:courbe-plus-b valeur)
                       0 (sub1 (get-length (:courbe-ouverture valeur)))))
        (:mon-max-x valeur
                (max-x (:courbe-ouverture valeur)
                       0 (sub1 (get-length (:courbe-ouverture valeur)))))
        (:mon-max-y valeur
                (max-y (:courbe-plus-h valeur)
                       0 (sub1 (get-length (:courbe-ouverture valeur)))))
        valeur)

(de valeur (c-h c-b c-ouv c-ferm c-vol)
        (:initialize (:create) c-h c-b c-ouv c-ferm c-vol))

(de :display (valeur dx dy region)
    (let* ((nb (get-length (:courbe-plus-h valeur)))
           (cur-i 0)
          )
        (setq dx (add dx (send 'x valeur)))
        (setq dy (add dy (send 'y valeur)))
        (while (le cur-i (sub1 nb))
               (:display-une-valeur 
                           valeur dx dy 
                           (vref (:courbe-plus-h valeur) cur-i)
                           (vref (:courbe-plus-b valeur) cur-i)
                           (vref (:courbe-ouverture valeur) cur-i)
                           (vref (:courbe-fermeture valeur) cur-i))
               (incr cur-i))
    ))


(de :display-une-valeur (valeur dx dy pt-h pt-b pt-ouv pt-ferm)
        (draw-line 
                (add dx (send 'calcul-de-x valeur ({point}:get-x pt-h)))
                (add dy (send 'calcul-de-y valeur ({point}:get-y pt-h)))
                (add dx (send 'calcul-de-x valeur ({point}:get-x pt-b)))
                (add dy (send 'calcul-de-y valeur ({point}:get-y pt-b))) )
        (draw-line 
                (add dx (send 'calcul-de-x valeur ({point}:get-x pt-h)))
                (add dy (send 'calcul-de-y valeur ({point}:get-y pt-ouv)))
                (sub1 (add dx (send 'calcul-de-x valeur ({point}:get-x pt-h))))
                (add dy (send 'calcul-de-y valeur ({point}:get-y pt-ouv))) )
        (draw-line 
                (add dx (send 'calcul-de-x valeur ({point}:get-x pt-h)))
                (add dy (send 'calcul-de-y valeur ({point}:get-y pt-ferm)))
                (add1 (add dx (send 'calcul-de-x valeur ({point}:get-x pt-h))))
                (add dy (send 'calcul-de-y valeur ({point}:get-y pt-ferm))) )
        )

        

        
        
;----------------------------------------------------------------------
(setq #:sys-package:colon '{segment})

(de :create ()
        (new '{segment}))

(de :initialize (segment point1 point2)
        (send-super '{segment} 'initialize segment () () () () () () ())
        (:point-depart segment point1)
        (:point-arrivee segment point2)
        (:epaisseur segment 1)
        segment)

(de segment (point1 point2)
        (:initialize (:create) point1 point2))

(de :display (segment dx dy region)
   (setq dx (add dx (send 'x segment)))
   (setq dy (add dy (send 'y segment)))
   (let ((x1 (add dx (send 'calcul-de-x segment 
                        ({point}:get-x (:point-depart segment)))))
         (y1 (add dy (send 'calcul-de-y segment 
                        ({point}:get-y (:point-depart segment)))))
         (x2 (add dx (send 'calcul-de-x segment 
                        ({point}:get-x (:point-arrivee segment)))))
         (y2 (add dy (send 'calcul-de-y segment 
                        ({point}:get-y (:point-arrivee segment)))))
         (epaisseur (sub1 (:epaisseur segment)))
        )
      (while (ge epaisseur 0)
          (draw-line (add x1 epaisseur)
                     (add y1 epaisseur)
                     (add x2 epaisseur)
                     (add y2 epaisseur))
          (setq epaisseur (sub1 epaisseur)))
   ))
        
(de :show (segment)
        (:epaisseur segment (min 2 (add1 (:epaisseur segment)))))

(de :hide (segment)
        (:epaisseur segment (max (sub1 (:epaisseur segment)) 0)))

;------------------------------------------------------------------------

(setq #:sys-package:colon '{droite-technique})

(de :create ()
        (new '{droite-technique}))

(de :initialize (droite pente ordonnee-0)
        (send-super '{droite-technique} 'initialize droite () () () () () () ())
        (:pente droite pente)
        (:ordonnee-0 droite ordonnee-0)
        (:epaisseur droite 1)
        droite)

(de droite-technique (pente ordonnee-0)
        (:initialize (:create) pente ordonnee-0))

(de :display (droite dx dy region)
   (let* ((x-premier-point 0)
          (y-premier-point (send 'min-y droite))
          (x-second-point 0)
          (y-second-point (send 'max-y droite))
         )
      (unless (eq (:pente droite) 0)
        (setq x-premier-point (+ (:ordonnee-0 droite)
                                 (/ y-premier-point (:pente droite))))
        (setq x-second-point (+ (:ordonnee-0 droite)
                                (/ y-second-point (:pente droite))))
        (let ((x1 (add dx (send 'calcul-de-x droite x-premier-point)))
              (y1 (add dy (send 'calcul-de-y droite y-premier-point)))
              (x2 (add dx (send 'calcul-de-x droite x-second-point)))
              (y2 (add dy (send 'calcul-de-y droite y-second-point)))
              (epaisseur (sub1 (:epaisseur droite)))
             )
           (while (ge epaisseur 0)
                  (draw-line 
                         (add epaisseur x1)
                         (add epaisseur y1)
                         (add epaisseur x2)
                         (add epaisseur y2))
                  (setq epaisseur (sub1 epaisseur)))
        ))))

(de :show (droite)
        (:epaisseur droite (min 2 (add1 (:epaisseur droite)))))

(de :hide (droite)
        (:epaisseur droite (max 0 (sub1 (:epaisseur droite)))))

;------------------------------------------------------------------------
(setq #:sys-package:colon '{figure})

(de :create ()
        (new '{figure}))

(de :initialize (figure dte-resis dte-supp)
        (send-super '{figure} 'initialize figure () () () () () () ())
        (:droite-resistance figure dte-resis)
        (:droite-support figure dte-supp)
        figure)

(de figure (dte-resis dte-supp)
        (:initialize (:create) dte-resis dte-supp))

(de :min-x (figure min-x)
        (send 'min-x (:droite-resistance figure) min-x)
        (send 'min-x (:droite-support figure) min-x))

(de :min-y (figure min-y)
        (send 'min-y (:droite-resistance figure) min-y)
        (send 'min-y (:droite-support figure) min-y))

(de :max-x (figure max-x)
        (send 'max-x (:droite-resistance figure) max-x)
        (send 'max-x (:droite-support figure) max-x))

(de :max-y (figure max-y)
        (send 'max-y (:droite-resistance figure) max-y)
        (send 'max-y (:droite-support figure) max-y))

(de :ech-x (figure ech-x)
        (send 'ech-x (:droite-resistance figure) ech-x)
        (send 'ech-x (:droite-support figure) ech-x))

(de :ech-y (figure ech-y)
        (send 'ech-y (:droite-resistance figure) ech-y)
        (send 'ech-y (:droite-support figure) ech-y))

(de :h-total (figure h-total)
        (send 'h-total (:droite-resistance figure) h-total)
        (send 'h-total (:droite-support figure) h-total))

(de :show (figure)
        (send 'show (:droite-resistance figure))
        (send 'show (:droite-support figure)))

(de :hide (figure)
        (send 'hide (:droite-resistance figure))
        (send 'hide (:droite-support figure)))

(de :display (figure dx dy region)
        (send 'display (:droite-resistance figure) dx dy region)
        (send 'display (:droite-support figure) dx dy region))

;----------------------------------------------------------------------

(setq #:sys-package:colon '{canal})

(de :create ()
        (new '{canal}))

(de :initialize (canal dte-resis dte-supp)
        (send-super '{canal} 'initialize canal dte-resis dte-supp))

(de canal (dte-resis dte-supp)
        (:initialize (:create) dte-resis dte-supp))

;----------------------------------------------------------------------

(setq #:sys-package:colon '{ctriangle})

(de :create ()
        (new '{ctriangle}))

(de :initialize (ctriangle dte-resis dte-supp)
        (send-super '{ctriangle} 'initialize ctriangle dte-resis dte-supp))

(de ctriangle (dte-resis dte-supp)
        (:initialize (:create) dte-resis dte-supp))

;------------------------------------------------------------------------
(setq #:sys-package:colon '{fleche})

(de :create ()
        (new '{fleche}))

(de :initialize (fleche direction long rang courbe)
        (send-super '{fleche} 'initialize fleche () () () () () () ())
        (:point-arrivee fleche (get-nth rang (send 'liste-de-points courbe)))
        (:type fleche direction)
        (:longueur fleche long)
        (:rang fleche rang)
        (:courbe fleche courbe)
        fleche)

(de fleche (direction long rang courbe)
        (:initialize (:create) direction long rang courbe))

(de :decal-w (fleche)
        (fix (* (:longueur fleche)
                (cos (* :pi/4 (:type fleche))))))

(de :decal-h (fleche)
        (fix (* (:longueur fleche)
                (sin (* :pi/4 (:type fleche))))))

(de :x-fin-de-fleche-reel (fleche)
        (add (:decal-w fleche)
             (send 'calcul-de-x fleche 
                    ({point}:get-x (:point-arrivee fleche)))))

(de :y-fin-de-fleche-reel (fleche)
        (add (:decal-h fleche)
             (send 'calcul-de-y fleche 
                    ({point}:get-y (:point-arrivee fleche)))))

(de :display (fleche dx dy region)
    (let ((x-reel (send 'calcul-de-x fleche 
                                ({point}:get-x (:point-arrivee fleche))))
          (y-reel (send 'calcul-de-y fleche 
                                ({point}:get-y (:point-arrivee fleche))))
          (decal-x (:decal-w fleche))
          (decal-y (:decal-h fleche))
         )
        (draw-circle 
                (add dx x-reel)
                (add dy y-reel)
                1)
        (draw-line 
                (add dx x-reel)
                (add dy y-reel)
                (add dx (add x-reel decal-x))
                (add dy (add y-reel decal-y)) )
      ))
                

;------------------------------------------------------------------------------

(setq #:sys-package:colon '{texte-sur-fleche})

(de :create ()
        (new '{texte-sur-fleche}))

(de :initialize (texte-sur-fleche dir long rang courbe 
                             petite-long texte police boite? situation)
        (send-super '{texte-sur-fleche} 'initialize texte-sur-fleche
                        dir long rang courbe)
        (:petite-long texte-sur-fleche petite-long)
        (:texte texte-sur-fleche texte)
        (:police texte-sur-fleche police)
        (:boite? texte-sur-fleche boite?)
        (:situation texte-sur-fleche situation)
        texte-sur-fleche)

(de simple-texte (dir rang courbe texte situation)
       (texte-sur-fleche dir 20 rang courbe 0 texte () () situation))

(de indicateur-de-pattern (rang courbe texte situation)
        (texte-sur-fleche 2 20 rang courbe 0 texte 0 t situation))

(de texte-sur-fleche (dir long rang courbe 
                      petite-long texte police boite? situation)
        (:initialize (:create) 
                dir long rang courbe petite-long 
                texte police boite? situation) )

(de :display (texte-sur-fleche dx dy region)
    (let ((x-fin-fleche ({fleche}:x-fin-de-fleche-reel texte-sur-fleche))
          (y-fin-fleche ({fleche}:y-fin-de-fleche-reel texte-sur-fleche))
          (x-fin-petite-long ())
          (x-debut-texte ())
          (w-texte ())
          (h-texte ())
         )
        (unless (:police texte-sur-fleche) (:police texte-sur-fleche 0))
        (with ((current-font (:police texte-sur-fleche)))
              (setq w-texte (width-substring
                                (:texte texte-sur-fleche)       
                                0 (slen (:texte texte-sur-fleche))))
              (setq h-texte (height-substring
                                (:texte texte-sur-fleche)       
                                0 (slen (:texte texte-sur-fleche)))) )
        
        ({fleche}:display texte-sur-fleche dx dy region)
        (cond ((eq (:situation texte-sur-fleche) 'tete)
               (setq x-fin-petite-long 
                     (add (:petite-long texte-sur-fleche) x-fin-fleche))
               (setq x-debut-texte x-fin-petite-long) )
              ((eq (:situation texte-sur-fleche) 'queue)
               (setq x-fin-petite-long 
                     (sub x-fin-fleche (:petite-long texte-sur-fleche)))
               (setq x-debut-texte 
                          (sub x-fin-petite-long w-texte)) )
              (t
               (setq x-fin-petite-long (add :petite-long x-fin-fleche))
               (setq x-debut-texte x-fin-petite-long) ))

        (draw-line 
              (add dx x-fin-fleche)
              (add dy y-fin-fleche)
              (add dx x-fin-petite-long)
              (add dy y-fin-fleche))
        (my-draw-texte 
                (:texte texte-sur-fleche)
                (:police texte-sur-fleche)
                x-debut-texte
                y-fin-fleche
                w-texte
                h-texte
                (:boite? texte-sur-fleche)
                ())
      ))
                         
;-----------------------------------------------------------------------------
(setq #:sys-package:colon '{indicateur-volume})

(de :create ()
        (new '{indicateur-volume}))

(de :initialize (indic liste-de-points)
    (send-super '{indicateur-volume} 'initialize indic () () () () () () ())
    (:liste-de-points indic liste-de-points)
    (:point-max indic (get-max-point-y 
                                liste-de-points 0 
                                (sub1 (get-length liste-de-points))))
    indic)

(de indicateur-volume (liste-de-points)
    (:initialize (:create) liste-de-points))

(de :display (indic dx dy region)
    (let ((x-base (send 'calcul-de-x indic
                                ({point}:get-x (:point-max indic))))
          (y-base (send 'calcul-de-y indic 
                                ({point}:get-y (:point-max indic))))
         )
        (draw-line 
                (add dx x-base)
                (add dy (sub y-base 3))
                (add dx (add :length x-base))
                (add dy (add :length y-base)) )
        (draw-line 
                (add dx (sub1 x-base))
                (add dy (sub y-base 3))
                (add dx (sub (sub1 x-base) :length))
                (add dy (add :length y-base)) )
    ))

;-----------------------------------------------------------------------------

(setq #:sys-package:colon '{indicateur-etendu})

(de :create ()
        (new '{indicateur-etendu}))

(de :initialize (indic courbe rang-debut rang-fin titre police boite?)
        (send-super '{indicateur-etendu} 'initialize 
                                indic () () () () () () ())
        (:point-debut indic 
                  (get-nth rang-debut (send 'liste-de-points courbe)))
        (:rang-debut indic rang-debut)
        (:point-fin indic 
                  (get-nth rang-fin (send 'liste-de-points courbe)))
        (:rang-fin indic rang-fin)
        (:courbe indic courbe)
        (:titre indic titre)
        (:police indic police)
        (:boite? indic boite?)
        indic)

(de indicateur-etendu (courbe rang-debut rang-fin titre police boite?)
     (:initialize (:create) courbe rang-debut rang-fin titre police boite?))

(de :display (indic dx dy region)
    (let* ((min-x-local (min-x (send 'liste-de-points (:courbe indic))
                               (:rang-debut indic) (:rang-fin indic)))
           (min-y-local (min-y (send 'liste-de-points (:courbe indic))
                               (:rang-debut indic) (:rang-fin indic)))
           (max-x-local (max-x (send 'liste-de-points (:courbe indic))
                               (:rang-debut indic) (:rang-fin indic)))
           (max-y-local (max-y (send 'liste-de-points (:courbe indic))
                               (:rang-debut indic) (:rang-fin indic)))
           (x-debut-de-texte ())
           (y-debut-de-texte ())
           (w-texte ())
           (h-texte ())
           (y-base-space ())
          )

        (setq min-x-local (send 'calcul-de-x indic min-x-local))
        (setq min-y-local (send 'calcul-de-y indic min-y-local))
        (setq max-x-local (send 'calcul-de-x indic max-x-local))
        (setq max-y-local (send 'calcul-de-y indic max-y-local))
        
        (my-draw-rectangle
                'super
                (add dx (send 'calcul-de-x indic 
                                ({point}:get-x (:point-debut indic))))
                (add dy max-y-local)
                (sub max-x-local min-x-local)
                (sub min-y-local max-y-local) )

        (unless (:police indic) (:police indic 0))
        (with ((current-font (:police indic)))
              (setq w-texte (width-substring (:titre indic)
                                        0 (slen (:titre indic))))
              (setq h-texte (height-substring (:titre indic)
                                        0 (slen (:titre indic))))
              (setq y-base-space (y-base-space)) )
        (setq x-debut-de-texte 
                      (add min-x-local
                           (sub (div (sub max-x-local min-x-local) 2)
                                (div w-texte 2))))
        (setq y-debut-de-texte max-y-local)
        (my-draw-texte 
                (:titre indic)
                (:police indic 0)
                (add dx x-debut-de-texte)
                (add dy y-debut-de-texte)
                w-texte
                h-texte
                (:boite? indic)
                ())
      ))
         

;------------------------------------------------------------------------

(de my-draw-rectangle (type x y w h)
    (cond ((eq type 'super)
           (draw-rectangle 
                x y w h)
           (draw-rectangle 
                (sub1 x) (sub1 y)
                (add 2 w) (add 2 h)) )
          (t
           (draw-rectangle
                x y w h)) ))

;
; les valeurs de x et de y sont les valeurs du coin inferieur gauche
; de l'ensemble a afficher..

(de my-draw-texte (chaine police x y w h boite? type-boite)
     (let ((y-base-space ())
          )
        (with ((current-font police))
              (setq y-base-space (y-base-space))
              (draw-string x (sub y (sub h y-base-space)) chaine) )
        (when boite?
              (my-draw-rectangle type-boite
                        (sub x 2)
                        (sub y (add1 h))
                        (add 2 w) h) )
     ))  

;------------------------------------------------------------------------

(setq #:sys-package:colon '{points-et-figures})

(de :create ()
        (new '{points-et-figures}))

(de :initialize (p-et-f boite vecteur)
        (send-super '{points-et-figures} 
                'initialize p-et-f () () () () () () ())
        (:largeur-colonne p-et-f (width-space))
        (:boite p-et-f boite)
        (:body p-et-f vecteur)
        p-et-f)

(de points-et-figures (boite vecteur)
        (:initialize (:create) boite vecteur))

;
; le x de chaque elt est le numero de la colonne
; le y de chaque elt est la valeur de l'elt
; le cn de chaque elt est soit un chiffre, soit x, soit o.

(de :display (p-et-f dx dy region)
   (let* ((vecteur (:body p-et-f))
          (nb (get-length vecteur))
          (cur-i 0)
         )
        (setq dx (add dx (send 'x p-et-f)))
        (setq dy (add dy (send 'y p-et-f)))
        (unless (eq 0 nb)
                (while (le cur-i (sub1 nb))
                       (:display-cn p-et-f dx dy (vref vecteur cur-i))
                       (incr cur-i) )
                )))

(de :display-cn (p-et-f dx dy elt)
   (let* ((x (add dx (mul (:get-x elt) (:largeur-colonne p-et-f))))
          (y (add dy (send 'calcul-de-y p-et-f (:get-y elt))))
          (cn (:get-cn elt))
         )
        (when (member cn :chiffres-et-autres)
                     (draw-string x y cn))
   ))

#|
              (cond ((eq cn "c")
                     (:draw-x x y))
                    ((eq cn "o")
                     (:draw-o x y))
                    (t
|#

(de :get-x (v)
        (car v))

(de :get-y (v)
        (cadr v))

(de :get-cn (v)
        (caddr v))

                




