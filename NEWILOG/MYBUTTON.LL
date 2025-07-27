(setq #:sys-package:colon '{mybutton})

(de mybutton (titre image get-function)
    (let ((mb
           (application '{mybutton} 0 0 0 0 image))
          )
      (send 'fit-to-contents mb)
      (:get-function mb get-function)
      (:titre mb titre)
      mb))

(de :down-event (appli event)
    (:compute-menu appli)
    (let ((res
           (activate-menu ({application}:menu appli)
                          ({Event}:gx event) ({Event}:gy event))))
      (ungrab-event)
      (when res (funcall ({application}:action appli) appli  res))
      ))

(de :compute-menu (appli)
    (let* ((liste (funcall (:get-function appli) appli))
           (menu (create-menu (:titre appli)))
           )
      (mapc (lambda (symbol)
              (menu-insert-item 
               menu 0 0 (string symbol) t 
               symbol))
            liste)
      ({application}:menu appli menu)))
            

