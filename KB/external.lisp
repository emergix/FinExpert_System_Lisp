 ;fichier contenant les objects et fonctions relative a l interaction entre le systeme
;et les base de donnees



;a partir de cours.lis cree cours.ouverture cours.fermeture cours.plus-haut cours.plus-bas cours.volume
; type vaut o pour ouverture f pour fermeture h pour plus-haut b pour plus-bas


(de add-last (l x)
    (let ((z (copy l)))
      (cond ((and (cdr x)
                  (cadr x)
                  (not (equal (cadr x) 0.0)))
             
             (nreverse (cons x (nreverse z))))
            (t z))))



(de load-valeur-quotidien(ticker)
    (prog (savechan chan cours.ouverture cours.fermeture cours.plus-haut cours.plus-bas cours.volume
                    ref-jour indicator date premier dernier plus-haut plus-bas quantite taux-1 taux-2 flist)
          (comline (catenate "transvaleur " (string ticker)))
          (setq chan (openi (catenate  "/usr/jupiter/olivier/expert/cours/"
                                       (string ticker)
                                       
                                       ".quotidien")))
          (setq savechan (inchan))
          (inchan chan)
          (readline)
       
          (untilexit eof 
                     (setq indicator (read))
                     (setq date (read))
                     (setq premier (read))
                     (setq dernier (read))
                     (setq plus-haut (read))
                     (setq plus-bas (read))
                     (setq quantite (read))
                     (setq taux-1 (read))
                     (setq taux-2 (read))
                     (when (not (and (numberp premier )
                                     (numberp dernier)
                                     (numberp plus-haut)
                                     (numberp plus-bas)
                                     (numberp quantite)))
                                         (exit eof))
                     (setq ref-jour (convert-stringdate-to-date date))
                     (setq cours.ouverture (add-last cours.ouverture (list ref-jour premier)))
                     (setq cours.fermeture (add-last cours.fermeture (list ref-jour dernier)))
                     (setq cours.plus-haut (add-last cours.plus-haut (list ref-jour plus-haut)))
                     (setq cours.plus-bas  (add-last cours.plus-bas (list ref-jour plus-bas)))
                     (setq cours.volume (add-last  cours.volume  (list ref-jour quantite)))
                     ;(print ref-jour " " premier " " dernier " "  plus-haut " " plus-bas " " quantite)
                     )
          
          (inchan savechan )
          (mapc '(lambda (type)
                   (setq chan (openo (catenate  "/usr/jupiter/olivier/expert/cours/"
                                                (string ticker)
                                                (cond ((eq type 'o) "-q-ouvert")
                                                      ((eq type 'f) "-q-fermet")
                                                      ((eq type 'h) "-q-plhaut")
                                                      ((eq type 'b) "-q-plubas")
                                                      ((eq type 'v) "-q-volume"))
                                                
                                                ".courbe-2d")))
                   
                   (setq savechan (outchan))
                   (outchan chan)
                   (print " #[")
                   (mapc '(lambda (x) (print x))
                         (cond ((eq type 'o) (reverse cours.ouverture))
                               ((eq type 'f) (reverse cours.fermeture))
                               ((eq type 'h) (reverse cours.plus-haut))
                               ((eq type 'b) (reverse cours.plus-bas))
                               ((eq type 'v) (reverse cours.volume))))
                   (print " ]")
                   (outchan savechan )
                   (close))
                '(o f h b v))
          (return (list  (catenate  "/usr/jupiter/olivier/expert/cours/"
                                    (string ticker)
                                    "-q-ouvert")
                         (catenate  "/usr/jupiter/olivier/expert/cours/"
                                    (string ticker)
                                    "-q-fermet")
                          (catenate  "/usr/jupiter/olivier/expert/cours/"
                                    (string ticker)
                                    "-q-plhaut")
                          (catenate  "/usr/jupiter/olivier/expert/cours/"
                                    (string ticker)
                                    "-q-plubas")
                          (catenate  "/usr/jupiter/olivier/expert/cours/"
                                     (string ticker)
                                     "-q-volume")))
                                                
                                              
          ))


(de load-valeur-hebdomadaire(ticker)
    (prog (savechan chan cours.ouverture cours.fermeture cours.plus-haut cours.plus-bas cours.volume
                    ref-jour indicator date premier dernier plus-haut plus-bas quantite taux-1 taux-2)
          (comline (catenate "transvaleur " (string ticker)))
          (setq chan (openi (catenate  "/usr/jupiter/olivier/expert/cours/"
                                       (string ticker)
                                       
                                       ".hebdomadaire")))
          (setq savechan (inchan))
          (inchan chan)
          (readline)
       
          (untilexit eof 
                     (setq indicator (read))
                     (setq date (read))
                     (setq premier (read))
                     (setq dernier (read))
                     (setq plus-haut (read))
                     (setq plus-bas (read))
                     (setq quantite (read))
                     (setq taux-1 (read))
                     (setq taux-2 (read))
                     (when (not (and (numberp premier )
                                     (numberp dernier)
                                     (numberp plus-haut)
                                     (numberp plus-bas)
                                     (numberp quantite)))
                           (exit eof))
                     (setq ref-jour (convert-stringdate-to-date date))
                     (setq cours.ouverture (add-last cours.ouverture (list ref-jour premier)))
                     (setq cours.fermeture (add-last cours.fermeture (list ref-jour dernier)))
                     (setq cours.plus-haut (add-last cours.plus-haut (list ref-jour plus-haut)))
                     (setq cours.plus-bas  (add-last cours.plus-bas (list ref-jour plus-bas)))
                     (setq cours.volume (add-last  cours.volume  (list ref-jour quantite)))
                     ;(print ref-jour " " premier " " dernier " "  plus-haut " " plus-bas " " quantite)
                     )
          
          (inchan savechan )
          (mapc '(lambda (type)
                   (setq chan (openo (catenate  "/usr/jupiter/olivier/expert/cours/"
                                                (string ticker)
                                                (cond ((eq type 'o) "-h-ouvert")
                                                      ((eq type 'f) "-h-fermet")
                                                      ((eq type 'h) "-h-plhaut")
                                                      ((eq type 'b) "-h-plubas")
                                                      ((eq type 'v) "-h-volume"))
                                                
                                                ".courbe-2d")))
                   
                   (setq savechan (outchan))
                   (outchan chan)
                   (print " #[")
                   (mapc '(lambda (x) (print x))
                         (cond ((eq type 'o) (reverse cours.ouverture))
                               ((eq type 'f) (reverse cours.fermeture))
                               ((eq type 'h) (reverse cours.plus-haut))
                               ((eq type 'b) (reverse cours.plus-bas))
                               ((eq type 'v) (reverse cours.volume))))
                   (print " ]")
                   (outchan savechan )
                   (close))
                '(o f h b v))
          (return (list  (catenate  "/usr/jupiter/olivier/expert/cours/"
                                    (string ticker)
                                    "-h-ouvert")
                         (catenate  "/usr/jupiter/olivier/expert/cours/"
                                    (string ticker)
                                    "-h-fermet")
                         (catenate  "/usr/jupiter/olivier/expert/cours/"
                                    (string ticker)
                                    "-h-plhaut")
                         (catenate  "/usr/jupiter/olivier/expert/cours/"
                                    (string ticker)
                                    "-h-plubas")
                         (catenate  "/usr/jupiter/olivier/expert/cours/"
                                    (string ticker)
                                    "-h-volume")))
          ))


(de fetch-courbe-from-current-directory* (current-stock)
    (prog (name savechan input chan i c d)
          (setq name (catenate "/usr/jupiter/olivier/expert/cours/" (string current-stock)
                               ))
          (with ((typecn #/{ 'cmsymb)
                 (typecn #/} 'cmsymb)
                 (typecn #/@ 'cmsymb))
                (setq chan (openi name))
                (setq savechan (inchan))
                (inchan chan)               
                (untilexit eof
                           (setq input (read))
                           (setq c (user-instanciate 'courbe-2d nil nil))
                           (setf (get-slot-value c 'body) input)
                           (setf (get-slot-value c 'xtype) 'date)
                           (setf (get-slot-value c 'ytype) 'real)
                           (setf (get-slot-value c 'pointeur-max) (1- (vlength input)))
                           )
                (inchan savechan))
          (setq *already-studied-courbe* (cons (cons current-stock c)
                                               *already-studied-courbe*))
          ))

(de fetch-courbe-from-current-directory (current-stock fin-de-fichier)
    (let (d)
    (cond ((eqstring (substring (string current-stock) (1- (plength (string current-stock))) 1) "h")
           (setq d (fetch-courbe-hebdomadaire-from-current-directory  current-stock fin-de-fichier))
             (setq *already-studied-h-valeur* (cons (cons current-stock d)
                                               *already-studied-h-valeur*)))
          ((eqstring (string fin-de-fichier) ".hebdomadaire")
                  
           (setq d (fetch-courbe-hebdomadaire-from-current-directory (catenate (string current-stock)
                                                                       "-h")
                                                             fin-de-fichier))
             (setq *already-studied-h-valeur* (cons (cons current-stock d)
                                               *already-studied-h-valeur*)))
                 
                     
          ((eqstring (substring (string current-stock) (1- (plength (string current-stock))) 1) "q")
           (setq d (fetch-courbe-quotidien-from-current-directory current-stock fin-de-fichier))
             (setq *already-studied-q-valeur* (cons (cons current-stock d)
                                               *already-studied-q-valeur*)))
          ((eqstring (string fin-de-fichier) ".quotidien")
           (setq d (fetch-courbe-quotidien-from-current-directory (catenate (string current-stock)
                                                                    "-q")
                                                          fin-de-fichier))
             (setq *already-studied-h-valeur* (cons (cons current-stock d)
                                               *already-studied-h-valeur*)))
                
                   
          )))

(de fetch-courbe-quotidien-from-current-directory (current-stock fin-de-fichier)
    (prog (name savechan input chan  c d)
          (setq d (user-instanciate 'valeur nil nil))
          (setq name (catenate "/usr/jupiter/olivier/expert/cours/" 
                               (string current-stock) 
                               "-ouvert.courbe-2d"
                               ))
          (with ((typecn #/{ 'cmsymb)
                 (typecn #/} 'cmsymb)
                 (typecn #/@ 'cmsymb))
                (setq chan (openi name))
                (setq savechan (inchan))
                (inchan chan)
                
                (untilexit eof
                           (setq input (read))
                           (setq c (user-instanciate 'courbe-2d nil nil))
                           (setf (get-slot-value c 'body) input)
                           (setf (get-slot-value c 'xtype) 'date)
                           (setf (get-slot-value c 'ytype) 'real)
                           (setf (get-slot-value c 'pointeur-max) (1- (vlength input)))
                           (setf (get-slot-value d 'premier-cours) c))
                (inchan savechan))
          (setq name (catenate "/usr/jupiter/olivier/expert/cours/" 
                               (string current-stock) 
                               "-fermet.courbe-2d"
                               ))
          (with ((typecn #/{ 'cmsymb)
                 (typecn #/} 'cmsymb)
                 (typecn #/@ 'cmsymb))
                (setq chan (openi name))
                (setq savechan (inchan))
                (inchan chan)
                
                (untilexit eof
                           (setq input (read))
                           (setq c (user-instanciate 'courbe-2d nil nil))
                           (setf (get-slot-value c 'body) input)
                           (setf (get-slot-value c 'xtype) 'date)
                           (setf (get-slot-value c 'ytype) 'real)
                           (setf (get-slot-value c 'pointeur-max) (1- (vlength input)))
                           (setf (get-slot-value d 'dernier-cours) c))
                (inchan savechan))
          (setq name (catenate "/usr/jupiter/olivier/expert/cours/" 
                               (string current-stock) 
                               "-plhaut.courbe-2d"
                               ))
          (with ((typecn #/{ 'cmsymb)
                 (typecn #/} 'cmsymb)
                 (typecn #/@ 'cmsymb))
                (setq chan (openi name))
                (setq savechan (inchan))
                (inchan chan)
                
                (untilexit eof
                           (setq input (read))
                           (setq c (user-instanciate 'courbe-2d nil nil))
                           (setf (get-slot-value c 'body) input)
                           (setf (get-slot-value c 'xtype) 'date)
                           (setf (get-slot-value c 'ytype) 'real)
                           (setf (get-slot-value c 'pointeur-max) (1- (vlength input)))
                           (setf (get-slot-value d 'plus-haut) c))
                (inchan savechan))
          (setq name (catenate "/usr/jupiter/olivier/expert/cours/" 
                               (string current-stock) 
                               "-plubas.courbe-2d"
                               ))
          (with ((typecn #/{ 'cmsymb)
                 (typecn #/} 'cmsymb)
                 (typecn #/@ 'cmsymb))
                (setq chan (openi name))
                (setq savechan (inchan))
                (inchan chan)
                
                (untilexit eof
                           (setq input (read))
                           (setq c (user-instanciate 'courbe-2d nil nil))
                           (setf (get-slot-value c 'body) input)
                           (setf (get-slot-value c 'xtype) 'date)
                           (setf (get-slot-value c 'ytype) 'real)
                           (setf (get-slot-value c 'pointeur-max) (1- (vlength input)))
                           (setf (get-slot-value d 'plus-bas) c))
                (inchan savechan))
          (setq name (catenate "/usr/jupiter/olivier/expert/cours/" 
                               (string current-stock) 
                               "-volume.courbe-2d"
                               ))
          (with ((typecn #/{ 'cmsymb)
                 (typecn #/} 'cmsymb)
                 (typecn #/@ 'cmsymb))
                (setq chan (openi name))
                (setq savechan (inchan))
                (inchan chan)
                
                (untilexit eof
                           (setq input (read))
                           (setq c (user-instanciate 'courbe-2d nil nil))
                           (setf (get-slot-value c 'body) input)
                           (setf (get-slot-value c 'xtype) 'date)
                           (setf (get-slot-value c 'ytype) 'real)
                           (setf (get-slot-value c 'pointeur-max) (1- (vlength input)))
                           (setf (get-slot-value d 'volume) c))
                (inchan savechan))
          (return d)
         
          ))
          
(de fetch-courbe-hebdomadaire-from-current-directory (current-stock fin-de-fichier)
    (prog (name savechan input chan  c d)
          (setq d (user-instanciate 'valeur nil nil))
          (setq name (catenate "/usr/jupiter/olivier/expert/cours/" 
                               (string current-stock) 
                               "-ouvert.courbe-2d"
                               ))
          (with ((typecn #/{ 'cmsymb)
                 (typecn #/} 'cmsymb)
                 (typecn #/@ 'cmsymb))
                (setq chan (openi name))
                (setq savechan (inchan))
                (inchan chan)
                
                (untilexit eof
                           (setq input (read))
                           (setq c (user-instanciate 'courbe-2d nil nil))
                           (setf (get-slot-value c 'body) input)
                           (setf (get-slot-value c 'xtype) 'date)
                           (setf (get-slot-value c 'ytype) 'real)
                           (setf (get-slot-value c 'pointeur-max) (1- (vlength input)))
                           (setf (get-slot-value d 'premier-cours) c))
                (inchan savechan))
          (setq name (catenate "/usr/jupiter/olivier/expert/cours/" 
                               (string current-stock) 
                               "-fermet.courbe-2d"
                               ))
          (with ((typecn #/{ 'cmsymb)
                 (typecn #/} 'cmsymb)
                 (typecn #/@ 'cmsymb))
                (setq chan (openi name))
                (setq savechan (inchan))
                (inchan chan)
                
                (untilexit eof
                           (setq input (read))
                           (setq c (user-instanciate 'courbe-2d nil nil))
                           (setf (get-slot-value c 'body) input)
                           (setf (get-slot-value c 'xtype) 'date)
                           (setf (get-slot-value c 'ytype) 'real)
                           (setf (get-slot-value c 'pointeur-max) (1- (vlength input)))
                           (setf (get-slot-value d 'dernier-cours) c))
                (inchan savechan))
          (setq name (catenate "/usr/jupiter/olivier/expert/cours/" 
                               (string current-stock) 
                               "-plhaut.courbe-2d"
                               ))
          (with ((typecn #/{ 'cmsymb)
                 (typecn #/} 'cmsymb)
                 (typecn #/@ 'cmsymb))
                (setq chan (openi name))
                (setq savechan (inchan))
                (inchan chan)
                
                (untilexit eof
                           (setq input (read))
                           (setq c (user-instanciate 'courbe-2d nil nil))
                           (setf (get-slot-value c 'body) input)
                           (setf (get-slot-value c 'xtype) 'date)
                           (setf (get-slot-value c 'ytype) 'real)
                           (setf (get-slot-value c 'pointeur-max) (1- (vlength input)))
                           (setf (get-slot-value d 'plus-haut) c))
                (inchan savechan))
          (setq name (catenate "/usr/jupiter/olivier/expert/cours/" 
                               (string current-stock) 
                               "-plubas.courbe-2d"
                               ))
          (with ((typecn #/{ 'cmsymb)
                 (typecn #/} 'cmsymb)
                 (typecn #/@ 'cmsymb))
                (setq chan (openi name))
                (setq savechan (inchan))
                (inchan chan)
                
                (untilexit eof
                           (setq input (read))
                           (setq c (user-instanciate 'courbe-2d nil nil))
                           (setf (get-slot-value c 'body) input)
                           (setf (get-slot-value c 'xtype) 'date)
                           (setf (get-slot-value c 'ytype) 'real)
                           (setf (get-slot-value c 'pointeur-max) (1- (vlength input)))
                           (setf (get-slot-value d 'plus-bas) c))
                (inchan savechan))
          (setq name (catenate "/usr/jupiter/olivier/expert/cours/" 
                               (string current-stock) 
                               "-volume.courbe-2d"
                               ))
          (with ((typecn #/{ 'cmsymb)
                 (typecn #/} 'cmsymb)
                 (typecn #/@ 'cmsymb))
                (setq chan (openi name))
                (setq savechan (inchan))
                (inchan chan)
                
                (untilexit eof
                           (setq input (read))
                           (setq c (user-instanciate 'courbe-2d nil nil))
                           (setf (get-slot-value c 'body) input)
                           (setf (get-slot-value c 'xtype) 'date)
                           (setf (get-slot-value c 'ytype) 'real)
                           (setf (get-slot-value c 'pointeur-max) (1- (vlength input)))
                           (setf (get-slot-value d 'volume) c))
                (inchan savechan))
          (return d)
        
          ))
          


          
(de fetch-object-from-current-directory (current-stock fin-de-fichier)
    (prog (name savechan input chan  c ll)
          (setq name (catenate "/usr/jupiter/olivier/expert/base-de-donnees/" 
                               (string current-stock) 
                               (string fin-de-fichier)
                               ))
          (with ((typecn #/{ 'cmsymb)
                 (typecn #/} 'cmsymb)
                 (typecn #/@ 'cmsymb))
                (setq chan (openi name))
                (setq savechan (inchan))
                (inchan chan)
                (setq ll nil)
                (untilexit eof
                           (setq input (read))
                           (setq c (user-instanciate 'resultat-d-analyse nil nil))
                           (setf (get-slot-value c 'valeur-concernee) (car (caddr input)))
                           (setf (get-slot-value c (car input)) (cdr (caddr input)))
                           (setq ll (cons c ll)))
                (inchan savechan))
          (return ll)
          ))
          
         
(de fetch-courbe-exceptionnel-from-current-directory (current-stock fin-de-fichier)
    (prog (name savechan input chan  c)
          (setq name (catenate "/usr/jupiter/olivier/expert/cours/" 
                               (string current-stock) 
                              (string fin-de-fichier)
                               ))
          (with ((typecn #/{ 'cmsymb)
                 (typecn #/} 'cmsymb)
                 (typecn #/@ 'cmsymb))
                (setq chan (openi name))
                (setq savechan (inchan))
                (inchan chan)
                
                (untilexit eof
                           (setq input (read))
                           (setq c (user-instanciate 'courbe-2d nil nil))
                           (setf (get-slot-value c 'body) input)
                           (setf (get-slot-value c 'xtype) 'date)
                           (setf (get-slot-value c 'ytype) 'real)
                           (setf (get-slot-value c 'pointeur-max) (1- (vlength input)))
                           )
                (inchan savechan))
          
          (return c)
        
          ))
          




(de convert-stringdate-to-date (atm)
    (let ((strng (string atm)) jour mois annee)
          (setq jour (concat (substring strng 0 2)))
          (setq mois (concat (substring strng 3 2)))
          (setq annee (concat (substring strng 6 2)))
          (list annee mois jour 0 0 0)))






(de complete-courbe-2d-save (courbe file-name directory)
    (prog (savechan chan)
          (setq savechan (outchan))
          (setq chan (openo  (catenate directory "/" (string file-name) ".courbe-2d")))
          (outchan chan)
          (print " #[")
          (mapvector '(lambda (x) (print x)) 
                     (get-slot-value courbe 'body))
                    (print " ]")
          (outchan savechan)
          (close)
          ))


(de sauver (expr nom)
    (prog (savechan chan)
          (setq savechan (outchan))
          (setq chan (openo  (catenate "/usr/jupiter/olivier/expert/tmp" (string nom))))
          (outchan chan)
          (pprint  expr)
          (outchan savechan)
          (close)
          ))
              
(de printer (expr)
       (prog (savechan chan)
          (setq savechan (outchan))
          (setq chan (openo  (catenate "/usr/jupiter/olivier/expert/tmp/fichier-intermediaire-du-printer")))
          (outchan chan)
          (pprint expr)
          (outchan savechan)
          (close)
          (comline "print  /usr/jupiter/olivier/expert/tmp/fichier-intermediaire-du-printer")
          ))


(de charge-courbe-2d-date (name-file name-courbe directory)
    (prog (name  savechan input chan  c d dir)
          (cond ((null directory) (setq dir  "/usr/jupiter/olivier/expert/tmp"))
                (t (setq dir (string directory))))
          (setq name (catenate dir "/"  name-file ".courbe-2d"))
          (with ((typecn #/{ 'cmsymb)
                 (typecn #/} 'cmsymb)
                 (typecn #/@ 'cmsymb))
                (setq chan (openi name))
                (setq savechan (inchan))
                (inchan chan)
                
                (untilexit eof
                           (setq input (read))
                           (setq c (user-instanciate 'courbe-2d name-courbe nil))
                           (setf (get-slot-value c 'body) input)
                           (setf (get-slot-value c 'xtype) 'date)
                           (setf (get-slot-value c 'ytype) 'real)
                           (setf (get-slot-value c 'pointeur-max) (1- (vlength input)))
                          )
                (inchan savechan))
          (return ($ c 'convert-time))))
          
          
(de directory-list (directory)
    (let (chan savechan fichier-list)
      (comline (catenate "(ls " (string directory) ")>/usr/jupiter/olivier/tmp"))
      (setq savechan (inchan))
      (setq chan (openi "/usr/jupiter/olivier/tmp"))
      (inchan chan)
      (untilexit eof
                 (setq fichier-list (cons (catenate (read)) fichier-list))
                 )
      (inchan savechan)
    fichier-list
     ))