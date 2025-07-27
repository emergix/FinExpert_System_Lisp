#|
.Section "Le type case"
|#

(defabbrev repeater {application}:repeater)

(defstruct {repeater})

(setq #:sys-package:colon '{repeater})

(de repeater (image)
    (omakeq {repeater} x 0 
                   y 0
                   w (send 'width image)
                   h (send 'height image)
                   image image))

(de :down-event (appli event)
    (with ((current-window ({Application}:window appli)))
	  (send 'invert-display ({Application}:image appli) 0 0 ()))
    (#:event:detail event (cond ((eq 0 (#:event:detail event)) 1024)
                                ((eq 2 (#:event:detail event)) 256)
                                (t 512)))
    (:activated-event appli event)
    (while (progn (read-mouse event)
                  (neq 0 ({Event}:detail event)))
      (:activated-event appli event)))

(de :up-event (appli event)
    (with ((current-window ({Application}:window appli)))
	  (send 'invert-display ({Application}:image appli) 0 0 ())))
    

(de :activated-event (appli event)
    (let ((action ({application}:action appli)))
      (when action (funcall action appli event))))
    
