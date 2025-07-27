(defabbrev curveeditor {application}:curveeditor)

(defstruct {curveeditor} eventx eventy list)

(setq #:sys-package:colon '{curveeditor})

(defvar :rectangle #:image:rectangle:#[0 0 0 0])

(de :set-the-mark (appli)
    (let ((image (application '{Mark}
                               (sub (:eventx appli) (div #wc 2))
                               (sub (:eventy appli) (div #hc 2))
                               #wc #hc (mode #:mode:xor "*"))))
      (when (and appli (typep appli '{curveeditor}))
	    (let ((found (:found image (:list appli))))
	      (if found 
		  (:remove-the-mark appli found)
		(:list appli (cons image (:list appli)))
		(send 'add-image appli image)
		(send 'bounding-box image :rectangle)
		(send 'redisplay appli :rectangle)
		(with ((current-window ({Application}:window image)))
		      (clear-graph-env))
		(send 'redisplay appli :rectangle)
		(set-action image (lambda (m)
				    (:remove-the-mark ({application}:father m)
						      m))))))))
    
(de :remove-the-mark (appli image)
    (when (and appli (typep appli '{curveeditor}))
          (:list appli (delq image (:list appli)))
          (with ((current-window ({Application}:window image)))
                (clear-graph-env))
          (send 'remove-image appli image)
          (send 'bounding-box image :rectangle)
          (send 'redisplay appli :rectangle)))

(de :found (image list)
    (tag found
	 (while list
	   (when (and (eq (send 'x image) (send 'x (car list)))
		      (eq (send 'y image) (send 'y (car list))))
		 (exit found (car list)))
	   (nextl list))))
			  