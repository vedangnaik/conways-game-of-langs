#lang racket

(struct Board (b size))

(define (saveBoardAsPBMP1 board filename)
  (call-with-output-file filename #:exists 'replace
    (lambda (out)
      (define size (Board-size board))
      (define b (Board-b board))
      (fprintf out "P1\n~a ~a\n" size size)
      (for ([x (in-range size)])
        (for ([y (in-range size)])
          (fprintf out "~a " 
            (if (vector-ref (vector-ref b x) y)
              "1"
              "0"
            )
          )
        )
        (fprintf out "\n")
      )
    )
  )
  (void)
)

(define (main)
  ; TODO: Read in size and number of simulation turns
  (define size 40)
  (define inital-state-file "gosper_glider_gun.txt")

  ; Set up board
  (define board
    (Board
      (build-vector
        size
        (lambda (i)
          (build-vector
            size
            (lambda (i)
              #f
            )
          )
        )
      )
      size
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
    (vector-set! (vector-ref (Board-b board) x) y #t)
  )

  (saveBoardAsPBMP1 board "test.pbm")

  0
)

(main)