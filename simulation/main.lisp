;******************************************************************************************
;                           PROGRAMME PRINCIPAL
;******************************************************************************************

(libloadfile 'pretty t)
(setq *date-des-calculs* 
      ; (date-d-aujourd-hui)
      '(89 06 15 0 0 0)
      )

(setq *liste-d-actions-de-base* '(ai ca  cl sq or ac aq en ly lg lr cs bn ri mt ff mc cw ml ho cb 
                                     ex ug cu mi du ef pn lh ar sgo pm cap co cge aj rs cr gle fs
                                     ah lps pfa def jj))

(setq *liste-de-convertibles-de-base* '(cv-lg-6.125-97 cv-cge-5.5-96))


(setq *chargement-des-historiques* nil)

(setq *conjoncture-principale* (initialisation-de-la-conjoncture))

(de calcul-de-risque-1 (compte-directory)
    (prog (savechan chan input compte position-list position instrument actions)
          (setq compte (user-instanciate 'compte nil nil))
          (setf (get-slot-value compte 'nom) compte-directory)
          
;                                    CONSTRUCTION DE LA REPRESENTATION DYNAMIQUE DU PORTEFEUILLE
          (setq savechan (inchan))
          (setq chan (openi  (catenate "/usr/jupiter/olivier/expert/comptes/"
                                       (string compte-directory) "/portefeuille-final.lisp")))
          (inchan chan)
          (untilexit eof 
                     (setq input (read)) (print input)
                     (setq bi-instrument (ticker-expect-instrument-financier (string (cadr input))))
                     (print bi-instrument)
                     (setq instrument (concat (car bi-instrument)))
                     (setf (get-slot-value instrument 'dernier-cours) (caddr input))
                     (setq position (prog ((pl position-list) qte sens)
                                          (when (eq (car input) 0) (return nil))
                                          loop
                                          (when (null pl) (return nil))
                                          (when (and (eq (get-slot-value (car pl) 'type-d-instrument) instrument)
                                                     (eq (get-slot-value (car pl) 'compte) compte))
                                                (setq qte (get-slot-value (car pl) 'nombre-d-instruments))
                                                (setq qte (+ qte (car input)))
                                                (cond ((>= qte 0) (setq sens 'achat))
                                                      (t (setq sens 'vente)))
                                                (setf (get-slot-value (car pl) 'nombre-d-instruments) qte)
                                                (setf (get-slot-value (car pl) 'sens) sens)
                                                (setf (get-slot-value (car pl) 'date-de-negociation) nil)
                                                (setf (get-slot-value (car pl) 'prix-negocie) nil)
                                                (return (car pl)))
                                          (setq pl (cdr pl))
                                          (go loop)))
                     (when (and (not (equal (car input) 0)) 
                                (null position))
                           (setq position (user-instanciate 'position nil nil))
                           (setf (get-slot-value position 'type-d-instrument) instrument)
                           (setf (get-slot-value position 'sens)   (cond ((>= (car input) 0)  'achat)
                                                                         (t  'vente)))
                           (setf (get-slot-value position 'nombre-d-instruments) (car input))
                           )
                     (when position 
                           (setq position-list (cons position position-list))
                           (setf (get-slot-value position 'compte) compte))
                     (print position)
                     )
          (inchan savechan)
          (close)
          (setf (get-slot-value compte 'liste-de-positions) position-list)
          
;                                  CALCUL DU RISQUE PAR SUPPORT ACTION
         
          ))
        
(de tt() (calcul-de-risque 'egnell-98069))



