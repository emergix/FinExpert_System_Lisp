(setq *restart-flag* t)

(de use-panel ()
    (let*  ((fonction-selector (stringselector ()))
            (message-selector (stringselector ()))
            (enregistrement-selector (stringselector ()))
            (fonction-scroller
             (sized-verticalscroller fonction-selector :scroller-widthcn))
            (message-scroller
             (sized-verticalscroller message-selector (add :scroller-widthcn 3)))
            (enregistrement-scroller
             (sized-verticalscroller enregistrement-selector :scroller-widthcn))
            (send-boutton (standardbutton "    send    "))
            (exit-boutton (standardbutton "    exit    "))
            (stop-boutton (standardbutton "    stop    "))
            (cont-boutton (standardbutton "  continue  "))
            (re-init      (standardbutton "reinitialise"))
            (boutton-send ())
            (boutton-exit ())
            (b (rectangle 0 0 #wc #hc))
            (b1 (rectangle 0 0 #20wc #hc)))
      (set-action fonction-selector ':select-fonction)
      (set-action message-selector ':select-message)
      (set-action enregistrement-selector ':select-enregistrement)
      (set-action exit-boutton 
                  '(lambda (fin)
                     (remove-application (component 'appli fin))
                     (end)))
      (set-action send-boutton '(lambda (sen)
                                 (:execute-commande (symbol () (send 'get-selected-string 
                                                                 (component 'fonction-selector sen)))
                                                     (symbol () (send 'get-selected-string 
                                                                  (component 'message-selector sen)))
                                                     (symbol () (send 'get-selected-string 
                                                                  (component 'enregistrement-selector sen))))))
      (set-action stop-boutton '(lambda (sen) (setq *restart-flag* nil)
                                  (with ((prompt "EXPERT-CHART>"))
                                        (until *restart-flag*
                                               (itsoft 'toplevel nil)))))
      (set-action cont-boutton '(lambda (sen)
                                  (setq *restart-flag* t)
                                  (exit #:system:toplevel-tag)))

      (set-action re-init '(lambda (sen) (initialise-base-de-faits)))
      (let ((appli (mixed-applicationq
                    image
                    (column "titre 1"
                    (:fond-gris
                     (margin-view 
                      (column
                       (row
                        (:fond-blanc
                         (:banded-image "fonctionalites accessibles"
                                        (:bar-scroller fonction-scroller)))
                        b
                        (:fond-blanc
                         (:banded-image "messages"
                                        (:bar-scroller message-scroller)))
                        b
                        (:fond-blanc
                         (:banded-image
                          "enregistrement" (:bar-scroller enregistrement-scroller))))
                       b
                       (column (row b1 send-boutton b1 stop-boutton b1 re-init)
                               ""
                               (row b1 exit-boutton b1 cont-boutton))
                       )
                      10)))
                    name 'appli
                    fonction-selector fonction-selector
                    fonction-scroller fonction-scroller
                    message-selector message-selector
                    message-scroller message-scroller
                    enregistrement-selector enregistrement-selector
                    enregistrement2-scroller enregistrement-scroller)))
        appli)))
                  
           

(de kb-use ()
 (let ((panel (use-panel)))
      (add-application panel)
      (process-pending-events)
      (current-tty *tty-aida-prevu-pour-expert-chart*)
      (when ({application}:window *tty-aida-prevu-pour-expert-chart*)
            (current-keyboard-focus-window 
	     ({application}:window *tty-aida-prevu-pour-expert-chart*)))
      (:fill-selector (component 'fonction-selector panel)
                      (fonctions-disponibles))
      ))

;fonction-disponibles doit retourner la liste des fonctions disponibles :

(de fonctions-disponibles ()
    (mapcar '(lambda (x) (string x)) 
            (get-slot-value fonction 'instances)))




(de :select-fonction (fonction-selector)
    (let ((fonction-name (:symbol-selection fonction-selector))
          (message-selector (component 'message-selector fonction-selector)))
;      (:empty-selector message-selector)
      (:fill-selector message-selector (message-disponibles fonction-name))
      (send 'set-selected-rank
            (component 'message-selector fonction-selector)
            0)))



(de message-disponibles (fonction-name)
          (mapcan '(lambda (x) (cond ((memq (car x)  '(enregistrements-disponibles fin-de-fichier-d-enregistrement)) nil)
                                     (t (list (string (car x))))))
                  (get-slot-value fonction-name 'method-list)))



(de :select-message (message-selector)
    (let ((message-name (:symbol-selection message-selector))
          (fonction-selector (component 'fonction-selector message-selector))
          fonction-name
          (enregistrement-selector (component 'enregistrement-selector message-selector)))
      (setq fonction-name (:symbol-selection fonction-selector))
;      (:empty-selector enregistrement-selector)
      (:fill-selector enregistrement-selector (enregistrement-disponibles fonction-name message-name))
      (send 'set-selected-rank
            (component 'enregistrement-selector message-selector)
            0)))

(de :select-enregistrement (enregistrement-selector)
    (let ((enregistrement-name (:symbol-selection enregistrement-selector)))))
    

(de enregistrement-disponibles (fonction-name message-name)
          ($ fonction-name 'enregistrements-disponibles message-name))
         

(de :execute-commande (fonction message enregistrement)
    ($ fonction message (list enregistrement))
      )
