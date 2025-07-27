; fichier des definitions du langage oriente object de base
   (de lla () (load "object.lisp")) 


  (setq *knowledge-bases* nil)
  (setq *system-type* 'system)
  (setq *trace-level* '(8))
  (setq *metaclass-list* '(metaclass))
  (setq *slot-to-spy-list* nil)
  (setq *situation-bloc-activation-list* nil)
  (setq *dynamic-inheritance-slot-list* nil)
  (setq *forward-translation-predicat-state* nil)
  (setq *object-list* nil)  
  (setq *expand-method-bi-object-list* nil)
  (setq *super-binding-list* nil)
  (setq *current-hypothetical-world* 'fondamental)
  (setq *hypothetical-world-list* '( (fondamental fondamental)))
  (setq *current-forward-chainer-object* nil)
  (setq *current-reading-knowledge-base* nil)
  (setq *explanation-flag* t)
  (setq *error-check-flag* t)
  (setq *trace-main-event-buffer* nil)
  (setq *trace-main-event-buffer-count* 0)
  (setq *backward-rule-just-succeeded* nil)
  (setq *forward-rule-just-succeeded* nil)
  (setq *already-studied-courbe* nil)
  (setq *already-studied-q-valeur* nil)
  (setq *already-studied-h-valeur* nil)
  (setq *indic-h-q* nil)
  (setq *mode-display-time* t)
  (setq *displayed-courbe-a* nil)
  (setq *displayed-courbe-b* nil)
  (setq *displayed-courbe-c* nil)
  (setq *displayed-courbe-d* nil)
  (setq *current-expert* nil)
  (setq *corrector-x0* 0.)
  (setq *corrector-y0* 0.)
  (setq *corrector-kx* 1.)
  (setq *corrector-ky* 1.)
  (setq *wait-flag* nil)
  (setq *surveillance-flag1* t)
  (setq *surveillance-flag2* nil)
  (setq *log-trace* nil)
  (setq *list-to-print* nil)
  (setq *search-delete-flag* t)
  (setq *accummulation-delete-flag* t)
  (setq *generateur-de-droite-flag-de-sens* nil)
  (setq *where-to-trace* nil)
  (setq *contexte-d-analyse* nil)

; variable associee au tell&ask

  (setq *files-of-data* nil)
  (setq *where-to-answer* nil)
  (setq *what-to-answer* nil)
  (setq *files-of-data-charged-?* nil)
  (setq *contens-of-files-of-data* nil)

(de dd (n) 
    (setq #:system:debug-line n))

(de load-kb (kbname)
    (with ((typecn #/{ 'cmsymb)
           (typecn #/} 'cmsymb)
           (typecn #/@ 'cmsymb))
          (prog (savechan chan)
                (setq chan (openi (string kbname)))
                (setq savechan (inchan))
                (inchan chan)
                (untilexit eof
                           (setq input (read))
                           (when (eq (car input) 'setq)
                                 (setf (get (cadr input) 'knowledge-base) kbname))
                           (when (eq (car input) 'de)
                                 (setf (get (cadr input) 'knowledge-base) kbname))
                           (when (eq (car input) 'dmd)
                                 (setf (get (cadr input) 'knowledge-base) kbname))
                           (when (eq (car input) 'setq)
                                 (setf (get (cadr input) 'knowledge-base) kbname))
                           (setq *current-reading-knowledge-base* kbname)
                           (eval input)
                           (setq *current-reading-knowledge-base* nil)
                           )
                (inchan savechan )
                (print kbname))))




; on peut desactiver et reactiver  les situation-blocs en les retirant et en les rajoutant aux liste
; *situation-bloc-activation-list*  ou en leur envoyant le message activate ou desactivate
 

(de create-object (object  metaobject superobjectlist) 
    (prog ((date-of-creation (date-of-object-creation)) hyp-save)
          (setf (get object 'knowledge-base) 
                *current-reading-knowledge-base*)
          (setq hyp-save  *current-hypothetical-world*)
          (setq  *current-hypothetical-world* 'fondamental)
          (newl *object-list* object)
          (setf (get object 'object-property) nil)
          (add-slot-system object 'date-of-creation 'number date-of-creation
                           "?" nil 'system nil)
          (setf (get-fondamental-value object 'date-of-creation ) date-of-creation)
          (add-slot-system object 'supertypes 'list-of-objects date-of-creation
                           "quels sont les supertypes pour cet object ?" superobjectlist 'static-user nil)
          (add-slot-system object 'subtypes 'list-of-objects date-of-creation
                           "quels sont les subtypes pour cet object ?"  nil 'static-user nil)
          (add-slot-system object 'metaclass 'object date-of-creation
                           "quelle est la metaclasse pour cet object ?" nil 'static-user nil)
          (add-slot-system object 'instances 'list-of-objects date-of-creation
                           "" nil 'system nil)
          (add-slot-system object 'instance-slots-list 'list-of-symbols date-of-creation
                           "" '(super metaclass instances instance-slots-list class-slots-list methodes-list 
                                      name method-inheritance-role pre-instanciation-demon post-instanciation-demon
                                      pre-instanciation-demon-inheritance-role post-instanciation-inheritance-role
                                      transparent-slot-list)
                           'system nil)
          (add-slot-system object 'class-slots-list 'list-of-symbols date-of-creation
                           "" '(super metaclass instances instance-slots-list class-slots-list methodes-list
                                      name method-inheritance-role pre-instanciation-demon post-instanciation-demon
                                      pre-instanciation-demon-inheritance-role post-instanciation-inheritance-role 
                                      transparent-slot-list) 
                           'system nil)
          (add-slot-system object 'instance-user-slots-list 'list-of-symbols date-of-creation
                           "" nil 'system nil)
          (add-slot-system object 'class-user-slots-list 'list-of-symbols date-of-creation
                           "" nil 'system nil)
          (add-slot-system object 'method-list 'symbol-and-symbols-or-lispforms-list date-of-creation 
                           ""  nil 'static-user nil)

          (add-slot-system object 'name 'symbol date-of-creation "the name of this object"
                           nil 'user nil)
          (add-slot-system object 'method-inheritance-role 'selected-symbol date-of-creation
                           "" 'superseeding-inheritance 'user nil)
          (add-slot-system object 'pre-instanciation-demon 'symbols-or-lispfoms-list date-of-creation 
                           "" nil 'user nil)
          (add-slot-system object 'pre-instanciation-demon-inheritance-role 'selected-symbol date-of-creation 
                           "" 'merging-inheritance 'user '(no-inheritance superseeding-inheritance 
                                                                          merging-inheritance))
          (add-slot-system object 'post-instanciation-demon 'symbols-or-lispfoms-list date-of-creation 
                           "" nil 'user nil)
          (add-slot-system object 'post-instanciation-demon-inheritance-role 'selected-symbol date-of-creation 
                           "" 'merging-inheritance 'user '(no-inheritance superseeding-inheritance 
                                                                          merging-inheritance))
          (add-slot-system object 'dynamic-inheritance-slot-list 'anything date-of-creation
                           "" nil 'system nil)
          (add-slot-system object 'expansion-slot 'anything date-of-creation
                           "" nil 'system nil)
          (add-slot-system object 'instance-number 'anything date-of-creation
                           "" 1 'system nil)
          (when metaobject
                (setf (get-fondamental-value metaobject 'instance-number) (1+ (get-fondamental-value metaobject 'instance-number))))
    
                                        ; si une metaclasse est donnee , double-chainage du lien de genericite
          (cond((neq metaobject nil) 
                (setf  (get-fondamental-value object 'metaclass) metaobject)
                (setf  (get-fondamental-value metaobject 'instances) 
                       (cons object (get-fondamental-value metaobject 'instances)))

                                        ; heritage des slot d'instance en slot de classe

                (inherit-slots object (list metaobject) 'class-user-slots-list 'meta)
                                        ; heritage du slot transparent-slot-list quand il existe
                (when (get-fondamental-value metaobject 'transparent-slot-list)
                      (add-slot-system object 'transparent-slot-list 'list-of-slots 'date-of-creation
                                       "" nil 'system nil)
                      (setf (get-fondamental-value object 'transparent-slot-list) 
                            (get-fondamental-value metaobject 'transparent-slot-list))
                      )))
            

                                        ; si des supertypes ont ete donnes , heritage des proprietes
          (when  superobjectlist

                 (inherit-slots object  superobjectlist  'class-user-slots-list 'super)
                 (inherit-slots object  superobjectlist  'instance-user-slots-list 'super)    
                 (inherit-methods object superobjectlist)
                 (inherit-instanciation-demons object superobjectlist) 
                   
                 (setq  *super-binding-list* (cons (cons object superobjectlist)  *super-binding-list*))
                 (setf (get-fondamental-value object 'supertypes) superobjectlist)
                 (mapc '(lambda (x) (setf (get-fondamental-value x 'subtypes) 
                                          (cons object (get-fondamental-value x 'subtypes))))
                       superobjectlist))
          (setq  *current-hypothetical-world* hyp-save)
                  
           
          ))



(de delete-object (object)
    (prog ()
          (when (get-fondamental-value object 'instances)
                (mapc '(lambda (x) (delete-object x))
                      (get-fondamental-value object 'instances)))
          (setf (get-fondamental-value (get-fondamental-value object 'metaclass) 'instances)
                (remq object (get-fondamental-value (get-fondamental-value object 'metaclass) 'instances)))
          (setq *object-list* (remq object *object-list*))
          (mapc  '(lambda (x) (setf (get-fondamental-value x 'subtypes)
                                    (remq object (get-fondamental-value x 'subtypes))))
                 (get-fondamental-value object 'supertypes))
          (remprop object 'object-property)
          (remprop object 'knowledge-base)
          (ftrace 9 (catenate " deleted ! : " object) nil nil) 
          ))
            
  
(de inherit-slots (object superobjectlist slotfacet link )   
    (prog (superlist obn slotlist slot nature t1 t2)
          (cond ((eq slotfacet 'class-user-slots-list)(setq nature 'class))
                ((eq slotfacet 'instance-user-slots-list)(setq nature 'instance)))
          (setq superlist superobjectlist)
          (setq obn (car superlist))
          (check-object 1 obn)
          loop
          (cond ((eq obn nil) (return)))
          (cond ((eq link 'super)
                 (setq slotlist (get-fondamental-value obn  slotfacet )))
                ((eq link 'meta)
                 (setq slotlist (get-fondamental-value obn  'instance-user-slots-list))))
          (setq slot (car slotlist))
          loop1
          (cond ((eq slot nil) (go  fin1)))

                                        ;si il n'y a pas lieu de faire d'heritage du slot

          (cond((eq (get-slot-facet-value obn slot 'structure-inheritance-role) 'no-inheritance) 
                (go fin)))

                                        ;l'heritage du slot 

                                        ;si le slot heritant existe

          (cond((or (setq t1 (memq slot (get-fondamental-value object 'class-user-slots-list)))
                    (setq t2 (memq slot (get-fondamental-value object 'instance-user-slots-list))))

                                        ;traitement des contraintes sur les slots

                (cond((eq (get-slot-facet-value obn slot 'constraint-inheritance-role)
                          'superseeding-inheritance)
                      (setf (get-slot-facet-value object slot 'constraint-list)
                            (get-slot-facet-value obn slot 'constraint-list)))
                     ((eq (get-slot-facet-value obn slot 'constraint-inheritance-role) 'merging-inheritance)
                      (setf (get-slot-facet-value object slot 'constraint-list)
                            (append-new (get-slot-facet-value obn slot 'constraint-list)
                                        (get-slot-facet-value object slot 'constraint-list)))))
                                        ;traitement des valeurs des slots
                  
                (cond((eq (get-slot-facet-value obn slot 'value-inheritance-role) 'superseeding-inheritance)
                      (setf (get-fondamental-value object slot)
                            (get-fondamental-value obn slot)))
                     ((and (or (null (get-slot-facet obn slot 'value-inheritance-role))
                               (eq (get-slot-facet-value obn slot 'value-inheritance-role) 'merging-inheritance))
                           (consp (get-fondamental-value obn slot))
                           (consp (get-fondamental-value object slot)))
                      (setf (get-fondamental-value object slot)
                            (append-new (get-fondamental-value obn slot)
                                        (get-fondamental-value object slot))))
                     ((and (or (null (get-slot-facet obn slot 'value-inheritance-role))
                               (eq (get-slot-facet-value obn slot 'value-inheritance-role) 'merging-inheritance))
                           (variablep (get-fondamental-value obn slot))
                           (consp (get-fondamental-value object slot)))
                      (setf (get-fondamental-value object slot)
                            (append-new (list (get-fondamental-value obn slot))
                                        (get-fondamental-value object slot))))
                     ((and (or (null (get-slot-facet obn slot 'value-inheritance-role))
                               (eq (get-slot-facet-value obn slot 'value-inheritance-role) 'merging-inheritance))
                           (consp (get-fondamental-value obn slot))
                           (variablep (get-fondamental-value object slot)))
                      (setf (get-fondamental-value object slot)
                            (append-new (list (get-fondamental-value object slot))
                                        (get-fondamental-value obn slot))))
                     ((and (or (null (get-slot-facet obn slot 'value-inheritance-role))
                               (eq (get-slot-facet-value obn slot 'value-inheritance-role) 'merging-inheritance))
                           (variablep (get-fondamental-value obn slot))
                           (variablep (get-fondamental-value object slot))
                           (neq (get-fondamental-value obn slot) (get-fondamental-value object slot)))
                      (setf (get-fondamental-value object slot)
                            (list (get-fondamental-value obn slot)
                                  (get-fondamental-value object slot))))
                     ((and (or (null (get-slot-facet obn slot 'value-inheritance-role))
                               (eq (get-slot-facet-value obn slot 'value-inheritance-role) 'merging-inheritance))
                           (variablep (get-fondamental-value obn slot))
                           (null (get-fondamental-value object slot)))
                      (setf (get-fondamental-value object slot)
                            (get-fondamental-value obn slot)))))

                                        ;si le slot n'existe pas on cree un nouveau slot

               (t  (cond ((eq link 'super)
                          (add-slot-user-copy obn slot object nature))
                         ((and (eq link 'meta)
                               t1 t2 )
                          (add-slot-user-copy obn slot object 'class-instance))
                         ((eq link 'meta)
                                 
                          (add-slot-user-copy obn slot object 'class)))))
    
                   

          fin
          (setq slotlist (cdr slotlist))
          (setq slot (car slotlist))
          (go loop1)
          fin1
          (setq superlist (cdr superlist))
          (setq obn (car superlist))
          (go loop)
          )))
                 
               
(de inherit-methods (object superobjectlist)
    (prog (superlist obn mlist m )
          (setq superlist superobjectlist)
          (setq obn (car superlist))
          loop
          (cond ((eq obn nil) (return)))

                                        ;boucle sur les methodes

          (setq mlist (get-method-list obn))
          (setq m  (car mlist))
          loop1
          (cond ((eq m nil) (go  fin1)))
                                        ;partie dure
          (setq method (car m))
          (setq objectmethod (get-method object method)) 

                                        ;si la methode existe deja on la wrappe ou on la superseed

          (cond ((neq objectmethod nil)
                     
                 (cond ((eq (get-fondamental-value obn 'method-inheritance-role) 'superseeding-inheritance)
                        (setf (get-method object method) 
                              (get-method obn method)))
                       ((eq (get-fondamental-value obn 'method-inheritance-role) 'merging-inheritance)
                        (setf (get-method object method) 
                              (append-new (get-method  obn method)  objectmethod)))))
                  
                   
                                        ;si la methode n'existe pas , on l'ajoute

                (t (setf (get-fondamental-value object 'method-list) 
                         (append-new (list (cons method (copy (get-method obn method))))
                                     (get-fondamental-value object 'method-list)))))
               
          (setq mlist (cdr mlist))
          (setq m (car mlist))
          (go loop1)
          fin1
          (setq superlist (cdr superlist))
          (setq obn (car superlist))
          (go loop)))
                


(de inherit-instanciation-demons (object superobjectlist)
    (prog (superlist obn )
          (setq superlist superobjectlist)
          (setq obn (car superlist))
          loop
          (cond ((eq obn nil) (return)))
                                        ;partie dure
          (cond ((eq (get-fondamental-value obn 'pre-instanciation-demon) 'superseeding-inheritance)
                 (setf (get-fondamental-value object 'pre-instanciation-demon) 
                       (get-fondamental-value obn 'pre-instanciation-demon)))
                ((eq (get-fondamental-value obn 'pre-instanciation-demon) 'merging-inheritance)
                 (setf (get-fondamental-value object 'pre-instanciation-demon) 
                       (append-new (get-fondamental-value obn 'pre-instanciation-demon)
                                   (get-fondamental-value object 'pre-instanciation-demon)))))
                     

          (cond ((eq (get-fondamental-value obn 'post-instanciation-demon) 'superseeding-inheritance)
                 (setf (get-fondamental-value object 'post-instanciation-demon) 
                       (get-fondamental-value obn 'post-instanciation-demon)))
                ((eq (get-fondamental-value obn 'post-instanciation-demon) 'merging-inheritance)
                 (setf (get-fondamental-value object 'post-instanciation-demon) 
                       (append-new (get-fondamental-value obn 'post-instanciation-demon)
                                   (get-fondamental-value object 'post-instanciation-demon)))))
                     
               


          (setq superlist (cdr superlist))
          (setq obn (car superlist))
          (go loop)))
                     



(de  get-slot-value (object slot) (cdr (cond((eq *current-hypothetical-world* 'fondamental) 
                                             (assoc 'fondamental 
                                                    (cdr (assoc 'value
                                                                (cdr (assoc slot 
                                                                            (get object 'object-property)))))))
                                            (t (assoc (handle-tree-priority object slot 'value)
                                                      (cdr (assoc 'value
                                                                  (cdr (assoc slot 
                                                                              (get object 'object-property))))))))))

(de hypothetical-get-slot-value (object slot world) (prog ((world-save *current-hypothetical-world*))
                                                          (setq *current-hypothetical-world* world)
                                                          (setq value (get-slot-value object slot))
                                                          (setq *current-hypothetical-world* world-save)
                                                          (return value)))


(defsetf hypothetical-get-slot-value (object slot world) (v) `(hypothetical-put-slot-value ,object ,slot ,world ,v))

(de hypothetical-put-slot-value (object slot world new-value)  (prog ((world-save *current-hypothetical-world*))
                                                                     (setq *current-hypothetical-world* world)
                                                                     (setf (get-slot-value object slot) new-value)
                                                                     (setq *current-hypothetical-world* world-save)
                                                                     (return)))
    


(defsetf get-slot-value (object slot) (v) `(put-slot-value ,object ,slot ,v))

(de put-slot-value (object slot v) (cond((eq *current-hypothetical-world* 'fondamental) 
                                         (rplacd (assoc 'fondamental 
                                                        (cdr (assoc 'value
                                                                    (cdr (assoc slot 
                                                                                (get object 'object-property)))))) v))
                                        ((assoc *current-hypothetical-world*  (get-slot-facet object slot 'value))
                                         (rplacd (assoc  *current-hypothetical-world*
                                                         (cdr (assoc 'value
                                                                     (cdr (assoc slot 
                                                                                 (get object 'object-property)))))) v))
                                        (t (setf (get-slot-facet object slot 'value)
                                                 (cons (cons *current-hypothetical-world* v)
                                                       (get-slot-facet object slot 'value))))))

(dmd  get-slot-world (object slot world) `(cdr (assoc ,world (cdr (assoc 'value
                                 (cdr (assoc ,slot (get ,object 'object-property)))))))) 


(dmd  get-slot-facet-aspect (object slot facet aspect) `(cdr (assoc ,aspect (cdr (assoc ,facet
                                (cdr (assoc ,slot (get ,object 'object-property))))))))

(dmd get-fondamental-value (object slot)  `(cdr (assoc 'fondamental (cdr (assoc 'value
                               (cdr (assoc ,slot (get ,object 'object-property))))))))


(dmd get-slot-facet (object slot facet) `(cdr (assoc ,facet (cdr (assoc ,slot 
                              (get ,object 'object-property))))))

(dmd get-slot  (object slot)   `(cdr (assoc ,slot (get ,object 'object-property))))


(de  get-slot-facet-value (object slot facet)  (cdr (cond((eq *current-hypothetical-world* 'fondamental) 
                                              (assoc 'fondamental 
                                                     (cdr (assoc facet
                                                                 (cdr (assoc slot 
                                                                             (get object 'object-property)))))))
                                             (t (assoc (handle-tree-priority object slot facet)
                                                     (cdr (assoc facet
                                                                 (cdr (assoc slot 
                                                                             (get object 'object-property))))))))))


(defsetf get-slot-facet-value (object slot facet) (v) `(put-slot-facet-value ,object ,slot ,facet ,v))

(de put-slot-facet-value (object slot facet v)
    (when (null (assoc facet
                       (cdr (assoc slot 
                                   (get object 'object-property)))))
          (setf (cdr (assoc slot 
                            (get object 'object-property)))
                (cons (cons facet (copy '((fondamental))) )
                      (cdr (assoc slot 
                                  (get object 'object-property))))))
                                                                
    (cond((eq *current-hypothetical-world* 'fondamental) 
          (rplacd (assoc 'fondamental 
                         (cdr (assoc facet
                                     (cdr (assoc slot 
                                                 (get object 'object-property)))))) v))
         ((assoc *current-hypothetical-world*  (get-slot-facet object slot facet))
          (rplacd (assoc  *current-hypothetical-world*
                          (cdr (assoc facet
                                      (cdr (assoc slot 
                                                  (get object 'object-property)))))) v))
         (t (setf (get-slot-facet object slot facet)
                  (cons (cons *current-hypothetical-world* v)
                        (get-slot-facet object slot facet))))))


(dmd  get-method (object method) `(cdr (assoc ,method (cdr (cond((eq *current-hypothetical-world* 'fondamental) 
                                              (assoc 'fondamental 
                                                     (cdr (assoc 'value
                                                                 (cdr (assoc 'method-list 
                                                                             (get ,object 'object-property)))))))
                                             (t (assoc (handle-tree-priority ,object 'method-list 'value)
                                                     (cdr (assoc 'value
                                                                 (cdr (assoc 'method-list
                                                                             (get ,object 'object-property))))))))))))





(dmd get-method-list (object) `(cdr (cond((eq *current-hypothetical-world* 'fondamental) 
                                              (assoc 'fondamental 
                                                     (cdr (assoc 'value
                                                                 (cdr (assoc 'method-list 
                                                                             (get ,object 'object-property)))))))
                                             (t (assoc (handle-tree-priority ,object 'method-list 'value)
                                                     (cdr (assoc 'value
                                                                 (cdr (assoc 'method-list
                                                                             (get ,object 'object-property))))))))))



(de handle-tree-priority (object slot facet)
    (prog((facetl (get-slot-facet object slot facet)) h-priority w)
         (when (assoc *current-hypothetical-world* facetl) (return *current-hypothetical-world*))
         (setq h-priority (cdr (assoc *current-hypothetical-world* *hypothetical-world-list*)))
       
         loop
         (when (null h-priority) 
               (return nil))
         (setq w (car h-priority))
         (when (assoc w facetl) (return w))
         (setq h-priority (cdr h-priority))
         (go loop)))

(de add-constraint (object slot constraint)
    (prog()
         (when (null (get-slot-facet object slot 'constraint-list))
                 (add-slot-facet object slot 'constraint-list nil)
                 (add-slot-facet object slot 'constraint-inheritance-role  'merging-inheritance))
         (setf (get-slot-facet-value object slot 'constraint-list)
                (append-new (get-slot-facet-value obn slot 'constraint-list)
                            (list constraint)))
         (return constraint)))


(de add-slot-facet 
    (object slot facet value )
              (setf   (cdr (assoc slot (get object 'object-property))) 
                  (acons facet nil   (cdr (assoc slot (get object 'object-property))))) 
                        (setf (get-slot-facet object slot facet) 
                                 (list (cons 'fondamental value))))
                
(de add-slot-facet-user 
    (object slot facet value )
    (check-object-slot 1 object slot)
            (setf   (cdr (assoc slot (get object 'object-property))) 
                  (acons facet nil   (cdr (assoc slot (get object 'object-property))))) 
            (setf (get-slot-facet object slot facet) 
                  (list (cons 'fondamental value)))
            (ftrace 9 (catenate " facet : "  slot "{" object "} <" facet ">") nil nil))  
                
(de add-slot-system
    (object slot p1 p2 p3 p4 p5 p6)

;p1 = type du slot
;p2 = la date de determination du slot (entier)
;p3 = string qui constitue la question a poser relative au slot
;p4 = la valeur par default du slot
;p5 = le niveau de modification autorise du slot (user , static-user ou system)
;p6 = la liste des valeurs autorisee pour le slot quand il y en a une

            (setf (get object 'object-property )(acons slot nil (get object 'object-property)))
            (add-slot-facet object slot 'value
                p4)
         ;   (add-slot-facet object slot 'constraint-list
         ;      nil )
         ;   (add-slot-facet object slot 'type  p1 )
         ;   (add-slot-facet object slot 'value-list  p6 )
         ;   (add-slot-facet object slot 'determined   t)
         ;   (add-slot-facet object slot 'keyword  t)
         ;   (add-slot-facet object slot 'determination-means  nil)
         ;   (add-slot-facet object slot 'determination-predicat nil)
         ;   (add-slot-facet object slot 'determination-date p2 )
         ;   (add-slot-facet object slot 'question-to-ask  p3)
         ;   (add-slot-facet object slot 'default  p4)
         ;   (add-slot-facet object slot 'contens-modification  p5)
            (add-slot-facet object slot 'existence-status  'system ))


(de add-slot-user
    (object slot nature)
    (check-object 2 object)
    (setf (get object 'object-property )(acons slot nil (get object 'object-property)))
    (cond ((memq nature '(class classinstance))
           (setf (get-fondamental-value object 'class-user-slots-list)
                 (cons slot (get-fondamental-value object 'class-user-slots-list))))
          ((memq nature '(classinstance instance))
           (setf (get-fondamental-value object 'instance-user-slots-list)
                 (cons slot (get-fondamental-value object 'instance-user-slots-list)))))
    (cond ((eq nature 'instance)
           (mapc '(lambda (x) (add-slot-user x slot 'class))
                 (get-fondamental-value object 'instances)))
          ((eq nature 'classinstance)
           (mapc '(lambda (x) (add-slot-user x slot 'classinstance))
                 (get-fondamental-value object 'instances))))
                  
    (add-slot-facet object slot 'value  nil )
                                        ;(add-slot-facet object slot 'type  'anything)
                                        ;(add-slot-facet object slot 'value-list nil)
                                        ;(add-slot-facet object slot 'constraint-list nil)
                                        ;(add-slot-facet object slot 'determined nil)
                                        ;(add-slot-facet object slot 'keyword nil)
                                        ;(add-slot-facet object slot 'determination-means nil)
                                        ;(add-slot-facet object slot 'determination-predicat 'standart-determination-predicat)
                                        ;(add-slot-facet object slot 'determination-date 0)
                                        ;(add-slot-facet object slot 'question-to-ask  nil)
                                        ;(add-slot-facet object slot 'default  nil )
                                        ;(add-slot-facet object slot 'link nil)
                                        ;(add-slot-facet object slot 'contens-modification 'user)
    (add-slot-facet object slot 'existence-status 'user)
                                        ;(add-slot-facet object slot 'read-demon nil)
                                        ;(add-slot-facet object slot 'read-demon-inheritance-role 'merge-after)
                                        ;(add-slot-facet object slot 'write-before-demon nil)
                                        ;(add-slot-facet object slot 'write-before-demon-inheritance-role 'merge-after)
                                        ;(add-slot-facet object slot 'write-after-demon nil)
                                        ;(add-slot-facet object slot 'write-after-demon-inheritance-role 'merge-after)
           
                                        ;(add-slot-facet object slot 'structure-inheritance-role  'inheritance)           
                                        ;(add-slot-facet object slot 'value-inheritance-role  'merging-inheritance)
                                        ;(add-slot-facet object slot 'constraint-inheritance-role  'merging-inheritance)
                                      
    (ftrace 9 (catenate " slot : " slot "{" object "} nature = " nature) nil nil) 
    (when (and (get-fondamental-value object 'metaclass)
               (eq nature 'instance))
          (mapc '(lambda (x) (add-slot-user x slot 'class))
                (get-fondamental-value object 'metaclass)))
    (when (and (get-fondamental-value object 'metaclass)
               (eq nature 'class-instance))
          (mapc '(lambda (x) (add-slot-user x slot 'class-instance))
                (get-fondamental-value object 'metaclass)))
    slot )

(de add-slot-user-copy
     (object-origin slot-origin object-goal nature)
     
     (setf (get object-goal 'object-property )
           (acons slot-origin nil (get object-goal 'object-property)))
     (setf (get-slot object-goal slot-origin)  
           (copy (get-slot object-origin slot-origin)))
     (cond ((eq nature 'class)
            (setf (get-fondamental-value object-goal 'class-user-slots-list)
                  (cons slot-origin (get-fondamental-value object-goal 'class-user-slots-list))))
           ((eq nature 'instance)
            (setf (get-fondamental-value object-goal 'instance-user-slots-list)
                  (cons slot-origin (get-fondamental-value object-goal 'instance-user-slots-list))))
           ((eq nature 'class-instance)
            (setf (get-fondamental-value object-goal 'instance-user-slots-list)
                  (cons slot-origin (get-fondamental-value object-goal 'instance-user-slots-list)))
            (setf (get-fondamental-value object-goal 'class-user-slots-list)
                  (cons slot-origin (get-fondamental-value object-goal 'class-user-slots-list)))
            )))
           


(de add-method (object method methodname way)

; way vaut 'merge-before , 'merge-after ou 'superseed
       (prog (objectmethod)
             (check-object 3 object)
             (setq objectmethod (get-method object methodname)) 

   ;si la methode existe deja on la wrappe ou on la superseed

              (cond ((neq objectmethod nil)          
                     (cond ((eq  way 'superseed)
                            (setf (get-method object methodname) 
                                  (list (copy method)) ))
                           ((eq way 'merge-before)
                            (setf (get-method object methodname 
) 
                                  (append-new  (list (copy method))
                                               objectmethod)))
                            ((eq way 'merge-after)
                            (setf (get-method object methodname 
) 
                                  (append-new  objectmethod
                                               (list (copy method)))))))
  ;si la methode n'existe pas , on l'ajoute

                    (t (setf (get-fondamental-value object 'method-list) 
                             (append-new (list (cons methodname (list (copy method))))
                                         (get-fondamental-value object 'method-list)  )))))
          (ftrace 9 (catenate " method : " object " $ " methodname " " way) nil nil)
             methodname) 

(de add-pre-instanciation-demon (object demon way)
; way vaut 'merge-before , 'merge-after ou 'superseed
       (prog (objectdemon)
             (check-object 4 object)
             (setq objectdemon (get-fondamental-value object 'pre-instanciation-demon)) 

   ;si la methode existe deja on la wrappe ou on la superseed

              (cond ((neq objectdemon nil)          
                     (cond ((eq  way 'superseed)
                            (setf (get-fondamental-value object 'pre-instanciation-demon) 
                                  (list (copy demon)) ))
                           ((eq way 'merge-before)
                            (setf (get-fondamental-value object 'pre-instanciation-demon) 
                                  (append-new (list (copy demon))
                                               objectdemon)))
                           ((eq way 'merge-after)
                            (setf (get-fondamental-value object 'pre-instanciation-demon) 
                                  (append-new  objectdemon
                                               (list (copy demon)))))))
  ;si le demon n'existe pas , on l'ajoute

                    (t (setf (get-fondamental-value object 'pre-instanciation-demon) 
                             (list (copy demon))
                                    ))))
                  (ftrace 9 (catenate " pre-instanciation demon : " object " " way) nil nil))
             
              


 (de add-post-instanciation-demon (object demon way)
; way vaut 'merge-before , 'merge-after ou 'superseed
        (prog (objectdemon)
              (check-object 5 object)
              (setq objectdemon  (get-fondamental-value object 'post-instanciation-demon)) 

   ;si le demon existe deja on le wrappe ou on le superseed

              (cond ((neq objectdemon nil)          
                     (cond ((eq  way 'superseed)
                            (setf (get-fondamental-value object 'post-instanciation-demon) 
                                  (list (copy demon)) ))
                           ((eq way 'merge-before)
                            (setf (get-fondamental-value object 'post-instanciation-demon) 
                                  (append-new (list (copy demon))
                                              objectdemon  )))
                           ((eq way 'merge-after)
                            (setf (get-fondamental-value object 'post-instanciation-demon) 
                                  (append-new  objectdemon
                                               (list (copy demon)) )))))
  ;si le demon n'existe pas , on l'ajoute

                    (t (setf (get-fondamental-value object 'post-instanciation-demon) 
                             (list (copy demon))
                                      ))))
                (ftrace 9 (catenate" post-instanciation demon : " object " " way) nil nil))



 (de add-read-demon (object slot demon way)
; way vaut 'merge-before , 'merge-after ou 'superseed
       (prog (objectdemon)
             (check-object-slot 2 object slot)
             (add-slot-facet object slot 'read-demon nil)
             (add-slot-facet object slot 'read-demon-inheritance-role 'merge-before)
             (mapc '(lambda (x) 
                      (add-slot-facet x slot 'read-demon nil)
                      (add-slot-facet x slot 'read-demon-inheritance-role 'merge-before))
                   (get-fondamental-value object 'instances))
             (setq objectdemon   (get-slot-facet-value object slot 'read-demon)) 

   ;si le demon existe deja on le wrappe ou on le superseed

              (cond ((neq objectdemon nil)          
                     (cond ((eq  way 'superseed)
                            (setf  (get-slot-facet-value object slot 'read-demon) 
                                  (list (copy demon)) ))
                           ((eq way 'merge-before)
                            (setf  (get-slot-facet-value object slot 'read-demon) 
                                  (append (list (copy demon))
                                               (copy objectdemon))))
                           ((eq way 'merge-after)
                            (setf  (get-slot-facet-value object slot 'read-demon) 
                                  (append  (copy objectdemon)
                                               (list (copy demon)))))))
  ;si le demon n'existe pas , on l'ajoute

                    (t (setf  (get-slot-facet-value object slot 'read-demon) 
                              (list (copy demon))
                                      ))))
                (ftrace 9 (catenate " read demon : " slot "{" object "}  " way) nil nil))


 
  (de add-write-before-demon (object slot demon way)
; way vaut 'merge-before , 'merge-after ou 'superseed
       (prog (objectdemon)
             (check-object-slot 3 object slot)
             (add-slot-facet object slot 'write-before-demon nil)
             (add-slot-facet object slot 'write-before-demon-inheritance-role 'merge-before)
             (mapc '(lambda (x) 
                      (add-slot-facet x slot 'write-before-demon nil)
                      (add-slot-facet x slot 'write-before-demon-inheritance-role 'merge-before))
                   (get-fondamental-value object 'instances))
             (setq objectdemon   (get-slot-facet-value object slot 'write-before-demon)) 

   ;si le demon existe deja on le wrappe ou on le superseed

              (cond ((neq objectdemon nil)          
                     (cond ((eq  way 'superseed)
                            (setf  (get-slot-facet-value object slot 'write-before-demon) 
                                  (list (copy demon)) ))
                           ((eq way 'merge-before)
                            (setf  (get-slot-facet-value object slot 'write-before-demon) 
                                  (append-new (list (copy demon))
                                               objectdemon)))
                             ((eq way 'merge-after)
                            (setf  (get-slot-facet-value object slot 'write-before-demon) 
                                  (append-new  objectdemon
                                               (list (copy demon)))))))
  ;si le demon n'existe pas , on l'ajoute

                    (t (setf  (get-slot-facet-value object slot 'write-before-demon) 
                              (list (copy demon))
                                      ))))
                (ftrace 9 (catenate " write-before demon : " slot "{" object "}  " way) nil nil))


 
  (de add-write-after-demon (object slot demon way)
; way vaut 'merge-before , 'merge-after ou 'superseed
        (prog (objectdemon)
              (check-object-slot 4 object slot)
              (add-slot-facet object slot 'write-after-demon nil)
              (add-slot-facet object slot 'write-after-demon-inheritance-role 'merge-before)
              (mapc '(lambda (x)  (add-slot-facet x slot 'write-after-demon nil)
                       (add-slot-facet x slot 'write-after-demon-inheritance-role 'merging-before))
                    (get-fondamental-value object 'instances))
              (setq objectdemon   (get-slot-facet-value object slot 'write-after-demon)) 
             
   ;si le demon existe deja on le wrappe ou on le superseed

              (cond ((neq objectdemon nil)          
                     (cond ((eq  way 'superseed)
                            (setf  (get-slot-facet-value object slot 'write-after-demon) 
                                  (list (copy demon)) ))
                           ((eq way 'merge-before)
                            (setf  (get-slot-facet-value object slot 'write-after-demon) 
                                  (append-new (list (copy demon))
                                               objectdemon)))
                           ((eq way 'merge-after)
                            (setf  (get-slot-facet-value object slot 'write-after-demon) 
                                  (append-new  objectdemon
                                               (list (copy demon)))))))
  ;si le demon n'existe pas , on l'ajoute

                    (t (setf  (get-slot-facet-value object slot 'write-after-demon) 
                              (list (copy demon))
                                      ))))
               (ftrace 9 (catenate " write-after demon : " slot "{" object "}  " way) nil nil))


 


(de append-new (suplist baselist)
         (prog (e slist baselistp)
               (setq slist suplist)
               (setq baselistp baselist)
               (setq e (car slist))
               loop
               (cond ((eq e nil) 
                      (return baselistp)))
               (cond ((variablep e)(cond ((memq e baselistp) nil)
                                         (t (setq baselistp (cons e baselistp)))))
                     ((consp e) (cond ((member e baselistp) nil)
                                      (t (setq baselistp (cons (copy e) baselistp))))))
               (setq slist (cdr slist))
               (setq e (car slist))
               (go loop)))

               



(de ask-for-value (object slot ask) (print ask slot "{" object "} :") (read))

(de standart-determination-predicat (object slot conclusion) t)

(de check-value-list-determination-predicat (object slot conclusion )
    (cond ((and (get-slot-facet object slot 'value-list)
                (member conclusion (get-slot-facet-value object slot 'value-list)) (list conclusion)))
          ((null (get-slot-facet object slot 'value-list)) t)
          ( t (message (list "la valeur doit etre choisie parmi :"  (get-slot-facet-value object slot 'value-list)))
               nil)))


          
(de message (txt)
    (print '*****************************)
    (print txt)
    (print '*****************************))
 
(de date-of-object-creation () (length *object-list*) )



 (de findname (object)

;trouve un nom pour la prochaine instance

     (implodech (append (explodech object) (cons '- (explodech (get-fondamental-value object 'instance-number))))))
      


(de instanciate (object superlist username)
     (prog (name super)
      (cond (username (setq name username) (set name name))
            (t(setq name (findname object))
              ))
      (cond ((variablep superlist) (setq super (list superlist)))
            ( t (setq super superlist)))
      (create-object name object super)
      (setf (get-fondamental-value name 'name) name)
      
      (return name)))


;voici maintenant les fonctions utilisateurs qui tiennent comptent des demons



(de user-instanciate (object username superlist) 
    (prog (pre-demon instance post-demon)
         (setq pre-demon (get-fondamental-value object 'pre-instanciation-demon))
         (cond ((neq pre-demon nil)
                (ftrace 10 (catenate " pre-demon d instance active sur :" object) nil nil)
                (mapcar  (lambda (fn)
                             (cond ((variablep fn)
                                    (funcall fn  object))
                                   ((consp fn )
                                    (funcall fn  object))))
                         pre-demon)))
         (setq instance (instanciate object superlist username))
         (setq post-demon (get-fondamental-value object 'post-instanciation-demon))
         (cond ((neq post-demon nil)
                (ftrace 10 (catenate " post-demon d instance active sur :" object) nil nil)
                (mapcar  (lambda (fn)
                             (cond ((variablep fn)
                                    (funcall fn  instance))
                                   ((consp fn )
                                    (funcall fn instance))))
                         post-demon)))
         (ftrace 9 (catenate " instanciation  : " object " " instance) nil nil)s 
         (return instance)
                ))

(de is-a (object1 metaobject2)
    (cond
     ( (member object1 (get-fondamental-value metaobject2 'instances))  t)
     (t (any '(lambda(x) (is-a object1 x))
             (get-fondamental-value metaobject2 'subtypes)))))

(de add-link (object1 slot1 object2 slot2 )
    (check-object-slot 5 object1 slot1)
    (check-object-slot 6 object2 slot2)
   (when (null (get-slot-facet object1 slot1 'link))
         (add-slot-facet object1 slot1 'link nil))
   (setf (get-slot-facet-value object1 slot1 'link)
          (list object2 slot2))
   (when (null (get-slot-facet object2 slot2 'link))
         (add-slot-facet object2 slot2 'link nil))
   (setf (get-slot-facet-value object2 slot2 'link)
          (list object1 slot1))
   (setf  (get-slot-value object1 slot1) object2)
   (setf  (get-slot-value object2 slot2) object1))

(de get-link (object slot)
    (check-object-slot 7 object slot)
   (get-slot-facet-value object slot 'link))


(de user-get-value (object slot)
  (prog (demon value )
        (check-object-slot 8 object slot)
         (setq demon (get-slot-facet-value object slot 'read-demon))
         (cond ((neq demon nil)
                (ftrace 11 (catenate " demon de lecture active sur :" slot "{" object "}") nil nil)
                (mapcar  (lambda (fn)
                             (cond ((variablep fn)
                                    (funcall fn  object slot))
                                   ((consp fn )
                                    (funcall fn  object slot))))
                         demon)))
         (return (get-slot-value object slot))
                ))


(de user-get-facet (object slot facet)
    (check-object-slot 9 object slot)
    (check-facet 1 object slot facet)
   (get-slot-facet-value object slot facet))


(de user-put-facet (object slot facet new-value)
      (prog (old-value)
            (check-object-slot 10 object slot)
    (when  (memq facet '(determined keyword
                         determination-means
                         determination-predicat
                         determination-date
                         question-to-ask))
           (when (null (get-slot-facet object slot 'determined))
                 (add-slot-facet object slot 'determined nil))
           (when (null (get-slot-facet object slot 'keyword))
                 (add-slot-facet object slot 'keyword nil))
           (when (null (get-slot-facet object slot 'determination-means))
                 (add-slot-facet object slot 'determination-means nil))
           (when (null (get-slot-facet object slot 'determination-predicat))
                 (add-slot-facet object slot 'determination-predicat 
                                 'standart-determination-predicat))
           (when (null (get-slot-facet object slot 'determination-date))
                 (add-slot-facet object slot 'determination-date nil))
           (when (null (get-slot-facet object slot 'question-to-ask))
                 (add-slot-facet object slot 'question-to-ask nil)))
    (check-facet 2 object slot facet)
    (cond ((memq slot '(super metaclass 
       instances instance-slots-list class-slots-list methodes-list
       name method-inheritance-role pre-instanciation-demon post-instanciation-demon
      pre-instanciation-demon-inheritance-role post-instanciation-inheritance-role ))
                                        (cerror 1  "slot interdit au put :" slot)
                                        (return (get-slot-value object slot)))
                 ((memq facet '(determined  keyword contens-modification existence-status))
                  (cerror 2 "facet de slot interdit au put" (list slot facet))
                  (return (get-slot-facet-value object slot facet)))
                 ( t (setq old-value (get-slot-facet-value object slot facet))
                     (setf (get-slot-facet-value object slot facet)
                           new-value)
                     (return old-value)))))

(defsetf user-get-value (object slot) (v) `(user-put-value ,object ,slot ,v))

            
(de user-put-value (object slot new-value)
    (prog (pre-demon old-value post-demon spy1 spy2 inter dyn1 dyn2 x-list)
       (check-object-slot 11 object slot)
          (cond ((memq slot '(super metaclass 
                                    instances instance-slots-list class-slots-list methodes-list
                                    name method-inheritance-role pre-instanciation-demon post-instanciation-demon
                                    pre-instanciation-demon-inheritance-role post-instanciation-inheritance-role ))
                 (cerror 3 "slot interdit au put :" slot)
                 (return (get-slot-value object slot))))
          (setq pre-demon (get-slot-facet-value object slot  'write-before-demon))
          (cond ((neq pre-demon nil)
                 (ftrace 11 (catenate " pre-demon d ecriture active sur :" slot "{" object "}") nil nil)
                 (mapcar  (lambda (fn)
                            (cond ((variablep fn)
                                   (funcall fn  object slot))
                                  ((consp fn )
                                   (funcall fn  object slot))))
                          pre-demon)))
          (setq old-value (get-slot-value object slot))
                                        ; activation des situation-bloc
          (setq  spy1 (assoc slot (cdr(assoc (get-fondamental-value object 'metaclass) *slot-to-spy-list*))))
          (setq  spy2 (assoc slot (cdr(assoc object  *slot-to-spy-list*))))
                                
          (when  (and spy1 (eq (car spy1) slot))
                 (mapc '(lambda (x) (when (eq (cadr x) 'metaclass) 
                                          ($ (car x) 'check-condition object slot old-value new-value)))
                       (cdr spy1)))
          (when  (and spy2 (eq (car spy2) slot))
                 (mapc '(lambda (x) (when (eq (cadr x) 'instance) 
                                          ($ (car x) 'check-condition object slot old-value new-value)))
                       (cdr spy2)))
          (setf (get-slot-value object slot )
                new-value)
   
                                        ; heritage dynamique de valeurs
        
          (setq  dyn (cdr (assoc slot (cdr(assoc object  *dynamic-inheritance-slot-list* )))))
        
          (when   dyn    
                  (mapc '(lambda (x) (when (and (eq (car x) 'instance)
                                                (eq (cadddr x) 'metaclass) )
                                          
                                           (setq slot-list1 (get-fondamental-value (cadr x) 'instances))
                                        
                                           (mapc '(lambda (y)  ($ y 'put-value (caddr x)  new-value))
                                                 slot-list1))
                           (when (and (eq (car x) 'instance)
                                      (eq (cadddr x) 'instance) )
                                 ($ (cadr x) 'put-value (caddr x) new-value)))
                        dyn)) 
        
          (when (and (eq object (car (get-fondamental-value (get-fondamental-value object 'metaclass) 'instances)))
                     (setq dyn  (cdr (assoc slot (cdr(assoc (get-fondamental-value object 'metaclass) 
                                                            *dynamic-inheritance-slot-list* )))))
                   
                     )
                (mapc '(lambda (x) (when (and (eq (cadddr x) 'metaclass) 
                                              (eq (car x) 'metaclass))
                                         (setq slot-list1 (get-fondamental-value (cadr x) 'instances))
                                         (mapc '(lambda (y)  ($ y 'put-value (caddr x)  new-value))
                                               slot-list1))
                         (when (and (eq (cadddr x) 'instance)
                                    (eq (car x) 'metaclass))
                               ($ (cadr x) 'put-value (caddr x) new-value)))
                      dyn)
                (setq  dyn (cdr (assoc slot (cdr(assoc object  *dynamic-inheritance-slot-list* )))))
                
                (when   dyn                 
                        (mapc '(lambda (x) (when (and (eq (car x) 'instance)
                                                      (eq (cadddr x) 'metaclass) )
                                          
                                                 (setq slot-list1 (get-fondamental-value (cadr x) 'instances))
                                                
                                                 (mapc '(lambda (y)  ($ y 'put-value (caddr x)  new-value))
                                                       slot-list1))
                                 (when (and (eq (car x) 'instance)
                                            (eq (cadddr x) 'instance) )
                                       ($ (cadr x) 'put-value (caddr x) new-value)))
                              dyn)))
                                  ;traitement des write-after-demons
          (setq post-demon (get-slot-facet-value object slot 'write-after-demon))
          (cond ((neq post-demon nil)
                 (ftrace 11 (catenate " post-demon d ecriture active sur :" slot "{" object "}") nil nil)
                 (mapcar  (lambda (fn)
                            (cond ((variablep fn)
                                   (funcall fn  object slot))
                                  ((consp fn )
                                   (funcall fn object slot))))
                          post-demon)))
          (let (k) 
            (if (and *what-to-answer*
                     (setq k (get-slot-facet-value object slot 'keyword))
                     (memq k *what-to-answer*)
                     *where-to-answer*)
                (new-trace-file (list k '= new-value) *where-to-answer* nil)))
          (return old-value))))))

            
(de user-add-value (object slot new-value)
    (prog (pre-demon old-value post-demon spy1 sp2 inter dyn1 dyn2)
          (check-object-slot 12 object slot)
          (cond ((memq slot '(super metaclass 
                                        instances instance-slots-list class-slots-list methodes-list
                                        name method-inheritance-role pre-instanciation-demon post-instanciation-demon
                                        pre-instanciation-demon-inheritance-role post-instanciation-inheritance-role ))
                     (cerror 4  "slot interdit au put :" slot)
                     (return (get-slot-value object slot))))
              (setq pre-demon (get-slot-facet-value object slot  'write-before-demon))
              (cond ((neq pre-demon nil)
                     (mapcar  (lambda (fn)
                                (cond ((variablep fn)
                                       (funcall fn  object slot))
                                      ((consp fn )
                                       (funcall fn  object slot))))
                              pre-demon)))
              (setq  spy1 (assoc slot (cdr(assoc (get-fondamental-value object 'metaclass) *slot-to-spy-list*))))
              (setq  spy2 (assoc slot (cdr(assoc object  *slot-to-spy-list*))))
                                        ; activation des situation-bloc
              (when  (and spy1 (eq (car spy1) slot))
                     (mapc '(lambda (x) (when (eq (cadr x) 'metaclass) 
                                              ($ (car x) 'check-condition object slot old-value new-value)))
                           (cdr spy1)))
              (when  (and spy2 (eq (car spy2) slot))
                     (mapc '(lambda (x) (when (eq (cadr x) 'instance) 
                                              ($ (car x) 'check-condition object slot old-value new-value)))
                           (cdr spy2)))
              (setq old-value (get-slot-value object slot))
              (cond((null old-value) (setf (get-slot-value object slot )  (list new-value)))
                   ;((variablep old-value)  (setf (get-slot-value object slot )  (list old-value new-value)))
                   ;  ((and (consp old-value) (member new-value old-value) ))
                   ;  ((consp old-value) (setf (get-slot-value object slot ) (cons new-value old-value)))
                   (t  (setf (get-slot-value object slot ) (cons new-value old-value))))
              (setq new-value (get-slot-value object slot))
     
              
                                              ; heritage dynamique de valeurs
           (setq  dyn1 (assoc slot (cdr(assoc (get-fondamental-value object 'metaclass) *dynamic-inheritance-slot-list*))))
           (setq  dyn2 (assoc slot (cdr(assoc object  *dynamic-inheritance-slot-list* ))))
                                         
          (when  (and dyn1 (eq (car dyn1) slot))
                 (mapc '(lambda (x) (when (eq (caddr x) 'metaclass) 
                                          ($ (car x) 'put-value (cadr x)  new-value)))
                       (cdr dyn1)))
          (when  (and dyn2 (eq (car dyn2) slot))
                 (mapc '(lambda (x) (when (eq (caddr x) 'instance) 
                                          ($ (car x) 'put-value (cadr x) new-value)))
                       (cdr dyn2)))
        
                
              (setq post-demon (get-slot-facet-value object slot 'write-after-demon))
              (cond ((neq post-demon nil)
                     (mapcar  (lambda (fn)
                                (cond ((variablep fn)
                                       (funcall fn  object slot))
                                      ((consp fn )
                                       (funcall fn object slot))))
                              post-demon)))
               (let (k)
                 (if  (and *what-to-answer*
                           (setq k (get-slot-facet-value object slot 'keyword))
                           (memq k *what-to-answer*)
                           *where-to-answer*)
                     (new-trace-file (list k '= new-value) *where-to-answer* nil)))
               (return old-value)
              ))



(de user-send-method (object message arglist)
                                        ;cherche une methode dans l'object ou la metaclasse de l'object
    (prog  (methodobject metaclass metametaclass couple transparent-slots object-method)
           (check-object 6 object)
           (cond ( (setq methodobject (get-method object message))
                   (return (car (last (mapcar  (lambda (fn)
                                                 (cond ((variablep fn)
                                                        (apply fn  object arglist))
                                                       ((consp fn )
                                                        (apply fn  object arglist))))
                                               methodobject)))))
                 ( (setq metaclass (get-fondamental-value object 'metaclass))
                   (cond ( (and metaclass (setq methodobject (get-method  metaclass message)))
                           (return (car (last (mapcar  (lambda (fn)
                                                         (cond ((variablep fn)
                                                                (apply fn  object arglist))
                                                               ((consp fn )
                                                                (apply fn  object arglist))))
                                                       methodobject)))))
                         ( (setq metametaclass (get-fondamental-value metaclass  'metaclass))
                           (setq couple  (user-send-method-1 metametaclass object message arglist))
                           (cond ((car couple) (return (cadr couple)))
                                 ( (and (setq transparent-slots (get-fondamental-value object 'transparent-slot-list))
                                        (setq object-method (any '(lambda (x) 
                                                                    (find-object-method (get-slot-value object x) message))
                                                                 transparent-slots)))
                                   (return (car (last (mapcar  (lambda (fn)
                                                                 (cond ((variablep fn)
                                                                        (apply fn  (car object-method) arglist))
                                                                       ((consp fn )
                                                                        (apply fn  (car object-method) arglist))))
                                                               (cadr object-method))))))
                                 (t (cerror 5  "methode non trouvee (meme au dela de la meta-metaclass) :"
                                            (list object  message)))))
                         ( (and  (setq transparent-slots (get-fondamental-value object 'transparent-slot-list))
                                (setq object-method (any '(lambda (x) 
                                                            (find-object-method (get-slot-value object x) message))
                                                         transparent-slots)))
                           (return (car (last (mapcar  (lambda (fn)
                                                         (cond ((variablep fn)
                                                                (apply fn  (car object-method) arglist))
                                                               ((consp fn )
                                                                (apply fn  (car object-method) arglist))))
                                                       (cadr object-method))))))
                         (t (cerror 6  "methode non trouvee (pas de meta-metaclass):" (list object  message)))))
                 ( (and (setq transparent-slots (get-fondamental-value object 'transparent-slot-list)) 
                        (setq object-method (any '(lambda (x) 
                                                    (find-object-method (get-slot-value object x) message))
                                                 transparent-slots)))
                   (return (car (last (mapcar  (lambda (fn)
                                                 (cond ((variablep fn)
                                                        (apply fn  (car object-method) arglist))
                                                       ((consp fn )
                                                        (apply fn  (car object-method) arglist))))
                                               (cadr object-method))))))
                 (t (cerror 7  "methode non trouvee (pas de metaclass): " (list object  message)))))))
 

     
    (de user-send-method-1 (metaclass object message argumentlist)
              
                                        ; cherche une methode en remontant l arbre des metaclasses recursivement

        (prog (methodobject metametaclass)
              (cond ( (and metaclass (setq methodobject (get-method  metaclass message)))
                      (return (cons t (last (mapcar  (lambda (fn)
                                                       (cond ((variablep fn)
                                                              (apply fn  object argumentlist))
                                                             ((consp fn )
                                                              (apply fn  object argumentlist))))
                                                     methodobject)))))
                    ( (and metaclass  (setq metametaclass (get-fondamental-value metaclass 'metaclass)))
                      (return (user-send-method-1 metametaclass object message argumentlist)))
                    (t (return (list nil nil)))
                    )



              loop
              (cond ((null meanlist) (return result)))
              (setq mean (car meanlist))
              (setq couple ($ object 'try-to-determine slot))
              (cond ( (car couple) (setq result (cons (cadr couple) result))))
              (setq meanlist (cdr meanlist))
              (go loop)))

                                        ; tous les moyens de recherche sauf la question directe sont exploite pour
                                        ; fournir la liste de tous les valeurs ,  c est a dire la liste de tout les cadr des listes retournee
                                        ; dont le car est different de nil


(de find-object-method (object message)
    ;retourne un couple (object methode) qui est directement executable
        (prog  (methodobject metaclass)
               (when (null object) (return nil))
            (check-object 7 object)
               (cond ( (setq methodobject (get-method object message))
                       (return (list object methodobject)))
                     ( (setq metaclass (get-fondamental-value object 'metaclass))
                       (cond ( (and metaclass (setq methodobject (get-method  metaclass message)))
                               (return (list object methodobject)))
                             (t (return nil))))
                     (t (return nil)))))


    (dmd sendc (object message . argumentlist)  (cond (argumentlist 
                                                       `(user-send-method ,object ,message  (quote ,argumentlist)))
                                                      (t `(user-send-method ,object ,message ()))))
(dmd $ (object message . argumentlist)
(cond  ((and (equal message ''get-value)
             (equal (length argumentlist) 1))
        `(user-get-value ,object ,(car argumentlist)))
       ((and (equal message ''put-value)
             (equal (length argumentlist) 2))
        `(user-put-value ,object ,(car argumentlist) ,(cadr argumentlist)))
       ((equal message ''expand)
        `(expand-object ,object ,(car argumentlist) ,(cons 'list (cdr argumentlist))))
       ((equal message ''instanciate)
        `(user-instanciate ,object ,(car argumentlist) ,(cadr argumentlist)))
       ((or (equal message ''get-value)                                               
            (equal message ''put-value))
        (cerror 8 "mauvais nombre d'argument" (list object message argumentlist)))
 
       (argumentlist 
        `(user-send-method ,object ,message  ,(cons 'list argumentlist)))
       (t `(user-send-method ,object ,message ()))))



    (de initialize-object (object listofdoublet) (prog (doublet listd)
                                                       (setq listd listofdoublet)
                                                       loop
                                                       (cond ((null listd) (return)))
                                                       (setq doublet (car listd))
                                                       (setq listd (cdr listd))
                                                       (setf (get-slot-value object (car doublet)) (cadr doublet))
                                                       (go loop)))

    (de initialize-slot (object slot listofdoublet) (prog (doublet listd)
                                                       (setq listd listofdoublet)
                                                       loop
                                                       (cond ((null listd) (return)))
                                                       (setq doublet (car listd))
                                                       (setq listd (cdr listd))
                                                       (when (null (get-slot-facet object slot (car doublet)))
                                                             (add-slot-facet object slot (car doublet) nil))
                                                       (setf (get-slot-facet-value object slot (car doublet)) (cadr doublet))
                                                       (when (memq (car doublet) '(determined 
                                                                                   keyword
                                                                                   determination-means
                                                                                   determination-predicat
                                                                                   determination-date
                                                                                   question-to-ask))
                                                             (when (null (get-slot-facet object slot 'determined))
                                                                   (add-slot-facet object slot 'determined nil))
                                                             (when (null (get-slot-facet object slot 'keyword))
                                                                   (add-slot-facet object slot 'keyword nil))
                                                             (when (null (get-slot-facet object slot 'determination-means))
                                                                   (add-slot-facet object slot 'determination-means nil))
                                                             (when (null (get-slot-facet object slot 'determination-predicat))
                                                                   (add-slot-facet object slot 'determination-predicat 
                                                                                   'standart-determination-predicat))
                                                             (when (null (get-slot-facet object slot 'determination-date))
                                                                   (add-slot-facet object slot 'determination-date nil))
                                                             (when (null (get-slot-facet object slot 'question-to-ask))
                                                                   (add-slot-facet object slot 'question-to-ask nil)))
                                                     
                                                            
                                                             
                                                       (go loop)))
   
(de set-determination-slot (object slot-list)
    (prog (slot-list-p)
          (cond ((atom slot-list) (setq slot-list-p (list slot-list)))
                (t (setq slot-list-p slot-list)))
          (mapc '(lambda (slot) (when (null (get-slot-facet object slot 'determined))
                                      (add-slot-facet object slot 'determined nil))
                                (when (null (get-slot-facet object slot 'keyword))
                                      (add-slot-facet object slot 'keyword nil))
                                (when (null (get-slot-facet object slot 'determination-means))
                                      (add-slot-facet object slot 'determination-means nil))
                                (when (null (get-slot-facet object slot 'determination-predicat))
                                      (add-slot-facet object slot 'determination-predicat 
                                                      'standart-determination-predicat))
                                (when (null (get-slot-facet object slot 'determination-date))
                                      (add-slot-facet object slot 'determination-date nil))
                                (when (null (get-slot-facet object slot 'question-to-ask))
                                      (add-slot-facet object slot 'question-to-ask nil)))
                slot-list-p)))

(de set-determination-slot-for-a-mean (object slot-list mean)
    (prog (slot-list-p)
          (cond ((atom slot-list) (setq slot-list-p (list slot-list)))
                (t (setq slot-list-p slot-list)))
          (mapc '(lambda (slot) (when (null (get-slot-facet object slot 'determined))
                                      (add-slot-facet object slot 'determined nil))
                                (when (null (get-slot-facet object slot 'keyword))
                                      (add-slot-facet object slot 'keyword nil))
                                (when (null (get-slot-facet object slot 'determination-means))
                                      (add-slot-facet object slot 'determination-means (list mean)))
                                (when (null (get-slot-facet object slot 'determination-predicat))
                                      (add-slot-facet object slot 'determination-predicat 
                                                      'standart-determination-predicat))
                                (when (null (get-slot-facet object slot 'determination-date))
                                      (add-slot-facet object slot 'determination-date nil))
                                (when (null (get-slot-facet object slot 'question-to-ask))
                                      (add-slot-facet object slot 'question-to-ask nil)))
                slot-list-p)))

(de set-transparent-object (object slot-list)
    (when (not (get-slot object 'transparent-slot-list))
          (add-slot-system object 'transparent-slot-list 'anything 0
                             "" 1 'system nil) )
    (setf (get-fondamental-value object 'transparent-slot-list ) slot-list))


(de declare-slot-type (object slot slot-type value-list)
    (when (null (get-slot-facet object slot 'type))
          (add-slot-facet object slot 'type nil))
    (setf (get-slot-facet-value object slot 'type)
          slot-type)
    (when (null (get-slot-facet object slot 'value-list))
              (add-slot-facet object slot 'value-list nil))
    (setf (get-slot-facet-value object slot 'value-list)
          value-list))

(de undetermine (object slot)
    (when *explanation-flag* (trace-main-events (list 7 *current-hypothetical-world* object slot)))
    (when (null (get-slot-facet object slot 'determined))
          (add-slot-facet object slot 'determined nil))
    (setf (get-slot-facet-value object slot 'determined) nil))

(de determine-slot-value (object slot )
    (prog (predicat  conclusion verification determean mean oldback value forme bi-conclusion)
          (setq value (user-get-value object slot))
          (when (eq (get-slot-facet-value object slot 'determined) t) (return value))
          (setq determean (get-slot-facet-value object slot 'determination-means))
          (setq oldback *backward-chaining-state*)
          (setq *backward-chaining-state* 'external-backward-chaining)
          (check-object-slot 13 object slot)
          (setq determean (get-slot-facet-value object slot 'determination-means))
          (setq predicat (get-slot-facet-value object slot 'determination-predicat))
          (ftrace 3 (list "debut de determination generale de " slot "{" object "}")
                  (list "moyens de determination :" determean)
                  (list "predicat de verification de resultat :" predicat))
          loop

          (cond((null determean)
                (cond ((null *files-of-data*)
                       (setq conclusion
                             (prog (reponse ask)
                                   (setq ask (get-slot-facet-value object slot 'question-to-ask))
                                   (when (null ask) (return (get-slot-value object slot)))
                                   loop1
                                   (setq reponse
                                         (ask-for-value  object slot ask))
                                   (setq verification (funcall predicat object slot reponse))
                                   (when (null verification) (message "cette reponse n est pas valable")
                                         (go loop1))
                                   (setq *backward-chaining-state* oldback)
                                   (return reponse))))
                      ((null *files-of-data-charged-?*)

                       (when (atom *files-of-data*)
                             (setq *files-of-data* (list *files-of-data*)))
                       (mapc '(lambda (ffile)
                                (setq chan (openi  (string ffile)))
                                (setq savechan (inchan))
                                (inchan chan)
                                (untilexit eof 
                                           (setq forme (read))
                                           (cond ((memq (cadr forme) '(=))
                                                  (setq *contens-of-files-of-data*
                                                        (cons (list (car forme) (caddr forme))  *contens-of-files-of-data*)))
                                                 )
                                           )
                                (inchan savechan )
                                )
                             *files-of-data*)
                       (setq *files-of-data-charged-?* t)
                       (setq bi-conclusion (prog (local-forme key)
                                                 (setq key (get-slot-facet-value object slot 'keyword))
                                                 (cond (key (setq local-forme (assq key  *contens-of-files-of-data*))
                                                            (when local-forme (return (list t (eval (cadr local-forme))))))
                                                       (t (return)))
                                                 (return)))
                       (cond (bi-conclusion (setq conclusion (cadr bi-conclusion)))
                             (t (setq conclusion  (prog (reponse ask)
                                                        (setq ask (get-slot-facet-value object slot 'question-to-ask))
                                                        (when (null ask) (return (get-slot-value object slot)))
                                                        loop1
                                                        (setq reponse
                                                              (ask-for-value  object slot ask))
                                                        (setq verification (funcall predicat object slot reponse))
                                                        (when (null verification) (message "cette reponse n est pas valable")
                                                              (go loop1))
                                                        (setq *backward-chaining-state* oldback)
                                                        (return reponse))))))
                      
                      (*files-of-data-charged-?*
                       (setq bi-conclusion (prog (local-forme key)
                                                 (setq key (get-slot-facet-value object slot 'keyword))
                                                 (cond (key (setq local-forme (assq key  *contens-of-files-of-data*))
                                                            (when local-forme (return (list t (eval (cadr local-forme))))))
                                                       (t (return)))
                                                 (return)))
                       (cond (bi-conclusion (setq conclusion (cadr bi-conclusion)))
                             (t (setq conclusion  (prog (reponse ask)
                                                        (setq ask (get-slot-facet-value object slot 'question-to-ask))
                                                        (when (null ask) (return (get-slot-value object slot)))
                                                        loop1
                                                        (setq reponse
                                                              (ask-for-value  object slot ask))
                                                        (setq verification (funcall predicat object slot reponse))
                                                        (when (null verification) (message "cette reponse n est pas valable")
                                                              (go loop1))
                                                        (setq *backward-chaining-state* oldback)
                                                        (return reponse))))))
                      )
                
                (setq *backward-chaining-state* oldback)
                (ftrace 4 (catenate "il a ete conclu que " slot "{" object "} = " ) conclusion nil)
                (user-put-value object slot conclusion)
                (setf (get-slot-facet-value object slot 'determined) t)
                (let (k)
                  (if (and *what-to-answer*
                           (setq k (get-slot-facet-value object slot 'keyword))
                           (memq k *what-to-answer*)
                           *where-to-answer*)
                      (new-trace-file (list k '= conclusion) *where-to-answer* nil)))
                (return conclusion))
               ((variablep determean)
                (setq determean (list determean))))                 
          (setq mean (car determean))
          (setq conclusion ($ mean 'determine object slot))
          (setq verification (funcall predicat object slot conclusion))
          (cond((eq verification t)
                ;(setf (get-slot-value object slot) conclusion)
                (user-put-value object slot conclusion)
                (setf (get-slot-facet-value object slot 'determined) t)
                (setq *backward-chaining-state* oldback)
                (let (k) (if (and *what-to-answer*
                                  (setq k (get-slot-facet-value object slot 'keyword))
                                  (memq k *what-to-answer*)
                                  *where-to-answer*)
                             (new-trace-file (list k '= conclusion) *where-to-answer* nil)))
                (return conclusion)))
          (setq mean (cdr determean))
          (go loop)))




; le slot determination-means contient une liste d'object qui sont des instances de determination-mean
; ou  des fonctions prenant en argument :(object slot).
;le slot est marque determine si un moyen de determination a retourne une liste dont le premier
; argument est different de nil , le slot est alors positionne au second element de la liste





(de add-forward-chainer (name slot-list)
    (check-defined-object 2 name)
    (user-instanciate 'forward-chainer name nil)
    (mapc '(lambda (x)
             (add-slot-user name x 'class))
          slot-list)
    (set name name)
    name)


(de add-backward-chainer (name slot-list)
    (user-instanciate 'backward-chainer name nil)
    (mapc '(lambda (x)
             (add-slot-user name x 'class))
          slot-list)
    (set name name)
    name)





(de create-hypothetical-world (sequence-list)
    (prog (hyp hyp-list sequence sequence-list-1 hypothetical-world-save current-hypothetical-list  ante-backtracker bhw)
          (setq bhw (get-slot-value *current-forward-chainer-object* 'basic-hypothetical-world))
          (setq sequence-list-1 sequence-list)
          (setq hypothetical-world-save *current-hypothetical-world*)
          (setq ante-backtracker (ante-backtracker))
          (setq current-hypothetical-list (assoc *current-hypothetical-world* *hypothetical-world-list*))
          loop
          (when (null sequence-list-1) (go fin))
          (setq sequence (car sequence-list-1))
          (setq sequence-list-1 (cdr sequence-list-1))
          (setq hyp ($ hypothetical-world 'instanciate nil nil))
          (setf (get-fondamental-value hyp 'parent-world )  *current-hypothetical-world*)
          (setf (get-fondamental-value *current-hypothetical-world* 'children-worlds) 
                (cons hyp (copy (get-fondamental-value *current-hypothetical-world* 'children-worlds))))
          (setf (get-fondamental-value hyp 'initialisation-sequence) sequence)
          (setq hyp-list (cons hyp hyp-list))
          (setf (get-fondamental-value hyp 'parent-backtracker) ante-backtracker)
          (setq  *hypothetical-world-list* (cons (cons hyp current-hypothetical-list)  *hypothetical-world-list*))

    ; on positionne les nouvelles creations de monde dans le cadre du monde qui a lance le chainage avant

          (setf (get-slot-facet-aspect *current-forward-chainer-object* 
                                       'current-supplementary-hypothetical-world-sequence
                                       'value
                                       bhw )
               (cons hyp (get-slot-facet-aspect *current-forward-chainer-object*
                                                'current-supplementary-hypothetical-world-sequence
                                                'value
                                                bhw )))
                      

          (setq *current-hypothetical-world* hyp)
          (eval sequence)
          (setq *current-hypothetical-world*  hypothetical-world-save)
          (go loop)
          fin
          (setf (get-slot-facet-aspect *current-forward-chainer-object* 
                                       'current-supplementary-hypothetical-world-sequence
                                       'value
                                       bhw )
                (reverse (get-slot-facet-aspect *current-forward-chainer-object* 
                                       'current-supplementary-hypothetical-world-sequence
                                       'value
                                       bhw )))
          (setf (get-fondamental-value *current-hypothetical-world* 'children-worlds) 
                (reverse (get-fondamental-value *current-hypothetical-world* 'children-worlds) ))
          (setq hyp-list (reverse hyp-list))
          (when *explanation-flag* (trace-main-events (list 5 *current-hypothetical-world* hyp-list)))
          (ftrace 1 (catenate "activation de " (list-string hyp-list) " au lieu de " hypothetical-world-save) nil nil)
          (return hyp-list)))
          
   
(de list-string (lst)
    (cond((null lst) "")
         (t (catenate (string (car lst)) (list-string (cdr lst))))))


      
(de create-possibilities (sequence-list  best-function point-name subhypothesis)

 ; sequence-list est une liste de forme-lisp qui seront evalues dans les mondes crees successivement comme liste
 ; d hypotheses de travail , si cette liste est nulle  , la fonction best-function sera prise comme
 ; une fonction qui verifie la validite de la nouvelle hypothese et effectue les evaluations correspondantes
 ; au contraire du cas precedent qui suppose decrite dans sequence-list les formes a evaluer.

 ; subhypothesis est soit nil soit une sous-classe de la classe hypothetical-world contenant
 ; par exemple des slots ou des messages supplementaires.

    (prog (hyp hyp-list sequence sequence-list-1 hypothetical-world-save current-hypothetical-list backtrack super-hyp)
          (when (null sequence-list) (go find-next-case))
          (setq sequence-list-1 sequence-list)
          (setq hypothetical-world-save *current-hypothetical-world*)
          (setq current-hypothetical-list (assoc *current-hypothetical-world* *hypothetical-world-list*))
                                        ;on traite comme un monde particulier la premiere possibilite
          (when (null sequence-list-1) (go fin))
          (setq sequence (car sequence-list-1))
          (cond (subhypothesis
                 (setq hyp ($ subhypothesis 'instanciate nil nil)))
                (t (setq hyp ($ hypothetical-world 'instanciate nil nil))))
          (setq super-hyp hyp)
          (setf (get-fondamental-value hyp 'parent-world)  *current-hypothetical-world*)
          (setf (get-fondamental-value  *current-hypothetical-world* 'children-worlds) 
                (cons hyp (copy (get-fondamental-value  *current-hypothetical-world* 'children-worlds))))
          (setf (get-fondamental-value hyp 'initialisation-sequence) sequence)
          (setq hyp-list (cons hyp hyp-list))
          (setq  *hypothetical-world-list* (cons (cons hyp current-hypothetical-list)  *hypothetical-world-list*))
  
     ; on change le monde actuel en vigueur dans le chainage avant par la premiere hypothese essaye par le backtracker

          (setf (get-slot-facet-aspect *current-forward-chainer-object*
                                       'current-hypothetical-world-sequence
                                       'value
                                       (get-slot-value *current-forward-chainer-object* 'basic-hypothetical-world))
                (append (remq *current-hypothetical-world* 
                              (get-slot-facet-aspect *current-forward-chainer-object*
                                                     'current-hypothetical-world-sequence
                                                     'value
                                                     (get-slot-value 
                                                      *current-forward-chainer-object* 'basic-hypothetical-world)))
                        (list hyp)))

          (setq *current-hypothetical-world* hyp)
          (eval sequence)
          (setq *current-hypothetical-world*  hypothetical-world-save)
          (setq backtrack (user-instanciate 'backtracker nil nil))
          (setf (get-fondamental-value hyp 'parent-backtracker) backtrack)
          (setf (get-fondamental-value backtrack 'parent-backtracker) (ante-backtracker))
          (setf (get-fondamental-value backtrack 'hypothetical-world-list) nil)
          (setf (get-fondamental-value backtrack 'fired-hypothetical-world-list) (list hyp))
          (setf (get-fondamental-value backtrack 'best-first-function) best-function)
          (setf (get-fondamental-value backtrack 'current-hypothese) hyp)
          (setf (get-fondamental-value backtrack 'point-name) point-name)
          (setq sequence-list-1 (cdr sequence-list-1))
                                        ;on met en reserve les autres possibilites
          loop
          (when (null sequence-list-1) (go fin))
          (setq sequence (car sequence-list-1))
          (setq sequence-list-1 (cdr sequence-list-1))
          (cond (subhypothesis
                 (setq hyp ($ subhypothesis 'instanciate nil nil)))
                (t (setq hyp ($ hypothetical-world 'instanciate nil nil))))
          (setf (get-fondamental-value hyp 'parent-backtracker) backtrack)
          (setf (get-fondamental-value backtrack 'hypothetical-world-list) 
                (cons hyp (get-fondamental-value backtrack 'hypothetical-world-list) ))
          (setf (get-fondamental-value hyp 'parent-world )  *current-hypothetical-world*)
          (setf (get-fondamental-value  *current-hypothetical-world* 'children-worlds) 
                (cons hyp (copy (get-fondamental-value  *current-hypothetical-world* 'children-worlds))))
          (setf (get-fondamental-value hyp 'initialisation-sequence) sequence)
          (setq hyp-list (cons hyp hyp-list))
          (setq  *hypothetical-world-list* (cons (cons hyp current-hypothetical-list)  *hypothetical-world-list*))
          (setq *current-hypothetical-world* hyp)
          (eval sequence)
          (setq *current-hypothetical-world*  hypothetical-world-save)
          (go loop)
          fin
          (setf (get-fondamental-value backtrack 'hypothetical-world-list) 
                (reverse  (get-fondamental-value backtrack 'hypothetical-world-list) ))
          (setf (get-fondamental-value  *current-hypothetical-world* 'children-worlds) 
                (reverse (get-fondamental-value  *current-hypothetical-world* 'children-worlds) ))
          (setq *current-hypothetical-world* super-hyp)
          (setq hyp-list (reverse hyp-list))
          (when *explanation-flag* (trace-main-events (list 6 *current-hypothetical-world* 
                                                            backtrack point-name best-function hyp-list )))
          (ftrace 1 (catenate "point de backtraking : " point-name)
                  (catenate "mise en reserve de :" (list-string (cdr hyp-list)))
                  (catenate "activation de  : " (car hyp-list) " au lieu de : " hypothetical-world-save))
          (return hyp-list)
          find-next-case
          (setq hypothetical-world-save *current-hypothetical-world*)
          (setq current-hypothetical-list (assoc *current-hypothetical-world* *hypothetical-world-list*))
          (cond (subhypothesis
                 (setq hyp ($ subhypothesis 'instanciate nil nil)))
                (t (setq hyp ($ hypothetical-world 'instanciate nil nil))))
          (setq backtrack (user-instanciate 'backtracker nil nil))
          (setf (get-fondamental-value hyp 'parent-backtracker) backtrack)
          (setf (get-fondamental-value backtrack 'parent-backtracker) (ante-backtracker))
          (setf (get-fondamental-value backtrack 'hypothetical-world-list) nil)
          (setf (get-fondamental-value backtrack 'fired-hypothetical-world-list) (list hyp))
          (setf (get-fondamental-value backtrack 'best-first-function) nil)
          (cond(best-function
                (setf (get-fondamental-value backtrack 'find-next-function) best-function))
               (t (setf (get-fondamental-value backtrack 'find-next-function) 'backtracker-standard-find-next-function)))
          (setf (get-fondamental-value backtrack 'current-hypothese) hyp)
          (setf (get-fondamental-value backtrack 'point-name) point-name)
          (setf (get-fondamental-value hyp 'parent-backtracker) backtrack)
          (setf (get-fondamental-value hyp 'parent-world )  *current-hypothetical-world*)
          (setf (get-fondamental-value  *current-hypothetical-world* 'children-worlds) 
                (cons hyp (copy (get-fondamental-value  *current-hypothetical-world* 'children-worlds))))
          (setq  *hypothetical-world-list* (cons (cons hyp
                                                       (assoc *current-hypothetical-world* *hypothetical-world-list*))
                                                 *hypothetical-world-list*))
          (setq *current-hypothetical-world* hyp)
          (setq next-hyp (apply best-function (list backtrack *current-hypothetical-world* hyp)))
          (setq *current-hypothetical-world* world-save)
    ; on change le monde actuel en vigueur dans le chainage avant par la premiere hypothese essaye par le backtracker

          (setf (get-slot-facet-aspect *current-forward-chainer-object*
                                       'current-hypothetical-world-sequence
                                       'value
                                       (get-slot-value *current-forward-chainer-object* 'basic-hypothetical-world))
                (append (remq *current-hypothetical-world* 
                              (get-slot-facet-aspect *current-forward-chainer-object*
                                                     'current-hypothetical-world-sequence
                                                     'value
                                                     (get-slot-value 
                                                      *current-forward-chainer-object* 'basic-hypothetical-world)))
                        (list hyp)))
          (setq *current-hypothetical-world* hyp)
          (when *explanation-flag* (trace-main-events (list 6 *current-hypothetical-world* 
                                                            backtrack point-name best-function (list hyp) )))
          (ftrace 1 (catenate "point de backtraking : " point-name)
                  (catenate "mise en reserve de :" (list-string (cdr hyp-list)))
                  (catenate "activation de  : " (car hyp-list) " au lieu de : " hypothetical-world-save))
          (return (list hyp))))))

(de remove-hypothetical-world ()
    (let ((world-save *current-hypothetical-world*))
    (setf (get-slot-facet-aspect *current-hypothetical-world*
                                 'excluded 
                                 'value 
                                 (get-slot-value *current-forward-chainer-object* 'basic-hypothetical-world)) t)
    (setf (get-slot-facet-aspect *current-forward-chainer-object*
                                 'current-hypothetical-world-sequence
                                 'value 
                                 (get-slot-value *current-forward-chainer-object* 'basic-hypothetical-world)) 
          (remq *current-hypothetical-world*
                (get-slot-facet-aspect *current-forward-chainer-object*
                                 'current-hypothetical-world-sequence
                                 'value 
                                 (get-slot-value *current-forward-chainer-object* 'basic-hypothetical-world))))
    (ftrace 1 (catenate "desactivation du monde : " world-save) nil nil)))
                

(de backtrack () (prog (b) (cond((setq b (ante-backtracker))
                                 ($ b 'backtrack))
                                (t nil))))

(de backtrack-to (point-nomme)  (prog (b) (cond((setq b (ante-backtracker))
                                                ($ b 'backtrack-to point-nomme))
                                               (t nil))))

(de ante-backtracker ()
    (get-fondamental-value *current-hypothetical-world* 'parent-backtracker))
    


(de backtracker-backtrack (btk-object)
    (prog (bad-hyp-list basic-bad-hyp best-first-function next-hyp bhw next-hyp1 find-next-function world-save)
          (setq bhw (get-slot-value *current-forward-chainer-object* 'basic-hypothetical-world))
          (setq basic-bad-hyp (get-slot-facet-aspect btk-object 'current-hypothese 'value bhw))
          (setq bad-hyp-list (bad-hyp-list-determination basic-bad-hyp))
          (mapc '(lambda (x) (setf (get-slot-facet-aspect x 'excluded 'value bhw) t))
                bad-hyp-list)
          (setf (get-slot-facet-aspect *current-forward-chainer-object* 'stop-flag 'value bhw) t)
          (cond  ((get-fondamental-value btk-object 'best-first-function)
                  (setq best-first-function (get-fondamental-value btk-object 'best-first-function))
                  (setq next-hyp (apply best-first-function (list btk-object (get-slot-facet-aspect btk-object
                                                                                                    'current-hypothese
                                                                                                    'value
                                                                                                    bhw))))
                  (go deb1))
                 ((get-fondamental-value btk-object 'find-next-function)
                  (setq find-next-function  (get-fondamental-value btk-object 'find-next-function))
                  (setq next-hyp1 ($ hypothetical-world 'instanciate nil nil))
                  (setf (get-fondamental-value next-hyp1 'parent-backtracker) btk-object)
                  (setf (get-fondamental-value next-hyp1 'parent-world )  *current-hypothetical-world*)
                  (setf (get-fondamental-value  *current-hypothetical-world* 'children-worlds) 
                        (cons next-hyp1 (copy (get-fondamental-value  *current-hypothetical-world* 'children-worlds))))
                  (setq  *hypothetical-world-list* (cons (cons next-hyp1
                                                               (assoc *current-hypothetical-world* *hypothetical-world-list*))
                                                         *hypothetical-world-list*))
                  (setq world-save *current-hypothetical-world*)
                  (setq *current-hypothetical-world* next-hyp1)
                  (setq next-hyp (apply find-next-function (list btk-object
                                                                 (get-slot-facet-aspect btk-object
                                                                                        'current-hypothese
                                                                                        'value
                                                                                        bhw)
                                                                 next-hyp1)))
                  (setq *current-hypothetical-world* world-save)
                           (go deb1))
                 ((get-fondamental-value btk-object 'hypothetical-world-list)
                  (setq best-first-function 'backtracker-standart-best-function)
                  (setq next-hyp (apply best-first-function (list btk-object (get-slot-facet-aspect btk-object
                                                                                                    'current-hypothese
                                                                                                    'value
                                                                                                    bhw))))
                  (go deb1))
                 (t (setq next-hyp nil)))
          deb1    
          (when (null next-hyp)
                (cond((null (get-fondamental-value btk-object 'parent-backtracker))
                      (ftrace 1 (catenate "backtracking sans hypothese de rechange , desactivation de : " world-save) nil nil)
                      (stop-forward)
                      (return))
                     (t (ftrace 1 (catenate  " backtracking vers l hypothese  :" 
                                           (get-fondamental-value btk-object 'parent-backtracker)) nil nil)
                        ($ (get-fondamental-value btk-object 'parent-backtracker) 'backtrack)
                        (return))))
          (ftrace 1 (catenate " backtracking vers l hypothese :" next-hyp) nil nil)
          (setf (get-slot-facet-aspect *current-forward-chainer-object* 
                                       'current-supplementary-hypothetical-world-sequence
                                       'value
                                       bhw)
                (list next-hyp))

          ))

(de backtracker-backtrack-to (btk-object point-nomme)
  (prog (bad-hyp-list basic-bad-hyp best-first-function next-hyp btk-cherche bhw next-hyp1 find-next-function world-save)
        (setq btk-cherche btk-object)
        (setq bhw (get-slot-value *current-forward-chainer-object* 'basic-hypothetical-world))
        loop
        (cond ((eq btk-cherche nil) (cerror 9 " point de backtracking non trouve " point-nomme))
              ((eq (get-fondamental-value btk-cherche 'point-name) point-nomme) (go fin))
              ((setq btk-cherche (get-fondamental-value btk-cherche 'parent-backtracker))
               (go loop)))
        fin
          (setq basic-bad-hyp (get-slot-facet-aspect btk-cherche 'current-hypothese 'value bhw))
          (setq bad-hyp-list (bad-hyp-list-determination basic-bad-hyp))
          (mapc '(lambda (x) (setf (get-slot-facet-aspect x 'excluded 'value bhw) t))
                bad-hyp-list)
          (setf (get-slot-facet-aspect *current-forward-chainer-object* 'stop-flag 'value bhw) t)
          (cond  ((get-fondamental-value btk-cherche 'best-first-function)
                  (setq best-first-function (get-fondamental-value btk-cherche 'best-first-function))
                  (setq next-hyp (apply best-first-function (list btk-cherche (get-slot-facet-aspect btk-cherche
                                                                                                    'current-hypothese
                                                                                                    'value
                                                                                                    bhw))))
                  (go deb1))
                 ((get-fondamental-value btk-cherche 'find-next-function)
                  (setq find-next-function  (get-fondamental-value btk-cherche 'find-next-function))
                  (setq next-hyp1 ($ hypothetical-world 'instanciate nil nil))
                  (setf (get-fondamental-value next-hyp1 'parent-backtracker) btk-cherche)
                  (setf (get-fondamental-value next-hyp1 'parent-world )  *current-hypothetical-world*)
                  (setf (get-fondamental-value  *current-hypothetical-world* 'children-worlds) 
                        (cons next-hyp1 (copy (get-fondamental-value  *current-hypothetical-world* 'children-worlds))))
                  (setq  *hypothetical-world-list* (cons (cons next-hyp1
                                                               (assoc *current-hypothetical-world* *hypothetical-world-list*))
                                                         *hypothetical-world-list*))
                  (setq world-save *current-hypothetical-world*)
                  (setq *current-hypothetical-world* next-hyp1)
                  (setq next-hyp (apply find-next-function (list btk-cherche
                                                                 (get-slot-facet-aspect btk-cherche
                                                                                        'current-hypothese
                                                                                        'value
                                                                                        bhw)
                                                                 next-hyp1)))
                  (setq *current-hypothetical-world* world-save)
                           (go deb1))
                 ((get-fondamental-value btk-object 'hypothetical-world-list)
                  (setq best-first-function 'backtracker-standart-best-function)
                  (setq next-hyp (apply best-first-function (list btk-cherche (get-slot-facet-aspect btk-cherche
                                                                                                    'current-hypothese
                                                                                                    'value
                                                                                                    bhw))))
                  (go deb1))
                 (t (setq next-hyp nil)))
          deb1 
          (when (null next-hyp)
                (cond((null (get-fondamental-value btk-cherche 'parent-backtracker))
                      (ftrace 1 (catenate "backtracking sans hypothese de rechange au dela de :" point-nomme )
                              (catenate "desactivation de :" world-save) nil)
                      (stop-forward)
                      (return))
                     (t (ftrace 1 (catenate " backtracking vers l hypothese "
                                            (get-fondamental-value btk-object 'parent-backtracker))
                                (catenate " desactication de : " world-save) nil)
                                
                        ($ (get-fondamental-value btk-cherche 'parent-backtracker) 'backtrack)
                        (return))))
          (ftrace 1 (catenate " backtracking vers l hypothese " next-hyp)
                  (catenate "desactivation de : " world-save) nil)
          (setf (get-slot-facet-aspect 
                 *current-forward-chainer-object* 
                 'current-supplementary-hypothetical-world-sequence                    
                 'value 
                 (get-slot-value *current-forward-chainer-object* 'basic-hypothetical-world))
                (list next-hyp))
    ))

(de backtracker-standart-best-function (backtracker hypothese)
    
        ; cette fonction se contente de choisir la possibilite suivante decrite lors du marquage du backtraking     

    (prog (hyp-list final-hyp)
          (setq hyp-list (get-fondamental-value backtracker 'hypothetical-world-list))
          (cond((car hyp-list)
                (setf (get-fondamental-value backtracker 'fired-hypothetical-world-list)
                      (cons (car hyp-list) 
                            (get-fondamental-value backtracker 'fired-hypothetical-world-list)))
                (setf (get-fondamental-value backtracker 'hypothetical-world-list)
                      (cdr hyp-list ))
                (return (car hyp-list)))
               (t (return nil)))))

(de backtracker-standard-find-next-function (backtracker current-hypothese next-hypothese)

     ;cette fonction se contente de lancer une nouvelle hypothese sans autre precision en acceptant celle proposee par le systeme

    (prog ()
          (return next-hypothese)))


                         

(de stop-forward ()
    (setf (get-slot-facet-aspect *current-forward-chainer-object* 
                                 'current-supplementary-hypothetical-world-sequence
                                 'value 
                                 (get-slot-value *current-forward-chainer-object* 'basic-hypothetical-world))
          nil)
    (setf (get-slot-facet-aspect 
           *current-forward-chainer-object* 
           'stop-flag 
           'value
           (get-slot-value *current-forward-chainer-object* 'basic-hypothetical-world)) t)
    (setf (get-slot-facet *current-forward-chainer-object* 'current-hypothetical-world-sequence 'value)
          (list (list (get-slot-value *current-forward-chainer-object* 'basic-hypothetical-world)))))

(de bad-hyp-list-determination (bad-hyp)
    (prog(hyp-list hyp-seq)
         (setq hyp-list *hypothetical-world-list*)
         loop
         (when (null hyp-list) (go fin))
         (when (memq bad-hyp (car hyp-list))
               (setq hyp-seq (cons (caar hyp-list) hyp-seq)))
         (setq hyp-list (cdr hyp-list))
         (go loop)
         fin
         (return hyp-seq)))
         

(de determination-bloc-determine (deterbloc object slot)
        (prog (result)
              (setq result (funcall (get-fondamental-value deterbloc 'compiled-body)  object slot))
              (return result)))
    
            


(de forward-chainer-determine (forchainobject object slot )
    (prog(value verification)
         (ftrace 2 (catenate " lancement du chaineur avant " forchainobject " pour determiner : " slot  "{" object "}") nil nil)
         (when *explanation-flag* (trace-main-events (list 3 *current-hypothetical-world* forchainobject 'determine object slot)))
         loop
         (setq verification (funcall (get-slot-facet-value object slot 'determination-predicat)
                                     object
                                     slot
                                     (setq value (get-slot-value object slot))))
         (when verification
               (ftrace 2 (catenate "exit du chaineur avant " forchainobject) nil nil)
               (ftrace 4 (catenate  "il est donc conclu que " slot "{" object "} = ") value nil)
               (when *explanation-flag* (trace-main-events (list 4 *current-hypothetical-world* 
                                                                 forchainobject 'determine object slot)))
               (return value))
         (forward-chainer-one-step forchainobject)
         (go loop)))



                            



;on ne peut rajouter des regles qu avant le demarrage du systeme 


(de add-forward-rule (titre forchainobject1 premisse conclusion description)
    (prog (rule wm compiled-premisse compiled-conclusion forchainobject2 forchainobject)
          (cond ((not (consp forchainobject1)) (setq forchainobject2 (list forchainobject1)))
                (t (setq forchainobject2 forchainobject1)))
          (mapc '(lambda(forchainobject)
                   (check-forward-chainer 1 forchainobject)
                   (setq rule ($ 'forward-rule 'instanciate titre nil))
                   (setq *forward-translation-predicat-state* 'forward)
                   (setq compiled-premisse (macroexpand (top-traduc-boolean  
                                                         (translate-atom-forward-3
                                                          (translate-atom-forward-2
                                                           (translate-atom-forward-1
                                                            (translate-atom premisse)))) rule forchainobject)))
                           
                   (setq compiled-conclusion (macroexpand (top-traduc-conclusion
                                                           (translate-atom-forward-3
                                                            (translate-atom-forward-2
                                                             (translate-atom-forward-1 
                                                              (translate-atom conclusion)))) rule)))
                   ($ rule 'put-value 'premisse premisse)
                   ($ rule 'put-value 'conclusion conclusion)
                   ($ rule 'put-value 'compiled-premisse (copy compiled-premisse))
                   ($ rule 'put-value 'compiled-conclusion (copy compiled-conclusion))
                   ($ rule 'put-value 'determination-mean forchainobject)
                   ($ rule 'put-value 'contens-description description)
                   ($ forchainobject 'add-value 'rule-list rule)
                   )
                forchainobject2)
          (setq *forward-translation-predicat-state* nil)
          (return rule)))

                
(de forward-chainer-one-step (forchainobject)
    (prog (result current-hyp-list current-hyp hyp-save)
          (setq current-hyp-list (get-slot-value forchainobject 'current-hypothetical-world-sequence))
          (setq hyp-save *current-hypothetical-world*)
          loop
          (when (null current-hyp-list) (go fin))
          (setq current-hyp (car current-hyp-list))
          (setf (get-slot-value forchainobject 'current-supplementary-hypothetical-world-sequence) nil)
          (setq *current-hypothetical-world* current-hyp)
          (setq result (forward-chainer-one-step-1 forchainobject))
          (setq *current-hypothetical-world* hyp-save)
          (when (get-slot-facet-aspect forchainobject 
                                               'current-supplementary-hypothetical-world-sequence 'value current-hyp)
                (setf (get-slot-value forchainobject 'current-hypothetical-world-sequence)
                      (mapcan '(lambda (x) (cond ((null (get-slot-value x 'excluded)) (list x))
                                                 (t nil)))
                              (append (get-slot-facet-aspect forchainobject 
                                                             'current-supplementary-hypothetical-world-sequence 'value current-hyp)
                                      (remq current-hyp
                                            (copy (get-slot-value forchainobject 'current-hypothetical-world-sequence)))))))
          
          (setq current-hyp-list (cdr current-hyp-list))
          (go loop)
          fin
          (return result)))
          
(de forward-chainer-one-step-1 (forchainobject)
    (prog ( conflictset)

          (setq conflictset  (make-classic-conflict-set forchainobject))

          (ftrace 8  (list "== conflict set ===  hypothetical world  : " *current-hypothetical-world*)
                  conflictset
                  "===============================================================================")
          (return (forward-execute-conclusion conflictset forchainobject))))


          
(de forward-chainer-one-step-2 (forchainobject)
    (prog ( conflictset)

          (setq conflictset  (make-saturation-conflict-set forchainobject))

          (ftrace 8  (list "== conflict set ===  hypothetical world  : " *current-hypothetical-world*)
                  conflictset
                  "===============================================================================")
          (return (forward-execute-conclusion conflictset forchainobject))))


                
(de forward-chainer-go (forchainobject)
    (prog ( conflictset result ruleset current-hyp-list current-hyp hyp-save bhw)
          (check-forward-chainer 2 forchainobject)
          (when *explanation-flag* (trace-main-events (list 3 *current-hypothetical-world* forchainobject 'go)))
          (ftrace 2 (catenate "lancement du chaineur avant " forchainobject " en conflict gere ") nil nil)
          (setq rule-list  (get-slot-value forchainobject 'rule-list))
          (setf (get-slot-value forchainobject 'fired-binding-list) nil)
          (setf (get-slot-value forchainobject 'conflict-set) nil)
          (setf (get-slot-value forchainobject 'basic-hypothetical-world ) *current-hypothetical-world*)
          (setq bhw  *current-hypothetical-world*)
          loop
          (setq result nil)
          (setq current-hyp-list (get-slot-facet-aspect forchainobject 'current-hypothetical-world-sequence 'value bhw))
          (setq hyp-save *current-hypothetical-world*)
          (setf (get-slot-facet-aspect forchainobject 'stop-flag 'value bhw) nil)
          loop1

          (cond((and (null current-hyp-list) 
                     (get-slot-facet-aspect forchainobject 
                                            'current-supplementary-hypothetical-world-sequence
                                            'value
                                            bhw))
                (setf (get-slot-facet-aspect forchainobject
                                             'current-hypothetical-world-sequence
                                             'value
                                             bhw)
                      (get-slot-facet-aspect forchainobject 
                                                   'current-supplementary-hypothetical-world-sequence 
                                                   'value
                                                   bhw))
                (go loop))
               ((and (null current-hyp-list) 
                     (null (get-slot-facet-aspect forchainobject 
                                       'current-supplementary-hypothetical-world-sequence
                                       'value
                                       bhw)))
                 (go fin1)))
          (setq current-hyp (car current-hyp-list))
          (setf (get-slot-facet-aspect forchainobject 'current-supplementary-hypothetical-world-sequence 'value bhw) nil)
          (setq *current-hypothetical-world* current-hyp)
          (setq result (forward-chainer-one-step-1 forchainobject))
          (setq *current-hypothetical-world* hyp-save)

   ;quand des mondes nouveaux et parralleles apparaissent  dans l'hypothese parrallele essaye 
   ;on les rajoute dans le monde initial de lancement du chainer (en enlevant le monde parrallele essaye)
          (when (get-slot-facet-aspect forchainobject 
                                       'current-supplementary-hypothetical-world-sequence 
                                       'value 
                                       bhw)
                (setf (get-slot-facet-aspect forchainobject
                                             'current-hypothetical-world-sequence
                                             'value
                                             bhw)
                              (append 
                                      (remq current-hyp
                                            (copy (get-slot-facet-aspect forchainobject
                                                                         'current-hypothetical-world-sequence
                                                                         'value
                                                                         bhw)))
                                      (get-slot-facet-aspect forchainobject 
                                                             'current-supplementary-hypothetical-world-sequence 
                                                             'value
                                                             bhw))))

   ;quand la regle failed on enleve le monde parrallele essaye dans le contexte du lancement du chainer

          (when (eq result nil)
                (setf (get-slot-facet-aspect forchainobject 
                                             'current-hypothetical-world-sequence
                                             'value
                                             bhw)
                              (remq current-hyp
                                    (copy (get-slot-facet-aspect forchainobject 
                                                                 'current-hypothetical-world-sequence
                                                                 'value
                                                                 bhw)))))

    ;on filtre les monde declares exclus dans le monde parralele essaye  , dans le contexte du chainer de depart

          (setf  (get-slot-facet-aspect forchainobject 
                                        'current-hypothetical-world-sequence
                                        'value
                                        bhw)
                 (mapcan '(lambda (x) (cond ((null (get-slot-facet-aspect x 'excluded 'value current-hyp))
                                             (list x))
                                            (t nil)))
                         (copy (get-slot-facet-aspect forchainobject 
                                                      'current-hypothetical-world-sequence
                                                      'value
                                                      bhw))))
          (when (not (null  (get-slot-facet-aspect  forchainobject 
                                              'current-hypothetical-world-sequence 
                                              'value 
                                              bhw)))
                (setq result t))
          (when (get-slot-facet-aspect forchainobject 
                                       'stop-flag
                                       'value
                                       bhw) (go fin1))
          (setq current-hyp-list (cdr current-hyp-list))
          (go loop1)
          fin1
          (when (eq result nil)
                (setf (get-slot-facet-aspect forchainobject 
                                             'current-hypothetical-world-sequence
                                             'value
                                             (get-slot-value forchainobject 'basic-hypothetical-world )) (copy '(fondamental)))
                (when *explanation-flag* (trace-main-events (list 4 *current-hypothetical-world* forchainobject 'go)))
                (ftrace 2 (catenate "exit du chaineur avant " forchainobject) nil nil)
                (return nil))
          (go loop)))

(de forward-chainer-sature (forchainobject)
    (prog ( conflictset result ruleset current-hyp-list current-hyp hyp-save bhw)
          (check-forward-chainer 3 forchainobject)
          (when *explanation-flag* (trace-main-events (list 3 *current-hypothetical-world* forchainobject 'sature)))
          (ftrace 2 (catenate "lancement du chaineur avant " forchainobject " en chainage saturant rapide") nil nil)
          (setq rule-list  (get-slot-value forchainobject 'rule-list))
          (setf (get-slot-value forchainobject 'fired-binding-list) nil)
          (setf (get-slot-value forchainobject 'conflict-set) nil)
          (setf (get-slot-value forchainobject 'basic-hypothetical-world ) *current-hypothetical-world*)
          (setq bhw  *current-hypothetical-world*)
          loop
          (setq result nil)
          (setq current-hyp-list (get-slot-facet-aspect forchainobject 'current-hypothetical-world-sequence 'value bhw))
          (setq hyp-save *current-hypothetical-world*)
          (setf (get-slot-facet-aspect forchainobject 'stop-flag 'value bhw) nil)
          loop1
          (when (null current-hyp-list) (go fin1))
          (setq current-hyp (car current-hyp-list))
          (setf (get-slot-facet-aspect forchainobject 'current-supplementary-hypothetical-world-sequence 'value bhw) nil)
          (setq *current-hypothetical-world* current-hyp)
          (setq result (forward-chainer-one-step-2 forchainobject))
          (setq *current-hypothetical-world* hyp-save)


                           ;quand des mondes nouveaux et parralleles apparaissent  dans l'hypothese parrallele essaye 
                           ;on les rajoute dans le monde initial de lancement du chainer (en enlevant le monde parrallele essaye)

          (when (get-slot-facet-aspect forchainobject 
                                       'current-supplementary-hypothetical-world-sequence 
                                       'value 
                                       bhw)
                (setf (get-slot-facet-aspect forchainobject
                                             'current-hypothetical-world-sequence
                                             'value
                                             bhw)
                      (append   (remq current-hyp
                                      (copy (get-slot-facet-aspect forchainobject
                                                                   'current-hypothetical-world-sequence
                                                                   'value
                                                                   bhw)))
                                (get-slot-facet-aspect forchainobject 
                                                       'current-supplementary-hypothetical-world-sequence 
                                                       'value
                                                       bhw))))
                            

                         ;quand la regle failed on enleve le monde parrallele essaye dans le contexte du lancement du chainer

          (when (eq result nil)
                (setf (get-slot-facet-aspect forchainobject 
                                             'current-hypothetical-world-sequence
                                             'value
                                             bhw)
                      (remq current-hyp
                            (copy (get-slot-facet-aspect forchainobject 
                                                         'current-hypothetical-world-sequence
                                                         'value
                                                         bhw)))))
              ;on filtre les monde declares exclus dans le monde parralele essaye  , dans le contexte du chainer de depart

          (setf  (get-slot-facet-aspect forchainobject 
                                        'current-hypothetical-world-sequence
                                        'value
                                        bhw)
                 (mapcan '(lambda (x) (cond ((null (get-slot-facet-aspect x 'excluded 'value current-hyp))
                                             (list x))
                                            (t nil)))
                         (copy (get-slot-facet-aspect forchainobject 
                                                      'current-hypothetical-world-sequence
                                                      'value
                                                      bhw))))      
          (when (get-slot-facet-aspect forchainobject 
                                       'stop-flag
                                       'value
                                       bhw) (go fin1))
        
          (setq current-hyp-list (cdr current-hyp-list))
          (go loop1)
          fin1
          (when (eq result nil)
                (setf (get-slot-facet-aspect forchainobject 
                                             'current-hypothetical-world-sequence
                                             'value
                                             bhw) (copy '(fondamental)))
                (when *explanation-flag* (trace-main-events (list 4 *current-hypothetical-world* forchainobject 'sature)))
                (ftrace 2 (catenate " exit du chaineur avant " forchainobject ) nil nil)
                (return nil))
          (go loop)))
                                        ;
                                        ;        structure du conflict-set
                                        ;
                                        ;  ((rule-1 (fired (12502 12607)  (a . toto-1 ) ... (b . toto-3 ))
                                        ;           (ready (13004 23043)  (a . toto-3 ) ... (b . toto-7 ))
                                        ;                                             .
                                        ;                                             . 
                                        ;                                             .
                                        ;           (ready (14022 15744)  (a . toto-4 ) ... (b . toto-2 )))
                                        ;   (rule-2 (ready (12433 12833)  (c . toto-5 ) ...
                                        ;           .
                                        ;           .)))

                                        ;        structure de la working-memory
                                        ;
                                        ;   ((toto-1 (att1  value 12504) (att2  value 14260) ... (attn  value 34234))
                                        ;    (toto-2 (att1  value 65445) (att2  value 73323) ... (attn  value 45543))
                                        ;                     .
                                        ;                     .
                                        ;                     .
                                        ;    (toto-5 (att1  value 44332) (att2  value 39909) ... (attn  value 50045)))




(de forward-chainer-super-sature (forchainobject)
    (prog ( conflictset result ruleset current-hyp-list current-hyp hyp-save bhw)
          (check-forward-chainer 3 forchainobject)
          (when *explanation-flag* (trace-main-events (list 3 *current-hypothetical-world* forchainobject 'sature)))
          (ftrace 2 (catenate "lancement du chaineur avant " forchainobject " en chainage saturant rapide") nil nil)
          (setq rule-list  (get-slot-value forchainobject 'rule-list))
          (setf (get-slot-value forchainobject 'fired-binding-list) nil)
          (setf (get-slot-value forchainobject 'conflict-set) nil)
          (setf (get-slot-value forchainobject 'basic-hypothetical-world ) *current-hypothetical-world*)
          (setq bhw  *current-hypothetical-world*)
          loop
          (setq result nil)
          (setq current-hyp-list (get-slot-facet-aspect forchainobject 'current-hypothetical-world-sequence 'value bhw))
          (setq hyp-save *current-hypothetical-world*)
          (setf (get-slot-facet-aspect forchainobject 'stop-flag 'value bhw) nil)
          loop1
          (when (null current-hyp-list) (go fin1))
          (setq current-hyp (car current-hyp-list))
          (setf (get-slot-facet-aspect forchainobject 'current-supplementary-hypothetical-world-sequence 'value bhw) nil)
          (setq *current-hypothetical-world* current-hyp)
          (setq result (forward-chainer-one-step-2 forchainobject))
          (setq *current-hypothetical-world* hyp-save)


                           ;quand des mondes nouveaux et parralleles apparaissent  dans l'hypothese parrallele essaye 
                           ;on les rajoute dans le monde initial de lancement du chainer (en enlevant le monde parrallele essaye)

          (when (get-slot-facet-aspect forchainobject 
                                       'current-supplementary-hypothetical-world-sequence 
                                       'value 
                                       bhw)
                (setf (get-slot-facet-aspect forchainobject
                                             'current-hypothetical-world-sequence
                                             'value
                                             bhw)
                      (append   (remq current-hyp
                                      (copy (get-slot-facet-aspect forchainobject
                                                                   'current-hypothetical-world-sequence
                                                                   'value
                                                                   bhw)))
                                (get-slot-facet-aspect forchainobject 
                                                       'current-supplementary-hypothetical-world-sequence 
                                                       'value
                                                       bhw))))
                            

                         ;quand la regle failed on enleve le monde parrallele essaye dans le contexte du lancement du chainer

          (when (eq result nil)
                (setf (get-slot-facet-aspect forchainobject 
                                             'current-hypothetical-world-sequence
                                             'value
                                             bhw)
                      (remq current-hyp
                            (copy (get-slot-facet-aspect forchainobject 
                                                         'current-hypothetical-world-sequence
                                                         'value
                                                         bhw)))))
              ;on filtre les monde declares exclus dans le monde parralele essaye  , dans le contexte du chainer de depart

          (setf  (get-slot-facet-aspect forchainobject 
                                        'current-hypothetical-world-sequence
                                        'value
                                        bhw)
                 (mapcan '(lambda (x) (cond ((null (get-slot-facet-aspect x 'excluded 'value current-hyp))
                                             (list x))
                                            (t nil)))
                         (copy (get-slot-facet-aspect forchainobject 
                                                      'current-hypothetical-world-sequence
                                                      'value
                                                      bhw))))      
          (when (get-slot-facet-aspect forchainobject 
                                       'stop-flag
                                       'value
                                       bhw) (go fin1))
        
          (setq current-hyp-list (cdr current-hyp-list))
          (go loop1)
          fin1
          (when (eq result nil)
                (setf (get-slot-facet-aspect forchainobject 
                                             'current-hypothetical-world-sequence
                                             'value
                                             bhw) (copy '(fondamental)))
                (when *explanation-flag* (trace-main-events (list 4 *current-hypothetical-world* forchainobject 'sature)))
                (ftrace 2 (catenate " exit du chaineur avant " forchainobject ) nil nil)
                (return nil))
          (go loop)))
                                      

(dmd get-forward-cs-list (conflict-set rule rank)  `(nth ,rank
                                                         (cdr (assoc ,rule ,conflict-set))))

(dmd get-forward-binding-list (conflict-set rule rank) `(caddr(nth ,rank
                                                                       (cdr (assoc ,rule ,conflict-set)))))

(dmd get-forward-rule-state (conflict-set rule rank) `(car(nth ,rank
                                (cdr (assoc ,rule ,conflict-set)))))))

(dmd get-forward-tags  (conflict-set rule rank) `(cadr(nth ,rank
                                (cdr (assoc ,rule ,conflict-set))))))))



(dmd get-wm-slot (forchainobject object slot)  `(cdr (assoc ,slot (cdr (assoc ,object 
                                (get-slot-value ,forchainobject 'conflict-set))))))

(dmd get-wm-value (forchainobject object slot)  `(cadr (assoc ,slot (cdr (assoc ,object 
                                (get-slot-value ,forchainobject 'conflict-set))))))

(dmd get-wm-tag (forchainobject object slot)  `(caddr (assoc ,slot (cdr (assoc ,object 
                                (get-slot-value ,forchainobject 'conflict-set))))))


        
(de make-classic-conflict-set (forchainobject)
    (prog (ruleset old-conflict-set old-rule-conflict-set new-rule-conflict-set chain-save)
          (setq ruleset (get-slot-value forchainobject 'rule-list))
          (when (variablep ruleset) (setq ruleset (list ruleset)))
          (setq old-conflict-set  (get-slot-value forchainobject 'conflict-set))
          (setf (get-slot-value forchainobject 'conflict-set) nil)
          (setq chain-save  *current-forward-chainer-object*)
          (setq  *current-forward-chainer-object* forchainobject)
           loop
          (when (null ruleset)
                  (setq  *current-forward-chainer-object* chain-save)
                  (return (get-slot-value forchainobject 'conflict-set)))
          (setq rule (car ruleset))
          (setq old-rule-conflict-set (cdr (assoc rule old-conflict-set)))

          (setq new-rule-conflict-set  (make-conflict-set-for-a-rule forchainobject rule old-rule-conflict-set))

          (when (null new-rule-conflict-set)
                (setq ruleset  (cdr ruleset))
                (go loop))
          (setf (get-slot-value forchainobject 'conflict-set)
                (cons  new-rule-conflict-set
                      (get-slot-value forchainobject 'conflict-set)))
          (setq ruleset  (cdr ruleset))
          (go loop)))
         


(de make-saturation-conflict-set (forchainobject)
    (prog (ruleset old-conflict-set old-rule-conflict-set new-rule-conflict-set chain-save)
          (setq ruleset (get-slot-value forchainobject 'rule-list))
          (when (variablep ruleset) (setq ruleset (list ruleset)))
          (setq old-conflict-set  (get-slot-value forchainobject 'conflict-set))
          (setf (get-slot-value forchainobject 'conflict-set) nil)
          (setq chain-save  *current-forward-chainer-object*)
          (setq  *current-forward-chainer-object* forchainobject)

           loop
          (when (null ruleset)
                  (setq  *current-forward-chainer-object* chain-save)
                  (return (get-slot-value forchainobject 'conflict-set)))
          (setq rule (car ruleset))
          (setq old-rule-conflict-set (cdr (assoc rule old-conflict-set)))

          (setq new-rule-conflict-set  (make-conflict-set-for-a-rule forchainobject rule old-rule-conflict-set))

          (when (null new-rule-conflict-set)
                (setq ruleset  (cdr ruleset))
                (go loop))
          (setf (get-slot-value forchainobject 'conflict-set)
                (cons  new-rule-conflict-set
                      (get-slot-value forchainobject 'conflict-set)))
          (setq  *current-forward-chainer-object* chain-save)
          (return (get-slot-value forchainobject 'conflict-set))))
       

  
(de make-conflict-set-for-a-rule (forchainobject rule old-rule-conflict-set)
    (prog ( bindings binding bindings1 tagsup taginf new-conflict-set tag-list crdate)
          (setq tag-list nil)
          (setq tagsup 0)
          (setq taginf 99999)

          (setq premisse (forward-try-premisse rule forchainobject))
          (when (null premisse) (return nil))
          (setq bindings (get-backward-binding-list forchainobject rule))

          (setq bindings1 bindings)
       
          loop
          (when (null bindings) (go loop1))
          (setq binding (car bindings))
          (when (null (cdr binding))
                (setq bindings (cdr bindings))
                (go loop))
          (cond((null tag-list) 
                (setq tag-list (cond ((and (variablep (cdr binding))
                                           (get-fondamental-value (cdr binding) 'date-of-creation)))   
                                     (t 0))))
               ((numberp tag-list) 
                (setq y (cond ((and (variablep (cdr binding))
                                    (get-fondamental-value (cdr binding) 'date-of-creation))) 
                              (t 0)))
                (setq tag-list (cond ((> tag-list y) (list tag-list y))
                                     (t (list y tag-list)))))
               (t (setq tag-list (make-classification  (cond ((and (variablep (cdr binding))
                                                                   (get-fondamental-value (cdr binding) 'date-of-creation)))    
                                                             (t 0))
                                                       tag-list))))
          (setq bindings (cdr bindings))
          (go loop)
          loop1
          (setq new-conflict-set  (list 'fired 
                                        (cons (length bindings1)
                                              (cond((numberp tag-list) (list tag-list))
                                                   (t tag-list)))
                                        bindings1))
          (cond( (member new-conflict-set old-rule-conflict-set)

                 (return  (list rule (list 'fired
                                           (cons (length bindings1)  
                                                 (cond((numberp tag-list) (list tag-list))
                                                      (t tag-list)))
                                           bindings1))))
               ( t (return  (list rule (list 'ready
                                             (cons (length bindings1)  
                                                   (cond((numberp tag-list) (list tag-list))
                                                        (t tag-list)))
                                             bindings1)))))))
        
(de make-classification (n nlist)
    (cond((null nlist) (list n))
         ((>= n (car nlist)) (cons n nlist))
         (t (cons (car nlist) (make-classification n (cdr nlist))))))
         

(de forward-execute-conclusion  (conflict-set forchainobject)
    (prog (rule rank binding-list var-list settings r1 r s s1 rank ntags ntags1 chain-save)
                                        ;resolution du conflit
     
          (when (null conflict-set) 
                (return nil))
          (setq s1 nil)
          (setq ntags1 0)
          (setq conf1 conflict-set)
          loop
          (when (null conf1) (go loop1))
          (setq r (car conf1))
          (setq s (best-tags r))
          (when (null s) 
                (setq conf1 (cdr conf1))
                (go loop))
          (setq rank (car s))
          (setq s (cadr s))
          (setq ntags (caadr s))
          (when (null s1) (setq s1 s)
                          (setq rank1 rank)
                          (setq ntags1 ntags)
                          (setq r1 r)
                          (setq conf1 (cdr conf1))
                          (1+ rank)
                          (go loop))
          (cond((< ntags ntags1) 
                (setq conf1 (cdr conf1))
                (1+ rank)
                (go loop))
               ((> ntags ntags1)
                (setq ntags1 ntags)
                (setq rank1 rank)
                (setq s1 s)
                (setq r1 r)
                (setq conf1 (cdr conf1))
                (1+ rank)
                (go loop))
               (t (setq tag-list (cdadr s))
                  (when(superieurp tag-list tag-list1)
                       (setq rank1 rank)
                       (setq s1 s)
                       (setq r1 r))
                  (setq conf1 (cdr conf1))
                  (1+ rank)
                  (go loop)))
        
          loop1
          (when (eq s1 nil) (return nil)) ;  retour car pas de regle executable
          (setq rule (car r1))
                                ;  execution de la conclusion 
          (setq chain-save  *current-forward-chainer-object*)
          (setq  *current-forward-chainer-object* forchainobject)
          (ftrace 7 (catenate "regle forward reussie : " rule " dans le monde " *current-hypothetical-world* ) nil nil)
          (setq binding-list (get-forward-binding-list conflict-set rule rank))
          (setq var-list (first-list binding-list))
          (setf (get-slot-value forchainobject 'fired-binding-list) 
                (cons (cons (cons '*rule* rule) binding-list)
                      (get-slot-value forchainobject 'fired-binding-list) ))
          
          (setq settings (backward-conclusion-settings var-list binding-list))
          (setf  (get-forward-cs-list conflict-set rule rank)
                 (cons 'fired (cdr (copy  (get-forward-cs-list conflict-set rule rank)))))
          (setf (get-slot-value forchainobject 'conflict-set) conflict-set)
          (when *explanation-flag* (trace-main-events (list 2
                                                            *current-hypothetical-world*
                                                            rule
                                                            )))

          (eval `(let ,var-list ,@settings
                      (funcall (get-fondamental-value (quote ,rule) 'compiled-conclusion) forchainobject)))

          (setq  *forward-rule-just-succeeded* rule)
          (setq  *current-forward-chainer-object* chain-save)
          (return rule)))






   ; une instanciation a la forme (rule-17 (ready (3 123 124 125) ((a . toto-1) (b . toto-2) (c . toto-3)) )                                                                   (ready (3 123 125 124) ((a . toto-1) (b . toto-3) (c . toto-2)) )                                                                   .............)

(de best-tags (instanciation)
    (prog (r2 s ntags ntags1 resultrank)
          (setq r2 (cdr instanciation))
          (setq result nil)
          (setq rank 0)
          (setq ntags1 0)
          (setq tag-list1 nil)
          loop
          (when (null r2)
                (return result) )
          (setq s (car r2))
          (when (eq (car s) 'fired)
                (setq r2 (cdr r2))
                (1+ rank)
                (go loop))
          (setq ntags (caadr s))
          (cond((< ntags ntags1) 
                (setq r2 (cdr r2))
                (1+ rank)
                (go loop))
               ((> ntags ntags1)
                (setq ntags1 ntags)
                (setq result (list rank s))
                (setq r2 (cdr r2))
                (1+ rank)
                (go loop))
               (t (setq tag-list (cdadr s))
                  (when(superieurp tag-list tag-list1)
                      (setq result (list rank s))
                      (setq r2 (cdr r2))
                      (1+ rank)
                      (go loop))))))
                    
        
(de superieurp (list1 list2)
    (any '(lambda (x y) (> x y)) list1 list2))



    
    (de add-determination-bloc ( body  blocname)
        (prog(bloc compiled-body)
            (check-defined-object 1 blocname)
             (setq bloc ($ 'determination-bloc 'instanciate blocname nil))
               (setq *forward-translation-predicat-state* 'forward)
             (setq compiled-body (macroexpand  (top-traduc-body 
                                                (translate-atom-forward-3
                                                 (translate-atom-forward-2
                                                 (translate-atom-forward-1
                                                 (translate-atom-forward  body)))) bloc)))
               (setq *forward-translation-predicat-state* nil)
             ($ bloc 'put-value 'body body)
             ($ bloc 'put-value 'compiled-body compiled-body)
             (return bloc)))

    (de situation-block-check-condition (situation-bloc object slot old-value new-value)
        (prog (premisse)
              (when (not(member situation-bloc *situation-bloc-activation-list*))
                    (return nil))

              (setq premisse (funcall (get-fondamental-value situation-bloc 'compiled-predicat)
                                      object slot old-value new-value))
              (when (not premisse) 
                    (ftrace 12 (catenate "situation-bloc qui a echoue : " situation-bloc) nil nil)
                    (return))
              (when premisse  
                    (ftrace 12 (catenate "situation-bloc qui a reussi : " situation-bloc) nil nil)
                    (setq binding-list (get-backward-binding-list object situation-bloc))
                    (setq var-list (first-list binding-list))
                    (setq settings (backward-conclusion-settings var-list binding-list))
                    (eval `(let ,var-list ,@settings
                                (funcall (get-fondamental-value (quote ,situation-bloc) 'compiled-action)
                                         object slot old-value new-value))))))

    (de add-situation-bloc (slot-list predicat action blocname )

                                        ;slot-list contient une liste d item de 3 elements du type
                                        ;  `(object slot 'metaclass) ou ` (object slot 'instance)
                                        ; si le terme metaclass est present alors la verification est faite
                                        ; pour toute les instances de l'object cite

        (prog (bloc compiled-predicat compiled-action spy)
             (check-defined-object 2 blocname)
              (mapc   '(lambda (x) (check-object-slot 14 (car x) (cadr x)))
                      slot-list)
              (setq bloc ($ 'situation-bloc 'instanciate blocname nil))

              (setq compiled-predicat (macroexpand  (top-traduc-predicat predicat bloc)))

                           
              (setq compiled-action (macroexpand  (top-traduc-action action bloc)))

              ($ bloc 'put-value 'predicat predicat)
              ($ bloc 'put-value 'action action)
              ($ bloc 'put-value 'compiled-predicat compiled-predicat)
              ($ bloc 'put-value 'compiled-action   compiled-action)
              ($ bloc 'put-value 'slot-list slot-list)

              (mapc '(lambda (x) (when (null (assoc (car x) *slot-to-spy-list*))
                                       (setq *slot-to-spy-list* (cons (list (car x)) *slot-to-spy-list*)))

                       (when (eq (caddr x) 'metaclass)

                             (setq  spy (assoc (cadr x) (cdr(assoc (car x)  *slot-to-spy-list*))))

                             (cond 
                              ((or (null spy)
                                   (null (cdr spy)))
                               (setf  (cdr(assoc  (car x)   *slot-to-spy-list*))
                                      (acons (cadr x)  (list(list  bloc 'metaclass))  
                                             (cdr(assoc  (car x)   *slot-to-spy-list*)))))
                              (t 
                               (setf (cdr spy) 
                                     (acons bloc (list 'metaclass) (cdr spy))))))
                       (when (eq (caddr x) 'instance)
                             (setq  spy (assoc (cadr x) (cdr(assoc (car x)  *slot-to-spy-list*))))
                         
                             (cond 
                              ((or (null spy)
                                   (null (cdr spy)))
                               (setf  (cdr(assoc  (car x)   *slot-to-spy-list*))
                                      (acons (cadr x) (list (list  bloc 'instance) ) 
                                             (cdr(assoc  (car x)   *slot-to-spy-list*)))))
                              (t 
                               (setf (cdr spy)
                                     (acons bloc (list 'instance) (cdr spy)))))))
                    slot-list)
              (ftrace 9 (catenate  " situation-bloc : " bloc) nil nil)
              (setq *situation-bloc-activation-list* (cons bloc *situation-bloc-activation-list*))
              (return bloc)))

(de add-dynamic-link (object1 slot1 way1 object2 slot2 way2)
                                        ;way1 ou way2 contient soit 'metaclass soit 'instance
    (prog (x dyn)
          (when (null (assoc object1 *dynamic-inheritance-slot-list*))
                         (setq *dynamic-inheritance-slot-list* 
                               (cons (list object1) *dynamic-inheritance-slot-list*)))
                       
                   (setq dyn (assoc slot1 (cdr (assoc object1  *dynamic-inheritance-slot-list*))))
                   (cond ((or (null dyn)
                              (null (cdr dyn)))
                          (setf (cdr (assoc object1 *dynamic-inheritance-slot-list*))
                                (acons slot1 (list  (list way1 object2 slot2 way2))
                                       (cdr (assoc object1  *dynamic-inheritance-slot-list*)))))
                         (t (setf (cdr dyn)
                                  (cons (list way1 object2 slot2 way2) (cdr dyn)))))     
          (return nil)))

;la limite de la liason dynamique est que on ne peut pas etablir des liason dynamique entre des objects
; et le faire aussi entre leur metaclass

(de remove-dynamic-link (object1 slot1 way1 object2 slot2 way2)
                                        ;way1 ou way2 contient soit 'metaclass soit 'instance
        (prog (slot-list dyn)
              (cond ((eq way1 'metaclass)
                     (setq slot-list (mapcar '(lambda (x) (list x slot1)) 
                                                                  (get-fondamental-value object1 'instances))))
                    ((eq way1 'instance)
                     (setq slot-list (list object1 slot1))))
              
              (mapc '(lambda (x) 
                       (setq dyn (assoc (cadr x) (cdr (assoc (car x)  *dynamic-inheritance-slot-list*))))
                       (cond ((or (null dyn)
                                  (null (cdr dyn)))
                              nil)
                             (t (setf (cdr dyn)
                                      (remove  (list object2 slot2 way2) (cdr dyn))))))
                        
                       
                    slot-list)
             
              (return nil)))
 
    (de top-traduc-predicat (exp bloc)
        (prog (dec transforme settings nom)
              (setq transforme (traduc-boolean exp  bloc bloc))
              (setq dec (car transforme))
              
              (setq transforme (cadr transforme))
              (setq *variable-list* (first-list dec))
              (cond ((null dec) (setq settings nil))
                    (t (setq settings (copy(form-settings dec bloc)))))
              (setq nom (gensym))
              (eval `(de ,nom  (object slot old-value new-value) 
                         (let ,(first-list dec) 
                           (prog1
                               ,transforme
                             ,@settings))))
              (return nom)))
 
    (de top-traduc-body (exp bloc)
        (prog (dec transforme settings nom)
              (setq transforme (traduc-boolean exp bloc bloc))
              (setq dec (car transforme))
              
              (setq transforme (cadr transforme))
              (setq *variable-list* (first-list dec))
              (cond ((null dec) (setq settings nil))
                    (t (setq settings (copy (form-settings dec bloc)))))
              (setq nom (gensym))
              (eval `(de ,nom (*object* *slot*) 
                         (let ,(first-list dec) 
                           (prog1
                               ,transforme
                             ,@settings))))
              (return nom)))

    (de situation-bloc-activate (object) (cond((not(member object *situation-bloc-activation-list*))
                                               (setq  *situation-bloc-activation-list*
                                                      (cons object  *situation-bloc-activation-list*)))))


    (de situation-bloc-desactivate (object) (cond((member object  *situation-bloc-activation-list*)
                                                  (setq  *situation-bloc-activation-list*
                                                         (remq object  *situation-bloc-activation-list*)))))


    (de top-traduc-action (exp bloc)
        `(lambda (object slot old-value new-value) ,(traduc-conclusion exp bloc)))

    (de traduc-boolean (exp chain rule) 
        (prog (dec-list t1 t2 dec var class param-list)   
              (cond ((null exp)
                     (return (list nil nil)))
                    ((atomp exp)
                     (return (list nil exp)))
                    ((eq (car exp) 'for-all )
                     (cond ((eq (caddr exp) 'such-that)
                            (setq dec (cadr exp))
                            (setq t1 (traduc-boolean (caddr (cdr exp)) chain rule))
                            (setq t2 (traduc-boolean (caddr (cddr exp)) chain rule))
                            (setq dec-list (append (list dec) (car t1)))
                            (setq param-list (first-list dec-list))
                            (setq var (car dec))
                            (setq class (cadr dec))
                            (return (list nil (traduc-boolean-for-all-such-that class var t1 t2 param-list))
                                    ))
                           (t (setq dec (cadr exp))
                              (setq t1 (traduc-boolean (caddr exp) chain rule))
                              (setq dec-list (append (list dec) (car t1)))
                              (setq param-list (first-list dec-list))
                              (setq var (car dec))
                              (setq class (cadr dec))
                              (return (list nil (traduc-boolean-for-all class var t1 param-list)
                                            )))))
                    ((eq (car exp) 'existing)
                     (setq dec (cadr exp) )
                     (setq t1 (traduc-boolean (caddr exp) chain rule))
                     (setq dec-list (append (list dec)  (car t1)))
                     (setq var (car dec))
                     (setq class (cadr dec))
                     (return (list dec-list (traduc-boolean-exist class var t1 chain rule)
                                   )))
                    ((eq (car exp) 'in-a-world-where)
                     (setq dec (list (cadr exp) ''hypothetical-world))
                     (setq t1 (traduc-boolean (cadddr exp) chain rule))
                     (setq dec-list (append (list dec)  (car t1)))
                     (setq var (car dec))
                     (setq class (cadr dec))
                     (return (list dec-list (traduc-boolean-hypothetical var (caddr exp) t1 chain rule)
                                   )))
                    
                    (t (cond ((consp (car exp))
                              (setq t1 (traduc-boolean (car exp) chain rule))
                              (setq t2 (traduc-boolean (cdr exp) chain rule))
                              (setq dec-list (append (car t1) (car t2)))
                              (return (list dec-list (cons (cadr t1) (cadr t2)))))
                             (t (setq t1 (traduc-boolean (cdr exp) chain rule))
                                (setq dec-list  (car t1))
                                (return (list dec-list (cons (car exp) (cadr t1))))))))))

                                   


    (setq *local-bindings* nil)

    (setf (get 'value '*local-bindings*) nil)
    (setf (get 'type '*local-bindings*) nil)

    (dmd get-binding-value (var object rule)
         `(cdr (assoc ,var (cdr (assoc  ,object (get-slot-value ,rule 'list-of-intermediate-bindings))))))

    (dmd get-backward-binding-list (object rule)
         `(cdr (assoc  ,object (get-slot-value ,rule 'list-of-intermediate-bindings)))) 


    (de traduc-boolean-for-all (class var t1 param-list)                           
        `(prog ,(append (list 'value-list 'result ) param-list)
               (setq value-list (get-all-instances  ,class))
               loop
               (cond ((null value-list) (return t)))
               (setq ,var (car value-list))
               (setq result ,(cadr t1))
               (cond(result 
                     (setq value-list (cdr value-list))
                     (go loop))
                    (t (return nil))))
        )

    (de traduc-boolean-for-all-such-that (class var t1 t2 param-list)
        `(prog ,(append (list 'value-list 'value-list-1 'result) param-list)
               (setq value-list-1 (get-all-instances  ,class))
               (setq value-list ())
               loop1
               (cond ((null value-list-1) (go loop)))
               (setq ,var (car value-list-1))
               (setq result ,(cadr t1))
               (cond (result
                      (setq value-list (cons (car value-list-1) value-list))))
               (setq value-list-1 (cdr value-list-1))
               (go loop1)
               loop
               (cond ((null value-list) (return t)))
               (setq ,var (car value-list))
               (setq result ,(cadr t2))
               (cond(result 
                     (setq value-list (cdr value-list))
                     (go loop))
                    (t (return nil))))
        )


                                  
    (de traduc-boolean-exist (class var t1 chain rule)
        (cond ((eq *forward-translation-predicat-state* 'backward)
               `(prog (value-list result)
                      (setq value-list (get-all-instances ,class))
                      loop
                      (cond ((null value-list) (return ())))
                      (setq ,var (car value-list))
                      (setq result ,(cadr t1))
                      (cond(result 
                            (return result))
                           (t (setq value-list (cdr value-list))
                              (go loop)))))
              ((eq *forward-translation-predicat-state* 'forward)
               `(prog (value-list current-bindings fired-binding-list try-current-bindings result)
                      (setq value-list (get-all-instances  ,class))
                      (setq current-bindings (get-slot-value (quote ,chain) 'current-binding-list)) 
                      (setq fired-binding-list (get-slot-value (quote ,chain) 'fired-binding-list)) 
     
                      loop
                      (cond ((null value-list) (return ())))
                      (setq ,var (car value-list))

                      (setq try-current-bindings 
                            (try-current-bindings-function (quote ,rule) (quote ,var ) ,var  current-bindings))
; si  try-current-bindings est inclu dans un des fired-binding-list
                      (when (any (quote (lambda (xlist)
                                          (match-bindings->*
                                           xlist 
                                           try-current-bindings)))
                                 fired-binding-list)
                            (setq value-list (cdr value-list))
                           
                            (go loop))
                      (setf (get-slot-value (quote ,chain) 'current-binding-list)
                            (cons (cons (quote ,var) ,var)  (get-slot-value (quote ,chain) 'current-binding-list)))
                      (setq result ,(cadr t1))
                      (setf (get-slot-value (quote ,chain) 'current-binding-list)
                            (cdr  (get-slot-value (quote ,chain) 'current-binding-list)))
                      (cond(result 
                          
                            (return result))
                           (t (setq value-list (cdr value-list))
                              (go loop)))))))


(de traduc-boolean-hypothetical (var t2 t1 chain rule)
    `(prog (hyp1 hypothetical-world-save1 current-hypothetical-list1 result1 ante-backtracker)
           (setq hypothetical-world-save1 *current-hypothetical-world*)
           (setq ante-backtracker (ante-backtracker))
           (setq current-hypothetical-list1 (assoc *current-hypothetical-world* *hypothetical-world-list*))
           (setq hyp1 ($ hypothetical-world 'instanciate nil nil))
           (setf (get-slot-value hyp1 'parent-backtracker) ante-backtracker)
           (setf (get-slot-facet-aspect hyp1 'parent-world 'value 'fondamental)  *current-hypothetical-world*)
           (setf (get-slot-facet-aspect  *current-hypothetical-world* 'children-worlds  'value 'fondamental) 
                 (cons hyp1 (copy (get-slot-facet-aspect  *current-hypothetical-world* 
                                                          'children-worlds 'value 'fondamental))))
           (setf (get-slot-facet-aspect hyp1 'initialisation-sequence 'value 'fondamental) (quote ,t2))

           (setq  *hypothetical-world-list* (cons (cons hyp1 current-hypothetical-list1)  *hypothetical-world-list*))
           (setq *current-hypothetical-world* hyp1)
           (setq ,var hyp1)
           ,t2
           (setq result1 ,(cadr t1))
           (setq *current-hypothetical-world*  hypothetical-world-save1)
           (return result1)))
                        
           
                    


(de get-all-instances (object)
    (prog ((sub (get-fondamental-value object 'subtypes)))
          (cond((null sub) (return (copy (get-fondamental-value object 'instances))))
               (t (return (append (copy (get-fondamental-value object 'instances)) 
                                  (mapcan 'get-all-instances sub)))))))
        
(de try-current-bindings-function (rule varname varvalue current-bindings)
         (cons (cons  '*rule* rule)  (cons (cons varname varvalue) current-bindings)))



; verifie si c-bindings est inclu dans x-list
(de match-bindings-> (xlist c-bindings)
    (every '(lambda (x) (member x xlist)) 
           c-bindings))

(de match-bindings->* (xlist c-bindings)
    (every '(lambda (x) (member x c-bindings)) 
            xlist))



(de top-traduc-boolean (exp rule chain)
    (prog (dec transforme settings)
          (setq transforme (traduc-boolean exp chain rule))
          (setq dec (car transforme))
          
          (setq transforme (cadr transforme))
          (setq *variable-list* (first-list dec))
          (cond ((null dec) (setq settings nil))
                (t (setq settings (copy (form-settings dec rule)))))
          (return 
           `(lambda (*formal-argument*) (let ,(first-list (copy dec)) 
                                          (prog1
                                              ,transforme
                                                      ,@settings
                                                      
                                                      ))
              ))))


        



                                        ;dans le cas forward les *formal-argument* seront lies au forchainobject              
               
               
        (de form-settings (dec rule)
          
            (append (list `(setf (get-slot-value (quote ,rule) 'list-of-intermediate-bindings) 
                                 (list (cons *formal-argument* (copy (quote  ,(copy (mapcar 'list
                                                                                      (first-list dec)))))))))
        
                    (form-settings-1 dec rule)))
                 


        (de form-settings-1 (dec rule)

            (cond((null dec) nil)
                 (t (cons   `(setf (get-binding-value (quote ,(copy(caar dec)))
                                                      *formal-argument*  (quote ,rule)) (copy ,(copy(caar dec))))
                            (form-settings-1 (cdr dec) rule)))))

      


        (de first-list (dec)
            (cond((null dec) nil)
                 (t (cons (caar dec) (first-list (cdr dec))))))


        (de traduc-conclusion (exp rule) exp)



        (de top-traduc-conclusion (exp rule)
            `(lambda (*formal-argument*) ,(traduc-conclusion exp rule)))

        (setq *backward-chaining-state* nil)
        (setq *current-ruleset* nil)


        (de backward-chainer-try-to-determine-internally (backchainobject object slot)
            (prog (oldback oldrul result)
                  (check-object-slot 15 object slot)
                  (check-backward-chainer 1 backchainobject)
                  (setq oldback *backward-chaining-state*)
                  (setq oldrul *current-ruleset*)
                  (setq *backward-chaining-state* 'internal-backward-chaining)
                  (setq *current-ruleset* (get-slot-value backchainobject 'rule-list))
                  (setq result (backward-chainer-try-to-determine-internally-1 object slot))
                  (setq *backward-chaining-state* oldback)
                  (setq *current-ruleset* oldrul)
                  (return result)))

        (de backward-chainer-try-to-determine-externally (backchainobject object slot)
            (prog (oldback oldrul result)
                  (check-object-slot 16 object slot)
                  (check-backward-chainer 2 backchainobject)
                  (setq oldback *backward-chaining-state*)
                  (setq oldrul *current-ruleset*)
                  (setq *backward-chaining-state* 'external-backward-chaining)
                  (setq *current-ruleset* (get-slot-value backchainobject 'rule-list))
                  (setq result (backward-chainer-try-to-determine-internally-1 object slot))
                  (setq *backward-chaining-state* oldback)
                  (setq *current-ruleset* oldrul)
                  (return result)))


        (de backward-chainer-try-to-determine-internally-1 (object slot)
            (prog (predicat ruleset-p rule conclusion verification premisse)
                  (setq predicat (get-slot-facet-value object slot 'determination-predicat))
                  (setq ruleset-p *current-ruleset* )
                  loop
                  (cond ((null ruleset-p)
                         (setf (get-slot-facet-value object slot 'determined) t)
                         (ftrace 4 (catenate  "il est donc conclu que " slot "{" object "} = " )
                                              (get-slot-value object slot) nil)
                         (return (user-get-value object slot)))
                        ((variablep ruleset-p)
                         (setq ruleset-p (list ruleset-p))))
                  (setq rule (car ruleset-p))
                  (when (not(and (eq (get-fondamental-value rule 'concluded-slot) slot)
                                 (eq (get-fondamental-value rule 'concluded-type)
                                     (get-fondamental-value object 'metaclass))))
                        (setq ruleset-p (cdr ruleset-p))
                        (go loop))
                  (setq premisse (try-premisse rule object slot))
                  (cond ((null premisse)
                         (setq ruleset-p (cdr ruleset-p))
                          (ftrace 6 (catenate " regle qui a echoue a cause du premisse  : " rule) nil nil)
                         (go loop)))
                  (setq conclusion (execute-conclusion rule object slot))
                  (setq  *backward-rule-just-succeeded* rule)
                  (setq verification (funcall predicat object slot conclusion))
                  (cond((eq verification t)
                        (setf (get-slot-value object slot) conclusion)
                        (setf (get-slot-facet-value object slot 'determined) t)
                        (ftrace 5 (catenate " regle qui a reussi : " rule) nil nil)
                        (ftrace 4 (catenate  "il est donc conclu que " slot "{" object "} = " ) conclusion nil)
                        (return conclusion)))
                  (ftrace 4 (catenate "il n a pas ete correct de conclure " slot "{" object "} = ")
                          conclusion nil)
                  (setq ruleset-p (cdr ruleset-p))
                  (ftrace 6 (catenate " regle qui a echoue a cause du predicat  : " rule) nil nil)
                  (go loop)))



        (de determine (object slot)
            (let (result)
              (check-object-slot 17 object slot)
              (cond((null (get-slot-facet object slot 'determined))
                    (setq result (user-get-value object slot))
                    result)
                   ((eq (get-slot-facet-value object slot 'determined) t)
                    (setq result (user-get-value object slot))
                    result)
                   ((eq *backward-chaining-state* 'internal-backward-chaining)
                    (setq result (backward-chainer-try-to-determine-internally-1 object slot))
                    result)
                   ((or (eq *backward-chaining-state* 'external-backward-chaining)
                        t)
                    (setq result (determine-slot-value object slot))
                    result))))


                   


        (de forward-try-premisse (rule forchainobject)
           (setf (get-slot-value forchainobject 'current-binding-list) nil)
           (funcall (get-fondamental-value rule 'compiled-premisse) forchainobject))
        

(de forme-toto-premisse (rule forward-chainer)
    (prog (p)
          (setq p (get-slot-value rule 'compiled-premisse))
          (setq z `(de toto ()   
                       (setf (get-slot-value ,forward-chainer 'current-binding-list) nil)
                       ,(list p forward-chainer)))
          (eval z)
          (return " toto redefini")))

        (de try-premisse (rule object slot)
            (prog (c)
                  (setq c  (funcall (get-fondamental-value rule 'compiled-premisse) object))
                  (return c)))

        (de execute-conclusion (rule object slot)
            (let (binding-list var-list settings conclusion)
              (setq binding-list (get-backward-binding-list object rule))
              (setq var-list (first-list binding-list))
              (setq settings (backward-conclusion-settings var-list binding-list))
              (when *explanation-flag* (trace-main-events (list 1 
                                                                *current-hypothetical-world*
                                                                rule
                                                                object
                                                                slot)))
              (eval  `(let ,var-list ,@settings
                           (setq conclusion (funcall (get-fondamental-value (quote ,rule) 'compiled-conclusion)
                                                     object))
                           (user-put-value (quote ,object) (quote ,slot) conclusion)
                           conclusion))))
                                    
    
        (de backward-conclusion-settings (var-list binding-list)
            (cond((null var-list ) nil)
                 (t (append (list  `(setq ,(copy(car var-list)) (cdr(assoc (quote ,(car var-list)) binding-list))))
                            (backward-conclusion-settings (cdr var-list) binding-list)))))
     
 



        (de add-backward-rule (titre backward-chainer1 premisse conclusion concluded-attribut description)

                                        ;normalement le concluded-slot  le concluded-type et le backward-chaineur
                                        ; doivent preexister au moment de l'addition de la regle
                                        ; le concluded-attribut a la forme (att{b} toto)
                                        ; soit en fait (att {  b } toto)
            (prog (rule compiled-premisse compiled-conclusion concluded-slot concluded-variable concluded-type
                        backward-chainer2 backward-chainer)
                  (setq concluded-slot (car concluded-attribut))
                  (setq concluded-variable (caddr concluded-attribut))
                  (setq concluded-type (caddr (cddr concluded-attribut)))
                  (check-object-slot 18 concluded-type concluded-slot)
                  (cond((not(consp backward-chainer1)) (setq backward-chainer2 (list backward-chainer1)))
                       (t (setq backward-chainer2 backward-chainer1)))
                  (mapc '(lambda(backward-chainer)
                           (check-backward-chainer 3 backward-chainer)
                           (setq rule ($ 'backward-rule 'instanciate titre nil))
                           (setq *forward-translation-predicat-state* 'backward)
                           (setq compiled-premisse (macroexpand (subst '*formal-argument* 
                                                                       concluded-variable
                                                                       (top-traduc-boolean  (translate-atom premisse)
                                                                                            rule backward-chainer))))
                           (setq compiled-conclusion (translate-atom-backward-1 conclusion))
                           (when (and (consp compiled-conclusion)
                                      (consp (car compiled-conclusion)))
                                 (setq compiled-conclusion (car compiled-conclusion)))

                           (setq compiled-conclusion (macroexpand (subst '*formal-argument*
                                                                         concluded-variable
                                                                         (top-traduc-conclusion
                                                                          compiled-conclusion rule))))
                           ($ rule 'put-value 'premisse premisse)
                           ($ rule 'put-value 'conclusion conclusion)
                           ($ rule 'put-value 'compiled-premisse compiled-premisse)
                           ($ rule 'put-value 'compiled-conclusion   compiled-conclusion)
                           ($ rule 'put-value 'concluded-variable concluded-variable)
                           ($ rule 'put-value 'concluded-type concluded-type)
                           ($ rule 'put-value 'concluded-slot concluded-slot)
                           ($ rule 'put-value 'determination-mean backward-chainer)
                           ($ rule 'put-value 'contens-description description)
                           ($ backward-chainer 'add-value 'rule-list rule)
                           )
                        backward-chainer2)
                  (setq *forward-translation-predicat-state* nil)
                  (return rule)))



           
(de translate-atom (expr)
  (cond((eq  *forward-translation-predicat-state* 'forward)
          (translate-atom-forward expr))
         ((eq  *forward-translation-predicat-state* 'backward)
          (translate-atom-backward expr)))))


(de translate-atom-forward (expr)
; transforme les expression du type att { a } en (user-get-value a 'att)

   (prog (l0 l1 l2 l3 l4 expr1)
          (cond ((null expr) (return nil))
                ((atom  expr) (return expr))
                ((eq (length expr) 1)
                 (return (list (translate-atom-forward (car expr)))))
                ((eq (length expr) 2)
                 (return (list (translate-atom-forward (car expr)) (translate-atom-forward (cadr expr)))))
                ((eq (length expr) 3)
                 (return (list  (translate-atom-forward (car expr)) 
                                (translate-atom-forward (cadr expr))
                                (translate-atom-forward (caddr expr))))))
          (setq l0 nil)
          (setq l1 (car expr))
          (setq l2 (cadr expr))
          (setq l3 (caddr expr))
          (setq l4 (cadddr expr))
          (setq expr1 (cddr(cddr expr)))
          loop
          (cond((and (eq l2 '|{|)
                     (eq l4 '|}|))
               
                (return (append  (translate-atom-forward l0)
                                (list (list 'user-get-value  l3 (list 'quote l1)))
                                (translate-atom-forward expr1))))
               ((null expr1)
                (return (append l0 (list (translate-atom-forward l1)
                                         (translate-atom-forward l2)
                                         (translate-atom-forward l3)
                                         (translate-atom-forward l4))))))
          (setq l0 (append l0 (list (translate-atom-forward l1))))
          (setq l1 l2)
          (setq l2 l3)
          (setq l3 l4)
          (setq l4 (car expr1))
          (setq expr1 (cdr expr1))
          (go loop)))
          
(de translate-atom-forward-1 (expr)
                                        ; transforme les expressions du type (x a b) @ = v  en user-put-value a b v
                                        ; de meme que les expressions de type (x a b) @ a v en user-add-value a b v
                                        ; destinee a etre utilisee apres translate-atom-forward sur les conclusions de regle forward
                                        ; pour transformer att{a} @= v en user-put-value a 'att v

    (prog (l0 l1 l2 l3 l4 expr1)
          (cond ((null expr) (return nil))
                ((atom  expr) (return expr))
                ((eq (length expr) 1)
                 (return (list (translate-atom-forward-1 (car expr)))))
                ((eq (length expr) 2)
                 (return (list (translate-atom-forward-1 (car expr)) (translate-atom-forward-1 (cadr expr)))))
                ((eq (length expr) 3)
                 (return (list  (translate-atom-forward-1 (car expr)) 
                                (translate-atom-forward-1 (cadr expr))
                                (translate-atom-forward-1 (caddr expr))))))
          (setq l0 nil)
          (setq l1 (car expr))
          (setq l2 (cadr expr))
          (setq l3 (caddr expr))
          (setq l4 (cadddr expr))
          (setq expr1 (cddr(cddr expr)))
          loop
          (cond((and (eq l2 '|@|)
                     (eq l3 '|=|))
               
                (return (append  (translate-atom-forward-1 l0)
                                 (list 'user-put-value  (cadr l1) (caddr l1) l4)
                                 (translate-atom-forward-1 expr1))))
               ((and (eq l2 '|@|)
                     (eq l3 '|a|))
               
                (return (append  (translate-atom-forward-1 l0)
                                 (list 'user-add-value  (cadr l1) (caddr l1) l4)
                                 (translate-atom-forward-1 expr1))))
               ((null expr1)
                (return (append l0 (list (translate-atom-forward-1 l1)
                                         (translate-atom-forward-1 l2)
                                         (translate-atom-forward-1 l3)
                                         (translate-atom-forward-1 l4))))))
          (setq l0 (append l0 (list (translate-atom-forward-1 l1))))
          (setq l1 l2)
          (setq l2 l3)
          (setq l3 l4)
          (setq l4 (car expr1))
          (setq expr1 (cdr expr1))
          (go loop)))



(de translate-atom-forward-2 (expr)
                                        ; transforme les expressions du type (x a b) @ l (x c d)  en add-link a b c d
                                        ; destinee a etre utilisee apres translate-atom-forward sur les conclusions de regle forward
                                        ; pour transformer att{a} @l att1{b} en add-link a 'att b 'att1

    (prog (l0 l1 l2 l3 l4 expr1)
          (cond ((null expr) (return nil))
                ((atom  expr) (return expr))
                ((eq (length expr) 1)
                 (return (list (translate-atom-forward-2 (car expr)))))
                ((eq (length expr) 2)
                 (return (list (translate-atom-forward-2 (car expr)) (translate-atom-forward-2 (cadr expr)))))
                ((eq (length expr) 3)
                 (return (list  (translate-atom-forward-2 (car expr)) 
                                (translate-atom-forward-2 (cadr expr))
                                (translate-atom-forward-2 (caddr expr))))))
          (setq l0 nil)
          (setq l1 (car expr))
          (setq l2 (cadr expr))
          (setq l3 (caddr expr))
          (setq l4 (cadddr expr))
          (setq expr1 (cddr(cddr expr)))
          loop
          (cond((and (eq l2 '|@|)
                     (eq l3 '|l|))
               
                (return (append  (translate-atom-forward-2 l0)
                                 (list 'add-link  (cadr l1) (caddr l1) (cadr l4) (caddr l4))
                                 (translate-atom-forward-2 expr1))))
               ((null expr1)
                (return (append l0 (list (translate-atom-forward-2 l1)
                                         (translate-atom-forward-2 l2)
                                         (translate-atom-forward-2 l3)
                                         (translate-atom-forward-2 l4))))))
          (setq l0 (append l0 (list (translate-atom-forward-2 l1))))
          (setq l1 l2)
          (setq l2 l3)
          (setq l3 l4)
          (setq l4 (car expr1))
          (setq expr1 (cdr expr1))
          (go loop)))







(de translate-atom-forward-3 (expr)
    ;transforme les expression du type (determine (x a b)) en (determine a b)
                                        

    (prog (l0 l1 l2 l3 l4 expr1)
          (cond ((null expr) (return nil))
                ((atom  expr) (return expr))
                ((eq (length expr) 1)
                 (return (list (translate-atom-forward-3 (car expr))))))
                
          (setq l0 nil)
          (setq l1 (car expr))
          (setq l2 (cadr expr))
        
          (setq expr1 (cddr expr))
          loop
          (cond((and (eq l1 'determine)
                     (eq (length expr ) 2)
                     (eq (car l2) 'user-get-value))
               
                (return (append   l0
                                 (list 'determine (cadr l2) (caddr l2))
                                 (translate-atom-forward-3 expr1))))
               ((null expr1)
                (return (append l0 (list (translate-atom-forward-3 l1)
                                         (translate-atom-forward-3 l2))))))
          (setq l0 (append l0 (list (translate-atom-forward-3 l1))))
          (setq l1 l2)
          (setq l2 (car expr1))
          (setq expr1 (cdr expr1))
          (go loop)))




(de translate-atom-backward-1 (expr)
                                        ;transforme les expression att { a } en (user-get-value a 'att)
                                        ;sauf (att { a } ) en (user-get-value a 'att)

    (prog (l0 l1 l2 l3 l4 expr1)
          (cond ((null expr) (return nil))
                ((atom  expr) (return expr))
                ((eq (length expr) 1)
                 (return (list (translate-atom-backward-1 (car expr)))))
                ((eq (length expr) 2)
                 (return (list (translate-atom-backward-1 (car expr)) (translate-atom-backward-1 (cadr expr)))))
                ((eq (length expr) 3)
                 (return (list  (translate-atom-backward-1 (car expr)) 
                                (translate-atom-backward-1 (cadr expr))
                                (translate-atom-backward-1 (caddr expr))))))
                
          
          (setq l0 nil)
          (setq l1 (car expr))
          (setq l2 (cadr expr))
          (setq l3 (caddr expr))
          (setq l4 (cadddr expr))
          (setq expr1 (cddr(cddr expr)))
          loop
          (cond((and (eq l2 '|{|)
                     (eq l4 '|}|))
               
                (return (append  (translate-atom-backward-1 l0)
                                 (list (list 'user-get-value l3 (list 'quote l1)))
                                 (translate-atom-backward-1 expr1))))
               ((null expr1)
                (return (append l0 (list (translate-atom-backward-1 l1)
                                         (translate-atom-backward-1 l2)
                                         (translate-atom-backward-1 l3)
                                         (translate-atom-backward-1 l4))))))
          (setq l0 (append l0 (list (translate-atom-forward-1 l1))))
          (setq l1 l2)
          (setq l2 l3)
          (setq l3 l4)
          (setq l4 (car expr1))
          (setq expr1 (cdr expr1))
          (go loop)))


(de translate-atom-backward (expr)
                                        ;transforme les expression att { a } en (user-get-value a 'att)
                                        ;sauf (att { a } ) en (user-get-value a 'att)

    (prog (l0 l1 l2 l3 l4 expr1)
          (cond ((null expr) (return nil))
                ((atom  expr) (return expr))
                ((eq (length expr) 1)
                 (return (list (translate-atom-backward (car expr)))))
                ((eq (length expr) 2)
                 (return (list (translate-atom-backward (car expr)) (translate-atom-backward (cadr expr)))))
                ((eq (length expr) 3)
                 (return (list  (translate-atom-backward (car expr)) 
                                (translate-atom-backward (cadr expr))
                                (translate-atom-backward (caddr expr))))))
                
          
          (setq l0 nil)
          (setq l1 (car expr))
          (setq l2 (cadr expr))
          (setq l3 (caddr expr))
          (setq l4 (cadddr expr))
          (setq expr1 (cddr(cddr expr)))
          loop
          (cond((and (eq l2 '|{|)
                     (eq l4 '|}|))
               
                (return (append  (translate-atom-backward l0)
                                 (list (list 'determine l3 (list 'quote l1)))
                                 (translate-atom-backward expr1))))
               ((null expr1)
                (return (append l0 (list (translate-atom-backward l1)
                                         (translate-atom-backward l2)
                                         (translate-atom-backward l3)
                                         (translate-atom-backward l4))))))
          (setq l0 (append l0 (list (translate-atom-backward l1))))
          (setq l1 l2)
          (setq l2 l3)
          (setq l3 l4)
          (setq l4 (car expr1))
          (setq expr1 (cdr expr1))
          (go loop)))


                

        (de backward-chainer-try-to-determine-internally-and-externally (backchainobject slot object)
            (setq *backward-chaining-state* 'internal-and-external-backward-chaining)

            )



                           ;definition des notions d 'attribut et d'expansion de classe


(de add-attribute-user (object slotname evaluation-function nature)
                                        ;evaluation-function doit etre une fonction de deux variables : 
                                        ; object1 slot ou object1  est une instance de object

    (prog (demon)
          (setq demon `(lambda (object slot) 
                         (cond ((get-slot-facet-value object slot 'determined)
                                nil)
                               (t (prog (v) 
                                        (setq v (funcall (quote ,evaluation-function) object slot))
                                        (user-put-value object slot v)
                                        (setf (get-slot-facet-value object slot 'determined) t)
                                        (if (let (k) (and *what-to-answer*
                                                          (setq k (get-slot-facet-value object slot 'keyword))
                                                          (memq k *what-to-answer*)
                                                          *where-to-answer*))
                                            (new-trace-file (list k '= v) *where-to-answer* nil))
                                        )))))
          (add-slot-user object slotname nature)
          (add-slot-facet object slotname 'determined nil)
          (add-read-demon object slotname demon 'merge-before)))

(de add-expand-method (object1 object2 method)
                                        ;method doit etre une fonction de object-1 qui une instance
                                        ;de object1 et d un certain nombre d argument 
                                        ;object2 joue ici le role d un selecteur qui selectione
                                        ; la bonne methode dans une table a deux entree
                                        ; *expand-method-bi-object-list*

    (prog (met)
          (setq met (assoc (list object1 object2) *expand-method-bi-object-list*))
          (cond (met (setf (cdr met) method))
                (t (setq  *expand-method-bi-object-list* 
                          (cons (list (list object1 object2))  *expand-method-bi-object-list*))
                   (setf (cdr (assoc (list object1 object2) *expand-method-bi-object-list*)) method)))))

    
(de expand-object (object-1 object2 argument-list)

    (prog (met auto transparent-slots result foo1 foo2 )
          (setq auto (get-slot-value object-1 'expansion-slot))
          (setq foo1 (list (get-fondamental-value object-1 'metaclass) object2))
          (when (any  '(lambda (x)(cond ( (equal foo1  (list (car x) (cadr x)))
                                          (setq foo2 (caddr x))
                                          t)
                                        (t nil)))
                      auto)
                (return foo2))
          (setq met (cdr (assoc (list (get-fondamental-value object-1 'metaclass) object2)
                                *expand-method-bi-object-list*)))
          (cond (met 
                 (setq result (apply met object-1 argument-list))
                 (setf (get-slot-value  object-1 'expansion-slot) 
                       (cons (list (get-fondamental-value object-1 'metaclass) object2 result)
                             (get-slot-value  object-1 'expansion-slot)))
                 (return  result))
                ((setq transparent-slots (get-slot-value object-1 'transparent-slot-list))
                 (when (null transparent-slots) (return nil))
                 (return (any '(lambda (x) 
                                 (expand-object  (get-slot-value object-1 x)  object2 argument-list))
                              transparent-slots))))))




(de make-vector-from-list (lst)
    (prog (l v vec lst1)
          (setq l (length lst))
          (setq vec (makevector l ()))
          (setq lst1 (reverse lst))
          (setq v 0)
          loop
          (when (>= v l) (return vec))
          (setf (vref vec v) (car lst1))
          (setq v (1+ v))
          (setq lst1 (cdr lst1))
          (go loop)))


(de intersect (ens1 ens2) 
    (mapcan '(lambda (x) (if (member x ens2) (list x) nil)) ens1))



                                        ;RECUPERATION DES ERREURS ET FONCTION DE TRACE


(de check-object (number object) (when (and *error-check-flag*
                                            (not(member object *object-list*)) )
                                       (cerror number "pas d object de ce nom la : " object )))

(de check-slot (number object slot)  (when (and *error-check-flag* 
                                                (not(cdr(assoc slot (get object 'object-property)))))
                                           (cerror number "pas de slot de ce nom la  : " (list object slot))))

(de check-object-slot (number object slot)  (when *error-check-flag*
                                                  (when  (not(member object *object-list*))
                                                          (cerror number "pas d object de ce nom la : " object ))
                                                  (when    (and (not (memq object '(backward-chainer forward-chainer)))
                                                                (not(cdr(assoc slot (get object 'object-property)))))
                                                           (cerror number "pas de slot de ce nom la  : " (list object slot)))))

(de check-facet (number object slot facet) (when (and *error-check-flag*
                                                      (not(assoc facet (cdr(assoc slot (get object 'object-property))))))
                                                 (cerror number "pas de facet de ce nom la : " (list object slot facet))))

(de check-defined-object (number object)  (when (and *error-check-flag*
                                                     (member object  *object-list*) )
                                                (cerror number " object de ce nom la deja defini : " object )))

(de check-backward-chainer (number backward-chainer)   (when (and *error-check-flag*
                                                                  (not (member backward-chainer
                                                                               (get-fondamental-value 'backward-chainer 'instances))))
                                                                  (cerror number "pas de backward-chaineur de ce nom la :" 
                                                                          backward-chainer)))

(de check-forward-chainer (number forward-chainer)   (when (and *error-check-flag*
                                                                  (not (member forward-chainer
                                                                               (get-fondamental-value 'forward-chainer 'instances))))
                                                                  (cerror number "pas de forward-chaineur de ce nom la :" 
                                                                          forward-chainer)))
                                          

(de cerror (errornumber text arglist)
    (error (catenate " erreur no " errornumber) text arglist))



(de ftrace (nb x y z)
    (when (memq nb *trace-level*)
          (cond ((eq nb 8)
                 (print)
                 (print x)
                 (pprint y)
                 (print z)
                 (print))
          
                ((eq nb 9) 
                 (print "---structure:" x))
                ((and (eq nb 10) (equal x " post-demon d instance active sur :forward-chainer")) nil)

                ((and (eq y nil) (eq z nil)) 
                 (print "@@@trace " nb   " " x))
                ((eq z nil)
                 (print "@@@trace " nb " " x)
                 (print "@  "y))
                (t (print"@@@trace " nb " " x)
                   (print "@  " y)
                   (print "@  " z)))))



      


(de tl (x)
    (cond ((null x) nil)
          ((not (consp x))
           (setq *trace-level* (cons x *trace-level*)))
          (t  (setq *trace-level* (cons (car x) *trace-level*))
              (tl (cdr x)))))

(de tl0 ()
   (setq *trace-level* nil))


     

     
     


                                 
                                             ;UTILITAIRES DIVERS


(de cat-list (lst)
    (cond ((consp lst ) (catenate (cat-list (car lst)) (cat-list (cdr lst))))
          (t (string lst))))

  (de trace-file (item fichier flag)    ;permet de faire des logs durant une executions
      ; le flag permet d avoir des trace avec pprint au lieu de print
      (prog (savechan chan)
           (setq chan (opena (string fichier)))
            (setq savechan (outchan))
            (outchan chan)
            (cond (flag (pprint item ))
                  (t (print item)))
            (outchan savechan )
            (close chan)))

 (de new-trace-file (item fichier flag) ;ecrit quelque chose surr un fichier reinitialise
     (prog (savechan chan)

           (setq chan (openo (string fichier)))
           (setq savechan (outchan))
           (outchan chan)
           (cond (flag (pprint item ))
                 (t (print item)))
           (outchan savechan )
           (close chan)))                   
     
(de log-print (item)
    (cond ((null *log-trace*)
           (setq *log-trace* 'appli.log)
           (new-trace-file item *log-trace* nil)
           (print item))
          (t 
           (trace-file item *log-trace* nil)
           (print item))))


(de top (object)
    (top1 (get object 'object-property)))

        (de top1 (lst)
            (cond((null lst) nil)
                 (t (cons (car (car lst)) (top1 (cdr lst))))))

(de user-slots (object)
    (prog (top top2)
          (setq top (top object))
          (setq top (mapcan '(lambda (x) (cond ((eq (get-slot-facet-value object x 'existence-status) 'system) nil)
                                               (t (list x))))
                            top))
          (setq top2 (mapcar '(lambda (x) (list x (get-slot-facet object x 'value)))
                             top))
          (return top2)))

(de show (object)
    (pprin (user-slots object))
    nil)

(de show-rule (rule)
    (print " premisse : 
")
    (pprin (get-fondamental-value rule 'premisse))
    (print " conclusion :
")
    (pprin (get-fondamental-value rule 'conclusion))
    (print " description :
")
    (pprin (get-fondamental-value rule 'contens-description))
    nil)

(de sf (n)
    (show-rule (implodech (append (explodech  'forward-rule-) (explodech n)))))

(de sb (n)
    (show-rule (implodech (append (explodech  'backward-rule-)  (explodech n)))))

(de qf (n) 
    (prog (r)
         
          (setq r (implodech (append (explodech  'forward-rule-)  (explodech n))))
          (print r)
          (pprin (get-fondamental-value r 'contens-description))))

(de qb (n) 
    (prog (r)
          (setq r (implodech (append (explodech  'backward-rule-)  (explodech n))))
          (print r)
          (pprin (get-fondamental-value r 'contens-description))))



(de complete-save-object (object  object-name file-name directory)
     (prog ((user-slots (user-slots object))
            (meta (get-slot-value object 'metaclass))
            savechan chan 
            )
          (setq savechan (outchan))
          (setq chan (openo  (catenate (string directory) "/" (string file-name) ".object")))
          (outchan chan)
          (print (list 'user-instanciate meta (concat "'" object-name) nil))
          (mapc '(lambda (x) (print (list 'setf
                                          (list 'get-slot-value (concat "'" object-name) (concat "'" (car x))) 
                                          (concat "'" (get-slot-value object (car x))))))
                user-slots)
          (print)
          (outchan savechan)
          (close)
          ))



(de save-object (object)
    (complete-save-object object object object "/usr/jupiter/olivier/expert/tmp" ))

(de truncate* (x)
    (cond ((< x 32768.) (truncate x))
          (t (let ((z (* (truncate* (/ x 32768.)) 32768)))
               (+ z (truncate (- x z)))))))

(de truncate-* (x)
      (cond ((< x 32768.) (truncate x))
          (t (let ((z (* (truncate* (/ x 32768.)) 32768)))
               (+ z (truncate (- x z)))))))

(de date-d-aujourd-hui ()
    (let ((a (date)))
      (list (- (vref a 0) 1900)
            (vref a 1)
            (vref a 2)
            (vref a 3)
            (vref a 4)
            (vref a 5))))

(setq *date-des-calculs* (date-d-aujourd-hui))


  
(de add-knowledge-base (knb super-knb asso-obs glo-pas)
    (let (kb1)
      (setq *knowledge-bases* (cons knb *knowledge-bases*))
     (setq kb1 ($ 'knowledge-base 'instanciate knb nil))
     (setf (get-slot-value kb1 'super-knowledge-base) super-knb)
     (when super-knb (setf (get-slot-value super-knb 'list-of-sub-knowledge-bases)
                           (cons knb  (get-slot-value super-knb 'list-of-sub-knowledge-bases))))
     (setf (get-slot-value kb1 'list-of-associated-objects) asso-obs)
     (setf (get-slot-value kb1 'list-of-global-parameters) glo-pas)
     kb1))


(de knowledge-base-reinitialise (kb obj-liste)
    (prog ((super-kb (get-slot-value kb 'super-knowledge-base))
           (l-sub-kb (get-slot-value kb 'list-of-sub-knowledge-bases))
           (l-objects-intouchables (get-slot-value kb 'list-of-associated-objects)))
          (mapc '(lambda (skb)
                   (setq  l-objects-intouchables (append-new ($ skb 'intouchable-object-list)  l-objects-intouchables))
                   )
                l-sub-kb)
          (mapc '(lambda (obj)
                   (let ((l-inst (get-all-instances obj)))
                     (mapc '(lambda (s-obj)   
                              (when (not (memq s-obj  l-objects-intouchables))
                                    (delete-object s-obj)))
                           l-inst)))
                l-objects-intouchables)
          (return   l-objects-intouchables)
          ))

(de knowledge-base-intouchable-object-list (kb)
       (prog ((super-kb (get-slot-value kb 'super-knowledge-base))
              (l-sub-kb (get-slot-value kb 'list-of-sub-knowledge-bases))
              (l-objects-intouchables (get-slot-value kb 'list-of-associated-objects)))
             (mapc '(lambda (skb)
                      (setq  l-objects-intouchables (append-new ($ skb 'intouchable-object-list)  l-objects-intouchables))
                      )
                   l-sub-kb)
             (return   l-objects-intouchables)
             ))
                         ;Premieres creations ....


                                   ;CREATION DES OBJECTS DE BASE DU MONDE 
                                        ;description de l'objet metaclass
 
        (create-object 'metaclass nil nil)

        (add-method 'metaclass 'user-instanciate 'instanciate 'superseed)
        (add-method 'metaclass 'user-get-value 'get-value 'superseed)
        (add-method 'metaclass 'user-put-value 'put-value 'superseed)
        (add-method 'metaclass 'user-add-value 'add-value 'superseed)
        (add-method 'metaclass 'user-get-facet 'get-facet 'superseed)
        (add-method 'metaclass 'user-put-facet  'put-facet 'superseed)
        (add-method 'metaclass 'add-slot-user 'add-slot 'superseed)
        (add-method 'metaclass 'add-method 'add-method 'superseed)
        (add-method 'metaclass 'add-pre-instanciation-demon 'add-pre-instanciation-demon 'superseed)
        (add-method 'metaclass 'add-post-instanciation-demon 'add-post-instanciation-demon 'superseed)
        (add-method 'metaclass 'add-read-demon 'add-read-demon 'superseed)
        (add-method 'metaclass 'add-write-before-demon 'add-write-before-demon 'superseed)
        (add-method 'metaclass 'add-write-after-demon 'add-write-after-demon 'superseed)                
        (add-method 'metaclass 'initialize-object 'initialize 'superseed)
        (add-method 'metaclass 'add-link 'add-link 'superseed)
        (add-method 'metaclass 'get-link 'get-link 'superseed)
        (add-method 'metaclass 'determine-slot-value 'determine 'superseed)
        (add-method 'metaclass 'expand-object 'expand 'superseed)
        (add-method 'metaclass 'delete-object 'delete 'superseed)
        (add-method 'metaclass 'save-object 'save 'superseed)

                                        ;description de l object knowledge-base
        ($ 'metaclass 'instanciate 'knowledge-base nil)
        (add-slot-user 'knowledge-base 'list-of-associated-objects 'instance)
        (add-slot-user 'knowledge-base 'list-of-global-parameters 'instance)
        (add-slot-user 'knowledge-base 'super-knowledge-base 'instance)
        (add-slot-user 'knowledge-base 'list-of-sub-knowledge-bases 'instance)
        (add-method 'knowledge-base 'knowledge-base-reinitialise 'reinitialise 'superseed)
        (add-method 'knowledge-base 'knowledge-base-intouchable-object-list 'intouchable-object-list 'superseed)

      

                                        ;description de l'object  situation-bloc

        (create-object 'situation-bloc 'metaclass nil)
        (add-slot-user 'situation-bloc 'slot-list 'instance)
        (add-slot-user 'situation-bloc 'predicat 'instance)
        (add-slot-user 'situation-bloc 'compiled-predicat 'instance)
        (add-slot-user 'situation-bloc 'action 'instance)
        (add-slot-user 'situation-bloc 'compiled-action 'instance)
        (add-method 'situation-bloc 'situation-block-check-condition 'check-condition 'superseed)
        (add-method 'situation-bloc 'situation-bloc-activate 'activate 'superseed)
        (add-method 'situation-bloc 'situation-bloc-desactivate 'desactivate 'superseed)


                                        ;description de l'objet determination-mean

        (create-object 'determination-mean 'metaclass nil)

                                        ;cette notion sert uniquement a regroupper les moyen de determination suceptible
                                        ;d apparaitre dans la facette determination-means des slots


                                        ;description de l'object  determination-bloc

        (create-object 'determination-bloc 'metaclass (copy '(determination-mean)))
        (add-slot-user 'determination-bloc 'body 'instance)
        (add-slot-user 'determination-bloc 'compiled-body 'instance)
        (add-slot-user 'determination-bloc 'list-of-intermediate-bindings 'instance)
        (add-method 'determination-bloc 'determination-bloc-determine 'determine 'superseed)


                                        ;description de l'object chainer

        (create-object 'chainer 'metaclass (copy '(determination-mean)))
        (add-slot-user 'chainer 'rule-list 'instance)
        (declare-slot-type 'chainer 'rule-list 'list-of-objects nil)

                                        ;normalement le rule-list est un slot de type list-of-objects
                                        ;ou chaque objet de cette liste est une regle



                                        ;description de l'object forward-chainer

        ($ 'metaclass 'instanciate 'forward-chainer (copy '(chainer)))
        (add-slot-user 'forward-chainer 'conflict-set 'instance)
        (add-slot-user 'forward-chainer 'max-tag-number 'instance)
        (add-slot-user 'forward-chainer 'fired-binding-list 'instance)
        (add-slot-user 'forward-chainer 'current-binding-list 'instance)
        (add-slot-user 'forward-chainer 'current-hypothetical-world 'instance)
        (add-slot-user 'forward-chainer 'current-hypothetical-world-sequence 'instance)
        (add-slot-user 'forward-chainer 'current-supplementary-hypothetical-world-sequence 'instance)
        (add-slot-user 'forward-chainer 'hypothetical-world-tree 'instance)
        (add-slot-user 'forward-chainer 'basic-hypothetical-world 'instance)
        (add-slot-user 'forward-chainer 'stop-flag 'instance)
        (add-method 'forward-chainer 'forward-chainer-one-step 'one-step 'superseed)
        (add-method 'forward-chainer 'forward-chainer-go 'go 'superseed)
        (add-method 'forward-chainer 'forward-chainer-determine 'determine 'superseed)
        (add-method 'forward-chainer 'forward-chainer-sature 'sature 'superseed)
        (add-method 'forward-chainer 'forward-chainer-super-sature 'super-sature 'superseed)
        (add-method 'forward-chainer 'add-forward-rule 'add-rule 'superseed)
        
        (add-post-instanciation-demon 'forward-chainer '(lambda (x) 
                                                        ($ x 'put-value  'current-hypothetical-world-sequence
                                                           (copy '(fondamental))))
                                      'merge-after)


        
                                        ;normalement le contenu du slot rule-list est une liste d'objet de type forward-rule


                                        ;description de l'object backward-chainer


        ($ 'metaclass 'instanciate 'backward-chainer (copy '(chainer)))
        (add-slot-user 'backward-chainer 'rule-list 'instance)
        (add-method 'backward-chainer 'add-backward-rule 'add-rule 'superseed)
        (add-method 'backward-chainer 'backward-chainer-try-to-determine-internally 'intern-determine 'superseed)
        (add-method 'backward-chainer 'backward-chainer-try-to-determine-externally  'determine 'superseed)
        (declare-slot-type 'backward-chainer 'rule-list 'list-of-objects nil)

                                        ;normalement le contenu du slot rule-list est une liste d'object du type backward-rule

                                        ;description de l'object rule

        ($ 'metaclass 'instanciate 'rule nil)
        (add-slot-user 'rule 'premisse 'instance)
        (add-slot-user 'rule 'compiled-premisse 'instance)
        (add-slot-user 'rule 'conclusion 'instance)
        (add-slot-user 'rule 'compiled-conclusion 'instance)
        (add-slot-user 'rule 'list-of-intermediate-bindings 'instance)
        (add-slot-user 'rule 'determination-mean  'instance)
        (add-slot-user 'rule 'contens-description  'instance)
        

                                        ;normalement le slot determination-mean contiendra la 
                                        ;liste des determination-mean qui l'utiliseront


                                        ;description de l'object forward-rule

        ($ 'metaclass 'instanciate 'forward-rule (copy '(rule)))
 
        
        


                                        ;description de l'object backward-rule

        ($ 'metaclass 'instanciate 'backward-rule (copy '(rule)))
        (add-slot-user 'backward-rule 'concluded-attribut 'instance)
        (add-slot-user 'backward-rule 'concluded-slot 'instance)
        (add-slot-user 'backward-rule 'concluded-variable 'instance)
        (add-slot-user 'backward-rule 'concluded-type 'instance)
        ;l'argument formel est toujours *formal-argument*


                                        ;description de l'object  hypothetical-world ou monde hypothetique

                                                                           
        ($ 'metaclass 'instanciate 'hypothetical-world nil)
        (add-slot-user 'hypothetical-world 'parent-world 'instance)
        (add-slot-user 'hypothetical-world 'children-worlds 'instance)
        (add-slot-user 'hypothetical-world 'initialisation-sequence 'instance)
        (add-slot-user 'hypothetical-world 'parent-backtracker 'instance)
        (add-slot-user 'hypothetical-world 'excluded 'instance)

        ($ 'hypothetical-world 'instanciate 'fondamental nil)


                                        ;description de l'object backtracker
        ($ 'metaclass 'instanciate 'backtracker nil)
        (add-slot-user 'backtracker 'parent-backtracker 'instance)
        (add-slot-user 'backtracker 'hypothetical-world-list 'instance)
        (add-slot-user 'backtracker 'fired-hypothetical-world-list 'instance)
        (add-slot-user 'backtracker 'current-hypothese 'instance)
        (add-slot-user 'backtracker 'point-name 'instance)
        (add-slot-user 'backtracker 'best-first-function 'instance)               ;fonction prenant pour argument le backtracker
                                                                                  ;et l'hypothese en cours et rendant la
                                                                                  ;prochaine hypothese a essayer

        (add-slot-user 'backtracker 'find-next-function 'instance)                ;fonction prenant pour argument le backtracker
                                                                                  ;l hypothese en cours et la prochaine
                                                                                  ; hypothese de travail et doit rendre cette
                                                                                  ;cette hypothese ou nil


        (add-method 'backtracker 'backtracker-backtrack 'backtrack 'superseed)    ;bactracke automatiquement
                                                                                  ;sur l'hypothese en cours
                                                                                  ;arguments : backtracker 

        (add-method 'backtracker 'backtracker-backtrack-to 'backtrack-to 'superseed)  ;backtracke sur un point de decision nomme
                                                                                      ;arguments : backtracker ,point-nomme



                                        ;description de l object "classe quelconque"
                                        ;et "object quelconque" instance de "classe quelconque"

        ($ 'metaclass 'instanciate 'anything nil)
        ($ 'anything 'instanciate 'something nil)



    
                                 
        
(add-knowledge-base 'object-de-base
                    nil
                    (copy '(situation-bloc determination-mean determination-bloc chainer forward-chainer backward-chainer rule 
                                     forward-rule backward-rule hypothetical-world fondamental something anything))
                    nil)

   
(print "object.lisp version 1.2")