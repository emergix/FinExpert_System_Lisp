;fichier regrouppant les objects et fonctions concernes par le chainage avant avec l algorithme de rete
(add-knowledge-base 'forward 
                    'object-de-base
                    '(rete-forward-chainer)
                    nil)

 (setq *rete-forward-chainer-activation-list* nil)


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
          (add-slot-system object 'rete-forward-chainer-list 'anything date-of-creation
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
                                        ; mise a jour des differents forward-chainers
          (setq x-list nil)
          (cond ((and (setq inter (intersect (get-slot-facet-value object slot 'rete-forward-chainer-list) 
                                           *rete-forward-chainer-activation-list*))
                      (not (equal new-value old-value)) ;
                      old-value)
                 (mapc '(lambda (x)   (when (not (memq x x-list))
                                            ($ x 'new-value object slot old-value new-value) (setq x-list (cons x x-list)))) 
                       inter) )
                ((or (and inter
                          (not (equal new-value old-value))
                          (null old-value))     
                     (and (eq new-value nil)
                          inter
                          (eq (get-slot-facet object slot 'determined) t)))
                 (mapc '(lambda (x) (when (not (memq x x-list)) 
                                          ($ x 'set-value object slot new-value) (setq x-list (cons x x-list))))
                       inter)))
          (cond ((and (setq inter (intersect (get-fondamental-value (get-fondamental-value object 'metaclass) 'rete-forward-chainer-list)
                                             *rete-forward-chainer-activation-list*))
                      (not (equal new-value old-value)) ;
                      old-value)
                 (mapc '(lambda (x)   (when (not (memq x x-list))
                                            ($ x 'new-value object slot old-value new-value) (setq x-list (cons x x-list)))) 
                       inter) )
                ((or (and inter
                          (not (equal new-value old-value))
                          (null old-value))     
                     (and (eq new-value nil)
                          inter
                          (eq (get-slot-facet object slot 'determined) t)))
                 (mapc '(lambda (x)  (when (not (memq x x-list))
                                           ($ x 'set-value object slot new-value) (setq x-list (cons x x-list))))
                       inter)))
        
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
                                        ; mise a jour des differents forward-chainers de rete

          (setq x-list nil)
          (cond ((and (setq inter (intersect (get-slot-facet-value object slot 'rete-forward-chainer-list) 
                                           *rete-forward-chainer-activation-list*))
                      (not (equal new-value old-value)) ;
                      old-value)
                 (mapc '(lambda (x)   (when (not (memq x x-list))
                                            ($ x 'new-value object slot old-value new-value) (setq x-list (cons x x-list)))) 
                       inter) )
                ((or (and inter
                          (not (equal new-value old-value))
                          (null old-value))     
                     (and (eq new-value nil)
                          inter
                          (eq (get-slot-facet object slot 'determined) t)))
                 (mapc '(lambda (x) (when (not (memq x x-list)) 
                                          ($ x 'set-value object slot new-value) (setq x-list (cons x x-list))))
                       inter)))
          (cond ((and (setq inter (intersect (get-fondamental-value (get-fondamental-value object 'metaclass) 'rete-forward-chainer-list)
                                             *rete-forward-chainer-activation-list*))
                      (not (equal new-value old-value)) ;
                      old-value)
                 (mapc '(lambda (x)   (when (not (memq x x-list))
                                            ($ x 'new-value object slot old-value new-value) (setq x-list (cons x x-list)))) 
                       inter) )
                ((or (and inter
                          (not (equal new-value old-value))
                          (null old-value))     
                     (and (eq new-value nil)
                          inter
                          (eq (get-slot-facet object slot 'determined) t)))
                 (mapc '(lambda (x)  (when (not (memq x x-list))
                                           ($ x 'set-value object slot new-value) (setq x-list (cons x x-list))))
                       inter)))
        

              
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
              (return old-value)
              ))



(de add-rete-forward-chainer (name slot-list)
    (check-defined-object 3 name)
    (user-instanciate 'rete-forward-chainer name nil)
    (mapc '(lambda (x)
             (add-slot-user name x 'class))
          slot-list)
    (set name name)
    name)

 (de llf () (load "/usr/jupiter/olivier/forward.lisp"))


                        ;description de l'object rete-forward-chainer

        ($ 'metaclass 'instanciate 'rete-forward-chainer '(chainer))
        (add-slot-user 'rete-forward-chainer 'slot-list 'instance)
        (add-slot-user 'rete-forward-chainer 'network 'instance)
        (add-slot-user 'rete-forward-chainer 'working-memory 'instance)
        (add-slot-user 'rete-forward-chainer 'conflict-set 'instance)
        (add-slot-user 'rete-forward-chainer 'max-tag-number 'instance)
        (add-slot-user 'rete-forward-chainer 'ready-to-fire 'instance)
        (add-slot-user 'rete-forward-chainer 'fired-binding-list 'instance)
        (add-slot-user 'rete-forward-chainer 'current-binding-list 'instance)
        (add-method 'rete-forward-chainer 'rete-forward-chainer-one-step 'one-step 'superseed)
        (add-method 'rete-forward-chainer 'rete-forward-chainer-go 'go 'superseed)
        (add-method 'rete-forward-chainer 'rete-forward-chainer-new-value 'new-value 'superseed)
        (add-method 'rete-forward-chainer 'rete-forward-chainer-set-value 'set-value 'superseed)
        (add-method 'rete-forward-chainer 'rete-forward-chainer-determine 'determine 'superseed)
        (add-method 'rete-forward-chainer 'add-rete-forward-rule 'add-rule 'superseed)
        (add-method 'rete-forward-chainer 'rete-forward-chainer-initialize-facts 'initialize-facts 'superseed)
        (add-method 'rete-forward-chainer 'rete-forward-chainer-initialize 'initialize 'superseed)
        (add-method 'rete-forward-chainer 'rete-forward-chainer-activate 'activate 'superseed)
        (add-method 'rete-forward-chainer 'rete-forward-chainer-desactivate 'desactivate 'superseed)




(add-post-instanciation-demon 'rete-forward-chainer '(lambda (x)
                                                        (setq  *rete-forward-chainer-activation-list*
                                                               (cons x *rete-forward-chainer-activation-list*))
                                                        (setf (get-slot-value x 'ready-to-fire ) 'yes))
                                                        'superseed)


(de rete-forward-chainer-new-value (forchainobject object slot old-value new-value)
      (rete-interprete  forchainobject 
                            (list '-  object slot old-value))
          
      (rete-interprete  forchainobject 
                            (list '+  object slot new-value)))
       
            


(de rete-forward-chainer-set-value (forchainobject object slot new-value)
                  (rete-interprete  forchainobject 
                            (list '+  object slot new-value)))


(de rete-forward-chainer-determine (forchainobject object slot )
    (prog(value verification)
         (rete-forward-chainer-reset-facts forchainobject)
         (rete-forward-chainer-initialize forchainobject)
         (ctrace 3 (list " lancement du chaineur avant " forchainobject " pour determiner :" slot  "{" object "}"))
         loop
         (setq verification (funcall (get-slot-facet-value object slot 'determination-predicat)
                                     object
                                     slot
                                     (setq value (get-slot-value object slot))))
         (when verification
               (ctrace 3 (list " il a ete conclu par chainage avant de " forchainobject " que :"
                               slot  "{" object "} = " value))
               (return value))
         (ctrace 3 (list "un step de forward-chaining de " forchainobject " va etre effectue"))
         (rete-forward-chainer-one-step forchainobject)
         (go loop)))

          

(de rete-forward-chainer-reset-facts (reteforchainobject )
 (prog () 
       (when (not(member reteforchainobject *rete-forward-chainer-activation-list*  ))
             (setq  *rete-forward-chainer-activation-list* (cons forchainobject *rete-forward-chainer-activation-list*)))
       (setf (get-slot-value reteforchainobject 'working-memory) nil)
       (setf (get-slot-value reteforchainobject 'conflict-set) nil)
       (setf (get-slot-value reteforchainobject 'ready-to-fire) nil)))
)))



(de rete-forward-chainer-activate (forchainobject)
 (when (not(member forchainobject *rete-forward-chainer-activation-list*  ))
  (setq  *rete-forward-chainer-activation-list* (cons  forchainobject *rete-forward-chainer-activation-list*)))
 (setf (get-slot-value forchainobject 'ready-to-fire ) 'yes))



(de rete-forward-chainer-desactivate (forchainobject)
 (when (member forchainobject *rete-forward-chainer-activation-list*  )
  (setq  *rete-forward-chainer-activation-list* (remove  forchainobject *rete-forward-chainer-activation-list*)))
 (setf (get-slot-value forchainobject 'ready-to-fire ) 'no))


(de add-rete-forward-rule (forchainobject premisse conclusion)
    (prog (rule wm compiled-premisse compiled-conclusion new-network old-network slot-list instances)
          (setq old-network (get-slot-value forchainobject 'network))

          (if (not (member forchainobject (get-slot-value 'rete-forward-chainer 'instances)))
              (cerror 80 "pas de forward-chainer de ce nom la :"    forchainobject))
          (setq rule ($ 'forward-rule 'instanciate nil nil))
          (setq *forward-translation-predicat-state* 'forward)
          (setq new-network (optimize-incremental (analyse-premisse premisse rule forchainobject)  old-network))
          (setq compiled-conclusion (macroexpand (top-traduc-conclusion
                                                  (translate-atom-forward-3
                                                   (translate-atom-forward-2
                                                    (translate-atom-forward-1 
                                                     (translate-atom conclusion)))) rule)))
          ($ rule 'put-value 'premisse premisse)
          ($ rule 'put-value 'conclusion conclusion)
          ($ rule 'put-value 'compiled-conclusion (copy compiled-conclusion))
          ($ rule 'put-value 'determination-mean forchainobject)
          ($ forchainobject 'put-value 'network new-network)
          ($ forchainobject 'add-value 'rule-list rule)
          (setq slot-list (mapcan '(lambda (x) (cond ((eq (get  x 'type) 'n0-metaclass )
                                                      (mapcar '(lambda (y)  (list (get  x 'metaclass) 
                                                                                  (get  (car y) 'attribute-name)
                                                                                  'metaclass))
                                                              (get  x 'S)))
                                                     ((eq (get  x 'type) 'n0-obj)
                                                      (mapcar '(lambda (y)  (list (get  x 'object-name) 
                                                                                  (get  (car y) 'attribute-name)
                                                                                  'instance))
                                                              (get  x 'S)))))
                                  new-network))
                                                
          (mapc '(lambda (x) (when (null (get-slot-facet (car x) (cadr x) 'rete-forward-chainer-list))
                                  (add-slot-facet (car x) (cadr x) 'rete-forward-chainer-list nil)))
                   slot-list)
          (mapc '(lambda (x)
                   (when (eq (caddr x) 'metaclass)
                         (setf (get-slot-value (car x)  'rete-forward-chainer-list)
                               (append-new (list forchainobject) 
                                           (get-slot-facet-value (car x) (cadr x) 'rete-forward-chainer-list))))
                      
                   (when (eq (caddr x) 'instance)
                         (setf (get-slot-facet-value (car x) (cadr x) 'rete-forward-chainer-list)
                               (append-new (list forchainobject) 
                                           (get-slot-facet-value (car x) (cadr x) 'rete-forward-chainer-list)))))
                slot-list)
          ($ forchainobject 'put-value 'slot-list slot-list)
          (setq *forward-translation-predicat-state* nil)
          (return rule)))

        
(de rete-forward-chainer-one-step (reteforchainobject)
    (prog ( conflictset)
          
         
          (when (not (eq (get-slot-value forchainobject 'ready-to-fire) 'yes))
                (ctrace 3 (list "chainage avant de rete par " reteforchainobject))
                (setq conflictset  (get-slot-value reteforchainobject 'conflict-set)))
          (return (forward-execute-conclusion conflictset reteforchainobject))))
          

(de rete-forward-chainer-go (forchainobject)
    (prog ( conflictset result ruleset)
          (setf (get-slot-value forchainobject 'fired-binding-list) nil)
          (when (not (eq (get-slot-value forchainobject 'ready-to-fire) 'yes))
                (rete-forward-chainer-reset-facts forchainobject)
                (rete-forward-chainer-initialize forchainobject))

          loop
          (setq conflictset (get-slot-value forchainobject 'conflict-set))
          (ctrace 5  "== rete conflict set ===")
          (ctrace 5 conflictset)
          (ctrace 5  "===================")
          (setq result (rete-forward-execute-conclusion conflictset forchainobject))
        
          (when (eq result nil) (return nil))
          (go loop)))


(de rete-forward-execute-conclusion     (conflict-set forchainobject)
    (prog (rule rank binding-list var-list settings r1 s s1 rank ntags ntags1 chain-save)
                                        ;resolution du conflit
        
          (when (null conflict-set) 
                (ctrace 3 " pas de regle applicable : fin du chainage avant")
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
          (ctrace 3 (list rule " fired"))
          (setq binding-list (get-forward-binding-list conflict-set rule rank))
          (setf (car(nth rank (cdr (assoc rule conflict-set)))) 'fired)
          (setq var-list (first-list binding-list))
          (setf (get-slot-value forchainobject 'fired-binding-list) 
                (cons (cons (cons '*rule* rule) binding-list)
                      (get-slot-value forchainobject 'fired-binding-list) ))

          (setq settings (backward-conclusion-settings var-list binding-list))
          (eval `(let ,var-list ,@settings
                      (funcall (get-slot-value (quote ,rule) 'compiled-conclusion) forchainobject)))
          (setq  *current-forward-chainer-object* chain-save)
          (return rule)))


                     
(de rete-forward-chainer-initialize (forchainobject)
        (prog (slotp-list ob-list ob)
              (setq slotp-list (get-slot-value forchainobject 'slot-list))
              (setq ob-list nil)
              loop
              (when (null slotp-list) (go loop1))
              (setq slotp (car slotp-list))
              (when (eq (caddr slotp) 'metaclass)
                    (setq ob-list (append (mapcar '(lambda (x) (list x (cadr slotp)))
                                                  (get-slot-value (car slotp) 'instances))
                                          ob-list)))
              (when (eq (caddr slotp) 'instance)
                    (setq ob-list (cons (list (car slotp) (cadr slotp)) ob-list)))
              (setq slotp-list (cdr slotp-list))
              (go loop)
              loop1
              (when (null ob-list)(return ))
              (setq ob (car ob-list))
              (forward-new-fact (get-slot-value forchainobject 'network)
                                (get-slot-value forchainobject 'conflict-set)
                                (get-slot-value forchainobject 'working-memory)
                                (list nil
                                      '+
                                      (car ob)
                                      (cadr ob)
                                      (get-slot-value (car ob) (cadr ob))))
              (setq ob-list (cdr ob-list))
              (go loop)))
                        
  
;on ne peut demarrer le chainage rete qu'apres une phase d'initialisation si celui-ci a ete desactive entre-temps

 (de rete-interprete  (rete-chainer token)
(print '**************1 rete-chainer  token)
                                        ;fait passer le token d'entree le long du reseau
     (prog (pnodlist nod pnod ntokens ntokens2 pnods node1 pnodcar)
           (setq  pnodlist (copy (get-slot-value rete-chainer 'network)))
           loop
           (print "pnode-list =" pnodlist)
           (cond 
            ((eq pnodlist nil) (return ()))
                                        ;on calcule le nouveau token a transmettre
            (t (setq pnod (rete-pop pnodlist))
                                        ; (print "pnod = " pnod)
               (cond ((variablep pnod) (setq pnodcar pnod)
                      (setq ntokens (rete-transfert pnod () token)))
                     (t (setq pnodcar (car pnod))
                        (setq ntokens (rete-transfert pnodcar
                                                 (cadr pnod) 
                                                 (cddr pnod)))))))
                                        ;une fois les nouveaux tokens calcules
                                        ; on les transmet aux noeuds suivants
                                        ;ensemble des noeuds suivants=pnods
                                        ;element de pnods=(noeud . entree)
           ;(print "tokens a transmettre =" ntokens)
           ;(print "ensemble des noeuds suivants =" (get pnodcar 'S))
                                        ; element de pnodlist=(noeud entree . tokentransmis)
                                        ; token transmis= ((+- tokenproprementdit) (...))
           (cond
            ((and (not (eq ntokens nil)) (not (eq (get pnodcar 'S) nil)))
             (setq pnods (get pnodcar 'S)) ;de la forme ((g102) (g103) ..(g105 . D))
                                        ;(print pnods)
             (tagbody
              loop1
              (cond
               ((eq pnods ()) (go loop))
               (t
                  (setq node1 (rete-pop pnods))
                  (setq ntokens2 ntokens)
                  (tagbody
                   loop2
                   (cond
                    ((eq ntokens2 nil) (go loop1))
                    (t
                     (setq ntoken (rete-pop ntokens2))
                     (setq pnodlist (append pnodlist 
                                            (list (cons (car node1)
                                                        (cons (cdr node1)
                                                              ntoken)))))))
                   ; (print pnodlist)
                   (go loop2))))
              (go loop1))))
           (go loop)))


 (dmd rete-pop (stack)
      `(let (x) (setq x (car ,stack))
            (setq ,stack (cdr ,stack))
            x))

 (de rete-transfert (node entree token)
     (let (type)
       (setq type (get node 'type))
       (selectq 
        type
       (n0-obj (n0-obj-rete-transfert token node))
       (n0-o-v (n0-o-v-rete-transfert token node))
       (n0-a-v (n0-a-v-rete-transfert token node))
       (n0-metaclass (n0-metaclass-rete-transfert token node))
       (n0-att (n0-att-rete-transfert token node))
       (n0-att= (n0-att=-rete-transfert token node))
       (n0-att<> (n0-att<>-rete-transfert token node))
       (n0-att> (n0-att>-rete-transfert token node))
       (n0-att< (n0-att<-rete-transfert token node))
       (n0-att>= (n0-att>=-rete-transfert token node))
       (n0-att<= (n0-att<=-rete-transfert token node))
       (n0-attinclusion (n0-attinclusion-rete-transfert token node))
       (n0-attmember (n0-attmember-rete-transfert token node))
       (n0-attor (n0-attor-rete-transfert token node))
       (n0-attand (n0-attand-rete-transfert token node))
       (n0-attrete-xor (n0-attrete-xor-rete-transfert token node))
       (n0-= (selectq 
              entree
              (G (n0-=-rete-transfert-G token node))
              (D (n0-=-rete-transfert-D token node))))
       (n0-<> (selectq
               entree 
               (G (n0-<>-rete-transfert-G token node))
               (D (n0-<>-rete-transfert-D token node))))
       (n0->= (selectq
               entree 
               (G (n0->=-rete-transfert-G token node))
               (D (n0->=-rete-transfert-D token node))))
       (n0-<= (selectq
               entree 
               (G (n0->=-rete-transfert-G token node))
               (D (n0->=-rete-transfert-D token node))))
       (n0-< (selectq 
              entree 
              (G (n0-<-rete-transfert-G token node))
              (D (n0-<-rete-transfert-D token node))))
       (n0-> (selectq
              entree
              (G (n0->-rete-transfert-G token node))
              (D (n0->-rete-transfert-D token node))))
       (n0-inclusion (selectq
                      entree 
                      (G (n0-inclusion-rete-transfert-G token node))
                      (D (n0-inclusion-rete-transfert-D token node))))
       (n0-member (selectq 
                   entree 
                   (G (n0-member-rete-transfert-G token node))
                   (D (n0-member-rete-transfert-D token node))))
       (n0-or (selectq
               entree 
               (G (n0-or-rete-transfert-G token node))
               (D (n0-or-rete-transfert-D token node))))
       (n0-and (selectq
                entree
                (G (n0-and-rete-transfert-G token node))
                (D (n0-and-rete-transfert-D token node))))
       (n0-and-not (selectq
                    entree 
                    (G (n0-and-not-rete-transfert-G token node))
                    (D (n0-and-not-rete-transfert-D token node))))
       
       (n0-rete-xor (selextq
                     entree 
                     (G (n0-rete-xor-rete-transfert-G token node))))
       (n0-rete-xor (selectq
                     entree 
                     (D (n0-rete-xor-rete-transfert-D token node))))
       (rule-node (rule-node-rete-transfert token node)))))
       


            ;grammaire utilisee pour la comprehension des premisses de regles de rete

; expression.booleenne --> (existing (a 'toto) expression.boolenne )
;                      --> (= expression.booleenne  expression.booleeenne )
;                      --> (c= attribute.decriptor expression.lisp)
;                      --> (attribute-descriptor attribute.descriptor)

; attribute.descriptor --> (object slot)

;de plus les objects rencontres dans les attribute.descriptor sont declare constant si il n ont pas ete
;declare variable dans un existing accessible lexicalement

;une premiere traduction est effectuee par analyse-premisse (expression rule)
;qui renvoie une liste de top-nodes 
;l optimisation  est alors assuree par optimise-rete-rule ( liste-de-top-nodes-1 , liste-de-top-nodes-2)


(de analyse-premisse (exp rule forchainobject)
    (prog (nn opt)
          (setq *liste-des-variables-scannees* nil)
          (setq nn (rule-node-create rule forchainobject))
          (setq opt (analyse-expression-booleenne exp  (list (list nn))))
          (return opt)))

(de analyse-expression-booleenne (exp  pp)
                                        ; pp est le non du neud qui doit figurer en sortie de l expression
    (prog (nn nn2)
          (cond((= (length exp) 3)
                (cond((and (eq (car exp) 'and)
                           (eq (length (cadr exp)) 2)
                           (eq (caadr exp) 'not))
                      (setq nn (n0-and-not-create  pp))
                      (return (append (analyse-expression-booleenne (cadadr exp) (list (cons  nn 'G)) )
                                      (analyse-expression-bboleenne (caddr exp) (list (cons nn 'D)) ))))
                     ((and (eq (car exp) 'and)
                           (eq (length (caddr exp)) 2)
                           (eq (caaddr exp) 'not))
                      (setq nn (n0-and-not-create pp))
                      (return (append (analyse-expression-booleenne  (cadr (caddr exp)) (list (cons nn 'D)))
                                      (analyse-expression-booleenne (cadr exp)  (list (cons nn 'G))) )))
                     ((and (eq (car exp) 'existing)
                           (eq (length (cadr exp)) 2))
                      (setq  *liste-des-variables-scannees*
                             (cons (cadr exp)  *liste-des-variables-scannees*))
                      (return (analyse-expression-booleenne (caddr exp) pp)))
                     ((member (car exp) '(= <> > < >= <= inclusion member or and xor))
                      (setq nn (funcall (selectq (car exp)
                                                 (= 'n0-=-create)
                                                 (<> 'n0-<>-create)
                                                 (> 'n0->-create)
                                                 (< 'n0-<-create)
                                                 (>= 'n0->=-create)
                                                 (<= 'n0-<=-create)
                                                 (inclusion 'n0-inclusion-create)
                                                 (member 'n0-member-create)
                                                 (or 'n0-or-create)
                                                 (and 'n0-and-create)
                                                 (xor 'n0-xor-create))
                                        pp))
                      (return (append (analyse-expression-booleenne (cadr exp) (list (cons nn 'G)))
                                      (analyse-expression-booleenne (caddr exp) (list (cons nn 'D))))))
                     ((eq (car exp) 'attribute-descriptor)
                      (return (analyse-attribute-descriptor (cdr exp) pp)))))

               ((= (length exp) 4)
                (cond((member (car exp) '(c= c<> c< c> c<= c>= cinclusion cmember cor cand cxor))
                      (setq nn (funcall (selectq (car exp)
                                                  (c= 'n0-att=-create)
                                                  (c<> 'n0-att<>-create)
                                                  (c> 'n0-att>-create)
                                                  (c< 'n0-att<-create)
                                                  (c>= 'n0-att>=-create)
                                                  (c<= 'n0-att<=-create)
                                                  (cinclusion 'n0-attinclusion-create)
                                                  (cmember 'n0-attmember-create)
                                                  (cor 'n0-attor-create)
                                                  (cand 'n0-attand-create)
                                                  (cxor 'n0-attxor-create))
                                         pp (caddr exp) (cadddr exp)
                                         ))
                       (return (analyse-object (cadr exp) (list (list nn)))))))
                (t nil))))

(de analyse-attribute-descriptor (exp pp)
                                        ; exp , un attribute-descriptor , est une liste (attribut object)
  (prog (nn1 nn2 m)
        
          (cond ((setq m (cdr(assoc (cadr exp)   *liste-des-variables-scannees*)))
                                        ;on a a faire a une variable
                 (setq nn1 (n0-att-create pp (car exp)))
                 (setq nn2 (n0-metaclass-create (list (list nn1)) (eval (car m)) (cadr exp)))
                 (return (list (list nn2)) ))
                (t 
                                        ;on a a faire a une constante
                 (setq nn1 (n0-att-create pp (car exp)))
                 (setq nn2 (n0-obj-create (list (list nn1)) (cadr exp)))
                 (return (list (list nn2)))))))

(de analyse-object (exp pp)
                                        ;exp = objectname ou objecttype
    (prog (nn)
          (cond ((cdr (assoc  exp *liste-des-variables-scannees*))
                                        ;on a a faire a une variable
                 (setq nn (n0-metaclass-create  pp  exp))
                 (return (list (list nn))))
                (t 
                                        ;on a a faire a une constante
                 (setq nn (n0-obj-create pp  exp))
                 (return (list (list nn)))))))
                


                                    ;OPTIMISATION DU RESEAU


(de optimize-incremental (node-list node-list-p)
    (prog (node node-list-1 node-list-f node-list-g)
          (setq node-list-1 node-list)
          (setq node-list-f (copy node-list-p))
          loop
          (when (null node-list-1) (go fin))
          (setq node (car node-list-1))
          (setq node-list-1 (cdr node-list-1))
          (setq node-list-f (optimize-incremental-1 node node-list-f))
          (go loop)
          fin
          (setq node-list-g (mapcar '(lambda (x) (car x)) node-list-f))
          (return node-list-g)))

(de optimize-incremental-1 (node node-list)
                                        ;retourne la liste node-liste avec le noeud node inseree de maniere optimisee
                                        ;on supose que node est de type( metaclass) ou (obj) et
                                        ;que le neud qui suit est detype att ou att=
    (prog (ntype nn node-list-1 node-2 ntype-2 nn-2 node-list-2)
          (setq ntype (get (car node) 'type))
          (setq node-list-1 node-list)
          loop
          (when (null node-list-1) (go fin))
          (setq nn (car node-list-1))
          (setq node-list-1 (cdr node-list-1))
          (when (not (eq (get (car nn) 'type) ntype)) (go loop))
          (cond ((eq ntype 'n0-metaclass)
                 (when (eq (get (car node) 'metaclass) (get (car nn) 'metaclass))
                       (go fin-fusion)))
                ((eq ntype 'n0-obj)
                 (when (eq (get (car node) 'object-name) (get (car nn) 'object-name))
                       (go fin-fusion))))
          fin
          (return (cons node node-list))
          fin-fusion
          (setq node-2 (caar (get (car node) 'S)))
          (setq ntype-2 (get node-2 'type))
          (setq node-list-2 (mapcar '(lambda (x) (car x)) (get (car nn) 'S)))
          (prog ()
                loop1
                (when (null node-list-2) (go fin-fusion-2))
                (setq nn-2 (car node-list-2))
                (setq node-list-2 (cdr node-list-2))
                (when (not (eq (get nn-2 'type) ntype-2)) (go loop1))
                (cond ((eq ntype-2 'att)
                       (when (eq (get node-2 'attribute-name) (get nn-2 'attribute-name))
                             (setf (get nn-2 'S) 
                                   (append (get node-2 'S) (get nn-2 'S)))
                             (go fin-fusion-1)))
                      ((memq ntype '(n0-att= n0-att<> n0-att< n0-att< n0-att> n0-att<= n0-att>=
                                             n0-attinclusion n0-attmember n0-attor n0-attand n0-attxor))
                       (when (and (eq (get node-2 'attribute-name) (get nn-2 'attribute-name))
                                  (eq (get node-2 'attribute-value) (get nn-2 'attribute-value)))
                             (setf (get nn-2 'S) 
                                   (append (get node-2 'S) (get nn-2 'S)))
                             (go fin-fusion-1))))
                (go loop1))
                      
          fin-fusion-2
          (setf (get (car nn) 'S)
                (append (get (car node) 'S) (get (car nn) 'S)))
          (return node-list)
          fin-fusion-1
          (return node-list)
          ))


  (de n0-obj-create (l objectname)
     (prog (newn)
     (setq newn (gensym))
     (setf (get newn 'type) 'n0-obj)
     (setf (get newn 'S) l)
     (setf (get newn 'object-name) objectname)
     (reseau-trace (list "noeud="  newn "objet=" objectname))
     (return newn)))

 (de n0-obj-rete-transfert (token node)
     (Reseau-trace (list "noeud=" node " token=" token "type nt1")) 
     (cond
      ((eq (cadr token) (get node 'object-name))
       (list (cons
        (car token)
        (cddr token))))
      (t ())))

(de n0-metaclass-create (l metaclass varname)
    (prog (newn)
     (setq newn (gensym))
     (setf (get newn 'type) 'n0-metaclass)
     (setf (get newn 'S) l)
     (setf (get newn 'metaclass) metaclass)
     (setf (get newn 'var-name) varname)
     (reseau-trace (list "noeud=" newn "metaclass=" metaclass))
     (return newn)))

(de n0-metaclass-rete-transfert (token node)
    (reseau-trace (list "noeud=" node "token=" token "type metaclass"))
    (cond
     ((eq (get-slot-value (cadr token) 'metaclass)
          (get node 'metaclass))
      (list (cons
                    (car token)
                    (append
                     (cddr token)
                     (list (cons (get node 'var-name)
                           (cadr token)))))))
      (t ())))




 (de n0-att-create (l attributename)
     (prog (newn)
     (setq newn (gensym))
     (setf (get newn 'type) 'n0-att)
     (setf (get newn 'S) l)
     (setf (get newn 'attribute-name) attributename)
     (reseau-trace (list "noeud=" newn "attribut=" attributename))
     (return newn)))

 (de n0-att-rete-transfert (token node)
     (Reseau-trace (list "noeud=" node " token=" token "type nt2")) 
     (cond
      ((eq (cadr token) (get node 'attribute-name))  (list (cons
                                                            (car token)
                                                            (cddr token))))
      (t ())))

 (de n0-att=-create (l attributename attributevalue)
     (prog (newn)
     (setq newn (gensym))
     (setf (get newn 'type) 'n0-att=)
     (setf (get newn 'S) l)
     (setf (get newn 'attribute-name) attributename)
     (setf (get newn 'attribute-value) attributevalue)
     (reseau-trace (list "noeud=" newn "attribut=" attributename "valeur=" attributevalue))
     (return newn)))


 (de n0-att=-rete-transfert (token node)
     (Reseau-trace (list "noeud=" node " token=" token "type nt2=")) 
     (cond
      ((and (equal (caddr token) (get node 'attribute-value))
            (equal (cadr token) (get node 'attribute-name))) 
       (list (cons (car token)
             (cdddr token))))
      (t ())))


 (de n0-att<>-create (l attributename attributevalue)
     (prog (newn)
           (setq newn (gensym))
           (setf (get newn 'type) 'n0-att<>)
           (setf (get newn 'S) l)
           (setf (get newn 'attribute-name) attributename)
           (setf (get newn 'attribute-value) attributevalue)
           (return newn)))


 (de n0-att<>-rete-transfert (token node)
     (Reseau-trace (list "noeud=" node " token=" token "type nt2<>")) 
     (cond
      ((and (equal (cadr token) (get node 'attribute-name))
            (nequal (caddr token) (get node 'attribute-value)))
       (list (car token) (cdddr token)))
      (t ())))


 (de n0-att>-create (l attributename attributevalue)
     (prog (newn)
     (setq newn (gensym))
     (setf (get newn 'type) 'n0-att>)
     (setf (get newn 'S) l)
     (setf (get newn 'attribute-name) attributename)
     (setf (get newn 'attribute-value) attributevalue)
     (return newn)))


 (de n0-att>-rete-transfert (token node)
     (Reseau-trace (list "noeud=" node " token=" token "type nt2>")) 
     (cond
      ((and (equal (cadr token) (get node 'attribute-name))
            (> (caddr token) (get node 'attribute-value)))
       (list (car token) (cdddr token)))
      (t ())))


 (de n0-att<-create (l attributename attributevalue)
     (prog (newn)
     (setq newn (gensym))
     (setf (get newn 'type) 'n0-att<)
     (setf (get newn 'S) l)
     (setf (get newn 'attribute-name) attributename)
     (setf (get newn 'attribute-value) attribute-value)
     (return newn)))


 (de n0-att<-rete-transfert (token node)
     (Reseau-trace (list "noeud=" node " token=" token "type nt2<")) 
     (cond
      ((and (equal (cadr token) (get node 'attribute-name))
            (< (caddr token) (get node 'attribute-value)))
       (list (car token) (cdddr token)))
      (t ())))


 (de n0-att>=-create (l attributename attributevalue)
     (prog (newn)
     (setq newn (gensym))
     (setf (get newn 'type) 'n0-att>=)
     (setf (get newn 'S) l)
     (setf (get newn 'attribute-name) attributename)
     (setf (get newn 'attribute-value) attributevalue)
     (return newn)))


 (de n0-att>=-rete-transfert (token node)
     (Reseau-trace (list "noeud=" node " token=" token "type nt2>=")) 
     (cond
      ((and (equal (cadr token) (get node 'attribute-name))
            (>= (caddr token) (get node 'attribute-value)))
       (list (car token) (cdddr token)))
      (t ())))


 (de n0-att<=-create (l attributename attributevalue)
     (prog (newn)
           (setq newn (gensym))
           (setf (get newn 'type) 'n0-att<=)
           (setf (get newn 'S) l)
           (setf (get newn 'attribute-name) attributename)
           (setf (get newn 'attribute-value) attributevalue)
           (return newn)))


 (de n0-att<=-rete-transfert (token node)
     (Reseau-trace (list "noeud=" node " token=" token "type nt2<=")) 
     (cond
      ((and (equal (cadr token) (get node 'attribute-name))
            (<= (caddr token) (get node 'attribute-value)))
       (list (car token) (cdddr token)))
      (t ())))


 (de n0-attinclusion-create (l attributename attributevalue)
     (prog (newn)
     (setq newn (gensym))
     (setf (get newn 'type) 'n0-attinclusion)
     (setf (get newn 'S) l)
     (setf (get newn 'attribute-name) attributename)
     (setf (get newn 'attribute-value) attributevalue)
     (return newn)))


 (de n0-attinclusion-rete-transfert (token node)
     (Reseau-trace (list "noeud=" node " token=" token "type nt2-inclusion")) 
     (cond
      ((and (equal (cadr token) (get node 'attribute-name))
            (rete-inclusion (caddr token) (get node 'attribute-value)))
       (list (car token) (cdddr token)))
      (t ())))


 (de n0-attmember-create (l attributename attributevalue)
     (prog (newn)
     (setq newn (gensym))
     (setf (get newn 'type) 'n0-attmember)
     (setf (get newn 'S) l)
     (setf (get newn 'attribute-name) attributename)
     (setf (get newn 'attribute-value) attributevalue)
     (return newn)))


 (de n0-attmember-rete-transfert (token node)
     (Reseau-trace (list "noeud=" node " token=" token "type nt2member")) 
     (cond
      ((and (equal (cadr token) (get node 'attribute-name))
            (member (caddr token) (get node 'attribute-value)))
       (list (car token) (cdddr token)))
      (t ())))


 (de n0-attor-create (l attributename attributevalue)
     (prog (newn)
     (setq newn (gensym))
     (setf (get newn 'type) 'n0-attor)
     (setf (get newn 'S) l)
     (setf (get newn 'attribute-name) attributename)
     (setf (get newn 'attribute-value) attributevalue)
     (return newn)))


 (de n0-attor-rete-transfert (token node)
     (Reseau-trace (list "noeud=" node " token=" token "type nt2or")) 
     (cond
      ((and (equal (cadr token) (get node 'attribute-name))
            (or (caddr token) (get node 'attribute-value)))
       (list (car token) (cdddr token)))
      (t ())))


 (de n0-attand-create (l attributename attributevalue)
     (prog (newn)
           (setq newn (gensym))
           (setf (get newn 'type) 'n0-attand)
           (setf (get newn 'S) l)
           (setf (get newn 'attribute-name) attributename)
           (setf (get newn 'attribute-value) attributevalue)
           (return newn)))


 (de n0-attand-rete-transfert (token node)
     (Reseau-trace (list "noeud=" node " token=" token "type nt2and")) 
     (cond
      ((and (equal (cadr token) (get node 'attribute-name))
            (and (caddr token) (get node 'attribute-value)))
       (list (car token) (cdddr token)))
      (t ())))


  (de n0-attrete-xor-create (l attributename attributevalue)
      (prog (newn)
            (setq newn (gensym))
            (setf (get newn 'type) 'n0-attrete-xor)
            (setf (get newn 'S) l)
            (setf (get newn 'attribute-name) attributename)
            (setf (get newn 'attribute-value) attributevalue)
            (return newn)))


 (de n0-attrete-xor-rete-transfert (token node)
     (Reseau-trace (list "noeud=" node " token=" token "type nt2rete-xor")) 
     (cond
      ((and (equal (cadr token) (get node 'attribute-name))
            (rete-xor (caddr token) (get node 'attribute-value)))
       (list (car token) (cdddr token)))
      (t ())))








 (de n0-=-create (l)
     (prog (newn)
     (setq newn (gensym))
     (setf (get newn 'type) 'n0-=)
     (setf (get newn 'S) l)
     (setf (get newn 'G) ())
     (setf (get newn 'D) ())
     (reseau-trace (list "noeud=" newn "type=" "=" "noeuds suivants=" l))
     (return newn)))

 (de n0-=-rete-transfert-G (token node)
     (cond
      ((eq (car token) '-)
       (setf (get node 'G) (remove (cdr token) (get node 'G))))
      ((eq (car token) '+)
       (reseau-trace (list "noeud G avant=" (get node 'G)))
       (setf (get node 'G) (cons (cdr token) (get node 'G)))
       (reseau-trace (list "noeud G apres=" (get node 'G)))))    
     (rete-matcher-= token (get node 'D)))

        
 (de n0-=-rete-transfert-D (token node)
     (cond
      ((eq (car token) '-)
       (setf (get node 'D) (remove (cdr token) (get node 'D))))
      ((eq (car token) '+)
       (reseau-trace (list "noeud D avant=" (get node 'D)))
       (setf (get node 'D) (cons (cdr token) (get node 'D)))
       (reseau-trace (list "noeud D apres=" (get node 'D)))))
     (rete-matcher-= token (get node 'G)))

        
(de rete-matcher-= (token memory)
    ;ex: token = (+ rouge (c . client1))
    ;    memory= ((rouge (v . voiture1)) (rouge (v . voiture2)) (jaune (v . voiture3)))
    ;    il ressort ((+ (v . voiture1) (c . client1)) (+ (v . voiture2) (c . client1)))
          (cond
           ((equal memory nil)
            nil)
           ((and (equal (cadr token) (caar memory))
                 (rete-match (cddr token) (cdar memory)))
            (cons
             (cons (car token)
                   (rete-match (cdar memory) (cddr token)))
             (rete-matcher-= token (cdr memory))))
           (t (rete-matcher-= token (cdr memory))))
     )
     
 (de rete-match (lis1 lis2)
     ;ex: lis1 = ((c . client1))
     ;    lis2 = ((v . voiture1) (b . banque2))
     ;il ressort ((c . client1) (v . voiture1) (b . banque2))
     (prog (binding (lis1trav lis1) (lis2trav lis2) assocbindlist)
           (tagbody
            loop
            (cond
             ((eq (print lis1trav) nil)
              (return (append lis1 lis2trav)))
             (t
              (reseau-trace (list "lis1trav" lis1trav))
              (setq binding (rete-pop lis1trav))
              ;(print lis2trav)
              (setq assocbindlist (assoc (car binding) lis2trav))
              (cond
               ((eq assocbindlist nil)
                (go loop))
               ((and (neq assocbindlist nil)
                     (equal assocbindlist binding))
                (setq lis2trav (remove binding lis2trav)))
               (t (return nil)))))
            (go loop))))

             
                     
                  
 
 (de n0-<>-create (l)
     (prog (newn)
     (setq newn (gensym))
     (setf (get newn 'type) 'n0-<>)
     (setf (get newn 'S) l)
     (setf (get newn 'G) ())
     (setf (get newn 'D) ())
     (return newn)))


 (de n0-<>-rete-transfert-G (token node)
     (cond
      ((eq (car token) '-)
       (setf (get node 'G) (remove (cdr token) (get node 'G))))
      ((eq (car token) '+)
       (setf (get node 'G) (cons (cdr token) (get node 'G)))))
     (rete-matcher-<> token (get node 'D)))
     

        
 (de n0-<>-rete-transfert-D (token node)
     (cond
      ((eq (car token) '-)
       (setf (get node 'D) (remove (cdr token) (get node 'D))))
      ((eq (car token) '+)
       (setf (get node 'D) (cons (cdr token) (get node 'D)))))
     (rete-matcher-= token (get node 'D)))

        
(de rete-matcher-<> (token memory)
    ;ex: token = (+ rouge (c . client1))
    ;    memory= ((rouge (v . voiture1)) (rouge (v . voiture2)) (jaune (v . voiture3)))
    ;    il ressort ((+ (v . voiture1) (c . client1)) (+ (v . voiture2) (c . client1)))
    (cond
     ((equal memory nil)
      nil)
     ((nequal (cadr token) (caar memory))
     (cons
      (cons (car token)
            (rete-match (cdar memory) (cddr token)))
      (rete-matcher-<> token (cdr memory))))
     (t (rete-matcher-<> token (cdr memory))))
     )
 



 (de n0->=-create (l )
     (prog (newn)
     (setq newn (gensym))
     (setf (get newn 'type) 'n0->=)
     (setf (get newn 'S) l)
     (setf (get newn 'G) ())
     (setf (get newn 'D) ())
     (return newn)))


 (de n0->=-rete-transfert-G (token node)
     (cond
      ((eq (car token) '-)
       (setf (get node 'G) (remove (cdr token) (get node 'G))))
      ((eq (car token) '+)
       (setf (get node 'G) (cons (cdr token) (get node 'G)))))
     (rete-matcher-= token (get node 'D)))
 
        
 (de n0->=-rete-transfert-D (token node)
     (cond
      ((eq (car token) '-)
       (setf (get node 'D) (remove (cdr token) (get node 'D))))
      ((eq (car token) '+)
       (setf (get node 'D) (cons (cdr token) (get node 'D)))))
     (rete-matcher->= token (get node 'D)))
 
        
(de rete-matcher->= (token memory)
    ;ex: token = (+ rouge (c . client1))
    ;    memory= ((rouge (v . voiture1)) (rouge (v . voiture2)) (jaune (v . voiture3)))
    ;    il ressort ((+ (v . voiture1) (c . client1)) (+ (v . voiture2) (c . client1)))
    (cond
     ((equal memory nil)
      nil)
     ((>= (cadr token) (caar memory))
     (cons
      (cons (car token)
            (rete-match (cdar memory) (cddr token)))
      (rete-matcher->= token (cdr memory))))
     (t (rete-matcher->= token (cdr memory))))
     )
 

 (de n0-<=-create (l )
     (prog (newn)
     (setq newn (gensym))
     (setf (get newn 'type) 'n0-<=)
     (setf (get newn 'S) l)
     (setf (get newn 'G) ())
     (setf (get newn 'D) ())
     (return newn)))


 (de n0-<=-rete-transfert-G (token node)
     (cond
      ((eq (car token) '-)
       (setf (get node 'G) (remove (cdr token) (get node 'G))))
      ((eq (car token) '+)
       (setf (get node 'G) (cons (cdr token) (get node 'G)))))
     (rete-matcher-<= token (get node 'D)))
 
        
 (de n0-<=-rete-transfert-D (token node)
     (cond
      ((eq (car token) '-)
       (setf (get node 'D) (remove (cdr token) (get node 'D))))
      ((eq (car token) '+)
       (setf (get node 'D) (cons (cdr token) (get node 'D)))))
     (rete-matcher-<= token (get node 'D)))
   

        
(de rete-matcher-<= (token memory)
    ;ex: token = (+ rouge (c . client1))
    ;    memory= ((rouge (v . voiture1)) (rouge (v . voiture2)) (jaune (v . voiture3)))
    ;    il ressort ((+ (v . voiture1) (c . client1)) (+ (v . voiture2) (c . client1)))
    (cond
     ((equal memory nil)
      nil)
     ((<= (cadr token) (caar memory))
     (cons
      (cons (car token)
            (rete-match (cdar memory) (cddr token)))
      (rete-matcher-<= token (cdr memory))))
     (t (rete-matcher-<= token (cdr memory))))
     )
 

 (de n0-<-create (l)
     (prog (newn)
           (setq newn (gensym))
           (setf (get newn 'type) 'n0-<)
           (setf (get newn 'S) l)
           (setf (get newn 'G) ())
      (setf (get newn 'D) ())
      (return newn)))


(de n0-<-rete-transfert-G (token node)
    (cond
     ((eq (car token) '-)
      (setf (get node 'G) (remove (cdr token) (get node 'G))))
     ((eq (car token) '+)
      (setf (get node 'G) (cons (cdr token) (get node 'G)))))
    (rete-matcher-< token (get node 'D)))
 
        
(de n0-<-rete-transfert-D (token node)
    (cond
     ((eq (car token) '-)
      (setf (get node 'D) (remove (cdr token) (get node 'D))))
     ((eq (car token) '+)
      (setf (get node 'D) (cons (cdr token) (get node 'D)))))
    (rete-matcher-< token (get node 'D)))
 
 
        
(de rete-matcher-< (token memory)
    ;ex: token = (+ rouge (c . client1))
    ;    memory= ((rouge (v . voiture1)) (rouge (v . voiture2)) (jaune (v . voiture3)))
    ;    il ressort ((+ (v . voiture1) (c . client1)) (+ (v . voiture2) (c . client1)))
    (cond
     ((equal memory nil)
      nil)
     ((< (cadr token) (caar memory))
      (cons
       (cons (car token)
             (rete-match (cdar memory) (cddr token)))
       (rete-matcher-< token (cdr memory))))
     (t (rete-matcher-< token (cdr memory))))
    )
 


(de n0->-create (l)
    (prog (newn)
          (setq newn (gensym))
          (setf (get newn 'type) 'n0->)
          (setf (get newn 'S) l)
          (setf (get newn 'G) ())
          (setf (get newn 'D) ())
          (return newn)))


 (de n0->-rete-transfert-G (token node)
     (cond
      ((eq (car token) '-)
       (setf (get node 'G) (remove (cdr token) (get node 'G))))
      ((eq (car token) '+)
       (setf (get node 'G) (cons (cdr token) (get node 'G)))))
     (rete-matcher-> token (get node 'D)))
  
        
 (de n0->-rete-transfert-D (token node)
     (cond
      ((eq (car token) '-)
       (setf (get node 'D) (remove (cdr token) (get node 'D))))
      ((eq (car token) '+)
       (setf (get node 'D) (cons (cdr token) (get node 'D)))))
     (rete-matcher-> token (get node 'D)))
  
        
(de rete-matcher-> (token memory)
    ;ex: token = (+ rouge (c . client1))
    ;    memory= ((rouge (v . voiture1)) (rouge (v . voiture2)) (jaune (v . voiture3)))
    ;    il ressort ((+ (v . voiture1) (c . client1)) (+ (v . voiture2) (c . client1)))
    (cond
     ((equal memory nil)
      nil)
     ((> (cadr token) (caar memory))
     (cons
      (cons (car token)
            (print (rete-match (cdar memory) (cddr token))))
      (print (rete-matcher-> token (cdr memory)))))
     (t (rete-matcher-> token (cdr memory))))
     )
 

 (de n0-inclusion-create (l )
     (setq newn (gensym))
     (setf (get newn 'type) 'n0-inclusion)
     (setf (get newn 'S) l)
     (setf (get newn 'G) ())
     (setf (get newn 'D) ())
     (print newn)) 

 (de n0-inclusion-rete-transfert-G (token node)
     (cond
      ((eq (car token) '-)
       (setf (get node 'G) (remove (cdr token) (get node 'G))))
      ((eq (car token) '+)
       (setf (get node 'G) (cons (cdr token) (get node 'G)))))
          (rete-matcher-inclusion token (get node 'D)))
   

 (de n0-inclusion-rete-transfert-D (token node)
     (cond
      ((eq (car token) '-)
       (setf (get node 'D) (remove (cdr token) (get node 'D))))
      ((eq (car token) '+)
       (setf (get node 'D) (cons (cdr token) (get node 'D)))))
     (rete-matcher-inclusion token (get node 'D)))
  
        
(de rete-matcher-inclusion (token memory)
    ;ex: token = (+ rouge (c . client1))
    ;    memory= ((rouge (v . voiture1)) (rouge (v . voiture2)) (jaune (v . voiture3)))
    ;    il ressort ((+ (v . voiture1) (c . client1)) (+ (v . voiture2) (c . client1)))
    (cond
     ((equal memory nil)
      nil)
     ((rete-inclusion (cadr token) (caar memory))
     (cons
      (cons (car token)
            (print (rete-match (cdar memory) (cddr token))))
      (print (rete-matcher-inclusion token (cdr memory)))))
     (t (rete-matcher-inclusion token (cdr memory))))
     )
 

 (de n0-member-create (l)
(prog (newn)
     (setq newn (gensym))
     (setf (get newn 'type) 'n0-member)
     (setf (get newn 'S) l)
     (setf (get newn 'G) ())
     (setf (get newn 'D) ())
     (return newn)))


(de n0-member-rete-transfert-G (token node)
    (cond
     ((eq (car token) '-)
      (setf (get node 'G) (remove (cdr token) (get node 'G))))
     ((eq (car token) '+)
      (setf (get node 'G) (cons (cdr token) (get node 'G)))))
    (rete-matcher-member token (get node 'D)))
  

(de n0-member-rete-transfert-D (token node)
    (cond
     ((eq (car token) '-)
      (setf (get node 'D) (remove (cdr token) (get node 'D))))
     ((eq (car token) '+)
      (setf (get node 'D) (cons (cdr token) (get node 'D)))))
    (rete-matcher-member token (get node 'D)))
  
 
        
(de rete-matcher-member (token memory)
    ;ex: token = (+ rouge (c . client1))
    ;    memory= ((rouge (v . voiture1)) (rouge (v . voiture2)) (jaune (v . voiture3)))
    ;    il ressort ((+ (v . voiture1) (c . client1)) (+ (v . voiture2) (c . client1)))
    (cond
     ((equal memory nil)
      nil)
     ((member (cadr token) (caar memory))
     (cons
      (cons (car token)
            (print (rete-match (cdar memory) (cddr token))))
      (print (rete-matcher-member token (cdr memory)))))
     (t (rete-matcher-member token (cdr memory))))
     )







 (de n0-or-create (l)
(prog (newn)
     (setq newn (gensym))
     (setf (get newn 'type) 'n0-or)
     (setf (get newn 'S) l)
     (setf (get newn 'G) ())
     (setf (get newn 'D) ())
     (return newn)))



 (de n0-or-rete-transfert-G (token node)
     (cond
      ((eq (car token) '-)
       (setf (get node 'G) (remove (cdr token) (get node 'G))))
      ((eq (car token) '+)
       (setf (get node 'G) (cons (cdr token) (get node 'G)))))
     (prog ((rete-matching-result
             (rete-matcher-or token (get node 'D))))
           (cond (rete-matching-result
                  (mapcar 'cons
                          (cirlist (car token))
                          rete-matching-result))
       )))
    
      
  
 (de n0-or-rete-transfert-D (token node)
       (reseau-trace (list "noeud=" node " token=" token 
                           "type nt3orD" "G="
                           (get node 'G) "D=" (get node 'D)))
     (cond
      ((eq (car token) '-)
       (setf (get node 'D) (remove (cdr token) (get node 'D))))
      ((eq (car token) '+)
       (setf (get node 'D) (cons (cdr token) (get node 'D)))))
     (prog ((rete-matching-result
             (rete-matcher-or token (get node 'G))))
           (cond (rete-matching-result
                  (mapcar 'cons
                          (cirlist (car token))
                          rete-matching-result))
       )))

      

 (de n0-and-create (l)
(prog (newn)
     (setq newn (gensym))
     (setf (get newn 'type) 'n0-and)
     (setf (get newn 'S) l)
     (setf (get newn 'G) ())
     (setf (get newn 'D) ())
     (reseau-trace (list "noeud=" newn "type=" "and" "noeuds suivants=" l))
     (return newn)))



                        
                         

 (de n0-and-rete-transfert-G (token node)
       (reseau-trace (list "noeud=" node " token=" token 
                           "type nt3andG" "G="
                           (get node 'G) "D=" (get node 'D)))
     (cond
      ((eq (car token) '-)
       (setf (get node 'G) (remove (cdr token) (get node 'G))))
      ((eq (car token) '+)
       (setf (get node 'G) (cons (cdr token) (get node 'G)))))
     (rete-matcher-and token (get node 'D)))

  
 (de n0-and-rete-transfert-D (token node)
       (reseau-trace (list "noeud=" node " token=" token 
                           "type nt3andD" "G="
                           (get node 'G) "D=" (get node 'D)))
     (cond
      ((eq (car token) '-)
       (setf (get node 'D) (remove (cdr token) (get node 'D))))
      ((eq (car token) '+)
       (setf (get node 'D) (cons (cdr token) (get node 'D)))))
     (rete-matcher-and token (get node 'G)))

        
(de rete-matcher-and (token memory)
    ;ex: token = (+ (c . client1))
    ;    memory= (((v . voiture1)) ((v . voiture2)) ((v . voiture3)))
    ;    il ressort ((+ (v . voiture1) (c . client1)) (+ (v . voiture2) (c . client1)))
    (cond
     ((equal memory nil)
      nil)
     (t (cons (cons (car token)
                    (rete-match (car memory) (cdr token)))
              (rete-matcher-and token (cdr memory))))
     ))
     
(de rule-node-create (rule forchainobject)
    (prog(newn)
         (setq newn (gensym))
         (setf (get newn 'type) 'rule-node)
         (setf (get newn 'rule) rule)
         (setf (get newn 'rete-forward-chainer) forchainobject)
         (return newn)))

(de rule-node-rete-transfert (token node)
    ;le role de cette fonction est d incorporer en plus ou en moins le changement intervenu dans le conflict-set
    (prog (rule old-conflict-set old-rule-conflict-set)
(print " on est dans rule-node-rete-transfert  : token = " token)
          (setq rule (get node 'rule))
          (setq old-conflict-set (get-slot-value (get node 'rete-forward-chainer) 'conflict-set))
          (when (null old-conflict-set)
                (setf (get-slot-value (get node 'rete-forward-chainer) 'conflict-set)
                      (cons (list rule) old-conflict-set)))
          (setq old-rule-conflict-set (cdr (assoc rule old-conflict-set)))
          (setq new-rule-conflict-set  (make-rete-conflict-set-for-a-rule forchainobject rule token old-rule-conflict-set))
          (setf (cdr (assoc rule (get-slot-value (get node 'rete-forward-chainer) 'conflict-set)))
                (print (cdr new-rule-conflict-set)))
          
          (return nil)))











(de make-rete-conflict-set-for-a-rule (forchainobject rule token old-rule-conflict-set)
    (prog ( bindings binding bindings1 tagsup taginf new-conflict-set tag-list)
          (setq tag-list nil)
          (setq tagsup 0)
          (setq taginf 99999)
          (setq bindings (cdr token))
          
          (setq bindings1 (copy bindings))
       
          loop
          (when (null bindings) (go loop1))
          (setq binding (car bindings))
          (when (null (cdr binding))
                (setq bindings (cdr bindings))
                (go loop))
          (cond((null tag-list) (setq tag-list  (get-slot-value (cdr binding) 'date-of-creation)))
               ((numberp tag-list) (setq y  (get-slot-value (cdr binding) 'date-of-creation))
                (setq tag-list (cond ((> tag-list y) (list tag-list y))
                                     (t (list y tag-list)))))
               (t (setq tag-list (make-classification  (get-slot-value (cdr binding) 'date-of-creation) tag-list))))
          (setq bindings (cdr bindings))
          (go loop)
          loop1
          (cond ((eq (car token) '+)(setq new-conflict-set  (list 'ready
                                        (cons (length bindings1)
                                              (cond((numberp tag-list) (list tag-list))
                                                   (t tag-list)))
                                        bindings1))
                (return (append  (list rule new-conflict-set)
                                 (cdr old-rule-conflict-set))))
                (t (setq new-conflict-set  (list 'ready
                                                 (cons (length bindings1)
                                                       (cond((numberp tag-list) (list tag-list))
                                                            (t tag-list)))
                                                 bindings1))
                   (cond ((member new-conflict-set old-rule-conflict-set)
                          (return (remove new-conflict-set (copy old-rule-conflict-set))))
                         (t (return (remove (rplaca new-conflict-set 'fired) (copy old-rule-conflict-set)))))))))

 (de n0-and-not-create (l)
     ;l'entree G est consideree comme entree positive
(prog (newn)
     (setq newn (gensym))
     (setf (get newn 'type) 'n0-and-not)
     (setf (get newn 'S) l)
     (setf (get newn 'G) ())
     (setf (get newn 'D) ())
     (reseau-trace (list "noeud=" newn "type=" "andnot" "noeuds suivants=" l))
     (return newn)))

 (de n0-and-not-rete-transfert-G (token node)
     ;l'entree G est consideree comme entree positive
       (reseau-trace (list "noeud=" node " token=" token 
                           "type nt3andnotG" "G="
                           (get node 'G) "D=" (get node 'D)))
       (prog (ass (wwg (assoc (cdr token) (get node 'G))))
             (cond
              ((eq (car token) '-)
               (setf (get node 'G) (remove wwg
                                           (get node 'G)))
               (cond ((eq (cdr wwg) 0)
                      token)))
              ((eq (car token) '+)
               (cond ((eq wwg nil)
                      (setq ass (length (rete-match-list (cdr token)
                                                    (get node 'D))))
                      (reseau-trace (list "ass=" ass "wwg=" wwg))
;                     (setf (cdr (assoc (cdr token) (get node 'G)))
;                           ass)
                      (setf (get node 'G)
                            (cons (cons (cdr token)
                                        ass)
                                  (get node 'G)))
                      (reseau-trace (list "noeud=" node " G=" (get node 'G) "D=" (get node 'D)))              
                      (cond ((equal ass 0)
                             token))))))))


                                                                                                              
(de n0-and-not-rete-transfert-D (token node)
    ;l'entree D est consideree comme entree negative
    (reseau-trace (list "noeud=" node " token=" token 
                        "type nt3andnotD" "G="
                        (get node 'G) "D=" (get node 'D)))
    (cond
     ((eq (car token) '-)
      (setf (get node 'D) (remove (cdr token)
                                  (get node 'D)))
      (prog ((oldG (get node 'G)) bind ntokens)
            loop1
            (cond
             ((eq oldG nil) (return ntokens))
             (t (setq bind (car (rete-pop oldG)))
                (cond ((rete-match bind (cdr token))
                       (setf (cdr (assoc bind (get node 'G)))
                             (- (cdr (assoc bind (get node 'G))) 1))))
                (cond ((equal (cdr (assoc bind (get node 'G))) 0)
                       (remove bind (get node 'G))
                       (setq ntokens (cons (cons (car token)
                                                 bind)
                                           ntokens))))))
            (go loop1)))
     ((eq (car token) '+)
      (setf (get node 'D) (cons (cdr token)
                                (get node 'D)))
      (prog ((oldG (get node 'G)) bind ntokens)
            loop2
            (cond
             ((eq oldG nil)
              (reseau-trace (list "noeud=" node " G=" (get node 'G) "D=" (get node 'D)))
              (return ntokens))
             (t (setq bind (car (rete-pop oldG)))
                (cond ((rete-match bind (cdr token))
                       (setf (cdr (assoc bind (get node 'G)))
                             (+ (cdr (assoc bind (get node 'G))) 1))))
                (cond ((equal (cdr (assoc bind (get node 'G))) 1)
                       (setq ntokens (cons (cons '-
                                                 bind)
                                           ntokens))))))
            (go loop2)))))




(de rete-match-list (binding list-binding)
    (reseau-trace (list "binding=" binding "list-binding=" list-binding))
    ;exemple : binding est ((v . voiture1) (c . client1))
    ;          list-binding est (((v . voiture2) (c . client1))
    ;                            ((v . voiture1) (c . client3))
    ;                            ((v . voiture1) (b . banque2))
    ;                            ((v . voiture1) (d . domicile3)))
    ;il ressort (((v . voiture1) (c . client1) (b . banque2))
    ;            ((v . voiture1) (c . client1) (d . domicile3)))
    (prog ((rete-match-result (print (rete-match binding (car list-binding)))))
          (cond ((equal list-binding nil)
                 nil)
                (rete-match-result
                 (cons rete-match-result
                       (rete-match-list binding (cdr list-binding))))
                (t
                 (rete-match-list binding (cdr list-binding))))))


 (de n0-rete-xor-create (l)
     (prog (newn)
     (setq newn (gensym))
     (setf (get newn 'type) 'n0-rete-xor)
     (setf (get newn 'S) l)
     (setf (get newn 'G) ())
     (setf (get newn 'D) ())
     (return newn)))




 (de n0-rete-xor-rete-transfert-G (token node)
       (reseau-trace (list "noeud=" node " token=" token 
                           "type nt3rete-xorG" "G="
                           (get node 'G) "D=" (get node 'D)))
     (cond
      ((eq (car token) '-)
       (setf (get node 'G) (remove (cdr token) (get node 'G))))
      ((eq (car token) '+)
       (setf (get node 'G) (cons (cdr token) (get node 'G)))))
     (prog ((rete-matching-result
             (rete-matcher-rete-xor token (get node 'D))))
           (cond (rete-matching-result
                  (mapcar 'cons
                          (cirlist (car token))
                          rete-matching-result))
       )))

      
      
  
 (de n0-rete-xor-rete-transfert-D (token node)
       (reseau-trace (list "noeud=" node " token=" token 
                           "type nt3rete-xorD" "G="
                           (get node 'G) "D=" (get node 'D)))
     (cond
      ((eq (car token) '-)
       (setf (get node 'D) (remove (cdr token) (get node 'D))))
      ((eq (car token) '+)
       (setf (get node 'D) (cons (cdr token) (get node 'D)))))
     (prog ((rete-matching-result
             (rete-matcher-rete-xor token (get node 'G))))
           (cond (rete-matching-result
                  (mapcar 'cons
                          (cirlist (car token))
                          rete-matching-result))
       )))

    
  
 (de rete-xor (a b)
     (and (or a b) (not (and a b))))

 (de rete-inclusion (l1 l2)
     (print l1)
     (cond
      ((eq l1 ()) t)
      ((and (equal (length l1) 0) (member l1 l2)) t)
      ((and (equal (length l1) 0) (not (member l1 l2))) ())
      ((not (member (car l1) l2)) ())
      (t (rete-inclusion (cdr l1) l2))))
 



                                        ;TESTS ET FONCTION DIVERSE
 
                 


; (de test-c ()
;     (prog (t1 t2 t3 t4 t5 t6 t7)
;          (setq t3 (n0-<>-create ()))
;          (setq t4 (n0-att-create (list (cons t3 'G)) 'couleur))
;          (setq t6 (n0-att-create (list (cons t3 'D)) 'couleur))
;          (setq t2 (n0-obj-create (list (cons t4 nil)) 'car-1))
;          (setq t1 (n0-obj-create (list (cons t6 nil)) 'car-2))
;          (setq *top-node-list* (list t1 t2))))
;                                             
; (de test1-c ()
;     (prog (t1 t2)
;          (setq t2 (n0-att=-create () 'couleur 'rouge))
;          (setq t1 (n0-obj-create (list (cons t2 nil)) 'car-1))
;          (setq *top-node-list* (list t1))))

;
 (de reseau-trace (list)
    ; (print list)
     list)
;
;
;
;(de tt4 ()
;    (prog (t1 t2 t3 t4 t5 t6 t7)
;         (setq t7 (n0-and-not-create ()))
;         (setq t5 (n0-=-create (list (cons t7 'D))))
;         (setq t4 (n0-att-create (list (cons t5 'G)) 'couleur))
;         (setq t6 (n0-att=-create (list (cons t7 'G)) 'agressivite 'forte))
;         (setq t3 (n0-att-create (list (cons t5 'D)) 'prefered))
;         (setq t2 (n0-metaclass-create (list (cons t4 nil)) 'voiture 'V))
;         (setq t1 (n0-metaclass-create (list (cons t3 nil) (cons t6 'nil)) 'client 'C))
;         (setq *top-node-list* (list t1 t2))
;         (rete-interprete '(+ client-1 agressivite forte))       
;         (setq *top-node-list* (list t1 t2))
;         (rete-interprete '(+ voiture-1 couleur rouge))
          ;(setq *top-node-list* (list t1 t2))
          ;(rete-interprete '(+ voiture-2 couleur vert))
          ;(setq *top-node-list* (list t1 t2))
          ;(rete-interprete '(- voiture-2 couleur vert))
          ;(setq *top-node-list* (list t1 t2))
          ;(rete-interprete '(+ voiture-2 couleur vert))
          ;(setq *top-node-list* (list t1 t2))
          ;(rete-interprete '(+ client-1 prefered rouge))
          ;(setq *top-node-list* (list t1 t2))
          ;(rete-interprete '(+ client-1 agressivite forte))
          ;(setq *top-node-list* (list t1 t2))
          ;(rete-interprete '(- client-1 agressivite forte))      
          ;(setq *top-node-list* (list t1 t2))
          ;(rete-interprete '(- client-1 agressivite forte))
; ))
;
;(de tt5 ()
;    (rete-match '((c . client1) (b . banque3) (t . toto3)) '((c . client1) (b . banque3) (v . voiture1))))
;
;(de tt6 ()
;    (rete-matcher-= '(+ rouge (c . client1)) '((vert (v . voiture1)) (jaune (v . voiture2)) (bleu (v . voiture3)))))
;
;(de tt7 ()
;    (rete-match-list '((v . voiture1) (c . client1)) '(((v . voiture1) (c . client2)) ((v . voiture1)) ((c . client1)))))



(de pn (node)
    (print node )
    (print " type =" (get node 'type))
    (print " metaclass =" (get node 'metaclass))
    (print " object-name =" (get node 'object-name))
    (print " attribute-name =" (get node 'attribute-name))
    (print " attribute-value =" (get node 'attribute-value))
    (print " s =" (get node 's))
    ()
    )

(de ppp1 ()
    ($ 'metaclass 'instanciate 'fifi ())
    (add-slot-user 'fifi 'att1 'instance)
    (add-slot-user 'fifi 'att2 'instance)
    ($ 'fifi 'instanciate 'a  nil)
    (setq a1 ($ 'fifi 'instanciate nil nil))

    ($ rete-forward-chainer 'instanciate 'ff1 nil)
    (add-rete-forward-rule 
     'ff1
     '(existing (b 'fifi) 
               (and (c= a att1 10)
                    (= (attribute-descriptor att2 a)
                            (attribute-descriptor att2 b))))
     '(print 'youppee))
 
    ($ a 'put-value 'att1 10)  
    ($ a 'put-value 'att2 20)
    ($ a1 'put-value 'att1 10)
    ($ a1 'put-value 'att2 20)
   
    ($ 'ff1 'go)
  
    ()
)

 (de pp  ()
(ppp1 ))