
(setq #:sys-package:colon '{presentateur})

(de :create ()
        (new '{presentateur}))

(de :initialize (presentateur w h min-x min-y max-x max-y liste-de-courbes)
        (:rectangle presentateur (omakeq {rectangle} x 0 y 0 w w h h))
        (send 'images presentateur 
                (newl liste-de-courbes (:rectangle presentateur)))
        (:liste-de-courbes presentateur liste-de-courbes)
        (:min-x presentateur min-x)
        (:min-y presentateur min-y)
        (:max-x presentateur max-x) 
        (:max-y presentateur max-y)
        (:calculer-echelle-des-courbes presentateur)
        presentateur)

(de presentateur (w h min-x min-y max-x max-y liste-de-courbes)
     (:initialize (:create) w h min-x min-y max-x max-y liste-de-courbes))

(de :width (presentateur)
        ({rectangle}:w (:rectangle presentateur)))

(de :height (presentateur)
        ({rectangle}:h (:rectangle presentateur)))

(de :calculer-echelle-des-courbes (presentateur)
   (let ((liste-de-courbes (:liste-de-courbes presentateur))
        )
      (:positionner-echelles liste-de-courbes 
                (/ (send 'width presentateur)
                   (sub (:max-x presentateur) (:min-x presentateur)))
                (/ (send 'height presentateur)
                   (sub (:max-y presentateur) (:min-y presentateur))) )
      (:positionner-origine liste-de-courbes
                (send 'width presentateur)
                (send 'height presentateur)
                (:min-x presentateur)
                (:min-y presentateur)
                (:max-x presentateur)
                (:max-y presentateur) )
      presentateur))

(de :calculer-echelle-une-courbe (presentateur courbe)
     (:positionner-une-echelle courbe 
                (/ (send 'width presentateur)
                   (sub (:max-x presentateur) (:min-x presentateur)))
                (/ (send 'height presentateur)
                   (sub (:max-y presentateur) (:min-y presentateur))) )
     (:positionner-une-origine courbe
                (send 'width presentateur)
                (send 'height presentateur)
                (:min-x presentateur)
                (:min-y presentateur)
                (:max-x presentateur)
                (:max-y presentateur) ))

(de :positionner-echelles (liste-de-courbes ech-x ech-y)
        (mapcar (lambda (courbe)
              (:positionner-une-echelle courbe ech-x ech-y))
              liste-de-courbes) )

(de :positionner-origine 
                    (liste-de-courbes w-total h-total min-x min-y max-x max-y)
        (mapcar (lambda (courbe)
                     (:positionner-une-origine 
                              courbe w-total h-total min-x min-y max-x max-y))
              liste-de-courbes) )

(de :positionner-une-echelle (courbe ech-x ech-y)
        (cond ((typep courbe '{objet-graph})
               (send 'ech-x courbe ech-x)
               (send 'ech-y courbe ech-y))
              (t ())))

(de :positionner-une-origine (courbe w-total h-total min-x min-y max-x max-y)
        (cond ((typep courbe '{objet-graph})
               (send 'h-total courbe h-total) 
               (send 'min-x courbe min-x)
               (send 'min-y courbe min-y)
               (send 'max-x courbe max-x)
               (send 'max-y courbe max-y))
              ((typep courbe '#:image)
               (send 'grow courbe w-total h-total))
              (t ())))
                        
        
(de :grow (presentateur w h)
        (unless (and (eq w (send 'width presentateur))
                     (eq h (send 'height presentateur)))
                (send-super '{presentateur} 'grow presentateur w h)
                (send 'grow (:rectangle presentateur) w h)
                (:calculer-echelle-des-courbes presentateur) ))


(de :inserer-courbe (presentateur courbe)
     (let ((liste-de-courbes (:liste-de-courbes presentateur))
          )
        (:calculer-echelle-une-courbe presentateur courbe)
        (send 'insert-image presentateur courbe 10000 )
        presentateur))

(de :retirer-courbe (presentateur courbe)
     (let ((liste-de-courbes (:liste-de-courbes presentateur))
          )
        (send 'remove-image presentateur courbe)
        (:liste-de-courbes presentateur
                (delq courbe liste-de-courbes)) 
        presentateur))

(de :modifier-courbe (presentateur old-courbe new-courbe)
     (:retirer-courbe presentateur old-courbe)
     (:inserer-courbe presentateur new-courbe) )

(de :is-one-of-my-courbes (presentateur courbe)
     (when (memq courbe (:liste-de-courbes presentateur))
           presentateur))
