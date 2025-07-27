; definition des types

(defvar :type-list ())

(dmd def-type-struct (type main . struct)
     `(progn (newl :type-list (string ',type))
             (putprop ',type ',main 'main-accessor)
             (putprop ',type ',(mapcar 'car struct) 'titles)
             (putprop ',type ',(mapcar 'cadr struct) 'structure)
             (putprop ',type ',(mapcar 'caddr struct) 'defaults)
             (putprop ',type
                      ',(mapcar (lambda (l) (mapcar 'string l))
                                (mapcar 'cadddr struct))
                      'controls)))

; acces aux descripteurs

(de type-name-list ()
    :type-list)

(de type-structure (type)
    (getprop type 'structure))

(de type-defaults (type)
    (getprop type 'defaults))

(de type-titles (type)
    (getprop type 'titles))

(de type-controls (type)
    (getprop type 'controls))

(de type-main-accessor (type)
    (getprop type 'main-accessor))

; les types

(def-type-struct add-knowledge-base
  cadr
  (name longsymbol))

(def-type-struct setq
  cadr
  (name nonquotesymbol)
  (contenu text))

(def-type-struct de
  cadr
  (name nonquotesymbol)
  (arguments short)
  (corps text-list))

(def-type-struct dmd
  cadr
  (name nonquotesymbol)
  (arguments short)
  (corps text-list))

(def-type-struct defsetf
  cadr
  (name nonquotesymbol)
  (arguments1 short)
  (argumental text)
  (corps text-list))

(def-type-struct user-instanciate
  caddr
  (metaclass symbol)
  (username longsymbol)
  (superlist short))

(def-type-struct add-slot-user
  caddr
  (object symbol)
  (slot longsymbol)
  (nature control instance (instance class-instance metaclass)))

(def-type-struct add-slot-facet-user
  cadddr
  (object symbol)
  (slot longsymbol)
  (facet symbol)
  (value short))

(def-type-struct initialize-object
  cadr
  (object symbol)
  (list-of-doublets text))

(def-type-struct initialize-slot
  caddr
  (object symbol)
  (slot longsymbol)
  (list-of-doublets text))

(def-type-struct add-link
  cadr
  (object1 longsymbol)
  (slot1 symbol)
  (object2 longsymbol)
  (slot2 symbol))

(def-type-struct add-dynamic-link
  cadr
  (object1 longsymbol)
  (slot1 symbol)
  (way1 control instance (instance metaclass))
  (object2 longsymbol)
  (slot2 symbol)
  (way2 control instance (instance metaclass)))

(def-type-struct add-attribute-user
  caddr
  (object symbol)
  (slot longsymbol)
  (function text)
  (nature control instance (instance class-instance metaclass)))

(def-type-struct add-method
  cadddr
  (object symbol)
  (function text)
  (name longsymbol)
  (way control superseed (superseed merge-before merge-after)))

(def-type-struct add-expand-method
  caddr
  (object1 longsymbol)
  (object2 longsymbol)
  (method text))

(def-type-struct add-pre-instanciation-demon
  cadr
  (object symbol)
  (function text)
  (way control superseed (superseed merge-before merge-after)))

(def-type-struct add-post-instanciation-demon
  cadr
  (object symbol)
  (function text)
  (way control superseed (superseed merge-before merge-after)))

(def-type-struct add-read-demon
  caddr
  (object symbol)
  (slot longsymbol)
  (function text)
  (way control superseed (superseed merge-before merge-after)))

(def-type-struct add-write-before-demon
  caddr
  (object symbol)
  (slot longsymbol)
  (function text)
  (way control superseed (superseed merge-before merge-after)))

(def-type-struct add-write-after-demon
  caddr
  (object symbol)
  (slot longsymbol)
  (function text)
  (way control superseed (superseed merge-before merge-after)))

(def-type-struct add-determination-bloc
  cadr
  (name longsymbol)
  (body text))

(de caddddr (c) (car (cddddr c)))

(def-type-struct add-situation-bloc
  caddddr
  (slot-list short)
  (predicat text)
  (action text)
  (name longsymbol))

(de cadddddr (c) (cadr (cddddr c)))

(def-type-struct add-formule
  cadddddr
  (indice longsymbol)
  (argument-list short)
  (body text)
  (access-list text)
  (name longsymbol))

(def-type-struct add-forward-rule
  cadr
  (chainer longsymbol)
  (premisse text)
  (conclusion text))

(def-type-struct add-rete-forward-rule
  cadr
  (chainer longsymbol)
  (premisse text)
  (conclusion text))

(def-type-struct add-backward-rule
  cadr
  (chainer longsymbol)
  (premisse text)
  (conclusion text)
  (type-conclu short))

(def-type-struct add-rete-forward-chainer
  cadr
  (chainer-name longsymbol)
  (slot-list short))

(def-type-struct add-forward-chainer
  cadr
  (chainer-name longsymbol)
  (slot-list short))

(def-type-struct add-backward-chainer
  cadr
  (chainer-name longsymbol)
  (slot-list short))

(def-type-struct set-determination-slot
  caddr
  (objet longsymbol)
  (slot symbol)
  (list-of-doublet short))
