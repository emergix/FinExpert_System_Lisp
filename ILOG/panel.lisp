(de message-panel ()
    (mixed-applicationq image "Welcome                                "))

(de kb-panel ()
    (let* ((base-selector (stringselector ()))
           (type-selector (stringselector ()))
           (object-selector (stringselector ()))
           (base-scroller
            (sized-verticalscroller base-selector :scroller-widthcn))
           (type-scroller
            (sized-verticalscroller type-selector (add :scroller-widthcn 3)))
           (object-scroller
            (sized-verticalscroller object-selector :scroller-widthcn))
           (lines (template-lines))
           (texts (template-texts))
           (buttons (button-panel))
           (message (message-panel))
           (b (rectangle 0 0 #wc #hc)))
      (set-action base-selector ':select-base)
      (set-action type-selector ':select-type)
      (set-action object-selector ':select-object)
      (let ((appli (mixed-applicationq
                    image
                    (:fond-gris
                     (margin-view
                      (column
                       (row
                        (:fond-blanc
                         (:banded-image "Bases de connaissance"
                                        (:bar-scroller base-scroller)))
                        b
                        (:fond-blanc
                         (:banded-image "Types d'entrees"
                                        (:bar-scroller type-scroller)))
                        b
                        (:fond-blanc
                         (:banded-image
                          "Entrees" (:bar-scroller object-scroller))))
                       b
                       (row (column (:fond-blanc message) b lines) b buttons)
                       b
                       texts)
                      10))
                    message message
                    name 'appli
                    template lines
                    base-selector base-selector
                    base-scroller base-scroller
                    type-selector type-selector
                    type-scroller type-scroller
                    object-selector object-selector
                    object-scroller object-scroller
                    modify '(())
                    base-name '(()))))
        (move-components lines appli)
        (move-components texts appli)
        (move-components buttons appli)
        (add-component appli 'editors
                       (append (component 'lineedits appli)
                               (component 'longedits appli)
                               (component 'controls appli)
                               (component 'shorts appli)
                               (component 'texts appli)))
        (add-component appli 'titles
                       (append (component 'lineedittitles appli)
                               (component 'longedittitles appli)
                               (component 'controltitles appli)
                               (component 'shorttitles appli)
                               (component 'texttitles appli)))
        appli)))

(de kb-edit ()
    (let ((panel (kb-panel)))
      (add-application panel)
      (process-pending-events)
      (:fill-selector (component 'base-selector panel)
                      (kb-bases))))

; manipulation des de'fileurs

(de :reinitialise-when-scrolled (appli)
    (let ((scroller (scrolledp appli)))
      (when scroller
            (send 'reinitialise scroller))))

; le flag modify

(de :base-modify (appli . flag)
    (ifn flag
         (car (component 'modify appli))
         (set-component appli 'modify flag)))

(de :base-name (appli . flag)
    (ifn flag
         (car (component 'base-name appli))
         (set-component appli 'base-name flag)))

; manipulation des selectionneurs

(de :empty-selector (ss)
    (send 'set-strings ss ())
    (:reinitialise-when-scrolled ss))

(de :fill-selector (ss strings)
    (let ((selection (send 'get-selected-string ss)))
      (send 'set-strings ss strings)
      (:reinitialise-when-scrolled ss)
      (when (null selection)
            ;(send 'activated-event ss ()) ; ce qu il y avait avant
              (send 'set-selected-rank ss 0) ; ce que j ai mis
            )))
    
(de :symbol-selection (ss)
    (let ((selection (send 'get-selected-string ss)))
      (when selection (concat selection))))

(de :update-object-selector (os)
    (:fill-selector os
                    (kb-object-ids (:current-base os)
                                   (:current-type-name os))))

; selections courantes

(de :current-base (c)
    (kb-by-name (:symbol-selection (component 'base-selector c))))

(de :current-base-name (c)
    (:symbol-selection (component 'base-selector c)))

(de :current-type-name (c)
    (:symbol-selection (component 'type-selector c)))

(de :current-object (c)
    (let ((rank (send 'get-selected-rank (component 'object-selector c))))
      (when rank
            (kb-object (:current-base c)
                       (:current-type-name c)
                       rank))))

; actions des selectionneurs

(de :select-base (base-selector)
    (let ((base-name (:symbol-selection base-selector))
          (type-selector (component 'type-selector base-selector)))
      (:protect-base-save
       base-selector
       (:base-modify base-selector ())                   
       (if (null base-name)
           (progn
             (:empty-selector type-selector)
             (:base-name base-selector ()))
         (let ((base (kb-by-name base-name)))
           (unless base
		   (:run base-selector)
                   (:message base-selector "Loading base ~A" base-name)
                   (setq base (load-named-kb base-name))
		   (:stop base-selector)
                   (:message base-selector "Loaded"))
           (:base-name base-selector base-name)
           (:fill-selector type-selector (kb-type-names base))
           (send 'set-selected-rank
                 (component 'type-selector base-selector)
                 0))))))

(de :select-type (type-selector)
    (let ((type-name (:current-type-name type-selector))
          (object-selector (component 'object-selector type-selector))
          (template (component 'template type-selector)))
      (cond ((null type-name)
             (inhibit-application (component 'doit type-selector))
             (:protect-template-doit template
              (:empty-selector object-selector)
              (:disable-template template)))
            (t
             (autorise-application (component 'doit type-selector))
             (:protect-template-doit template
              (:disable-template template)
              (:enable-template template type-name)
              (:update-object-selector object-selector)
              (send 'set-selected-rank
                    (component 'object-selector type-selector)
                    0))))))

(de :select-object (object-selector)
    (let ((object (:current-object object-selector))
          (type-name (:current-type-name object-selector))
          (template (component 'template object-selector)))
      (if (null object)
          (progn
            (:template-object template ())
            (when (null (send 'get-strings object-selector))
                  (:default-fill-template template type-name)))
        (:protect-template-doit template
         (:fill-template template type-name object)))))

(de :doit (b)
    (let* ((template (component 'template b))
           (current-object (:template-object template))
           (new-object (:extract-object template (:current-type-name b))))
      (:unmodify template)
      (:base-modify b t)
      (if current-object
          (kb-replace-object (:current-base b)
                             current-object
                             new-object)
        (kb-add-object (:current-base b) new-object)
        (:update-object-selector (component 'object-selector b)))))

(de :delete (b)
    (let ((object (:current-object b)))
      (when object
            (kb-remove-object (:current-base b) object)
            (:base-modify b t)
            (:update-object-selector (component 'object-selector b)))))

(de :new (b)
    (send 'set-selected-string (component 'object-selector b) ()))

(de :add-type (ts type)
    (let ((strings (send 'get-strings ts)))
      (unless (member type strings)
              (send 'set-strings ts (nconc1 strings type))
              (send 'reinitialise (scrolledp ts)))))
               
(de :add (b)
    (let ((type (ask-string "Add object of type" (type-name-list) t))
          (type-selector (component 'type-selector b)))
      (when type
            (:add-type type-selector type)
            (send 'set-selected-string type-selector type))))

(de :add-kb (b)
    (let ((string (ask-string "Add kb named" () t)))
      (when string
            (tag not-removed
                 (when (probefile string)
                       (:ask-overwrite-file string))
                 (kb-create string)
                 (:insert-new-kb b string)))))

(de :ask-overwrite-file (string)
    (confirm (catenate "Do you want to overwrite file " string "?")))

(de :insert-new-kb (b name)
    (let ((base-selector (component 'base-selector b)))
      (send 'set-strings base-selector
            (cons name (send 'get-strings base-selector)))
      (send 'set-selected-string base-selector name)))

(de :save (b)
    (let ((base-name (string (:base-name b))))
      (when base-name
            (:protect-template-doit (component 'template b) base-name)
            (:run b)
            (:message b "Saving base ~A" base-name)
            (when (probefile base-name)
                  (unless
                   (catcherror ()
                               (renamefile base-name (catenate base-name "~")))
                   (:message b
                             "Could not write backup base-name ~A" base-name)))
            (save-named-kb (concat base-name))
            (:stop b)
            (:message b "Saved")
            (:base-modify b ()))))

(dmd :protect-template-doit (template . body)
    `(progn
       (when (:modifyp ,template)
             (if (confirm-yes-no
                  (column "L'objet a ete modifie"
                          "voulez-vous le sauver dans la base?"))
                 (:doit ,template)))
       ,@body))
                       
(dmd :protect-base-save (c . body)
     `(progn (when (:base-modify ,c)
                   (if (confirm-yes-no
                        (column "La base est modifiee"
                                "voulez vous la sauvegarder sur fichier?"))
                       (:save ,c)))
             ,@body))

(de confirm-yes-no (i)
    (let (({asker}:ok " Yes ")
          ({asker}:cancel " No  "))
      (confirm i)))

      


; messages

(de :message (b format . rest)
    (send 'set-image (component 'message b)
          (apply 'format () format rest))
    (bitmap-flush))

; run/stop

(de :run (b)
    (send 'set-image (component 'run b)
          (Icon 0 0 run-icon)))

(de :stop (b)
    (send 'set-image (component 'run b)
          (Icon 0 0 stop-icon)))
