#lang racket

(provide fill-abilities)
(provide compose-abilities)
(provide hourglass)
(provide get-ability-image)
(provide get-ability-time)
(provide get-ability-pos)
(provide get-ability-next)
(provide ability)
(provide ability-pos)
(provide ability-image)
(provide ability-time)
(provide ability-next)

(require "random.rkt")
(require lang/posn)
(require 2htdp/image)

; Imaginea si range-ul în care vor aparea abilitațile
; Nu modificați
(define POSITION_RANGE '((300 2000) (30 550)))
(define (hourglass color) (underlay
 (rectangle 40 40 "solid" color)
 (polygon
  (list (make-posn 0 0)
        (make-posn 25 0)
        (make-posn 0 25)
        (make-posn 25 25))
  "outline"
  (make-pen "darkslategray" 5 "solid" "round" "round"))))

(define-struct ability (image time pos next))

; Fiecare funcție returneaza o componenta a unei abilități.
(define (get-ability-image ability)
  (ability-image ability))
(define (get-ability-time  ability)
  (ability-time ability))
(define (get-ability-pos   ability)
  (ability-pos ability))
(define (get-ability-next  ability)
  (ability-next ability))

; Returneaza o poziție aleatorie în POSITION_RANGE.
(define (random-position range)
  (apply make-posn (map ((curry apply) random) range)))

; Returnează o listă de n elemente alese aleatoriu din lista L.
(define (choice-abilities n L)
  (sample (discrete-dist L) n))

; Va parcurge abitatile și pentru cele care au poziția null va asigna
; una aletorie.
; Folosiți random-position
(define (position-abilities abilities)
  (map (λ(a)
         (if (null? (ability-pos a))
             (struct-copy ability a [pos (random-position POSITION_RANGE)])
             (ability-pos a)))
       abilities))
                  

; Fiecare abilitate are o funcție next care modifica stare jocului
; Compuneti toate funcțiile next în una singură
; Hint: compose
(define (compose-abilities L)
  (apply compose (map get-ability-next L)))

; Primiște o listă de abilități inițiale, un număr n
; și o listă cu toate abilități posibile.
; Va adauga elemente aleatoare la lista inițială pană aceasta are lungimea n
; Atentie n poate fi chiar si 0 cand vrem sa jucam fara nicio abilitate.
; Folosiți choice-abilities.
(define (fill-abilities initial n abilities)
  (if (< (length initial) n)
      (append initial (position-abilities (choice-abilities (- n (length initial)) abilities)))
      initial))