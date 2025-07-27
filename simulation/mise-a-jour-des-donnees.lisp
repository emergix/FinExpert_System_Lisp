(de modif ()
    (prog ((file-list (directory-list "/usr/jupiter/olivier/expert/donnees"))
           file-list-filtree)
          (setq file-list-filtree file-list)
          (when (null file-list-filtree) (go end))
          (setq savechan (outchan))
          loop
          (when (null file-list-filtree) (return))
          (setq file (car file-list-filtree))
          (setq name (catenate "/usr/jupiter/olivier/expert/donnees/" (string file)))
          (setq chan (opena name))
          (outchan chan)
          (print "
(code-rga )")
          (outchan savechan)
          (close)
          (setq file-list-filtree (cdr file-list-filtree))
          (go loop)
          end
          ))
           