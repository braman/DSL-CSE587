/*
@author: Raman B.
date: 13.11.2014
*/

module PML

	imports SUBSTITUTION

	syntax Proc ::= Val
			 | "R" "(" Id "," Id ")" ";" Proc
			 | "W" "(" Id "," Exp ")" ";" Proc
			 | Proc "||" Proc 	[left]
			 | "("Proc")"		[bracket]
	 	     | "acq" "(" Id ")" ";" Proc
	 	     | "rel" "(" Id ")" ";" Proc
		     | "ok"
		 	 | "new_reg" Id ";" Proc
		 	 | "new" Id ";" Proc    
	
    syntax Exp ::=  Int
    		| Id 
    		| Exp "+" Exp
		    | Exp "-" Exp
			 
	syntax Val ::= Int		 

    syntax KResult ::= Val
	//syntax Lock ::= R | Int | W
	
	rule X:Int + Y:Int => X +Int Y
	rule X:Int - Y:Int => X -Int Y
	

	rule <k>new_reg Reg ; P => P</k> 
		 <reg> ... ( . => Reg |-> 0)</reg> [transition]
		 
	rule <k>new X ; P:Proc => P</k>
		 <ram> ... ( . => X |-> 0)</ram> 
		 <lock> ... ( . => X |-> 0) </lock> [transition]

	rule <k>R(X:Id, Reg);P => P</k>
		 <reg> Reg |-> ( K => V)</reg>
		 <ram> ... X:Id |-> V:Val</ram> [transition]

	rule <k> W ( X:Id , V:Id ) ; P:Proc => P </k>
		 <reg> ... ( X |-> ( K => V) ) ... </reg> [transition]

	rule <ths>
			<th>
				<k> acq(X:Id) ; P:Proc </k> ...
			</th>
			...
		</ths>
		<lock> ... X |-> (0 => 1) ... </lock> [transition]

	rule <ths>
			<th>
				<k>rel(X:Id) ; P:Proc</k>...
		 	</th>
		 	...
		 </ths>
		 <lock> ... X |-> (1 => 0) ... </lock> [transition]



	rule <th>
			<k>P:Proc || Q:Proc => P </k> ...
		</th>
		(. => <th>
				<k>Q</k>
				<reg>.</reg>
			</th>)
/*
	
	configuration
		<sub>
			<k>$PGM:Proc</k>
			<reg>.Map</reg>
			<ram>.Map</ram>
			<blocks>.Map</blocks>
			<lock>.Map</lock>
		</sub>
*/	

	configuration
		<proc>
			<ths>
				<th multiplicity="*">
					<k>$PGM:Proc</k>
					<reg>.Map</reg>
				</th>
			</ths>
			<ram>.Map</ram>
			<lock>.Map</lock>
		</proc>


endmodule
