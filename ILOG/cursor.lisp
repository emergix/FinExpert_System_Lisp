(defabbrev cursor {application}:cursor)

(defstruct {cursor})

(setq #:sys-package:colon '{cursor})

(de cursor (x y w h)
    (application '{cursor} x y w h
                 (row (mode #:mode:xor (box 0 0 3 h)) "")))

(de :get-position (cursor)
    (send 'x ({application}:image cursor)))

(de :set-position (cursor x)
    (when (and (>= x 0) (< x ({rectangle}:w cursor)))
          (send 'translate ({application}:image cursor) x 0)
          (send 'activated-event cursor ())))

(de :slide-to (cursor x)
    (with ((current-window ({application}:window cursor)))
          (let ((image ({application}:image cursor)))
            (send 'display image 0 0 ())
            (:set-position cursor x)
            (send 'display image 0 0 ()))))

(de :down-event (cursor event)
    (let ((father ({application}:father cursor)))
      (when (and father (typep father '{curveeditor}))
            (send 'eventx father (#:event:x event))
            (send 'eventy father (#:event:y event))
            (send 'activated-event father ()))))


