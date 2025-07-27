
(de display-courbe-a (titre l)
    (prog (result bin x1 y1)
          (setq x1 20)
          (setq y1 170)
          (when *displayed-courbe-a* (remove-application *displayed-courbe-a*)) 
          (setq *mode-display-time* nil)
          (add-application (setq result (send 'translate (curveappli titre (- (div #wd 2) 20) (div #hd 3) l) x1 y1)))
          (setq *displayed-courbe-a* result)
          (return result)))

(de display-courbe-b (titre l)
    (prog (result bin x1 y1)
          (setq x1(div #wd 2) )
          (setq y1 170)
          (when *displayed-courbe-b* (remove-application *displayed-courbe-b*)) 
          (setq *mode-display-time* nil)         
          (add-application (setq result (send 'translate (curveappli titre (- (div #wd 2) 20) (div #hd 3) l) x1 y1)))
          (setq *displayed-courbe-b* result)
          (return result)))

(de display-courbe-c (titre l)
    (prog (result bin x1 y1)
          (setq x1 20)
          (setq y1 470)
          (when *displayed-courbe-c* (remove-application *displayed-courbe-c*)) 
          (setq *mode-display-time* nil)
          (add-application (setq result (send 'translate (curveappli titre (- (div #wd 2) 20) (div #hd 3) l) x1 y1)))
          (setq *displayed-courbe-c* result)
          (return result)))

(de display-courbe-d (titre l)
    (prog (result bin x1 y1)
          (setq x1 (div #wd 2))
          (setq y1 470)
          (when *displayed-courbe-d* (remove-application *displayed-courbe-d*)) 
          (setq *mode-display-time* nil)
          (add-application (setq result (send 'translate (curveappli titre (- (div #wd 2) 20) (div #hd 3) l) x1 y1)))
          (setq *displayed-courbe-d* result)
          (return result)))








(de add-displayed-courbe-2d (appli c1)
   
	({curveapplication}:add-curve appli c1))
   

(de recupere-abcisse-designee (appli)
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
    
