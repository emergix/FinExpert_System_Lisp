(defabbrev roller {application}:roller)

(defstruct {roller} images modified-flag)

(setq #:sys-package:colon '{roller})

(de Roller (x y w h images)
    (let ((roller (omakeq {roller}
                       x x y y w w h h image (view))))
      (:set-images roller images)
      roller))

(de :down-event (roller event)
    (:next-image roller))

(de :set-images (roller images)
    (unless images
            (setq images (list (rectangle 0 0 0 0))))
    (:images roller images)
    (send 'set-image roller (car images)))

(de :get-images (roller)
    (:images roller))

(de :next-image (roller)
    (let ((nextlist
           (or
            (cdr (memq ({application}:image roller) (:images roller)))
            (:images roller))))
      (send 'set-image roller (car nextlist))
      (:modified-flag roller t)))

(de :get-current (roller)
    ({application}:image roller))

(de :select-image (roller i)
    (send 'set-image roller i))
