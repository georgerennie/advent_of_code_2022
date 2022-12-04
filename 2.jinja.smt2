(set-option :produce-models true)
(set-logic QF_UFLIA)

; Part 1

(declare-sort Choice 0)

(declare-const Rock Choice)
(declare-const Paper Choice)
(declare-const Scissors Choice)
(define-fun A () Choice Rock)
(define-fun B () Choice Paper)
(define-fun C () Choice Scissors)
(define-fun X () Choice Rock)
(define-fun Y () Choice Paper)
(define-fun Z () Choice Scissors)

(declare-fun val (Choice) Int)
(assert (= (val Rock) 1))
(assert (= (val Paper) 2))
(assert (= (val Scissors) 3))

(define-fun win ((opp Choice) (us Choice)) Bool
	(or
		(and (= us Rock)     (= opp Scissors))
		(and (= us Paper)    (= opp Rock))
		(and (= us Scissors) (= opp Paper))
	)
)

(define-fun lose ((opp Choice) (us Choice)) Bool (win us opp))
(define-fun draw ((opp Choice) (us Choice)) Bool (= opp us))

(define-fun outcome ((opp Choice) (us Choice)) Int
	(ite (win opp us) 6 (ite (draw opp us) 3 0))
)

(define-fun score ((opp Choice) (us Choice)) Int
	(+ (val us) (outcome opp us))
)

(define-fun part-1 () Int
	(+{%- for line in input_lines %} (score {{ line }}){%- endfor %})
)

; Part 2

(define-fun force ((opp Choice) (res Choice) (us Choice)) Bool
	(and
		(=> (= res X) (lose opp us))
		(=> (= res Y) (draw opp us))
		(=> (= res Z) (win opp us))
	)
)

{%- for line in input_lines %}
(declare-const choice-{{ loop.index }} Choice) (assert (force {{ line }} choice-{{ loop.index }}))
{%- endfor %}

(define-fun part-2 () Int
	(+{%- for line in input_lines %} (score {{ line.split()[0] }} choice-{{ loop.index }}){%- endfor %})
)

(check-sat)
(get-value (part-1 part-2))
