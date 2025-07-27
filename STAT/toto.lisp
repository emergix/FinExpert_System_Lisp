    
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
    (prog ((p3 (copy p2)))
          (append (mapcan '(lambda (x)
                             (let (valem)
                               (setq valem (assoc (car x) p1))
                               (cond(valem
                                     (list (list (car x) (+ (cadr valem) (cadr x)))))
                                    (t (list (list  (car x) (cadr x)))))
                               ))
                          p3)
                  (mapcan '(lambda (x) 
                             (let (valem)
                               (setq valem (assoc  (car x) p2))
                               (cond(valem nil)
                                    (t (list x)))))
                          (copy p1)))
          ))



          