(unless (boundp '*displayerd-courbe-2d*)
	(defvar *displayerd-courbe-2d*))

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
    
