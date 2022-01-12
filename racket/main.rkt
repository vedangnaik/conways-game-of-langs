#lang racket

(define Board% (class object%
  (init size)

  (define s size)
  (define b 
    (build-vector
      s
      (lambda (i)
        (build-vector
          s
          (lambda (i)
            #f
          )
        )
      )
    )
  )
  (super-new)

  (define/public (is-set row col)
    (vector-ref (vector-ref b row) col)
  )

  (define/public (set row col)
    (vector-set! (vector-ref b row) col #t)
  )

  (define/public (get-size)
    s
  )
))

(define (saveBoardAsPBMP1 board filename)
  (call-with-output-file filename #:exists 'replace
    (lambda (out)
      (define size (send board get-size))
      
      (fprintf out "P1\n~a ~a\n" size size)
      (for ([row (in-range size)])
        (for ([col (in-range size)])
          (fprintf out "~a " 
            (if (send board is-set row col)
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
  (define size (send board get-size))

  (define count 0)
  (define row_lower (modulo (- row 1) size))
  (define row_upper (modulo (+ row 1) size))
  (define col_lower (modulo (- col 1) size))
  (define col_upper (modulo (+ col 1) size))

  (set! count (+ count (if (send board is-set row_lower col_lower) 1 0 )))
  (set! count (+ count (if (send board is-set row_lower col      ) 1 0 )))
  (set! count (+ count (if (send board is-set row_lower col_upper) 1 0 )))
  (set! count (+ count (if (send board is-set row       col_lower) 1 0 )))
  (set! count (+ count (if (send board is-set row       col_upper) 1 0 )))
  (set! count (+ count (if (send board is-set row_upper col_lower) 1 0 )))
  (set! count (+ count (if (send board is-set row_upper col      ) 1 0 )))
  (set! count (+ count (if (send board is-set row_upper col_upper) 1 0 )))

  count
)

(define (main)
  ; TODO: Read in size and number of simulation turns
  (define user-size 40)
  (define user-num-timesteps 100)
  (define user-inital-state-file "gosper_glider_gun.txt")

  ; Set up board
  (define board (new Board% [size user-size]))
  (define size (send board get-size))

  ; Parse input file
  (define coords_str (string-split (port->string (open-input-file user-inital-state-file))))
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
    (raise (printf "There are an odd number of coordinates in ~a." user-inital-state-file))
    (void)
  )

  ; Apply to board
  (for ([i (in-range 0 (length coords) 2)])
    (define x (list-ref coords i))
    (define y (list-ref coords (+ i 1)))
    (send board set x y)
  )

  ; Main simulation loop
  (for ([timestep (in-range user-num-timesteps)])
    (saveBoardAsPBMP1 board (format "~a.pbm" timestep))

    (define nextBoard (new Board% [size user-size]))
    (for ([row (in-range size)])
      (for ([col (in-range size)])
        (define num-neighbors (getNumNeighbors board row col))
        (if (send board is-set row col)
          (if (<= 2 num-neighbors 3)   (send nextBoard set row col) void)
          (if (equal? num-neighbors 3) (send nextBoard set row col) void)
        )
      )
    )
    (set! board nextBoard)
  )
  0
)

(main)