new x; new y; (
	(W(x, 1); ok) ||
	(W(y, 1); ok) ||
	(new_reg r; new_reg s; R(x,r);R(y,s);ok) ||
	(new_reg t; new_reg u; R(y,t);R(x,u);ok)
)