; quelques macro-caracteres

(de |;| ()
    (tcons 'comment (readstring)))

(de |(| ()
    (read-delimited-list #/)))

(de |)| ()
    (exit end-of-list))

; pour imprimer les commentaires

(de #:comment:prin (comment)
    (princn #/;)
    (let ((#:system:print-for-read ()))
      (print (cdr comment))))

(de parse-kb ()
    (let ((res ()))
      (with ((typecn #/( 'cmsymb) 
             (typecn #/; 'cmacro)
             (typecn #/{ 'cpname)
             (typecn #/} 'cpname))
            (untilexit eof
                       (newl res
                             (parse-kb-item (read)))))
      (nreverse res))))

(de parse-kb-item (item)
    (with ((typecn #/) 'cmacro) 
           (typecn #/( 'cmacro))
          (cond ((consp item) item)
                ((eq item '|(|)    
                 (parse-item-by-type (read))))))

(de parse-item-by-type (type)
    (let ((structure (type-structure type)))
      (cons type
            (ifn structure
                 (list-sexpr-read-line)
                 (mapcar 'parse-structure structure)))))

(de parse-structure (structure)
    (selectq structure
             ((longsymbol symbol control) (unquote-read))
             (nonquotesymbol (read))
             ((short text) (sexpr-read-line))
             (text-list (list-sexpr-read-line))
             (t (error 'parse-structure "not a structure element" structure))))


(de unquote-read ()
    (let ((res (read)))
      (if (and (consp res)
               (eq 'quote (car res))
               (null (cddr res)))
          (cadr res)
        res)))

(unless (boundp ':lines)
        (defvar :lines))

(de #:sexpr-read-line:bol ()
    (super-itsoft 'sexpr-read-line 'bol ())
    (newl :lines (substring (inbuf) 0 (sub (inmax) 2)))
    (setq :inpos ()))

(de sexpr-read-line ()
    (let ((#:sys-package:itsoft 'sexpr-read-line)
          (:lines)
          (:inpos (inpos))
          (eol (sub (inmax) (inpos))))
      (when (ge eol 2)
            (setq :lines
                  (ncons (substring (inbuf) (inpos) (sub eol 2)))))
      (read)
      (rplaca :lines
              (substring (car :lines) 0
                         (ifn :inpos
                              (inpos)
                              (sub (inpos) :inpos))))
      (when (eq (add (inpos) 2) (inmax))
            (inpos (inmax)))
      (nreverse :lines)))

(de list-sexpr-read-line ()
    (let ((res ()))
      (untilexit end-of-list
                 (setq res (nconc res (sexpr-read-line))))
      res))

(de unparse-kb (kb)
    (with ((rmargin 257))
          (let ((#:system:print-for-read ()))
            (mapc 'unparse-item kb))))

(de unparse-item (item)
    (cond ((consp item)
           (if (tconsp item)
               (print item)
             (unparse-object (car item) (cdr item))))
          (t
           (print item))))

(de unparse-object (type item)
    (let ((desc (type-structure type)))
      (princn #/()
      (prin type)
      (ifn desc
           (mapc 'prin item)
           (unparse-object1 desc item))
      (princn #/))
      (terpri)
      (terpri)))

(de unparse-object1 (desc item)
    (while desc 
      (selectq (nextl desc)
               ((longsymbol symbol control)
                (princn #\sp)
                (princn #/')
                (prin (nextl item)))
               ((nonquotesymbol)
                (princn #\sp)
                (prin (nextl item)))
               (short
                (tprin-list (car item))
                (when (car item) (terpri))
                (nextl item))
               ((text text-list)
                (tprin-list (nextl item)))
               (t (error 'unparse-object1 "not a structure element" desc)))))

(de tprin-list (l)
    (while l
      (prin (car l))
      (when (cdr l) (terpri))
      (nextl l)))

(de load-kb (file)
    (with ((inchan (openi file)))
          (parse-kb)))

(de save-kb (file kb)
    (with ((outchan (openo file)))
          (unparse-kb kb)
          (close (outchan))))

(de kb-bases ()
    '("foo.ll"
      "base.kb"
      "canal.kb"
      "eliot.kb"
      "fourier.kb"
      "rapport.kb"
      "save.kb"
      "technique.kb"))

(de load-named-kb (kb-name)
    (kb-by-name kb-name (load-kb kb-name)))

(de unload-named-kb (kb-name)
    (kb-by-name kb-name ()))

(de save-named-kb (kb-name)
    (save-kb kb-name (kb-by-name kb-name)))

(de kb-by-name (kb-name . value)
    (ifn value
         (get kb-name 'kb-description)
         (putprop kb-name (car value) 'kb-description)))

(de kb-create (filename)
    (when (probefile filename)
          (renamefile filename (catenate filename "~")))
    (with ((outchan (openo filename)))
          (print "(add-knowledge-base '" filename ")")
          (close (outchan))))
     
; manipulation d'une kb

(de kb-type-names (kb)
    (mapcar 'string (allowed-types (unique-car kb))))

(de allowed-types (l)
    (mapcan (lambda (type)
              (when (type-structure type)
                    (list type)))
            l))

(de kb-object-ids (kb type)
    (let ((main-field-accessor (type-main-accessor type))
          (objects (kb-objects-list kb type)))
      (if (not main-field-accessor)
          (numbered-list type objects)
        (mapcar 'string
                (mapcar main-field-accessor objects)))))

(de kb-objects-list (kb type)
    (mapcan (lambda (o)
              (when (and (consp o)
                         (eq (car o) type))
                    (ncons o)))
            kb))

(de kb-object (kb type rank)
    (nth rank (kb-objects-list kb type)))

(de kb-replace-object (kb previousobject object)
    (let ((lkb (memq previousobject kb)))
      (ifn lkb
           (error 'kb-replace-object "object not in kb" previousobject)
           (rplaca lkb object))))

(de kb-add-object (kb object)
    (nconc1 kb object))
 
(de kb-remove-object (kb object)
    (when (confirm "Really delete?")
          (delq object kb)))
 
; utilitaires lispiens

(de numbered-list (symbol l)
    (let ((res ())
          (i (length l)))
      (repeat i
              (newl res (catenate symbol "-" i))
              (decr i))
      res))

(de unique-car (l)
    (unique-car1 l ()))

(de unique-car1 (l cars)
    (ifn (consp l)
         cars
         (unique-car1 (cdr l)
                      (if (or (not (consp (car l)))
                              (memq (caar l) cars))
                          cars
                        (cons (caar l) cars)))))
                                         
