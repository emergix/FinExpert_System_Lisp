
    
(de expand-object (object-1 object2 argument-list)

    (prog (met auto transparent-slots)
          (setq auto (get-slot-value object-1 'expansion-slot))
          (when (member (list (get-slot-value object-1 'metaclass) object2) auto)
                (return nil))
          (setq met (cdr (assoc (list (get-slot-value object-1 'metaclass) object2)
                                *expand-method-bi-object-list*)))
          (cond (met (setf (get-slot-value  object-1 'expansion-slot) 
                           (cons (list (get-slot-value object-1 'metaclass) object2)
                                 (get-slot-value  object-1 'expansion-slot)))
                     (return  (apply met object-1 argument-list)))
                ((setq transparent-slots (get-slot-value object-1 'transparent-slot-list))
                 (when (null transparent-slots) (return nil))
                 (return (any '(lambda (x) 
                                 (expand-object  (get-slot-value object-1 x)  object2 argument-list))
                              transparent-slots))))))


