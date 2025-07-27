(de template-lines ()
    (let* ((longedit-1 (lineedit 0 0 (mul :long-le-width-cn #wc) ""))
           (longedit-2 (lineedit 0 0 (mul :long-le-width-cn #wc) ""))
           (lineedit-1 (lineedit 0 0 (mul :short-le-width-cn #wc) ""))
           (lineedit-2 (lineedit 0 0 (mul :short-le-width-cn #wc) ""))
           (control-1  (roller 0 0 (mul :short-le-width-cn #wc) #hc '("")))
           (control-2  (roller 0 0 (mul :short-le-width-cn #wc) #hc '("")))
           (title-1 (:title-viewer))
           (title-2 (:title-viewer))
           (title-3 (:title-viewer))
           (title-4 (:title-viewer))
           (title-5 (:title-viewer))
           (title-6 (:title-viewer))
           (b (rectangle 0 0 5 5)))
      (mixed-applicationq
       image
       (view
         (column
         (row (:titled-boxed title-1 (:fond-blanc lineedit-1))
              b
              (:titled-boxed title-2 (:fond-blanc control-1)))
         b
         (:titled-boxed title-3 (:fond-blanc longedit-1))
         b
         (row (:titled-boxed title-4 (:fond-blanc lineedit-2))
              b
              (:titled-boxed title-5 (:fond-blanc control-2)))
         b
         (:titled-boxed title-6 (:fond-blanc longedit-2))
         b))
       object   t
       lineedits (list lineedit-1 lineedit-2)
       longedits (list longedit-1 longedit-2)
       controls (list control-1 control-2)
       lineedittitles  (list title-1 title-4)
       longedittitles  (list title-3 title-6)
       controltitles (list title-2 title-5))))

(de template-texts ()
    (let* ((short-1 (medite 0 0
                            (mul :text-width-cn #wc)
                            (mul :short-text-height-cn #hc)))
           (text-1 (medite 0 0
                           (mul :text-width-cn #wc) (mul :text-height-cn #hc)))
           (text-2 (medite 0 0
                           (mul :text-width-cn #wc) (mul :text-height-cn #hc)))
           (title-1 (:title-viewer))
           (title-2 (:title-viewer))
           (title-3 (:title-viewer)))
      (mixed-applicationq
       image
       (column
        (:titled-boxed title-1
                       (verticalscroller 0 0
                                         (add (send 'width short-1)
                                              {scroller}:scrollbarwidth)
                                         (mul :short-scroller-height-cn #hc)
                                         short-1))
        ""
        (:titled-boxed title-2
                       (:text-scroller text-1))
        ""
        (:titled-boxed title-3
                       (:text-scroller text-2)))
       shorts (list short-1)
       texts (list text-1 text-2)
       shorttitles (list title-1)
       texttitles (list title-2 title-3))))

; pour modifier le template

; positionner et re'cupe'rer l'objet initial

(de :template-object (template . object)
    (ifn object
         (or (consp (component 'object template)) ())
         (set-component template 'object (or (car object) t))))

; vider le template

(de :null-value (appli)
    (send 'set-value appli ()))

(de :disable-template (template)
    (mapc ':null-value
          (component 'titles template))
    (mapc ':null-value
          (component 'editors template))
    (:unmodify template))

; pre'parer le template pour un type

(de :enable-template (template type-name)
    (:disable-template template)
    (:fill-template1 (type-titles type-name)
                     (type-structure type-name)
                     (type-controls type-name)
                     (component 'lineedittitles template)
                     (component 'longedittitles template)
                     (component 'controltitles template)
                     (component 'shorttitles template)
                     (component 'texttitles template))
    (:unmodify template))
                     
; mettre les de'fauts dans le template

(de :default-fill-template (template type-name)
    (:fill-template1
     (type-defaults type-name)
     (type-structure type-name)
     (type-controls type-name)
     (component 'lineedits template)
     (component 'longedits template)
     (component 'controls template)
     (component 'shorts template)
     (component 'texts template))
    (:unmodify template)
    (:template-object template ()))

; positionner un objet dans le template

(de :fill-template (template type-name object)
    (:template-object template object)
    (:fill-template1
     (cdr object)
     (type-structure type-name)
     (type-controls type-name)
     (component 'lineedits template)
     (component 'longedits template)
     (component 'controls template)
     (component 'shorts template)
     (component 'texts template))
    (:unmodify template))


(de :fill-template1 (obj desc cdefs lines longs controls shorts texts)
    (while desc
          (selectq (nextl desc)
                   (symbol
                    (:fill-template2 (nextl lines) (nextl obj)))
                   ((longsymbol nonquotesymbol)
                    (:fill-template2 (nextl longs) (nextl obj)))
                   (control
                    (when (and (car cdefs) (typep (car controls) '{roller}))
                          (send 'set-images (car controls) (car cdefs)))
                    (:fill-template2 (nextl controls) (nextl obj)))
                   (short
                    (:fill-template2 (nextl shorts) (nextl obj)))
                   ((text text-list)
                    (:fill-template2 (nextl texts) (nextl obj))))
          (nextl cdefs)))

(de :fill-template2 (editor value)
    (ifn editor
         (error ':fill-template2 "not enough editors" value)
         (send 'set-value editor value)))

; re'cupe'rer l'objet e'dite'

(de :extract-object (template type-name)
    (cons type-name
          (:extract-object1
           (type-structure type-name)
           (component 'lineedits template)
           (component 'longedits template)
           (component 'controls template)
           (component 'shorts template)
           (component 'texts template))))

(de :extract-object1 (desc lines longs controls shorts texts)
    (let ((res ()))
      (while desc
        (newl res
              (selectq (nextl desc)
                       (symbol
                        (:extract-object2 (nextl lines)))
                       ((longsymbol nonquotesymbol)
                        (:extract-object2 (nextl longs)))
                       (control
                        (:extract-object2 (nextl controls)))
                       (short
                        (:extract-object2 (nextl shorts)))
                       ((text text-list)
                        (:extract-object2 (nextl texts))))))
      (nreverse res)))

(de :extract-object2 (editor)
    (ifn editor
         (error ':extract-object2 "not enough editors" ())
         (send 'get-value editor)))

; gestion de l'indicateur MODIFY

(de :unmodify (template)
    (mapc (lambda (m) (send 'modified-flag m ()))
          (component 'editors template)))

(de :modifyp (template)
    (any (lambda (m) (send 'modified-flag m))
         (component 'editors template)))
