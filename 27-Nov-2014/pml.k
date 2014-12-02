/*
@author: Raman B.
date: 27.11.2014
*/

module PML

	imports SUBSTITUTION
	

	syntax Proc ::= Val
			 | Proc "||" Proc 	[left]
			 | "("Proc")"		[bracket]
 	     	 | "acq" "(" Id ")" ";" Proc
 	      	 | "rel" "(" Id ")" ";" Proc
	     	 | "ok"
		 	 | "new_reg" Id ";" Proc
		 	 | "new" Id ";" Proc    
		 	 | Act ";" Proc
	
	syntax Exp ::=  Int
		| Id 
		> Exp "+" Exp [left]
		| Exp "-" Exp [left]


	syntax Act ::= "R" "(" Id "," Id ")"
			 	| "W" "(" Id "," Exp ")"
			 	| "mfence"

			 
	syntax Val ::= Int		 


	syntax Int ::= "try" "(" Id "," List "," Map ")" [function]

	syntax KResult ::= Val
	syntax Lock ::= Id | Int
	
	rule try(X, . List , ( Ram:Map(X |-> V:Int))) => V
	rule try(X, (ListItem(W(X,V)) Fifo:List) , Ram:Map) => V
	rule try(X, (ListItem(W(Y,V)) Fifo:List) , Ram:Map) => try(X, Fifo, Ram) when X =/=K Y


	rule <ths>
			<th>
				<k>R(X,Reg:Id);P => P </k>
				<reg> ... (Reg |-> try(X, Fifo:List, Ram:Map)) </reg>
				<fifo> Fifo </fifo>	
			</th> 
		</ths>
		<ram> Ram </ram>



    
	rule X:Int + Y:Int => X +Int Y
	rule X:Int - Y:Int => X -Int Y
	

	rule <k>mfence; P => P </k>
		 <fifo> . </fifo> [structural]

    

	rule <k>new_reg Reg ; P => P</k> 
		 <reg> ... ( . => Reg |-> 0)</reg> 		[transition]
		 
	rule <ths>
			<th>
				<k>new X ; P:Proc => P</k> ...
			</th> ...
		</ths>
	 	<ram> ... ( . => X |-> 0)</ram> 
	 	<lock> ... ( . => X |-> 0) </lock>	 	[transition]

	rule <k>R ( X:Id, Reg) ; P => P</k>
		 <reg> Reg |-> ( K => V)</reg>
		 <ram> ... X:Id |-> V:Val</ram> 		[transition]

	rule 
		<ths>
			<th>
				<fifo> ... (ListItem(W(X,V)) => .) </fifo>
				... 
			</th>
		</ths>
		<ram> ... (X |-> (_ => V:Int)) </ram>	[transition]
	


	rule <k> W ( X:Id , V:Int ) ; P:Proc => P </k>
		 <fifo>(. => ListItem(W(X,V))) ... </fifo>
		 
	rule <k> W(X, Reg:Id); P => P </k>
		 <fifo> (. => ListItem(W(X,V:Int))) ... </fifo> 
		 <reg> ... Reg |-> V </reg>	  [structural]

	rule <ths>
			<th>
				<k> acq(X:Id) ; P:Proc </k> ...
			</th>
			...
		</ths>
		<lock> ... X |-> (0 => 1) ... </lock> 		[transition]

	rule <ths>
			<th>
				<k>rel(X:Id) ; P:Proc</k>...
		 	</th>
		 	...
		 </ths>
		 <lock> ... X |-> (1 => 0) ... </lock> 		[transition]



	rule <th>
			<k>P:Proc || Q:Proc => P </k> ...
		</th>
		(. => <th>
				<k>Q</k>
				<reg>.</reg>
				<fifo>.</fifo>
			</th>)

	configuration
		<proc>
			<ths>
				<th multiplicity="*">
					<k>$PGM:Proc</k>
					<reg>.Map</reg>
					<fifo>.List</fifo>
				</th>
			</ths>
			<ram>.Map</ram>
			<lock>.Map</lock>
		</proc>


endmodule
