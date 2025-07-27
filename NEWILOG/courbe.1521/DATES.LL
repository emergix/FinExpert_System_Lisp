;----------------------------------------------------------------------
; les dates

(setq #:sys-package:colon '{ma-date})

(de :inverse-convert-time (value)
    (let* ((ans (div value 360))
           (mois (div (sub value (mul ans 360)) 30))
           (jours (sub value (add (mul ans 360) (mul 30 mois))))
          )
        (:annees :global ans)
        (:mois :global mois)
        (:jours :global jours)
        :global))

(de :convert-time (date)
        (add (mul 360 (:annees date))
             (add (mul 30 (:mois date))
                  (:jours date))) )

(de :debut-de-mois-suivant (date)
        (:jours date 0)
        (:mois date (add1 (:mois date)))
        (when (ge (:mois date) 12)
              (:annees date (add1 (:annees date)))
              (:mois date 0))
        date)

(de :debut-de-trimestre-suivant (date)
        (:jours date 0)
        (:mois date (mul 3 (div (add 3 (:mois date)) 3)))
        (when (ge (:mois date) 12)
              (:annees date (add1 (:annees date)))
              (:mois date 0))
        date)

(de :debut-d-annee-suivante (date)
        (:jours date 0)
        (:mois date 0)
        (:annees date (add1 (:annees date)))
        date)

(de :nom-du-mois (date)
        (nth (:mois date) :table-des-mois))


