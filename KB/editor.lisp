;fichier contenant un editeur de structure lisp quelconque
;pour editer par exemple les premisse compile des regles a des fin de debugging grace aux fonctions
;forward-try-prmisse et backward-try-premisse
;de meme qu un editeur d object visualisateur de hierachies recursif

(dmd tedit (form) `(prog (val savechan chan tedit newval) 
                         (setq val ,form)
                         (setq chan (openo "/tmp/lisp-editor-buffer.lisp"))
                         (setq savechan (outchan))
                         (outchan chan)
                         (pprin val)
                         (outchan savechan)
                         (close chan)
                         (setq tedit (edit-filepanel  "/tmp/lisp-editor-buffer.lisp"))
                         (prompt-application tedit)
                         (setq chan (openi "/tmp/lisp-editor-buffer.lisp"))
                         (setq savechan (inchan))
                         (inchan chan)
                         (setq newval (read))
                         (close chan)
                         (inchan savechan)
                         (setf ,form newval)
                         (return nil)))
                         