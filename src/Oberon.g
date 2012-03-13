grammar Oberon;

options {
  language = Java;
  output = AST;
}
@headers {

}
@members {

int errorCnt;
protected void mismatch(IntStream input, int ttype, BitSet follow) 
	throws RecognitionException {
	throw new MismatchedTokenException(ttype, input); 
}
public Object recoverFromMismatchedSet(IntStream input, 
	RecognitionException e, BitSet follow) throws RecognitionException{
	throw e;
}
protected Object recoverFromMismatchedToken (IntStream input, int ttype, BitSet follow) 
	throws RecognitionException {
	throw new MismatchedTokenException(ttype, input);
	
}

public void reportMissingVar(String id) {
errorCnt++;
reportError(new MissingVariableException(id));
}
public void reportRepeatDeclaration(String id) {
errorCnt++;
reportError(new AmbiguousId(id));

}

SimpleScope currentScope;
}


@rulecatch {
catch (RecognitionException e) {
//	reportError(e);
//	recover(input, e);
	throw e;
}
}




obmodule: {currentScope = SimpleScope.globalScope; errorCnt = 0;}  'MODULE' IDENT SEMICOLON  (importList)? declarationSequence
    ('BEGIN' statementSequence)? 'END' IDENT DOT ;

identdef : id=IDENT (STAR)? {
if (currentScope.containsInside($id.text)) {
  reportRepeatDeclaration($id.text);
} else {
currentScope.addVar(new SimpleVar($id.text));
}
};
qualident 
  : (IDENT '.')? id=IDENT 
  {
  if (currentScope.contains($id.text)) {
    //OK
  } else {reportMissingVar($id.text);}
  }
  ;
constantDeclaration  :  identdef EQUAL constExpression;
constExpression  :  expression;
typeDeclaration  :  identdef EQUAL type;

//qualident only for TYPE a = b and basic types
type  :  qualident | arrayType | procedureType;
arrayType  :  'ARRAY' length 'OF' type;
length  :  constExpression;
baseType  :  qualident;
identList  :  identdef (COMMA identdef)*;
procedureType : 'PROCEDURE' (formalParameters)?;
variableDeclaration  : {} identList COLON type;

designator  :  qualident (LBR expression RBR)?;
expList  :  expression (COMMA expression)*;
expression  :  simpleExpression (relation simpleExpression)?;
relation  :  EQUAL | NEQUAL | LESS | LEQ | GREATER | GEQ;
simpleExpression  :  (PLUS|MINUS)? term (addOperator term)*;
addOperator  :  PLUS | MINUS | 'OR' ;
term  :  factor (mulOperator factor)*;
mulOperator  :  STAR | SLASH | 'DIV' | 'MOD' | AMP ;
factor  :  NUMBER | CharConstant | STRING | 'NIL' |
        designator (actualParameters)? | LPAREN expression RPAREN | TILDE factor;
element  :  expression (DOTDOT expression)?;
actualParameters  :  LPAREN (expList)? RPAREN ;

statement  :  (designator ASSIGN)=> assignment | procedureCall |
        forStatement |
        ifStatement | caseStatement | whileStatement | repeatStatement |
        loopStatement | 'EXIT' | 'RETURN' (expression)?;
assignment  :  designator ASSIGN expression;
procedureCall  :  designator (actualParameters)?;
statementSequence  :  statement (SEMICOLON statement)*;
ifStatement  :  'IF' expression 'THEN' statementSequence
        ('ELSIF' expression 'THEN' statementSequence)*
        ('ELSE' statementSequence)? 'END';
caseStatement  :  'CASE' expression 'OF' obcase (STROKE obcase)*
        ('ELSE' statementSequence)? 'END';
obcase  :  (caseLabelList COLON statementSequence)?;
caseLabelList  :  caseLabels (COMMA caseLabels)*;
caseLabels  :  constExpression (DOTDOT constExpression)?;
whileStatement  :  'WHILE' expression 'DO' statementSequence 'END';
repeatStatement  :  'REPEAT' statementSequence 'UNTIL' expression;
loopStatement  :  'LOOP' statementSequence 'END';
forStatement : 'FOR' IDENT ASSIGN expression 'TO' expression ('BY' expression)?
                'DO' statementSequence 'END' ;

procedureDeclaration  
  :
{
SimpleScope prevScope = currentScope;
currentScope = new SimpleScope();
currentScope.setParentScope(prevScope);
}
  procedureHeading SEMICOLON procedureBody IDENT
{
currentScope = currentScope.getParentScope();
};
procedureHeading  :  'PROCEDURE' identdef (formalParameters)?;
procedureBody  :  declarationSequence ('BEGIN' statementSequence)? 'END';
forwardDeclaration  :  'PROCEDURE' '^' IDENT (STAR)? (formalParameters)?;
declarationSequence  :  ('CONST' (constantDeclaration SEMICOLON)* |
    'TYPE' (typeDeclaration SEMICOLON)* | 'VAR' (variableDeclaration SEMICOLON)*)*
    (procedureDeclaration SEMICOLON | forwardDeclaration SEMICOLON)*;
formalParameters  :  LPAREN (fPSection (SEMICOLON fPSection)*)? RPAREN (COLON qualident)?;
fPSection  :  ('VAR')? IDENT (COMMA IDENT)* COLON formalType;
formalType  :  ('ARRAY' 'OF')? (qualident | procedureType);
importList  :  'IMPORT' obimport (COMMA obimport)* SEMICOLON ;
obimport  :  IDENT;

STAR : '*' ;
DOT : '.' ;
EQUAL : '=' ;
COMMA : ',' ;
SEMICOLON : ';' ;
LPAREN : '(' ;
RPAREN : ')' ;
COLON : ':' ;
DOTDOT : '..' ;
LBR : '[' ;
RBR : ']' ;
LBRACE : '{' ;
RBRACE : '}' ;
NEQUAL : '#' ;
LESS : '<' ;
LEQ : '<=' ;
GREATER : '>' ;
GEQ : '>=' ;
PLUS : '+' ;
MINUS : '-' ;
SLASH : '/' ;
AMP : '&' ;
TILDE : '~' ;
STROKE : '|' ;
ASSIGN : ':=' ;

STRING : '\"' .+ '\"' ;
CharConstant : '\'' . '\'' | DIGIT HEX_DIGIT* 'X';
IDENT : LETTER ( LETTER | DIGIT) * ;
//NUMBER : INTEGER | REAL;
NUMBER : ( DIGIT ) + REAL_PART? | DIGIT (HEX_DIGIT) + 'H';

//INTEGER : DIGIT ( DIGIT ) + | DIGIT (HEX_DIGIT) + 'H';
//REAL : DIGIT ( DIGIT ) + '.' DIGIT * (SCALE)?;
REAL_PART: '.' DIGIT * (SCALE)?;
SCALE : ('E' | 'D') ('+' | '-')? DIGIT (DIGIT)+;
fragment HEX_DIGIT : DIGIT | 'A'..'F';
fragment DIGIT : '0' .. '9' ;
fragment LETTER : 'A' .. 'Z' | 'a' .. 'z';
WHITESPACE: (' ' | '\t' | '\n' | '\r' | '\u000C')+ {$channel=HIDDEN;};