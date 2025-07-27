(de {application}:set-value (title string)
    (setq string (string string))
    (unless (stringp string)
            (error '{application}:set-value errnsa string))
    (send 'set-image title
          (if (null string)
              (filledbox 0 0 1000 1000 0)
            (centeredview (rectangle 0 0
                                     (send 'width title) (send 'height title))
                          (font 1 string)))))

(de {lineedit}:set-value (le value)
    (unless (stringp (setq value (string value)))
            (error '{lineedit}:set-value errnsa value))
    (send 'set-line le value))

(de {medite}:set-value (te value)
    (when (eq value 'nil) (setq value ()))
    (unless (or (null value)
                (and (consp value)
                     (every 'stringp value)))
            (error '{medite}:set-value "not a list of strings" value))
    (medite-buf-new te)
    (send 'set-text te value))

(de {roller}:set-value (ro value)
    (unless (stringp (setq value (string value)))
            (error '{roller}:set-value errnsa value))
    (send 'select-image ro value))

(de {lineedit}:get-value (le)
    (read-from-string (send 'get-line le)))

(de {medite}:get-value (te)
    (send 'get-text te))

(de {roller}:get-value (ro)
    (read-from-string (send 'get-current ro)))

