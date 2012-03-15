grammar Oberon;

options {
  language = Java;
  output = AST;
}
@header {
package generated;
import java.util.ArrayList;
import exceptions.*;
import core.*;
}
@lexer::header {
package generated;
}
@members {

int errorCnt;
ArrayList<RecognitionException> errors;

//protected void mismatch(IntStream input, int ttype, BitSet follow) 
//	throws RecognitionException {
//	throw new MismatchedTokenException(ttype, input); 
//}
//public Object recoverFromMismatchedSet(IntStream input, 
//	RecognitionException e, BitSet follow) throws RecognitionException{
//	throw e;
//}
//protected Object recoverFromMismatchedToken (IntStream input, int ttype, BitSet follow) 
//	throws RecognitionException {
//	throw new MismatchedTokenException(ttype, input);
//	
//}
public int getErrorsNumber() {
return errors.size();
}
public ArrayList<RecognitionException> getErrors() {
return errors;
}

public void reportError(RecognitionException e) {

errors.add(new RRException(e, getErrorMessage(e, tokenNames)));
//System.err.println(e.getMessage());
//System.out.println(getErrorMessage(e, tokenNames));
}

public void reportMissingVar(String id, int line, int pos) {
MissingVariableException e = new MissingVariableException(id, line, pos);
errors.add(e);
//reportError(new MissingVariableException(id, line, pos));
}
public void reportRepeatDeclaration(String id, int line, int pos) {
AmbiguousIdException e = new AmbiguousIdException(id, line, pos);
errors.add(e);
//reportError(e);
}

SimpleScope currentScope;

public void checkScope(Token id, SimpleScope currentScope) {
if (currentScope.containsInside(id.getText())) {
  reportRepeatDeclaration(id.getText(), id.getLine(), id.getCharPositionInLine());
} else {
	currentScope.addVar(new SimpleVar(id.getText()));
}

}
}






obmodule
@init {
currentScope = SimpleScope.getNewGlobalScope();
errorCnt = 0;
errors = new ArrayList<RecognitionException>();
}
	: 'MODULE' IDENT SEMICOLON  (importList)? declarationSequence
    ('BEGIN' statementSequence)? 'END' IDENT DOT
    ;

identdef
@after {
checkScope($id, currentScope);
} 
	: id=IDENT (STAR)?;

qualident
@after { 
  if (currentScope.contains($id.text)) {
    //OK
  } else reportMissingVar($id.text, $id.line, $id.pos);
}
  : (IDENT '.')? id=IDENT 
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
variableDeclaration  : identList COLON type;

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
  procedureHeading SEMICOLON procedureBody IDENT
{
currentScope = currentScope.getParentScope();
};
procedureHeading  :  'PROCEDURE' identdef (formalParameters)?;
procedureBody  :  declarationSequence ('BEGIN' statementSequence)? 'END';

//TODO forward declaration
forwardDeclaration  :  'PROCEDURE' '^' IDENT (STAR)? (formalParameters)?;

declarationSequence
	:  ('CONST' (constantDeclaration SEMICOLON)* |
    'TYPE' (typeDeclaration SEMICOLON)* | 'VAR' (variableDeclaration SEMICOLON)*)*
    (procedureDeclaration SEMICOLON | forwardDeclaration SEMICOLON)*;
    
formalParameters
@init {
SimpleScope prevScope = currentScope;
currentScope = new SimpleScope();
currentScope.setParentScope(prevScope);
}  
  	:  LPAREN (fPSection (SEMICOLON fPSection)*)? RPAREN (COLON qualident)?;
fPSection  :  ('VAR')? id1=IDENT {checkScope($id1, currentScope);} (COMMA id2=IDENT{checkScope($id2, currentScope);})* COLON formalType;

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