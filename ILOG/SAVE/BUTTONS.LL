(defvar :button-widthcn 7)
(defvar :bigfont-name "helv12i")
(defvar :smallfont-name "6x10")

(unless (boundp ':bigfont)
        (defvar :bigfont))
(unless (boundp ':smallfont)
        (defvar :smallfont))

(de running-panel ()
    (unless (boundp 'stop-icon)
            (libloadicon 'stop-icon))
    (unless (boundp 'run-icon)
            (libloadicon 'run-icon))
    (mixed-applicationq image (Icon 0 0 stop-icon)))

(de interne-externe ()
    (let* ((interne  (selectableapplication
                      (:fond-blanc
                       (boxedimage 0 0
                                   (mul :interne-widthcn #wc)
                                   (mul 3 #hc)
                                   "Interne"))))
           (externe (selectableapplication
                     (:fond-blanc
                      (boxedimage 0 0
                                  (mul :interne-widthcn #wc)
                                  (mul 3 #hc)
                                  "Externe"))))
           (sel (selectorapplication 0 0 100 100 (column interne externe))))
      (send 'fit-to-contents sel)
      (send 'set-selection sel interne)
      sel))

(de message-panel ()
    (:fond-blanc
     (mixed-applicationq image "Welcome                                ")))

(de :double-bbox (w h i)
    (buttonbox 0 0 w h
               (buttonbox 0 0 (sub w 4) (sub h 4) i)))

(de :small-button (i)
    (button
     (:fond-blanc
     (font :bigfont
           (translation 1 1
                        (boxedview
                         (:double-bbox
                          (mul :button-widthcn #wc)
                          (add 8 #hc)
                          (translation 0 1 i))))))))

(de :single-button (i)
    (button
     (:fond-blanc
     (font :bigfont
           (translation 1 1
                        (boxedview
                         (:double-bbox
                          (mul :button-widthcn #wc)
                          (mul 3 #hc) i)))))))

(de :double-button (i)
    (button
     (:fond-blanc
     (font :bigfont
           (translation 1 1
                        (boxedview
                         (:double-bbox
                          (add 5 (mul (mul 2 :button-widthcn) #wc))
                          (mul 3 #hc) i)))))))

(de button-panel ()
    (unless :bigfont
            (setq :bigfont (load-font :bigfont-name)))
    (let ((exit (:double-button "Exit"))
          (doit (:double-button "do it"))
          (save (:double-button "Save"))
          (new (:single-button "new"))
          (add-kb (:single-button (column "add" " kb")))
          (add-object (:single-button (column " add" "object")))
          (del (:single-button "del"))
          (load-kb (:single-button (column "load" "  kb")))
          (load-object (:single-button (column "load" "object")))
          (ba (:single-button "A"))
          (bb (:single-button "B"))
          (bc (:single-button "C"))
          (bd (:single-button "D"))
          (be (:single-button "E"))
          (b (rectangle 0 0 3 3))
          (selector (interne-externe))
          (run (running-panel)))
      (set-action exit
                  (lambda (b)
                    (:protect-base-save
                     b
                     (remove-application (component 'appli b)))))
      (set-action doit ':doit)
      (set-action save ':save)
      (set-action new ':new)
      (set-action add-kb ':add-kb)
      (set-action add-object ':add)
      (set-action del ':delete)
      (set-action load-kb ':load-kb)
      (set-action load-object ':load-object)
      (mixed-applicationq
       image (view (row (column
                         (row (column ba b add-kb b load-kb)
                              b
                              (column bb b add-object  b load-object))
                         b
                         save)
                        b
                        (column (row bc b bd) b doit b exit)
                        b
                        (column be b new b del)
                        b
                        (column selector b b b (row b b b run))))
       run run
       doit doit)))
       
