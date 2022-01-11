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

(define (getNumNeighbors board row col)
  (define size (Board-size board))
  (define b (Board-b board))
  
  (define count 0)
  (define row_lower (modulo (- row 1) size))
  (define row_upper (modulo (+ row 1) size))
  (define col_lower (modulo (- col 1) size))
  (define col_upper (modulo (+ col 1) size))

  (define (boardIsSet x y)
    (vector-ref (vector-ref b x) y)
  )

  (set! count (+ count (if (boardIsSet row_lower col_lower) 1 0 )))
  (set! count (+ count (if (boardIsSet row_lower col      ) 1 0 )))
  (set! count (+ count (if (boardIsSet row_lower col_upper) 1 0 )))
  (set! count (+ count (if (boardIsSet row       col_lower) 1 0 )))
  (set! count (+ count (if (boardIsSet row       col_upper) 1 0 )))
  (set! count (+ count (if (boardIsSet row_upper col_lower) 1 0 )))
  (set! count (+ count (if (boardIsSet row_upper col      ) 1 0 )))
  (set! count (+ count (if (boardIsSet row_upper col_upper) 1 0 )))

  count
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
  (if (not (equal? (modulo (length coords) 2) 0))
    (raise (printf "There are an odd number of coordinates in ~a." inital-state-file))
    (void)
  )

  ; Apply to board
  (for ([i (in-range 0 (length coords) 2)])
    (define x (list-ref coords i))
    (define y (list-ref coords (+ i 1)))
    (vector-set! (vector-ref (Board-b board) x) y #t)
  )

  0
)

(main)