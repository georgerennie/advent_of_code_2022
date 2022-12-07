(set-option :produce-models true)
(set-logic QF_UFLIA)

; Part 1

(declare-sort Dir 0)
(declare-fun parent (Dir) Dir)
(declare-fun subdir (Dir Dir) Dir)
(declare-fun size (Dir) Int)

(declare-const |dir-/| Dir)
(declare-const |dir-..| Dir)
{%- for line in set(input_lines) %}
{%- set parts = line.split() -%}
{%- if parts[0] == "dir" %}
(declare-const |dir-{{ parts[1]}}| Dir)
{%- endif %}
{%- endfor %}

(assert
	(distinct
		|dir-/|
		|dir-..|
		{%- for line in set(input_lines) %}
		{%- set parts = line.split() -%}
		{%- if parts[0] == "dir" %}
		|dir-{{ parts[1]}}|
		{%- endif %}
		{%- endfor %}))

(define-fun size-subdir ((root Dir) (dir Dir)) Int
	(size (subdir root dir)))

(define-fun cd ((old Dir) (new Dir) (dirname Dir)) Bool
	(ite (= dirname |dir-..|)
		(= new (parent old))
		(and
			(= old (parent new))
			(= new (subdir old dirname)))))

(define-fun set-size ((dir Dir) (new-size Int)) Bool
	(= (size dir) new-size))

(declare-const tmp-dir-0 Dir)
{%- set tmp_dir = namespace(value=0) %}
{%- set dir = namespace(value=0) %}
{%- set brackets_outstanding = namespace(value=false) %}
{%- for line in input_lines %}
{%- set parts = line.split() %}
{%- if parts[0] == "$" and parts[1] == "cd" %}
{%- if brackets_outstanding.value %})))
{%- set brackets_outstanding.value = false %}
{%- endif %}
{%- set tmp_dir.value = tmp_dir.value + 1 %}

(declare-const tmp-dir-{{tmp_dir.value}} Dir)
{%- if parts[2] != ".." %}
(declare-const dir-{{dir.value}} Dir)
(assert (= dir-{{dir.value}} tmp-dir-{{tmp_dir.value}}))
{%- set dir.value = dir.value + 1 %}
{%- endif %}
(assert (cd tmp-dir-{{tmp_dir.value-1}} tmp-dir-{{tmp_dir.value}} |dir-{{parts[2]}}|))
{%- elif parts[0] == "$" and parts[1] == "ls" %}
{%- set brackets_outstanding.value = true %}
(assert
	(set-size tmp-dir-{{tmp_dir.value}}
	(+ 0
{%- elif parts[0].isdigit() %}
		{{ parts[0] }}
{%- elif parts[0] == "dir" %}
		(size-subdir tmp-dir-{{tmp_dir.value}} |dir-{{parts[1]}}|)
{%- endif %}
{%- endfor %}
{%- if brackets_outstanding.value %}))){%- endif %}

(define-fun gate-100k ((dir Dir)) Int
	(let ((dir-size (size dir)))
	(ite (<= dir-size 100000) dir-size 0)))

(define-fun part-1 () Int
	(+
		{%- for i in range(dir.value) %}
		(gate-100k dir-{{i}})
		{%- endfor %}))

; Part 2

(define-fun used () Int (size dir-0))
(define-fun total-space   () Int 70000000)
(define-fun space-needed  () Int 30000000)
(define-fun space-free    () Int (- total-space used))
(define-fun space-to-free () Int (- space-needed space-free))

(define-fun min ((x Int) (y Int)) Int (ite (< x y) x y))

; Clamp a value to be at least space-to-free. If it is below,
; return total-space
(define-fun clamp-to-needed ((x Int)) Int
	(ite (< x space-to-free) total-space x))

; Returns the smallest of x and y that is above 30 space-to-free
; If neither are, returns total-space
(define-fun smallest-to-free ((x Int) (y Int)) Int
	(min (clamp-to-needed x) (clamp-to-needed y)))

(define-fun part-2 () Int
	{%- for i in range(dir.value) %}
	(smallest-to-free (size dir-{{i}})
	{%- endfor %} 0{{")" * dir.value}})

(check-sat)
(get-value (part-1 part-2))

