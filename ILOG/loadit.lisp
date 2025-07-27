polyline
mark
curveeditor
cursor
repeater
curveappli

(defvar :smallfont-name "6x10")

(unless (boundp ':smallfont)
        (defvar :smallfont))

(defvar :curve-user-action (lambda (b ev) ()))

(unless :smallfont
        (setq :smallfont (load-font :smallfont-name)))

;(de get-slot-value (obj slot)
;    (cond ((and (eq obj 'courbe-2d-6)
;                (eq slot 'body)) c2d)
;          ((and (eq obj 'droite-technique-6)
;                (eq slot 'pente)) (car dt))
;          ((and (eq obj 'droite-technique-6)
;                (eq slot 'ordonnee-zero)) (cdr dt))
;          ((and (eq obj 'ligne-brisee-12)
;                (eq slot 'liste-de-points)) lb)
;          ((and (eq obj 'ligne-brisee-6)
;                (eq slot 'liste-de-points)) lb1)))

;(de is-a (obj type)
;    (cond ((and (eq type 'courbe-2d)
;                (eq 'courbe-2d-6 obj)) t)
;          ((and (eq type 'droite-technique)
;                (eq 'droite-technique-6 obj)) t)
;          ((and (eq type 'ligne-brisee)
;                (eq 'ligne-brisee-12 obj)) t)
;          ((and (eq type 'ligne-brisee)	
;                (eq 'ligne-brisee-6 obj)) t))) 

;(de test ()
;    (setq c2d (makevector 150 0))
;    (for (i 0 1 49) (vset c2d i (list i (* 2 i))))
;    (for (i 50 1 99) (vset c2d i (list i (- 250 (* 3 i)))))
;    (for (i 100 1 149) (vset c2d i (list i (- i 150))))    
;    (setq dt (cons 1.5 3))    
;    (setq lb ())
;    (for (i 0 (random 10 20) 149)
;         (newr lb (list i (random -50 100))))
;    (newr lb (list 149 0))    
;    (setq lb1 ())
;    (for (i 0 (random 10 20) 149)
;         (newr lb1 (list i (random -50 100))))
;    (newr lb1 (list 149 0))    
;    (display-courbe-2d
;     3 3
;     (list 'courbe-2d-6 'droite-technique-6 'ligne-brisee-12)))

(defvar *displayerd-courbe-2d*)

(de display-courbe-2d (w h l)
    (newl *displayerd-courbe-2d*
          (add-application (curveappli (div #wd w) (div #hd h) l))))

(de add-displayed-courbe-2d (appli c1)
    (if (memq appli *displayerd-courbe-2d*)
	({curveapplication}:add-curve appli c1)
      (print "not found")))

(de recupere-abscisse-designee (appli)
    (car (vref ({curveapplication}:scale appli)
               ({curveapplication}:index appli))))

(de impose-abscisse-designee (appli value)
    (let ((i ({curveapplication}:index appli)))
      (when (or (ge i 0) 
                (le i (sub1 (vlength ({curveapplication}:scale appli)))))
            ({curveapplication}:index appli value)
            ({curveapplication}:slide-cursor appli))))

(de recupere-liste-points (appli)
    (mapcar (lambda (i)
              (let ((x (add (div #wc 2) (send 'x i)))
                    (y (add (div #hc 2) (send 'y i))))
                (cons (fix (+ (/ x ({curveapplication}:scalex appli))
                              ({curveapplication}:transx appli)))
                      (fix (+ (/ y ({curveapplication}:scaley appli))
                              ({curveapplication}:transy appli))))))
            ({curveeditor}:list ({curveapplication}:editor appli))))

(de efface-liste-points (appli)
    (let ((editor ({curveapplication}:editor appli)))
      (mapc (lambda (i) ({curveeditor}:remove-the-mark editor i))
              ({curveeditor}:list editor))
      ({curveeditor}:list editor ())))
    
