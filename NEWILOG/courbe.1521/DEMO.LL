
(de di1 ()
        (let* ((l-haut (vector '(1 . 100) '(2 . 50) '(3 . 75) '(4 . 80)
                         '(5 . 50) '(6 . 60) '(7 . 70) '(8 . 40)))
               (l-bas (vector '(1 . 90) '(2 . 40) '(3 . 60) '(4 . 40)
                         '(5 . 40) '(6 . 50) '(7 . 65) '(8 . 35)))
               (l-ouv (vector '(1 . 100) '(2 . 50) '(3 . 75) '(4 . 80)
                         '(5 . 50) '(6 . 60) '(7 . 70) '(8 . 40)))
               (l-ferm (vector '(1 . 90) '(2 . 40) '(3 . 70) '(4 . 40)
                         '(5 . 40) '(6 . 50) '(7 . 65) '(8 . 35)))
               (l-vol (vector '(1 . 40) '(2 . 10) '(3 . 20) '(4 . 30)
                        '(5 . 20) '(6 . 10) '(7 . 20) '(8 . 30)))
               (valeur (valeur l-haut l-bas l-ouv l-ferm l-vol))
               (c1 (courbe (do-vector 1 8
                                (lambda (x)
                                        (fix (random 0 100))))))
               (segment (segment '(6 . 60) '(7 . 70)))
               (courbe (courbe (do-vector 1 8 
                                   (lambda (x) 
                                        (abs (fix (* 100 (sin x)))))) ))
               (courbe2 (courbe (do-vector 1 8 
                                   (lambda (x) 
                                        (abs (fix (* 100 (sin x)))))) ))
               (indic (indicateur-etendu c1 2 4 "Xoucou" 1 t))
               (t-s-f (texte-sur-fleche 5 30 0 c1 20 "Coucou" 1 t 'queue))
               (s (simple-texte 4 1 courbe "ce point la !" 'queue))
              )
        ({bars-and-charts}:bars-and-charts 
         0 0 400 300
         (interface) 1
         "essai" "du 14/02/89"
         "principal" (list c1 t-s-f indic valeur)
         "second2" (list courbe) 
         "second2" (list courbe))
        ))

(de di2 ()
    (let ((courbe (courbe (do-vector 26000 26200
                                     (lambda (x) 
                                       (random 1 190)))))
          )
      ({bars-and-charts}:bars-and-charts
       0 0 400 300 
       (interface) 1
       "essai" "du 14/02/89"
       "principal" (list courbe)
       "second2" () 
       "second2" ())
      ))

(de do-vector (first-x last-x function)
    (when (le first-x last-x)
          (apply 'vector (do-liste first-x last-x function)) ))

(de do-liste (first-x last-x function)
    (when (le first-x last-x)
          (cons (cons first-x (funcall function first-x))
                (do-liste (add1 first-x) last-x function)) ))


(when (confirm "On lance la demo ?")
      (setq a (di2) b ())
      (progn (add-application a) ()) )






