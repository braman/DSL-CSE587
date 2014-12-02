new x; new y; (
	(new_reg r; W(x, 1); mfence; R(y,r);ok) ||
	(new_reg s; W(y, 1); mfence; R(x,s);ok)
)