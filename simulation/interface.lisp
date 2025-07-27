

(de start-application  ()
    (setq ii (user-instanciate 'interface nil nil))
    (setf (get-slot-value ii  'nom) "quantification des risques")
    (setf (get-slot-value ii 'nombre-de-selectionneurs) 1)
    (setf (get-slot-value ii 'titre-du-selectionneur-1) "comptes")
    (setf (get-slot-value ii 'liste-de-choix-du-selectionneur-1) (directory-list "/usr/jupiter/olivier/expert/comptes"))
    (setf (get-slot-value ii 'fonction-d-execution-des-commandes) 
          '(lambda (inter) (calcul-de-risque 
                            (catenate (get-slot-value inter 'item-choisi-du-selectionneur-1)))))
                                                                     
    
    ($ ii 'activation)
    nil
    )