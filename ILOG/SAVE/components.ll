; quelques fonctions utiliaires pour les composants

(de move-components (from to)
    ({Application}:components
     to
     (append ({Application}:components to)
             ({Application}:components from)))
    ({Application}:components from ()))

(de set-component (appli name comp)
    (if (null appli)
	(error 'component errnotacomponent name)
      (let ((pair (assq name ({Application}:components appli))))
        (if pair
            (rplacd pair comp)
          (set-component ({Application}:father appli) name comp)))))

