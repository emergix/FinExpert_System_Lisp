

 (de courbe-2d-extract-droite-de-canal-haut (courbe rang1 rang2 precision-brute nombre-critique)
     (prog ((rang-debut rang1)
            (rang-try (1+ rang1))
            rang-try-next
            (h (get-slot-value courbe 'body))
            precision
            x-min
            x-max
            a-courant
            b-courant
            points-courants
            x0-courant
            liste-de-droites
            situation-du-point-courant
            liste-de-droites-de-convexite
            sous-liste)
           (setq x-min (car (vref h 0)))
           (setq x-max (car (vref h (1- (vlength h)))))
           loop
           (cond ((> rang-try rang2) (go fin)))        
           (setq situation-du-point-courant
                 (canavex-forme-situation-du-point-courant  h rang-try a-courant b-courant points-courants x0-courant precision))
           (cond ((eq  situation-du-point-courant 'point-acceptable)
                  (setq points-courants (cons rang-try points-courants))
                  (when (eq (length points-courants) 2)
                        (setq a-courant (canavex-forme-a-b-courant h (cadr points-courants) (car points-courants)))
                        (setq b-courant (cadr a-courant))
                        (setq a-courant (car a-courant))
                        (setq x0-courant (cadr points-courants))
                        (setq precision (canavex-forme-precision precision-brute x-min x-max x0-courant)))
                  (setq rang-try (1+ rang-try))
                  (go loop))
                 ((eq  situation-du-point-courant 'brisure-vers-le-haut)
                  (cond ((>= (length points-courants) nombre-critique)
                         (setq point-de-sortie (1- rang-try))
                         (setq liste-de-droite (cons (canavex-forme-droite  h rang1  a-courant b-courant points-courants
                                                                            x0-courant rang-try point-de-sortie)
                                                     liste-de-droites))
                         (setq rang-debut (canavex-descent-jusqu-a-la-droite h  rang-try  a-courant b-courant x0-courant precision))
                         (setq points-courants nil)
                         (setq rang-try (1+ rang-debut))
                         (go loop))
                        (t (setq rang-try (canavex-eleve-jusqu-au-sommet h rang-try  rang-debut rang2
                                                                         x0-courant precision))
                           (setq points-courants (list rang-debut rang-try))
                           (setq a-courant (canavex-forme-a-b-courant h rang-debut rang-try))
                           (setq b-courant (cadr a-courant))
                           (setq a-courant (car a-courant))
                           (setq x0-courant (car (vref h rang-debut)))
                           (setq precision (canavex-forme-precision precision-brute x-min x-max x0-courant))
                           (setq rang-try (1+ rang-try))
                           (go loop))))
                 ((eq  situation-du-point-courant 'brisure-vers-le-bas)
                  (setq rang-try-next (canavex-prochaine-rencontre-avec-la-droite h rang-try rang-debut rang2 x0-courant precision))
                  (cond ((null rang-try-next)
                         (setq liste-de-droites-de-convexite
                               (cons (canavex-forme-droite-de-convexite  h rang-debut rang-try)
                                     liste-de-droites-de-convexite))
                         (setq rang-debut (canavex-remonte-jusqu-a-la-droite h  rang-try  a-courant b-courant x0-courant precision))
                         (setq rang-try (1+ rang-debut))
                         (go loop))
                        (t (setq sous-liste  (courbe-2d-extract-droite-de-canal-haut-2
                                              h (canavex-remonte-jusqu-a-la-droite h  rang-try 
                                                                                   a-courant b-courant x0-courant precision)
                                              rang-try-next precision nombre-critique))
                           (setq liste-de-droites (append (car sous-liste) liste-de-droites))
                                        ;la sous-liste de convexite n est pas interessante et ne sera pas calcule
                        
                           (setq points-courants (cons rang-try-next points-courants))
                           (setq rang-try (1+ rang-try-next))
                           (go loop)))))     
           fin
           (cond ((>= (length points-courants) nombre-critique)
                  (setq point-de-sortie nil)
                  (setq liste-de-droite (cons (canavex-forme-droite h  rang1 a-courant b-courant points-courants
                                                                    x0-courant rang-try point-de-sortie)
                                              liste-de-droites))
                  (return (list  (reverse liste-de-droites)  (reverse liste-de-droites-de-convexite))))
                 (t
                  (return (list  (reverse liste-de-droites)  (reverse liste-de-droites-de-convexite)))))))
                

        

 (de canavex-create-droite-technique (courbe rang1 rang2 epsilon pcentre rayon circonstance)
     (prog  ((extremum-groupe-total  (mapcan '(lambda (x) (cond ((eq (get-slot-value x 'courbe) courbe) (list x))
                                                                (t nil)))
                                             (get-all-instances 'extremum-local)))
             extremum-liste-1 
             (h (get-slot-value courbe 'body))
             (liste-des-droites-techniques (get-slot-value courbe 'liste-des-droites-techniques)) 
             p1 p2 a b c a1 a2 a3 point1 point2 dr p d liste-d-extremums)
            (setq extremum-liste-1 (copy extremum-groupe-total))
            (setq p1 (vref h rang1))
            (setq p2 (vref h rang2))
            (setq point1 (find-extremum-meme-pseudo rang1 courbe extremum-groupe-total ))
            (setq point2 (find-extremum-meme-pseudo rang2 courbe extremum-groupe-total ))
            (when (any '(lambda (x) (let ((a1 (car x)) (a2 (cadr x)) (a3 (caddr x)))
                                      (and (< (abs (- (* (cadr p1) a1) (+ a2 (* (car p1) a3)))) (* 0.02 epsilon))
                                           (<= (abs (- (* (cadr p2) a1) (+ a2 (* (car p2) a3)))) (* 0.02 epsilon)))))
                       liste-des-droites-techniques )
                  (when *surveillance-flag1* (print "droite deja mentionne : ( " rang1 " " rang2")"))
                  (return nil))         ;si la droite a deja ete mentionnee
            (setq a (/ (- (cadr p1) 
                          (cadr p2))
                       (- (car p1)
                          (car p2))))
            (setq b (- (cadr p1)
                       (* a (car p1))))
            (setq c (* (/ (sqrt (1+ (* a a))) (+ (* *csurj* *csurj*) (* a a))) *csurj*))
            (setq a1 c)
            (setq a2 (* b c))
            (setq a3 (* a c))
            (when *surveillance-flag1* (print "point1 = " point1 " point2 =" point2 "distance centre = "
                                              (abs (- (* (cadr pcentre) a1) (+ a2 (*  (car pcentre) a3))))))
            (when  (> (abs (- (* (cadr pcentre) a1) (+ a2 (*  (car pcentre) a3)))) rayon)
                   (when *surveillance-flag1* (print "droite trop loin : ( " rang1 " " rang2")"))
                   (return nil))        ;si la droite est trop loin de notre zone d interet
            (setq liste-d-extremums nil)
            loop
            (when (null extremum-liste-1) (go fin))
            (setq point (car extremum-liste-1))

            (setq p (get-fondamental-value point 'hauteur))
            (setq d (abs (- (* (cadr p) a1)
                            (+ a2 (* (car p) a3)))))
            (when *surveillance-flag2* (print "point3 =" p " distance = " d))
            (when (and (<= d epsilon)
                       (not (memq point liste-d-extremums)))
                  (setq liste-d-extremums (cons point liste-d-extremums)))
            (setq extremum-liste-1 (cdr extremum-liste-1))
            (go loop)
            fin
            (setq liste-d-extremums-1 (cons point1 (append liste-d-extremums (list point2))))
            (setq dr ($ 'droite-technique 'instanciate nil nil))
            (setf liste-des-droites-techniques (cons (list a1 a2 a3 dr) liste-des-droites-techniques ))
            (setf (get-slot-value courbe 'liste-des-droites-techniques) liste-des-droites-techniques )
            (setf (get-slot-value dr 'courbe-origine) courbe)
            (setf (get-slot-value dr 'pente) a)
            (setf (get-slot-value dr 'ordonnee-zero) b)
            (setf (get-slot-value dr 'force) (length liste-d-extremums-1))
            (setf (get-slot-value dr 'liste-d-extremums ) liste-d-extremums-1)
            (setf (get-slot-value dr 'sous-type) circonstance)
            (montre-droite-graphique dr rang1)
            (rajoute-droite-graphique dr rang1)
            (return nil)
            ))

         
  (de essai-2  ( precision-brute)

      (setq aa (mapcan '(lambda (x) (car (courbe-2d-extract-droite-de-canal-haut-2 ww x 95 precision-brute 3)))
                       (mapcan '(lambda (y) (cond ((eq (get-slot-value (get-slot-value y 'courbe) 'body) ww)
                                                   (list (get-slot-value y 'rang)))
                                                  (t nil)))
                               (get-all-instances 'minimum-local)))))
                                             
 (de essai-2-r  ( precision-brute)

      (setq aa (mapcan '(lambda (x) (car (courbe-2d-extract-droite-de-canal-haut-2-r ww 0 x precision-brute 3)))
                       (cons (1- (vlength ww))  (mapcan '(lambda (y) (cond ((eq (get-slot-value (get-slot-value y 'courbe) 'body) ww)
                                                   (list (get-slot-value y 'rang)))
                                                  (t nil)))
                               (get-all-instances 'minimum-local))))))
                                             

