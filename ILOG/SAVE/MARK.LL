(defabbrev mark {application}:mark)

(defstruct {mark})

(setq #:sys-package:colon '{mark})

(de mark (image)
    (omakeq {mark} x 0 
                   y 0
                   w (send 'width image)
                   h (send 'height image)
                   image image))

(de :down-event (appli event))

(de :up-event (appli event)
    (send 'activated-event appli ()))    

