;fichier qui permet d etudier le montant necessaire a l achat du marche et le flux de dividende associe



(setq ponderations '((ai 4.01) (ca 2.32) (cl 1.38) (sq 1.84) (or 3.41) (ac 1.45) (aq 5.89) (en 1.18) (ly 1.29) 
                     (lg 2.91) (lr 1.21) (cs 3.84) (bn 4.97) (ri 1.98) (mt 1) (ff 1.07) (mc 6.12) (cw 1.2) 
                     (ml 2.39) (ho 3.33) (cb 1.13) (ex 3.59) (ug 5.22) (cu 0.84 ) (mi 1.5) (du 0.74) (ef 0.78)
                     (pn 1.29) (lh 0.85) (ar 0.72) (sgo 5.21) (pm 4.46) (cap 1.65) (co 1.06) (cge 4.77) (aj 1.48)
                     (rs 0.98) (cr 1.35) (gle 5.2) (fs 4.37)))

(setq cours '((ai 630) (ca 3375)  (cl 2800) (sq 819) (or 4225) (ac 630) (aq 424.5) (en 632) (ly 1689) (lg 1520) 
              (lr 3755) (cs 1690) (bn 694) (ri 1377) (mt 3750) (ff 901) (mc 3790) (cw 1500) (ml 196) (ho 239.5)
              (cb 555) (ex 1796) (ug 1430) (cu 570) (mi 1182) (du 860) (ef 3720) (pn 1220) (lh 345) (ar 2612) 
              (sgo 620) (pm 484.5) (cap 2591) (co 216) (cge 409) (aj 700) (rs 1300) (cr 1311) (gle 507) (fs 323)
              ))

(setq quotites '((ai 25) (ca 5) (cl 10) (sq 25) (or 5) (ac 50) (aq 100) (en 25) (ly 25) (lg 10) (lr 10) (cs 5) (bn 10)
                 (ri 25) (mt 10) (ff 10) (mc 10) (cw 25) (ml 10) (ho 10) (cb 25) (ex 10) (ug 25) (cu 50) (mi 25) (du 10)
                 (ef 10) (pn 10) (lh 100) (ar 10) (sgo 10) (pm 25) (cap 5) (co 50) (cge 10) (aj 25) (rs 25) (cr 25)
                 (gle 10) (fs 10)))
                 

(setq dividendes '((ai 13 (89 6 13 0 0 0)) (ca 64 (89 4 29 0 0 0)) (cl 85 (89 6 30 0 0 0)) (sq 21 (89 6 8 0 0 0))
                   (or 42 (89 6 30 0 0 0)) (ac 10 (89 8 4 0 0 0)) (aq 15 (89 7 8 0 0 0)) (en 14.5 (89 6 20 0 0 0))
                   (ly 34 (89 7 18 0 0 0)) (lg 28 (89 7 1 0 0 0)) (lr 46 (89 7 1 0 0 0)) (cs 23 (89 5 2 0 0 0))
                   (bn 95 (89 6 13 0 0 0)) (ri 25.5 (89 5 18 0 0 0)) (mt 45 (89 7 29 0 0 0)) (ff 30 (89 6 6 0 0 0))
                   (mc 37.5 (89 7 4 0 0 0)) (cw 22 (89 6 30 0 0 0)) (ml 2.7 (89 7 11 0 0 0)) (ho 7 (89 7 11 0 0 0))
                   (cb 10 (89 3 31 0 0 0)) (ex 28 (89 7 11 0 0 0)) (ug 23 (89 7 7 0 0 0)) (cu 9 (89 7 1 0 0 0))
                   (mi 20 (89 7 18 0 0 0)) (du 15 (89 7 15 0 0 0)) (ef 37 (89 7 4 0 0 0)) (pn 13 (89 7 7 0 0 0))
                   (lh 32 (89 7 12 0 0 0)) (ar 35 (89 7 7 0 0 0)) (sgo 12.5 (89 7 11 0 0 0)) (pm 8.5 (89 5 16 0 0 0)) 
                   (cap 22.7 (89 6 1 0 0 0)) (co 6 (89 6 6 0 0 0)) (cge 8.5 (89 6 27 0 0 0)) (aj 10 (89 7 15 0 0 0))
                   (rs 20 (89 7 6 0 0 0)) (cr 14 (89 6 30 0 0 0)) (gle 11 (89 6 10 0 0 0)) (fs 8.5 (89 7 6 0 0 0))))
                   

(setq montants-essayes '(1000000. 2000000. 3000000. 4000000. 5000000. 6000000. 7000000. 8000000. 9000000. 10000000.))

(setq taux-monetaire 8.)
(de top-go ()
    (prog ()


(setq courbe-des-delta-%
      (mapcar '(lambda (montant)
                 
                 (setq jour-d-aujourdhui '(89 1 30 0 0 0))
                 (setq qte-ri (mapcar '(lambda (x) (list (car x) (truncate (/ (* (/ montant 100.) (cadr x)) 
                                                                              (cadr (assoc (car x) cours))))))
                                      ponderations))
                 (setq qte-rm (mapcar '(lambda (x) (list (car x) (* (truncate (/ (cadr x) 
                                                                                 (cadr (assoc (car x) quotites))))
                                                                    
                                                                    (cadr (assoc (car x) quotites)))))
                                      qte-ri))
                 (setq delta-ri (apply '+ (mapcar '(lambda (x) (* (cadr x) 
                                                                  (cadr (assoc (car x) cours))))
                                                  qte-ri)))
                 (setq delta-rm (apply '+ (mapcar '(lambda (x) (* (cadr x) 
                                                                  (cadr (assoc (car x) cours))))
                                                  qte-rm)))
                 
                 
                 (setq delta-%-ri (* (/ (- montant delta-ri) montant) 100.))
                 (setq delta-%-rm (* (/ (- montant delta-rm) montant) 100.))
                 
                 (setq flux-de-dividende-ri (apply '+ (mapcar '(lambda (x)
                                                                 (* (cadr x)
                                                                    (cadr (assoc (car x)  dividendes))
                                                                    (/ 1
                                                                       (power (+ 1. (/ taux-monetaire 100.))
                                                                              (/ (- (convert-time  (caddr (assoc (car x)  
                                                                                                                 dividendes)))
                                                                                    (convert-time jour-d-aujourdhui))
                                                                                 365.)))))
                                                              qte-ri)))
                 
                 (setq flux-de-dividende-rm (apply '+ (mapcar '(lambda (x)
                                                                 (* (cadr x)
                                                                    (cadr (assoc (car x)  dividendes))
                                                                    (/ 1
                                                                       (power (+ 1. (/ taux-monetaire 100.))
                                                                              (/ (- (convert-time  (caddr (assoc (car x)  
                                                                                                                 dividendes)))
                                                                                    (convert-time jour-d-aujourdhui))
                                                                                 365.)))))
                                                              qte-rm)))
                 (list montant '/ delta-%-ri  (/ flux-de-dividende-ri delta-ri) 
                       '/  delta-%-rm   (/ flux-de-dividende-rm delta-rm) )
                 )
              montants-essayes))
(setq savechan (outchan))
(setq chan (openo  "/usr/jupiter/olivier/expert/test/resultat.lisp"))
(outchan chan)

(print "courbe-des-delta-% = " )
(pprint courbe-des-delta-%)


(print " pour le montant = " montant)
(print "qte-ri = " qte-ri)
(print "qte-rm = " qte-rm)
(print "delta-ri = " delta-ri)
(print "delta-rm = " delta-rm)
(print "delta-%-ri = " delta-%-ri " % de " montant)
(print "delta-%-rm = " delta-%-rm " % de " montant)
(print "flux-de-dividende-ri = " flux-de-dividende-ri)
(print "flux-de-dividende-rm = " flux-de-dividende-rm)

(outchan savechan)
(close)
nil
          
))