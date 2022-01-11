#lang racket

(define (main)
  ; TODO: Read in size and number of simulation turns
  (define size 40)
  (define inital-state-file "gosper_glider_gun.txt")

  ; Set up board
  (define board
    (build-vector
      size
      (lambda (i)
        (build-vector
          size
          (lambda (i)
            (vector #f)
          )
        )
      )
    )
  )
  
  ; Parse input file
  (define coords_str (string-split (port->string (open-input-file inital-state-file))))
  (define coords (map 
    (lambda (c)
      (define i (string->number c))
      (cond
        [(not i) (raise (printf "\"~a\" is not a valid integer." c))]
        [(not (< -1 i size)) (raise (printf "~a is out of bounds for board of size ~a." i size))]
        [else i]
      )
    )
    coords_str
  ))
  ; Check for odd number of coordinates
  (if (not (equal? (remainder (length coords) 2) 0))
    (raise (printf "There are an odd number of coordinates in ~a." inital-state-file))
    (void)
  )

  ; Apply to board
  (for ([i (in-range 0 (length coords) 2)])
    (define x (list-ref coords i))
    (define y (list-ref coords (+ i 1)))
    (vector-set! (vector-ref board x) y #t)
  )
  
  0
)

(main)