;------------------------------------------------------------------------
; les fonctions a utiliser ...

(de bars-and-charts (x y w h scale titre sous-titre
                     titre-prin liste-s-prin titre-secon1 liste-s-secon1
                     titre-secon2 liste-s-secon2)
   (let ((liste-prin (maplist (lambda (symb)
                                   (make-objet-graph symb))
                              liste-s-prin))
         (liste-secon1 (maplist (lambda (symb)
                                   (make-objet-graph symb))
                                liste-s-secon1))
         (liste-secon2 (maplist (lambda (symb)
                                   (make-objet-graph symb))
                                liste-s-secon2))
         (b))
      (setq b 
        ({bars-and-charts}:bars-and-charts
                        x y w h (interface) 
                        scale titre sous-titre
                        titre-prin liste-prin titre-secon1 liste-secon1
                        titre-secon2 liste-secon2))
      (mapc
          (lambda (symb courbe) (add-couple b symb courbe))
          liste-s-prin
          liste-prin)
      (mapc
          (lambda (symb courbe) (add-couple b symb courbe))
          liste-s-secon1
          liste-secon1)
      (mapc
          (lambda (symb courbe) (add-couple b symb courbe))
          liste-s-secon2
          liste-secon2)
      b))


;-------------------------------------------------------
; creation d'histogrammes associes ...

(de create-horizontal-histogramme (bars-and-charts symbol)
      (let ((courbe (add-symbol bars-and-charts symbol)))
        ({bars-and-charts}:create-horizontal-histogramme 
                        bars-and-charts courbe)
      ))

(de create-vertical-histogramme (bars-and-charts symbol)
      (let ((courbe (add-symbol bars-and-charts symbol)))
        ({bars-and-charts}:create-vertical-histogramme 
                        bars-and-charts courbe)
      ))

;-------------------------------------------------------
; lister les objets presents ..

;
; celles-ci renvoient les objets AIDA

(de get-liste-principale (b)
    (let ((bars-and-charts (component 'bars-and-charts b))
          )
        ({bars-and-charts}:get-liste-principale bars-and-charts)))

(de get-liste-secondaire1 (b)
    (let ((bars-and-charts (component 'bars-and-charts b))
          )
        ({bars-and-charts}:get-liste-secondaire1 bars-and-charts)))

(de get-liste-secondaire2 (b)
    (let ((bars-and-charts (component 'bars-and-charts b))
          )
        ({bars-and-charts}:get-liste-secondaire2 bars-and-charts)))

;
; celle-ci renvoit les symboles de type FIGURE ou SEGMENT 
; (triangles et canaux ..)

(de get-liste-figures (b)
    (let ((bars-and-charts (component 'bars-and-charts b))
          )
        (mapcar (lambda (cons)
                    (when (or (typep (cdr cons) '{figure})
                              (typep (cdr cons) '{segment}))
                          (car cons)))
                 ({bars-and-charts}:courbes-map bars-and-charts))))
                              
;-------------------------------------------------------
; ajout, retrait et modification d'objets graphiques ..

(de add-object-liste-principale (bars-and-charts symbol)
      (let ((courbe (add-symbol bars-and-charts symbol)))
        ({bars-and-charts}:add-object-liste-principale
                        bars-and-charts courbe)
      ))

(de delete-object-liste-principale (bars-and-charts symbol)
      (let ((courbe (get-courbe bars-and-charts symbol))
           )
        (remove-symbol bars-and-charts symbol)
        ({bars-and-charts}:delete-object-liste-principale 
                        bars-and-charts courbe)
     ))

(de modify-object-liste-principale (bars-and-charts symbol-old symbol)
      (let ((courbe (make-objet-graph symbol))
            (courbe-old (get-courbe bars-and-charts symbol-old))
           )
        (remove-symbol bars-and-charts symbol-old)
        (add-couple bars-and-charts symbol courbe)
        ({bars-and-charts}:modify-object-liste-principale 
                        bars-and-charts courbe-old courbe)
      ))

(de add-object-liste-secondaire-1 (bars-and-charts symbol)
      (let ((courbe (add-symbol bars-and-charts symbol)))
        ({bars-and-charts}:add-object-liste-secondaire-1 
                        bars-and-charts courbe)
      ))

(de delete-object-liste-secondaire-1 (bars-and-charts symbol)
      (let ((courbe (get-courbe bars-and-charts symbol)))
        (remove-symbol bars-and-charts symbol)
        ({bars-and-charts}:delete-object-liste-secondaire-1 
                        bars-and-charts courbe)
      ))

(de modify-object-liste-secondaire-1 (bars-and-charts symbol-old symbol)
      (let ((courbe (make-objet-graph symbol))
            (courbe-old (get-courbe bars-and-charts symbol-old))
           )
        (remove-symbol bars-and-charts symbol-old)
        (add-couple bars-and-charts symbol courbe)
        ({bars-and-charts}:modify-object-liste-secondaire-1 
                        bars-and-charts courbe-old courbe)
        ))

(de add-object-liste-secondaire-2 (bars-and-charts symbol)
      (let ((courbe (add-symbol bars-and-charts symbol)))
        ({bars-and-charts}:add-object-liste-secondaire-2 
                        bars-and-charts courbe)
      ))

(de delete-object-liste-secondaire-2 (bars-and-charts symbol)
     (let ((courbe (get-courbe bars-and-charts symbol))
          )
        (remove-symbol bars-and-charts symbol)
        ({bars-and-charts}:delete-object-liste-secondaire-2 
                        bars-and-charts courbe)
     ))

(de modify-object-liste-secondaire-2 (bars-and-charts symbol-old symbol)
      (let ((courbe (make-objet-graph symbol))
            (courbe-old (get-courbe bars-and-charts symbol-old))
           )
        (remove-symbol bars-and-charts symbol-old)
        (add-couple bars-and-charts symbol courbe)
        ({bars-and-charts}:modify-object-liste-secondaire-2 
                        bars-and-charts courbe-old courbe)
       ))


;------------------------------------------------------------------------
; creation d'un objet graphique connaissant le symbole ...

(de get-slot-value (object symbol)
    ())

(de type-of-symbol (symbol)       ; <---------- A REMPLIR !!!!!
        symbol)

(de make-objet-graph (symbol)
    (let ((objet ())
        )
      (setq objet
           (selectq (type-of-symbol symbol)  
                 (courbe
                     (make-courbe symbol))
                 (v-histo
                     (make-vertical-histogramme symbol))
                 (h-histo
                     (make-horizontal-histogramme symbol))
                 (gros-v-histo
                     (make-gros-vertical-histogramme symbol))
                 (gros-h-histo
                     (make-gros-horizontal-histogramme symbol))
                 (valeur
                     (make-valeur symbol))
                 (segment
                     (make-segment symbol))
                 (droite-technique
                     (make-droite-technique symbol))
                 (texte-sur-fleche
                     (make-texte-sur-fleche symbol))
                 (indicateur-pattern
                     (make-indicateur-pattern symbol))
                 (simple-texte
                     (make-simple-texte symbol))
                 (indicateur-etendu
                     (make-indicateur-etendu symbol))))
      ({objet-graph}:symbol objet symbol)
   objet))

(de make-courbe (symbol)
       (courbe
        (get-slot-value symbol 'body)           ;  vecteur de paires pointees
       ))

(de make-vertical-histogramme (symbol)
       (v-histogramme
        (get-slot-value symbol 'body)           ;  vecteur de paires pointees
       ))  

(de make-horizontal-histogramme (symbol)
       (h-histogramme
        (get-slot-value symbol 'body)           ;  vecteur de paires pointees
       ))

(de make-gros-vertical-histogramme (symbol)
       (gros-v-histogramme
        (get-slot-value symbol 'body)           ;  vecteur de paires pointees
       ))

(de make-gros-horizontal-histogramme (symbol)
       (gros-h-histogramme
        (get-slot-value symbol 'body)           ;  vecteur de paires pointees
       ))

(de make-valeur (symbol)
       (valeur
        (get-slot-value symbol 'plus-haut)      ;  vecteur de paires pointees
        (get-slot-value symbol 'plus-bas)       ;  vecteur de paires pointees
        (get-slot-value symbol 'premier-cours)  ;  vecteur de paires pointees
        (get-slot-value symbol 'dernier-cours)  ;  vecteur de paires pointees
        (get-slot-value symbol 'volume)         ;  vecteur de paires pointees
       ))

(de make-segment (symbol)
       (segment
        (get-slot-value symbol 'premier-point)  ;  paire pointee
        (get-slot-value symbol 'second-point)   ;  paire pointee
       ))

(de make-droite-technique (symbol)
        (droite-technique
         (get-slot-value symbol 'pente)         ;  valeur
         (get-slot-value symbol 'ordonnee-zero) ;  valeur
         ))

(de make-texte-sur-fleche (symbol)
        (texte-sur-fleche
         direction                              ;  valeur (n * pi/4)
         longueur                               ;  longueur du trait hori.
         rang                                   ;  rang du point pointe.
         courbe                                 ;  courbe du point pointe.
         petite-longueur                        ;  longueur dans direction.
         texte                                  ;  texte a ecrire
         police                                 ;  easy no ?
         boite?                                 ;  on met un cadre ?
         situation                              ;  'tete ou 'queue.
        ))      

(de make-indicateur-pattern (symbol)
        (indicateur-pattern
         rang                                   ;  rang du point pointe.
         courbe                                 ;  courbe du point pointe.
         texte                                  ;  texte a ecrire
         situation                              ;  'tete ou 'queue.
        ))

(de make-simple-texte (symbol)
        (simple-texte
         direction                              ;  n : (n * pi/4)
         rang                                   ;  rang du point pointe.
         courbe                                 ;  courbe du point pointe.
         texte                                  ;  texte a ecrire
         situation                              ;  'tete ou 'queue.
        ))

(de make-indicateur-etendu (symbol)
        (indicateur-etendu 
         courbe                                 ;  courbe concernee
         rang-debut                             ;  rang debut
         rang-fin                               ;  fin 
         titre                                  ;  texte       
         police                                 ;  police du titre
         boite?                                 ;  on encadre ?
        ))


;------------------------------------------------------------------------
; gestion de la table de correspondance entre les symboles
; de O.Croissant et ceux d'AIDA.


; 
; ajoute un couple

(de add-couple (bars-and-charts symbol courbe)
    ({bars-and-charts}:courbes-map bars-and-charts
     (acons symbol courbe ({bars-and-charts}:courbes-map bars-and-charts))))


;
; ajoute un couple SYMBOL-OBJET ds la liste en creant l'objet.

(de add-symbol (bars-and-charts symbol)
   (let ((objet-graph (make-objet-graph symbol))
        )
      (acons symbol objet-graph 
             ({bars-and-charts}:courbes-map bars-and-charts))
      objet-graph))

;
; detruit le couple SYMBOL-OBJET de la liste .

(de remove-symbol (bars-and-charts symbol)
     (delq (assq symbol 
             ({bars-and-charts}:courbes-map bars-and-charts))))

;
; recuperation d'un des elements a partir de l'autre .

(de get-courbe (bars-and-charts symbol)
        (cassq symbol 
             ({bars-and-charts}:courbes-map bars-and-charts)))

(de get-symbol (bars-and-charts objet-graph)
        ({objet-graph}:symbol objet-graph))

