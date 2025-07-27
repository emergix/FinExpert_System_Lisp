(setq #:sys-package:colon '{point})

(de :get-x (point)
        (car point))

(de :get-y (point)
        (cdr point))

(de :set-x (point x)
        (rplaca point x))
        
(de :set-y (point y)
        (rplacd point y))

(de :min-x (p1 p2)
        (if (lt (:get-x p1) (:get-x p2))
            p1 p2))

(de :min-y (p1 p2)
        (if (lt (:get-y p1) (:get-y p2))
            p1 p2))

(de :max-x (p1 p2)
        (if (gt (:get-x p1) (:get-x p2))
             p1 p2))

(de :max-y (p1 p2)
        (if (gt (:get-y p1) (:get-y p2))
            p1 p2))



;------------------------------------------------------------------------

; 
; Partie a utiliser avec le code definitif
; pour une gestion de vecteurs...

(de get-nth (n liste-de-points)
    (vref liste-de-points n))

(de get-length (liste-de-points)
    (vlength liste-de-points))

;
; calcul du MIN ou du MAX sur X ou Y
; en partant de START et en finissant en END compris. 

(de coeur (liste-de-points start end function-xy function-minmax)
        (cond ((eq start end)
               (funcall function-xy (get-nth start liste-de-points)))
              (t
               (funcall function-minmax
                    (coeur liste-de-points 
                        (add1 start) end function-xy function-minmax)
                    (funcall function-xy (get-nth start liste-de-points))))
              ))

(de min-x (liste-de-points start end)
        (coeur liste-de-points start end '{point}:get-x 'min))

(de min-y (liste-de-points start end)
        (coeur liste-de-points start end '{point}:get-y 'min))

(de max-x (liste-de-points start end)
        (coeur liste-de-points start end '{point}:get-x 'max))

(de max-y (liste-de-points start end)
        (coeur liste-de-points start end '{point}:get-y 'max))

;
; renvoie le point dont le x ou le y est maximum ou minimum

(de coeur-point (liste-de-points start end fun-maxminxy)
        (cond ((eq start end)
               (get-nth start liste-de-points))
              (t
               (funcall fun-maxminxy 
                        (get-nth start liste-de-points)
                        (coeur-point liste-de-points 
                                (add1 start) end fun-maxminxy))) ))
    
(de get-min-point-x (liste-de-points start end)
    (coeur-point liste-de-points 
                start end  '{point}:min-x))

(de get-min-point-y (liste-de-points start end)
    (coeur-point liste-de-points 
                start end  '{point}:min-y))

(de get-max-point-x (liste-de-points start end)
    (coeur-point liste-de-points 
                start end  '{point}:max-x))

(de get-max-point-y (liste-de-points start end)
    (coeur-point liste-de-points 
                start end  '{point}:max-y))



