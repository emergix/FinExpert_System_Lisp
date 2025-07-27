

(de zoom+ (b)
    (map-voyeurs
          (lambda (voyeur)
                  (send 'zoom voyeur
                             (+ 1 ({voyeur}:current-zoom-w voyeur))
                             (+ 1 ({voyeur}:current-zoom-h voyeur)) ))
          ({bars-and-charts}:controleur
                                (component 'bars-and-charts b)))
    ({bars-and-charts}:ajuster-deplaceur b) )
     

(de zoom- (b)
    (map-voyeurs
          (lambda (voyeur)
                  (send 'zoom voyeur 
                             (- ({voyeur}:current-zoom-w voyeur) 1)
                             (- ({voyeur}:current-zoom-h voyeur) 1) ))
          ({bars-and-charts}:controleur
                                (component 'bars-and-charts b)))
    ({bars-and-charts}:ajuster-deplaceur b))

(de scroll-right (b)
   (let ((controleur ({bars-and-charts}:controleur
                                (component 'bars-and-charts b)))
        )
    (map-voyeurs
          (lambda (voyeur)
                   (send 'scroll voyeur 
                        (- (compute-h-step controleur)) 0 t))
          controleur)
    ({bars-and-charts}:ajuster-deplaceur b)))

(de scroll-left (b)
   (let ((controleur ({bars-and-charts}:controleur
                                (component 'bars-and-charts b)))
        )
    (map-voyeurs
          (lambda (voyeur)
                    (send 'scroll voyeur
                        (compute-h-step controleur) 0 t))
          controleur)
    ({bars-and-charts}:ajuster-deplaceur b)))

(de scroll-down (b)
   (let ((controleur ({bars-and-charts}:controleur
                                (component 'bars-and-charts b)))
        )
    (map-voyeurs
          (lambda (voyeur)
                  (send 'scroll voyeur 
                        0 (compute-v-step controleur) t))
          controleur)
    ({bars-and-charts}:ajuster-deplaceur b)))

(de scroll-up (b)
   (let ((controleur ({bars-and-charts}:controleur
                                (component 'bars-and-charts b)))
        )
    (map-voyeurs
          (lambda (voyeur)
                   (send 'scroll voyeur 
                        0 (- (compute-v-step controleur)) t))
          controleur)
    ({bars-and-charts}:ajuster-deplaceur b)))

(de quit-bars-and-charts (b)
    (remove-application (component 'bars-and-charts b)))

(de grow1 (b)
    (send 'grow (component 'bars-and-charts b)
                (div (bitxmax) 3)
                (div (bitymax) 3))
    
    (send 'redisplay (component 'bars-and-charts b) ())
    ({bars-and-charts}:ajuster-deplaceur b))

(de grow2 (b)
    (send 'grow (component 'bars-and-charts b)
                (mul 2 (div (bitxmax) 3))
                (mul 2 (div (bitymax) 3)))
    (send 'redisplay (component 'bars-and-charts b) ())
    ({bars-and-charts}:ajuster-deplaceur b))

(de grow3 (b)
    (send 'grow (component 'bars-and-charts b)
                (bitxmax) (bitymax))
    (send 'redisplay (component 'bars-and-charts b) ())
    ({bars-and-charts}:ajuster-deplaceur b))

(de show-figure (button object)
    (let ((bars-and-charts (component 'bars-and-charts button))
          )
      (setq object (get-courbe bars-and-charts object))
      (when (or (typep object '{figure})
                (typep object '{segment}))
            (let ((presentateur
                   (quel-presentateur?
                    ({bars-and-charts}:controleur bars-and-charts)
                    object))
                  )
              (when presentateur
                    (send 'show object)
                    (with ((current-window 
                            ({application}:window presentateur)))
                          (send 'display object 0 0 ())))
              ))))

(de hide-figure (button object)
    (let ((bars-and-charts (component 'bars-and-charts button))
          )
      (setq object (get-courbe bars-and-charts object))
      (when (or (typep object '{figure})
                (typep object '{segment}))
            (let ((voyeur
                   (quel-voyeur?
                    ({bars-and-charts}:controleur bars-and-charts)
                    object))
                  )
              (when voyeur
                    (send 'hide object)
                    (full-redisplay voyeur))
              ))))


(de redisplay-all (b)
    (let* ((controleur ({bars-and-charts}:controleur 
                        (component 'bars-and-charts b)))
           )
      (send 'redisplay controleur ())
      ))


(de user-action1 (b)
    (print "appel a` user-action1"))

(de user-action2 (b)
    (print "appel a` user-action2"))


; utilities ...


(de compute-h-step (controleur)
    (let* ((prin-voyeur (component 'princ-v controleur))
           (image-scrollee (send 'scrollee prin-voyeur))
           (difference (sub (send 'width image-scrollee) 
                            (send 'width prin-voyeur)))
           )
      (setq difference (max 0 difference))
      (div difference 6)
      ))

(de compute-v-step (controleur)
    (let* ((prin-voyeur (component 'princ-v controleur))
           (image-scrollee (send 'scrollee prin-voyeur))
           (difference (sub (send 'height image-scrollee) 
                            (send 'height prin-voyeur)))
           )
      (setq difference (max 0 difference))
      (div difference 6)
      ))

(de quel-presentateur? (controleur courbe)
    (car (maplist-voyeurs (lambda (v)
                            (let ((presentateur 
                                   (send 'scrollee (car v)))
                                  )
                              (when ({presentateur}:is-one-of-my-courbes 
                                     (send 'image presentateur)
                                     courbe)
                                    presentateur)))
                          controleur)))

(de quel-voyeur? (controleur courbe)
    (car (maplist-voyeurs (lambda (v)
                            (let ((presentateur 
                                   (send 'scrollee (car v)))
                                  )
                              (when ({presentateur}:is-one-of-my-courbes 
                                     (send 'image presentateur)
                                     courbe)
                                    (car v))))
                          controleur)))

(de map-voyeurs (function controleur)
    (mapc function
          (component 'liste-des-voyeurs controleur))
    (mapc function
          (component 'liste-des-v-sur-histo controleur)))

(de maplist-voyeurs (function controleur)
    (append
     (maplist function
              (component 'liste-des-voyeurs controleur))
     (maplist function
              (component 'liste-des-v-sur-histo controleur))))


(de etats (c)
    (map-voyeurs 
     (lambda (v)
       (print " x " (send 'x (send 'scrollee v)))
       (print " y " (send 'y (send 'scrollee v)))
       (print " w " (send 'current-zoom-w v))
       (print " h " (send 'current-zoom-h v)))
     c))


