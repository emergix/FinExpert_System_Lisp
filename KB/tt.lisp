
(de expert-canal-what-do-you-think-about (expert courbe )
    (prog  () ; (l c precision nombre-d-extremums-critique point-de-decision rayon-d-interet 
              ;  extremums-principaux-1 extremums-secondaires-1
              ;  extremums-principaux-2 extremums-secondaires-2
              ;  liste-de-groupe-de-droites-d-accummulation precision-d-accummlation)
	  
	  
	  (setq c ($ courbe 'expand 'convert-time))
         (when ff (setq max-de-ref (* 1.2 (cadr (courbe-2d-point-maximum c 0 (get-slot-value c 'pointeur-max)))))
                (setq courbe2 ($ c '* -1.))
                (setq c  ($ courbe2 '+ max-de-ref)))
	  ($ c 'expand 'extremum-local 'objects nil)
          (calcul-des-extremum-niveau-2 c)
          (calcul-des-extremum-niveau-3 c)
          (calcul-des-extremum-niveau-4 c)
          (setf (get-slot-value select-parameters 'courbe) c)
          (mapc '(lambda (x) (undetermine select-parameters x))
                '(precision nombre-d-extremums-critique point-de-decision rayon-d-interet
                            extremums-principaux-1 extremums-secondaires-1 
                            extremums-principaux-2 extremums-secondaires-2))
          (setq *csurj* ($ select-parameters 'determine 'select-parameters 'csurj))
          (setq precision ($ select-parameters 'determine select-parameters 'precision))
          (setf (get-slot-value nmm-suppression-de-droites-ininterressantes 'precision-de-croisement) precision)
          (setq nombre-d-extremums-critique ($ select-parameters 'determine select-parameters 'nombre-d-extremums-critique))
          (setq point-de-decision ($ select-parameters 'determine select-parameters 'point-de-decision))
          (setq rayon-d-interet ($ select-parameters 'determine select-parameters 'rayon-d-interet))
          
      ;    (setq extremums-principaux-1 ($ select-parameters 'determine select-parameters 'extremums-principaux-1))
      ;    (setq extremums-secondaires-1 ($ select-parameters 'determine select-parameters 'extremums-secondaires-1))
      ;    (setq extremums-principaux-2 ($ select-parameters 'determine select-parameters 'extremums-principaux-2))
      ;    (setq extremums-secondaires-2 ($ select-parameters 'determine select-parameters 'extremums-secondaires-2))
      ;    ($ c 'extract-droite-de-canal-haut 0 (get-slot-value c 'pointeur-max) 0.01 3)
      ;    ($ c 'expand-droite-technique-par-groupe  precision nombre-d-extremums-critique point-de-decision rayon-d-interet
      ;     extremums-principaux-1 extremums-secondaires-1 t)
      ;    ($ c 'expand-droite-technique-par-groupe-pour-extremums-consecutifs  precision nombre-d-extremums-critique
      ;     point-de-decision rayon-d-interet extremums-secondaires-1)
      ;    ($ c 'expand-droite-technique-par-groupe  precision nombre-d-extremums-critique point-de-decision rayon-d-interet
      ;     extremums-principaux-2 extremums-secondaires-2 t)
      ;    ($ c 'expand-droite-technique-par-groupe-pour-extremums-consecutifs  precision nombre-d-extremums-critique
      ;     point-de-decision rayon-d-interet extremums-secondaires-2)

          (courbe-2d-canavex c  0.001 50. point-de-decision rayon-d-interet )
          ($ c 'extract-contour precision precision  point-de-decision rayon-d-interet 0.6)

          (setq precision-d-accummulation ($ select-parameters 'determine select-parameters 'precision-d-accummulation))

          (setq liste-de-groupe-de-droites-d-accummulation ($ c 'droites-d-accummulation precision-d-accummulation))
          (mapc '(lambda (x) (purge-groupe-de-droites  c x))
                liste-de-groupe-de-droites-d-accummulation)
          (setq liste-de-groupe-de-droites-d-accummulation ($ c 'droites-d-accummulation (* precision-d-accummulation 0.66) ))
          (mapc '(lambda (x) (purge-groupe-de-droites  c x))
                liste-de-groupe-de-droites-d-accummulation)
          (setq liste-de-groupe-de-droites-d-accummulation ($ c 'droites-d-accummulation (* precision-d-accummulation 0.33)))
          (mapc '(lambda (x) (purge-groupe-de-droites  c x))
                liste-de-groupe-de-droites-d-accummulation)

	  ($ d-technique 'put-value 'distance-en-cours-max '10)
	  ($ d-technique 'sature)
          (setf (get-slot-value  'd-prevision 'conclusion) nil)
	  ($ d-prevision 'sature)
	  (setq r (create-instance-rapport '()))
	  (setf (get-slot-value r 'technique) 'canal)
	  (setf (get-slot-value r 'description-technique)
		"analyse des canaux et triangles presents dans la courbe")
	  (setf (get-slot-value r 'courbe) courbe)
	  (setf (get-slot-value r 'conclusion) (get-slot-value 'd-prevision 'conclusion)) 
	  (return r)))


