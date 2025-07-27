(user-instanciate 'metaclass 'action  nil)
(add-attribute-user 'action 'dernier-cours 'action-remplit-donnees 'instance)
(add-attribute-user 'action 'date-du-dernier-cours 'action-remplit-donnees 'instance)
(add-attribute-user 'action 'dernier-dividende 'action-remplit-donnees 'instance)
(add-attribute-user 'action 'date-du-dernier-dividende 'action-remplit-donnees 'instance)
(add-attribute-user 'action 'quotite 'action-remplit-donnees 'instance)
(add-attribute-user 'action 'nom 'action-remplit-donnees 'instance)
(add-attribute-user 'action 'ponderation-dans-le-cac40 'action-remplit-donnees 'instance)
(add-attribute-user 'action 'historique-quotidien 'action-remplit-donnees 'instance)
;(add-attribute-user 'action 'historique-hebdomadaire 'action-remplit-donnees 'instance)
(add-slot-user 'action 'ticker 'instance)
(add-slot-user 'action 'marche 'instance)
(add-slot-user 'action 'premier-cours 'instance)
(add-slot-user 'action 'dernier-cours 'instance)
(add-slot-user 'action 'plus-haut-cours 'instance)
(add-slot-user 'action 'plus-bas-cours 'instance)
(add-slot-user 'action 'volume 'instance)
(add-slot-user 'action 'date-d-operation 'instance)

(user-instanciate 'metaclass 'panier  nil)
(add-attribute-user 'panier 'composition 'panier-composition 'instance)
(add-attribute-user 'panier 'liquidites 'panier-liquidites 'instance)
(add-slot-user 'panier 'liste-des-actions-incluses 'instance)
(add-slot-user 'panier 'poids-relatifs-ideals 'instance)
(add-slot-user 'panier 'date-courante 'instance)
(add-slot-user 'panier 'somme-de-reference 'instance)
(add-slot-user 'panier 'ri-ou-rm 'instance)

(add-method 'action 'action-set-date 'set-date 'superseed)
(add-method 'action 'action-initialize 'initialize 'superseed)
(add-method 'panier 'panier-set-date 'set-date 'superseed)
(add-method 'panier 'panier-ordres-d-achat-equivalents 'ordres-d-achat-equivalents 'superseed)
(add-method 'panier 'panier-s-poids-relatifs-ideals 's-poids-relatifs-ideals 'superseed)
(add-method 'panier 'panier-initialize 'initialize 'superseed)

(de action-initialize (action)
    nil)

(de panier-initalize (panier)
    (undetermine panier 'composition)
    (undetermine panier 'liquidites)
    )

(de panier-s-poids-relatifs-ideals (panier)
    (mapcar '(lambda (x) (list (get-slot-value (car x) 'nom) (cadr x)))
            (get-slot-value panier 'poids-relatifs-ideals)))

(user-instanciate 'metaclass 'simulation nil)
(add-slot-user 'simulation 'date-de-debut 'instance)          ;a fixer
(add-slot-user 'simulation 'date-de-fin 'instance)            ;a fixer
(add-slot-user 'simulation 'action-de-reference 'instance)    ;a fixer
(add-slot-user 'simulation 'liste-des-parametres 'instance)   ;a fixer
(add-slot-user 'simulation 'liste-des-acteurs 'instance)      ;a fixer
(add-slot-user 'simulation 'liste-des-marches 'instance)      ;a fixer
(add-slot-user 'simulation 'liste-des-comptes 'instance)      ;a fixer
(add-attribute-user 'simulation 'liste-des-dates-de-bourse 'simulation-liste-des-dates-de-bourse 'instance)
(add-slot-user 'simulation 'date-courante 'instance)
(add-slot-user 'simulation 'moyen-de-financement 'instance)   ;a fixer
(add-slot-user 'simulation 'forward-chainer 'instance)        ;a fixer
(add-slot-user 'simulation 'numero-du-step 'instance)
(add-slot-user 'simulation 'delta-date 'instance)
(add-slot-user 'simulation 'fonction-de-trace 'instance)      ;a fixer la fonction  est d argument (simulation i date delta-date)
(add-slot-user 'simulation 'step-by-step 'instance)           ;vaut nil ou t

(setq *simulation-courante* nil)
(add-method 'simulation 'simulation-start 'start 'superseed)
(add-method 'simulation 'simulation-initialize 'initialize 'superseed)

(de simulation-initialize (simulation)
    (mapc '(lambda (x) ($ x 'initialize))
          (append (get-slot-value simulation 'liste-des-parametres)
                  (get-slot-value simulation 'liste-des-acteurs)
                  (get-slot-value simulation 'liste-des-marches)
                  (get-slot-value simulation 'liste-des-comptes))))
    

(user-instanciate 'metaclass 'parametre nil)
(add-slot-user 'parametre 'nom 'instance)                    ;a fixer optionnel
(add-slot-user 'parametre 'fonction-de-calcul 'instance)     ;a fixer
(add-slot-user 'parametre 'valeur-initiale 'instance)        ;a fixer optionnel
(add-slot-user 'parametre 'courbe-resultat 'instance)
(add-slot-user 'parametre 'date-courante 'instance)
(add-slot-user 'parametre 'simulation 'instance)             ;a fixer
(add-slot-user 'parametre 'valeur-courante 'instance)
(add-slot-user 'parametre 'ytype 'instance)

(add-method 'parametre 'parametre-compute-value 'compute-value 'superseed)
(add-method 'parametre 'parametre-initialize 'initialize 'superseed)
(add-method 'parametre 'parametre-set-date 'set-date 'superseed)

(de parametre-initialize (parametre)
    (setf (get-slot-value parametre 'valeur-courante) nil))

(de parametre-get-value-n-1 (parametre)
    (prog ((historique (get-slot-value (get-slot-value parametre 'courbe-resultat) 'body))
           (simulation (get-slot-value parametre 'simulation))
           step ran)
          (setq step (get-slot-value simulation 'numero-du-step))
          (cond ((equal  step 0) (return nil))
                (t (return (cadr (vref historique (1- step))))))))
    

(de parametre-set-date (parametre date)
    (setf (get-slot-value parametre 'date-courante) date))

(de parametre-compute-value (parametre i) 
    (setf (get-slot-value parametre 'valeur-courante)
          (apply (get-slot-value parametre 'fonction-de-calcul) (list parametre)))
    (setf (vref (get-slot-value (get-slot-value parametre 'courbe-resultat) 'body) i)
          (list (get-slot-value parametre 'date-courante)
                (get-slot-value parametre 'valeur-courante))))
    
 

(de simulation-liste-des-dates-de-bourse (simulation slot)
    (prog ((date-de-debut (get-slot-value simulation 'date-de-debut))
           (date-de-fin (get-slot-value simulation 'date-de-fin))
           (courbe (get-slot-value 
                    (get-slot-value 
                     (get-slot-value simulation 'action-de-reference) 
                     'historique-quotidien ) 
                    'premier-cours))
           h l (v 0) ll )
          (setq h (get-slot-value courbe 'body))
	  (setq l (get-slot-value courbe 'pointeur-max))
	  loop
	  (when (> v l) (return ll))
	  (when (and (time->= (car (vref h (- l v))) date-de-debut)
                     (time-<= (car (vref h (- l v))) date-de-fin))
                (setq ll (cons (car (vref h (- l v))) ll)))
	  (setq v (1+ v))
	  (go loop)))

(de simulation-start (simulation)
    (prog ((liste-des-dates-de-bourse (user-get-value simulation 'liste-des-dates-de-bourse))
           date-courrante assoc-liste-des-parametres liste-de-dates  date-courante (i -1)
           (forward-chainer (get-slot-value simulation 'forward-chainer))simulation-save delta-date)
          (setq simulation-save *simulation-courante*)
          (setq *simulation-courante* simulation)

          (mapc '(lambda (x)
                   (let (cc)
                     (setq cc (user-instanciate 'courbe-2d nil nil))
                     (setf (get-slot-value cc 'body)   
                           (makevector (length liste-des-dates-de-bourse)  nil))
                     (setf (get-slot-value cc 'pointeur-max) 
                           (1-  (length liste-des-dates-de-bourse)))
                     (setf (get-slot-value cc 'xtype) 'date)
                     (setf (get-slot-value cc 'ytype)
                           (get-slot-value x 'ytype) )
                     (setf (get-slot-value cc 'transformation) 
                           (list 'parametre x))
                              
                     (setf (get-slot-value x 'courbe-resultat) cc)
                     ))
                (get-slot-value simulation 'liste-des-parametres))
          (setq liste-de-dates liste-des-dates-de-bourse)
          loop
          (when (null liste-de-dates)(go fin))
          (setq date-courrante (car liste-de-dates))
          (setq liste-de-dates (cdr liste-de-dates))
          (setq i (1+ i))
          (setf (get-slot-value simulation 'numero-du-step) i)
          (when (get-slot-value simulation 'date-courante)
                (setq delta-date (- (convert-time date-courrante )
                                    (convert-time (get-slot-value simulation 'date-courante)))))
          (setf (get-slot-value simulation 'delta-date) delta-date)
          (setf (get-slot-value simulation 'date-courante) date-courrante)
          (print " cas " i)
          (mapc '(lambda (x) ($ x 'set-date date-courrante))
                
                (get-slot-value simulation 'liste-des-acteurs))
          (mapc '(lambda (x) ($ x 'set-date date-courrante)) 
                
                (get-slot-value simulation 'liste-des-parametres))
          (mapc '(lambda (x) ($ x 'set-date date-courrante)) 
                
                (get-slot-value simulation 'liste-des-marches))
          (mapc '(lambda (x) ($ x 'set-date date-courrante)) 
                
                (get-slot-value simulation 'liste-des-comptes))
          ($ (get-slot-value simulation 'moyen-de-financement) 'set-date date-courrante)
          (when forward-chainer
               
                
               (cond ((consp forward-chainer) 
                      (mapc '(lambda (fc)
                               (setf (get-slot-value fc 'simulation) simulation)
                               ($ fc 'go))
                            forward-chainer))
                     (t (when (get-slot forward-chainer 'simulation)
                               (setf (get-slot-value forward-chainer 'simulation) simulation)
                                ($ forward-chainer 'go)))
                     ))
          (when delta-date 
                (mapc '(lambda (x) ($ x 'actualisation 
                                      (+ 1. (* delta-date (/ (get-slot-value 
                                                              (get-slot-value simulation 'moyen-de-financement)
                                                              'taux-courant) 
                                                             36500.)))))
                      (get-slot-value simulation 'liste-des-marches)))
          (mapc '(lambda (x) ($ x 'compute-value i))
                (get-slot-value simulation 'liste-des-parametres))
          (mapc '(lambda (x)
                   (let ((liquidites (get-slot-value x 'liquidites))
                         (emprunts (get-slot-value x 'emprunts)))
                   
                     (when (and delta-date
                                (> emprunts 0.))
                           (setq emprunts (* emprunts (+ 1. (* delta-date (/ (get-slot-value 
                                                                              (get-slot-value simulation 'moyen-de-financement)
                                                                              'taux-courant-d-emprunt) 
                                                                             36500.))))))
                     (when (and delta-date
                                (> liquidites 0.))
                           (setq liquidites (* liquidites (+ 1. (* delta-date (/ (get-slot-value 
                                                                                  (get-slot-value simulation 'moyen-de-financement)
                                                                                  'taux-courant-de-placement) 
                                                                                 36500.))))))
                     (when (< liquidites 0.)
                           (setq emprunts (+  emprunts (- liquidites)))
                           (setq liquidites 0.))
                     (cond ((and (> liquidites 0.)
                                 (> emprunts 0.)
                                 (< emprunts liquidites))
                            (setq liquidites (- liquidites emprunts))
                            (setq emprunts 0.)
                            )
                           ((and (> liquidites 0.)
                                 (> emprunts 0.)
                                 (>= emprunts liquidites))
                            (setq emprunts (- emprunts liquidites))
                            (setq liquidites 0.)
                            ))
                     
                     (setf (get-slot-value x 'liquidites) liquidites)
                     (setf (get-slot-value x 'emprunts) emprunts)))
                (get-slot-value simulation 'liste-des-comptes))
          (mapc '(lambda (x)
                   (user-get-value x 'investissements-net-courant )
                   (user-get-value x 'investissements-net-cummule-courant) 
                   (user-get-value x 'volume-des-transactions-courant)
              )
                (get-slot-value simulation 'liste-des-marches))
          (funcall (get-slot-value simulation 'fonction-de-trace) simulation i date-courante delta-date)
          (go loop)
          fin
          
                
          (setq *simulation-courante* simulation-save)
          ))








(de panier-ordres-d-achat-equivalents (panier montant)
    (prog (jour-d-aujourdhui qte-ri qte-rm qte investi-ri investi-rm investi
                              ponderations cours quotites dividendes montants-essayes taux-monetaire jour-d-aujourdhui
                              (poids-relatifs-ideals (user-get-value panier 'poids-relatifs-ideals))
                              (liste-des-actions-incluses (user-get-value panier 'liste-des-actions-incluses))
                              (jour-d-aujourdhui (user-get-value panier 'date-courante))
                              (ri-ou-rm (user-get-value panier 'ri-ou-rm))
                              somme-des-ponderations)
          (setq somme-des-ponderations (apply '+ (mapcar 'cadr poids-relatifs-ideals)))
          (setq ponderations (mapcar '(lambda (x) (list (car x) (*  100. 
                                                                    (/ (cadr x) 
                                                                       somme-des-ponderations))))
                                     poids-relatifs-ideals))
          (setq cours (mapcar '(lambda (x) (list x (user-get-value x 'premier-cours))) liste-des-actions-incluses))
          (setq quotites (mapcar '(lambda (x) (list x (user-get-value x 'quotite))) liste-des-actions-incluses))
          (setq dividendes (mapcar '(lambda (x) (list x (user-get-value x 'dernier-dividende))) liste-des-actions-incluses))
          
          (setq qte-ri (mapcar '(lambda (x) (list (car x) (truncate* (/ (* (/ montant 100.) (cadr x)) 
                                                                       (cadr (assoc (car x) cours))))))
                               ponderations))
          (setq qte-rm (mapcar '(lambda (x) (list (car x) (* (truncate* (/ (cadr x) 
                                                                          (cadr (assoc (car x) quotites))))
                                                             
                                                             (cadr (assoc (car x) quotites)))))
                               qte-ri))
          (setq investi-ri (apply '+ (mapcar '(lambda (x) (* (cadr x) 
                                                           (cadr (assoc (car x) cours))))
                                           qte-ri)))
          (setq investi-rm (apply '+ (mapcar '(lambda (x) (* (cadr x) 
                                                           (cadr (assoc (car x) cours))))
                                           qte-rm)))
          (cond ((eq ri-ou-rm 'ri)
                 (setq qte qte-ri)
                 (setq investi investi-ri))
                (t (setq qte qte-rm)
                   (setq investi investi-rm)))
          (return (mapcar '(lambda (x) (list 'achat (cadr x) (car x)  (get-slot-value (car x) 'premier-cours)))
                          qte))))
                             




(de panier-ordres-equivalents (sens marche panier montant heure)
    (prog (jour-d-aujourdhui qte-ri qte-rm qte investi-ri investi-rm investi
                             ponderations cours quotites dividendes montants-essayes taux-monetaire jour-d-aujourdhui
                             (poids-relatifs-ideals (user-get-value panier 'poids-relatifs-ideals))
                             (liste-des-actions-incluses (user-get-value panier 'liste-des-actions-incluses))
                             (jour-d-aujourdhui (user-get-value panier 'date-courante))
                             (ri-ou-rm (user-get-value panier 'ri-ou-rm))
                             (modele (get-slot-value marche 'modele-de-marche))
                             somme-des-ponderations)
          (setq somme-des-ponderations (apply '+ (mapcar 'cadr poids-relatifs-ideals)))
          (setq ponderations (mapcar '(lambda (x) (list (car x) (*  100. 
                                                                    (/ (cadr x) 
                                                                       somme-des-ponderations))))
                                     poids-relatifs-ideals))
          (setq dividendes (mapcar '(lambda (x) (list x (user-get-value x 'dernier-dividende))) liste-des-actions-incluses))
          (setq cours (mapcar '(lambda (x) (list x (user-get-value x 'premier-cours))) liste-des-actions-incluses))
          (setq quotites (mapcar '(lambda (x) (list x (user-get-value x 'quotite))) liste-des-actions-incluses))          
          (setq qte-ri (mapcar '(lambda (x) (list (car x) (truncate* (/ (* (/ montant 100.) (cadr x)) 
                                                                       (cadr (assoc (car x) cours))))))
                               ponderations))
          (setq qte-rm (mapcar '(lambda (x) (list (car x) (* (truncate* (/ (cadr x) 
                                                                          (cadr (assoc (car x) quotites))))
                                                             
                                                             (cadr (assoc (car x) quotites)))))
                               qte-ri))
          (setq cours (mapcar '(lambda (x) (list x (funcall modele sens (cadr (assoc x 
                                                                                     (cond ((eq ri-ou-rm 'ri) qte-ri)
                                                                                           (t qte-rm))))
                                                            x heure)))
                              liste-des-actions-incluses))
          (setq qte-ri (mapcar '(lambda (x) (list (car x) (truncate* (/ (* (/ montant 100.) (cadr x)) 
                                                                       (cadr (assoc (car x) cours))))))
                               ponderations))
          (setq qte-rm (mapcar '(lambda (x) (list (car x) (* (truncate* (/ (cadr x) 
                                                                          (cadr (assoc (car x) quotites))))
                                                             
                                                             (cadr (assoc (car x) quotites)))))
                               qte-ri))
          (setq investi-ri (apply '+ (mapcar '(lambda (x) (* (cadr x) 
                                                             (cadr (assoc (car x) cours))))
                                             qte-ri)))
          (setq investi-rm (apply '+ (mapcar '(lambda (x) (* (cadr x) 
                                                             (cadr (assoc (car x) cours))))
                                             qte-rm)))
          (cond ((eq ri-ou-rm 'ri)
                 (setq qte qte-ri)
                 (setq investi investi-ri))
                (t (setq qte qte-rm)
                   (setq investi investi-rm)))
          (return (mapcar '(lambda (x) (list sens (cadr x) (car x)  (cadr (assoc (car x) cours))))
                          qte))))





          
(de action-remplit-donnees (object slot)
    (prog ((ticker (get-slot-value object 'ticker))
           savechan-1 chan name input)
          (setq name (catenate "/usr/jupiter/olivier/expert/donnees/" 
                               (string ticker)
                               ".dat"))
          
          (setq savechan-1 (inchan))
          (setq chan (openi name))
          (inchan chan)
          (untilexit eof 
                     (setq input (read))
                     (when (and (consp input)
                                (get-slot object (car input))
                                )
                           (setf (get-slot-value object (car input)) (cadr input))
                           (setf (get-slot-facet-value object (car input) 'determined) t)
                           ))
          (inchan savechan-1)
          (setq valeur-q (fetch-courbe-quotidien-from-current-directory (catenate (string ticker)
                                                                                  "-q")
                                                                        ""))
          (setf (get-slot-value object 'historique-quotidien) valeur-q)
                                        ;(setq valeur-h (fetch-courbe-hebdomadaire-from-current-directory (catenate (string ticker)
                                        ;                                                              "-h")
                                        ;                                                   ""))
                                        ;(setf (get-slot-value object 'historique-hebdomadaire) valeur-h)
          
          
          (return (get-slot-value object slot))))




(de action-set-date (action date)
    (prog ((histo-q (get-slot-value action 'historique-quotidien))
           c-ouvert c-fermet c-plus-haut c-plus-bas c-volume)
          (setq c-ouvert (get-slot-value histo-q 'premier-cours))
          (setq c-fermet (get-slot-value histo-q 'dernier-cours))
          (setq c-plus-haut (get-slot-value histo-q 'plus-haut))
          (setq c-plus-bas (get-slot-value histo-q 'plus-bas))
          (setq c-volume (get-slot-value histo-q 'volume))
          (setf (get-slot-value action 'date-d-operation) date)
          (setf (get-slot-value action 'premier-cours)
                (courbe-2d-interpolation c-ouvert date))
          (setf (get-slot-value action 'dernier-cours)
                (courbe-2d-interpolation c-fermet date))
          (setf (get-slot-value action 'plus-haut-cours)
                (courbe-2d-interpolation c-plus-haut date))
          (setf (get-slot-value action 'plus-bas-cours)
                (courbe-2d-interpolation c-plus-bas date))
          (setf (get-slot-value action 'volume)
                (courbe-2d-interpolation c-volume date))
          ))

(de panier-set-date (panier date)
    (mapc '(lambda (a) ($ a 'set-date date))
          (get-slot-value panier 'liste-des-actions-incluses)))


;*********************************************************************************************
;                             COMPTE
;******************************************************************************************





(user-instanciate 'metaclass 'compte nil)
(add-slot-user 'compte 'nom 'instance)
(add-slot-user 'compte 'date-courante 'instance)
(add-slot-user 'compte 'liquidites 'instance)
(add-slot-user 'compte 'portefeuille 'instance)
(add-slot-user 'compte 'liste-de-positions 'instance)
(add-slot-user 'compte 'instance-liquidation 'instance)
(add-slot-user 'compte 'instance-reglement-espece 'instance)
(add-slot-user 'compte 'emprunts 'instance)
(add-slot-user 'compte 'versement-courant 'instance)

(add-post-instanciation-demon compte 'initialisation-du-compte 'merge-before)
(de initialisation-du-compte (compte)
    (setf (get-slot-value compte 'liquidites) 0.)
    (setf (get-slot-value compte 'instance-reglement-espece) 0.)
    (setf (get-slot-value compte 'emprunts) 0.)
    )

(add-method 'compte 'compte-set-date 'set-date 'superseed) 
(add-method 'compte 'compte-premier-jour-de-liquidation 'premier-jour-de-liquidation 'superseed)
(add-method 'compte 'compte-dernier-jour-de-liquidation 'dernier-jour-de-liquidation 'superseed)
(add-method 'compte 'compte-depouillement 'depouillement 'superseed)
(add-method 'compte 'compte-valorisation 'valorisation 'superseed)
(add-method 'compte 'compte-valorisation-a-l-ouverture 'valorisation-a-l-ouverture 'superseed)
(add-method 'compte 'compte-s-portefeuille 's-portefeuille 'superseed)
(add-method 'compte 'compte-portefeuille-total 'portefeuille-total 'superseed)
(add-method 'compte 'compte-suspens-a-payer 'suspens-a-payer 'superseed)
(add-method 'compte 'compte-initialize 'initialize 'superseed)

(de compte-initialize (compte)
    (setf (get-slot-value compte 'liquidites) 0.)
    (setf (get-slot-value compte 'instance-reglement-espece) 0.)
    (setf (get-slot-value compte 'emprunts) 0.)
    (setf (get-slot-value compte 'portefeuille) nil)
    (setf (get-slot-value compte 'instance-liquidation) nil)
    (setf (get-slot-value compte 'versement-courant) 0.)
    )

(de compte-s-portefeuille (compte)
    (mapcar '(lambda (x) (list (get-slot-value (car x) 'nom) (cadr x)))
            (get-slot-value compte 'portefeuille)))

(de compte-valorisation (compte)
    (let ((liquidites (get-slot-value compte 'liquidites))
          (portefeuille (get-slot-value compte 'portefeuille))
          (instance-reglement-espece (get-slot-value compte 'instance-reglement-espece))
          (emprunts (get-slot-value compte 'emprunts))
          (instance-liquidation (get-slot-value compte 'instance-liquidation))
          (evaluation-du-portefeuille 0.) (evaluation-des-ordres-en-instance 0.))

      (mapc '(lambda (x1) 
               (setq evaluation-du-portefeuille (+ evaluation-du-portefeuille
                                                   (* (get-slot-value (car x1) 'dernier-cours)
                                                      (cadr x1)))))
            portefeuille)

      (mapc '(lambda (x1) 
               (setq evaluation-des-ordres-en-instance (+ evaluation-des-ordres-en-instance
                                                          (* (cond ((eq (car x1) 'achat) 1.)
                                                                   (t -1.))
                                                             (- (get-slot-value (caddr x1) 'dernier-cours) 
                                                                (cadddr x1))
                                                             (cadr x1)))))
            instance-liquidation)

      (+ liquidites
         instance-reglement-espece
         evaluation-du-portefeuille
         evaluation-des-ordres-en-instance
         (* emprunts -1.))))

(de compte-suspens-a-payer* (compte)
    (let ((instance-reglement-espece (get-slot-value compte 'instance-reglement-espece))
          (instance-liquidation (get-slot-value compte 'instance-liquidation))
          (evaluation-des-ordres-en-instance 0.))  
      (mapc '(lambda (x1) 
               (setq evaluation-des-ordres-en-instance (+ evaluation-des-ordres-en-instance
                                                          (* (cond ((eq (car x1) 'achat) 1.)
                                                                   (t -1.))
                                                             (cadddr x1)
                                                             (cadr x1)))))
            instance-liquidation)
(print "il:" instance-liquidation "ire:" instance-reglement-espece " ev-il:" evaluation-des-ordres-en-instance)
      (- evaluation-des-ordres-en-instance
         instance-reglement-espece)))

(de compte-portefeuille-total (compte)
    (let ((portefeuille (get-slot-value compte 'portefeuille))
          (instance (get-slot-value compte 'instance-liquidation)))
      (portefeuille-plus portefeuille 
                         (mapcar '(lambda (x)
                                    (list   (caddr x)
                                            (cond((eq (car x) 'achat) (cadr x))
                                                 (t (- (cadr x))))
                                        ))
                                 instance))))
    
      
(de compte-set-date (compte date)
    (prog ((old-date (get-slot-value compte 'date-courante)))
          (setf (get-slot-value compte 'date-courante) date)
          (cond ((null old-date)
                 t)
                ((saute-un-premier-jour-de-liquidation? old-date date)
                 ($ compte 'premier-jour-de-liquidation)
                 )
                ((saute-un-dernier-jour-de-liquidation? old-date date)
                 ($ compte 'dernier-jour-de-liquidation))
                )
          (return date)))


(de compte-premier-jour-de-liquidation (compte)
    (prog ((instance-liquidation (get-slot-value compte 'instance-liquidation))
           (portefeuille (get-slot-value compte 'portefeuille))
           (instance-reglement-espece (get-slot-value compte 'instance-reglement-espece))
           couple)
          (mapc '(lambda (x) 
                   (setq couple (depouillement-elementaire instance-reglement-espece portefeuille x nil))
                   (setq instance-reglement-espece (car couple))
                   (setq portefeuille (cadr couple))
                   )
                instance-liquidation)
          (setf (get-slot-value compte 'instance-reglement-espece) instance-reglement-espece)
          (setf (get-slot-value compte 'portefeuille) portefeuille)
          (setf (get-slot-value compte 'instance-liquidation) nil)
          ))

(de compte-dernier-jour-de-liquidation (compte)
    (prog ((instance-reglement-espece (get-slot-value compte 'instance-reglement-espece))
           (liquidites (get-slot-value compte 'liquidites))
           )
          (setq liquidites (+ instance-reglement-espece liquidites))
          (setf (get-slot-value compte 'instance-reglement-espece) 0)
          (setf (get-slot-value compte 'liquidites) liquidites)
          ))
          

(de saute-un-premier-jour-de-liquidation? (old-date date)
    (cond ((any '(lambda (x)(and (time->  x old-date)
                                 (time->= date x)))
                '((88 1 21 0 0 0 )
                  (88 2 19 0 0 0 )
                  (88 3 23 0 0 0 )
                  (88 4 21 0 0 0 )
                  (88 5 20 0 0 0 )
                  (88 6 22 0 0 0 )
                  (88 7 21 0 0 0 )
                  (88 8 23 0 0 0 )
                  (88 9 22 0 0 0 )
                  (88 10 20 0 0 0 )
                  (88 11 22 0 0 0 )
                  (88 12 21 0 0 0 )
                  (89 1 23 0 0 0 )
                  (89 2 20 0 0 0 )
                  (89 3 21 0 0 0 )
                  (89 4 20 0 0 0 )
                  (89 5 23 0 0 0 )
                  (89 6 22 0 0 0 )
                  (89 7 21 0 0 0 )
                  (89 8 23 0 0 0 )
                  (89 9 21 0 0 0 )
                  (89 10 23 0 0 0 )
                  (89 11 22 0 0 0 )
                  (89 12 20 0 0 0 )
                  ))
           t)
          (t nil)))

               


(de saute-un-dernier-jour-de-liquidation? (old-date date)
    (cond ((any '(lambda (x)(and (time->  x old-date)
                                 (time->= date x)))
                '((88 1 29 0 0 0 )
                  (88 2 29 0 0 0 )
                  (88 3 31 0 0 0 )
                  (88 4 29 0 0 0 )
                  (88 5 31 0 0 0 )
                  (88 6 30 0 0 0 )
                  (88 7 29 0 0 0 )
                  (88 8 31 0 0 0 )
                  (88 9 30 0 0 0 )
                  (88 10 28 0 0 0 )
                  (88 11 30 0 0 0 )
                  (88 12 30 0 0 0 )
                  (89 1 31 0 0 0 )
                  (89 2 28 0 0 0 )
                  (89 3 31 0 0 0 )
                  (89 4 28 0 0 0 )
                  (89 5 31 0 0 0 )
                  (89 6 30 0 0 0 )
                  (89 7 31 0 0 0 )
                  (89 8 31 0 0 0 )
                  (89 9 29 0 0 0 )
                  (89 10 31 0 0 0 )
                  (89 11 30 0 0 0 )
                  (89 12 39 0 0 0 )
                  ))
           t)
          (t nil)))





; un ordre est de la forme (achat 10 action-3 220.5) ou (vente 100 action-4 1531.)
; ou  (achat 10 action-3 220.5 ri) ou (vente 100 action-4 1531. ri)

(de liste-d-ordres-valorisation (liste-d-ordres)
    (apply '+ (mapcar '(lambda (x)
                         (* (cond((eq (car x) 'achat) 1.)
                                 (t -1.))
                            (cadr x)
                            (cadddr x)))
                      liste-d-ordres)))

(de compte-depouillement (compte liste-d-ordre)
    (prog ((liquidites (get-slot-value compte 'liquidites))
           (portefeuille (get-slot-value compte 'portefeuille))
           (instance-liquidation (get-slot-value compte 'instance-liquidation))
           couple)
          (mapc '(lambda (x) (setq action (caddr x))
                   (cond ((and (eq (get-slot-value action 'marche) 'reglement-mensuel)
                               (or (null (cddr (cddr x)))
                                   (not (eq (caddr (cddr x)) 'ri))))
                          (setq couple (depouillement-elementaire-rm liquidites portefeuille x instance-liquidation)))
                         (t
                          (setq couple (depouillement-elementaire liquidites portefeuille x instance-liquidation))))
                   
                   (setq liquidites (car couple))
                   (setq portefeuille (cadr couple))
                   (setq instance-liquidation (caddr couple)))
                
                liste-d-ordre)
          (setf (get-slot-value compte 'liquidites) liquidites)
          (setf (get-slot-value compte 'portefeuille) portefeuille)
          (setf (get-slot-value compte 'instance-liquidation) instance-liquidation)
          
          )) 

(de depouillement-elementaire (liquidites portefeuille-1 ordre instance-liquidation)
    (prog (lassoc (portefeuille (copy portefeuille-1)))
          (setq lassoc (assoc (caddr ordre) portefeuille ))
          (cond ((null lassoc)
                 (when (eq (car ordre) 'vente) 
                       (return (list (+ liquidites (* (cadr ordre) (cadddr ordre)))
                                     (cons (list (caddr ordre) (- (cadr ordre)))
                                           portefeuille)
                                     instance-liquidation)))
                 (when (eq (car ordre) 'achat) 
                       (return (list (- liquidites (* (cadr ordre) (cadddr ordre)))
                                     (cons (list (caddr ordre) (cadr ordre))
                                           portefeuille)
                                     instance-liquidation)))
                 )
                (t
                 (when (eq (car ordre) 'vente) 
                       (rplacd lassoc (list (- (cadr lassoc) (cadr ordre))))
                       (return (list (+ liquidites (* (cadr ordre) (cadddr ordre)))
                                     portefeuille
                                     instance-liquidation)))
                                           
                 (when (eq (car ordre) 'achat) 
                       (rplacd lassoc (list (+ (cadr lassoc) (cadr ordre))))
                       (return (list (- liquidites (* (cadr ordre) (cadddr ordre)))
                                     portefeuille
                                     instance-liquidation)))
                 ))))
                 
                 



(de depouillement-elementaire-rm (liquidites portefeuille ordre instance-liquidation)
    (list liquidites
          portefeuille
          (cons ordre instance-liquidation)
          ))

(user-instanciate 'metaclass 'moyen-de-financement nil)
(add-slot-user 'moyen-de-financement 'taux-courant 'instance)
(add-slot-user 'moyen-de-financement 'taux-courant-d-emprunt 'instance)
(add-slot-user 'moyen-de-financement 'taux-courant-de-placement 'instance)
(add-slot-user 'moyen-de-financement 'date-courante 'instance)
(add-slot-user 'moyen-de-financement 'courbe 'instance)

(add-method 'moyen-de-financement 'moyen-de-financement-set-date 'set-date 'superseed)

(de moyen-de-financement-set-date (moyen date)
    (setf (get-slot-value moyen 'date-courante) date)
    (setf (get-slot-value moyen 'taux-courant)
          (courbe-2d-interpolation (get-slot-value moyen 'courbe) date))
    (setf (get-slot-value moyen 'taux-courant-d-emprunt)
          (+ (get-slot-value moyen 'taux-courant) .0025))
    (setf (get-slot-value moyen 'taux-courant-de-placement)
          (- (get-slot-value moyen 'taux-courant) .0025))
 ;(setf (get-slot-value moyen 'taux-courant) 0.0)
 ;(setf (get-slot-value moyen 'taux-courant-d-emprunt) 0.0)
 ;(setf (get-slot-value moyen 'taux-courant-de-placement) 0.0)
    )
    
;chargement du taux-courant

(user-instanciate 'moyen-de-financement 'marche-monetaire nil)
(setf (get-slot-value 'marche-monetaire 'courbe) 
      (fetch-courbe-exceptionnel-from-current-directory "monetaire-q" ""))
          


(user-instanciate 'metaclass 'marche nil)
(add-slot-user 'marche 'liste-des-actions 'instance)
(add-slot-user 'marche 'date-courante 'instance)
(add-slot-user 'marche 'liste-des-ordres-courants 'instance)
(add-slot-user 'marche 'modele-de-marche 'instance)

; le modele de marche recoit une fonction ('achat-ou-vente volume action heure) 
; qui donne en retour le cours auquel s est effectue l echange

(add-attribute-user 'marche 'investissements-net-courant 
                    'marche-investissements-net-courant 'instance)
(add-attribute-user 'marche 'investissements-net-cummule-courant 
                    'marche-investissements-net-cummule-courant  'instance)
(add-attribute-user 'marche 'volume-des-transactions-courant 
                    'marche-volume-des-transactions-courant 'instance)




(de marche-investissements-net-courant (marche slot)
    (let ((liste-des-ordres (get-slot-value marche 'liste-des-ordres-courants)))
      (apply '+ (mapcar '(lambda (x) (cond ((eq (car x) 'achat)
                                            (* (cadr x) (cadddr x)))
                                           (t (* -1. (cadr x) (cadddr x)))))
                        liste-des-ordres))))

(de marche-investissements-net-cummule-courant (marche slot)
    (let ((old-value (get-slot-value marche slot))
          (investissement (user-get-value marche 'investissements-net-courant))
          )
      (cond ((null old-value) investissement)
            (t (+ old-value investissement)))))
    
          

(de marche-volume-des-transactions-courant (marche slot)
    (let ((liste-des-ordres (get-slot-value marche 'liste-des-ordres-courants)))
      (apply '+ (mapcar '(lambda (x) (* (cadr x) (cadddr x)))
                        liste-des-ordres))))


(de marche-action-achat-au-mieux (marche compte nb action heure)
    (let ((modele (get-slot-value marche 'modele-de-marche)) cours)
          
      (setq cours (funcall modele 'achat nb action heure))
      (setf (get-slot-value marche 'liste-des-ordres-courants)
            (cons (list 'achat nb action cours)
                  (get-slot-value marche 'liste-des-ordres-courants)))
      (undetermine marche 'volume-des-transactions-courant )
      (undetermine marche 'investissements-net-cummule-courant)
      (undetermine marche 'investissements-net-courant)
      ($ compte 'depouillement (list (list 'achat nb action cours)))))

(de marche-action-vente-au-mieux (marche compte nb action heure)
    (let ((modele (get-slot-value marche 'modele-de-marche)) cours)
          
      (setq cours (funcall modele 'vente nb action heure))
      (setf (get-slot-value marche 'liste-des-ordres-courants)
            (cons (list 'vente nb action cours)
                  (get-slot-value marche 'liste-des-ordres-courants)))
      (undetermine marche 'volume-des-transactions-courant )
      (undetermine marche 'investissements-net-cummule-courant)
      (undetermine marche 'investissements-net-courant)
      ($ compte 'depouillement (list (list 'vente nb action cours)))))


    
(de marche-panier-achat-au-mieux (marche compte montant panier heure)
    (let ((liste-d-ordres (panier-ordres-equivalents 'achat marche panier montant heure)))
;(print "liste d ordre : " liste-d-ordres)
      (setf (get-slot-value marche 'liste-des-ordres-courants)
            (append liste-d-ordres
                    (get-slot-value marche 'liste-des-ordres-courants)))
      (undetermine marche 'volume-des-transactions-courant )
      (undetermine marche 'investissements-net-cummule-courant)
      (undetermine marche 'investissements-net-courant)
      ($ compte 'depouillement liste-d-ordres )))

    
(add-method 'marche 'marche-portefeuille-au-mieux 'portefeuille-au-mieux 'superseed)

(de marche-portefeuille-au-mieux (marche compte portefeuille heure)
    (let (liste-d-ordres (modele (get-slot-value marche 'modele-de-marche)))
      (setq liste-d-ordres (mapcar '(lambda (x) (cond((< (cadr x) 0.) 
                                                      (list 'vente (- (cadr x)) (car x)  
                                                            (funcall modele 'vente (- (cadr x)) (car x) heure)))
                                                     (t 
                                                      (list 'achat (cadr x) (car x)  
                                                            (funcall modele 'achat (cadr x) (car x) heure)))
                                                     ))
                                   portefeuille))
      (setf (get-slot-value marche 'liste-des-ordres-courants)
            (append liste-d-ordres
                    (get-slot-value marche 'liste-des-ordres-courants)))
      (undetermine marche 'volume-des-transactions-courant )
      (undetermine marche 'investissements-net-cummule-courant)
      (undetermine marche 'investissements-net-courant)
      ($ compte 'depouillement liste-d-ordres )))

    

    
(de marche-panier-vente-au-mieux (marche compte montant panier heure)
    (let ((liste-d-ordres (panier-ordres-equivalents 'vente marche panier montant heure)))
;(print "liste d ordre : " liste-d-ordres)
      (setf (get-slot-value marche 'liste-des-ordres-courants)
            (append liste-d-ordres
                    (get-slot-value marche 'liste-des-ordres-courants)))
      (undetermine marche 'volume-des-transactions-courant )
      (undetermine marche 'investissements-net-cummule-courant)
      (undetermine marche 'investissements-net-courant)
      ($ compte 'depouillement liste-d-ordres )))

    

(de marche-vente-au-mieux (marche compte qte  instrument heure)
    (cond ((is-a instrument 'panier) 
           (marche-panier-vente-au-mieux marche compte qte instrument heure))
          ((is-a instrument 'action)
           (marche-action-vente-au-mieux marche compte qte instrument heure))))



(de marche-achat-au-mieux (marche compte qte  instrument heure)
    (cond ((is-a instrument 'panier) 
           (marche-panier-achat-au-mieux marche compte qte instrument heure))
          ((is-a instrument 'action)
           (marche-action-achat-au-mieux marche compte qte instrument heure))))


(add-method 'marche 'marche-set-date 'set-date 'superseed)
(add-method 'marche 'marche-actualisation 'actualisation 'superseed)
(add-method 'marche 'marche-vente-au-mieux 'vente-au-mieux 'superseed)
(add-method 'marche 'marche-achat-au-mieux 'achat-au-mieux 'superseed)
(add-method 'marche 'marche-initialize 'initialize 'superseed)

(de marche-initialize (marche)
    (undetermine marche 'volume-des-transactions-courant )
    (undetermine marche 'investissements-net-cummule-courant)
    (undetermine marche 'investissements-net-courant)
    (setf (get-slot-value marche 'volume-des-transactions-courant ) 0.)
    (setf (get-slot-value marche 'investissements-net-cummule-courant) 0.)
    (setf (get-slot-value marche 'investissements-net-courant) 0.)
    (setf (get-slot-value marche 'liste-des-ordres-courants) nil))

(add-post-instanciation-demon marche 'initialisation-du-marche 'merge-before)

(de initialisation-du-marche (marche)
    (setf (get-slot-value marche 'investissements-net-cummule-courant) 0.)
    )

(de marche-actualisation (marche facteur)
    (when (get-slot-value marche 'investissements-net-cummule-courant)
          (setf (get-slot-value marche 'investissements-net-cummule-courant)
                (* facteur (get-slot-value marche 'investissements-net-cummule-courant)))))
    
(de marche-set-date (marche date)
    (setf (get-slot-value marche 'liste-des-ordres-courants) nil)
   (undetermine marche 'liste-des-ordres-courants)
   (setf (get-slot-value marche 'investissements-net-courant) nil)
   (undetermine marche 'investissements-net-courant)
   (undetermine marche 'investissements-net-cummule-courant)
   (setf (get-slot-value marche 'volume-des-transactions-courant) nil)
   (undetermine marche 'volume-des-transactions-courant )
   (user-put-value marche 'date-courante date))

(de modele-standart-de-marche (sens nb action heure)
    (let ((plus-haut (get-slot-value action 'plus-haut))
          (plus-bas (get-slot-value action 'plus-bas))
          (premier-cours (get-slot-value action 'premier-cours))
          (dernier-cours (get-slot-value action 'dernier-cours))
          (volume (get-slot-value action 'volume)))
      (* (/ (+ (* premier-cours (- 17. heure))
               (* dernier-cours (- heure 10.))) 
            7.)
         (+ 1. (* (cond ((<= heure 10.01) 0.02)
                        (t 0.04))
                  (cond ((eq sens 'achat) 1.)
                        (t -1.))
                  0.
                  (/ nb volume))))))





                            
(de panier-portefeuille-equivalent (marche panier montant)
    (prog (jour-d-aujourdhui qte-ri qte-rm qte investi-ri investi-rm investi
                             ponderations cours quotites dividendes montants-essayes taux-monetaire jour-d-aujourdhui
                             (poids-relatifs-ideals (user-get-value panier 'poids-relatifs-ideals))
                             (liste-des-actions-incluses (user-get-value panier 'liste-des-actions-incluses))
                             (jour-d-aujourdhui (user-get-value panier 'date-courante))
                             (ri-ou-rm (user-get-value panier 'ri-ou-rm))
                            
                             somme-des-ponderations)
          (setq somme-des-ponderations (apply '+ (mapcar 'cadr poids-relatifs-ideals)))
          (setq ponderations (mapcar '(lambda (x) (list (car x) (*  100. 
                                                                    (/ (cadr x) 
                                                                       somme-des-ponderations))))
                                     poids-relatifs-ideals))
          (setq dividendes (mapcar '(lambda (x) (list x (user-get-value x 'dernier-dividende))) liste-des-actions-incluses))
          (setq cours (mapcar '(lambda (x) (list x (user-get-value x 'premier-cours))) liste-des-actions-incluses))
          (setq quotites (mapcar '(lambda (x) (list x (user-get-value x 'quotite))) liste-des-actions-incluses))          
          (setq qte-ri (mapcar '(lambda (x) (list (car x) (truncate* (/ (* (/ montant 100.) (cadr x)) 
                                                                       (cadr (assoc (car x) cours))))))
                               ponderations))
          (setq qte-rm (mapcar '(lambda (x) (list (car x) (* (truncate* (/ (cadr x) 
                                                                          (cadr (assoc (car x) quotites))))
                                                             
                                                             (cadr (assoc (car x) quotites)))))
                               qte-ri))
          
          (setq investi-ri (apply '+ (mapcar '(lambda (x) (* (cadr x) 
                                                             (cadr (assoc (car x) cours))))
                                             qte-ri)))
          (setq investi-rm (apply '+ (mapcar '(lambda (x) (* (cadr x) 
                                                             (cadr (assoc (car x) cours))))
                                             qte-rm)))
          (cond ((eq ri-ou-rm 'ri)
                 (setq qte qte-ri)
                 (setq investi investi-ri))
                (t (setq qte qte-rm)
                   (setq investi investi-rm)))
          (return qte)))

     
(de portefeuille-moins (p1 p2)
    (prog ((p3 (copy p2)))
          (append (mapcan '(lambda (x)
                             (let (valem)
                               (setq valem (assoc (car x) p1))
                               (cond((and valem
                                          (equal (cadr valem) (cadr x)))
                                     nil)
                                    (valem
                                     (list (list (car x) (- (cadr valem) (cadr x)) )))
                                    (t (list (list (car x) (- (cadr x))))))
                               ))
                          p3)
                  (mapcan '(lambda (x) 
                             (let (valem)
                               (setq valem (assoc (car x) p2))
                               (cond(valem nil)
                                    (t (list x)))))
                          (copy p1)))
          ))


    
(de portefeuille-plus (p1 p2)
    (prog ((psom (copy p1)) elem)
          (mapc '(lambda (y)
                   (cond ((setq elem (assoc (car y ) psom))
                          (rplacd elem (list (+ (cadr elem) (cadr y)))))
                         (t (setq psom (cons y psom)))))
                p2)
         (return psom)))


(de compte-valorisation-a-l-ouverture (compte)
    (let ((liquidites (get-slot-value compte 'liquidites))
          (portefeuille (get-slot-value compte 'portefeuille))
          (instance-reglement-espece (get-slot-value compte 'instance-reglement-espece))
          (emprunts (get-slot-value compte 'emprunts))
          (instance-liquidation (get-slot-value compte 'instance-liquidation))
          (evaluation-du-portefeuille 0.) (evaluation-des-ordres-en-instance 0.))

      (mapc '(lambda (x1) 
               (setq evaluation-du-portefeuille (+ evaluation-du-portefeuille
                                                   (* (get-slot-value (car x1) 'premier-cours)
                                                      (cadr x1)))))
            portefeuille)

      (mapc '(lambda (x1) 
               (setq evaluation-des-ordres-en-instance (+ evaluation-des-ordres-en-instance
                                                          (* (cond ((eq (car x1) 'achat) 1.)
                                                                   (t -1.))
                                                             (- (get-slot-value (caddr x1) 'premier-cours) 
                                                                (cadddr x1))
                                                             (cadr x1)))))
            instance-liquidation)
     ; (print "liquidites = " liquidites)
     ; (print " instance-reglement-espece = " instance-reglement-espece)
     ; (print " evaluation-du-portefeuille = " evaluation-du-portefeuille)
     ; (print " evaluation-des-ordres-en-instance = " evaluation-des-ordres-en-instance)
     ; (print " emprunts = " emprunts)
     ; (print " valorisation a l ouverture = "   (+ liquidites
     ;                                              instance-reglement-espece
     ;                                              evaluation-du-portefeuille
     ;                                              evaluation-des-ordres-en-instance
     ;                                              (* emprunts -1.)))
     ; (print " = " )
      

      (+ liquidites
         instance-reglement-espece
         evaluation-du-portefeuille
         evaluation-des-ordres-en-instance
         (* emprunts -1.))))
      
(de compte-suspens-a-payer (compte)
    (let ((instance-reglement-espece (get-slot-value compte 'instance-reglement-espece))
          (instance-liquidation (get-slot-value compte 'instance-liquidation))
          (emprunts (get-slot-value compte 'emprunts))
          (evaluation-des-ordres-en-instance 0.))  
      (mapc '(lambda (x1) 
               (setq evaluation-des-ordres-en-instance (+ evaluation-des-ordres-en-instance
                                                          (* (cond ((eq (car x1) 'achat) 1.)
                                                                   (t -1.))
                                                             (cadddr x1)
                                                             (cadr x1)))))
            instance-liquidation)
      (+ emprunts
         (- evaluation-des-ordres-en-instance
            instance-reglement-espece))))
