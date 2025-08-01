(setq interprete? ())

(if interprete?
    (progn
  (print "dates ...")
      (libloadfile "dates.lh" t)
      (libloadfile "dates.ll" t)
  (print "points ...")
      (libloadfile "points.lh" t)
      (libloadfile "points.ll" t)
  (print "beau-cadre ...")
      (libloadfile "beau-cadre.lh" t)
      (libloadfile "beau-cadre.ll" t)
  (print "courbes ...")
      (libloadfile "courbes.lh" t)
      (libloadfile "courbes.ll" t)
  (print "echelles ...")
      (libloadfile "echelles.lh" t)
      (libloadfile "echelles.ll" t)
  (print "mybutton ...")
      (libloadfile "mybutton.lh" t)
      (libloadfile "mybutton.ll" t)
  (print "presentateur ...")
      (libloadfile "pres.lh" t)
      (libloadfile "pres.ll" t)
  (print "voyeur ...")
      (libloadfile "voyeur.lh" t)
      (libloadfile "voyeur.ll" t)
   (print "vue >..")
     (libloadfile "vue.lh" t)
     (libloadfile "vue.ll" t)
   (print "bars ...")
     (libloadfile "bars.lh" t)
     (libloadfile "bars.ll" t))
  
  (print "dates ...")
  (loadmodule "dates")
  (print "points ...")
  (loadmodule "points")
  (print "beau-cadre ...")
  (loadmodule "beau-cadre")
  (print "courbes ...")
  (loadmodule "courbes")
  (print "echelles ...")
  (loadmodule "echelles")
  (print "mybutton ...")
  (loadmodule "mybutton")
  (print "presentateur ...")
  (loadmodule "pres")
  (print "voyeur ...")
  (loadmodule "voyeur")
  (print "vue >..")
  (loadmodule "vue")
  (print "bars ...")
  (loadmodule "bars"))


(libloadfile "actions.ll" t)
(libloadfile "interface.li" t)
(libloadfile "liaison.ll" t)
(print "c est parti ...")
(libloadfile "demo.ll" t)

