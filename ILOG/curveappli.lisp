'(defvar :smallfont-name "6x10")

(unless (boundp ':smallfont)
        (defvar :smallfont))

(defvar :curve-user-action (lambda (b ev) ()))

(de courbe2d (curve dx dy kx ky)
    (let* ((body (get-slot-value curve 'body))
           (n (vlength body))
           (vx (makevector n 0))
           (vy (makevector n 0)))
      (for (i 0 1 (sub1 n))
           (vset vx i (fix (* kx *corrector-kx* (- (car (vref body i)) dx ))))
           (vset vy i (fix (* ky *corrector-ky* (- (cadr (vref body i)) dy)))))
      (omakeq {polyline} n n vx vx vy vy)))

(de droitetechnique (x0 x1 curve dx dy kx ky)
    (let ((pente (get-slot-value curve 'pente))
          (ordonnee (get-slot-value curve 'ordonnee-zero)))
      (omakeq {polyline}
              n 2
              vx (vector (fix (* kx *corrector-kx* (- x0 dx)))
                         (fix (* kx *corrector-kx* (- x1 dx))))
              vy (vector (fix (* ky *corrector-ky* (- (+ ordonnee (* x0 pente)) dy )))
                         (fix (* ky *corrector-ky* (- (+ ordonnee (* x1 pente)) dy )))))))

(de lignebrisee (curve dx dy kx ky)
    (let* ((liste (get-slot-value curve 'liste-de-points))
           (n (length liste))
           (vx (makevector n 0))
           (vy (makevector n 0)))
      (for (i 0 1 (sub1 n))
           (vset vx i (fix (* kx *corrector-kx*  (- (car (car liste)) dx))))
           (vset vy i (fix (* ky *corrector-ky*  (- (cadr (nextl liste)) dy)))))
      (omakeq {polyline} n n vx vx vy vy)))


(de repere-graphique(x0 x1  dx dy kx ky x y)
  
      (omakeq {polyline}
              n 3
              vx (vector (fix (* kx *corrector-kx* (- x0 dx)))
                         (fix (* kx *corrector-kx* (- x dx)))
                         (fix (* kx *corrector-kx* (- x1 dx))))
              vy (vector (fix (* ky *corrector-ky* (- 0 dy)))
                         (fix (* ky *corrector-ky* (- y dy)))
                         (fix (* ky *corrector-ky* (- 0 dy))))))
           



(de :repeater (i)
    (repeater
     (:fond-blanc
     (font :bigfont
           (translation 1 1
                        (boxedview
                         (:double-bbox
                          (mul :button-widthcn #wc)
                          (add 8 #hc)
                          (translation 0 1 i))))))))

(de :button (i)
    (button
     (:fond-blanc
     (font :bigfont
           (translation 1 1
                        (boxedview
                         (:double-bbox
                          (mul :button-widthcn #wc)
                          (add 8 #hc)
                          (translation 0 1 i))))))))

(unless (boundp '*glue*)
        (defvar *glue* 10)
        (defvar *space* 4)
        (defvar *step* 7))

(defabbrev curveapplication {Application}:curveapplication)

(defstruct {curveapplication}
  editor scalex scaley transx transy step index scale x1 x2)

(setq #:sys-package:colon '{curveapplication})

(defvar :rectangle #:image:rectangle:#[0 0 0 0])

(define-application-property-accessor expert)
(define-application-property-accessor panel)

(de curveappli (titre w1 h1 curves)
    (unless #:user:smallfont
	    (setq #:user:smallfont (load-font #:user:smallfont-name)))
    (unless #:user:bigfont
	    (setq #:user:bigfont (load-font #:user:bigfont-name)))
    (let* ((scale (:get-scale-bbox (get-slot-value (car curves) 'body)
                                   :rectangle))
           (index 0)
           (step *step*)
           (x1 ({rectangle}:x :rectangle))
           (y1 (- ({rectangle}:y :rectangle) (/ *glue* *corrector-ky*)))
           (x2 ({rectangle}:w :rectangle))
           (y2 (+ ({rectangle}:h :rectangle) (/ *glue* *corrector-ky*)))
           (comment (application '{application} 0 0
				 (mul 16
                                      (with ((current-font #:user:smallfont))
                                            (width-space)))
				 (mul 2
                                      (with ((current-font #:user:smallfont))
                                            (height-space)))
				 (font #:user:smallfont 
				       (column
					(catenate " x="
						 
                                                  (cond ((eq *mode-display-time* nil) (string (car (vref scale index))))
                                                        (t (apply 'catenate 
                                                                  (mapcar '(lambda (x) (catenate " " (string x))) 
                                                                          (inverse-convert-time 
                                                                           (car (vref scale index))))))))
                                        (catenate " y="
                                                  (string
                                                   (cadr (vref scale index)))
                                                  " #" 
                                                  (string 
                                                   index)))
				       )))
           (fast (#:user:repeater " FAST "))
           (slow (#:user:repeater " SLOW "))
           (mark (#:user:repeater " Mark "))
           (user (#:user:button " Disp "))
           (user1 (#:user:button " Fonct "))
           (user2 (#:user:button " Reset "))
           (user3 (#:user:button " Trans "))

           (w2 (div (sub w1 (add (send 'width comment)
                                 (add (send 'width mark)
                                      (add (send 'width user)
                                           (add (send 'width slow)
                                                (add (send 'width fast)
                                                     (add (send 'width user1)
                                                          (add (send 'width user2)
                                                               (send 'width user3)))))))))
                    2))
           (glue1 (rectangle 0 0 w2 0))
           (glue2 (rectangle 0 0 w2 0))
           (panel (row comment glue1 mark user user1 user2 user3 glue2 slow fast))
           (curvexmax w1)
           (curveymax (sub h1 (send 'height panel)))
           (dx x1)
           (dy (/ y1 *corrector-ky*))
           (kx (/ curvexmax (- x2 x1)))
           (ky (/ curveymax (- y2 y1)))
           (w  (add1 (fix (* kx (- x2 x1)))))
           (h  (fix (* ky  (- y2 y1))))
           (cursor (cursor 0 0 w h))
           (images (progn (setq dy y2)
                          (setq ky (- ky))
                          (mapcar (lambda (c)
                                    (cond ((consp c)
                                           (repere-graphique x1 x2 dx dy kx ky
                                                             (car c)
                                                             (cadr (get-slot-value expert-canal 'graphique-min-max))))
                                          ((is-a c 'ligne-brisee)
                                           (lignebrisee c dx dy kx ky))
                                          ((is-a c 'courbe-2d)
                                           (courbe2d c dx dy kx ky))
                                          ((is-a c 'droite)
                                           (droitetechnique x1 x2 c
                                                            dx dy kx ky))))
                                  curves)))
           (curveeditor (application '{curveeditor} 0 0 w h
                                     (apply 'view (cons cursor images))))
           (appli (application '{curveApplication} 0 0 0 0 
                               (column (string titre)  curveeditor panel)))
         
           )
      ({application}:panel  appli panel)
      (:editor appli curveeditor)
      (:scalex appli kx)
      (:scaley appli ky)
      (:transx appli dx)
      (:transy appli dy)
      (:step   appli step)
      (:index  appli index)
      (:scale  appli scale)
      ({application}:expert appli *current-expert*)
      (:x1 appli x1)
      (:x2 appli x2)
      (set-action fast (lambda (b ev)
                         (let ((appli (component 'appli b)))
                           (cond ((eq (#:event:detail ev) 1024)
                                  (if (gt (:index appli) 10)
                                      (:index appli
                                              (sub (:index appli)
                                                   (:step appli)))
                                    (:index appli 0))
                                  (:slide-cursor appli))
                                 ((eq (#:event:detail ev) 256)
                                  (if (lt (:index appli)
                                          (sub (vlength (:scale appli))
                                               (:step appli)))
                                      (:index appli
                                              (add (:index appli)
                                                   (:step appli)))
                                    (:index appli
                                            (sub1 (vlength (:scale appli))))) 
                                  (:slide-cursor appli))))))
      (set-action slow (lambda (b ev)
                         (let ((appli (component 'appli b)))
                           (cond ((and (eq (#:event:detail ev) 1024)
                                       (gt (:index appli) 0))
                                  (:index appli (sub (:index appli) 1))
                                  (:slide-cursor appli))
                                 ((and (eq (#:event:detail ev) 256)
                                       (lt (:index appli)
                                           (sub (vlength (:scale appli)) 1)))
                                  (:index appli (add (:index appli) 1))
                                  (:slide-cursor appli))))))
      (set-action mark (lambda (b ev)
                         (let* ((appli (component 'appli b))
                                (xy (vref (:scale appli) (:index appli)))
                                (editor (:editor appli)))
                           (send 'eventx editor
                                 (fix (* (:scalex appli)
                                         (- (car xy) (:transx appli)))))
                           (send 'eventy editor
                                 (fix (* (:scaley appli)
                                         (- (cadr xy) (:transy appli)))))
                           (send 'activated-event editor ()))))
      (set-action user '(lambda (c) 
                          (prog (fonction-choisie function-menu)
                                (setq function-menu (create-menu "----operations-----"
                                                                 "echelle-x : + 20%" 'echelle-x-plus-20
                                                                 "echelle-x : - 20%" 'echelle-x-moins-20
                                                                 "echelle-y : + 20%" 'echelle-y-plus-20
                                                                 "echelle-y : - 20%" 'echelle-y-moins-20))
                                (read-mouse)
                                (setq fonction-choisie (activate-menu function-menu #:mouse:x #:mouse:y))
                                (cond ((eq fonction-choisie 'echelle-x-plus-20) ($ ({application}:expert (component 'appli c))
                                                                                   'echelle-x-plus-20))
                                      ((eq fonction-choisie 'echelle-x-moins-20) ($ ({application}:expert (component 'appli c))
                                                                                    'echelle-x-moins-20))
                                      ((eq fonction-choisie 'echelle-y-plus-20) ($ ({application}:expert (component 'appli c))
                                                                                   'echelle-y-plus-20))
                                      ((eq fonction-choisie 'echelle-y-moins-20) ($ ({application}:expert (component 'appli c))
                                                                                    'echelle-y-moins-20)))
                                (full-redisplay  ({application}:expert (component 'appli c)))
                                )))
                                      
      (set-action cursor (lambda (c)
                           (let* ((appli (component 'appli c))
                                  (xy (vref (:scale appli) (:index appli))))
                             (send 'set-image (component 'comment appli)
                                   (font #:user:smallfont
					 (column
					  (catenate " x=" 
                                                    (cond ((eq *mode-display-time* nil) (string (car xy)))
                                                          (t (apply 'catenate 
                                                                    (mapcar '(lambda (x) (catenate " " (string x))) 
                                                                            (inverse-convert-time (car xy)))))))
                                          (catenate " y=" (string (cadr xy))
                                                    " #" (string (:index appli)))
                                          
					  ))))))
   
      (set-action user1 '(lambda (c) 
                           (prog (fonction-choisie function-menu)
                                 (setq function-menu (create-menu "------fonctions-------"
                                                                  "create-droite" 'create-droite 
                                                                  "show-droite" 'show-droite
                                                                  "distance-object-curseur" 'distance-object-curseur
                                                                  "distance-object-point" 'distance-object-point
                                                                  "distance-object-object" 'distance-object-object
                                                                  "show-extremums" 'show-extremums
                                                                  "show-extremums-niveau-2" 'show-extremums-niveau-2
                                                                  "show-extremums-niveau-3" 'show-extremums-niveau-3
                                                                  "show-extremums-niveau-4" 'show-extremums-niveau-4
                                                                  "show-droite-liste-d-extremums"
                                                                  'show-droite-liste-d-extremums
                                                                  "droite-la-plus-proche"
                                                                  'droite-la-plus-proche
                                                                  "montre-droite"
                                                                  'montre-droite
                                                                  ))
                                 (read-mouse)
                                 (setq fonction-choisie (activate-menu function-menu #:mouse:x #:mouse:y))
                                 (cond ((eq fonction-choisie 'create-droite) 
                                        ($ ({application}:expert (component 'appli c)) 'create-droite))
                                       ((eq fonction-choisie 'show-droite) 
                                        ($ ({application}:expert (component 'appli c)) 'show-droite))
                                       ((eq fonction-choisie 'distance-object-curseur)
                                        ($ ({application}:expert (component 'appli c)) 'distance-object-curseur))
                                       ((eq fonction-choisie 'distance-object-point)
                                        ($ ({application}:expert (component 'appli c)) 'distance-object-point))
                                       ((eq fonction-choisie 'distance-object-object)
                                        ($ ({application}:expert (component 'appli c)) 'distance-object-object))
                                       ((eq fonction-choisie 'show-extremums)
                                        ($ ({application}:expert (component 'appli c)) 'show-extremums))
                                       ((eq fonction-choisie 'show-extremums-niveau-2)
                                        ($ ({application}:expert (component 'appli c)) 'show-extremums-niveau-2))
                                       ((eq fonction-choisie 'show-extremums-niveau-3)
                                        ($ ({application}:expert (component 'appli c)) 'show-extremums-niveau-3))
                                       ((eq fonction-choisie 'show-extremums-niveau-4)
                                        ($ ({application}:expert (component 'appli c)) 'show-extremums-niveau-4))
                                       ((eq  fonction-choisie 'show-droite-liste-d-extremums)
                                        ($ ({application}:expert (component 'appli c)) 'show-droite-liste-d-extremums))
                                       ((eq  fonction-choisie 'droite-la-plus-proche)
                                        ($ ({application}:expert (component 'appli c)) 'droite-la-plus-proche))
                                       ((eq  fonction-choisie 'montre-droite)
                                        ($ ({application}:expert (component 'appli c)) 'montre-droite))

                                       
                                       )
                                 (full-redisplay (get-slot-value ({application}:expert (component 'appli c)) 'graphique))
                                 )))
                                 
      (set-action user2 '(lambda (c) 
                           (prog (courbe liste-droite expert1 appli1)
                                 (setq expert1  ({application}:expert (component 'appli c)))
                                 (setq courbe (car (get-slot-value expert1
                                                                   'graphique-liste-des-objects-affiches)))
                                 (setq liste-droite (mapcan 
                                                     '(lambda (x)
                                                        (cond ((and (eq (get-slot-value x 'courbe-origine)
                                                                        courbe)
                                                                    (or (and (eq (get-slot-facet-value
                                                                                  x 
                                                                                  'to-be-killed 
                                                                                  'determined)
                                                                                 t)
                                                                             (null (get-slot-value x 'to-be-killed)))
                                                                        (and (eq (get-slot-facet-value
                                                                                  x 
                                                                                  'to-be-killed 
                                                                                  'determined)
                                                                                 nil)
                                                                             (null
                                                                              ($ 
                                                                               nmm-suppression-de-droites-ininterressantes
                                                                               'determine x 
                                                                               'to-be-killed)))))
                                                               (list x))
                                                              (t nil)))
                                                     (get-slot-value 'droite-technique 'instances)))
                                 (setf (get-slot-value expert1
                                                       'graphique-liste-des-objects-affiches)
                                       (cons courbe liste-droite))
                                 (setf (get-slot-value expert1
                                                       'representation-graphique-transitoire) nil)
                                 (setq appli1 (display-courbe-a (cons courbe liste-droite)))
                                 (setf (get-slot-value expert1 'graphique) appli1)
                                 ({application}:expert appli1 expert1)
                                 (full-redisplay  (get-slot-value expert1 'graphique))
                                 )))
                                 
                                 
      (set-action user3 '(lambda (c) (setf (get-slot-value ({application}:expert (component 'appli c))
                                                               'representation-graphique-transitoire) t)))
                                          
      (set-action curveeditor '{curveeditor}:set-the-mark)
      (add-component appli 'comment comment)
      (add-component appli 'cursor cursor)
      (add-component appli 'appli appli)
      (send 'fit-to-contents appli)
      ({application}:expert appli *current-expert*)
      appli)))

(de :slide-cursor (appli)
    (send 'slide-to (component 'cursor appli)
          (fix (* (:scalex appli) (- (car (vref (:scale appli) (:index appli)))
                                     (:transx appli))))))

(de :get-scale-bbox (body rectangle)
    (let* ((xmin 32767)
           (ymin 32767)
           (xmax 0)
           (ymax 0)
           curx cury)
      (for (i 0 1 (sub1 (vlength body)))
           (setq curx (car (vref body i)) cury (cadr (vref body i)))
           (when (> curx xmax) (setq xmax curx))
           (when (< curx xmin) (setq xmin curx))
           (when (> cury ymax) (setq ymax cury))
           (when (< cury ymin) (setq ymin cury)))      
      ({rectangle}:x rectangle xmin)
      ({rectangle}:y rectangle ymin)
      ({rectangle}:w rectangle xmax)
      ({rectangle}:h rectangle ymax)
      body))

(de :add-curve (appli curve)
    (let* ((dx (:transx appli))
	   (dy (:transy appli))
	   (kx (:scalex appli))
	   (ky (:scaley appli))
	   (x1 (:x1 appli))
	   (x2 (:x2 appli))
	   (editor (:editor appli))
	   (image (cond ((is-a curve 'ligne-brisee)
			 (lignebrisee curve dx dy kx ky))
			((is-a curve 'courbe-2d)
			 (courbe2d curve dx dy kx ky))
			((is-a curve 'droite-technique)
			 (droitetechnique x1 x2 curve dx dy kx ky)))))
      (send 'add-image editor image)
      (send 'redisplay editor ())))

