(setq #:sys-package:colon '{bars-and-charts})

(de :create (x y w h)
     (application '{bars-and-charts} x y w h ()))

(de :initialize (bars-and-charts interface scale titre sous-titre
                 titre-prin liste-prin
                 titre-secon1 liste-secon1
                 titre-secon2 liste-secon2)
  (let ((w 0) (h 0))
     (add-component bars-and-charts 'interface interface)
     (add-component bars-and-charts 'bars-and-charts bars-and-charts)
     (:controleur bars-and-charts
             (:compute-controleur
                 bars-and-charts scale 
                 titre-prin liste-prin
                 titre-secon1 liste-secon1
                 titre-secon2 liste-secon2))
     (setq w (send 'width (:controleur bars-and-charts)))
     (setq h (send 'height (:controleur bars-and-charts)))
     (send 'set-image bars-and-charts
                (column (component 'interface bars-and-charts)
                     (%centeredview (beau-cadre 0 0 (add 30 w) 40 t)
                                    (column titre sous-titre))
                     (%centeredview (beau-cadre 0 0 (add 30 w) (add 30 h) t)
                                    (%view (filledbox 0 0 w h 0)
                                           (box 0 0 w h)
                                           (:controleur bars-and-charts)))))
     (send 'fit-to-contents bars-and-charts)
     bars-and-charts))

(de :prin (b)
        (prin "Bars and charts"))


(de :bars-and-charts (x y w h interface scale titre sous-titre
                     titre-prin liste-prin titre-secon1 liste-secon1
                     titre-secon2 liste-secon2)
     (:initialize (:create x y w h) interface
                  scale titre sous-titre
                  titre-prin liste-prin
                  titre-secon1 liste-secon1
                  titre-secon2 liste-secon2))


;
; scale : la taille initiale de l'espace scrolle' par le voyeur principal
;         ---> un chiffre qui compris entre 1 et 3 
; (1 a 3 fois la taille du voyeur principal)
; on renvoit le controleur.
; les listes doivent contenir des objets AIDA ...


(de :compute-controleur (bars-and-charts scale 
                             titre-prin liste-prin
                             titre-second1 liste-second1 
                             titre-second2 liste-second2)
    (unless (null liste-prin)
         (let* ((w (send 'width bars-and-charts))
                (h (send 'height bars-and-charts))
                (min-x (send 'mon-min-x (car liste-prin)))
                (min-y (send 'mon-min-y (car liste-prin)))
                (max-x (send 'mon-max-x (car liste-prin)))
                (max-y (send 'mon-max-y (car liste-prin)))
                (min-x-1 0)
                (min-y-1 0)
                (max-x-1 0)
                (max-y-1 0)
                (min-x-2 0)
                (min-y-2 0)
                (max-x-2 0)
                (max-y-2 0)
                (plage-x (sub max-x min-x))
                (plage-y (sub max-y min-y))
                (presentateur-prin ())
                (presentateur-sec1 ())
                (presentateur-sec2 ())
                (presentateur-ech-h ())
                (presentateur-ech-v ())
                (presentateur-ech-v1 ())
                (presentateur-ech-v2 ())
                (liste-h ())
                (ech-h-min-y 0)
                (ech-h-max-y 0)
                (liste-v ())
                (ech-v-min-x 0)
                (ech-v-max-x 0)
                (valeur? (:valeur-presente? liste-prin))
                (w-ech-v-v (:w-ech-v-v valeur? w))
                (h-ech-v-v (:h-ech-v-v valeur? h))
                (w-ech-h-v (:w-ech-h-v valeur? w))
                (h-ech-h-v (:h-ech-h-v valeur? h))
                (w-prin-v (:w-prin-v valeur? w))
                (h-prin-v (:h-prin-v valeur? h))
                (w-second-v (:w-second-v valeur? w))
                (h-second-v (:h-second-v valeur? h))
                (c ())
               )
             (:valeur? bars-and-charts valeur?)
             ;
             ; pour avoir un espace de 9 fois la taille minimale requise.
             ;
             (setq min-x (sub min-x plage-x))
             (setq min-y (sub min-y plage-y))
             (setq max-x (add max-x plage-x))
             (setq max-y (add max-y plage-y))
             ;
             ; construction des deux echelles
             ;
             (setq ech-h-min-y min-y)
             (setq ech-h-max-y max-y)
             (setq liste-h (list (h-cal-echelle ())))
             (when valeur?
                  (newl liste-h (v-histogramme 
                                    ({valeur}:courbe-volume valeur?)))
                  (newl liste-h (indicateur-volume 
                                    ({valeur}:courbe-volume valeur?)))
                  (setq ech-h-min-y -10)
                  (setq ech-h-max-y 
                        (max-y ({valeur}:courbe-volume valeur?) 
                               0 (sub1 (get-length 
                                     ({valeur}:courbe-volume valeur?))))) )
             (setq liste-v (list (v-num-echelle t)))
                  
             ;
             ; construction des differents presentateurs
             ;
             (setq presentateur-prin
                   (presentateur (mul w-prin-v scale)
                        (mul h-prin-v scale)
                        min-x min-y max-x max-y liste-prin))
             (when liste-h
                (setq presentateur-ech-h
                   (presentateur (mul w-prin-v scale)
                        (mul h-prin-v scale)
                        min-x ech-h-min-y max-x ech-h-max-y liste-h)))
             (when liste-v
                (setq presentateur-ech-v
                   (presentateur (mul w-prin-v scale)
                        (mul h-prin-v scale)
                        min-x min-y max-x max-y liste-v)))
             (when liste-second1
                (setq min-x-1 (send 'mon-min-x (car liste-second1)))
                (setq min-y-1 (send 'mon-min-y (car liste-second1)))
                (setq max-x-1 (send 'mon-max-x (car liste-second1)))
                (setq max-y-1 (send 'mon-max-y (car liste-second1)))
                (setq presentateur-ech-v1 
                   (presentateur (mul w-prin-v scale)
                        (mul h-prin-v scale)
                        min-x-1 min-y-1 max-x-1 max-y-1 
                        (list (v-num-echelle t))))
                (setq presentateur-sec1
                   (presentateur (mul w-prin-v scale)
                        (mul h-prin-v scale)
                        min-x-1 min-y-1 max-x-1 max-y-1 liste-second1)) )
             (when liste-second2
                (setq min-x-2 (send 'mon-min-x (car liste-second2)))
                (setq min-y-2 (send 'mon-min-y (car liste-second2)))
                (setq max-x-2 (send 'mon-max-x (car liste-second2)))
                (setq max-y-2 (send 'mon-max-y (car liste-second2)))
                (setq presentateur-ech-v2
                   (presentateur (mul w-prin-v scale)
                        (mul h-prin-v scale)
                        min-x-2 min-y-2 max-x-2 max-y-2 
                        (list (v-num-echelle t))))
                (setq presentateur-sec2
                   (presentateur (mul w-prin-v scale)
                        (mul h-prin-v scale)
                        min-x-2 min-y-2 max-x-2 max-y-2 liste-second2)) )
             ;
             ; appel a la construction du controleur
             ;
             (:controleur bars-and-charts
               (:make-controleur 
                  bars-and-charts
                  (vue-sur-voyeur titre-prin
                        w-ech-v-v 0
                        w-prin-v h-prin-v
                        0 0 
                        (mul scale w-prin-v) (mul scale h-prin-v)
                        presentateur-prin)
                  (and liste-h
                       (vue-sur-h-voyeur ()
                                 w-ech-v-v h-prin-v
                                 w-ech-h-v h-ech-h-v 
                                 0 0 
                                 (mul scale w-prin-v) h-ech-h-v
                                 presentateur-ech-h))
                  (and liste-v
                       (vue-sur-v-voyeur (when titre-prin "")
                                 0 0
                                 w-ech-v-v h-ech-v-v 
                                 0 0    
                                 w-ech-v-v (mul scale h-prin-v)
                                 presentateur-ech-v))
                  (and liste-second1
                       ; echelle
                       (vue-sur-f-voyeur (when titre-second1 "")
                                 0 (add h-prin-v h-ech-h-v)
                                 w-ech-v-v h-second-v
                                 0 0 
                                 (mul scale w-prin-v) h-second-v
                                 presentateur-ech-v1))
                  (and liste-second1
                       ; courbe
                       (vue-sur-h-voyeur titre-second1
                                 w-ech-v-v (add h-prin-v h-ech-h-v)
                                 w-second-v h-second-v
                                 0 0 
                                 (mul scale w-prin-v) h-second-v
                                 presentateur-sec1))
                  (and liste-second2
                       ; echelle
                       (vue-sur-f-voyeur (when titre-second2 "")
                                 0 (add h-prin-v (add h-second-v h-ech-h-v))
                                 w-ech-v-v h-second-v
                                 0 0 
                                 (mul scale w-prin-v) h-second-v
                                 presentateur-ech-v2))
                  (and liste-second2
                       ; courbe
                       (vue-sur-h-voyeur titre-second2
                                 w-ech-v-v 
                                 (add h-prin-v (add h-second-v h-ech-h-v))
                                 w-second-v h-second-v
                                 0 0 
                                 (mul scale w-prin-v) h-second-v
                                 presentateur-sec2))))
            
            )))

(de :make-controleur (papa . liste-des-vues-sur-voyeur)
     (let* ((liste-des-voyeurs
              (mapcar (lambda (v)
                           (when v (send 'voyeur v)))
                   liste-des-vues-sur-voyeur))
            (liste-des-v-sur-histo ())
           )
       (setq liste-des-vues-sur-voyeur (remq '() liste-des-vues-sur-voyeur))
       (setq liste-des-voyeurs (remq '() liste-des-voyeurs))
       ;
       ; 
       (mixed-applicationq
                name 'controleur
                image (:image-controleur liste-des-vues-sur-voyeur)
                bars-and-charts papa
                liste-des-voyeurs liste-des-voyeurs
                liste-des-v-sur-histo liste-des-v-sur-histo
                vue-sur-princ-v (nth 0 liste-des-vues-sur-voyeur)
                princ-v (nth 0 liste-des-voyeurs)
                ech-h-v (nth 1 liste-des-voyeurs)
                ech-v-v (nth 2 liste-des-voyeurs)
                seco1-v (nth 4 liste-des-voyeurs)
                seco2-v (nth 6 liste-des-voyeurs) )
       ))
        
(de :image-controleur (liste)
    (apply '%view liste))


                  
;
; les fonctions demandeees ...

(de :add-object-liste-principale (bars-and-charts courbe)
    (let ((presentateur-prin 
           (send 'scrollee 
                 (component 'princ-v (:controleur bars-and-charts))))
          )
      (send 'inserer-courbe (send 'image presentateur-prin) courbe)
      (with ((current-window ({application}:window presentateur-prin)))
            (send 'display courbe 0 0 ()))
    ))

(de :delete-object-liste-principale (bars-and-charts courbe)
    (let ((presentateur-prin 
           (send 'scrollee 
                 (component 'princ-v (:controleur bars-and-charts))))
          )
      (send 'retirer-courbe (send 'image presentateur-prin) courbe)
      (send 'redisplay (component 'princ-v 
                                  (:controleur bars-and-charts))
            ())
    ))

(de :modify-object-liste-principale (bars-and-charts courbe-old courbe)
    (let ((presentateur-prin 
           (send 'scrollee 
                 (component 'princ-v (:controleur bars-and-charts))))
          )
      (send 'modifier-courbe (send 'image presentateur-prin) courbe-old courbe)
      (send 'redisplay (component 'princ-v 
                                  (:controleur bars-and-charts))
            ())
    ))

(de :add-object-liste-secondaire-1 (bars-and-charts courbe)
    (let ((presentateur 
           (send 'scrollee 
                 (component 'seco1-v (:controleur bars-and-charts))))
          )
      (send 'inserer-courbe (send 'image presentateur) courbe)
      (with ((current-window ({application}:window presentateur)))
            (send 'display courbe 0 0 ()))
    ))

(de :delete-object-liste-secondaire-1 (bars-and-charts courbe)
    (let ((presentateur 
           (send 'scrollee 
                 (component 'seco1-v (:controleur bars-and-charts))))
          )
      (send 'retirer-courbe (send 'image presentateur) courbe)
      (send 'redisplay (component 'seco1-v 
                                  (:controleur bars-and-charts))
            ())
    ))

(de :modify-object-liste-secondaire-1 (bars-and-charts courbe-old courbe)
    (let ((presentateur
           (send 'scrollee 
                 (component 'seco1-v (:controleur bars-and-charts))))
          )
      (send 'modifier-courbe (send 'image presentateur) courbe-old courbe)
      (send 'redisplay (component 'seco1-v 
                                  (:controleur bars-and-charts))
            ())
    ))

(de :add-object-liste-secondaire-2 (bars-and-charts courbe)
    (let ((presentateur 
           (send 'scrollee 
                 (component 'seco2-v (:controleur bars-and-charts))))
          )
      (send 'inserer-courbe (send 'image presentateur) courbe)
      (with ((current-window ({application}:window presentateur)))
            (send 'display courbe 0 0 ()))
    ))

(de :delete-object-liste-secondaire-2 (bars-and-charts courbe)
    (let ((presentateur 
           (send 'scrollee 
                 (component 'seco2-v (:controleur bars-and-charts))))
          )
      (send 'retirer-courbe (send 'image presentateur) courbe)
      (send 'redisplay (component 'seco2-v 
                                  (:controleur bars-and-charts))
            ())
    ))

(de :modify-object-liste-secondaire-2 (bars-and-charts courbe-old courbe)
    (let ((presentateur 
           (send 'scrollee 
                 (component 'seco2-v (:controleur bars-and-charts))))
          )
      (send 'modifier-courbe (send 'image presentateur) courbe-old courbe)
      (send 'redisplay (component 'seco2-v 
                                  (:controleur bars-and-charts))
            ())
    ))


; ajout d'histogrammes 

(de :create-vertical-histogramme (bars-and-charts courbe)
        (let* ((controleur (:controleur bars-and-charts))
               (liste-des-histo (component 'liste-des-v-sur-histo controleur))
               (princ-v (component 'princ-v controleur))
               (presentateur-prin (send 'image (send 'scrollee princ-v)))
               (v-histo (gros-v-histogramme (send 'liste-de-points courbe)))
               (presentateur ())
               (vue-sur-voyeur ())
               (valeur? (:valeur? bars-and-charts))
               (w (:h-second-v valeur? (send 'width bars-and-charts)))
               (h (send 'height princ-v))
               (w0 (send 'width (send 'scrollee princ-v)))
               (h0 (send 'height (send 'scrollee princ-v)))
               (x0 (send 'x (send 'scrollee princ-v)))
               (y0 (send 'y (send 'scrollee princ-v)))
              )
            (setq presentateur 
                  (presentateur w h
                        (min (send 'mon-min-x courbe) 0)
                        (send 'min-y presentateur-prin)
                        (send 'mon-max-x courbe)
                        (send 'max-y presentateur-prin)
                        (list v-histo)))
            (setq vue-sur-voyeur 
                  (vue-sur-h-voyeur "essai"
                                 0 0 w h
                                 x0 y0 w0 h0 presentateur))
            (add-component controleur 'liste-des-v-sur-histo
                  (newl liste-des-histo (send 'voyeur vue-sur-voyeur)))
            (application '{application}
                        0 0 (add 30 w) (add 30 h)
                        (%centeredview 
                          (beau-cadre 0 0 (add 30 w) (add 30 h) t)
                          (filledbox 0 0 w h 0)
                          vue-sur-voyeur))
      ))

(de :create-horizontal-histogramme (bars-and-charts courbe)
        (let* ((controleur (:controleur bars-and-charts))
               (liste-des-histo (component 'liste-des-v-sur-histo controleur))
               (vue-sur-princ-v (component 'vue-sur-princ-v controleur))
               (princ-v (component 'princ-v controleur))
               (presentateur-prin (send 'image (send 'scrollee princ-v)))
               (h-histo (gros-h-histogramme (send 'liste-de-points courbe)))
               (presentateur ())
               (vue-sur-voyeur ())
               (valeur? (:valeur? bars-and-charts))
               (w (:h-second-v valeur? (send 'width bars-and-charts)))
               (h (send 'height vue-sur-princ-v))
               (w0 (send 'width (send 'scrollee princ-v)))
               (h0 (send 'height (send 'scrollee princ-v)))
               (x0 (send 'x (send 'scrollee princ-v)))
               (y0 (send 'y (send 'scrollee princ-v)))
              )
            (setq presentateur 
                  (presentateur w0 h0
                        (min (send 'mon-min-x courbe) 0)
                        (send 'min-y presentateur-prin)
                        (send 'mon-max-x courbe)
                        (send 'max-y presentateur-prin)
                        (list h-histo)))
            (setq vue-sur-voyeur 
                  (vue-sur-v-voyeur "essai" 0 0 w h 
                        x0 y0 w0 h0 presentateur))
            (add-component controleur 'liste-des-v-sur-histo
                  (newl liste-des-histo (send 'voyeur vue-sur-voyeur)))
            (application '{application}
                        0 0 (add 30 w) (add 30 h)
                        (%centeredview 
                          (beau-cadre 0 0 (add 30 w) (add 30 h) t)
                          (filledbox 0 0 w h 0)
                          vue-sur-voyeur))
      ))
                                        
           
; renvoient la liste des courbes contenues dans les voyeurs ..

(de :get-liste-principale (bars-and-charts)
        (let* ((controleur (:controleur bars-and-charts))
               (princ-v (component 'princ-v controleur))
               (presentateur-prin (send 'image (send 'scrollee princ-v)))
              )
           (cdr (send 'liste-de-courbes presentateur-prin))
        ))

(de :get-liste-secondaire1 (bars-and-charts)
        (let* ((controleur (:controleur bars-and-charts))
               (seco1-v (component 'seco1-v controleur))
               (presentateur (send 'image (send 'scrollee seco1-v)))
              )
           (cdr (send 'liste-de-courbes presentateur))
        ))

(de :get-liste-secondaire2 (bars-and-charts)
        (let* ((controleur (:controleur bars-and-charts))
               (seco2-v (component 'seco2-v controleur))
               (presentateur (send 'image (send 'scrollee seco2-v)))
              )
           (cdr (send 'liste-de-courbes presentateur))
        ))

;
; utile ..
    
(de :valeur-presente? (liste-de-courbes)
        (any '(lambda (c)
                      (when (typep c '{valeur})
                            c))
              liste-de-courbes))
                    

;------------------------------------------------------------------------
;                  tailles standards ...
;------------------------------------------------------------------------
;
; quelques facteurs multiplicatifs standards ...

(de :w-ech-v-v (valeur? w)
        30)

; le voyeur principal

(de :w-prin-v (valeur? w)
    (sub w (:w-ech-v-v valeur? w)))

(de :h-prin-v (valeur? h)
    (if valeur?
        (fix (* 8 (/ h 15)))
      (fix (* 9 (/ h 15))) ))

; les deux voyeurs sur les echelles

(de :w-ech-h-v (valeur? w)
        (:w-prin-v valeur? w))

(de :h-ech-h-v (valeur? h)
    (if valeur?
        (fix (* 2 (/ h 15)))
      (fix (* 1 (/ h 15))) ))

(de :h-ech-v-v (valeur? h)
    (:h-prin-v valeur? h))

; les deux voyeurs secondaires

(de :w-second-v (valeur? w)
        (:w-prin-v valeur? w))

(de :h-second-v (valeur? h)
    (fix (* 1 (/ h 6))) )

;------------------------------------------------------------------------


#|
(de scroll-voyeurs (b)
    (let* ((controleur ({bars-and-charts}:controleur 
                                (component 'bars-and-charts b)))
           (voyeur-prin (component 'princ-v controleur))
           (presentateur-prin (send 'scrollee voyeur-prin))
           (cadre-de-deplacement (component 'espace-utilisable b))
           (w-prin (send 'width presentateur-prin))
           (h-prin (send 'height presentateur-prin))
           (old-x (send 'x presentateur-prin))
           (old-y (send 'y presentateur-prin))
           (w-deplaceur (send 'width b))
           (h-deplaceur (send 'height b))
           (w-cadre (send 'width cadre-de-deplacement))
           (h-cadre (send 'height cadre-de-deplacement))
           (new-x (send 'x b))
           (new-y (send 'y b))
          )
        ; on ne veut pas sortir du cadre

        (setq new-x (- (max 0 (min new-x (sub w-cadre w-deplaceur)))))
        (setq new-y (- (max 0 (min new-y (sub h-cadre h-deplaceur)))))
        (setq new-x (fix (* new-x (/ w-prin w-cadre))))
        (setq new-y (fix (* new-y (/ h-prin h-cadre))))
        (map-voyeurs (lambda (v)
                          (send 'scroll v 
                                (sub new-x old-x)
                                (sub new-y old-y) t))
                     controleur)
        (:ajuster-deplaceur b)
    ))
|#


(de :ajuster-deplaceur (b)
    (when (typep b '{bars-and-charts})
          (setq b (component 'deplaceur (component 'interface b))))
    (let* ((controleur ({bars-and-charts}:controleur
                                (component 'bars-and-charts b)))
           (voyeur-prin (component 'princ-v controleur))
           (presentateur-prin (send 'scrollee voyeur-prin))
           (deplaceur (component 'deplaceur b))
           (cadre-de-deplacement (component 'espace-utilisable b))
           (w-cadre (send 'width cadre-de-deplacement))
           (h-cadre (send 'height cadre-de-deplacement))
           (w-prese (send 'width presentateur-prin))
           (h-prese (send 'height presentateur-prin))
           (ech-w (/ (send 'width voyeur-prin) w-prese))
           (ech-h (/ (send 'height voyeur-prin) h-prese))
          )
        (send 'grow deplaceur
                (fix (* ech-w w-cadre))
                (fix (* ech-h h-cadre)))

        (send 'translate deplaceur
                (fix (* (/ w-cadre w-prese)
                        (- (send 'x presentateur-prin))))
                (fix (* (/ h-cadre h-prese)
                        (- (send 'y presentateur-prin)))))
        (full-redisplay cadre-de-deplacement)
    ))
