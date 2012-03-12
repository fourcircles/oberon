grammar Oberon;


options {
  language = Java;
  output = AST;
//  backtrack = true;
}
@members {
int errors_cnt = 0;
public void reportError(RecognitionException e)
{
  errors_cnt++;
  super.reportError(e);
//  TODO e.toString();
}
public int getErrorCount() {
  return errors_cnt;
}
}


obmodule: {errors_cnt = 0;}  'MODULE' IDENT SEMICOLON  (importList)? declarationSequence
    ('BEGIN' statementSequence)? 'END' IDENT DOT ;

identdef : IDENT (STAR)? ;
qualident : (IDENT '.')? IDENT;
constantDeclaration  :  identdef EQUAL constExpression;
constExpression  :  expression;
typeDeclaration  :  identdef EQUAL type;
type  :  qualident | arrayType | procedureType;
arrayType  :  'ARRAY' length 'OF' type;
length  :  constExpression;
baseType  :  qualident;
identList  :  identdef (COMMA identdef)*;
procedureType : 'PROCEDURE' (formalParameters)?;
variableDeclaration  :  identList COLON type;

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

procedureDeclaration  :  procedureHeading SEMICOLON procedureBody IDENT;
procedureHeading  :  'PROCEDURE' identdef (formalParameters)?;
procedureBody  :  declarationSequence ('BEGIN' statementSequence)? 'END';
forwardDeclaration  :  'PROCEDURE' '^' IDENT (STAR)? (formalParameters)?;
declarationSequence  :  ('CONST' (constantDeclaration SEMICOLON)* |
    'TYPE' (typeDeclaration SEMICOLON)* | 'VAR' (variableDeclaration SEMICOLON)*)*
    (procedureDeclaration SEMICOLON | forwardDeclaration SEMICOLON)*;
formalParameters  :  LPAREN (fPSection (SEMICOLON fPSection)*)? RPAREN (COLON qualident)?;
fPSection  :  ('VAR')? IDENT (COMMA IDENT)* COLON formalType;
formalType  :  ('ARRAY' 'OF')* (qualident | procedureType);
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

STRING : '\"' 'a' '\"' ;
CharConstant : '\'' 'a' '\'';
IDENT : LETTER ( LETTER | DIGIT) * ;
NUMBER : DIGIT ( DIGIT ) +;
fragment DIGIT : '0' .. '9' ;
fragment LETTER : 'A' .. 'Z' | 'a' .. 'z' | '_' ;
WHITESPACE: (' ' | '\t' | '\n' | '\r' | '\u000C')+ {$channel=HIDDEN;};