grammar Base;
options {
  language = Java;
  output = AST;
}
tokens {
	ARGLIST;
	CALL;
	ARITH;
	STAT;
	VAR_DECL;
	PARAMS;
	PROGRAM;
	ASSIGN;
}

program : 'PROGRAM' (formalParameters)? ';' body '.' EOF 
			-> ^(PROGRAM formalParameters body);
formalParameters  :  '(' (fP (';' fP)*)? ')' -> ^(PARAMS fP+);
fP  :  ('VAR')? IDENT ':' type -> ^(VAR_DECL IDENT type);
type  :  'INTEGER' | 'REAL';
body  :  'BEGIN' (statementSequence)? 'END' -> statementSequence;
statementSequence  :  statement (';' statement)* -> ^(STAT statement+);
statement 
	: assignment -> assignment 
	| procedureCall -> procedureCall;
assignment  :  IDENT ':=' expression -> ^(ASSIGN IDENT expression);
procedureCall  :  IDENT (actualParameters)? -> ^(CALL IDENT actualParameters);
actualParameters  :  '(' (expList)? ')' -> expList?;
expList  :  expression (',' expression)* -> ^(ARGLIST expression+);
expression  :  factor (('+'^ | '-'^) factor)*;
factor  :  NUMBER | '(' expression ')' -> expression | IDENT;
IDENT : LETTER ( LETTER | DIGIT) * ;
NUMBER : DIGIT+;
fragment LETTER : 'A' .. 'Z' | 'a' .. 'z' ;
fragment DIGIT : '0' .. '9';
WHITESPACE: (' ' | '\t' | '\n' | '\r' | '\u000C')+ {$channel=HIDDEN;}; 
