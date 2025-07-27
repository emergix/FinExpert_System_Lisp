(defvar {scrollbar}:sliderpattern 3)
(defvar {scrollbar}:indexpattern 4)

(defvar :scroller-widthcn 28)                   ;largeur des scrollers 
(defvar :scroller-heightcn 10)                  ;  hauteur des scrollers
(defvar :interne-widthcn 9)
(defvar :short-le-width-cn 19)
(defvar :long-le-width-cn 39)
(defvar :title-width-cn 13)
(defvar :text-width-cn 85)
(defvar :short-text-height-cn 10)
(defvar :text-height-cn 80)
(defvar :short-scroller-height-cn 3)
(defvar :text-scroller-height-cn 15)

(de :fit-appli (i)
    (mixed-applicationq image i))

(de :text-scroller (text)
    (verticalscroller 0 0
                      (add (send 'width text) {scroller}:scrollbarwidth)
                      (mul :text-scroller-height-cn #hc)
                      text))

(de :title-viewer ()
    (application '{application} 0 0 (mul :title-width-cn #wc) #hc ""))

(de :titled-boxed (title i)
    (:titled-image
     title
     (translation 1 1
                  (boxedview (Rectangle 0 0 (add 10 (send 'width i))
                                        (add 10 (send 'height i))) i))))

(de :titled-image (title i)
    (:fit-appli
     (view (translation 0 11 (:fond-blanc i))
           (centeredview (rectangle 0 0 (send 'width i) 0)
                         (:make-title title
                                      (sub (send 'width i) #5wc)
                                      (add 4 #hc))))))

(de :cadre ()
    (translation 1 1
                 (boxedview
                  (Filledbox 0 0 402 402 3)
                  (Boxedview
                   (Filledbox 0 0 396 396 0)))))

(de :make-title (title w h)
    (:fond-blanc
     (buttonbox 0 0 w h
                (buttonbox 0 0 (sub w 2) (sub h 2)
                           (font 1 title)))))

(de sized-verticalscroller (i width)
    (send 'translate i 2 0)
    (verticalscroller 0 0
                      (mul width (width-space))
                      (mul :scroller-heightcn (width-space))
                      i))

(de :bar-scroller (scroller)
    (view scroller
          (box (sub1 {Scroller}:scrollbarwidth)
               0
               1
               (send 'height scroller))))

(de :banded-image (title i)
    (let* ((w (send 'width i))
           (image
            (:relief
             (translation
              1 1
              (boxedview
               (row
                (column
                 (inversion (font 1
                                  (centeredview (rectangle 0 0 w (+ 2 #hc))
                                                title)))
                 (box 0 0 w 3)
                 i)))))))
      (:fit-appli image)))
      
(de :relief (i)
    (let ((image (Column (Row i (box 0 0 1 0)) (box 0 0 0 1))))
      (send 'grow image (send 'width image) (send 'height image))
      image))

(de margin-view (i margin)
    (centeredview (rectangle 0 0
                             (add margin (send 'width i))
                             (add margin (send 'height i)))
                  i))


(de :fond-blanc (i)
    (view (filledbox 0 0 (send 'width i) (send 'height i) 0)
          i))

(de :fond-gris (i)
    (view (filledbox 0 0 (send 'width i) (send 'height i) 3)
          i))

